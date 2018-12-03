defmodule Day3 do
  def occupied_squares(file_stream) do
    {occupied_squares, _} =
      file_stream
      |> Stream.map(fn line ->
        regex = ~r/#(?<claimid>\d+)\s+@\s+(?<x>\d+),(?<y>\d+):\s(?<w>\d+)x(?<h>\d+)/
        captures = Regex.named_captures(regex, line)

        %{
          claimid: String.to_integer(captures["claimid"]),
          x: String.to_integer(captures["x"]),
          y: String.to_integer(captures["y"]),
          w: String.to_integer(captures["w"]),
          h: String.to_integer(captures["h"])
        }
      end)
      |> Stream.flat_map(fn %{claimid: _, x: x, y: y, w: w, h: h} ->
        0..(w - 1) |> Enum.map(fn v -> %{x: x + v, y: y, h: h} end)
      end)
      |> Stream.flat_map(fn %{x: x, y: y, h: h} ->
        0..(h - 1) |> Enum.map(fn v -> {x, y + v} end)
      end)

      |> Enum.reduce({0, %{}}, fn {x, y}, {sum_squares, board} ->
        case Map.get(board, {x, y}, :free) do
          :free -> {sum_squares, Map.put(board, {x, y}, :once)}
          :once -> {sum_squares+1, Map.put(board, {x, y}, :many)}
          _ -> {sum_squares, board}
        end
      end)

    occupied_squares
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day1Test do
      use ExUnit.Case

      import Day3

      test "test_clain" do
        assert occupied_squares([
                 "#1 @ 1,3: 4x4\n",
                 "#2 @ 3,1: 4x4\n",
                 "#3 @ 5,5: 2x2\n"
               ]) == 4
      end
    end

  [input_file] ->
    input_file
    |> File.stream!([], :line)
    |> Day3.occupied_squares()
    |> IO.puts()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end
