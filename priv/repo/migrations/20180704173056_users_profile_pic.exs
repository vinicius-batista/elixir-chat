defmodule Chat.Repo.Migrations.UsersProfilePic do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:profile_pic, :string)
    end
  end
end
