defmodule AOC.Day13 do
  def solve_a do
    [dots, folds] =
      AOC.Utilities.read_lines('inputs/day13.txt')
      |> Enum.chunk_by(&String.contains?(&1, "fold"))

    dots = parse_dots(dots)
    folds = parse_folds(folds)

    fold(dots, folds |> Enum.at(0)) |> Enum.count()
  end

  def solve_b do
    [dots, folds] =
      AOC.Utilities.read_lines('inputs/day13.txt')
      |> Enum.chunk_by(&String.contains?(&1, "fold"))

    dots = parse_dots(dots)
    folds = parse_folds(folds)

    dots =
      folds
      |> Enum.reduce(dots, fn fold, acc ->
        fold(acc, fold)
      end)

    print_dots(dots)
  end

  defp print_dots(dots) do
    {min_x, max_x} = dots |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = dots |> Enum.map(&elem(&1, 1)) |> Enum.min_max()
    dots_set = MapSet.new(dots)

    for y <- min_y..max_y, x <- min_x..max_x do
      if x === min_x do
        IO.puts("")
      end

      if MapSet.member?(dots_set, {x, y}) do
        IO.write("#")
      else
        IO.write(" ")
      end
    end

    :ok
  end

  defp fold(dots, {fold_axis, fold_pos}) do
    dots
    |> Enum.map(fn {x, y} ->
      case fold_axis do
        "x" ->
          {if x > fold_pos do
             x - 2 * (x - fold_pos)
           else
             x
           end, y}

        "y" ->
          {x,
           if y > fold_pos do
             y - 2 * (y - fold_pos)
           else
             y
           end}
      end
    end)
    |> Enum.uniq()
  end

  defp parse_dots(dots) do
    dots
    |> Enum.map(fn dot ->
      [x, y] = String.split(dot, ",")
      {x |> Integer.parse() |> elem(0), y |> Integer.parse() |> elem(0)}
    end)
  end

  defp parse_folds(folds) do
    folds
    |> Enum.map(fn fold ->
      [_, axis, position] = Regex.run(~r/fold along ([x|y])=(\d+)/, fold)
      {axis, position |> Integer.parse() |> elem(0)}
    end)
  end
end
