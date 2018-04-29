defmodule ChatWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ChatWeb.Resolvers.AccountsResolver
  alias ChatWeb.Middlewares.{Authentication, HandleErrors}
  alias Chat.Rooms.Room

  @desc "User object"
  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:username, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
    field(:rooms, list_of(:room), resolve: dataloader(Room))
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

  @desc "Input object for update_profile"
  input_object :update_profile_input do
    field(:email, :string)
    field(:name, :string)
    field(:username, :string)
  end

  @desc "Input object for change_password"
  input_object :change_password_input do
    field(:old_password, non_null(:string))
    field(:new_password, non_null(:string))
  end

  @desc "Account mutations"
  object :account_mutations do
    field :register_user, :string do
      arg(:input, non_null(:register_user_input))
      resolve(&AccountsResolver.register_user/3)
      middleware(HandleErrors)
    end

    field :login_user, :auth_tokens do
      arg(:input, non_null(:login_user_input))
      resolve(&AccountsResolver.login_user/3)
      middleware(HandleErrors)
    end

    field :logout, :string do
      arg(:refresh_token, non_null(:string))
      middleware(Authentication)
      resolve(&AccountsResolver.logout/3)
      middleware(HandleErrors)
    end

    field :update_profile, :user do
      arg(:input, non_null(:update_profile_input))
      middleware(Authentication)
      resolve(&AccountsResolver.update_profile/3)
      middleware(HandleErrors)
    end

    field :change_password, :user do
      arg(:input, non_null(:change_password_input))
      middleware(Authentication)
      resolve(&AccountsResolver.change_password/3)
      middleware(HandleErrors)
    end

    field :delete_user, :string do
      middleware(Authentication)
      resolve(&AccountsResolver.delete_user/3)
      middleware(HandleErrors)
    end
  end

  @desc "Account queries"
  object :account_queries do
    field :new_access_token, :auth_tokens do
      arg(:refresh_token, non_null(:string))
      resolve(&AccountsResolver.new_access_token/3)
      middleware(HandleErrors)
    end

    field :profile, :user do
      middleware(Authentication)
      resolve(&AccountsResolver.profile/3)
    end
  end
end
