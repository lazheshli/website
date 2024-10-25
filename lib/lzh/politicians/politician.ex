defmodule Lzh.Politicians.Politician do
  use Ecto.Schema

  import Ecto.Changeset

  schema "politicians" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(politician, attrs) do
    politician
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 200)
  end
end
