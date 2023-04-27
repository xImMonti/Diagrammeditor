defmodule Diagrammeditor.Processes.Step do
  use Ecto.Schema
  import Ecto.Changeset

  schema "steps" do
    field :description, :string
    field :name, :string
    field :type, :string
    field :step_id, :integer
    belongs_to :process, Diagrammeditor.Processes.Process

    timestamps()
  end

  @doc false
  def changeset(step, attrs) do
    step
    |> cast(attrs, [:name, :description, :type, :process_id, :step_id])
    |> validate_required([:type, :process_id])
  end
end
