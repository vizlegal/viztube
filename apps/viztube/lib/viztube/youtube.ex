defmodule Viztube.Youtube do
  @moduledoc """
  This module handles Youtube API calls
  """

  @doc """
    Get a video using YT API.

    Parameters

      - Part: String with get options "snippet", "recordingDetails"....
      - Id: String with the video id

    Returns `{:ok, [results], [metadata]}`
  """
  def video(id, part) do
    TubEx.Video.get(id, part)
  end

  @doc """
    Get channel info using YT API.

    Parameters

      - id: String that represents channel id

    Returns `{:ok, [results]}`
  """
  def channel(id) do
    TubEx.Channel.get(id)
  end

  @doc """
    Get channel videos using YT API.

    Parameters

      - id: String. Channel id
      - from: Date, date to search from
      - to: Date, date to search to

    Returns `{:ok, [results], [metadata]}`
  """
  def channel_videos(id, from, to) do
    TubEx.Video.search("", [maxResults: 50,
      safeSearch: "none",
      order: "date",
      publishedAfter: date_to_rfc3339(from),
      publishedBefore: date_to_rfc3339(to),
      channelId: id])
  end

  @doc """
    Get channel videos using YT API.

    Parameters

    Parameters

      - id: String. Channel id
      - from: Date, date to search from
      - to: Date, date to search to
      - page: String, page token to search

    Returns `{:ok, [results], [metadata]}`
  """
  def channel_videos(id, from, to, pageToken) do
    TubEx.Video.search("", [maxResults: 50,
      safeSearch: "none",
      order: "date",
      publishedAfter: date_to_rfc3339(from),
      publishedBefore: date_to_rfc3339(to),
      pageToken: pageToken,
      channelId: id])
  end


  @doc """
    Do a search using YT API.
    - Dates must be in RFC 3339z format
    - Paginations uses a token provided by API response

    Returns `{:ok, [%Youtube.video{}, ...], [metadata]}`
  """
  def search(%{query: query, pub_after: pub_after, pub_before: pub_before, order: order, duration: duration, license: license, definition: definition, page: page, channel: channel}) do
    TubEx.Video.search(query, [maxResults: 50,
      safeSearch: "none",
      publishedAfter: pub_after,
      publishedBefore: pub_before,
      order: order,
      pageToken: page,
      videoLicense: license,
      videoDefinition: definition,
      videoDuration: duration,
      channel: channel])
  end

  @doc """
    Like `search/5` but consumes Phoenix.Form data
  """
  def search(form_data) do

    form = form_data
    |> check_after()
    |> check_before()

    search(%{
      query: form["query"],
      pub_after: date_to_rfc3339(form["pub_after"]),
      pub_before: date_to_rfc3339(form["pub_before"]),
      order: form["order"],
      duration: form["duration"],
      license: form["license"],
      definition: form["definition"],
      page: form["page"] || nil,
      channel: form["channel"] || nil
    })
  end

  @doc false
  defp date_to_rfc3339(date) do
    {:ok, ndt} = NaiveDateTime.from_iso8601(date)
    ndt |> Timex.to_datetime |> Timex.format!("{RFC3339z}")
  end

  @doc false
  defp check_after(date = %{"pub_after" => ""}) do
    Map.put(date, "pub_after", "2005-01-01 00:00:00")
  end

  @doc false
  defp check_after(date = %{"pub_after" => _pub_after}) do
    date
  end

  @doc false
  defp check_before(date = %{"pub_before" => ""}) do
    Map.put(date, "pub_before", NaiveDateTime.to_iso8601(NaiveDateTime.utc_now()) )
  end

  @doc false
  defp check_before(date = %{"pub_before" => _pub_before}) do
    date
  end


end
