defmodule Day3 do
  def occupied_squares(file_stream) do
    {claimed_multiply, _, claim_state} =
      file_stream
      |> Stream.map(fn line ->
        regex = ~r/#(?<claimid>\d+)\s+@\s+(?<x>\d+),(?<y>\d+):\s(?<w>\d+)x(?<h>\d+)/
        captures = Regex.named_captures(regex, line)

        %{
          c: String.to_integer(captures["claimid"]),
          x: String.to_integer(captures["x"]),
          y: String.to_integer(captures["y"]),
          w: String.to_integer(captures["w"]),
          h: String.to_integer(captures["h"])
        }
      end)
      |> Stream.flat_map(fn %{c: c, x: x, y: y, w: w, h: h} ->
        0..(w - 1) |> Enum.map(fn v -> %{c: c, x: x + v, y: y, h: h} end)
      end)
      |> Stream.flat_map(fn %{c: c,x: x, y: y, h: h} ->
        0..(h - 1) |> Enum.map(fn v -> {c, x, y + v} end)
      end)
      |> Enum.reduce({0, %{}, %{}}, fn {claim, x, y}, {sum_squares, board, claim_states} ->
        case board |> Map.get({x, y}, 0) do
          0         -> {sum_squares, board |> Map.put({x, y}, claim), claim_states |> Map.put_new(claim, :intact)}
          :many     -> {sum_squares, board, claim_states}
          old_claim -> {sum_squares+1, board |> Map.put({x, y}, :many), claim_states |> Map.put(claim, :not_intact) |> Map.put(old_claim, :not_intact)}
        end
      end)

      {claimed_multiply, claim_state |> Enum.filter(fn {_,v} -> v==:intact end) |> Enum.map(fn {claim, _} -> claim end)}
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day3Test do
      use ExUnit.Case

      import Day3

      test "test_clain" do
        assert occupied_squares([
                 "#1 @ 1,3: 4x4\n",
                 "#2 @ 3,1: 4x4\n",
                 "#3 @ 5,5: 2x2\n"
               ]) == {4, [3]}
      end
    end

  [input_file] ->
    input_file
    |> File.stream!([], :line)
    |> Day3.occupied_squares()
    |> IO.inspect()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end
