defmodule <%= base %>.RegistrationController do
  use <%= base %>.Web, :controller

  alias <%= module %>

  def new(conn, _params) do
    changeset = <%= scoped %>.changeset(%<%= module %>{})
    conn
    |> render(:new, changeset: changeset)
  end

  def create(conn, %{<%= inspect singular %> => registration_params}) do
    changeset = <%= scoped %>.registration_changeset(%<%= scoped %>{}, registration_params)
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Account created!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render(:new, changeset: changeset)
    end
  end

end
