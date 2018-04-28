defmodule Chat.Accounts.AuthToken do
  alias Chat.Accounts
  alias ChatWeb.Guardian

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

  def generate_access_token(user), do: Guardian.encode_and_sign(user, %{}, token_type: :bearer)

  def revoke_token(nil), do: {:error, "Could not find refresh token provided"}

  def revoke_token(token) do
    token
    |> Accounts.update_token(%{is_revoked: true})
  end
end
