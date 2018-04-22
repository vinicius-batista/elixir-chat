defmodule ChatWeb.Schema.AccountTypes do

  use Absinthe.Schema.Notation

  alias ChatWeb.Resolvers.AccountResolver
  alias ChatWeb.Helpers.HandleErrors

  @desc "User object"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :username, :string
    field :inserted_at, :string
    field :updated_at, :string
  end

  @desc "Input object for register"
  input_object :register_user_input do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :username, non_null(:string)
    field :password, non_null(:string)
  end

  @desc "Input object for login"
  input_object :login_user_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  @desc "Account mutations"
  object :account_mutations do
    field :register_user, :string do
      arg :input, non_null(:register_user_input)
      resolve HandleErrors.handle_errors(&AccountResolver.register_user/3)
    end

    field :login_user, :string do
      arg :input, non_null(:login_user_input)
      resolve HandleErrors.handle_errors(&AccountResolver.login_user/3)
    end
  end

  @desc "Account queries"
  object :account_queries do
    field :user, :string do
      resolve fn _, _, _ -> "ola" end
    end
  end
end
