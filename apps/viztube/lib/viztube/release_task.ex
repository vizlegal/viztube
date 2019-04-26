defmodule Viztube.ReleaseTasks do
  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  @myapps [
    :viztube
  ]

  @repos [
    Viztube.Repo
  ]

  def createdb do
    
    # Ensure all apps have started
    Enum.each(@myapps, fn(x) ->
      :ok = Application.load(x)
    end)
        
    # Start postgrex and ecto
    Enum.each(@start_apps, fn(x) ->
      {:ok, _} = Application.ensure_all_started(x)
    end)
        
    # Create the database if it doesn't exist
    Enum.each(@repos, &ensure_repo_created/1)
        
    :init.stop()
  end

  def migrate do

    IO.puts "Starting dependencies"
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for myapp
    IO.puts "Starting repos"
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))

    # Run migrations
    Enum.each(@myapps, fn(myapp) ->
      run_migrations_for(myapp)
      # Run the seed script if it exists
      seed_script = seed_path(myapp)
      if File.exists?(seed_script) do
        IO.puts "Running seed script for #{myapp}"
        Code.eval_file(seed_script)
      end

    end)

  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(Viztube.Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
  defp seed_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])

  defp ensure_repo_created(repo) do
    case repo.__adapter__.storage_up(repo.config) do
      :ok -> :ok
      {:error, :already_up} -> :ok
      {:error, term} -> {:error, term}
    end
  end

end
