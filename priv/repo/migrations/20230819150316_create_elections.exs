defmodule Lzh.Repo.Migrations.CreateElections do
  use Ecto.Migration

  def change do
    create table("elections") do
      add :type, :string, size: 200, null: false
      add :date, :date, null: false

      timestamps(type: :timestamptz)
    end
  end
end
