defmodule Project.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Project.Game` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        color: "some color",
        number: 42,
        shading: "some shading",
        shape: "some shape"
      })
      |> Project.Game.create_card()

    card
  end

  @doc """
  Generate a game_live.
  """
  def game_live_fixture(attrs \\ %{}) do
    {:ok, game_live} =
      attrs
      |> Enum.into(%{

      })
      |> Project.Game.create_game_live()

    game_live
  end
end
