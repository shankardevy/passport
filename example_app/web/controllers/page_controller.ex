defmodule ExampleApp.PageController do
  use ExampleApp.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
