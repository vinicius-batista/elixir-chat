defmodule ChatWeb.Resolvers.AccountResolver do
  alias Chat.Accounts.Auth

  def register_user(_, %{input: input}, _) do
    case Auth.register(input) do
       {:ok, _user} -> {:ok, "User registred successfully."}
       {:error, error} -> {:error, error}
    end
  end
end
