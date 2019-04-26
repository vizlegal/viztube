defmodule Viztube.Queries.Result do
  use Ecto.Schema
  import Ecto.Changeset
  alias Viztube.Queries.{Result, Search, Video}

  schema "results" do
    embeds_one :value, Video
    belongs_to :search, Search

    timestamps()
  end

  @doc false
  def changeset(%Result{} = result, attrs) do
    result
    |> cast(attrs, [:search_id])
    |> foreign_key_constraint(:search_id)
    |> cast_embed(:value)
    |> validate_required([:value, :search_id])
  end
end
