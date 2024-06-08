defmodule Lzh.Elections.Election do
  use Ecto.Schema

  import Ecto.Changeset

  schema "elections" do
    field :type, Ecto.Enum, values: [:parliamentary, :presidential, :local]
    field :date, :date

    field :show_statements, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(election, attrs) do
    election
    |> cast(attrs, [:type, :date, :show_statements])
    |> validate_required([:type, :date])
  end
end
