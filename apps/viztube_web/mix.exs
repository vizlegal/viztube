defmodule ViztubeWeb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :viztube_web,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ViztubeWeb.Application, []},
      extra_applications: [
        :sentry,
        :logger,
        :runtime_tools,
        :formex,
        :timex,
        :bamboo,
        :bamboo_smtp,
        :scrivener_html
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_active_link, "~> 0.1.1"},
      {:gettext, "~> 0.11"},
      {:viztube, in_umbrella: true},
      {:cowboy, "~> 1.0"},
      {:phoenix_slime, github: "slime-lang/phoenix_slime"},
      {:neotoma, "~> 1.7"},
      {:formex, "~> 0.5.0"},
      {:formex_vex, "~> 0.1.0"},
      {:ja_serializer, "~> 0.12.0"},
      {:guardian, "~> 1.0-beta"},
      {:timex, "~> 3.1"},
      {:bamboo, "~> 0.8"},
      {:bamboo_smtp, "~> 1.4.0"},
      {:scrivener_html, "~> 1.7"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
