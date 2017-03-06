defmodule <%= inspect schema.repo %>.Migrations.Create<%= inspect schema.module %> do
  use Ecto.Migration

  def change do
    create table(:<%= schema.table %>) do
      add :password_hash, :string
      add :user_id, :integer

      timestamps()
    end

    create index(:<%= schema.table %>, [:user_id])
  end
end
