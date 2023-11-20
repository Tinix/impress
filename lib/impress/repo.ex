defmodule Impress.Repo do
  use Ecto.Repo,
    otp_app: :impress,
    adapter: Ecto.Adapters.Postgres
end
