defmodule Viztube.Channels.ChannelData do
  use Ecto.Schema
  import Ecto.Changeset

  alias Viztube.Channels.ChannelData

  embedded_schema do
    field :description, :string
    field :title, :string
    field :channel_id, :string
    field :videos, :integer, default: 0
  end

  def changeset(%ChannelData{} = channel_data, attrs) do
    channel_data
    |> cast(attrs, [:description, :title, :channel_id, :videos])
    |> validate_required([:title, :channel_id, :videos])
  end
end
