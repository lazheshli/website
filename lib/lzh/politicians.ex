defmodule Lzh.Politicians do
  import Ecto.Query

  alias Lzh.Repo

  alias Lzh.Politicians.{Party, Politician}

  #
  # political parties
  #

  @doc """
  Returns the list of political parties.

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def list_parties do
    Repo.all(Party)
  end

  @doc """
  Gets a single political party.

  Raises `Ecto.NoResultsError` if the Party does not exist.

  ## Examples

      iex> get_party!(123)
      %Party{}

      iex> get_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_party!(id), do: Repo.get!(Party, id)

  @doc """
  Gets a single political party by name.

  ## Examples

      iex> get_party("Има")
      %Party{}

      iex> get_party("Няма")
      nil

  """
  def get_party(name) when is_binary(name) do
    Repo.get_by(Party, name: name)
  end

  @doc """
  Creates a political party.

  ## Examples

      iex> create_party(%{field: value})
      {:ok, %Party{}}

      iex> create_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_party(attrs \\ %{}) do
    %Party{}
    |> Party.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a political party.

  ## Examples

      iex> update_party(party, %{field: new_value})
      {:ok, %Party{}}

      iex> update_party(party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_party(%Party{} = party, attrs) do
    party
    |> Party.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a political party.

  ## Examples

      iex> delete_party(party)
      {:ok, %Party{}}

      iex> delete_party(party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_party(%Party{} = party) do
    Repo.delete(party)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking political party changes.

  ## Examples

      iex> change_party(party)
      %Ecto.Changeset{data: %Party{}}

  """
  def change_party(%Party{} = party, attrs \\ %{}) do
    Party.changeset(party, attrs)
  end

  #
  # politicians
  #

  @doc """
  Returns the list of politicians.

  ## Examples

      iex> list_politicians()
      [%Politician{}, ...]

  """
  def list_politicians do
    Politician
    |> order_by([politician], asc: politician.name, asc: politician.id)
    |> Repo.all()
  end

  @doc """
  Gets a single politician.

  Raises `Ecto.NoResultsError` if the Politician does not exist.

  ## Examples

      iex> get_politician!(123)
      %Politician{}

      iex> get_politician!(456)
      ** (Ecto.NoResultsError)

  """
  def get_politician!(id), do: Repo.get!(Politician, id)

  @doc """
  Gets a single politician by name and political party.

  ## Examples

      iex> get_party("Има")
      %Party{}

      iex> get_party("Няма")
      nil

  """
  def get_politician(name, party)

  def get_politician(name, %Party{id: party_id}) do
    get_politician(name, party_id)
  end

  def get_politician(name, party_id) when is_integer(party_id) do
    Repo.get_by(Politician, name: name, party_id: party_id)
  end

  @doc """
  Creates a politician.

  ## Examples

      iex> create_politician(%{field: value})
      {:ok, %Politician{}}

      iex> create_politician(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_politician(attrs \\ %{}) do
    %Politician{}
    |> Politician.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a politician.

  ## Examples

      iex> update_politician(politician, %{field: new_value})
      {:ok, %Politician{}}

      iex> update_politician(politician, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_politician(%Politician{} = politician, attrs) do
    politician
    |> Politician.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a politician.

  ## Examples

      iex> delete_politician(politician)
      {:ok, %Politician{}}

      iex> delete_politician(politician)
      {:error, %Ecto.Changeset{}}

  """
  def delete_politician(%Politician{} = politician) do
    Repo.delete(politician)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking politician changes.

  ## Examples

      iex> change_politician(politician)
      %Ecto.Changeset{data: %Politician{}}

  """
  def change_politician(%Politician{} = politician, attrs \\ %{}) do
    Politician.changeset(politician, attrs)
  end
end
