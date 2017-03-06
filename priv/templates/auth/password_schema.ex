defmodule <%= inspect schema.module %> do
  use Ecto.Schema

  schema <%= inspect schema.table %> do
    field :password_hash, :string
    field :user_id, :integer

    timestamps()
  end
end
