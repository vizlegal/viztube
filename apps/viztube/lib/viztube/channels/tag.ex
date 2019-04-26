defmodule Viztube.Channels.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Viztube.Channels.{Tag, Channel}
  alias Viztube.Accounts.User

  schema "tags" do
    field :name
    many_to_many :channels, Channel, join_through: "channel_tags"
    many_to_many :users, User, join_through: "user_tags"
    timestamps()
  end

  @doc false
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> cast_assoc(:channels)
    |> validate_required([:name])
  end
end
