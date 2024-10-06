defmodule Lzh.Politicians.Avatar do
  use Ecto.Schema

  import Ecto.Changeset

  schema "politician_avatars" do
    belongs_to :politician, Lzh.Politicians.Politician
    belongs_to :election, Lzh.Elections.Election

    # not relevant for presidential elections
    field :party, :string, default: ""

    # only relevant for local elections
    field :town, :string, default: ""

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(avatar, attrs) do
    avatar
    |> cast(attrs, [:politician_id, :election_id, :party, :town])
    |> validate_required([:politician_id, :election_id])
    |> assoc_constraint(:politician)
    |> assoc_constraint(:election)
    |> validate_length(:party, max: 200)
    |> validate_length(:town, max: 200)
    |> unique_constraint([:politician_id, :election_id])
  end
end
