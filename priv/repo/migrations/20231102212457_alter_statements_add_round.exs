defmodule Lzh.Repo.Migrations.AlterStatementsAddRound do
  use Ecto.Migration

  def change do
    alter table("statements") do
      add :round, :integer, null: false, default: 1
    end
  end
end
