defmodule Esse.Graph do
  import Ecto.Query, warn: false
  alias Esse.Repo

  alias Esse.Graph.Node

  def list_nodes do
    Repo.all(Node)
  end

  def list_root_nodes do
    Repo.all(
      from n in Node,
        where: is_nil(n.parent_id),
        order_by: [asc: n.inserted_at]
    )
  end

  def get_node!(id) do
    Repo.one(
      from n in Node,
        left_join: c in assoc(n, :children),
        left_join: p in assoc(n, :parent),
        where: n.id == ^id,
        order_by: [asc: c.inserted_at],
        preload: [children: c, parent: p]
    )
  end

  def create_node(attrs \\ %{}) do
    %Node{}
    |> Node.changeset(attrs)
    |> Repo.insert()
  end

  def create_child_node(parent, attrs) do
    %Node{}
    |> Node.changeset_child(parent, attrs)
    |> Repo.insert()
  end

  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  def change_node(%Node{} = node, attrs \\ %{}) do
    Node.changeset(node, attrs)
  end
end
