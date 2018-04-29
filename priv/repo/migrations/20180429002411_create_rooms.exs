defmodule Chat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add(:owner_id, references(:users, on_delete: :delete_all))
      add(:name, :string)
      add(:description, :string)

      timestamps()
    end
  end
end
