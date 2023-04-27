defmodule Diagrammeditor.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :name, :string
      add :description, :string
      add :type, :string
      add :process_id, references(:processes, on_delete: :nothing)

      timestamps()
    end

    create index(:steps, [:process_id])
  end
end
