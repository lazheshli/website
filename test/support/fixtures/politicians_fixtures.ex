defmodule Lzh.PoliticiansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lzh.Politicians` context.
  """

  @doc """
  Generate a party.
  """
  def party_fixture(attrs \\ %{}) do
    {:ok, party} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Lzh.Politicians.create_party()

    party
  end
end
