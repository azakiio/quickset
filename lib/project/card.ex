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
end
