defmodule Project.GameContextTest do
  use Project.DataCase

  alias Project.GameContext

  describe "games" do
    alias Project.GameContext.Game

    import Project.GameContextFixtures

    @invalid_attrs %{deck: nil, active_cards: nil, players: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert GameContext.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert GameContext.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{deck: %{}, active_cards: %{}, players: %{}}

      assert {:ok, %Game{} = game} = GameContext.create_game(valid_attrs)
      assert game.deck == %{}
      assert game.active_cards == %{}
      assert game.players == %{}
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GameContext.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{deck: %{}, active_cards: %{}, players: %{}}

      assert {:ok, %Game{} = game} = GameContext.update_game(game, update_attrs)
      assert game.deck == %{}
      assert game.active_cards == %{}
      assert game.players == %{}
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = GameContext.update_game(game, @invalid_attrs)
      assert game == GameContext.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = GameContext.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> GameContext.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = GameContext.change_game(game)
    end
  end
end
