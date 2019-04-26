defmodule Viztube.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :value, :map
      add :user_id, references(:users, on_delete: :delete_all)
      add :last_checked, :naive_datetime
      add :videos, :integer
      timestamps()
    end

    create index(:channels, [:user_id])
  end
end
