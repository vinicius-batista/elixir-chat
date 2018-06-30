defmodule Chat.Accounts.AuthToken do
  @moduledoc """
  Authentication token module
  """
  alias Chat.Accounts
  alias ChatWeb.Guardian

  @type auth_tokens :: %{refresh_token: String.t(), access_token: String.t(), type: String.t()}

  @spec generate_refresh_token(String.t(), Guardian.claims()) :: {:ok, auth_tokens}
  def generate_refresh_token(access_token, %{"typ" => type, "sub" => user_id}) do
    attrs = %{user_id: user_id, type: type}

    with {:ok, token} <- Accounts.create_token(attrs) do
      tokens =
        token
        |> Map.from_struct()
        |> Map.put(:access_token, access_token)
        |> Map.take([:access_token, :refresh_token, :type])

      {:ok, tokens}
    end
  end

  @spec generate_access_token(%Accounts.User{}) :: Guardian.encode_and_sign()
  def generate_access_token(user), do: Guardian.encode_and_sign(user, %{}, token_type: :bearer)

  @spec revoke_token(String.t() | nil) ::
          {:ok, %Accounts.Token{}} | {:error, String.t()} | {:error, %Ecto.Changeset{}}

  def revoke_token(nil), do: {:error, "Could not find refresh token provided"}

  def revoke_token(token) do
    token
    |> Accounts.update_token(%{is_revoked: true})
  end

  @spec authorize(String.t()) :: map
  def authorize(token) do
    case Guardian.resource_from_token(token) do
      {:error, _} -> %{}
      {:ok, current_user, _claims} -> %{current_user: current_user}
    end
  end
end
