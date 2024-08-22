defmodule ProjectWeb.GameLive.Show do
  use ProjectWeb, :live_view
  alias Project.GameContext
  alias Project.Card

  def mount(%{"id" => id}, _session, socket) do
    game = GameContext.get_game!(id)

    {:ok,
     assign(socket,
       game: game,
       deck: game.deck,
       active_cards: game.active_cards,
       selected_cards: game.selected_cards,
       players: game.players
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-between">
      <button class="btn">Copy Url</button>
      <button phx-click="reset_game">Reset Game</button>
    </div>
    <div class="grid grid-cols-3 gap-4 py-4 grid-rows-4">
      <%= for card <- @active_cards do %>
        <button
          class="card"
          disabled={!card}
          aria-selected={card in @selected_cards}
          phx-click="select_card"
          phx-value-card={card}
        >
          <%= render_card(card) %>
        </button>
      <% end %>
    </div>

    <%= if @players do %>
      <div class="players">
        <h2 class="text-xl font-bold">Players and Scores</h2>
        <ul>
          <%= for {player_id, player_cards} <- @players do %>
            <li>
              <%= player_id %>: <%= div(length(player_cards), 3) %>
            </li>
          <% end %>
        </ul>
      </div>
    <% end %>
    """
  end

  def handle_event("reset_game", _, socket) do
    game = socket.assigns.game

    {:ok, updated_game} =
      GameContext.reset_game(game)

    {:noreply,
     assign(socket,
       game: updated_game,
       deck: updated_game.deck,
       selected_cards: updated_game.selected_cards,
       active_cards: updated_game.active_cards,
       players: updated_game.players
     )}
  end

  def handle_event("select_card", %{"card" => card}, socket) do
    card = String.to_integer(card)
    selected_cards = socket.assigns.selected_cards

    selected_cards =
      if card in selected_cards do
        List.delete(selected_cards, card)
      else
        selected_cards ++ [card]
      end

    if length(selected_cards) == 3 do
      Process.send_after(self(), {:finalize_selection, selected_cards}, 1000)
      {:noreply, assign(socket, selected_cards: selected_cards)}
    else
      {:noreply, assign(socket, selected_cards: selected_cards)}
    end
  end

  def handle_info({:finalize_selection, selected_cards}, socket) do
    game = socket.assigns.game
    result = GameContext.update_game_with_set(game, selected_cards, ~s"noob")

    case result do
      {:ok, updated_game} ->
        {:noreply,
         assign(socket,
           game: updated_game,
           selected_cards: [],
           active_cards: updated_game.active_cards,
           deck: updated_game.deck,
           players: updated_game.players
         )}

      {:error, _reason} ->
        {:noreply, assign(socket, selected_cards: [])}
    end
  end

  defp render_card(card_index) do
    if is_number(card_index) do
      %{count: count, shape: shape, fill: fill, color: color} =
        Card.generate_card_data(card_index)

      card_svg =
        for _ <- 1..count do
          case shape do
            "square" ->
              """
              <svg width="50" height="50" class="card-svg">
                <rect x="5" y="5" width="40" height="40" fill="#{fill_color(fill, color)}" stroke="#{color}" stroke-width="2" rx="4" ry="4" stroke-linejoin="round" />
              </svg>
              """

            "circle" ->
              """
              <svg width="50" height="50" class="card-svg">
                <circle cx="25" cy="25" r="20" fill="#{fill_color(fill, color)}" stroke="#{color}" stroke-width="2"/>
              </svg>
              """

            "diamond" ->
              """
              <svg width="50" height="50" class="card-svg">
                <polygon points="25,2 48,25 25,48 2,25" fill="#{fill_color(fill, color)}" stroke="#{color}" stroke-width="2" stroke-linejoin="round"/>
              </svg>
              """
          end
        end
        |> Enum.join("\n")

      Phoenix.HTML.raw(card_svg)
    else
      Phoenix.HTML.raw("")
    end
  end

  defp fill_color("solid", color), do: color
  defp fill_color("striped", color), do: "hsl(from #{color} h s l / 0.4)"
  defp fill_color("empty", _color), do: "transparent"
end
