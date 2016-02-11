defmodule Passport.Plug do
  import Plug.Conn

  @resource Application.get_env(:passport, :resource)
  @repo Application.get_env(:passport, :repo)

  def current_user(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && @repo.get(@resource, user_id)
    assign(conn, :current_user, user)
  end
end
