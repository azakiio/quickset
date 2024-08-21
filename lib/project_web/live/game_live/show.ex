defmodule ProjectWeb.GameLive.Show do
  use ProjectWeb, :live_view
  import Phoenix.HTML
  alias Project.GameContext

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
    <div class="grid grid-cols-3 gap-4 p-4">
      <%= for card_index <- @active_cards do %>
        <% card = generate_card_data(card_index) %>
        <button class="card" phx-click="select_card" phx-value-card={card.id}>
          <%= render_card(card) %>
        </button>
      <% end %>
    </div>
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
    game = socket.assigns.game
    selected_cards = socket.assigns.selected_cards

    selected_cards =
      if card in selected_cards do
        List.delete(selected_cards, card)
      else
        selected_cards ++ [card]
      end

    result =
      if length(selected_cards) == 3 do
        GameContext.update_game_with_set(game, selected_cards, ~c"player_1")
      else
        GameContext.update_game(game, %{selected_cards: selected_cards})
      end

    case result do
      {:ok, updated_game} ->
        {:noreply,
         assign(socket,
           game: updated_game,
           selected_cards: updated_game.selected_cards,
           active_cards: updated_game.active_cards,
           deck: updated_game.deck,
           players: updated_game.players
         )}

      {:error, _reason} ->
        {:noreply, assign(socket, selected_cards: selected_cards)}
    end
  end

  defp generate_card_data(card_index) do
    counts = [1, 2, 3]
    shapes = ["square", "circle", "diamond"]
    fills = ["solid", "opacity_50", "no_fill"]
    colors = ["green", "orange", "purple"]

    attribute_string = Integer.to_string(card_index, 3) |> String.pad_leading(4, "0")
    count_index = String.at(attribute_string, 0) |> String.to_integer()
    shape_index = String.at(attribute_string, 1) |> String.to_integer()
    fill_index = String.at(attribute_string, 2) |> String.to_integer()
    color_index = String.at(attribute_string, 3) |> String.to_integer()

    %{
      id: card_index,
      count: Enum.at(counts, count_index),
      shape: Enum.at(shapes, shape_index),
      fill: Enum.at(fills, fill_index),
      color: Enum.at(colors, color_index)
    }
  end

  defp render_card(%{count: count, shape: shape, fill: fill, color: color}) do
    card_svg =
      for _ <- 1..count do
        case shape do
          "square" ->
            """
            <svg width="50" height="50" class="card-svg">
              <rect width="30" height="30" fill="#{fill_color(fill, color)}" stroke="#{color}" stroke-width="2"/>
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
              <polygon points="25,0 50,25 25,50 0,25" fill="#{fill_color(fill, color)}" stroke="#{color}" stroke-width="2"/>
            </svg>
            """
        end
      end
      |> Enum.join("\n")

    Phoenix.HTML.raw(card_svg)
  end

  defp fill_color("solid", _color), do: "currentColor"
  defp fill_color("opacity_50", color), do: "red"
  defp fill_color("no_fill", _color), do: "none"
end
