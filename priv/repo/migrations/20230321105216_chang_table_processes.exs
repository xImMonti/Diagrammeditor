defmodule Diagrammeditor.Repo.Migrations.ChangTableProcesses do
  use Ecto.Migration

  def change do
    alter table("processes") do
      add :flowchart, :jsonb
    end
  end
end
