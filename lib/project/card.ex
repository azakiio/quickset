defmodule Project.Card do
  # Define your attributes
  @counts [1, 2, 3]
  @shapes ["square", "circle", "diamond"]
  @fills ["solid", "striped", "empty"]
  @colors ["green", "orange", "purple"]

  def generate_card_data(card_id) do
    attribute_string = Integer.to_string(card_id, 3) |> String.pad_leading(4, "0")

    count_index = String.at(attribute_string, 0) |> String.to_integer()
    shape_index = String.at(attribute_string, 1) |> String.to_integer()
    fill_index = String.at(attribute_string, 2) |> String.to_integer()
    color_index = String.at(attribute_string, 3) |> String.to_integer()

    %{
      id: card_id,
      count: Enum.at(@counts, count_index),
      shape: Enum.at(@shapes, shape_index),
      fill: Enum.at(@fills, fill_index),
      color: Enum.at(@colors, color_index)
    }
  end

  def render_card(card_index) do
    if is_number(card_index) do
      %{count: count, shape: shape, fill: fill, color: color} =
        generate_card_data(card_index)

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
  defp fill_color("striped", color), do: "hsl(from #{color} h s l / 0.25)"
  defp fill_color("empty", _color), do: "transparent"
end
