defmodule MixUnderTest do
  use ExUnit.Case

  defmacro mix_under(args, out, [do: code]) do
    quote do
      cwd = File.cwd!
      try do
        File.cd!(Path.expand("../example", __DIR__))
        unquote(out) = System.cmd("mix", ["under"] ++ unquote(args))
        unquote(code)
      after
        File.cd!(cwd)
      end
    end
  end

  def assert_mix_under_fails(args) do
    mix_under args, {_, status} do
      assert status > 0, "Expected to fail"
    end
  end

  def assert_mix_under_contains(args, strings) do
    mix_under args, {out, _} do
      strings |> Enum.map(fn expected ->
        assert String.contains?(out, expected),
        "Expected output of `mix under #{Enum.join(args, " ")}` to contain #{expected}, but was: \n#{out}"
      end)
    end
  end

  test "executes mix on the specified app" do
    assert_mix_under_contains ["heaven", "test"], ["Heaven"]
  end

  test "execute mix on the wildcard matching apps" do
    assert_mix_under_contains ["{heaven,hell}", "test"], ["Heaven", "Hell"]
  end

  test "execute mix on the wildcard* matching apps" do
    assert_mix_under_contains ["*h*", "test"], ["Heaven", "Hell", "Earth"]
  end

  test "stops if a task fails under an app" do
    assert_mix_under_fails ["hell", "angel"]
  end

end
