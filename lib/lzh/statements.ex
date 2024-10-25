defmodule Lzh.Statements do
  import Ecto.Query

  alias Lzh.Repo

  alias Lzh.Elections.Election
  alias Lzh.Politicians.Avatar
  alias Lzh.Statements.Statement

  @doc """
  Returns the list of statements for a given election.

  Preloads the avatars together with the respective politicians.

  ## Examples

      iex> list_statements(election)
      [%Statement{}, ...]

  """
  def list_statements(%Election{id: election_id}) do
    Statement
    |> join(:left, [statement], avatar in assoc(statement, :avatar))
    |> join(:left, [_statement, avatar], politician in assoc(avatar, :politician))
    |> preload([_statement, avatar, politician],
      avatar: {avatar, politician: politician}
    )
    |> where([_statement, avatar, _politician], avatar.election_id == ^election_id)
    |> order_by([statement, _avatar, _politician], asc: statement.date)
    |> Repo.all()
  end

  @doc """
  Return the number of statements which belong to the given avatar.

  ## Examples

      iex> count_statements(avatar)
      42

  """
  def count_statements(%Avatar{id: avatar_id}) do
    Statement
    |> where([statement], statement.avatar_id == ^avatar_id)
    |> select([_statement], count())
    |> Repo.one()
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
end
