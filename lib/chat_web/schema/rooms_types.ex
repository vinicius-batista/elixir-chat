defmodule ChatWeb.Schema.RoomsTypes do
  use Absinthe.Schema.Notation

  @desc "Room object"
  object :room do
    field(:owner_id, :id)
    field(:name, :string)
    field(:description, :string)
  end
end
