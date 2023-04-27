defmodule DiagrammeditorWeb.FlowchartComponent do
  use Phoenix.Component

  import DiagrammeditorWeb.CoreComponents

  attr :id, :string, required: true
  attr :hook, :string, required: true
  slot(:inner_block, required: true)
  slot(:header, required: true)
  slot(:nodes, required: true)

  def flowchart(assigns) do
    ~H"""
    <div id={@id} class="h-screen" phx-hook={@hook}>
      <div class="flex h-screen flex-col flowchart">
        <div class="">
          <div>
            <%= render_slot(@header) %>
          </div>
        </div>
        <div class="h-full flex border-r">
          <div class="bg-white basis-2/12 h-full">
            <%= render_slot(@nodes) %>
          </div>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
  def flowchart_header_action(assigns) do
    ~H"""
    <div>
      <%= if assigns[:action] do %>
        <.button id={@id} class={@class} phx-click={@action}>
          <%= render_slot(@inner_block) %>
        </.button>
      <% else %>
        <.button id={@id} class={@class}>
          <%= render_slot(@inner_block) %>
        </.button>
      <% end %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :label, :string, required: true
  attr :class, :string, required: true
  attr :data_node, :string, required: true
  attr :inputs, :integer, values: [1, 2, 3]
  attr :outputs, :integer, values: [1, 2, 3]
  slot(:inner_block, required: true)

  def flowchart_node(assigns) do
    ~H"""
    <div
      id={@id}
      class={["drag-drawflow px-4 py-5 border-b-2 border-slate-200 cursor-grab", @class]}
      }
      data-node={@data_node}
      data-outputs={@outputs}
      data-inputs={@inputs}
      draggable="true"
    >
      <div class="drag-drawflow__label">
        <%= @label %>
      </div>
      <div class="drag-drawflow__content h-full">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def flowchart_canvas(assigns) do
    ~H"""
    <div class="flex-auto">
      <div phx-update="ignore" class="flowchart__wrapper h-full" id="drawflow"></div>
    </div>
    """
  end
end
