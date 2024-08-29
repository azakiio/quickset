defmodule ProjectWeb.GameLive.Admin do
  use ProjectWeb, :live_view

  alias Project.GameContext

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :games, GameContext.list_games())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <table class="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Deck</th>
            <th></th>
            <th></th>
          </tr>
        </thead>
        <tbody id="games" phx-update="stream">
          <tr :for={{id, game} <- @streams.games} id={id}>
            <td class="p-2"><%= inspect(game.id) %></td>
            <td class="p-2"><%= length(game.deck) %></td>
            <td>
              <.link class="btn" navigate={"/#{game.id}"} phx-click="delete" phx-value-id={game.id}>
                Open
              </.link>
            </td>
            <td>
              <a href="#" class="btn" phx-click="delete" phx-value-id={game.id}>Delete</a>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="grid grid-cols-2 gap-4">
        <div class="grid gap-4">
          <h2>About</h2>
          <p>skribbl.io is a free online multiplayer drawing and guessing pictionary game.</p>
          <p>
            A normal game consists of a few rounds, where every round a player has to draw their chosen word and others have to guess it to gain points!
          </p>
          <p>
            The person with the most points at the end of the game, will then be crowned as the winner!
            Have fun!
          </p>
        </div>
        <div class="grid gap-4">
          <h2>How to play</h2>
          <p>skribbl.io is a free online multiplayer drawing and guessing pictionary game.</p>
          <p>
            A normal game consists of a few rounds, where every round a player has to draw their chosen word and others have to guess it to gain points!
          </p>
          <p>
            The person with the most points at the end of the game, will then be crowned as the winner!
            Have fun!
          </p>
        </div>
      </div>
    </div>
    """
  end

  # def handle_params(params, _url, socket) do
  #   # {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Game")
  #   |> assign(:game, GameContext.get_game!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Game")
  #   |> assign(:game, %Game{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Games")
  #   |> assign(:game, nil)
  # end

  @impl true
  def handle_info({ProjectWeb.GameLive.FormComponent, {:saved, game}}, socket) do
    {:noreply, stream_insert(socket, :games, game)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = GameContext.get_game!(id)
    {:ok, _} = GameContext.delete_game(game)

    {:noreply, stream_delete(socket, :games, game)}
  end

  @impl true
  def handle_event("create_game", _params, socket) do
    case GameContext.create_game() do
      {:ok, game} ->
        # Redirect to the new game's page
        {:noreply, redirect(socket, to: "/#{game.id}")}

      {:error, _changeset} ->
        # Handle the error, perhaps re-render the form with an error message
        {:noreply, assign(socket, :error, "Failed to create game")}
    end
  end
end
