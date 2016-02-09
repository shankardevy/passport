use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :example_app, ExampleApp.Endpoint,
  secret_key_base: "Ek9P4d7ptUFZY2i3f1YvWcqBgLPbBp9RrPMKBfSvSQkAaSG+2pkEos0ol8/d1Zmo"

# Configure your database
config :example_app, ExampleApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "example_app_prod",
  pool_size: 20
