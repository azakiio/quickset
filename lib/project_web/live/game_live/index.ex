defmodule ProjectWeb.GameLive.Index do
  use ProjectWeb, :live_view

  alias Project.GameContext

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :games, GameContext.list_games())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid place-items-center">
      <h1 class="text-6xl font-bold">quickset<span class="text-[var(--primary)]">.online</span></h1>
      <div>Challenge your visualization and logical reasoning!</div>
      <form phx-submit="create_game" class="my-24">
        <input
          type="text"
          id="name"
          name="name"
          class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          required
          placeholder="Enter your name"
        />
        <button type="submit" class="btn mt-4 flex mx-auto">Create Game</button>
      </form>
      <div class="grid grid-cols-[repeat(auto-fit,minmax(300px,1fr))] gap-8">
        <div class="grid gap-4">
          <h2>About</h2>
          <p>
            Quickset is a real-time, multiplayer card game based on the game 'Set' by Marsha Falco in 1974.
          </p>
          <p>
            The game consists of 81 unique cards, each varying in four features: number of shapes (one, two, or three), shape (square, circle, diamond), shading (solid, striped, open), and color (orange, green, purple).
          </p>
          <p>
            Players must identify a "set" of three cards that either all share the same features or all have different features across all categories.
          </p>
        </div>
        <div class="grid gap-4">
          <h2>How to play</h2>
          <p>Start with 12 cards on the table</p>
          <p>
            Look for a "set" of three cards that meet the conditions: <b>all the same</b> <em>or</em>
            <b>all different</b> in number, shape, shading, and color.
          </p>
          <p>
            If you see a set, just click on the cards to select them. There are no turns in this game, the first player to make a set gets those cards.
          </p>
          <p>
            Once a set is made, the cards are replaced with new ones from the deck. The game continues until the deck is exhausted.
          </p>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("create_game", %{"name" => name}, socket) do
    # Create a new game and get its ID
    {:ok, game} = GameContext.create_game()

    socket = socket |> push_event("store", %{key: "name", data: name})

    {:noreply, socket |> push_navigate(to: ~p"/#{game.id}")}
  end
end
