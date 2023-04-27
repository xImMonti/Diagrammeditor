defmodule Diagrammeditor.Repo.Migrations.ChangeProcessesTable do
  use Ecto.Migration

  def change do
    alter table("processes") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
