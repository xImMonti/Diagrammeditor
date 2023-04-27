defmodule DiagrammeditorWeb.ProcessLive.Diagramm do
  use DiagrammeditorWeb, :live_view

  import DiagrammeditorWeb.FlowchartComponent

  alias Diagrammeditor.Processes
  alias Diagrammeditor.Processes.Step

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :diagramm, %{"id" => id} = _params) do
    form =
      %Step{}
      |> Processes.change_step()
      |> to_form()

    socket
    |> assign(:page_title, "Diagrammeditor")
    |> assign(:process, Processes.get_process!(id))
    |> assign(:current_step, 0)
    |> assign(:form, form)
  end

  @impl true
  def handle_event("get-flowchart-data", _params, socket) do
    flowchart = Map.get(socket.assigns.process, :flowchart, nil)

    if flowchart do
      {:reply, flowchart, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event("open-modal", %{"nodeId" => node_id}, socket) do
    {:noreply, socket |> assign(:current_step, node_id)}
  end

  def handle_event("save-process-all", params, socket) do
    save_process(params, socket.assigns.process)

    {:noreply, put_flash(socket, :success, gettext("Der Prozess wurde erfolgreich gespeichert"))}
  end

  @impl true
  def handle_event("save-process-all-and-close", params, socket) do
    save_process(params, socket.assigns.process)

    {:noreply,
     socket
     |> put_flash(:success, gettext("Der Prozess wurde erfolgreich gespeichert"))
     |> push_navigate(to: ~p"/processes")
    }
  end

  def save_process(params, process) do
    process_steps = params["exportdata"]["drawflow"]["Home"]["data"]

    flowchart = params["exportdata"]

    Processes.delete_steps_by_process_id(process.id)

    Enum.each(process_steps, fn {_number, step} ->

      Processes.create_step(%{
        process_id: process.id,
        step_id: step["id"],
        type: step["name"],
        name: step["data"]["name"],
        description: step["data"]["description"],
      })
    end)

    case {check_for_starting_point(process_steps), check_for_ending_point(process_steps)} do
      {true, true} -> Processes.update_process(process, %{flowchart: flowchart, status: :finished})
      {_, _} -> Processes.update_process(process, %{flowchart: flowchart, status: :in_progress})
    end
  end

  defp check_for_starting_point(process_steps) do
    Enum.count(process_steps, fn {_number, step} ->
      step["name"] == "starting-point"
    end) == 1
  end

  defp check_for_ending_point(process_steps) do
    Enum.count(process_steps, fn {_number, step} ->
      step["name"] == "ending-point"
    end) == 1
  end
end
