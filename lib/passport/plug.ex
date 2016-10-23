defmodule Passport.Plug do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  def current_user(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && fetch_user_by_id(user_id)
    assign(conn, :current_user, user)
  end

  def authenticate(conn, _) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_flash(:info, "You must be signed in")
        |> redirect(to: "/login")
        |> put_session("redirect_to", conn.request_path)
        |> configure_session(renew: true)
        |> halt
      _ ->
         conn
    end
  end

  defp fetch_user_by_id(id) do
    Passport.Config.repo.get(Passport.Config.resource, id)
  end

end
