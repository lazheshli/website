defmodule Lzh.StatementsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lzh.Statements` context.
  """
  import Lzh.{ElectionsFixtures, PoliticiansFixtures}

  @doc """
  Generate a statement.
  """
  def statement_fixture(attrs \\ %{}) do
    {:ok, statement} =
      attrs
      |> Map.put_new_lazy(:election_id, fn ->
        election = election_fixture()
        election.id
      end)
      |> Map.put_new_lazy(:politician_id, fn ->
        politician = politician_fixture()
        politician.id
      end)
      |> Map.put_new(:date, ~D[2023-08-18])
      |> Map.put_new(:tv_show, "TV Show #{System.unique_integer([:positive])}")
      |> Map.put_new(:tv_show_url, "http://example.com")
      |> Map.put_new(:tv_show_minute, 42)
      |> Map.put_new(:statement, "Lorem ipsum dolor sit amet.")
      |> Map.put_new(:response, "Consectetur adipiscing elit.")
      |> Map.put_new(:sources, ["http://example.com"])
      |> Lzh.Statements.create_statement()

    statement
  end
end
