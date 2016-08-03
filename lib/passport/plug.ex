defmodule Passport.Plug do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  def current_user(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && Passport.Config.repo.get(Passport.Config.resource, user_id)
    assign(conn, :current_user, user)
  end

  def authenticate(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
         conn |> put_flash(:info, "You must be signed in") |> redirect(to: "/login") |> halt
      _ ->
         conn
    end
  end

end
