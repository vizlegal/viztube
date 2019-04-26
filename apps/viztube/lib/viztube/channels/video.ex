defmodule  Viztube.Channels.Video do
  use Ecto.Schema
  import Ecto.Changeset

  alias Viztube.Channels.Video

  embedded_schema do
    field :channel_id, :string
    field :channel_title, :string
    field :description, :string
    field :etag, :string
    field :published_at, :naive_datetime
    field :thumbnails, :map
    field :video_id, :string
    field :title, :string
  end

  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:channel_id, :title, :thumbnails, :channel_title, :etag, :description, :published_at, :video_id])
    |> validate_required([:channel_id, :title, :thumbnails, :channel_title, :etag, :published_at, :video_id])
  end
end
