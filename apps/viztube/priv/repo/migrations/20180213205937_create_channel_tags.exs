defmodule Viztube.Repo.Migrations.CreateChannelTags do
  use Ecto.Migration

  def change do
    create table(:channel_tags, primary_key: false) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :channel_id, references(:channels, on_delete: :delete_all)

      # timestamps()
    end

    create index(:channel_tags, [:tag_id, :channel_id], unique: true)

  end
end
