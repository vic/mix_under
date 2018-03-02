defmodule HellTest do
  use ExUnit.Case
  doctest Hell

  test "greets the world" do
    IO.inspect Hell
    assert Hell.hello() == :world
  end
end
