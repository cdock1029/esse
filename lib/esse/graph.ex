defmodule Esse.Graph do
  @moduledoc """
  The Graph context.
  """

  import Ecto.Query, warn: false
  alias Esse.Repo

  alias Esse.Graph.Node

  @doc """
  Returns the list of nodes.

  ## Examples

      iex> list_nodes()
      [%Node{}, ...]

  """
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

  @doc """
  Gets a single node.

  Raises `Ecto.NoResultsError` if the Node does not exist.

  ## Examples

      iex> get_node!(123)
      %Node{}

      iex> get_node!(456)
      ** (Ecto.NoResultsError)

  """
  def get_node!(id) do
    Repo.one(
      from n in Node,
        left_join: c in assoc(n, :children),
        where: n.id == ^id,
        order_by: [asc: c.inserted_at],
        preload: [children: c]
    )
  end

  @doc """
  Creates a node.

  ## Examples

      iex> create_node(%{field: value})
      {:ok, %Node{}}

      iex> create_node(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  @doc """
  Updates a node.

  ## Examples

      iex> update_node(node, %{field: new_value})
      {:ok, %Node{}}

      iex> update_node(node, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a node.

  ## Examples

      iex> delete_node(node)
      {:ok, %Node{}}

      iex> delete_node(node)
      {:error, %Ecto.Changeset{}}

  """
  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node changes.

  ## Examples

      iex> change_node(node)
      %Ecto.Changeset{data: %Node{}}

  """
  def change_node(%Node{} = node, attrs \\ %{}) do
    Node.changeset(node, attrs)
  end
end