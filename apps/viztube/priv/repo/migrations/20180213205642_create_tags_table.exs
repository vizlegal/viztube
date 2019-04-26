defmodule Viztube.Repo.Migrations.CreateTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string, null: false

      timestamps()
    end

    create index(:tags, ["lower(name)"], unique: true)

  end
end
