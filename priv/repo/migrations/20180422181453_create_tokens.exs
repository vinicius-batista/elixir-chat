defmodule Chat.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :user_id, references(:users)
      add :token, :string
      add :is_revoked, :boolean, default: false
      add :type, :string, default: "refresh"
      timestamps()
    end

    create unique_index(:tokens, [:token])
  end
end
