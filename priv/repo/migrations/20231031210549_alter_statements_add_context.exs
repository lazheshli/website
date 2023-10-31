defmodule Lzh.Repo.Migrations.AlterStatementsAddContext do
  use Ecto.Migration

  def change do
    alter table("statements") do
      add :context, :text, null: false, default: ""
    end
  end
end
