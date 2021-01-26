defmodule EsseWeb.NodeLive.ChildFormComponent do
  use EsseWeb, :live_component

  alias Esse.Graph

  @impl true
  def render(assigns) do
    ~L"""
    <h2><%= @title %></h2>
    <%= f = form_for @changeset, "#",
    id: "node-form",
    phx_target: @myself,
    phx_change: "validate",
    phx_submit: "save",
    as: :child_node
    %>

      <%= label f, :body %>
      <%= textarea f, :body %>
      <%= error_tag f, :body %>

    <%= submit "Save", phx_disable_with: "Saving..." %>

    </form>

    """
  end

  @impl true
  def update(%{child: child} = assigns, socket) do
    changeset = Graph.change_node(child)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"child_node" => node_params}, socket) do
    changeset =
      socket.assigns.child
      |> Graph.change_node(node_params)
      |> Map.put(:action, :validate)

    IO.inspect(changeset)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"child_node" => node_params}, socket) do
    save_node(socket, socket.assigns.action, node_params)
  end

  # defp save_node(socket, :edit, node_params) do
  #   case Graph.update_node(socket.assigns.node, node_params) do
  #     {:ok, _node} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Node updated successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  # defp save_node(socket, :new, node_params) do
  #   case Graph.create_node(node_params) do
  #     {:ok, _node} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Node created successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end

  defp save_node(socket, :new_child, node_params) do
    case Graph.create_child_node(socket.assigns.node, node_params) do
      {:ok, _node} ->
        {:noreply,
         socket
         |> put_flash(:info, "Child Node created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
