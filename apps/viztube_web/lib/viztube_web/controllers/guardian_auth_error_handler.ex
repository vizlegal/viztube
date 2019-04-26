defmodule ViztubeWeb.GuardianAuthErrorHandler do

  use ViztubeWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    body = Poison.encode!(%{message: to_string(type)})
    render(conn, ViztubeWeb.SessionView, "new.html", layout: {ViztubeWeb.LayoutView, "app.html"})
  end

end
