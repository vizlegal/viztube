defmodule Viztube.Repo.Migrations.CreateChannelResources do
  use Ecto.Migration

  def change do
    create table(:channel_videos) do
      add :data, :map
      add :channel_id, references(:channels, on_delete: :delete_all)

      timestamps()
    end

    create index(:channel_videos, [:channel_id])
  end
end
