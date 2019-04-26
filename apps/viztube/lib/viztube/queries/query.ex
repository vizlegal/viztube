defmodule  Viztube.Queries.Query do
  use Ecto.Schema
  import Ecto.Changeset

  alias Viztube.Queries.Query

  embedded_schema do
    field :query, :string
    field :pub_after, :date, default: Ecto.DateTime.from_date(%Ecto.Date{year: 2005, month: 1, day: 1})
    field :pub_before, :date, default: Ecto.DateTime.utc()
    field :order, :string
    field :license, :string
    field :definition, :string
    field :duration, :string
  end

  def changeset(%Query{} = query, attrs) do
    query
    |> cast(attrs, [:query, :pub_after, :pub_before, :order, :license, :definition, :duration])
    |> validate_required([:query, :pub_after, :pub_before, :order, :license, :definition, :duration])
  end
end
