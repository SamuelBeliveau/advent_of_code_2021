defmodule AOC.Day2 do
  def solve_a do
    instructions =
      AOC.Utilities.read_lines('inputs/day2.txt')
      |> Enum.map(&parse_instruction/1)

    {x, y} =
      instructions
      |> Enum.reduce({0, 0}, fn instr, {x, y} ->
        case instr do
          {"forward", amount} -> {x + amount, y}
          {"up", amount} -> {x, y - amount}
          {"down", amount} -> {x, y + amount}
        end
      end)

    x * y
  end

  def solve_b do
    instructions =
      AOC.Utilities.read_lines('inputs/day2.txt')
      |> Enum.map(&parse_instruction/1)

    {x, y, _} =
      instructions
      |> Enum.reduce({0, 0, 0}, fn instr, {x, y, aim} ->
        case instr do
          {"forward", amount} -> {x + amount, y + amount * aim, aim}
          {"up", amount} -> {x, y, aim - amount}
          {"down", amount} -> {x, y, aim + amount}
        end
      end)

    x * y
  end

  def parse_instruction(line) do
    [_, direction, amount] = Regex.run(~r/(\D+) (\d+)/, line)
    {direction, String.to_integer(amount)}
  end
end
