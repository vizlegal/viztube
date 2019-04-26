defmodule ViztubeWeb.ChannelController do
  @moduledoc """
  Channel Controller
  """
  use ViztubeWeb, :controller

  alias Viztube.Channels
  alias Viztube.Accounts

  @doc """
  render index page with list of channels and tags

  Returns `render index`.
  """
  def index(conn, %{"page" => page}) do
    conn
    |> render_user_channels(page)
  end

  @doc """
  Check if user have this channel with the same tag.
  If channel & tag exists respond with an error message.
  In other case search channel by id using Youtube api and store it with a given tag

  Parmeters
    - channel_id: String that represent the Youtube id of the channel
    - tags: String with the tag name

  """
  def create(conn, %{"channel_id" => channel_id, "tags" => tags}) do
    Channels.check_tagged_user_channel(conn.assigns.current_user.id, channel_id, tags)
    |> subscribe_channel(conn, channel_id, tags)
    |> render_user_channels(1)
  end

  @doc """
  render list of videos from a channel since last checked date

  ## Parmeters
    - id: Integer that represent the channel id in the DB
    - page: Integer that represent the page to render

  Returns `render channel show with channel resources`.
  """
  def show(conn, %{"id" => id, "page" => page}) do
    Channels.get_channel(conn.assigns.current_user.id, id)
    |> render_channel_resources(conn, page)
  end

  @doc """
  render modal window to delete a channel

  ## Parmeters
    - id: Integer that represent the channel id in the DB

  Returns `render modal delete channel`.
  """
  def delete_confirmation(conn, %{"id" => id}) do
    conn
    |> render("confirm.html", id: id)
  end

  @doc """
  delete an user channel

  ## Parmeters
    - id: Integer that represent the channel id in the DB

  Returns `render channel index`.
  """
  def delete(conn, %{"id" => id}) do
    Channels.get_channel(conn.assigns.current_user.id, id)
    |> delete_channel(conn)
    |> render_user_channels(1)
  end

  @doc """
  Add a tag to an user channel

  ## Parmeters
    - channel_id: Integer that represent the channel id in the DB
    - tags: String with the tags to add

  Returns `render channel show with channel resources`.
  """
  def add_tag(conn, %{"channel_id" => channel_id, "tags" => tag}) do
    {:ok, ch} = Channels.get_channel(conn.assigns.current_user.id, channel_id)

    Channels.check_tagged_user_channel(conn.assigns.current_user.id, ch.value.channel_id, tag)
    |> update_channel(conn, channel_id, tag)
    |> render_channel_resources(conn, 1)
  end

  defp update_channel({:ok, :false}, conn, channel_id, tag) do
    Accounts.add_tag(conn.assigns.current_user.id, tag)
    Channels.add_channel_tag(channel_id, tag)
    Channels.get_channel(conn.assigns.current_user.id, channel_id)
  end

  defp update_channel({:error, message}, _conn, _channel_id, _tag) do
    {:error, message}
  end

  defp subscribe_channel({:error, message}, conn, _channel_id, _tag) do
    conn
    |> put_flash(:error, message)
  end

  defp subscribe_channel({:ok, false}, conn, channel_id, tag) do
    Viztube.Youtube.channel(channel_id)
    |> create_channel(conn, tag)
    |> create_user_tag(conn, tag)
  end

  defp create_channel({:ok, channel}, conn, tags) do
    Channels.create_channel(%{
      user_id: conn.assigns.current_user.id,
      value: %{
        "description" => channel.description,
        "title" => channel.title,
        "channel_id" => channel.channel_id},
      last_checked: NaiveDateTime.utc_now,
      tags: tags})
  end

  defp create_channel({:error, e}, _conn, _tags) do
    {:error, e}
  end

  defp create_user_tag({:ok, channel}, conn, tags) do
    Accounts.add_tag(conn.assigns.current_user.id, tags)
    conn
    |> put_flash(:info, "channel #{channel.value.title} has been created")
  end

  defp create_user_tag({:error, e}, conn, _tags) do
    error = Enum.reduce e.changes.value.errors, "", fn(e, er) ->
      er <> "#{elem(e, 0)}: #{elem(elem(e, 1), 0)}, "
    end

    conn
    |> put_flash(:error, error)
  end

  defp render_channel_resources({:ok, channel}, conn, page) do
    videos = Channels.list_resources(channel.id, page)

    tags = conn.assigns.current_user.tags
    |> Enum.reduce([], fn(x, acc) -> [x.name | acc] end)
    |> check_default_tag
    |> Enum.filter(fn(tag) -> !Enum.find channel.tags, fn(t) -> t.name == tag end end )

    conn
    |> assign(:videos, videos)
    |> assign(:channel_id, channel.id)
    |> assign(:last_checked, channel.last_checked)
    |> assign(:channel_tags, channel.tags)
    |> assign(:user_tags, tags)
    |> render("show.html")
  end

  defp check_default_tag(tags) do
    case !Enum.find(tags, fn(t) -> t == "Untagged" end) do
      false -> tags
      true -> ["Untagged"] ++ tags
    end
  end

  defp render_channel_resources({:error, message}, conn, _page) do
    conn
    |> put_flash(:error, message)
    |> render_user_channels(1)
  end

  defp delete_channel({:ok, channel}, conn) do
    Channels.delete_channel(channel)
    conn
    |> put_flash(:info, "channel subscription removed")
  end

  defp delete_channel({:error, message}, conn) do
    conn
    |> put_flash(:error, message)
  end

  defp render_user_channels(conn, page) do
    conn
    |> assign(:channels, Channels.list_channels(conn.assigns.current_user.id, page))
    |> assign(:tags, Channels.list_tags(conn.assigns.current_user.id))
    |> render("index.html")
  end

end
