use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :example_app, ExampleApp.Endpoint,
  secret_key_base: "PBAehDXBuhC+X7mlps7yD+cIL563ZyBxN/BDgD13OQegSrCCuEFz0NZlfyJLK+uf"

# Configure your database
config :example_app, ExampleApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "example_app_prod"
