use Mix.Config

# Do not print debug messages in production
config :logger, level: :debug

config :viztube_web, ViztubeWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "${HOST}"],
  http: [port: "${PORT}"],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: "${SECRET_KEY_BASE}",
  server: true,
  root: "."

config :viztube, Viztube.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "${DB_HOSTNAME}",
  username: "${DB_USERNAME}",
  password: "${DB_PASSWORD}",
  database: "${DB_NAME}",
  ssl: false,
  pool_size: 10

config :tub_ex, TubEx,
  api_key: "${YT_API_KEY}"
