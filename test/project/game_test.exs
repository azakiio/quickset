defmodule Project.GameTest do
  use Project.DataCase

  alias Project.Game

  describe "cards" do
    alias Project.Game.Card

    import Project.GameFixtures

    @invalid_attrs %{number: nil, color: nil, shape: nil, shading: nil}

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Game.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Game.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      valid_attrs = %{number: 42, color: "some color", shape: "some shape", shading: "some shading"}

      assert {:ok, %Card{} = card} = Game.create_card(valid_attrs)
      assert card.number == 42
      assert card.color == "some color"
      assert card.shape == "some shape"
      assert card.shading == "some shading"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      update_attrs = %{number: 43, color: "some updated color", shape: "some updated shape", shading: "some updated shading"}

      assert {:ok, %Card{} = card} = Game.update_card(card, update_attrs)
      assert card.number == 43
      assert card.color == "some updated color"
      assert card.shape == "some updated shape"
      assert card.shading == "some updated shading"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_card(card, @invalid_attrs)
      assert card == Game.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Game.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Game.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Game.change_card(card)
    end
  end

  describe "games" do
    alias Project.Game.GameLive

    import Project.GameFixtures

    @invalid_attrs %{}

    test "list_games/0 returns all games" do
      game_live = game_live_fixture()
      assert Game.list_games() == [game_live]
    end

    test "get_game_live!/1 returns the game_live with given id" do
      game_live = game_live_fixture()
      assert Game.get_game_live!(game_live.id) == game_live
    end

    test "create_game_live/1 with valid data creates a game_live" do
      valid_attrs = %{}

      assert {:ok, %GameLive{} = game_live} = Game.create_game_live(valid_attrs)
    end

    test "create_game_live/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_game_live(@invalid_attrs)
    end

    test "update_game_live/2 with valid data updates the game_live" do
      game_live = game_live_fixture()
      update_attrs = %{}

      assert {:ok, %GameLive{} = game_live} = Game.update_game_live(game_live, update_attrs)
    end

    test "update_game_live/2 with invalid data returns error changeset" do
      game_live = game_live_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_game_live(game_live, @invalid_attrs)
      assert game_live == Game.get_game_live!(game_live.id)
    end

    test "delete_game_live/1 deletes the game_live" do
      game_live = game_live_fixture()
      assert {:ok, %GameLive{}} = Game.delete_game_live(game_live)
      assert_raise Ecto.NoResultsError, fn -> Game.get_game_live!(game_live.id) end
    end

    test "change_game_live/1 returns a game_live changeset" do
      game_live = game_live_fixture()
      assert %Ecto.Changeset{} = Game.change_game_live(game_live)
    end
  end
end
