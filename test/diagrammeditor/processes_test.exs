defmodule Diagrammeditor.ProcessesTest do
  use Diagrammeditor.DataCase

  alias Diagrammeditor.Processes

  describe "processes" do
    alias Diagrammeditor.Processes.Process

    import Diagrammeditor.{
      AccountsFixtures,
      ProcessesFixtures
    }

    @invalid_attrs %{description: nil, name: nil, status: nil}

    setup do
      %{user: user_fixture()}
    end

    test "list_processes/0 returns all processes", %{user: user} do
      process = process_fixture(%{user_id: user.id})
      assert Processes.list_processes() == [process]
    end

    test "get_process!/1 returns the process with given id", %{user: user} do
      process = process_fixture(%{user_id: user.id})
      assert Processes.get_process!(process.id) == process
    end

    test "create_process/1 with valid data creates a process", %{user: user} do
      valid_attrs = %{description: "some description", name: "some name", status: :empty, user_id: user.id}

      assert {:ok, %Process{} = process} = Processes.create_process(valid_attrs)
      assert process.description == "some description"
      assert process.name == "some name"
      assert process.status == :empty
    end

    test "create_process/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Processes.create_process(@invalid_attrs)
    end

    test "update_process/2 with valid data updates the process", %{user: user} do
      process = process_fixture(%{user_id: user.id})

      update_attrs = %{
        description: "some updated description",
        name: "some updated name",
        status: :in_progress,
        user_id: user.id
      }

      assert {:ok, %Process{} = process} = Processes.update_process(process, update_attrs)
      assert process.description == "some updated description"
      assert process.name == "some updated name"
      assert process.status == :in_progress
    end

    test "update_process/2 with invalid data returns error changeset", %{user: user} do
      process = process_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Processes.update_process(process, @invalid_attrs)
      assert process == Processes.get_process!(process.id)
    end

    test "delete_process/1 deletes the process", %{user: user} do
      process = process_fixture(%{user_id: user.id})
      assert {:ok, %Process{}} = Processes.delete_process(process)
      assert_raise Ecto.NoResultsError, fn -> Processes.get_process!(process.id) end
    end

    test "change_process/1 returns a process changeset", %{user: user} do
      process = process_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Processes.change_process(process)
    end
  end
end
