defmodule Lzh.Elections do
  import Ecto.Query

  alias Lzh.Repo

  alias Lzh.Elections.Election

  @months [
    "януари",
    "февруари",
    "март",
    "април",
    "май",
    "юни",
    "юли",
    "август",
    "септември",
    "октомври",
    "ноември",
    "декември"
  ]

  @types %{
    :parliamentary => "парламентарни-избори",
    :presidential => "президентски-избори",
    :local => "местни-избори"
  }

  @doc """
  Returns the list of elections.

  ## Examples

      iex> list_elections()
      [%Election{}, ...]

  """
  def list_elections do
    Election
    |> order_by([election], desc: election.date)
    |> Repo.all()
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
  Gets an election by slug.

  ## Examples

      iex> get_election_by_slug("2023-октомври-местни-избори")
      %Election{}

  """
  def get_election_by_slug(slug) do
    case parse_slug(slug) do
      {year, month, type} ->
        Election
        |> where([election], fragment("EXTRACT(YEAR FROM ?)", election.date) == ^year)
        |> where([election], fragment("EXTRACT(MONTH FROM ?)", election.date) == ^month)
        |> where([election], election.type == ^type)
        |> Repo.one()

      nil ->
        nil
    end
  end

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

  @doc """
  Return an election's name.

  ## Examples

    iex> election_name(election)
    "Местни избори"

  """
  def election_name(%Election{} = election) do
    Map.get(@types, election.type)
    |> String.capitalize()
    |> String.replace("-", " ")
  end

  @doc """
  Return an election's month name.

  ## Examples

    iex> election_name(election)
    "октомври"

  """
  def election_month_name(%Election{} = election) do
    Enum.at(@months, election.date.month - 1)
  end

  @doc """
  Return an election's URL slug.

  ## Examples

    iex> election_slug(election)
    "2023-октомври-местни-избори"

  """
  def election_slug(%Election{} = election) do
    Enum.join(
      [
        election.date.year,
        Enum.at(@months, election.date.month - 1),
        @types[election.type]
      ],
      "-"
    )
  end

  defp parse_slug(slug) do
    case Integer.parse(slug) do
      {year, "-" <> rest} ->
        parse_slug(year, rest)

      _ ->
        nil
    end
  end

  defp parse_slug(year, rest) when is_integer(year) do
    case String.split(rest, "-", parts: 2) do
      [month, rest] ->
        case Enum.find_index(@months, fn x -> x == month end) do
          nil -> nil
          index -> parse_slug(year, index + 1, rest)
        end

      _ ->
        nil
    end
  end

  defp parse_slug(year, month, rest) when is_integer(year) and is_integer(month) do
    type =
      case Enum.find(@types, fn {_key, value} -> value == rest end) do
        {key, _value} -> key
        _ -> nil
      end

    if type do
      {year, month, type}
    else
      nil
    end
  end

  @doc """
  Return an ordered list of {year, elections} tuples.

  ## Examples

    iex> list_year_elections()
    [{2023, [%Election{}, ...]}]

  """
  def list_year_elections() do
    list_elections()
    |> Enum.map(fn election ->
      election
      |> Map.put(:slug, election_slug(election))
      |> Map.put(:name, election_name(election))
      |> Map.put(:month_name, election_month_name(election))
    end)
    |> Enum.reduce(%{}, fn election, acc ->
      value = Map.get(acc, election.date.year, [])
      Map.put(acc, election.date.year, value ++ [election])
    end)
    |> Enum.to_list()
    |> Enum.reverse()
  end
end
