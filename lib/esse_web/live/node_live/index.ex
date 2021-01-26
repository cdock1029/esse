defmodule EsseWeb.NodeLive.Index do
  use EsseWeb, :live_view

  alias Esse.Graph
  alias Esse.Graph.Node

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :nodes, list_root_nodes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Node")
    |> assign(:node, Graph.get_node!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Node")
    |> assign(:node, %Node{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Nodes")
    |> assign(:node, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    node = Graph.get_node!(id)
    {:ok, _} = Graph.delete_node(node)

    {:noreply, assign(socket, :nodes, list_root_nodes())}
  end

  defp list_root_nodes do
    Graph.list_root_nodes()
  end
end
