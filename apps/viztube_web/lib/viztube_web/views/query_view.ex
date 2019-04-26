defmodule ViztubeWeb.QueryView do
  use ViztubeWeb, :view

  import Scrivener.HTML

  @minute 60
  @hour   @minute*60
  @day    @hour*24
  @week   @day*7
  @divisor [@week, @day, @hour, @minute, 1]

  def render("scripts.html", _assigns) do
    ~s{<script>require("js/queries").Queries.run()</script>}
    |> raw
  end

  def time_ago(datetime\\ []) do
    Timex.diff(NaiveDateTime.utc_now, datetime, :seconds)
    |> sec_to_str
  end

  defp sec_to_str(sec) do
    {_, [s, m, h, d, w]} = Enum.reduce(@divisor, {sec,[]}, fn divisor,{n,acc} ->
      {rem(n,divisor), [div(n,divisor) | acc]}
    end)

    ["#{w} wk", "#{d} d", "#{h} hr", "#{m} min", "#{s} secs"]
    |> Enum.reject(fn str -> String.starts_with?(str, "0") end)
    |> Enum.join(", ")
  end
end
