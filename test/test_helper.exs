ExUnit.start()

defmodule Passport.SessionHelper do
  use Plug.Test

  def session_with_user(conn) do
    opts = Plug.Session.init(store: :ets, key: "_my_app_session", secure: true, table: :session)
    conn
      |> Plug.Session.call(opts)
      |> Plug.Conn.fetch_session
      |> Plug.Conn.put_session(:current_user, 1)
  end
end
