defmodule FlakyTest do
  use ExUnit.Case
  doctest Flaky

  test "the truth" do
    assert 1 + 1 == 2
  end
end
