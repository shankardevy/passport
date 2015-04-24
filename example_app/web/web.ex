defmodule ExampleApp.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use ExampleApp.Web, :controller
      use ExampleApp.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.
  
  Do NOT define functions inside the quoted expressions
  below.
  """

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2]

      # Import URL helpers from the router
      import ExampleApp.Router.Helpers

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      # Alias the data repository as a convenience
      alias ExampleApp.Repo

      # Import URL helpers from the router
      import ExampleApp.Router.Helpers
    end
  end

  def model do
    quote do
      use Ecto.Model
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
