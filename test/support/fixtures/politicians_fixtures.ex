defmodule Lzh.PoliticiansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lzh.Politicians` context.
  """
  import Lzh.ElectionsFixtures

  @doc """
  Generates a politician.
  """
  def politician_fixture(attrs \\ %{}) do
    {:ok, politician} =
      attrs
      |> Map.put_new(:name, "Politician #{System.unique_integer([:positive])}")
      |> Lzh.Politicians.create_politician()

    politician
  end

  @doc """
  Generates an avatar.
  """
  def avatar_fixture(attrs \\ %{}) do
    {:ok, avatar} =
      attrs
      |> Map.put_new_lazy(:politician_id, fn -> politician_fixture().id end)
      |> Map.put_new_lazy(:election_id, fn -> election_fixture().id end)
      |> Lzh.Politicians.create_avatar()

    # preload the :politician and :election fields
    Lzh.Politicians.get_avatar!(avatar.id)
  end
end
