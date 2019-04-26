defmodule ViztubeWeb.QueryChannel do
  use ViztubeWeb, :channel
  require Logger

  @minute 60
  @hour   @minute*60
  @day    @hour*24
  @week   @day*7
  @divisor [@week, @day, @hour, @minute, 1]


  def join("query:" <> user_id, _payload, socket) do
    {:ok, "Joined query:#{user_id}", socket}
  end


  def handle_in("update", query, socket) do
    q = Viztube.Queries.get_search!(query["id"])

    last_checked = sec_to_str(Timex.diff(NaiveDateTime.utc_now, q.last_checked, :seconds))

    payload = %{
      "id" => q.id,
      "last_checked" => last_checked,
      "videos" => q.videos || 0
    }

    broadcast socket, "update", payload
    {:noreply, socket}
  end

  defp sec_to_str(sec) do
    {_, [s, m, h, d, w]} = Enum.reduce(@divisor, {sec,[]}, fn divisor,{n,acc} ->
      {rem(n,divisor), [div(n,divisor) | acc]}
    end)

    ["#{w} wk", "#{d} d", "#{h} hr", "#{m} min", "#{s} secs"]
    |> Enum.reject(fn str -> String.starts_with?(str, "0") end)
    |> Enum.join(", ")
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (queries:lobby).
  def handle_out(event, payload, socket) do
    # broadcast socket, "shout", payload
    push socket, event, payload
    {:noreply, socket}
  end

end
