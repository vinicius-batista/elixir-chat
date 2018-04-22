defmodule ChatWeb.Guardian do
  use Guardian, otp_app: :chat

  alias Chat.Accounts.{User}
  alias Chat.Accounts

  def subject_for_token(%User{} = user, _claims), do: {:ok, to_string(user.id)}
  def subject_for_token(_, _), do: {:error, "Unknow resource type"}

  def resource_from_claims(%{"sub" => user_id}), do: {:ok, Accounts.get_user!(user_id)}
  def resource_from_claims(_claims), do: {:error, "Unknow resource type"}
end
