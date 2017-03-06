defmodule <%= inspect context.module %> do
  use Passport.Auth
  import Ecto.{Query, Changeset}, warn: false

  alias <%= inspect schema.module %>
  alias <%= inspect schema.repo %>

  def create_password(attrs \\ %{}) do
    %Password{}
    |> password_changeset(attrs)
    |> Repo.insert()
  end

  defp password_changeset(%Password{} = password, attrs) do
    password
    |> cast(attrs, [:password_hash, :user_id])
    |> put_hashed_password(attrs)
    |> validate_required([:password_hash, :user_id])
  end


  defp put_hashed_password(changeset, %{password: pass}) do
    put_change(changeset, :password_hash, Passport.Password.Crypto.hash(pass))
  end

end
