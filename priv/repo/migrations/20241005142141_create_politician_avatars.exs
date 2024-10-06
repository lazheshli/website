defmodule Lzh.Repo.Migrations.CreatePoliticianAvatars do
  use Ecto.Migration

  def change do
    create table("politician_avatars") do
      add :politician_id, references("politicians"), null: false
      add :election_id, references("elections"), null: false

      add :party, :string, size: 200, null: false, default: ""
      add :town, :string, size: 200, null: false, default: ""

      timestamps(type: :timestamptz)
    end

    create index("politician_avatars", [:politician_id, :election_id], unique: true)
  end
end
