defmodule FerreiraRocks.Repo do
  use Ecto.Repo,
    otp_app: :ferreira_rocks,
    adapter: Ecto.Adapters.Mnesia
end
