defmodule ProjectWeb.GameLive.Index do
  use ProjectWeb, :live_view

  alias Project.GameContext
  alias Project.Card

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :games, GameContext.list_games())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-xl mx-auto">
      <div class="grid place-items-center">
        <h1 class="text-4xl md:text-6xl font-bold mb-1">
          quickset<span class="text-[var(--primary)]">.online</span>
        </h1>
        <p class="text-lg">
          A free, real-time, multiplayer card game
        </p>
        <p class="text-lg">Challenge your visualization and logical reasoning!</p>
        <form phx-submit="create_game" class="my-24">
          <input
            type="text"
            id="name"
            name="name"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            required
            placeholder="Enter your name"
          />
          <button type="submit" class="btn mt-4 flex mx-auto">Play!</button>
        </form>
      </div>

      <h2 class="text-3xl mb-6">How to play</h2>

      <section class="grid mb-20">
        <h3 class="text-xl font-bold mb-1">
          1. The game starts with 12 cards on the table
        </h3>
        <p>
          Each card has a unique combination of 4 features: <b>number</b>, <b>shape</b>, <b>color</b>, and <b>shading</b>.
        </p>
        <div class="grid grid-cols-4 grid-rows-3 max-w-xl gap-3 mx-auto my-4">
          <div :for={index <- [13, 31, 73, 7, 36, 63, 74, 9, 44, 19, 60, 15]} class="card">
            <%= Card.render_card(index) %>
          </div>
        </div>
      </section>

      <section class="grid mb-20">
        <h3 class="text-xl font-bold mb-1">
          2. The goal is to make "sets".
        </h3>
        <p>
          A set is a group of 3 cards where each feature is <em>either</em>
          <b>all the same</b> or <b>all unique</b>.
        </p>

        <p>
          Here are the sets from the board above:
        </p>

        <div class="mx-auto text-center my-6">
          <div class="flex gap-3 justify-items-center max-w-md mb-2">
            <div :for={id <- [9, 36, 63]} class="card w-36 h-36">
              <%= Card.render_card(id) %>
            </div>
          </div>
          <p><b>Same:</b> Color, Shape and Shading</p>
          <p><b>Unique:</b> Number (1, 2, 3)</p>
        </div>

        <div class="mx-auto text-center my-6">
          <div class="flex gap-3 justify-items-center max-w-md mb-2">
            <div :for={id <- [7, 13, 19]} class="card w-36 h-36">
              <%= Card.render_card(id) %>
            </div>
          </div>
          <p><b>Same:</b> Number and Color</p>
          <p><b>Unique:</b> Shape and Shading</p>
        </div>

        <div class="mx-auto text-center my-6">
          <div class="flex gap-3 justify-items-center max-w-md mb-2">
            <div :for={id <- [13, 44, 63]} class="card w-36 h-36">
              <%= Card.render_card(id) %>
            </div>
          </div>
          <p><b>Same:</b> Shape</p>
          <p><b>Unique:</b> Number, Color, and Shading</p>
        </div>

        <div class="mx-auto text-center my-6">
          <div class="flex gap-3 justify-items-center max-w-md mb-2">
            <div :for={id <- [15, 31, 74]} class="card w-36 h-36">
              <%= Card.render_card(id) %>
            </div>
          </div>
          <p><b>Same:</b> Nothing</p>
          <p><b>Unique:</b> Number, Shape, Color, and Shading</p>
        </div>
      </section>

      <section class="grid mb-20">
        <h3 class="text-xl font-bold mb-1">3. Gotchas</h3>

        <div class="mx-auto text-center my-6 max-w-md">
          <b class="text-red-500">This is NOT a set</b>
          <div class="flex gap-3 justify-items-center max-w-md my-2">
            <div :for={id <- [15, 13, 9]} class="card w-36 h-36">
              <%= Card.render_card(id) %>
            </div>
          </div>
          <p class="text-balance">
            <b>Color</b> is <em>not</em> the <b>same</b> or <b>unique</b>
          </p>
        </div>

        <p class="mb-2">
          It can be tricky to spots sets sometimes, but keep in mind that for any two cards, there is
          <b>exactly</b>
          one card that would complete the set.
        </p>

        <div class="flex gap-3 justify-items-center items-center max-w-md my-2 mx-auto">
          <div class="card w-36 h-36">
            <%= Card.render_card(15) %>
          </div>
          <div class="card w-36 h-36">
            <%= Card.render_card(13) %>
          </div>
          <.icon name="hero-arrow-right" class="w-10 h-10" />
          <div class="card w-36 h-36">
            <%= Card.render_card(11) %>
          </div>
        </div>

        <div class="flex gap-3 justify-items-center items-center max-w-md my-2 mx-auto">
          <div class="card w-36 h-36">
            <%= Card.render_card(13) %>
          </div>
          <div class="card w-36 h-36">
            <%= Card.render_card(9) %>
          </div>
          <.icon name="hero-arrow-right" class="w-10 h-10" />
          <div class="card w-36 h-36">
            <%= Card.render_card(17) %>
          </div>
        </div>

        <div class="flex gap-3 justify-items-center items-center max-w-md my-2 mx-auto">
          <div class="card w-36 h-36">
            <%= Card.render_card(15) %>
          </div>
          <div class="card w-36 h-36">
            <%= Card.render_card(9) %>
          </div>
          <.icon name="hero-arrow-right" class="w-10 h-10" />
          <div class="card w-36 h-36">
            <%= Card.render_card(12) %>
          </div>
        </div>
      </section>

      <section class="grid mb-20 gap-2">
        <h3 class="text-xl font-bold">4. Gameplay</h3>
        <ul class="list-disc pl-6">
          <li>
            <b>There are no turns in this game,</b>
            the first player to make a set collects those cards and scores a point.
          </li>
          <li>
            3 new cards are dealt from the deck. The game continues until the deck is exhausted.
          </li>
          <li>
            You can play solo, or with friends. On the same device, or by sharing a link!
          </li>
        </ul>
      </section>

      <div class="grid place-items-center">
        <h1 class="text-4xl font-bold mb-1">
          Ready to play?
        </h1>
        <form phx-submit="create_game" class="my-12">
          <input
            type="text"
            id="name"
            name="name"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            required
            placeholder="Enter your name"
          />
          <button type="submit" class="btn mt-4 flex mx-auto">Play!</button>
        </form>
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

# <div class="grid gap-4">
#           <h2>About</h2>
#           <p>
#             Quickset is a real-time, multiplayer card game based on the game 'Set' by Marsha Falco in 1974.
#           </p>
#           <p>
#             The game consists of 81 unique cards, each varying in four features: number of shapes (one, two, or three), shape (square, circle, diamond), shading (solid, striped, open), and color (orange, green, purple).
#           </p>
#           <p>
#             Players must identify a "set" of three cards that either all share the same features or all have different features across all categories.
#           </p>
#         </div>
