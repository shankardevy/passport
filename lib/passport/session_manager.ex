defmodule Passport.SessionManager do
  import Passport.Model

  def login(conn, credentials) do
    user = find_user_by_email(credentials["email"])
    case authenticate(user, credentials["password"]) do
      true ->
        {:ok, conn |> Plug.Conn.put_session(:current_user, user.id), user }
      _ ->
        {:error, conn}
    end
  end

  def logout(conn) do
    conn |> Plug.Conn.delete_session(:current_user)
  end

  def authenticate(nil, _) do
    Comeonin.Bcrypt.dummy_checkpw
  end

  def authenticate(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.crypted_password)
  end

  def current_user(conn) do
    uid = Plug.Conn.get_session(conn, :current_user) || 0
    find_user_by_id(uid)
  end

  def logged_in?(conn) do
    case current_user(conn) do
      nil -> false
      _ -> true
    end
  end

  def logged_out?(conn) do
    !logged_in?(conn)
  end
end
