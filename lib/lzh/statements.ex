defmodule Lzh.Statements do
  import Ecto.Query

  alias Lzh.Repo

  alias Lzh.Elections.Election
  alias Lzh.Statements.Statement

  @doc """
  Returns the list of statements for a given election.

  Preloads the politicians and their parties.

  The list can be optionally filtered using the :party and :politician opts.

  ## Examples

      iex> list_statements(election)
      [%Statement{}, ...]

  """
  def list_statements(%Election{id: election_id}, opts \\ []) do
    Statement
    |> where([statement], statement.election_id == ^election_id)
    |> join(:left, [statement], politician in assoc(statement, :politician))
    |> join(:left, [_statement, politician], party in assoc(politician, :party))
    |> preload([_statement, politician, party], politician: {politician, party: party})
    |> maybe_filter_by_politician(opts)
    |> maybe_filter_by_party(opts)
    |> order_by([statement], asc: statement.date)
    |> Repo.all()
  end

  defp maybe_filter_by_politician(query, opts) do
    case Keyword.fetch(opts, :politician) do
      {:ok, %{id: politician_id}} ->
        query
        |> where([_statement, politician], politician.id == ^politician_id)

      :error ->
        query
    end
  end

  defp maybe_filter_by_party(query, opts) do
    case Keyword.fetch(opts, :party) do
      {:ok, %{id: party_id}} ->
        query
        |> where([_statement, _politician, party], party.id == ^party_id)

      :error ->
        query
    end
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
