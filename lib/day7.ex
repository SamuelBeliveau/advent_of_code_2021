defmodule AOC.Day7 do
  def solve_a do
    sorted =
      AOC.Utilities.read_lines('inputs/day7.txt')
      |> Enum.at(0)
      |> String.split(",", trim: true)
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))
      |> Enum.sort()

    {min, max} = sorted |> Enum.min_max()

    min..max
    |> Enum.map(&move(sorted, &1, 0))
    |> Enum.min()
  end

  def solve_b do
    sorted =
      AOC.Utilities.read_lines('inputs/day7.txt')
      |> Enum.at(0)
      |> String.split(",", trim: true)
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))
      |> Enum.sort()

    {min, max} = sorted |> Enum.min_max()

    min..max
    |> Enum.map(&move_b(sorted, &1, 0))
    |> Enum.min()
  end

  defp move([], _, fuel_consumed), do: fuel_consumed

  defp move(crabs, destination, fuel_consumed) do
    [crab | rest] = crabs

    move(rest, destination, fuel_consumed + abs(destination - crab))
  end

  defp move_b([], _, fuel_consumed), do: fuel_consumed

  defp move_b(crabs, destination, fuel_consumed) do
    [crab | rest] = crabs

    fuel_cost = 0..abs(destination - crab) |> Enum.sum()

    move_b(rest, destination, fuel_consumed + fuel_cost)
  end
end
