defmodule Viztube.Repo.Migrations.AddVideosCountToSearch do
  use Ecto.Migration

  def change do
    alter table(:searches) do
      add :videos, :integer
    end
  end
end
