defmodule Diagrammeditor.Repo do
  use Ecto.Repo,
    otp_app: :diagrammeditor,
    adapter: Ecto.Adapters.Postgres
end
