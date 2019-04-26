defmodule Viztube.Channels.Channel do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: true

  alias Viztube.Repo
  alias Viztube.Channels.{Channel, ChannelData, Tag, Resource}
  alias Viztube.Accounts.User


  schema "channels" do
    field :last_checked, :naive_datetime, default: NaiveDateTime.utc_now
    embeds_one :value, ChannelData, on_replace: :update
    has_many :resources, Resource
    many_to_many :tags, Tag, join_through: "channel_tags", on_replace: :delete

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Channel{} = channel, attrs) do
    channel
    |> cast(attrs, [:last_checked, :user_id])
    |> cast_embed(:value)
    |> validate_required([:last_checked, :user_id])
    |> put_assoc(:tags, parse_tags(attrs.tags))
  end

  def service_changeset(%Channel{} = channel, attrs) do
    channel
    |> cast(attrs, [:last_checked, :user_id])
    |> cast_embed(:value)
    |> validate_required([:last_checked, :user_id])
  end

  defp parse_tags([]) do
    []
  end

  defp parse_tags(params)  do
    (params || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> insert_and_get_all()
  end

  defp insert_and_get_all([]) do
    []
  end

  defp insert_and_get_all(names) do
    maps = Enum.map(names, &%{name: &1, inserted_at: Timex.now, updated_at: Timex.now})
    Repo.insert_all Tag, maps, on_conflict: :nothing
    Repo.all(from t in Tag, where: t.name in ^names)
  end
end
