use Mix.Config

config :viztube, ecto_repos: [Viztube.Repo]

# chech videos for saved search every 15 mins
# check video count for subscribed channels every 2 hours
config :viztube, Viztube.Scheduler,
  jobs: [
    check_query: [
      schedule: {:cron, "*/15 * * * *"},
      task: {Viztube.Services.QueryCheck, :run, []}
    ],
    channel_check: [
      schedule: {:cron, "0 */2 * * *"},
      task: {Viztube.Services.ChannelCheck, :run, []}
    ]
  ]

import_config "#{Mix.env}.exs"
