defmodule Viztube.Channels.Resource do

  use Ecto.Schema
  import Ecto.Changeset

  alias Viztube.Channels.{Channel, Resource, Video}

  schema "channel_videos" do
    embeds_one :data, Video
    belongs_to :channel, Channel

    timestamps()
  end

  @doc false
  def changeset(%Resource{} = resource, attrs) do
    resource
    |> cast(attrs, [:channel_id])
    |> foreign_key_constraint(:channel_id)
    |> cast_embed(:data)
    |> validate_required([:data, :channel_id])
  end
end
