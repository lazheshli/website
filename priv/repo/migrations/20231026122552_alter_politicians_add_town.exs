defmodule Lzh.Repo.Migrations.AlterPoliticiansAddTown do
  use Ecto.Migration

  def change do
    alter table("politicians") do
      add :town, :string, size: 200, null: false, default: ""
    end
  end
end
