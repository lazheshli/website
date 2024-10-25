defmodule Lzh.PoliticiansTest do
  use Lzh.DataCase

  alias Lzh.Politicians

  import Lzh.{ElectionsFixtures, PoliticiansFixtures}

  describe "parties" do
    alias Lzh.Politicians.Party

    @invalid_attrs %{name: nil}

    test "list_parties/0 returns all parties" do
      party = party_fixture()
      assert Politicians.list_parties() == [party]
    end

    test "get_party!/1 returns the party with given id" do
      party = party_fixture()
      assert Politicians.get_party!(party.id) == party
    end

    test "get_party/1 return the party with given name" do
      party = party_fixture()
      assert Politicians.get_party(party.name) == party
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

    @invalid_attrs %{name: nil}

    test "list_politicians returns all politicians" do
      assert Politicians.list_politicians() == []

      politician = politician_fixture()
      assert Politicians.list_politicians() == [politician]
    end

    test "get_politician!/1 returns the politician with given id" do
      politician = politician_fixture()
      assert Politicians.get_politician!(politician.id) == politician
    end

    test "get_politician/1 returns the politician with given name" do
      politician = politician_fixture()

      assert Politicians.get_politician(politician.name) == politician
      assert Politicians.get_politician("лъже-" <> politician.name) == nil
    end

    test "create_politician/1 with name creates a politician" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Politician{} = politician} = Politicians.create_politician(valid_attrs)
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

  describe "avatars" do
    alias Lzh.Politicians.Avatar

    @invalid_attrs %{party: String.duplicate("party", 42), town: String.duplicate("town", 52)}

    test "list_avatars/1 can filter by politician" do
      politician = politician_fixture()
      another_politician = politician_fixture()
      avatar = avatar_fixture(%{politician_id: politician.id})

      assert Politicians.list_avatars(politician) == [avatar]
      assert Politicians.list_avatars(another_politician) == []
    end

    test "list_avatars/1 can filter by election" do
      election = election_fixture()
      another_election = election_fixture()
      avatar = avatar_fixture(%{election_id: election.id})

      assert Politicians.list_avatars(election) == [avatar]
      assert Politicians.list_avatars(another_election) == []
    end

    test "get_avatar!/1 returns the avatar with given id" do
      avatar = avatar_fixture()
      assert Politicians.get_avatar!(avatar.id) == avatar
    end

    test "get_avatar/2 returns nil if the avatar does not exist" do
      politician = politician_fixture()
      election = election_fixture()
      assert Politicians.get_avatar(politician, election) == nil

      avatar_fixture(%{politician_id: politician.id})
      avatar_fixture(%{election_id: election.id})
      assert Politicians.get_avatar(politician, election) == nil
    end

    test "get_avatar/2 returns the avatar for the given politician and election" do
      politician = politician_fixture()
      election = election_fixture()
      avatar = avatar_fixture(%{politician_id: politician.id, election_id: election.id})
      assert Politicians.get_avatar(politician, election) == avatar
    end

    test "create_avatar/1 with valid data creates a avatar" do
      politician = politician_fixture()
      election = election_fixture()

      valid_attrs = %{
        politician_id: politician.id,
        election_id: election.id,
        party: "some party",
        town: "some town"
      }

      assert {:ok, %Avatar{} = avatar} = Politicians.create_avatar(valid_attrs)
      assert avatar.politician_id == politician.id
      assert avatar.election_id == election.id
      assert avatar.party == "some party"
      assert avatar.town == "some town"
    end

    test "create_avatar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Politicians.create_avatar(@invalid_attrs)
    end

    test "update_avatar/2 with valid data updates the avatar" do
      avatar = avatar_fixture()
      update_attrs = %{party: "", town: "some updated town"}

      assert {:ok, %Avatar{} = avatar} = Politicians.update_avatar(avatar, update_attrs)
      assert avatar.party == ""
      assert avatar.town == "some updated town"
    end

    test "update_avatar/2 with invalid data returns error changeset" do
      avatar = avatar_fixture()
      assert {:error, %Ecto.Changeset{}} = Politicians.update_avatar(avatar, @invalid_attrs)
      assert avatar == Politicians.get_avatar!(avatar.id)
    end

    test "delete_avatar/1 deletes the avatar" do
      avatar = avatar_fixture()
      assert {:ok, %Avatar{}} = Politicians.delete_avatar(avatar)
      assert_raise Ecto.NoResultsError, fn -> Politicians.get_avatar!(avatar.id) end
    end

    test "change_avatar/1 returns a avatar changeset" do
      avatar = avatar_fixture()
      assert %Ecto.Changeset{} = Politicians.change_avatar(avatar)
    end
  end
end
