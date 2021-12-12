defmodule AOC.Day12 do
  def solve_a do
    AOC.Utilities.read_lines('inputs/day12.txt')
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, fn link, graph ->
      build_graph(graph, link)
    end)
    |> then(&walk_in_graph(&1, "start", []))
  end

  def solve_b do
    graph =
      AOC.Utilities.read_lines('inputs/day12.txt')
      |> Enum.map(&parse/1)
      |> Enum.reduce(%{}, fn link, graph ->
        build_graph(graph, link)
      end)

    Map.keys(graph)
    |> Enum.filter(&(is_small_cave(&1) and &1 not in ["start", "end"]))
    |> Enum.reduce([], fn small_cave, acc ->
      [walk_in_graph_b(graph, "start", [], small_cave), acc]
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  defp parse(line) do
    [_, from, to] = Regex.run(~r/([a-zA-Z]+)-([a-zA-Z]+)/, line)
    {from, to}
  end

  defp build_graph(graph, {from, to}) do
    graph |> Map.update(from, [to], &[to | &1]) |> Map.update(to, [from], &[from | &1])
  end

  defp walk_in_graph(_, "end", _) do
    1
  end

  defp walk_in_graph(graph, node, visited) do
    visited = [node | visited]

    graph[node]
    |> Enum.reject(fn dest -> is_small_cave(dest) and Enum.any?(visited, &(&1 === dest)) end)
    |> Enum.reduce(0, fn dest, acc ->
      acc + walk_in_graph(graph, dest, visited)
    end)
  end

  defp walk_in_graph_b(_, "end", visited, _) do
    ["end" | visited] |> Enum.reverse() |> to_string()
  end

  defp walk_in_graph_b(graph, node, visited, special_cave) do
    visited = [node | visited]

    graph[node]
    |> Enum.reject(fn dest ->
      is_small_cave(dest) and special_cave !== dest and Enum.count(visited, &(&1 === dest)) >= 1
    end)
    |> Enum.reject(fn dest ->
      special_cave === dest and Enum.count(visited, &(&1 === dest)) >= 2
    end)
    |> Enum.reduce([], fn dest, acc ->
      [walk_in_graph_b(graph, dest, visited, special_cave) | acc]
    end)
  end

  defp is_small_cave(node) do
    node === String.downcase(node)
  end
end
