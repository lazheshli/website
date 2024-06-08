defmodule Lzh.ElectionsTest do
  use Lzh.DataCase

  alias Lzh.Elections

  describe "elections" do
    alias Lzh.Elections.Election

    import Lzh.ElectionsFixtures

    @invalid_attrs %{type: nil, date: nil}

    test "list_elections/0 returns all elections" do
      election = election_fixture()

      [output] = Elections.list_elections()
      assert output.id == election.id

      # assert that the computed fields are there
      assert output.slug
      assert output.name
      assert output.month_name
    end

    test "get_election!/1 returns the election with given id" do
      election = election_fixture()

      output = Elections.get_election!(election.id)
      assert output.id == election.id

      # assert that the computed fields are there
      assert output.slug
      assert output.name
      assert output.month_name
    end

    test "get_election_by_slug/1 returns the election with the given slug" do
      election = election_fixture(%{date: ~D[2023-10-29], type: :local})

      assert Elections.get_election_by_slug("2024-октомври-местни-избори") == nil
      assert Elections.get_election_by_slug("2023-септември-местни-избори") == nil
      assert Elections.get_election_by_slug("2023-октомври-парламентарни-избори") == nil

      output = Elections.get_election_by_slug("2023-октомври-местни-избори")
      assert output.id == election.id

      # assert that the computed fields are there
      assert output.slug
      assert output.name
      assert output.month_name
    end

    test "create_election/1 with valid data creates a election" do
      valid_attrs = %{type: :parliamentary, date: ~D[2023-08-18]}

      assert {:ok, %Election{} = election} = Elections.create_election(valid_attrs)

      assert election.type == :parliamentary
      assert election.date == ~D[2023-08-18]

      # assert that the computed fields are there
      assert election.slug == "2023-август-парламентарни-избори"
      assert election.name == "Парламентарни избори"
      assert election.month_name == "август"
    end

    test "create_election/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Elections.create_election(@invalid_attrs)
    end

    test "update_election/2 with valid data updates the election" do
      election = election_fixture()
      update_attrs = %{type: :presidential, date: ~D[2023-08-19]}

      assert {:ok, %Election{} = election} = Elections.update_election(election, update_attrs)
      assert election.type == :presidential
      assert election.date == ~D[2023-08-19]
    end

    test "update_election/2 with invalid data returns error changeset" do
      election = election_fixture()
      election = Elections.get_election!(election.id)

      assert {:error, %Ecto.Changeset{}} = Elections.update_election(election, @invalid_attrs)
      assert election == Elections.get_election!(election.id)
    end

    test "delete_election/1 deletes the election" do
      election = election_fixture()
      assert {:ok, %Election{}} = Elections.delete_election(election)
      assert_raise Ecto.NoResultsError, fn -> Elections.get_election!(election.id) end
    end

    test "change_election/1 returns a election changeset" do
      election = election_fixture()
      assert %Ecto.Changeset{} = Elections.change_election(election)
    end

    test "election_name/1 returns an elections's name" do
      election = election_fixture()
      assert Elections.election_name(election) == "Парламентарни избори"
    end

    test "election_month_name/1 returns the name of the month of an elections" do
      election = election_fixture()
      assert Elections.election_month_name(election) == "август"
    end

    test "election_slug/1 returns an elections's slug" do
      election = election_fixture(%{date: ~D[2023-10-29], type: :local})
      assert Elections.election_slug(election) == "2023-октомври-местни-избори"
    end
  end
end
