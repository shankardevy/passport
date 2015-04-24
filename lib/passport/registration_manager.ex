defmodule Passport.RegistrationManager do
  alias Ecto.Changeset
  import Passport.Model

  def register(params) do
    changeset = Changeset.cast(user_model.__struct__, params, ~w(email))
    |> set_hashed_password
    |> Changeset.validate_change(:email, &presence_validator/2)
    |> Changeset.validate_unique(:email, on: repo)

    case changeset.valid? do
      true ->
        repo.insert(changeset)
        {:ok}
      _ ->
        {:error, changeset}
    end
  end


  def set_hashed_password(changeset = %{params: %{"password" => password}}) when password != "" and password != nil do
    hashed_password = Comeonin.Bcrypt.hashpwsalt(password)

    changeset
    |> Changeset.put_change(:crypted_password, hashed_password)
  end
  def set_hashed_password(changeset) do
    changeset
    |> Changeset.add_error(:password, :required)
  end

  defp presence_validator(field, nil), do: [{field, :required}]
  defp presence_validator(field, ""), do: [{field, :required}]
  defp presence_validator(field, _), do: []

end
