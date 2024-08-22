defmodule Project.GameContext do
  @moduledoc """
  The GameContext context.
  """

  import Ecto.Query, warn: false
  alias Project.Repo
  alias Project.Game

  alias Project.GameContext.Game
  alias Project.Card

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    deck = Enum.shuffle(Enum.to_list(0..80))
    initial_active_cards = Enum.take(deck, 12)
    remaining_deck = Enum.drop(deck, 12)

    attrs_with_defaults =
      Map.merge(
        %{
          deck: remaining_deck,
          active_cards: initial_active_cards,
          selected_cards: [],
          players: %{}
        },
        attrs
      )

    %Game{}
    |> Game.changeset(attrs_with_defaults)
    |> Repo.insert()
  end

  def reset_game(%Game{} = game) do
    deck = Enum.shuffle(Enum.to_list(0..80))
    initial_active_cards = Enum.take(deck, 12)
    remaining_deck = Enum.drop(deck, 12)

    attrs_with_reset = %{
      deck: remaining_deck,
      active_cards: initial_active_cards,
      selected_cards: [],
      players: %{}
    }

    game
    |> change_game(attrs_with_reset)
    |> Repo.update()
  end

  def is_set?([card1_id, card2_id, card3_id]) do
    categories = [:count, :shape, :fill, :color]

    set_arr = [
      Card.generate_card_data(card1_id),
      Card.generate_card_data(card2_id),
      Card.generate_card_data(card3_id)
    ]

    res =
      Enum.map(categories, fn category ->
        set_arr
        |> Enum.map(&Map.get(&1, category))
        |> Enum.uniq()
        |> length()
      end)

    Enum.all?(res, &(&1 in [1, 3]))
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  def update_game_with_set(game, selected_cards, player_id) do
    if is_set?(selected_cards) do
      # Award the set to the player
      updated_players =
        Map.update(game.players, player_id, selected_cards, &(&1 ++ selected_cards))

      # Replace the active cards
      {new_active_cards, new_deck} =
        replace_selected_cards(game.active_cards, game.deck, selected_cards)

      update_game(game, %{
        players: updated_players,
        active_cards: new_active_cards,
        deck: new_deck,
        selected_cards: []
      })
    else
      # Ensure selected_cards is reset even if the set is not valid
      update_game(game, %{selected_cards: []})
    end
  end

  defp replace_selected_cards(active_cards, deck, selected_cards) do
    # Find the indices of the selected cards in the active cards
    selected_indices =
      Enum.map(selected_cards, fn card ->
        Enum.find_index(active_cards, fn x -> x == card end)
      end)

    # Take the new cards from the deck (up to the number of selected cards)
    {new_cards, remaining_deck} = Enum.split(deck, length(selected_cards))

    # Create the new active cards list by replacing selected cards with new cards
    new_active_cards =
      Enum.with_index(active_cards)
      |> Enum.map(fn {card, index} ->
        if index in selected_indices do
          # Replace the card with the corresponding new card
          new_card_index = Enum.find_index(selected_indices, fn idx -> idx == index end)
          Enum.at(new_cards, new_card_index)
        else
          card
        end
      end)

    {new_active_cards, remaining_deck}
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end
end
