defmodule Viztube.Services.QueryCheck do
  @moduledoc """
  Service for update new videos in saved search
  Search new videos from last_checked to now
  In every update the last_checked field is updated to current time
  """

  alias Viztube.Queries
  alias Viztube.Accounts

  def run() do
    Enum.map Accounts.list_users(), fn(user) ->
      get_user_searches(user, 1)
    end
  end

  defp get_user_searches(_user, page) when page == nil do
    true
  end

  defp get_user_searches(user, page) do
    searches = Queries.list_searches(user.id, page)

    Enum.map searches.entries, fn(search) ->
      search_new_videos(search)
    end

    nextPage =
      case searches.page_number != searches.total_pages do
        false -> nil
        true -> page + 1
      end

    get_user_searches(user, nextPage)
  end

  defp search_new_videos(search) do
    pub_after = format_date(search.last_checked)
    pub_before = format_date(NaiveDateTime.utc_now())

    get_paginated_search_and_save("first", search, pub_after, pub_before)
  end

  defp get_paginated_search_and_save(page, _search, _pub_after, _pub_before) when page == nil do
    false
  end

  defp get_paginated_search_and_save(page, search, pub_after, pub_before) when page == "first" do
    Viztube.Youtube.search(%{
      "query" => search.value.query,
      "pub_after" => pub_after,
      "pub_before" => pub_before,
      "order" => search.value.order,
      "license" => search.value.license,
      "duration" => search.value.duration,
      "definition" => search.value.definition,
      "page" => nil,
      "channel" => nil})
      |> save_query_videos(search)
      |> get_paginated_search_and_save(search, pub_after, pub_before)
  end

  defp get_paginated_search_and_save(page, search, pub_after, pub_before) do
    Viztube.Youtube.search(%{
      "query" => search.value.query,
      "pub_after" => pub_after,
      "pub_before" => pub_before,
      "order" => search.value.order,
      "license" => search.value.license,
      "duration" => search.value.duration,
      "definition" => search.value.definition,
      "page" => page,
      "channel" => nil})
      |> save_query_videos(search)
      |> get_paginated_search_and_save(search, pub_after, pub_before)
  end

  defp format_date(date) do
    %{
      "year"=> date.year,
      "month"=> date.month,
      "day"=> date.day,
      "hour"=> date.hour,
      "minute"=> date.minute}
      |> Timex.to_datetime
      |> Timex.format!("{RFC3339z}")
  end

  defp save_query_videos({:ok, videos, meta}, search) when length(videos) > 0 do
    Enum.map videos, fn(v) ->
      Queries.create_result(%{
        search_id: search.id,
        value: %{
          channel_id: v.channel_id,
          channel_title: v.channel_title,
          title: v.title,
          description: v.description,
          etag: v.etag,
          published_at: v.published_at,
          video_id: v.video_id,
          thumbnails: v.thumbnails
        }
      })
    end

    Queries.update_search(search, %{last_checked: NaiveDateTime.utc_now, videos: Queries.get_results_count(search.id)})
    meta["nextPageToken"]
  end

  defp save_query_videos({:ok, [], _}, _search) do
    nil
  end
end
