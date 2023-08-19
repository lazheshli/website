defmodule Lzh.Repo do
  use Ecto.Repo,
    otp_app: :lzh,
    adapter: Ecto.Adapters.Postgres
end
