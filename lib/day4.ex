defmodule AOC.Day4 do
  def solve_a do
    lines = AOC.Utilities.read_lines('inputs/day4.txt')
    {numbers, boards} = lines |> parse_lines()
    draw_next_number(boards, numbers)
  end

  def solve_b do
    lines = AOC.Utilities.read_lines('inputs/day4.txt')
    {numbers, boards} = lines |> parse_lines()
    draw_next_number_b(boards, numbers)
  end

  defp parse_lines(lines) do
    [numbers | boards_section] = lines

    numbers =
      numbers |> String.split(",", trim: true) |> Enum.map(&(Integer.parse(&1) |> elem(0)))

    boards = boards_section |> Enum.chunk_every(5) |> Enum.map(&parse_board/1)

    {numbers, boards}
  end

  defp parse_board(raw_board) do
    raw_board
    |> Enum.with_index()
    |> Enum.map(fn {row, row_idx} ->
      row
      |> String.split(" ", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {number, col_idx} ->
        {number |> Integer.parse() |> elem(0), row_idx, col_idx}
      end)
    end)
    |> List.flatten()
    |> Enum.reduce({%{}, %{}}, fn {number, row_idx, col_idx}, {numbers_status, board} ->
      {Map.put(numbers_status, number, :unmarked), Map.put(board, "#{row_idx}#{col_idx}", number)}
    end)
  end

  defp draw_next_number(_, []), do: nil

  defp draw_next_number(boards, numbers) do
    [number | numbers] = numbers

    boards =
      boards
      |> Enum.map(fn {numbers_status, board} ->
        {numbers_status |> Map.put(number, :marked), board}
      end)

    bingos = boards |> Enum.filter(&check_bingo/1)

    if length(bingos) > 0 do
      [board] = bingos
      %{board: board, score: calculate_score(board, number)}
    else
      draw_next_number(boards, numbers)
    end
  end

  defp draw_next_number_b(_, []), do: nil

  defp draw_next_number_b(boards, numbers) do
    [number | numbers] = numbers

    boards =
      boards
      |> Enum.map(fn {numbers_status, board} ->
        {numbers_status |> Map.put(number, :marked), board}
      end)

    bingos = boards |> Enum.filter(&check_bingo/1)
    non_bingos = boards |> Enum.filter(&(check_bingo(&1) === false))

    if length(non_bingos) === 0 do
      [board] = bingos
      %{board: board, score: calculate_score(board, number)}
    else
      draw_next_number_b(non_bingos, numbers)
    end
  end

  defp calculate_score({numbers_status, _}, number) do
    numbers_status
    |> Map.to_list()
    |> Enum.filter(fn {_, status} -> status === :unmarked end)
    |> Enum.map(fn {key, _} -> key end)
    |> Enum.sum()
    |> then(&(&1 * number))
  end

  defp check_bingo(board_data) do
    0..4 |> Enum.any?(&(check_row(board_data, &1) || check_col(board_data, &1)))
  end

  defp check_row({numbers_status, board}, row_idx) do
    0..4
    |> Enum.map(&"#{row_idx}#{&1}")
    |> Enum.all?(&(numbers_status[board[&1]] === :marked))
  end

  defp check_col({numbers_status, board}, col_idx) do
    0..4
    |> Enum.map(&"#{&1}#{col_idx}")
    |> Enum.all?(&(numbers_status[board[&1]] === :marked))
  end
end
