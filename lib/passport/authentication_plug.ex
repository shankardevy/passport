defmodule Passport.AuthenticationPlug do
  import Plug.Conn
  alias Phoenix.Controller

  def init(opts) do
    Dict.merge(defaults, opts)
  end

  def call(conn, opts) do
    if conn.private.phoenix_action |> authenticate?(opts) do
      authenticate(conn, opts) 
    else
      conn
    end
  end

  defp defaults do
    [
      flash_key: :info,
      flash_msg: "You must be logged in.",
      redirect_to: "/login"
    ]
  end

  defp authenticate(conn, opts) do
    case Passport.SessionManager.logged_in?(conn) do
      true ->
        conn
      false ->
        conn
          |> Controller.put_flash(opts[:flash_key], opts[:flash_msg])
          |> Controller.redirect(to: opts[:redirect_to])
          |> halt
    end
  end

  defp authenticate?(phoenix_action, opts) do
    cond do
      Dict.has_key?(opts, :except) and 
        Enum.member?(opts[:except], phoenix_action) ->
          false
      Dict.has_key?(opts, :only) and
        Enum.member?(opts[:only], phoenix_action) ->
          true
      Dict.has_key?(opts, :only) ->
        false
      true ->
        true
    end
  end
end
