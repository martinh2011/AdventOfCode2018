defmodule AoC01 do
  def get_frequency(filePath) do
    File.stream!(filePath)
    |> file_line_to_integer
    |> Enum.sum()
  end

  defp file_line_to_integer(stream) do
    stream
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_integer/1)
  end

  def get_first_repeated_frequency(filePath) do
    frequencies = MapSet.new([0])
    get_first_repeated_frequency(filePath, {0, frequencies})
  end

  defp get_first_repeated_frequency(filePath, {_current_frequency, _frequencies} = acc) do
    result =
      File.stream!(filePath)
      |> file_line_to_integer
      |> Enum.reduce_while(acc, fn value, {frequency, previous_frequencies} ->
        frequency = frequency + value

        if frequency in previous_frequencies do
          {:halt, frequency}
        else
          {:cont, {frequency, MapSet.put(previous_frequencies, frequency)}}
        end
      end)

    case result do
      {_current_frequency, _frequencies} = acc -> get_first_repeated_frequency(filePath, acc)
      frequency -> frequency
    end
  end
end

AoC01.get_first_repeated_frequency("input.txt") |> IO.inspect
