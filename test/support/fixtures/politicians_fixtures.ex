defmodule Lzh.PoliticiansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lzh.Politicians` context.
  """

  @doc """
  Generate a political party.
  """
  def party_fixture(attrs \\ %{}) do
    {:ok, party} =
      attrs
      |> Map.put_new(:name, "Party #{System.unique_integer([:positive])}")
      |> Lzh.Politicians.create_party()

    party
  end

  @doc """
  Generate a politician.
  """
  def politician_fixture(attrs \\ %{}) do
    {:ok, politician} =
      attrs
      |> Map.put_new_lazy(:party_id, fn ->
        party = party_fixture()
        party.id
      end)
      |> Map.put_new(:name, "Politician #{System.unique_integer([:positive])}")
      |> Lzh.Politicians.create_politician()

    politician
  end
end
