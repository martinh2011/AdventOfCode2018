Code.load_file("aoc01.exs", __DIR__)

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule SumTest do
  use ExUnit.Case

  test "sum ints in file" do
    [1,1,1] |> Enum.map(&Integer.to_string/1) |> Enum.map(fn s -> s <> "\n" end) |> Enum.into(File.stream!("testinput.txt"))
    assert Aoc01.sum_file("testinput.txt") == 3
  end
  test "sum ints in file with negatives" do
    [1,1,-2] |> Enum.map(&Integer.to_string/1) |> Enum.map(fn s -> s <> "\n" end) |> Enum.into(File.stream!("testinput.txt"))
    assert Aoc01.sum_file("testinput.txt") == 0
  end
  test "sum ints in file with only negatives" do
    [-1,-2,-3] |> Enum.map(&Integer.to_string/1) |> Enum.map(fn s -> s <> "\n" end) |> Enum.into(File.stream!("testinput.txt"))
    assert Aoc01.sum_file("testinput.txt") == -6
  end
end
