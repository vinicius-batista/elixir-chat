defmodule Chat.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add(:user_id, references(:users))
      add(:refresh_token, :string)
      add(:is_revoked, :boolean, default: false)
      add(:type, :string, default: "refresh")
      timestamps()
    end

    create(unique_index(:tokens, [:refresh_token]))
  end
end
