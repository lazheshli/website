defmodule Lzh.Politicians.Politician do
  use Ecto.Schema

  import Ecto.Changeset

  schema "politicians" do
    belongs_to :party, Lzh.Politicians.Party

    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(politician, attrs) do
    politician
    |> cast(attrs, [:party_id, :name])
    |> validate_required([:party_id, :name])
    |> assoc_constraint(:party)
    |> validate_length(:name, min: 1, max: 200)
    |> unique_constraint([:party_id, :name])
  end
end
