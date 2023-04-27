defmodule Diagrammeditor.Processes.Process do
  use Ecto.Schema
  import Ecto.Changeset

  schema "processes" do
    field :description, :string
    field :name, :string
    field :status, Ecto.Enum, values: [:empty, :in_progress, :finished]
    field :flowchart, :map
    belongs_to :user, Diagrammeditor.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(process, attrs) do
    process
    |> cast(attrs, [:name, :description, :status, :user_id, :flowchart])
    |> validate_required([:name, :description, :user_id])
  end
end
