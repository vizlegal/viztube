defmodule Viztube.Repo.Migrations.CreateResults do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :value, :map
      add :search_id, references(:searches, on_delete: :delete_all)

      timestamps()
    end

    create index(:results, [:search_id])
  end
end
