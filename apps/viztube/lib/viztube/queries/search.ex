defmodule Viztube.Queries.Search do
  use Ecto.Schema
  import Ecto.Changeset
  alias Viztube.Queries.{Search, Result, Query}
  alias Viztube.Accounts.User

  schema "searches" do
    field :last_checked, :naive_datetime
    field :videos, :integer, default: 0
    embeds_one :value, Query, on_replace: :delete
    belongs_to :user, User
    has_many :results, Result

    timestamps()
  end

  @doc false
  def changeset(%Search{} = search, attrs) do
    search
    |> cast(attrs, [:last_checked, :user_id, :videos])
    |> cast_embed(:value)
    |> validate_required([:value, :last_checked, :user_id])
  end
end
