defmodule ProjectWeb.GameLive.Show do
  use ProjectWeb, :live_view

  alias Project.GameContext

  def render(assigns) do
    ~H"""
    <h1>Game ID: <%= @game.id %></h1>
    <div class="grid grid-cols-3">
      <%= for card <- @active_cards do %>
        <button phx-click="remove_card" phx-value-id={card}>
          <%= card %>
        </button>
      <% end %>
    </div>
    <div>
      <h2>Deck</h2>
      <%= for card <- @deck do %>
        <div><%= card %></div>
      <% end %>
    </div>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    game = GameContext.get_game!(id)

    {:ok,
     assign(socket,
       game: game,
       deck: game.deck,
       active_cards: game.active_cards,
       players: game.players
     )}
  end

  def handle_event("remove_card", %{"id" => card_id}, socket) do
    card_id = String.to_integer(card_id)
    game = socket.assigns.game
    IO.inspect(game)

    {new_active_cards, new_deck} = replace_card(game.active_cards, game.deck, card_id)

    updated_game = %{
      game
      | active_cards: new_active_cards,
        deck: new_deck
    }

    {:ok, _game} =
      GameContext.update_game(game, %{active_cards: new_active_cards, deck: new_deck})

    {:noreply,
     assign(socket,
       game: updated_game,
       deck: new_deck,
       active_cards: new_active_cards
     )}
  end

  defp replace_card(active_cards, deck, card_id) do
    # Find the index of the card to remove
    card_index = Enum.find_index(active_cards, fn x -> x == card_id end)

    # Get the next card from the deck, if available
    {next_card, remaining_deck} =
      if deck != [] do
        List.pop_at(deck, 0)
      else
        {nil, deck}
      end

    # Replace the removed card with the next card from the deck
    new_active_cards =
      if next_card != nil do
        case card_index do
          nil -> active_cards
          _ -> List.replace_at(active_cards, card_index, next_card)
        end
      else
        active_cards
      end

    {new_active_cards, remaining_deck}
  end
end
