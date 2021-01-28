defmodule EsseWeb.NodeLive.Index do
  use EsseWeb, :live_view

  alias Esse.Graph
  alias Esse.Graph.Node

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, edit: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    id = Map.get(params, "id", 0)
    node = Graph.get_node!(id)

    socket
    |> assign(:node, node)
  end

  @impl true
  def handle_info({:form_success, node}, socket) do
    socket = assign(socket, edit: false, node: node)
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_edit", %{"id" => id}, socket) do
    case socket.assigns.edit do
      ^id -> {:noreply, assign(socket, edit: nil)}
      _ -> {:noreply, assign(socket, edit: id)}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {id_int, _} = Integer.parse(id)
    {:ok, _} = Graph.delete_node(%Node{id: id_int})

    {:noreply, assign(socket, :node, Graph.get_node!(socket.assigns.node.id))}
  end
end
