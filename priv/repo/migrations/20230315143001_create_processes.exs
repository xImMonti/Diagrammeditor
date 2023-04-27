defmodule Diagrammeditor.Repo.Migrations.CreateProcesses do
  use Ecto.Migration

  def change do
    create table(:processes) do
      add :name, :string
      add :description, :string
      add :status, :string

      timestamps()
    end
  end
end
