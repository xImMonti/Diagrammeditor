defmodule Diagrammeditor.ProcessesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Diagrammeditor.Processes` context.
  """

  @doc """
  Generate a process.
  """
  def process_fixture(attrs \\ %{}) do
    {:ok, process} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        status: :empty
      })
      |> Diagrammeditor.Processes.create_process()

    process
  end
end
