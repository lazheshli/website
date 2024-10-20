defmodule Lzh.Statements.Statement do
  use Ecto.Schema

  import Ecto.Changeset

  schema "statements" do
    belongs_to :election, Lzh.Elections.Election
    belongs_to :politician, Lzh.Politicians.Politician
    belongs_to :avatar, Lzh.Politicians.Avatar

    field :round, :integer, default: 1

    field :date, :date
    field :tv_show, :string
    field :tv_show_url, :string
    field :tv_show_minute, :integer

    field :statement, :string
    field :context, :string, default: ""

    field :response, :string
    field :sources, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(statement, attrs) do
    statement
    |> cast(attrs, [
      :avatar_id,
      :round,
      :date,
      :tv_show,
      :tv_show_url,
      :tv_show_minute,
      :statement,
      :context,
      :response,
      :sources
    ])
    |> validate_required([
      :avatar_id,
      :date,
      :tv_show,
      :tv_show_url,
      :tv_show_minute,
      :statement,
      :response,
      :sources
    ])
    |> assoc_constraint(:avatar)
    |> validate_subset(:round, [1, 2])
    |> validate_length(:tv_show, min: 1, max: 200)
    |> validate_number(:tv_show_minute, greater_than_or_equal_to: 0)
  end
end
