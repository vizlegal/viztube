defmodule Viztube.Channels do

  @moduledoc """
  The Channels context.
  """

  import Ecto.Query, warn: false
  alias Viztube.Repo

  alias Viztube.Channels.{Channel, Tag, Resource}
  alias Viztube.Accounts

  @doc """
  Returns the full list of channels.

  ## Examples

    iex> list_channels()
    [%Channel{}, ...]

  """
  def list_channels do
    Channel
    |> Repo.all
    |> Repo.preload(:tags)
  end

  @doc """
  Returns the list of channels for an user.

  ## Parameters

    - id: Integer that represent the user id

  ## Examples

    iex> list_channels(8, 2)
    %{"entries" => [%Channel{}, ...], "current_page" => integer, "total_pages" => integer... }

  """
  def list_channels(id, page) do
    Channel
    |> where([ch], ch.user_id == ^id)
    |> preload(:tags)
    |> preload(:resources)
    |> Repo.paginate(page: page, page_size: 50)
  end

  @doc """
  Gets a single channel owned by an user

  Raises `Ecto.NoResultsError` if the Channel does not exist.

  ## Parameters

    - user_id: String User id
    - id: Integer Channel id

  ## Examples

    iex> get_channel!(8, 123)
    {ok:, %Channel{}}

    iex> get_channel!(8, 456)
    {:error}

  """
  def get_channel(user_id, id) do
    case Channel
      |> where(user_id: ^user_id, id: ^id)
      |> Repo.one
      |> Repo.preload(:tags)
      |> Repo.preload(:resources) do
        nil  ->
          {:error, "Channel not found"}
        channel ->
          {:ok, channel}
    end
  end

  @doc """
  Check if an user have a channel subscription with a given tag

  Raises {:error, message} if the Channel does exist with the tag

  ## Parameters

    - user_id: String User id
    - channel_id: String Channel youtube id
    - tags: String, tag

  ## Examples

    iex> check_tagged_user_channel(1, "XDFBG_rt54-erCC", "Dublin")
    {:ok, :false} if channel does not exist with this tag

    iex> check_tagged_user_channel(1, "XDFBG_rt54-erCC", "Example")
    {:error, "This channel is already subscribed to in that tag"} if channel exists with this channel

  """
  def check_tagged_user_channel(user_id, channel_id, tags) do
    Channel
    |> where([r], r.user_id == ^user_id and fragment("?->>'channel_id' LIKE ?", r.value, ^channel_id))
    |> Repo.all
    |> Repo.preload(tags: from(t in Tag, where: t.name == ^tags))
    |> find_tags(tags)
  end

  @doc """
  Find all videos for a given tag and user

  ## Parameters

    - user_id: String that represents the user id
    - id: Integer that represent the tag id
    - page: Integer that represent page to show

  ## Examples

    iex> find_user_tag_videos(1, 45, 2)
    {%Tag{}, %{"entries" => [%Resource{}, ...], "current_page" => integer, "total_pages" => integer... }}

  """
  def find_user_tag_videos(user_id, id, page) do
    tag = Tag
    |> Repo.get!(id)
    |> Repo.preload(channels: from(c in Channel, where: c.user_id == ^user_id))

    channels = Enum.map tag.channels, fn(channel) -> channel.id end

    paginated_videos = Resource
      |> where([r], r.channel_id in ^channels)
      |> order_by([r], desc: fragment("?->>'published_at'", r.data))
      |> Repo.paginate(page: page, page_size: 50)

    {tag, paginated_videos}
  end

  @doc """
  Creates a channel.

  ## Parameters

    - user_id: String that represents the user id
    - id: Integer that represent the tag id
    - page: Integer that represent page to show

  ## Examples

    iex> create_channel(%{field: value})
    {:ok, %Channel{}}

    iex> create_channel(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def create_channel(attrs \\ %{}) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a channel.

  ## Parameters

    - channel: {:ok, %Channel{}}
    - attrs: %{field, value}

  ## Examples

    iex> update_channel(channel, %{field: new_value})
    {:ok, %Channel{}}

    iex> update_channel(channel, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def update_channel({:ok, %Channel{} = channel}, attrs) do
    channel
    |> Repo.preload(:tags)
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a channel from service.
  It uses a changeset without tags

  ## Parameters

    - channel: {:ok, %Channel{}}
    - attrs: %{field, value}

  ## Examples

    iex> service_update_channel(channel, %{field: new_value})
    {:ok, %Channel{}}

    iex> service_update_channel(channel, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def service_update_channel({:ok, %Channel{} = channel}, attrs) do
    channel
    |> Repo.preload(:tags)
    |> Channel.service_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Channel.

  ## Parameters

    - channel: %Channel{}

  ## Examples

    iex> delete_channel(channel)
    {:ok, %Channel{}}

    iex> delete_channel(channel)
    {:error, %Ecto.Changeset{}}

  """
  def delete_channel(%Channel{} = channel) do
    Repo.delete(channel)
  end

  @doc """
  Deletes an User Tag.

  ## Parameters

    - channel_id: Integer, channel id
    - tag_name: String, the tag name

  ## Examples

    iex> delete_tag(channel, tag)
    {:ok, %Channel{}}

    iex> delete_tag(channel, tag)
    {:error, %Ecto.Changeset{}}

  """
  def delete_channel_tag(channel_id, tag_name) do
    channel = Channel |> Repo.get!(channel_id) |> Repo.preload(:tags)

    tags =
      channel.tags
      |> Enum.map(fn(tag) -> tag.name end)
      |> Enum.reject(fn(tag) -> tag == tag_name end)
      |> check_default_tag

    update_channel({:ok, channel}, %{tags: Enum.join(tags, ",")})
  end

  @doc """
  Deletes an User Tag.

  ## Parameters

    - channel_id: Integer, channel id
    - tag_name: String, the tag name

  ## Examples

    iex> delete_tag(8, "casa")
    {:ok, %Channel{}}

    iex> delete_tag(8, _)
    {:error, %Ecto.Changeset{}}

  """
  def add_channel_tag(channel_id, tag_name) do
    channel = Channel |> Repo.get!(channel_id) |> Repo.preload(:tags)
    tags = channel.tags |> Enum.map(fn(tag) -> tag.name end)
    channel_tags = Enum.reject(tags, fn(tag) -> tag == "Untagged" end) |> Enum.join(",")

    if !Enum.find tags, fn(tag) -> tag == tag_name end do
      update_channel({:ok, channel}, %{tags: Enum.join([tag_name, channel_tags], ",")})
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking channel changes.

  ## Parameters

    - channel: %Channel{}

  ## Examples

    iex> change_channel(channel)
    %Ecto.Changeset{source: %Channel{}}

  """
  def change_channel(%Channel{} = channel) do
    Channel.changeset(channel, %{})
  end

  @doc """
  Creates a resource.

  ## Parameters

    - atrs: %{field: value}

  ## Examples

    iex> create_resource(%{field: value})
    {:ok, %Resource{}}

    iex> create_resource(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def create_resource(attrs \\ %{}) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a resource.

  ## Parameters

    - resource: %Resource{}
    - attrs: %{field: value}

  ## Examples

    iex> update_resource(resource, %{field: new_value})
    {:ok, %Resource{}}

    iex> update_resource(resource, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def update_resource(%Resource{} = resource, attrs) do
    resource
    |> Resource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Resource.

  ## Parameters

    - resource: %Resource{}

  ## Examples

    iex> delete_resource(resource)
    {:ok, %Resource{}}

    iex> delete_resource(resource)
    {:error, %Ecto.Changeset{}}

  """
  def delete_resource(%Resource{} = resource) do
    Repo.delete(resource)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resource changes.

  ## Parameters

    - resource: %Resource{}

  ## Examples

    iex> change_resource(resource)
    %Ecto.Changeset{source: %Resource{}}

  """
  def change_resource(%Resource{} = resource) do
    Resource.changeset(resource, %{})
  end

  @doc """
  Returns a paginated list of resources from a channel .

  ## Parameters

    - id: Integer, the channel id
    - page: Intger, the page to show

  ## Examples

    iex> list_resources(25, 1)
    %{"entries" => [%Result{}, ...], "current_page" => integer, "total_pages" => integer... }

  """
  def list_resources(id, page) do
    Resource
    |> where([r], r.channel_id == ^id)
    |> order_by([r], desc: fragment("?->>'published_at'", r.data))
    |> Repo.paginate(page: page, page_size: 50)
  end

  @doc """
  Returns a list of tagsfor an user .

  ## Parameters

    - id: Integer, the id of the user

  ## Examples

    iex> list_tags(8)
    [%{id, tag, channels, videos}, ...]

  """
  def list_tags(id) do
    user = Accounts.get_user!(id)
    |> Repo.preload(tags: [channels: from(c in Channel, where: c.user_id == ^id), channels: :resources])

    Enum.map user.tags, fn(tag) ->
      videos = Enum.reduce tag.channels, 0, fn(channel, sum) ->
        length(channel.resources) + sum
      end
      %{id: tag.id, tag: tag.name, channels: length(tag.channels), videos: videos}
    end
  end

  @doc """
  create a tag

  ## Parameters

    - attrs: %{field: value}

  ## Examples

    iex> create_tag(%{field: value})
    {:ok, %Tag{}}

    iex> create_tag(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  get a tag

  ## Parameters

    - tag_id: Integer, the tag id

  ## Examples

    iex> get_tag!(123)
    %Tag{}

    iex> get_tag!(456)
    ** (Ecto.NoResultsError)

  """
  def get_tag!(tag_id) do
    Tag
    |> Repo.get!(tag_id)
  end

  defp find_tags([], _tags) do
    {:ok, :false}
  end

  defp find_tags(channels, tags) do
    ex = Enum.map(channels, fn(ch) -> length(ch.tags) end)
    if(Enum.find(ex, fn(t) -> t > 0 end)) do {:error, "This channel is already subscribed to in that tag"} else {:ok, :false} end
  end

  defp check_default_tag(tags) when length(tags) == 0 do
    ["Untagged"]
  end

  defp check_default_tag(tags) do
    tags
  end
end
