defmodule Passport.RegistrationManager do
  import Ecto.Changeset
  import Passport.Model

  def register(params) do
    changeset = user_model.changeset(user_model.__struct__, params)

    changeset = changeset
      |> validate_format(:email, ~r/@/)
      |> update_change(:email, &String.downcase/1)
      |> set_hashed_password
      |> unique_constraint(:email)

    repo.insert(changeset)
  end

  def downcase_email(changeset = %{params: %{"email" => email}}) do
    changeset
    |> put_change(:email, String.downcase(email))
  end

  def set_hashed_password(changeset = %{params: %{"password" => password}}) when password != "" and password != nil do
    hashed_password = Comeonin.Bcrypt.hashpwsalt(password)
    changeset
    |> put_change(:crypted_password, hashed_password)
  end
  def set_hashed_password(changeset) do
    changeset
    |> add_error(:password, "is required")
  end

end
