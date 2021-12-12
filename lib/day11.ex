defmodule AOC.Day11 do
  def solve_a do
    map = AOC.Utilities.read_lines('inputs/day11.txt') |> then(&parse/1)

    0..99
    |> Enum.reduce({map, 0}, fn _, {m, f} ->
      run_step(m, f)
    end)
  end

  def solve_b do
    map = AOC.Utilities.read_lines('inputs/day11.txt') |> then(&parse/1)

    Enum.reduce_while(1..500, {map, 0}, fn step, {m, f} ->
      {new_m, new_f} = run_step(m, f)

      if new_f - f === 100 do
        {:halt, step}
      else
        {:cont, {new_m, new_f}}
      end
    end)
  end

  defp run_step(map, flashes) do
    for(x <- 0..9, y <- 0..9, do: {x, y})
    |> Enum.reduce({map, flashes}, fn {x, y}, {m, f} ->
      inc_energy(m, {x, y}, f)
    end)
    |> then(fn {map, flashes} -> {reset(map), flashes} end)
  end

  def reset(map) do
    Map.new(Map.to_list(map), fn {k, v} ->
      {k,
       if v > 9 do
         0
       else
         v
       end}
    end)
  end

  defp inc_energy(map, pos, flashes) do
    map = Map.update!(map, pos, &(&1 + 1))

    if map[pos] === 10 do
      neighbour_pos(pos)
      |> Enum.reduce({map, flashes + 1}, fn n_pos, {m, f} ->
        inc_energy(m, n_pos, f)
      end)
    else
      {map, flashes}
    end
  end

  defp neighbour_pos({x, y}) do
    for(
      i <- (x - 1)..(x + 1),
      j <- (y - 1)..(y + 1),
      {i, j} != {x, y} and i in 0..9 and j in 0..9,
      do: {i, j}
    )
  end

  defp parse(lines) do
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
end
