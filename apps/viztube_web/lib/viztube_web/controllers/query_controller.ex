defmodule ViztubeWeb.QueryController do
  @moduledoc """
  Query Controller
  """
  use ViztubeWeb, :controller

  alias Viztube.Queries

  @doc """
  render index page with list of Saved searches

  Returns `render_user_queries`.
  """
  def index(conn, %{"page" => page}) do
    conn
    |> render_user_queries(page)
  end

  @doc """
  render list of videos from a saved search

  Returns `respond(query, conn)`.
  """
  def show(conn, %{"id" => id, "page" => page}) do
    tags = conn.assigns.current_user.tags
    |> Enum.reduce([], fn(x, acc) -> [x.name | acc] end)
    |> check_default_tag

    Queries.get_query(conn.assigns.current_user.id, id)
    |> render_saved_search_results(conn, tags, page)
  end

  @doc """
  render popup window with delete confirmation

  Returns `render confirm`.
  """
  def delete_confirmation(conn, %{"id" => id}) do
    conn
    |> render("confirm.html", id: id)
  end

  @doc """
  Delete a saved search

  Returns `delete search`.
  """
  def delete(conn, %{"id" => id}) do
    Queries.get_query(conn.assigns.current_user.id, id)
    |> delete_search(conn)
  end

  defp delete_search([search], conn) do
    Queries.delete_search(search)
    conn
    |> put_flash(:info, "query removed")
    |> render_user_queries(1)
  end

  defp delete_search([], conn) do
    conn
    |> put_flash(:error, "you don't have permission")
    |> render_user_queries(1)
  end

  defp render_saved_search_results([], conn, _tags, _page) do
    conn
    |> put_flash(:error, "not found")
    |> render_user_queries(1)
  end

  defp render_saved_search_results([q], conn, tags, page) do
    videos = Queries.list_results(q.id, page)
    conn
    |> assign(:results, videos)
    |> assign(:user_tags, tags)
    |> assign(:search_id, q.id)
    |> render("show.html")
  end

  defp render_user_queries(conn, page) do
    saved_searches = Queries.list_searches(conn.assigns.current_user.id, page)
    conn
    |> render("index.html", saved_searches: saved_searches)
  end

  defp check_default_tag(tags) do
    case !Enum.find(tags, fn(t) -> t == "Untagged" end) do
      false -> tags
      true -> ["Untagged"] ++ tags
    end
  end

end
