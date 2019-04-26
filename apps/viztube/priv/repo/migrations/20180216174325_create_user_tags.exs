defmodule Viztube.Repo.Migrations.CreateUserTags do
  use Ecto.Migration

  def change do
    create table(:user_tags, primary_key: false) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      # timestamps()
    end

    create index(:user_tags, [:tag_id, :user_id], unique: true)

  end
end
