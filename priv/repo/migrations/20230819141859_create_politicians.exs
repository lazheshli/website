defmodule Lzh.Repo.Migrations.CreatePoliticians do
  use Ecto.Migration

  def change do
    create table("politicians") do
      add :party_id, references("parties"), null: false

      add :name, :string, size: 200, null: false

      timestamps(type: :timestamptz)
    end

    create index("politicians", [:party_id, :name], unique: true)
  end
end
