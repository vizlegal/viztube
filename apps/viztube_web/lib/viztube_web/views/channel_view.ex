defmodule ViztubeWeb.ChannelView do
  use ViztubeWeb, :view

  import Scrivener.HTML

  def render("scripts.html", _assigns) do
    ~s{<script>require("js/channels").Channels.run()</script>}
    |> raw
  end

end
