defmodule AOC.Day10 do
  def solve_a do
    AOC.Utilities.read_lines('inputs/day10.txt')
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&check/1)
    |> Enum.sum()
  end

  def solve_b do
    AOC.Utilities.read_lines('inputs/day10.txt')
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&{&1, check(&1)})
    |> Enum.reject(fn {_, score} -> score > 0 end)
    |> Enum.map(fn {line, _} -> autocomplete(line) end)
    |> Enum.sort()
    |> Enum.at(23)
  end

  defp autocomplete(line, score \\ 0, stack \\ [])

  defp autocomplete([], score, []) do
    score
  end

  defp autocomplete([], score, stack) do
    [next | stack_rest] = stack
    autocomplete([], score * 5 + get_autocomplete_score(next), stack_rest)
  end

  defp autocomplete(line, _, stack) do
    [next | line_rest] = line

    if is_opening?(next) do
      autocomplete(line_rest, 0, [next | stack])
    else
      autocomplete(line_rest, 0, stack |> tl())
    end
  end

  defp get_autocomplete_score("(") do
    1
  end

  defp get_autocomplete_score("[") do
    2
  end

  defp get_autocomplete_score("{") do
    3
  end

  defp get_autocomplete_score("<") do
    4
  end

  defp check(line, stack \\ [])

  defp check([], _) do
    0
  end

  defp check(line, stack) do
    [next | line_rest] = line
    stack_peek = stack |> List.first()

    if is_opening?(next) do
      check(line_rest, [next | stack])
    else
      if closing_matches?(stack_peek, next) do
        check(line_rest, stack |> tl())
      else
        get_score(next)
      end
    end
  end

  defp get_score(")") do
    3
  end

  defp get_score("]") do
    57
  end

  defp get_score("}") do
    1197
  end

  defp get_score(">") do
    25137
  end

  defp is_opening?(char) do
    ["(", "{", "[", "<"] |> Enum.any?(&(&1 === char))
  end

  defp closing_matches?("(", ")") do
    true
  end

  defp closing_matches?("{", "}") do
    true
  end

  defp closing_matches?("[", "]") do
    true
  end

  defp closing_matches?("<", ">") do
    true
  end

  defp closing_matches?(_, _) do
    false
  end
end
