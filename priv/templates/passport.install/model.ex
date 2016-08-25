defmodule <%= module %> do
  use <%= base %>.Web, :model
  alias Passport.Password

  schema <%= inspect plural %> do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps
  end

  def changeset(model, params \\ :empty) do model
    |> cast(params)
    |> validate_required(~w(email))
    |> validate_length(:email, min: 1, max: 150)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do model
    |> changeset(params)
    |> cast(params)
    |> validate_required(~w(password))
    |> validate_length(:password, min: 6, max: 100)
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Password.hash(pass))
        _ ->
          changeset
    end
  end

end
