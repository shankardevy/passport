defmodule ExampleApp.PageController do
  use ExampleApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
