defmodule DiagrammeditorWeb.ProcessLive.FormComponent do
  use DiagrammeditorWeb, :live_component

  alias Diagrammeditor.Processes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage process records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="process-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Process</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{process: process} = assigns, socket) do
    changeset = Processes.change_process(process)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"process" => process_params}, socket) do
    changeset =
      socket.assigns.process
      |> Processes.change_process(process_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"process" => process_params}, socket) do
    save_process(socket, socket.assigns.action, process_params)
  end

  defp save_process(socket, :edit, process_params) do
    case Processes.update_process(socket.assigns.process, process_params) do
      {:ok, process} ->
        notify_parent({:saved, process})

        {:noreply,
         socket
         |> put_flash(:info, "Process updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_process(socket, :new, process_params) do
    case Processes.create_process(process_params) do
      {:ok, process} ->
        notify_parent({:saved, process})

        {:noreply,
         socket
         |> put_flash(:info, "Process created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
