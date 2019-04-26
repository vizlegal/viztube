defmodule ViztubeWeb.DatesHelper do

  def readable_date(date) when is_binary(date) do
    stringify_date(date)
  end

  def readable_date(date) do
    stringify_date(NaiveDateTime.to_iso8601(date))
  end

  def readable_duration(duration) do
    tl(Regex.run(~r/PT(\d+H)?(\d+M)?(\d+S)?/, duration))
    |> regularize()
    |> Enum.join(":")
  end

  defp stringify_date(date) do
    [date, time] = String.split(date, "T")
    [time, rest] = String.split(time, ".")

    "#{date} #{time}"
  end

  defp regularize(date) do
    new_date = Enum.map date, fn(d) ->
      case String.length(d) do
        0 -> "00"
        2 -> "0#{Regex.run(~r/\d+/, d)}"
        3 -> "#{Regex.run(~r/\d+/, d)}"
      end
    end
    new_date
  end
end
