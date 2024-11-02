defmodule Lzh.Repo.Migrations.DropParties do
  use Ecto.Migration

  def change do
    drop table("parties")

    alter table("statements") do
      modify :avatar_id, references("politician_avatars"),
        null: false,
        from: references("politician_avatars")

      remove :election_id, references("elections"), null: true, default: nil
      remove :politician_id, references("politicians"), null: true, default: nil
    end
  end
end
