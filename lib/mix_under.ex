defmodule Mix.Tasks.Under do
  use Mix.Task

  @shortdoc "Execute a task under an umbrella or external app"
  @moduledoc File.read!(Path.expand("../README.md", __DIR__))
  @help """
  Usage: mix under GLOB TASK

  See `mix help under` for more.
  """

  def run([wildcard, task | args]) do
    wildcard = cond do
      String.contains?(wildcard, "/") -> wildcard
      :else -> "apps/#{wildcard}"
    end
    mix = System.find_executable("mix")
    args = [task] ++ absolute(args)
    Path.wildcard(wildcard) |> Enum.map(&under(&1, mix, args))
    :ok
  end
  def run(_), do: IO.puts(@help)

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
