# Passport
Passport is a ready to use authentication library for Phoenix. Using Passport is as easy as just running this simple command `$ mix passport.install`

Passport is designed to have minimal code hidden behind the library and expose all the controllers, templates and views in your project with some default values.

Passport is WIP. Bug reports and wish list from users are most welcome!

## Installation

  1. Add passport to your list of dependencies in `mix.exs`:

        def deps do
          [{:passport, "~> 0.0.4"}]
        end

  2. `$ mix do deps.get, compile`

  3. `$ mix passport.install`

  4. Follow the instruction shown on the screen to complete the installation
  
```
    Use Passport in your web/router.ex
        use Passport

    add the plug `:current_user` in your browser pipeline
        pipeline :browser do
          ...
          plug :current_user
        end
        
    Add the following routes to your browser scope in web/router.ex:

        get "/login", SessionController, :new
        post "/login", SessionController, :create
        get "/logout", SessionController, :delete
        get "/register", RegistrationController, :new
        post "/register", RegistrationController, :create
        get "/forget-password", PasswordController, :forget_password
        post "/reset-password", PasswordController, :reset_password

    Add Passport configuration in your config.exs like below:
        config :passport,
          resource: "#{binding[:module]}",
          repo: "#{binding[:base]}.Repo"

    Optionally, in your navigation you may to include this:

          <ul>
            <%= if @current_user do %>
              <li><%= @current_user.email %></li>
              <li><%= link "Log out", to: session_path(@conn, :delete) %></li>
            <% else %>
              <li><%= link "Login", to: session_path(@conn, :new) %></li>
              <li><%= link "Register", to: registration_path(@conn, :new) %></li>
            <% end %>
          </ul>
```

## Example

  1. `$ git clone git@github.com:opendrops/passport.git`

  2. `$ cd passport/example_app`

  3. `$ mix do deps.get, compile`

  4. `$ mix phoenix.server`

  Go to `http://localhost:4000` for a demo.

  
