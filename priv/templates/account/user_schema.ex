defmodule <%= inspect schema.module %> do
  use Ecto.Schema

  schema <%= inspect schema.table %> do
    field :email, :string

    timestamps()
  end
end
