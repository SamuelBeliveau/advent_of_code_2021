defmodule AOC.Day14 do
  def solve_a do
    [template, insertions] =
      AOC.Utilities.read_lines('inputs/day14.txt')
      |> Enum.chunk_by(&String.contains?(&1, "->"))

    template = Enum.at(template, 0)

    insertions = parse_insertions(insertions)

    1..10
    |> Enum.reduce(template, fn _, acc ->
      run_step(acc, insertions)
    end)
    |> String.graphemes()
    |> Enum.frequencies()
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
  end

  def solve_b do
    [template, insertions] =
      AOC.Utilities.read_lines('inputs/day14.txt')
      |> Enum.chunk_by(&String.contains?(&1, "->"))

    template = Enum.at(template, 0)

    insertions = parse_insertions(insertions)

    freqs = template |> String.graphemes() |> Enum.frequencies()

    template =
      template
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, [""])
      |> Enum.map(fn [a, b] -> {a <> b, 1} end)
      |> Enum.group_by(fn {k, _} -> k end, fn {_, v} -> v end)
      |> Enum.map(fn {k, v} -> {k, v |> Enum.sum()} end)
      |> Enum.into(%{})

    {_, freqs} =
      1..40
      |> Enum.reduce({template, freqs}, fn _, {t, f} ->
        run_step_fast(t, f, insertions)
      end)

    freqs
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
  end

  defp run_step(template, insertions) do
    pairs = template |> String.graphemes() |> Enum.chunk_every(2, 1, [""])

    pairs
    |> Enum.map(fn [a, b] ->
      insertion = insertions[a <> b]

      if insertion === nil do
        [a]
      else
        [a, insertion]
      end
    end)
    |> List.flatten()
    |> List.to_string()
  end

  defp run_step_fast(template, freqs, insertions) do
    template
    |> Enum.reduce({%{}, freqs}, fn {pair, count}, {t, f} ->
      insertion = insertions[pair]

      if insertion === nil do
        {t |> Map.update(pair, count, &(&1 + count)), f}
      else
        [a, b] = pair |> String.graphemes()

        {t
         |> Map.update(a <> insertion, count, &(&1 + count))
         |> Map.update(insertion <> b, count, &(&1 + count)),
         f |> Map.update(insertion, count, &(&1 + count))}
      end
    end)
  end

  defp parse_insertions(insertions) do
    insertions
    |> Enum.reduce(%{}, fn insertion, acc ->
      [_, left, right] = Regex.run(~r/([A-Z]+) -> ([A-Z]+)/, insertion)
      Map.put(acc, left, right)
    end)
  end
end
