defmodule Viztube.Repo.Migrations.ChangeAuthTokensUserId do
  use Ecto.Migration

  def change do
    alter table(:auth_tokens) do
      remove :user_id
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
