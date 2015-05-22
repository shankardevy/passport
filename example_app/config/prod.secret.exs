use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :example_app, ExampleApp.Endpoint,
  secret_key_base: "+3TaOZhAbTa93DkYC8myGgx30ODUD8crPbejlIoY1ayhqbyUG3CZZIg2n2e6hnwe"

# Configure your database
config :example_app, ExampleApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "example_app_prod",
  size: 20 # The amount of database connections in the pool
