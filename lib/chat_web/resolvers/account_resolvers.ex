defmodule ChatWeb.Resolvers.AccountResolver do
  alias Chat.Accounts.Auth
  alias ChatWeb.Guardian

  def register_user(_, %{input: input}, _) do
    case Auth.register(input) do
       {:ok, _user} -> {:ok, "User registred successfully."}
       error -> error
    end
  end

  def login_user(_, %{input:  %{email: email, password: password}}, _) do
    case Auth.find_user_and_check_password(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = user |> Guardian.encode_and_sign(%{}, token_type: :refresh)
        {:ok, token}
      error -> error
    end
  end
end
