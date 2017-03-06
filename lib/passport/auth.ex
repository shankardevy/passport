defmodule Passport.Auth do
  import Plug.Conn
  defmacro __using__(_opts) do
    quote do
      import Plug.Conn
      import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
      unquote(define_enabled_type_defs())
      unquote(plugs())
    end
  end

  defp plugs() do
    quote do

      @doc """
      Plug that validates the details and signs in the account.
      """
      def login(type, conn, params) do
        with account when account != nil <- Passport.Auth.get_account(params),
             true <- valid_credential?(type, account, Map.get(params, "password"))
        do
          {:ok, Passport.Auth.do_login(conn, account)}
        else
          _ ->
          {:error, conn}
        end
      end

      @doc """
      Plug that signs out the account.
      """
      def logout(conn, params \\ []) do
        conn
        |> configure_session(drop: true)
      end

      @doc """
      Load the current user into conn
      """
      def load_current_user(conn, opts) do
        with user_id when user_id != nil <- get_session(conn, :user_id),
             user <- Passport.Config.account_module.get_user(user_id) do
           conn
           |> assign(:current_user, user)
        else
          _ ->
          conn
        end
      end

      @doc """
      Helper function to get current user from conn
      """
      def current_user(conn, _opts \\ []) do
        Map.get(conn.assigns, :current_user)
      end

      def require_login(conn, opts) do
        if (user = current_user(conn)) do
          conn
        else
          conn
          |> put_session(:last_visit_path, conn.request_path)
          |> put_flash(:info, opts[:message])
          |> redirect(to: opts[:redirect_path])
        end
      end

      def redirect_back_or_to(conn, path) do
        path = case get_session(conn, :last_visit_path) do
          nil               -> path
          last_visit_path   -> last_visit_path
        end
        conn
        |> delete_session(:last_visit_path)
        |> redirect(to: path)
      end

    end
  end

  def do_login(conn, user) do
    conn
    |> fetch_session
    |> put_session(:user_id, user.id)
    |> assign(:current_user, user)
    |> configure_session(renew: true)
  end

  defp define_enabled_type_defs() do
    enabled_auths = Passport.Config.enabled_auths
                    |> Enum.map(fn(module) ->
                      auth_type = Phoenix.Naming.resource_name(module) |> String.to_atom
                      {auth_type, module}
                    end)

    quote bind_quoted: [enabled_auths: enabled_auths] do
      Enum.each enabled_auths, fn ({type, module}) ->
        def valid_credential?(unquote(type), account, password) do
           apply(unquote(module), :valid_credential?, [account, password])
        end
      end
    end
  end

  def get_account(params) do
    query_clause = Map.take(params, Passport.Config.auth_keys)
                   |> Enum.map(fn({k,v}) ->
                     {String.to_atom(k), v}
                   end)
    Passport.Config.account_user
    |> Passport.Config.repo.get_by(query_clause)
  end
end
