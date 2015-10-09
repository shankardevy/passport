defmodule Passport.AuthenticationPlug do
  import Plug.Conn
  alias Phoenix.Controller

  @admin_defaults [
    flash_key: :info,
    flash_msg: "You do not have sufficient permissions to view this page.",
    redirect_to: "/"
  ]

  @login_defaults [
    flash_key: :info,
    flash_msg: "You must be logged in.",
    redirect_to: "/login"
  ]

  @logout_defaults [
    flash_key: :info,
    flash_msg: "You must be logged in.",
    redirect_to: "/login"
  ]

  def require_admin(conn, opts \\ []) do
    opts = Dict.merge(@admin_defaults, opts)
    case Passport.SessionManager.admin?(conn) do
      true ->
        conn
      false ->
        auth_redirect(conn, opts)
    end
  end

  def require_login(conn, opts \\ []) do
    opts = Dict.merge(@login_defaults, opts)
    case Passport.SessionManager.logged_in?(conn) do
      true ->
        conn
      false ->
        auth_redirect(conn, opts)
    end
  end

  def require_logout(conn, opts \\ []) do
    opts = Dict.merge(@logout_defaults, opts)
    case Passport.SessionManager.logged_out?(conn) do
      true ->
        conn
      false ->
        auth_redirect(conn, opts)
    end
  end

  defp auth_redirect(conn, opts) do
    conn
      |> Controller.put_flash(opts[:flash_key], opts[:flash_msg])
      |> Controller.redirect(to: opts[:redirect_to])
      |> halt
  end
end
