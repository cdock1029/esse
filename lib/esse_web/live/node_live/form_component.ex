defmodule EsseWeb.NodeLive.FormComponent do
  use EsseWeb, :live_component

  alias Esse.Graph

  @impl true
  def update(%{node: node} = assigns, socket) do
    changeset = Graph.change_node(node)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"node" => node_params}, socket) do
    changeset =
      socket.assigns.node
      |> Graph.change_node(node_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"node" => node_params}, socket) do
    save_node(socket, socket.assigns.action, node_params)
  end

  defp save_node(socket, :index, node_params) do
    case Graph.update_node(socket.assigns.node, node_params) do
      {:ok, node} ->
        send(self(), {:form_success, node})

        {
          :noreply,
          socket
          # |> put_flash(:info, "Node updated successfully")
        }

      # |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_node(socket, :edit, node_params) do
    case Graph.update_node(socket.assigns.node, node_params) do
      {:ok, _node} ->
        {:noreply,
         socket
         |> put_flash(:info, "Node updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_node(socket, :new, node_params) do
    case Graph.create_node(node_params) do
      {:ok, _node} ->
        {:noreply,
         socket
         |> put_flash(:info, "Node created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
