defmodule AOC.Day8 do
  def solve_a do
    AOC.Utilities.read_lines('inputs/day8.txt')
    |> Enum.map(&parse/1)
    |> Enum.map(&(elem(&1, 1) |> Enum.filter(fn v -> is_unique_digit(v) end) |> Enum.count()))
    |> Enum.sum()
  end

  def solve_b do
    AOC.Utilities.read_lines('inputs/day8.txt')
    |> Enum.map(&parse/1)
    |> Enum.map(&decode/1)
    |> Enum.sum()
  end

  def decode({patterns, output}) do
    grouped =
      patterns |> Enum.group_by(&String.length/1, &MapSet.new(&1 |> String.split("", trim: true)))

    decoded = %{
      1 => grouped[2] |> hd(),
      4 => grouped[4] |> hd(),
      7 => grouped[3] |> hd(),
      8 => grouped[7] |> hd()
    }

    decoded =
      decoded
      |> Map.merge(%{
        2 => grouped[5] |> Enum.find(nil, &(MapSet.union(decoded[4], &1) |> MapSet.size() === 7)),
        3 => grouped[5] |> Enum.find(nil, &(MapSet.union(decoded[1], &1) |> MapSet.size() === 5)),
        6 => grouped[6] |> Enum.find(nil, &(MapSet.union(decoded[1], &1) |> MapSet.size() === 7)),
        9 => grouped[6] |> Enum.find(nil, &(MapSet.union(decoded[4], &1) |> MapSet.size() === 6))
      })

    decoded =
      decoded
      |> Map.merge(%{
        0 =>
          grouped[6]
          |> Enum.find(
            nil,
            &(not MapSet.subset?(decoded[6], &1) and not MapSet.subset?(decoded[9], &1))
          ),
        5 => grouped[5] |> Enum.find(nil, &(MapSet.union(decoded[2], &1) |> MapSet.size() === 7))
      })

    decoded = Map.new(decoded, fn {key, val} -> {val, key} end)

    [thousands, hundreds, tens, units] =
      output
      |> Enum.map(&MapSet.new(&1 |> String.split("", trim: true)))
      |> Enum.map(&decoded[&1])

    thousands * 1000 + hundreds * 100 + tens * 10 + units
  end

  defp is_unique_digit(value) do
    case String.length(value) do
      x when x in [2, 3, 4, 7] -> true
      _ -> false
    end
  end

  defp parse(line) do
    line
    |> String.split("|")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> then(fn entry ->
      [patterns, output] = entry
      {patterns, output}
    end)
  end
end
