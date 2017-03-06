defmodule <%= web_module %>.SessionController do
  use <%= web_module %>, :controller
  alias <%= auth_module %>
  def new(conn, _) do
    conn
    |> render("new.html")
  end

  def create(conn, params) do
    case Auth.login(:password, conn, params["session"]) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Logged in!")
        |> redirect(to: "/")
      _ ->
        conn
        |> put_flash(:info, "Error signing in!")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "Logged out!")
    |> redirect(to: page_path(conn, :index))
  end
end
