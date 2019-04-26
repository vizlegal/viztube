defmodule ViztubeWeb.VideoChannel do
  use ViztubeWeb, :channel
  require Logger

  def join("video:" <> video_id, payload, socket) do
    {:ok, "Joined video:#{video_id}", socket}
  end


  def handle_in("update", %{"id" => id}, socket) do

    {:ok, video} = Viztube.Youtube.video(id, "contentDetails,statistics,recordingDetails")

    payload = %{
      "duration" => List.first(video["items"])["contentDetails"]["duration"],
      "comments" => List.first(video["items"])["statistics"]["commentCount"],
      "views" => List.first(video["items"])["statistics"]["viewCount"],
      "lat" => List.first(video["items"])["recordingDetails"]["location"]["latitude"],
      "lon" => List.first(video["items"])["recordingDetails"]["location"]["longitude"]
    }

    broadcast socket, "update", payload
    {:noreply, socket}
  end
  
end
