defmodule HeavenTest do
  use ExUnit.Case
  doctest Heaven

  test "greets the world" do
    IO.inspect(Heaven)
    assert Heaven.hello() == :world
  end
end
