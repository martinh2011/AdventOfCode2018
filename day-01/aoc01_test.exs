Code.load_file("aoc01.exs", __DIR__)

ExUnit.start()
ExUnit.configure(exclude: [pending: true], trace: true)

defmodule SumTest do
  use ExUnit.Case

  defp create_testinput(list, file) do
    list
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(fn s -> s <> "\n" end)
    |> Enum.into(File.stream!(file))
  end

  @tag pending: false
  test "sum ints in file" do
    [1, 1, 1] |> create_testinput("testinput.txt")

    assert AoC01.get_frequency("testinput.txt") == 3
  end

  @tag pending: false
  test "sum ints in file with negatives" do
    [1, 1, -2] |> create_testinput("testinput.txt")

    assert AoC01.get_frequency("testinput.txt") == 0
  end

  @tag pending: false
  test "sum ints in file with only negatives" do
    [-1, -2, -3] |> create_testinput("testinput.txt")

    assert AoC01.get_frequency("testinput.txt") == -6
  end

  @tag pending: false
  test "get repeated frequency one pass" do
    [1, -1] |> create_testinput("testinput.txt")

    assert AoC01.get_first_repeated_frequency("testinput.txt") == 0
  end

  @tag pending: false
  test "get repeated frequency multiple passes 1" do
    [3, 3, 4, -2, -4] |> create_testinput("testinput.txt")

    assert AoC01.get_first_repeated_frequency("testinput.txt") == 10
  end

  @tag pending: false
  test "get repeated frequency multiple passes 2" do
    [-6, 3, 8, 5, -6] |> create_testinput("testinput.txt")

    assert AoC01.get_first_repeated_frequency("testinput.txt") == 5
  end

  @tag pending: false
  test "get repeated frequency multiple passes 3" do
    [7, 7, -2, -7, -4] |> create_testinput("testinput.txt")

    assert AoC01.get_first_repeated_frequency("testinput.txt") == 14
  end
end
