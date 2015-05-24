[![Build Status](https://travis-ci.org/opendrops/passport.svg?branch=master)](https://travis-ci.org/opendrops/passport)
[![Coverage Status](https://coveralls.io/repos/opendrops/passport/badge.svg?branch=master)](https://coveralls.io/r/opendrops/passport?branch=master)

Passport
========

Passport provides authentication for [Phoenix](http://github.com/phoenixframework/phoenix) applications.

How to use?
----------

* add `passport` to your phoenix project's `mix.exs`

```
defp deps do
  ...
   {:passport, "~> 0.0.1"}
  ...
end
```

* run `mix do deps.get, compile` to download and compile the dependency.

* create an ecto model for your user with fields `email` and `crypted_password`. You may add additional fields if you need. Typically you can create a model in phoenix using the below command
  `mix phoenix.gen.model YourApp.User users email crypted_password`

* edit your project's `config/config.exs` file and configure passport. Passport basically needs to know the Repo name and the user module name.

```  
config :passport,
  repo: YourApp.Repo,
  user_class: YourApp.User
```

Routes
-----
Passport does not create routes or controllers for you. Rather, it only provides easy to use module and methods that you can use in your own router and controller. Overriding default routes and controllers have been one of the pain that I wanted to avoid in passport.

Add the following routes to your router.ex. Change the path/controller name as per your application's needs.
```
scope "/", YourApp do
...
  get "/login", SessionController, :new
  post "/login", SessionController, :create
  get "/logout", SessionController, :delete

  get "/signup", RegistrationController, :new
  post "/signup", RegistrationController, :create
end
```

Here we assume that

SessionController
* login form is shown in the url '/login' (GET)
* login form gets submitted to the url '/login' (POST)
* user get logout when visiting the path '/logout' (GET)

RegistrationController
* registration form is shown in the url '/signup' (GET)
* registration form gets submitted to the url '/signup' (POST)

Sample session_controller.ex
-------------------

```
defmodule YourApp.SessionController do
  use YourApp.Web, :controller
  alias Passport.SessionManager
  alias YourApp.User

  plug :action

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case SessionManager.login(conn, session_params) do
      {:ok, conn, user} ->
        conn
        |> put_flash(:info, "Login succesful.")
        |> redirect(to: page_path(conn, :index))
       {:error, conn} ->
         conn
         |> put_flash(:info, "Email or password incorrect.")
         |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    SessionManager.logout(conn)
    |> put_flash(:info, "Logged out succesfully.")
    |> redirect(to: page_path(conn, :index))
  end

end
```

Sample registration_controller.ex
-------------------

```
defmodule YourApp.RegistrationController do
  use YourApp.Web, :controller

  alias YourApp.User
  alias Passport.RegistrationManager

  plug :action

  def new(conn, _params) do
    conn
    |> put_session(:foo, "bar")
    |> render("new.html")
  end

  def create(conn, %{"registration" => registration_params}) do
    case RegistrationManager.register(registration_params) do
      {:ok} -> conn
         |> put_flash(:info, "Registration success")
         |> redirect(to: page_path(conn, :index))
      _ -> conn
         |> put_flash(:info, "Registration failed")
         |> redirect(to: page_path(conn, :index))
    end
  end

end

```

Create views
------
Create 2 simple views for the registration and session controller in `web/views/` folder as below:

web/views/session_view.ex
----
defmodule ExampleApp.SessionView do
  use ExampleApp.Web, :view
end

web/views/registration_view.ex
-----
defmodule ExampleApp.RegistrationView do
  use ExampleApp.Web, :view
end


Sample session/new.html for displaying login form
-------------

```
<%= form_for @conn, session_path(@conn, :create), [name: :session], fn f -> %>
  <div class="form-group">
    <label>Email</label>
    <%= text_input f, :email, class: "form-control" %>
  </div>

  <div class="form-group">
    <label>Password</label>
    <%= password_input f, :password, class: "form-control" %>
  </div>

  <div class="form-group">
    <%= submit "Login", class: "btn btn-primary" %>
  </div>
<% end %>
```


Sample registration/new.html for displaying login form
-------------

```
<%= form_for @conn, registration_path(@conn, :create), [name: :registration], fn f -> %>
  <div class="form-group">
    <label>Email</label>
    <%= text_input f, :email, class: "form-control" %>
  </div>

  <div class="form-group">
    <label>Password</label>
    <%= password_input f, :password, class: "form-control" %>
  </div>

  <div class="form-group">
    <%= submit "Signup", class: "btn btn-primary" %>
  </div>
<% end %>
```

Convenient Shorthands
-------------------
Passport allows to check if an user is signed in or not. You can import the following in web.ex

```
def view do
    quote do
      ...
      import Passport.SessionManager, only: [current_user: 1, logged_in?: 1]
      ...
    end
end
```

Then inside your views you can call both `current_user` and `logged_in?` as below:

```
<%= if logged_in?(@conn) do %>
  <%=  current_user(@conn).email %>
<% end %>
```
