defmodule Mix.Tasks.Passport.Setup do
  use Mix.Task

  @shortdoc "Generates controller, model and views for authentication resource"

  @moduledoc """

  """

  def run(_) do
    paths = [".", :passport]
    with :ok <- generate_account(paths),
         :ok <- generate_auth(paths),
         :ok <- generate_web(paths),
         :ok <- generate_config() do
           print_shell_instructions()
         end
  end

  defp generate_account(paths) do
    args = ["Account", "User", "users"]
    {context, schema} = Mix.Tasks.Phx.Gen.Html.build(args)
    binding = [context: context, schema: schema]

    Mix.Phoenix.copy_from paths, "priv/templates/account", "", binding, [
      {:eex, "user_schema.ex", context.schema.file},
      {:eex, "user_migration.exs", "priv/repo/migrations/#{timestamp()}_create_passport_user_table.exs"},
      {:eex, "account_context.ex", context.file},
    ]
    :ok
  end

  defp generate_auth(paths) do
    args = ["Auth", "Password", "passwords"]
    {context, schema} = Mix.Tasks.Phx.Gen.Html.build(args)
    binding = [context: context, schema: schema]

    Mix.Phoenix.copy_from paths, "priv/templates/auth", "", binding, [
      {:eex, "password_schema.ex", context.schema.file},
      {:eex, "password_migration.exs", "priv/repo/migrations/#{timestamp()}_create_passport_password_table.exs"},
      {:eex, "auth_context.ex", context.file},
    ]
    :ok
  end

  defp generate_web(paths) do
    web_prefix = Mix.Phoenix.web_prefix()
    binding = [
      web_module: Mix.Phoenix.base <> ".Web",
      account_module: Mix.Phoenix.base <> ".Account",
      auth_module: Mix.Phoenix.base <> ".Auth"
    ]

    Mix.Phoenix.copy_from paths, "priv/templates/web", "", binding, [
      {:eex, "session_controller.ex", Path.join(web_prefix, "controllers/session_controller.ex")},
      {:eex, "session_view.ex", Path.join(web_prefix, "views/session_view.ex")},
      {:eex, "login.html.eex", Path.join(web_prefix, "templates/session/new.html.eex")},
      {:eex, "registration_controller.ex", Path.join(web_prefix, "controllers/registration_controller.ex")},
      {:eex, "registration_view.ex", Path.join(web_prefix, "views/registration_view.ex")},
      {:eex, "register.html.eex", Path.join(web_prefix, "templates/registration/new.html.eex")}
    ]
    :ok
  end

  defp generate_config() do
    {:ok, file} = File.open("./config/config.exs", [:append, :utf8])

    passport_config = """

    config :passport,
      repo: #{Mix.Phoenix.base() <> ".Repo"},
      account_module: #{Mix.Phoenix.base() <> ".Account"},
      account_user: #{Mix.Phoenix.base() <> ".Account.User"},
      auth_keys: ["email"],
      auth_module: #{Mix.Phoenix.base() <> ".Auth"},
      enabled_auths: [Passport.Password],
      auth_password: #{Mix.Phoenix.base() <> ".Auth.Password"}
    """

    Mix.shell.info [:green, "* updating config/config.exs"]
    IO.write(file, passport_config)
    :ok = File.close(file)
  end

  defp print_shell_instructions() do
    base = Mix.Phoenix.base()
    Mix.shell.info """
        `config/config.exs` file has been appended with Passport config as below:

        Just add the following changes to your router.ex

        1. Modify your "/" scope to include the following paths.

          scope "/", #{base}.Web do
            ...
            get "/login", SessionController, :new
            post "/session", SessionController, :create
            get "/logout", SessionController, :delete
            get "/register", RegistrationController, :new
            post "/register", RegistrationController, :create
          end

        2. Add the following plug to your pipeline
          ```
          import #{base}.Auth, only: [load_current_user: 2]
          pipeline :browser do
            ...
            plug :load_current_user
          end
        3. Add the following code to your layout `app.html.eex`
            <%= if user = #{base}.Auth.current_user(@conn) do %>
              <%= "Logged in as \#{user.email}" %>
              <a href="/logout">Logout</a>
            <% else %>
              <a href="/register">Register</a>
              <a href="/login">Login</a>
            <% end %>
    """
  end

  defp timestamp do
    :timer.sleep(1000) # hack to avoid two consecutive migrations from having having the same timestamp.
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end
  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end
