defmodule AoC02 do
  def double_triple_count({twos, threes}, boxid) do
    charCounts =
      boxid
      |> Enum.reduce(%{}, fn v, acc ->
        Map.update(acc, v, 1, &(&1 + 1))
      end)

    {twos + Enum.find_value(charCounts, 0, fn {_, v} -> if v == 2, do: 1 end),
     threes + Enum.find_value(charCounts, 0, fn {_, v} -> if v == 3, do: 1 end)}
  end

  def checksum(box_ids) do
    {twos, threes} =
      box_ids
      |> Enum.reduce({0, 0}, fn v, {twos, threes} = sum ->
        double_triple_count(sum, v)
      end)
    twos * threes
  end

  def distance(a, b) do
    Enum.count(a) - Enum.count(common_chars(a, b))
  end

  def common_chars(a, b) do
    a
    |> Enum.zip(b)
    |> Enum.filter(fn {x, y} -> x == y end)
    |> Enum.map(fn {x, y} -> x end)
  end

  def find_distance_one(list, value) do
    list
    |> Enum.filter(fn w -> distance(value, w) == 1 end)
  end

  def common_letters_id_distance_one(box_ids) do
    box_ids
    |> Enum.reduce_while(nil, fn v, acc ->
      case find_distance_one(box_ids, v) do
        [] -> {:cont, nil}
        [x | _] -> {:halt, common_chars(v, x)}
      end
    end)
  end

  def common_letters(filepath) do
    filepath
    |> File.stream!
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_charlist/1)
    |> common_letters_id_distance_one
  end
end
