defmodule Project.GameContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Project.GameContext` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        active_cards: %{},
        deck: %{},
        players: %{}
      })
      |> Project.GameContext.create_game()

    game
  end
end
