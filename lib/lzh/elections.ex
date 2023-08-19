defmodule Lzh.Elections do
  alias Lzh.Repo

  alias Lzh.Elections.Election

  @doc """
  Returns the list of elections.

  ## Examples

      iex> list_elections()
      [%Election{}, ...]

  """
  def list_elections do
    Repo.all(Election)
  end

  @doc """
  Gets a single election.

  Raises `Ecto.NoResultsError` if the Election does not exist.

  ## Examples

      iex> get_election!(123)
      %Election{}

      iex> get_election!(456)
      ** (Ecto.NoResultsError)

  """
  def get_election!(id), do: Repo.get!(Election, id)

  @doc """
  Creates a election.

  ## Examples

      iex> create_election(%{field: value})
      {:ok, %Election{}}

      iex> create_election(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_election(attrs \\ %{}) do
    %Election{}
    |> Election.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a election.

  ## Examples

      iex> update_election(election, %{field: new_value})
      {:ok, %Election{}}

      iex> update_election(election, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_election(%Election{} = election, attrs) do
    election
    |> Election.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a election.

  ## Examples

      iex> delete_election(election)
      {:ok, %Election{}}

      iex> delete_election(election)
      {:error, %Ecto.Changeset{}}

  """
  def delete_election(%Election{} = election) do
    Repo.delete(election)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking election changes.

  ## Examples

      iex> change_election(election)
      %Ecto.Changeset{data: %Election{}}

  """
  def change_election(%Election{} = election, attrs \\ %{}) do
    Election.changeset(election, attrs)
  end
end
