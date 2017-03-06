defmodule <%= inspect schema.repo %>.Migrations.Create<%= inspect schema.module %> do
  use Ecto.Migration

  def change do
    create table(:<%= schema.table %>) do
      add :email, :string

      timestamps()
    end

    create unique_index(:<%= schema.table %>, [:email])
  end
end
