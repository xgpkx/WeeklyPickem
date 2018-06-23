defmodule WeeklyPickemWeb.AdminPageController do
  use WeeklyPickemWeb, :controller

  plug :put_layout, "app.html"
  plug :put_view, WeeklyPickemWeb.PageView


  def index(conn, _params) do
    render conn, "admin.html"
  end

  def team_update(conn, _params) do
    WeeklyPickem.Services.TeamUpdate.update()
    text conn, "Success: Ran Team Update Service!"
  end

  def match_update(conn, _params) do
    WeeklyPickem.Services.MatchUpdate.update()
    text conn, "Success: Ran Match Update Service!"
  end

  def run_migrations(conn, _params) do
    IO.inspect(migrations_path(WeeklyPickem.Repo))
    Ecto.Migrator.run(WeeklyPickem.Repo, migrations_path(WeeklyPickem.Repo), :up, all: true)
    text conn, "Success: Ran ecto migrator!"
  end


  # Migration methods
  defp repos, do: Application.get_env(WeeklyPickem, :ecto_repos, [])

  defp migrate, do: Enum.each(repos(), &run_migrations_for/1)

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts "Running migrations for #{app}"
    
  end

  defp migrations_path(repo), do: priv_path_for(repo, "migrations")

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split |> List.last |> Macro.underscore
    Path.join([priv_dir(app), repo_underscore, filename])
  end
end
