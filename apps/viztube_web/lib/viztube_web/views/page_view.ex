defmodule ViztubeWeb.PageView do
  use ViztubeWeb, :view

  def render("scripts.html", _assigns) do
    ~s{<script>require("js/page").Calendar.run()</script>}
    |> raw
  end


  def my_datetime_select(form, field, opts \\ []) do
    builder = fn b ->
      ~e"""
      <%= b.(:day, []) %><%= b.(:month, []) %><%= b.(:year, []) %>
      <%= b.(:hour, []) %> : <%= b.(:minute, []) %>
      """
    end

    datetime_select(form, field, [builder: builder] ++ opts)
  end
end
