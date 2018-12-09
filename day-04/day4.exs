defmodule Day4 do
  def minutes_asleep(file_stream) do
    {_, _, asleep_minutes, minutes_guards} =
      file_stream
      |> parse_events
      |> process_events

    guard = most_minutes_asleep(asleep_minutes)
    [{minute, _}] = guards_most_sleepy_minute(minutes_guards, guard)
    {most_sleepy_guard, most_sleepy_minute, _} =
      asleep_minutes
      |> Enum.map(fn {k,_} -> k end)
      |> Enum.reduce({"",-1,0}, fn guard, {most_sleepy_guard, most_sleepy_minute, max_minutes} ->
        [{minute, max_minutes_of_guard}] =
          minutes_guards
          |> guards_most_sleepy_minute(guard)
          |> Enum.map(fn {m,guard_list} ->
            {m, Enum.count(guard_list, fn x -> x==guard end)}
          end)

        if max_minutes_of_guard > max_minutes do
          {guard, minute, max_minutes_of_guard}
        else
          {most_sleepy_guard, most_sleepy_minute, max_minutes}
        end
      end)
    {String.to_integer(guard) * minute, String.to_integer(most_sleepy_guard) * most_sleepy_minute}
  end

  defp parse_events(file_stream) do
    file_stream
    |> Enum.sort()
    |> Enum.map(fn line ->
      regex = ~r/\[(?<time>\d+-\d+-\d+ \d+:\d+)\] (?<msg>.+)/
      captures = Regex.named_captures(regex, line)
      {:ok, timestamp, 0} = DateTime.from_iso8601(captures["time"] <> ":00Z")

      case captures["msg"] do
        "falls asleep" ->
          %{g: 0, t: timestamp, a: :falls_asleep}

        "wakes up" ->
          %{g: 0, t: timestamp, a: :wakes_up}

        guard_begins_msg ->
          %{
            g: String.replace(guard_begins_msg, ~r/Guard #(\d+) begins shift/, "\\1"),
            t: timestamp,
            a: :begins
          }
      end
    end)
  end

  defp process_events(events) do
    events
    |> Enum.reduce({"", -1, %{}, %{}}, fn %{g: guard, t: timestamp, a: action},
                                          {current_guard, start_time, asleep_minutes,
                                           minutes_guards} ->
      current_guard = if action == :begins, do: guard, else: current_guard
      start_time = if action == :falls_asleep, do: timestamp, else: start_time

      asleep_minutes =
        if action == :wakes_up do
          update_guard_sleep_minutes(
            asleep_minutes,
            current_guard,
            start_time,
            timestamp
          )
        else
          asleep_minutes
        end

      minutes_guards =
        if action == :wakes_up do
          update_minutes_of_guard(
            minutes_guards,
            current_guard,
            start_time,
            timestamp
          )
        else
          minutes_guards
        end

      {current_guard, start_time, asleep_minutes, minutes_guards}
    end)
  end

  defp update_guard_sleep_minutes(minutes_guards, guard, start_time, wake_time) do
    Map.update(
      minutes_guards,
      guard,
      DateTime.diff(wake_time, start_time, :seconds) / 60,
      fn x ->
        x + DateTime.diff(wake_time, start_time, :seconds) / 60
      end
    )
  end

  defp update_minutes_of_guard(minutes_guards, guard, sleep_time, wake_time) do
    minutes = Kernel.trunc(DateTime.diff(wake_time, sleep_time, :seconds) / 60)

    {_, new_minutes_guards} =
      sleep_time.minute..(sleep_time.minute + minutes - 1)
      |> Enum.map_reduce(minutes_guards, fn m, acc ->
        {nil, Map.update(acc, m, [guard], fn x -> [guard | x] end)}
      end)

    new_minutes_guards
  end

  defp most_minutes_asleep(asleep_minutes) do
    [{guard, _}] =
      asleep_minutes
      |> Enum.sort(fn {_, v1}, {_, v2} -> v1 >= v2 end)
      |> Enum.take(1)

    guard
  end

  defp guards_most_sleepy_minute(minutes_guards, guard) do
      minutes_guards
      |> Enum.sort(fn {_, v1}, {_, v2} ->
        Enum.count(v1, fn x -> x == guard end) >= Enum.count(v2, fn x -> x == guard end)
      end)
      |> Enum.take(1)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day4Test do
      use ExUnit.Case

      import Day4

      test "test_clain" do
        assert minutes_asleep([
                 "[1518-11-01 00:00] Guard #10 begins shift\n",
                 "[1518-11-01 00:05] falls asleep\n",
                 "[1518-11-01 00:25] wakes up\n",
                 "[1518-11-01 00:30] falls asleep\n",
                 "[1518-11-01 00:55] wakes up\n",
                 "[1518-11-01 23:58] Guard #99 begins shift\n",
                 "[1518-11-02 00:40] falls asleep\n",
                 "[1518-11-02 00:50] wakes up\n",
                 "[1518-11-03 00:05] Guard #10 begins shift\n",
                 "[1518-11-03 00:24] falls asleep\n",
                 "[1518-11-03 00:29] wakes up\n",
                 "[1518-11-04 00:02] Guard #99 begins shift\n",
                 "[1518-11-04 00:36] falls asleep\n",
                 "[1518-11-04 00:46] wakes up\n",
                 "[1518-11-05 00:03] Guard #99 begins shift\n",
                 "[1518-11-05 00:45] falls asleep\n",
                 "[1518-11-05 00:55] wakes up"
               ])
               |> IO.inspect() == {240, 4455}
      end
    end

  [input_file] ->
    input_file
    |> File.stream!([], :line)
    |> Day4.minutes_asleep()
    |> IO.inspect()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end
