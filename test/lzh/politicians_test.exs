defmodule Lzh.PoliticiansTest do
  use Lzh.DataCase

  alias Lzh.Politicians

  describe "parties" do
    alias Lzh.Politicians.Party

    import Lzh.PoliticiansFixtures

    @invalid_attrs %{name: nil}

    test "list_parties/0 returns all parties" do
      party = party_fixture()
      assert Politicians.list_parties() == [party]
    end

    test "get_party!/1 returns the party with given id" do
      party = party_fixture()
      assert Politicians.get_party!(party.id) == party
    end

    test "create_party/1 with valid data creates a party" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Party{} = party} = Politicians.create_party(valid_attrs)
      assert party.name == "some name"
    end

    test "create_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Politicians.create_party(@invalid_attrs)
    end

    test "update_party/2 with valid data updates the party" do
      party = party_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Party{} = party} = Politicians.update_party(party, update_attrs)
      assert party.name == "some updated name"
    end

    test "update_party/2 with invalid data returns error changeset" do
      party = party_fixture()
      assert {:error, %Ecto.Changeset{}} = Politicians.update_party(party, @invalid_attrs)
      assert party == Politicians.get_party!(party.id)
    end

    test "delete_party/1 deletes the party" do
      party = party_fixture()
      assert {:ok, %Party{}} = Politicians.delete_party(party)
      assert_raise Ecto.NoResultsError, fn -> Politicians.get_party!(party.id) end
    end

    test "change_party/1 returns a party changeset" do
      party = party_fixture()
      assert %Ecto.Changeset{} = Politicians.change_party(party)
    end
  end

  describe "politicians" do
    alias Lzh.Politicians.Politician

    import Lzh.PoliticiansFixtures

    @invalid_attrs %{party_id: 0, name: nil}

    test "list_politicians/0 returns all politicians" do
      politician = politician_fixture()
      assert Politicians.list_politicians() == [politician]
    end

    test "get_politician!/1 returns the politician with given id" do
      politician = politician_fixture()
      assert Politicians.get_politician!(politician.id) == politician
    end

    test "create_politician/1 with valid data creates a politician" do
      party = party_fixture()

      valid_attrs = %{party_id: party.id, name: "some name"}

      assert {:ok, %Politician{} = politician} = Politicians.create_politician(valid_attrs)
      assert politician.party_id == party.id
      assert politician.name == "some name"
    end

    test "create_politician/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Politicians.create_politician(@invalid_attrs)
    end

    test "update_politician/2 with valid data updates the politician" do
      politician = politician_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Politician{} = politician} =
               Politicians.update_politician(politician, update_attrs)

      assert politician.name == "some updated name"
    end

    test "update_politician/2 with invalid data returns error changeset" do
      politician = politician_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Politicians.update_politician(politician, @invalid_attrs)

      assert politician == Politicians.get_politician!(politician.id)
    end

    test "delete_politician/1 deletes the politician" do
      politician = politician_fixture()
      assert {:ok, %Politician{}} = Politicians.delete_politician(politician)
      assert_raise Ecto.NoResultsError, fn -> Politicians.get_politician!(politician.id) end
    end

    test "change_politician/1 returns a politician changeset" do
      politician = politician_fixture()
      assert %Ecto.Changeset{} = Politicians.change_politician(politician)
    end
  end
end
