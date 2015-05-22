defmodule ExampleApp.SessionController do
  use ExampleApp.Web, :controller
  alias Passport.SessionManager
  alias ExampleApp.User

  plug :action

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case SessionManager.login(conn, session_params) do
      {:ok, conn, user} ->
        conn
        |> put_flash(:info, "Login succesful.")
        |> redirect(to: page_path(conn, :index))
       {:error, conn} ->
         conn
         |> put_flash(:info, "Email or password incorrect.")
         |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    SessionManager.logout(conn)
    |> put_flash(:info, "Logged out succesfully.")
    |> redirect(to: page_path(conn, :index))
  end

end
