defmodule Project.GameContext.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :deck, {:array, :integer}
    field :active_cards, {:array, :integer}
    field :players, :map

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:deck, :active_cards, :players])
    |> validate_required([])
  end
end
