defmodule Lzh.Repo.Migrations.CreateStatements do
  use Ecto.Migration

  def change do
    create table("statements") do
      add :election_id, references("elections"), null: false
      add :politician_id, references("politicians"), null: false

      add :date, :date, null: false
      add :tv_show, :string, size: 200, null: false
      add :tv_show_url, :string, null: false
      add :tv_show_minute, :integer, null: false

      add :response, :text
      add :sources, {:array, :string}

      timestamps(type: :timestamptz)
    end
  end
end
