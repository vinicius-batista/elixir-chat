defmodule Chat.Accounts.User do
  @moduledoc """
  User schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.{Token, Encryption}
  alias Chat.Rooms.{Room, Message}
  alias Chat.Images

  @email_regex ~r/^(?<user>[^\s]+)@(?<domain>[^\s]+\.[^\s]+)$/
  @required_fields ~w(email name password_hash username)a
  @all_fields ~w(password profile_pic profile_pic_file)a ++ @required_fields
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:username, :string)
    field(:password_hash, :string)
    field(:profile_pic, :string)
    field(:profile_pic_file, Images.UploadType, virtual: true)

    timestamps()
    has_many(:tokens, Token, on_delete: :delete_all)
    has_many(:rooms, Room, on_delete: :delete_all, foreign_key: :owner_id)
    has_many(:messages, Message, on_delete: :delete_all)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @all_fields)
    |> hash_password()
    |> upload_profile_pic()
    |> validate_required(@required_fields)
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:username, name: :users_username_index)
    |> validate_format(:email, @email_regex)
    |> update_change(:email, &String.downcase/1)
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    changeset
    |> put_change(:password_hash, Encryption.password_hashing(pass))
  end

  defp hash_password(changeset), do: changeset

  defp upload_profile_pic(
         %Ecto.Changeset{valid?: true, changes: %{profile_pic_file: profile_pic}} = changeset
       ) do
    changeset
    |> put_change(:profile_pic, Images.upload(profile_pic, "users"))
  end

  defp upload_profile_pic(changeset), do: changeset
end
