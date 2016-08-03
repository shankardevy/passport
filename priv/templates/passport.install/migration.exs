defmodule <%= base %>.Repo.Migrations.Create<%= scoped %> do
  use Ecto.Migration

  def change do
    create table(:<%= plural %>) do
      add :email, :string, null: false
      add :password_hash, :string      

      timestamps
    end

    create unique_index(:<%= plural %>, [:email])
  end
end
