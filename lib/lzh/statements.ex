defmodule Lzh.Statements do
  import Ecto.Query

  alias Lzh.Repo

  alias Lzh.Elections.Election
  alias Lzh.Statements.Statement

  @doc """
  Returns the list of statements for a given election.

  Preloads the avatars, the politicians and their parties.

  ## Examples

      iex> list_statements(election)
      [%Statement{}, ...]

  """
  def list_statements(%Election{id: election_id}) do
    Statement
    |> where([statement], statement.election_id == ^election_id)
    |> join(:left, [statement], avatar in assoc(statement, :avatar))
    |> join(:left, [statement, _avatar], politician in assoc(statement, :politician))
    |> join(:left, [_statement, _avatar, politician], party in assoc(politician, :party))
    |> preload([_statement, avatar, politician, party],
      avatar: avatar,
      politician: {politician, party: party}
    )
    |> order_by([statement], asc: statement.date)
    |> Repo.all()
  end

  @doc """
  Gets a single statement.

  Raises `Ecto.NoResultsError` if the Statement does not exist.

  ## Examples

      iex> get_statement!(123)
      %Statement{}

      iex> get_statement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_statement!(id), do: Repo.get!(Statement, id)

  @doc """
  Creates a statement.

  ## Examples

      iex> create_statement(%{field: value})
      {:ok, %Statement{}}

      iex> create_statement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_statement(attrs \\ %{}) do
    %Statement{}
    |> Statement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a statement.

  ## Examples

      iex> update_statement(statement, %{field: new_value})
      {:ok, %Statement{}}

      iex> update_statement(statement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_statement(%Statement{} = statement, attrs) do
    statement
    |> Statement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a statement.

  ## Examples

      iex> delete_statement(statement)
      {:ok, %Statement{}}

      iex> delete_statement(statement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_statement(%Statement{} = statement) do
    Repo.delete(statement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking statement changes.

  ## Examples

      iex> change_statement(statement)
      %Ecto.Changeset{data: %Statement{}}

  """
  def change_statement(%Statement{} = statement, attrs \\ %{}) do
    Statement.changeset(statement, attrs)
  end

  def migrate_to_avatars do
    Statement
    |> join(:left, [statement], politician in assoc(statement, :politician))
    |> join(:left, [_statement, politician], party in assoc(politician, :party))
    |> join(:left, [statement, _politician, _party], election in assoc(statement, :election))
    |> preload(
      [_statement, politician, party, election],
      politician: {politician, party: party},
      election: election
    )
    |> Repo.all()
    |> Enum.map(&migrate_to_avatars/1)
  end

  defp migrate_to_avatars(%Statement{} = statement) do
    avatar =
      case Lzh.Politicians.get_avatar(statement.politician, statement.election) do
        nil ->
          {:ok, avatar} =
            Lzh.Politicians.create_avatar(%{
              politician_id: statement.politician_id,
              election_id: statement.election_id,
              party: statement.politician.party.name,
              town: statement.politician.town
            })

          avatar

        avatar ->
          avatar
      end

    update_statement(statement, %{avatar_id: avatar.id})
  end
end
