defmodule Lzh.Politicians do
  import Ecto.Query

  alias Lzh.Repo

  alias Lzh.Elections.Election
  alias Lzh.Politicians.{Avatar, Party, Politician}

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
  Gets a single politician by name.

  ## Examples

      iex> get_politician("Има")
      %Politician{}

      iex> get_politician("Няма")
      nil

  """
  def get_politician(name) do
    Repo.get_by(Politician, name: name)
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

  #
  # avatars
  #

  @doc """
  Returns the list of avatars for a given politician or a given
  election.

  Always preloads the :politician and :election fields.

  ## Examples

      iex> list_avatars(politician)
      [%Avatar{}, ...]

      iex> list_avatars(election)
      [%Avatar{}, ...]

  """
  def list_avatars(politician_or_election)

  def list_avatars(%Politician{} = politician) do
    Avatar
    |> preload_politician_and_election()
    |> filter_by_politician(politician)
    |> order_by([avatar, politician, election], asc: election.date, asc: politician.name)
    |> Repo.all()
  end

  def list_avatars(%Election{} = election) do
    Avatar
    |> preload_politician_and_election()
    |> filter_by_election(election)
    |> order_by([avatar, politician, election], asc: election.date, asc: politician.name)
    |> Repo.all()
  end

  defp preload_politician_and_election(query) do
    query
    |> join(:left, [avatar], politician in assoc(avatar, :politician))
    |> join(:left, [avatar], election in assoc(avatar, :election))
    |> preload([_avatar, politician, election], [:politician, :election])
  end

  defp filter_by_politician(query, %Politician{id: politician_id}) do
    query
    |> where([avatar], avatar.politician_id == ^politician_id)
  end

  defp filter_by_election(query, %Election{id: election_id}) do
    query
    |> where([avatar], avatar.election_id == ^election_id)
  end

  @doc """
  Gets a single avatar.

  Raises if the avatar does not exist.

  Preloads the :politician and :election fields.

  ## Examples

      iex> get_avatar!(123)
      %Avatar{}

  """
  def get_avatar!(id) do
    Avatar
    |> preload_politician_and_election()
    |> Repo.get!(id)
  end

  @doc """
  Gets a single avatar by politician and election.

  Returns nil if the avatar does not exist.

  Preloads the :politician and :election fields.

  ## Examples

      iex> get_avatar(politician, election)
      %Avatar{}

      iex> get_avatar(politician, another_election)
      nil

  """
  def get_avatar(%Politician{} = politician, %Election{} = election) do
    Avatar
    |> preload_politician_and_election()
    |> filter_by_politician(politician)
    |> filter_by_election(election)
    |> Repo.one()
  end

  @doc """
  Creates a avatar.

  ## Examples

      iex> create_avatar(%{field: value})
      {:ok, %Avatar{}}

      iex> create_avatar(%{field: bad_value})
      {:error, ...}

  """
  def create_avatar(attrs \\ %{}) do
    %Avatar{}
    |> Avatar.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an avatar.

  ## Examples

      iex> update_avatar(avatar, %{field: new_value})
      {:ok, %Avatar{}}

      iex> update_avatar(avatar, %{field: bad_value})
      {:error, ...}

  """
  def update_avatar(%Avatar{} = avatar, attrs) do
    avatar
    |> Avatar.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an avatar.

  ## Examples

      iex> delete_avatar(avatar)
      {:ok, %Avatar{}}

      iex> delete_avatar(avatar)
      {:error, ...}

  """
  def delete_avatar(%Avatar{} = avatar) do
    Repo.delete(avatar)
  end

  @doc """
  Returns a data structure for tracking avatar changes.

  ## Examples

      iex> change_avatar(avatar)
      %Todo{...}

  """
  def change_avatar(%Avatar{} = avatar, attrs \\ %{}) do
    Avatar.changeset(avatar, attrs)
  end
end
