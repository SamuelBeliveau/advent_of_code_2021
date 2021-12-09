defmodule AOC.Day9 do
  def solve_a do
    heat_map =
      AOC.Utilities.read_lines('inputs/day9.txt')
      |> then(&parse_heatmap/1)

    find_low_points(heat_map)
    |> Enum.map(&(heat_map[&1] + 1))
    |> Enum.sum()
  end

  def solve_b do
    heat_map =
      AOC.Utilities.read_lines('inputs/day9.txt')
      |> then(&parse_heatmap/1)

    find_low_points(heat_map)
    |> Enum.map(&discover_basin(heat_map, &1))
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  defp discover_basin(heat_map, curr_point, visited_set \\ MapSet.new()) do
    curr_value = heat_map[curr_point]
    {x, y} = curr_point

    cond do
      curr_value === nil or curr_value === 9 ->
        visited_set

      MapSet.new([curr_point]) |> MapSet.subset?(visited_set) ->
        visited_set

      true ->
        visited_set = MapSet.union(visited_set, MapSet.new([curr_point]))
        visited_set = MapSet.union(visited_set, discover_basin(heat_map, {x - 1, y}, visited_set))
        visited_set = MapSet.union(visited_set, discover_basin(heat_map, {x + 1, y}, visited_set))
        visited_set = MapSet.union(visited_set, discover_basin(heat_map, {x, y - 1}, visited_set))
        MapSet.union(visited_set, discover_basin(heat_map, {x, y + 1}, visited_set))
    end
  end

  defp parse_heatmap(lines) do
    lines
    |> Enum.map(
      &(String.split(&1, "", trim: true)
        |> Enum.map(fn char -> Integer.parse(char) |> elem(0) end)
        |> Enum.with_index())
    )
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row_map = Map.new(row, fn {number, x} -> {{x, y}, number} end)
      Map.merge(acc, row_map)
    end)
  end

  defp find_low_points(heat_map) do
    for(y <- 0..99, x <- 0..99, do: {x, y})
    |> Enum.filter(&is_low_point(heat_map, &1))
  end

  defp is_low_point(heat_map, {x, y}) do
    current_val = heat_map[{x, y}]
    top = heat_map[{x, y - 1}] == nil or current_val < heat_map[{x, y - 1}]
    bottom = heat_map[{x, y + 1}] == nil or current_val < heat_map[{x, y + 1}]
    left = heat_map[{x - 1, y}] == nil or current_val < heat_map[{x - 1, y}]
    right = heat_map[{x + 1, y}] == nil or current_val < heat_map[{x + 1, y}]
    top and bottom and left and right
  end
end
