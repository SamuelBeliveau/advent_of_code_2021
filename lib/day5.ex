defmodule AOC.Day5 do
  def solve_a() do
    lines =
      AOC.Utilities.read_lines('inputs/day5.txt')
      |> Enum.map(&parse/1)
      |> Enum.filter(fn {{x1, y1}, {x2, y2}} -> x1 === x2 or y1 === y2 end)

    for(
      line1 <- lines,
      line2 <- lines,
      line1 !== line2,
      do: {min(line1, line2), max(line1, line2)}
    )
    |> Enum.sort()
    |> Enum.dedup()
    |> Enum.reduce(MapSet.new(), fn {line1, line2}, acc ->
      new_intersections = find_intersections(line1, line2)

      MapSet.union(acc, new_intersections)
    end)
    |> MapSet.size()
  end

  def solve_b() do
    lines =
      AOC.Utilities.read_lines('inputs/day5.txt')
      |> Enum.map(&parse/1)

    for(
      line1 <- lines,
      line2 <- lines,
      line1 !== line2,
      do: {min(line1, line2), max(line1, line2)}
    )
    |> Enum.sort()
    |> Enum.dedup()
    |> Enum.reduce(MapSet.new(), fn {line1, line2}, acc ->
      new_intersections = find_intersections(line1, line2)

      MapSet.union(acc, new_intersections)
    end)
    |> MapSet.size()
  end

  def parse(line) do
    [_ | coords] = Regex.run(~r/(\d+),(\d+) -> (\d+).(\d+)/, line)
    [x1, y1, x2, y2] = coords |> Enum.map(&(Integer.parse(&1) |> elem(0)))
    {{x1, y1}, {x2, y2}}
  end

  def find_intersections(line1, line2) do
    line1_coords = get_path(line1)
    line2_coords = get_path(line2)
    MapSet.intersection(line1_coords, line2_coords)
  end

  def get_path({{x1, y1}, {x2, y2}}) do
    cond do
      # Vertical or horizontal
      x1 === x2 or y1 === y2 ->
        for(x <- x1..x2, y <- y1..y2, do: {x, y}) |> MapSet.new()

      # Diagonal
      true ->
        0..abs(x2 - x1)
        |> Enum.map(fn i ->
          x =
            if x2 > x1 do
              x1 + i
            else
              x1 - i
            end

          y =
            if y2 > y1 do
              y1 + i
            else
              y1 - i
            end

          {x, y}
        end)
        |> MapSet.new()
    end
  end
end
