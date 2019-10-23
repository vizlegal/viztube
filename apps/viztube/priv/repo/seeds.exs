# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Viztube.Repo.insert!(%Viztube.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Viztube.Accounts.create_user(%{email: "admin@local.vl", admin: true, tags: ""})
