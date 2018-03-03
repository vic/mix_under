defmodule Mix.Tasks.Under do
  @moduledoc File.read!(Path.expand("../README.md", __DIR__))
  require Logger

  use Mix.Task

  def run([wildcard | args]) do
    wildcard = cond do
      String.contains?(wildcard, "/") -> wildcard
      :else -> "apps/#{wildcard}"
    end
    mix = System.find_executable("mix")
    args = absolute(args)
    Path.wildcard(wildcard) |> Enum.map(&under(&1, mix, args))
  end

  defp under(directory, mix, args) do
    cwd = File.cwd!
    try do
      File.cd!(directory)
      IO.puts "==> (under #{directory}) mix #{Enum.join(args, " ")}"
      0 = cmd([directory: directory, args: args], mix, args)
      IO.puts ""
    after
      File.cd!(cwd)
    end
  end

  defp absolute(args) do
    Enum.map(args, fn arg ->
      if File.exists?(arg) and Path.type(arg) == :relative do
        Path.expand(arg)
      else
        arg
      end
    end)
  end

  defp cmd(meta, cmd, args) do
    port = Port.open({:spawn_executable, cmd}, [:stderr_to_stdout, :binary, :exit_status, args: args])
    stream_output(meta, port)
  end

  defp stream_output(meta, port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        stream_output(meta, port)
      {^port, {:exit_status, 0}} -> 0
      {^port, {:exit_status, status}} ->
        args = Keyword.get(meta, :args)
        directory = Keyword.get(meta, :directory)
        raise Mix.Error, "(under #{directory}) `mix #{Enum.join(args, " ")}` failed with status #{status}"
    end
  end

end
