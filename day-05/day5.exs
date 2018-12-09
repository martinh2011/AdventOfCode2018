defmodule Day5 do
  def react(polymer) when is_binary(polymer) do
    String.graphemes(polymer)
    |> react
    |> List.to_string()
  end

  def react(polymer) do
    react(polymer, [])
    |> Enum.reverse()
  end

  def react(polymer, result) do
    # IO.inspect({List.to_string(polymer), List.to_string(result)}, label: "react")

    case polymer do
      [a | [b | tail]] ->
        if units_match(a, b) do
          case result do
            [h | t] -> react([h | tail], t)
            [] -> react(tail, [])
          end
        else
          case result do
            [] -> react([b | tail], [a])
            result -> react([b | tail], [a | result])
          end
        end

      [a | tail] ->
        react(tail, [a | result])

      [] ->
        result
    end
  end

  def units_match(a, b) do
    String.upcase(a) == String.upcase(b) && a != b
    # |> IO.inspect(label: "units match " <> a <> ", " <> b <> ": ")
  end

  def react_full(polymer) when is_binary(polymer) do
    String.graphemes(polymer)
    |> react_full
  end

  def react_full(polymer) do
    {min_length, fully_reacted_polymer} =
      polymer
      |> Enum.uniq_by(fn u -> String.upcase(u) end)
      |> Enum.reduce({Enum.count(polymer), []}, fn unit, {l, result} ->
        reduced_polymer =
          polymer
          |> Enum.filter(fn u -> String.upcase(u) != String.upcase(unit) end)
          |> react

        length = Enum.count(reduced_polymer)

        if length < l do
          {length, reduced_polymer}
        else
          {l, result}
        end
      end)

    {min_length, List.to_string(fully_reacted_polymer)}
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day5Test do
      use ExUnit.Case

      import Day5

      test "units_match" do
        assert units_match("a", "a") == false
        assert units_match("a", "A") == true
        assert units_match("A", "a") == true
        assert units_match("A", "A") == false
        assert units_match("a", "b") == false
      end

      test "test" do
        assert react("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
      end

      test "test2" do
        assert react("dabAcCaCBAcCcCaDA") == "dabCBDA"
      end

      test "test react_full" do
        assert react_full("dabAcCaCBAcCcaDA") == {4, "daDA"}
      end
    end

  [input_file] ->
    input_file
    |> File.read!()
    |> Day5.react()
    |> String.length()
    |> IO.puts()

    input_file
    |> File.read!()
    |> Day5.react_full()
    |> IO.inspect(printable_limit: :infinity)

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end
