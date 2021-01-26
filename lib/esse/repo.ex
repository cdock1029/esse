defmodule Esse.Repo do
  use Ecto.Repo,
    otp_app: :esse,
    adapter: Ecto.Adapters.Postgres
end
