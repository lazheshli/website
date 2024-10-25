defmodule Lzh.Repo.Migrations.AlterPoliticiansDropPartyAndTown do
  use Ecto.Migration

  def change do
    drop index("politicians", [:party_id, :name], unique: true)

    alter table("politicians") do
      remove :party_id, references("parties"), null: false
      remove :town, :string, size: 200, null: false, default: ""
    end
  end
end
