defmodule EsseWeb.NodeLive.Show do
  use EsseWeb, :live_view

  alias Esse.Graph
  alias Esse.Graph.Node
  alias Esse.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec handle_params(map, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     apply_action(
       socket,
       socket.assigns.live_action,
       Graph.get_node!(id) |> Repo.preload(:parent)
     )}
  end

  defp apply_action(socket, :show, node) do
    socket
    |> assign(:page_title, "Show Node")
    |> assign(:node, node)
  end

  defp apply_action(socket, :edit, node) do
    socket
    |> assign(:page_title, "Edit Node")
    |> assign(:node, node)
  end

  defp apply_action(socket, :new_child, node) do
    socket
    |> assign(:page_title, "New Child Node")
    |> assign(:node, node)
    |> assign(:child, %Node{})
  end
end
