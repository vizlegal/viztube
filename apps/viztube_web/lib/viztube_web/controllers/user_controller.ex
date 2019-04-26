defmodule ViztubeWeb.UserController do
  use ViztubeWeb, :controller

  alias Viztube.Accounts

  def index(conn, %{"page" => page}) do
    render_index(conn, page)
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    Accounts.create_user(%{email: email, admin: false, tags: "Untagged"})
    |> put_flash_message(conn)
    |> render_index(1)
  end

  defp put_flash_message({:ok, user}, conn) do
    conn
    |> put_flash(:info, "user #{user.email} has been created")
  end

  defp put_flash_message({:error, _}, conn) do
    conn
    |> put_flash(:error, "Invalid email or duplicate user")
  end


  def delete_confirmation(conn, %{"id" => id}) do
    conn
    |> render("confirm.html", id: id)
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    case Accounts.delete_user(user) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "user removed")
        |> render_index(1)
    end
  end

  defp render_index(conn, page) do
    conn
    |> render("index.html", users: Accounts.list_users(Guardian.Plug.current_resource(conn).id, page))
  end

end
