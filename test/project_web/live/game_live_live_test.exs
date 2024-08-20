defmodule ProjectWeb.GameLiveLiveTest do
  use ProjectWeb.ConnCase

  import Phoenix.LiveViewTest
  import Project.GameFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_game_live(_) do
    game_live = game_live_fixture()
    %{game_live: game_live}
  end

  describe "Index" do
    setup [:create_game_live]

    test "lists all games", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/games")

      assert html =~ "Listing Games"
    end

    test "saves new game_live", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/games")

      assert index_live |> element("a", "New Game live") |> render_click() =~
               "New Game live"

      assert_patch(index_live, ~p"/games/new")

      assert index_live
             |> form("#game_live-form", game_live: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#game_live-form", game_live: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/games")

      html = render(index_live)
      assert html =~ "Game live created successfully"
    end

    test "updates game_live in listing", %{conn: conn, game_live: game_live} do
      {:ok, index_live, _html} = live(conn, ~p"/games")

      assert index_live |> element("#games-#{game_live.id} a", "Edit") |> render_click() =~
               "Edit Game live"

      assert_patch(index_live, ~p"/games/#{game_live}/edit")

      assert index_live
             |> form("#game_live-form", game_live: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#game_live-form", game_live: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/games")

      html = render(index_live)
      assert html =~ "Game live updated successfully"
    end

    test "deletes game_live in listing", %{conn: conn, game_live: game_live} do
      {:ok, index_live, _html} = live(conn, ~p"/games")

      assert index_live |> element("#games-#{game_live.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#games-#{game_live.id}")
    end
  end

  describe "Show" do
    setup [:create_game_live]

    test "displays game_live", %{conn: conn, game_live: game_live} do
      {:ok, _show_live, html} = live(conn, ~p"/games/#{game_live}")

      assert html =~ "Show Game live"
    end

    test "updates game_live within modal", %{conn: conn, game_live: game_live} do
      {:ok, show_live, _html} = live(conn, ~p"/games/#{game_live}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Game live"

      assert_patch(show_live, ~p"/games/#{game_live}/show/edit")

      assert show_live
             |> form("#game_live-form", game_live: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#game_live-form", game_live: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/games/#{game_live}")

      html = render(show_live)
      assert html =~ "Game live updated successfully"
    end
  end
end
