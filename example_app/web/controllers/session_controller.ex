defmodule ExampleApp.SessionController do
  use ExampleApp.Web, :controller

  alias ExampleApp.User
  alias Passport.Session


  def new(conn, _) do
    conn
    |> render(:new)
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case Session.login(conn, email, pass) do
    {:ok, conn} ->
      conn
      |> put_flash(:info, "Welcome back!")
      |> redirect(to: page_path(conn, :index))
    {:error, _reason, conn} ->
      conn
      |> put_flash(:error, "Invalid username/password combination")
      |> render(:new)
    end
  end

  def delete(conn, _) do
    conn
    |> Session.logout()
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: session_path(conn, :new))
  end
end
