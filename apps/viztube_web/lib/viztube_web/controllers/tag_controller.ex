defmodule ViztubeWeb.TagController do
  @moduledoc """
  Channel Controller
  """
  use ViztubeWeb, :controller

  alias Viztube.Channels
  alias Viztube.Accounts

  @doc """
  render list of videos from a channel since last checked date

  Returns `render show`.
  """
  def show(conn, %{"id" => id, "page" => page}) do
    Channels.find_user_tag_videos(conn.assigns.current_user.id, id, page)
    |> render_tag_videos(conn)
  end

  def delete_confirmation(conn, %{"tag_name" => tag_name}) do
    conn
    |> render("confirm.html", tag: tag_name)
  end

  @doc """
  remove a tag from an user and his assciated channels

  ## Parmeters
    - tag_name: String. the name of the tag to remove

  Returns `rener channel index`.
  """
  def delete(conn, %{"tag_name" => tag_name}) do
    # TODO: delete channel tags
    # Enum.map Channels.list_channels(conn.assigns.current_user.id), fn(channel) ->
    # Channels.delete_channel_tag(channel.id, tag_name)
    # end

    # TODO: this append beacuse tags index render inside channel route.
    # should change channels route by tags route and remove channels from view ?
    Accounts.delete_tag(conn.assigns.current_user.id, tag_name)
    |> put_response(conn, tag_name)
    |> assign(:channels, Channels.list_channels(conn.assigns.current_user.id, 1))
    |> assign(:tags, Channels.list_tags(conn.assigns.current_user.id))
    |> render(ViztubeWeb.ChannelView, "index.html")
  end

  defp put_response({:ok, :true}, conn, tag_name) do
    conn
    |> put_flash(:info, "tag #{tag_name} removed")
  end

  defp put_response({:error, message}, conn, _tag_name) do
    conn
    |> put_flash(:error, message)
  end

  @doc """
  remove a tag from an user channel

  ## Parmeters
    - channel_id: Integer that represent the channel id in the DB
    - tag_id: Integer with the tag id to remove

  Returns `rener channel show with channel resources`.
  """
  def delete_tag(conn, %{"tag_id" => tag_id, "channel_id" => channel_id}) do
    Channels.get_channel(conn.assigns.current_user.id, channel_id)
    |> remove_channel_tag(tag_id, conn)
  end

  defp remove_channel_tag({:ok, channel}, tag_id, conn) do
    tag = Channels.get_tag!(tag_id)
    Channels.delete_channel_tag(channel.id, tag.name)
    Channels.find_user_tag_videos(conn.assigns.current_user.id, tag_id, 1)
    |> render_tag_videos(conn)
  end

  defp remove_channel_tag({:error, message}, tag_id, conn) do
    Channels.find_user_tag_videos(conn.assigns.current_user.id, tag_id, 1)
    |> put_flash(:error, message)
    |> render_tag_videos(conn)
  end

  defp render_tag_videos({tag, videos}, conn) do
    conn
    |> assign(:tag, tag)
    |> assign(:videos, videos)
    |> render("show.html")
  end
end
