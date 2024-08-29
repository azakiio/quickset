defmodule ProjectWeb.GameLive.Show do
  use ProjectWeb, :live_view
  alias Project.GameContext
  alias Project.Card
  alias Phoenix.PubSub

  @topic_prefix "game:"

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: PubSub.subscribe(Project.PubSub, topic(id))

    case GameContext.get_game!(id) do
      nil ->
        {:ok,
         socket
         |> push_navigate(to: "/")}

      game ->
        {:ok,
         socket
         |> push_event("restore", %{key: "name", event: "restoreSettings"})
         |> assign(game: game, name: "Guest_#{:rand.uniform(99999)}", any_sets: false)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-flow-col justify-between items-center">
      <button class="btn" phx-click={JS.dispatch("phx:copy")}>Invite</button>
      <div class="font-bold">
        <%= if @name do %>
          <%= @name %>
        <% end %>
      </div>
      <button class="btn-neutral" phx-click="reset_game">Reset Game</button>
    </div>

    <div class="grid grid-cols-4 gap-4 py-4 grid-rows-3">
      <%= for card <- @game.active_cards do %>
        <button
          class="card"
          disabled={!card}
          aria-selected={card in @game.selected_cards}
          phx-click="select_card"
          phx-value-card={card}
        >
          <%= render_card(card) %>
        </button>
      <% end %>
    </div>
    <div class="grid grid-flow-col justify-end">
      <div>
        <%= if @any_sets do %>
          <div class="font-bold text-green-500">
            There is a set!
          </div>
        <% end %>
      </div>
      <button class="btn" phx-click="any_set">Any Sets?</button>
      <div class="font-bold">
        <%= length(@game.deck) %> <.icon name="hero-square-2-stack-solid" class="w-10 h-10" />
      </div>
    </div>

    <%= if @game.players do %>
      <div class="players">
        <h2 class="text-xl font-bold">Players and Scores</h2>
        <ul>
          <%= for {player_id, player_cards} <- @game.players do %>
            <li>
              <%= player_id %>: <%= div(length(player_cards), 3) %>
            </li>
          <% end %>
        </ul>
      </div>
    <% end %>
    """
  end

  @impl true
  def handle_event("restoreSettings", token_data, socket) do
    IO.puts("token_data: #{token_data}")

    {:noreply, assign(socket, :name, token_data)}
  end

  def handle_event("reset_game", _, socket) do
    game = socket.assigns.game

    {:ok, updated_game} = GameContext.reset_game(game)
    broadcast_update(socket, updated_game)

    {:noreply,
     assign(socket,
       game: updated_game
     )}
  end

  def handle_event("select_card", %{"card" => card}, socket) do
    card = String.to_integer(card)
    selected_cards = socket.assigns.game.selected_cards

    selected_cards =
      if card in selected_cards do
        List.delete(selected_cards, card)
      else
        selected_cards ++ [card]
      end

    if length(selected_cards) == 3 do
      Process.send_after(self(), {:finalize_selection, selected_cards}, 1000)

      {:noreply,
       update(socket, :game, fn state -> Map.put(state, :selected_cards, selected_cards) end)}
    else
      {:noreply,
       update(socket, :game, fn state -> Map.put(state, :selected_cards, selected_cards) end)}
    end
  end

  def handle_event("any_set", _, socket) do
    active_cards = socket.assigns.game.active_cards

    any_sets = GameContext.is_set?(active_cards)

    {:noreply, assign(socket, :any_sets, any_sets)}
  end

  def handle_info({:finalize_selection, selected_cards}, socket) do
    game = socket.assigns.game
    result = GameContext.update_game_with_set(game, selected_cards, socket.assigns.name)

    case result do
      {:ok, updated_game} ->
        broadcast_update(socket, updated_game)

        {:noreply,
         assign(socket,
           game: updated_game
         )}

      {:error, _reason} ->
        {:noreply,
         update(socket, :game, fn state -> Map.put(state, :selected_cards, selected_cards) end)}
    end
  end

  def handle_info({:game_update, updated_game}, socket) do
    {:noreply,
     assign(socket,
       game: updated_game
     )}
  end

  defp broadcast_update(_socket, updated_game) do
    PubSub.broadcast(
      Project.PubSub,
      topic(updated_game.id),
      {:game_update, updated_game}
    )
  end

  defp topic(game_id), do: @topic_prefix <> to_string(game_id)

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
