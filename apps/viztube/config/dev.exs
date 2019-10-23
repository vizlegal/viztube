use Mix.Config

# Configure your database
config :viztube, Viztube.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "viztube_dev",
  hostname: System.get_env("DB_HOSTNAME") || "localhost",
  pool_size: 10

config :tub_ex, TubEx,
  api_key: "${YT_API_KEY}"
