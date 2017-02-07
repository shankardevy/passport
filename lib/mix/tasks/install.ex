defmodule Mix.Tasks.Passport.Install do
  use Mix.Task

  @shortdoc "Generates controller, model and views for authentication resource"

  @moduledoc """
  Generates a Phoenix resource for user authentication.

      mix passport.install

      or

      mix passport.install Admin admins

  The first argument is the module name for the user and the second argument is the plural form of the module name. If omitted, it uses default module name as User and its plural form users.

  The generated resource will contain:

    * a model in web/models
    * a controller, a view, and templates for User registration
    * a controller, a view, and templates for Session management
    * a controller, a view, and templates for Password reset
    * a migration file for the repository

  """
  def run(args) do
    {_, parsed, _} = OptionParser.parse(args)
    [singular, plural] = validate_args!(parsed)
    binding = Mix.Phoenix.inflect(singular)
    path    = binding[:path]
    migration = String.replace(path, "/", "_")
    binding = binding ++ [plural: plural,
                          template_singular: String.replace(binding[:singular], "_", " "),
                          template_plural: String.replace(plural, "_", " ")]
    IO.puts inspect binding
    Mix.Phoenix.check_module_name_availability!(binding[:module] <> "Controller")
    Mix.Phoenix.check_module_name_availability!(binding[:module] <> "View")

    files =
      [
        {:eex, "model.ex", "web/models/#{path}.ex"},
        {:eex, "migration.exs", "priv/repo/migrations/#{timestamp()}_create_#{migration}.exs"},
        {:eex, "session_view.ex", "web/views/session_view.ex"},
        {:eex, "registration_view.ex", "web/views/registration_view.ex"},
        {:eex, "password_view.ex", "web/views/password_view.ex"},
        {:eex, "registration_controller.ex", "web/controllers/registration_controller.ex"},
        {:eex, "session_controller.ex", "web/controllers/session_controller.ex"},
        {:eex, "password_controller.ex", "web/controllers/password_controller.ex"},
        {:eex, "session_new.html.eex",  "web/templates/session/new.html.eex"},
        {:eex, "registration_new.html.eex", "web/templates/registration/new.html.eex"},
        {:eex, "password_new.html.eex", "web/templates/password/new.html.eex"},
      ]

    Mix.Phoenix.copy_from paths(), "priv/templates/passport.install", "", binding, files

    instructions = """

    Use Passport in your web/router.ex
        use Passport

    add the plug `:current_user` in your browser pipeline
        pipeline :browser do
          ...
          plug :current_user
        end

    Add the following routes to your browser scope in web/router.ex:

        get "/login", SessionController, :new
        post "/session", SessionController, :create
        get "/logout", SessionController, :delete
        get "/join", RegistrationController, :new
        post "/register", RegistrationController, :create
        get "/passwords/new", PasswordController, :new
        post "/passwords", PasswordController, :reset

    Add Passport configuration in your config.exs like below:
        config :passport,
          resource: #{binding[:module]},
          repo: #{binding[:base]}.Repo

    Optionally, in your navigation you may to include this:

          <ul class="">
            <%= if @current_user do %>
              <li><%= @current_user.email %></li>
              <li><%= link "Log out", to: session_path(@conn, :delete) %></li>
            <% else %>
              <li><%= link "Login", to: session_path(@conn, :new) %></li>
              <li><%= link "Register", to: registration_path(@conn, :new) %></li>
            <% end %>
          </ul>

    Finally, update your repository:

        $ mix ecto.migrate

    """

    Mix.shell.info instructions

  end

  defp validate_args!([_singular, plural] = args) do
    cond do
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
  end

  defp validate_args!([]) do
    ["User", "users"]
  end

  defp validate_args!(_) do
    raise_with_help()
  end

  defp raise_with_help do
    Mix.raise """
    mix passport.install expects both singular and plural names

        mix passport.install User users

        or just type without any arguments to create a User resource

        mix passport.install
    """
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)

  defp paths do
    [".", :passport]
  end
end
