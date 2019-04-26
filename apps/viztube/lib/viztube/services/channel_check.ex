defmodule Viztube.Services.ChannelCheck do
  @moduledoc """
  Service for update new videos in channels
  """
  alias Viztube.Channels

  def run() do
    Enum.map Channels.list_channels(), fn(channel) ->
      from = NaiveDateTime.to_iso8601(channel.last_checked)
      to = NaiveDateTime.to_iso8601(NaiveDateTime.utc_now)
      page = "first"

      get_channel_videos(channel, from, to, page)
      # Channels.service_update_channel({:ok, channel}, %{:last_checked => NaiveDateTime.utc_now})
    end
  end

  defp save_channel_videos({:ok, videos, meta}, channel) do
    Enum.map videos, fn(video) ->
      Channels.create_resource(%{
        channel_id: channel.id,
        data: %{
          channel_id: video.channel_id,
          channel_title: video.channel_title,
          title: video.title,
          description: video.description,
          etag: video.etag,
          published_at: video.published_at,
          video_id: video.video_id,
          thumbnails: video.thumbnails
        }
      })
    end
    Channels.service_update_channel({:ok, channel}, %{:last_checked => NaiveDateTime.utc_now})
    meta["nextPageToken"]
  end

  # TODO: review this!
  defp get_channel_videos(channel, from, to, page) when page == "first" do
    nextPage = Viztube.Youtube.channel_videos(channel.value.channel_id, from, to)
    |> save_channel_videos(channel)

    get_channel_videos(channel, from, to, nextPage)
  end

  defp get_channel_videos(_channel, _from, _to, page) when page == nil do
    true
  end

  defp get_channel_videos(channel, from, to, page) do
    nextPage = Viztube.Youtube.channel_videos(channel.value.channel_id, from, to, page)
    |> save_channel_videos(channel)
    get_channel_videos(channel, from, to, nextPage)
  end

end
