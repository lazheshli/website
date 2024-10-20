defmodule Lzh.StatementsTest do
  use Lzh.DataCase

  alias Lzh.Statements

  describe "statements" do
    alias Lzh.Statements.Statement

    import Lzh.{ElectionsFixtures, PoliticiansFixtures, StatementsFixtures}

    @invalid_attrs %{
      date: nil,
      tv_show: nil,
      tv_show_url: nil,
      tv_show_minute: nil,
      statement: nil,
      response: nil,
      sources: nil
    }

    test "list_statements/1 returns all statements for an election" do
      election = election_fixture()
      avatar = avatar_fixture(%{election_id: election.id})
      statement = statement_fixture(%{avatar_id: avatar.id})

      [res] = Statements.list_statements(election)
      assert res.id == statement.id
      assert res.avatar_id == avatar.id

      # assert that these are preloaded
      assert res.avatar
      assert res.avatar.politician

      # assert that the list is filtered by the given election
      another_election = election_fixture()
      assert Statements.list_statements(another_election) == []
    end

    test "get_statement!/1 returns the statement with given id" do
      statement = statement_fixture()
      assert Statements.get_statement!(statement.id) == statement
    end

    test "create_statement/1 with valid data creates a statement" do
      avatar = avatar_fixture()

      valid_attrs = %{
        avatar_id: avatar.id,
        date: ~D[2023-08-18],
        tv_show: "some tv_show",
        tv_show_url: "some tv_show_url",
        tv_show_minute: 42,
        statement: "some statement",
        response: "some response",
        sources: ["option1", "option2"]
      }

      assert {:ok, %Statement{} = statement} = Statements.create_statement(valid_attrs)
      assert statement.avatar_id == avatar.id
      assert statement.date == ~D[2023-08-18]
      assert statement.tv_show == "some tv_show"
      assert statement.tv_show_url == "some tv_show_url"
      assert statement.tv_show_minute == 42
      assert statement.response == "some response"
      assert statement.sources == ["option1", "option2"]
    end

    test "create_statement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Statements.create_statement(@invalid_attrs)
    end

    test "update_statement/2 with valid data updates the statement" do
      statement = statement_fixture()

      update_attrs = %{
        date: ~D[2023-08-19],
        sources: ["option1"],
        response: "some updated response",
        tv_show: "some updated tv_show",
        tv_show_url: "some updated tv_show_url",
        tv_show_minute: 43
      }

      assert {:ok, %Statement{} = statement} =
               Statements.update_statement(statement, update_attrs)

      assert statement.date == ~D[2023-08-19]
      assert statement.sources == ["option1"]
      assert statement.response == "some updated response"
      assert statement.tv_show == "some updated tv_show"
      assert statement.tv_show_url == "some updated tv_show_url"
      assert statement.tv_show_minute == 43
    end

    test "update_statement/2 with invalid data returns error changeset" do
      statement = statement_fixture()
      assert {:error, %Ecto.Changeset{}} = Statements.update_statement(statement, @invalid_attrs)
      assert statement == Statements.get_statement!(statement.id)
    end

    test "delete_statement/1 deletes the statement" do
      statement = statement_fixture()
      assert {:ok, %Statement{}} = Statements.delete_statement(statement)
      assert_raise Ecto.NoResultsError, fn -> Statements.get_statement!(statement.id) end
    end

    test "change_statement/1 returns a statement changeset" do
      statement = statement_fixture()
      assert %Ecto.Changeset{} = Statements.change_statement(statement)
    end
  end
end
