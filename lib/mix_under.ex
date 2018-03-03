defmodule Mix.Tasks.Under do
  @moduledoc File.read!(Path.expand("../README.md", __DIR__))

  use Mix.Task

  def run([wildcard | args]) do
    wildcard = cond do
      String.contains?(wildcard, "/") -> wildcard
      :else -> "apps/#{wildcard}"
    end
    Path.wildcard(wildcard) |> Enum.map(&under(&1, args))
  end

  def under(directory, args) do
    cwd = File.cwd!
    try do
      File.cd!(directory)
      {out, status} = System.cmd("mix", args)
      IO.puts out
      unless status == 0 do
        raise Mix.Error, "[under #{directory}] `mix #{Enum.join(args, " ")}` failed with status #{status}"
      end
    after
      File.cd!(cwd)
    end
  end
end
