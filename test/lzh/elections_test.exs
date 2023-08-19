defmodule Lzh.ElectionsTest do
  use Lzh.DataCase

  alias Lzh.Elections

  describe "elections" do
    alias Lzh.Elections.Election

    import Lzh.ElectionsFixtures

    @invalid_attrs %{type: nil, date: nil}

    test "list_elections/0 returns all elections" do
      election = election_fixture()
      assert Elections.list_elections() == [election]
    end

    test "get_election!/1 returns the election with given id" do
      election = election_fixture()
      assert Elections.get_election!(election.id) == election
    end

    test "create_election/1 with valid data creates a election" do
      valid_attrs = %{type: :parliamentary, date: ~D[2023-08-18]}

      assert {:ok, %Election{} = election} = Elections.create_election(valid_attrs)
      assert election.type == :parliamentary
      assert election.date == ~D[2023-08-18]
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
  end
end
