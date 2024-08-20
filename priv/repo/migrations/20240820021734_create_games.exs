defmodule Project.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :deck, {:array, :integer}
      add :active_cards, {:array, :integer}
      add :players, :map

      timestamps()
    end
  end
end
