defmodule SecretSanta.Repo do
  use Ecto.Repo,
    otp_app: :secret_santa,
    adapter: Ecto.Adapters.Postgres
end
