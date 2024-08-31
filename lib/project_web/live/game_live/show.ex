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
        IO.inspect(GameContext.find_valid_sets(game.active_cards), charlists: :as_lists)

        {:ok,
         socket
         |> push_event("restore", %{key: "name", event: "restoreSettings"})
         |> assign(
           game: game,
           name: "Guest_#{:rand.uniform(99999)}",
           valid_sets: GameContext.find_valid_sets(game.active_cards),
           show_sets: false,
           selected_cards: []
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-flow-col justify-between items-center">
      <button class="btn" phx-click={JS.dispatch("phx:copy")}>Invite</button>
      <div class="text-lg font-bold">
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
          aria-selected={card in @selected_cards}
          phx-click="select_card"
          phx-value-card={card}
        >
          <%= Card.render_card(card) %>
        </button>
      <% end %>
    </div>

    <div class="grid grid-cols-[3fr,1fr]">
      <%= if @game.players do %>
        <div class="players">
          <h2 class="text-xl font-bold">Scores</h2>
          <div>
            <%= for {player_id, player_cards} <- @game.players do %>
              <div class="text-lg font-bold grid grid-flow-col auto-cols-max items-center gap-2">
                <.icon name="hero-user-circle" class="w-10 h-10 text-[var(--primary)]" />
                <%= player_id %>: <%= div(length(player_cards), 3) %>
                <div class="flex ml-2">
                  <%= for id <- Enum.take(player_cards, -3) do %>
                    <%= Card.render_card(id) %>
                  <% end %>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>

      <div class="font-bold justify-self-end">
        <%= length(@game.deck) %> <.icon name="hero-square-2-stack-solid" class="w-10 h-10" />
        <button class={if @show_sets, do: "btn-primary", else: "btn-neutral"} phx-click="toggle_sets">
          Help!
        </button>
      </div>
    </div>

    <%= if @show_sets do %>
      <div class="grid grid-cols-[repeat(auto-fill,minmax(150px,1fr))] gap-4 mt-12">
        <div
          :for={card <- @valid_sets}
          class="grid gap-1 border-2 rounded-lg p-2 justify-items-center"
        >
          <%= for id <- card do %>
            <div class="card">
              <%= Card.render_card(id) %>
            </div>
          <% end %>
        </div>
      </div>
    <% end %>
    """
  end

  @impl true
  def handle_event("restoreSettings", token_data, socket) do
    {:noreply, assign(socket, :name, token_data)}
  end

  def handle_event("reset_game", _, socket) do
    game = socket.assigns.game

    {:ok, updated_game} = GameContext.reset_game(game)
    broadcast_update(socket, updated_game)

    {:noreply,
     assign(socket,
       game: updated_game,
       valid_sets: GameContext.find_valid_sets(game.active_cards),
       selected_cards: []
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
      {:noreply, assign(socket, :selected_cards, selected_cards)}
    else
      {:noreply, assign(socket, :selected_cards, selected_cards)}
    end
  end

  def handle_event("toggle_sets", _, socket) do
    {:noreply, assign(socket, show_sets: !socket.assigns.show_sets)}
  end

  @impl true
  def handle_info({:finalize_selection, selected_cards}, socket) do
    game = socket.assigns.game
    result = GameContext.update_game_with_set(game, selected_cards, socket.assigns.name)

    case result do
      {:ok, updated_game} ->
        broadcast_update(socket, updated_game)

        if length(updated_game.selected_cards) == 0 do
          {:noreply,
           assign(socket,
             game: updated_game,
             selected_cards: []
           )}
        end

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  def handle_info({:game_update, updated_game}, socket) do
    {:noreply,
     assign(socket,
       game: updated_game,
       valid_sets: GameContext.find_valid_sets(updated_game.active_cards)
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
end
