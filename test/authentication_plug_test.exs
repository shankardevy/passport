defmodule AuthenticationPlugTest do
  use ExUnit.Case, async: false
  import Mock
  use Plug.Test
  alias Passport.AuthenticationPlug
  alias Passport.SessionHelper

  # test "it returns a custom flash key" do
  #   with_mock Passport.SessionManager, [:passthrough], [logged_in?: fn(conn) -> false end] do
  #   conn = conn(:get, "/")
  #     |> Plug.Conn.put_private(:phoenix_action, :index)
  #     |> SessionHelper.session_with_user
  #     |> AuthenticationPlug.call(@custom_flash_key)

  #   import IEx; IEx.pry
  #   assert called Passport.SessionManager.logged_in?(conn)
  #   end
  # end
end
