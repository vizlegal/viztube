defmodule ViztubeWeb.PageController do
  use ViztubeWeb, :controller
  alias Viztube.Queries

  def index(conn, _params) do
    render conn, "index.html"
  end

  # FIXME: render_results needs form_data for pagination. Change this !
  def search(conn, %{"search" => form_data, "button" => "search", "page" => page}) do
    check_query_for_id(form_data["query"])
    |> render_video_or_results(conn, form_data, page)
  end

  # TODO: save search from video id?
  def search(conn, %{"search" => form_data, "button" => "save", "page" => _page}) do
    Queries.create_search(%{
      user_id: conn.assigns.current_user.id,
      value: form_data,
      last_checked: NaiveDateTime.utc_now
    })
    |> render_search(conn, form_data)
  end

  defp check_query_for_id(query) do
    Regex.run(~r/[a-zA-Z0-9_-]{11}/, query)
  end

  defp render_video_or_results([id], conn, form_data, _page) do
    Viztube.Youtube.video(id, "snippet")
    |> render_video(conn, form_data)
  end

  defp render_video_or_results(_, conn, form_data, page) do
    form_data = Map.merge(form_data, %{"page" => page})
    render_results(conn, Viztube.Youtube.search(form_data), form_data)
  end

  defp render_video({:ok, video}, conn, form_data) do
    case Map.has_key?(video, "items") do
      true ->
        render_results(conn, Viztube.Youtube.search(form_data), form_data)
      false ->
        render_results(conn, {:ok, [video], nil}, form_data)
    end
  end

  defp render_video({:error, _}, conn, form_data) do
    render_results(conn, Viztube.Youtube.search(form_data), form_data)
  end

  defp render_search({:ok, _search}, conn, form_data) do
    conn
    |> put_flash(:info, "search #{} has been created")
    |> render_results(Viztube.Youtube.search(form_data), form_data)
  end

  defp render_search({:error, e}, conn, form_data) do
    error = Enum.reduce e.changes.value.errors, "", fn(e, error) ->
      error <> "#{elem(e, 0)}: #{elem(elem(e, 1), 0)}, "
    end

    conn
    |> put_flash(:error, error)
    |> render_results(Viztube.Youtube.search(form_data), form_data)
  end

  defp render_results(conn, {:error, message}, form_data) do
    conn
    |> assign(:results, [])
    |> assign(:meta, nil)
    |> assign(:user_tags, [])
    |> assign(:form_data, form_data)
    |> put_flash(:error, message["error"]["message"])
    |> render("index.html")
  end


  defp render_results(conn, {:ok, results, meta}, form_data) do
    tags = conn.assigns.current_user.tags
    |> Enum.reduce([], fn(x, acc) -> [x.name | acc] end)
    |> check_default_tag

    conn
    |> assign(:results, results)
    |> assign(:meta, meta || nil)
    |> assign(:user_tags, tags)
    |> assign(:form_data, form_data)
    |> render("index.html")
  end

  defp check_default_tag(tags) do
    case !Enum.find(tags, fn(t) -> t == "Untagged" end) do
      false -> tags
      true -> ["Untagged"] ++ tags
    end
  end

end
