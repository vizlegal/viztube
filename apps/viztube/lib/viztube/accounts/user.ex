defmodule Viztube.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: true

  alias Viztube.Repo
  alias Viztube.Accounts.{User, AuthToken}
  alias Viztube.Queries.Search
  alias Viztube.Channels.{Channel, Tag}

  schema "users" do
    field :email, :string
    field :admin, :boolean

    has_many :auth_tokens, AuthToken
    has_many :queries, Search
    has_many :channels, Channel
    many_to_many :tags, Tag, join_through: "user_tags", on_replace: :delete

    timestamps()

  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :admin])
    |> validate_required([:email, :admin])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end

  def tags_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :admin])
    |> validate_required([:email, :admin])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> put_assoc(:tags, parse_tags(attrs.tags))
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
