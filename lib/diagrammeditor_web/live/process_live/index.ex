defmodule DiagrammeditorWeb.ProcessLive.Index do
  use DiagrammeditorWeb, :live_view

  alias Diagrammeditor.Processes
  alias Diagrammeditor.Processes.Process

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(
       socket,
       :processes,
       Processes.list_processes_by_user_id(socket.assigns.current_user.id)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Process")
    |> assign(:process, Processes.get_process!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Process")
    |> assign(:process, %Process{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Processes")
    |> assign(:process, nil)
  end

  @impl true
  def handle_info({DiagrammeditorWeb.ProcessLive.FormComponent, {:saved, process}}, socket) do
    {:noreply, stream_insert(socket, :processes, process)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    process = Processes.get_process!(id)
    {:ok, _} = Processes.delete_process(process)

    {:noreply, stream_delete(socket, :processes, process)}
  end
end
