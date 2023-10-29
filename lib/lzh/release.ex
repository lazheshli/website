defmodule Lzh.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :lzh

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  def import_json(json_path, election_id) do
    load_app()

    election = Lzh.Elections.get_election!(election_id)

    json_path
    |> File.read!()
    |> Jason.decode!()
    |> Enum.map(&import_json_item(&1, election))
  end

  defp import_json_item(row_data, election) do
    party =
      case Lzh.Politicians.get_party(row_data["party"]) do
        nil ->
          {:ok, party} = Lzh.Politicians.create_party(%{name: row_data["party"]})
          party

        %{} = party ->
          party
      end

    politician =
      case Lzh.Politicians.get_politician(row_data["politician"], party) do
        nil ->
          {:ok, politician} =
            Lzh.Politicians.create_politician(%{
              name: row_data["politician"],
              party_id: party.id,
              town: Map.get(row_data, "town", "")
            })

          politician

        %{} = politician ->
          politician
      end

    date =
      row_data["date"]
      |> String.split(".")
      |> Enum.map(&String.to_integer/1)
      |> (fn [day, month, year] ->
            {:ok, date} = Date.new(year, month, day)
            date
          end).()

    tv_show_minute =
      case Integer.parse(row_data["tv_show_minute"]) do
        {integer, _rest} -> integer
        :error -> raise "tv_show_minute is not a number"
      end

    sources =
      row_data
      |> Map.keys()
      |> Enum.filter(&String.starts_with?(&1, "source_"))
      |> Enum.sort()
      |> Enum.map(fn key -> row_data[key] end)
      |> Enum.reject(fn value -> value == "" end)

    {:ok, statement} =
      Lzh.Statements.create_statement(%{
        election_id: election.id,
        politician_id: politician.id,
        date: date,
        tv_show: row_data["tv_show"],
        tv_show_url: row_data["tv_show_url"],
        tv_show_minute: tv_show_minute,
        statement: row_data["statement"],
        response: row_data["response"],
        sources: sources
      })

    statement
  end
end
