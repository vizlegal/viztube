defmodule ViztubeWeb.SessionController do
  use ViztubeWeb, :controller

  alias ViztubeWeb.TokenAuthentication

  def new(conn, _params) do
    response(conn)
  end

  def create(conn, %{"session" => %{"email" => email}}) do
    TokenAuthentication.provide_token(email)
    |> check_login(conn)
    |> response
  end

  def show(conn, %{"token" => token}) do
    TokenAuthentication.verify_token_value(token)
    |> authenticate_user(conn)
  end

  def delete(conn, _) do
    conn = ViztubeWeb.Guardian.Plug.sign_out(conn)
    conn
    |> Plug.Conn.assign(:current_user, Guardian.Plug.current_resource(conn))
    |> response
  end

  defp authenticate_user({:ok, user}, conn) do
    conn = ViztubeWeb.Guardian.Plug.sign_in(conn, user)
    conn
    |> Plug.Conn.assign(:current_user, Guardian.Plug.current_resource(conn))
    |> render(ViztubeWeb.PageView, "index.html")
  end

  defp authenticate_user({:error, _reason}, conn) do
    conn
    |> put_flash(:error, "Login token invalid")
    |> response
  end

  defp check_login({:ok, _email}, conn) do
    conn
    |> put_flash(:info, "we have sent you a link for signin")
  end

  defp check_login({:error, _reason}, conn) do
    conn
    |> put_flash(:error, "user does not exists")
  end

  defp response(conn) do
    render conn,"new.html"
  end

end
