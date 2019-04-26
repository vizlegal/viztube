defmodule Viztube.Application do
  @moduledoc """
  The Viztube Application Service.

  The viztube system business domain lives in this application.

  Exposes API to clients such as the `ViztubeWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Viztube.Repo, []),
      worker(Viztube.Scheduler, [])
    ]

    opts = [strategy: :one_for_one, name: Viztube.Supervisor]

    Supervisor.start_link(children, opts)

  end
end
