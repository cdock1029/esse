defmodule Esse.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :body, :text
      add :parent_id, references(:nodes, on_delete: :nothing)

      timestamps()
    end

    create index(:nodes, [:parent_id])
  end
end
