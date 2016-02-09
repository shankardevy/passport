defmodule ExampleApp.RegistrationController do
  use ExampleApp.Web, :controller

  alias ExampleApp.User

  def new(conn, _params) do
    changeset = User.changeset(%ExampleApp.User{})
    conn
    |> render(:new, changeset: changeset)
  end

  def create(conn, %{"user" => registration_params}) do
    changeset = User.registration_changeset(%User{}, registration_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account created!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render(:new, changeset: changeset)
    end
  end

end
