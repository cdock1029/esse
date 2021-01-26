defmodule Esse.Graph.Node do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nodes" do
    field :body, :string
    # field :parent_id, :id

    belongs_to :parent, Esse.Graph.Node

    has_many :children, Esse.Graph.Node, foreign_key: :parent_id

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end

  def changeset_child(node, parent, attrs) do
    changeset(node, attrs)
    |> put_assoc(:parent, parent)
  end
end
