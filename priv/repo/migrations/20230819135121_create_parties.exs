defmodule Lzh.Repo.Migrations.CreateParties do
  use Ecto.Migration

  def change do
    create table("parties") do
      add :name, :string, size: 200, null: false

      timestamps(type: :timestamptz)
    end

    create index("parties", [:name], unique: true)
  end
end
