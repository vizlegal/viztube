defmodule Viztube.Repo.Migrations.CreateAuthTokens do
  use Ecto.Migration

  def change do
    create table(:auth_tokens) do
      add :value, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:auth_tokens, [:user_id])
    create unique_index(:auth_tokens, [:value])
  end
end
