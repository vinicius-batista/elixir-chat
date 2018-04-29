defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:room_id, references(:rooms, on_delete: :delete_all))
      add(:text, :string)

      timestamps()
    end
  end
end
