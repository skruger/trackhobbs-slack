defmodule Trackhobbs.Repo do
  use Ecto.Repo,
    otp_app: :trackhobbs,
    adapter: Ecto.Adapters.Postgres
end
