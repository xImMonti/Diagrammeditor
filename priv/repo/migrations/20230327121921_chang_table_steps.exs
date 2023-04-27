defmodule Diagrammeditor.Repo.Migrations.ChangTableSteps do
  use Ecto.Migration

  def change do
    alter table("steps") do
      add :step_id, :int
    end
  end
end
