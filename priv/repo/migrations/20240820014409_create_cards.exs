defmodule Project.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :shape, :string
      add :color, :string
      add :number, :integer
      add :shading, :string

      timestamps(type: :utc_datetime)
    end
  end
end
