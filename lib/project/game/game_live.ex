defmodule Project.Game.GameLive do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game_live, attrs) do
    game_live
    |> cast(attrs, [])
    |> validate_required([])
  end
end
