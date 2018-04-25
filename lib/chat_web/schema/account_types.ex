defmodule ChatWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  alias ChatWeb.Resolvers.AccountResolver
  alias ChatWeb.Helpers.HandleErrors
  alias ChatWeb.Middlewares.Authentication

  @desc "User object"
  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:username, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
  end

  @desc "Auth tokens"
  object :auth_tokens do
    field(:access_token, :string)
    field(:refresh_token, :string)
    field(:type, :string)
  end

  @desc "Input object for register"
  input_object :register_user_input do
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field(:username, non_null(:string))
    field(:password, non_null(:string))
  end

  @desc "Input object for login"
  input_object :login_user_input do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  @desc "Account mutations"
  object :account_mutations do
    field :register_user, :string do
      arg(:input, non_null(:register_user_input))
      resolve(HandleErrors.handle_errors(&AccountResolver.register_user/3))
    end

    field :login_user, :auth_tokens do
      arg(:input, non_null(:login_user_input))
      resolve(HandleErrors.handle_errors(&AccountResolver.login_user/3))
    end
  end

  @desc "Account queries"
  object :account_queries do
    field :new_access_token, :auth_tokens do
      arg(:refresh_token, non_null(:string))
      resolve(HandleErrors.handle_errors(&AccountResolver.new_access_token/3))
    end

    field :profile, :user do
      middleware(Authentication)
      resolve(&AccountResolver.profile/3)
    end
  end
end
