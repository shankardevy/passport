defmodule <%= base %>.PasswordController do
  use <%= base %>.Web, :controller

  def new(conn, _) do
    conn
    |> render(:new)
  end

  # TODO
  def reset_password(conn, %{"user" => %{"email" => _email}}) do
    conn
    |> put_flash(:info, "Password reset link has been sent to your email address.")
    |> redirect(to: session_path(conn, :new))
  end
end
