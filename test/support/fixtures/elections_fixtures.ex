defmodule Lzh.ElectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lzh.Elections` context.
  """

  @doc """
  Generate an election.
  """
  def election_fixture(attrs \\ %{}) do
    {:ok, election} =
      attrs
      |> Map.put_new(:type, :parliamentary)
      |> Map.put_new(:date, ~D[2023-08-18])
      |> Lzh.Elections.create_election()

    election
  end
end
