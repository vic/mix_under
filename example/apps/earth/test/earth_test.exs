defmodule EarthTest do
  use ExUnit.Case
  doctest Earth

  test "greets the world" do
    IO.inspect(Earth)
    assert Earth.hello() == :world
  end
end
