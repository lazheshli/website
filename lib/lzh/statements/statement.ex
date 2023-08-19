defmodule Lzh.Statements.Statement do
  use Ecto.Schema

  import Ecto.Changeset

  schema "statements" do
    belongs_to :election, Lzh.Elections.Election
    belongs_to :politician, Lzh.Politicians.Politician

    field :date, :date
    field :tv_show, :string
    field :tv_show_url, :string
    field :tv_show_minute, :integer

    field :statement, :string
    field :response, :string
    field :sources, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(statement, attrs) do
    statement
    |> cast(attrs, [
      :election_id,
      :politician_id,
      :date,
      :tv_show,
      :tv_show_url,
      :tv_show_minute,
      :statement,
      :response,
      :sources
    ])
    |> validate_required([
      :election_id,
      :politician_id,
      :date,
      :tv_show,
      :tv_show_url,
      :tv_show_minute,
      :statement,
      :response,
      :sources
    ])
    |> assoc_constraint(:election)
    |> assoc_constraint(:politician)
    |> validate_length(:tv_show, min: 1, max: 200)
    |> validate_number(:tv_show_minute, greater_than_or_equal_to: 0)
  end
end
