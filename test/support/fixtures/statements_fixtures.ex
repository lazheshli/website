defmodule Lzh.StatementsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lzh.Statements` context.
  """
  import Lzh.PoliticiansFixtures

  @doc """
  Generate a statement.
  """
  def statement_fixture(attrs \\ %{}) do
    {:ok, statement} =
      attrs
      |> Map.put_new_lazy(:avatar_id, fn ->
        # forward politician_id and election_id, if present, to the avatar
        avatar =
          attrs
          |> Map.filter(fn {key, _value} ->
            Enum.member?([:politician_id, :election_id], key)
          end)
          |> avatar_fixture()

        avatar.id
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
