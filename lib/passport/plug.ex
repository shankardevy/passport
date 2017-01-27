defmodule Passport.Plug do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  def current_user(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && fetch_user_by_id(user_id)
    assign(conn, :current_user, user)
  end

  def authenticate(conn, _) do
    authenticate_env(:prod, conn)
  end

  defp authenticate_env(:test, conn) do
    case conn.params["as"] do
      nil ->
        conn
      id ->
        user = fetch_user_by_id(id)
        conn = conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
    end
    conn
  end

  defp authenticate_env(_, conn) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_flash(:info, "You must be signed in")
        |> redirect(to: "/login")
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
