defmodule AOC.Day3 do
  def solve_a do
    binaries = AOC.Utilities.read_lines('inputs/day3.txt')

    frequencies =
      binaries
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.frequencies/1)

    {gamma, _} =
      frequencies
      |> Enum.map(fn freq ->
        if freq["0"] > freq["1"] do
          "0"
        else
          "1"
        end
      end)
      |> then(&List.to_string/1)
      |> then(fn s -> s |> Integer.parse(2) end)

    {epsilon, _} =
      frequencies
      |> Enum.map(fn freq ->
        if freq["0"] > freq["1"] do
          "1"
        else
          "0"
        end
      end)
      |> then(&List.to_string/1)
      |> then(fn s -> s |> Integer.parse(2) end)

    gamma * epsilon
  end

  def solve_b do
    binaries = AOC.Utilities.read_lines('inputs/day3.txt')

    tuple_list =
      binaries
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&List.to_tuple/1)

    {oxygen, _} = search(tuple_list, 0, &find_common_bit/2) |> Integer.parse(2)
    {co2, _} = search(tuple_list, 0, &find_uncommon_bit/2) |> Integer.parse(2)
    {oxygen, co2, oxygen * co2}
  end

  def search([tuple], _, _) do
    tuple |> Tuple.to_list() |> List.to_string()
  end

  def search(tuple_list, position, strategy) do
    common_bit =
      tuple_list
      |> strategy.(position)

    search(
      tuple_list |> Enum.filter(&(elem(&1, position) === common_bit)),
      position + 1,
      strategy
    )
  end

  def find_common_bit(tuple_list, position) do
    tuple_list
    |> Enum.map(&elem(&1, position))
    |> Enum.frequencies()
    |> then(fn %{"0" => zeroes, "1" => ones} ->
      case zeroes - ones do
        diff when diff < 0 or diff === 0 -> "1"
        diff when diff > 0 -> "0"
      end
    end)
  end

  def find_uncommon_bit(tuple_list, position) do
    tuple_list
    |> Enum.map(&elem(&1, position))
    |> Enum.frequencies()
    |> then(fn %{"0" => zeroes, "1" => ones} ->
      case zeroes - ones do
        diff when diff < 0 or diff === 0 -> "0"
        diff when diff > 0 -> "1"
      end
    end)
  end
end
