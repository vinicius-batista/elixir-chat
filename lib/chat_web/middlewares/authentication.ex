defmodule ChatWeb.Middlewares.Authentication do
  @moduledoc """
  Absinthe middleware for authentication
  """
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  def call(%{context: %{current_user: _current_user}} = resolution, _) do
    resolution
  end

  def call(resolution, _) do
    error = {
      :error,
      %{
        code: :not_authenticated,
        error: "Not authenticated",
        message: "Invalid access token"
      }
    }

    resolution
    |> Resolution.put_result(error)
  end
end
