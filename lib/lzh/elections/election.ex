defmodule Lzh.Elections.Election do
  use Ecto.Schema

  import Ecto.Changeset

  @derive {Phoenix.Param, key: :id}

  schema "elections" do
    field :type, Ecto.Enum, values: [:parliamentary, :presidential, :local]
    field :date, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(election, attrs) do
    election
    |> cast(attrs, [:type, :date])
    |> validate_required([:type, :date])
  end
end
