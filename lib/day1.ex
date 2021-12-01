defmodule AOC.Day1 do
  def solve_a do
    numbers =
      AOC.Utilities.read_lines('inputs/day1.txt')
      |> Enum.map(&String.to_integer/1)

    numbers
    |> Enum.reduce({nil, 0}, fn n, {prev, c} ->
      if prev < n do
        {n, c + 1}
      else
        {n, c}
      end
    end)
  end

  def solve_b do
    numbers =
      AOC.Utilities.read_lines('inputs/day1.txt')
      |> Enum.map(&String.to_integer/1)

    numbers
    |> Enum.reduce({[], 0}, fn n, {prev, c} ->
      next =
        case prev do
          [] -> [n]
          [a] -> [a, n]
          [a, b] -> [a, b, n]
          [_, b, c] -> [b, c, n]
        end

      prevSum = Enum.sum(prev)
      nextSum = Enum.sum(next)

      if length(prev) === 3 and prevSum < nextSum do
        {next, c + 1}
      else
        {next, c}
      end
    end)
  end
end
