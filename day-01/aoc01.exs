defmodule Aoc01 do
  def sum_file(filePath) do
    File.stream!(filePath)
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
