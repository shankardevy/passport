defmodule AuthenticationPlugTest do
  use ExUnit.Case, async: false
  import Mock
  use Plug.Test
  alias Passport.AuthenticationPlug
  alias Passport.SessionHelper

  @default_opts AuthenticationPlug.init([])
  @only_opts AuthenticationPlug.init([only: [:index]])
  @except_opts AuthenticationPlug.init([except: [:index]])
  @both_opts AuthenticationPlug.init([except: [:index], only: [:index]])
  @custom_flash_key AuthenticationPlug.init([flash_key: :warning])

  test "it checks if the user is logged in if the options are default" do
    with_mock Passport.SessionManager, [:passthrough], [logged_in?: fn(_conn) -> true end] do
    conn = conn(:get, "/")
      |> Plug.Conn.put_private(:phoenix_action, :index)
      |> SessionHelper.session_with_user
      |> AuthenticationPlug.call(@default_opts)

    assert called Passport.SessionManager.logged_in?(conn)
    end
  end

  test "it checks if the user is logged in if only only action" do
    with_mock Passport.SessionManager, [:passthrough], [logged_in?: fn(_conn) -> true end] do
    conn = conn(:get, "/")
      |> Plug.Conn.put_private(:phoenix_action, :index)
      |> SessionHelper.session_with_user
      |> AuthenticationPlug.call(@only_opts)

    assert called Passport.SessionManager.logged_in?(conn)
    end
  end

  test "it does not check if the user is logged in if except includes action" do
    with_mock Passport.SessionManager, [:passthrough], [logged_in?: fn(_conn) -> true end] do
    conn = conn(:get, "/")
      |> Plug.Conn.put_private(:phoenix_action, :index)
      |> SessionHelper.session_with_user
      |> AuthenticationPlug.call(@except_opts)

    assert !called Passport.SessionManager.logged_in?(conn)
    end
  end

  test "it uses except in preference to includes" do
    with_mock Passport.SessionManager, [:passthrough], [logged_in?: fn(_conn) -> true end] do
    conn = conn(:get, "/")
      |> Plug.Conn.put_private(:phoenix_action, :index)
      |> SessionHelper.session_with_user
      |> AuthenticationPlug.call(@both_opts)

    assert !called Passport.SessionManager.logged_in?(conn)
    end
  end

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
