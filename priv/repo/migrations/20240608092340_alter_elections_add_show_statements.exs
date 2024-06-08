defmodule Lzh.Repo.Migrations.AlterElectionsAddShowStatements do
  use Ecto.Migration

  def change do
    alter table("elections") do
      add :show_statements, :boolean, null: false, default: false
    end
  end
end
