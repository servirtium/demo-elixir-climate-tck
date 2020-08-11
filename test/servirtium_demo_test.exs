defmodule ServirtiumDemoTest do
  use ExUnit.Case
  doctest ServirtiumDemo

  test "greets the world" do
    assert ServirtiumDemo.hello() == :world
  end
end
