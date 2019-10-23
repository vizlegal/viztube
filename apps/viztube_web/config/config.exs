# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :viztube_web,
  namespace: ViztubeWeb,
  ecto_repos: [Viztube.Repo]

# Configures the endpoint
config :viztube_web, ViztubeWeb.Endpoint,
  # url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: ViztubeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ViztubeWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :viztube_web, :generators,
  context_app: :viztube

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :formex,
  validator: Formex.Validator.Vex
  # translate_error: &App.ErrorHelpers.translate_error/1, # optional, from /web/views/error_helpers.ex
  # template: Formex.Template.BootstrapHorizontal,        # optional, can be overridden in a template
  # template_options: [                                   # optional, can be overridden in a template
    # left_column: "col-sm-2",
    # right_column: "col-sm-10"
  # ]

config :viztube_web, ViztubeWeb.Guardian,
  allowed_algos: ["HS512"],
  issuer: "Viztube",
  verify_module: Guardian.JWT,
  ttl: { 30, :days },
  verify_issuer: false,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: ViztubeWeb.GuardianSerializer

config :viztube_web, ViztubeWeb.Mailer,
  # adapter: Bamboo.LocalAdapter
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("SMTP_HOSTNAME"),
  hostname: System.get_env("SMTP_HOSTNAME"),
  port: 465,
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :if_available, # can be `:always` or `:never`
  allowed_tls_versions: [:"tlsv1", :"tlsv1.1", :"tlsv1.2"], # or {":system", ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  ssl: true,
  retries: 2

config :scrivener_html,
  routes_helper: ViztubeWeb.Router.Helpers,
  view_style: :semantic

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
