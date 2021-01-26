defmodule Esse.GraphTest do
  use Esse.DataCase

  alias Esse.Graph

  describe "nodes" do
    alias Esse.Graph.Node

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def node_fixture(attrs \\ %{}) do
      {:ok, node} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Graph.create_node()

      node
    end

    test "list_nodes/0 returns all nodes" do
      node = node_fixture()
      assert Graph.list_nodes() == [node]
    end

    test "get_node!/1 returns the node with given id" do
      node = node_fixture()
      assert Graph.get_node!(node.id) == node
    end

    test "create_node/1 with valid data creates a node" do
      assert {:ok, %Node{} = node} = Graph.create_node(@valid_attrs)
      assert node.body == "some body"
    end

    test "create_node/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Graph.create_node(@invalid_attrs)
    end

    test "update_node/2 with valid data updates the node" do
      node = node_fixture()
      assert {:ok, %Node{} = node} = Graph.update_node(node, @update_attrs)
      assert node.body == "some updated body"
    end

    test "update_node/2 with invalid data returns error changeset" do
      node = node_fixture()
      assert {:error, %Ecto.Changeset{}} = Graph.update_node(node, @invalid_attrs)
      assert node == Graph.get_node!(node.id)
    end

    test "delete_node/1 deletes the node" do
      node = node_fixture()
      assert {:ok, %Node{}} = Graph.delete_node(node)
      assert_raise Ecto.NoResultsError, fn -> Graph.get_node!(node.id) end
    end

    test "change_node/1 returns a node changeset" do
      node = node_fixture()
      assert %Ecto.Changeset{} = Graph.change_node(node)
    end
  end
end
