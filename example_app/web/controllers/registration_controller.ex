defmodule ExampleApp.RegistrationController do
  use ExampleApp.Web, :controller

  alias ExampleApp.User
  alias Passport.RegistrationManager

  plug :action

  def new(conn, _params) do
    conn
    |> put_session(:foo, "bar")
    |> render("new.html")
  end

  def create(conn, %{"registration" => registration_params}) do
    case RegistrationManager.register(registration_params) do
      {:ok} -> conn
         |> put_flash(:info, "Registration success")
         |> redirect(to: page_path(conn, :index))
      _ -> conn
         |> put_flash(:info, "Registration failed")
         |> redirect(to: page_path(conn, :index))
    end
  end

end
