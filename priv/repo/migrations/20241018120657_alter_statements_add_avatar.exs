defmodule Lzh.Repo.Migrations.AlterStatementsAddAvatar do
  use Ecto.Migration

  def change do
    alter table("statements") do
      add :avatar_id, references("politician_avatars"), null: true, default: nil

      modify :election_id, references("elections"),
        from: references("elections"),
        null: true,
        default: nil

      modify :politician_id, references("politicians"),
        from: references("politicians"),
        null: true,
        default: nil
    end
  end
end
