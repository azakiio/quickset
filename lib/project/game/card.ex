defmodule Project.Game.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :number, :integer
    field :color, :string
    field :shape, :string
    field :shading, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:shape, :color, :number, :shading])
    |> validate_required([:shape, :color, :number, :shading])
  end
end
