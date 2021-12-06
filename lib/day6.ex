defmodule AOC.Day6 do
  def solve do
    fishes =
      AOC.Utilities.read_lines('inputs/day6.txt')
      |> Enum.at(0)
      |> String.split(",", trim: true)
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))
      |> Enum.frequencies()

    advance_fast(fishes, 1)
  end

  def advance_slow(fishes, 20) do
    length(fishes)
  end

  def advance_slow(fishes, day) do
    {next, babies} =
      fishes
      |> Enum.reduce({[], []}, fn fish, {next_fishes, babies} ->
        next_fish =
          if fish > 0 do
            fish - 1
          else
            6
          end

        new_babies =
          if fish === 0 do
            [8 | babies]
          else
            babies
          end

        {[next_fish | next_fishes], new_babies}
      end)

    next_fishes = Enum.concat(next |> Enum.reverse(), babies)

    advance_slow(next_fishes, day + 1)
  end

  def advance_fast(fish_freq, 257) do
    fish_freq |> Map.values() |> Enum.sum()
  end

  def advance_fast(fish_freq, day) do
    %{
      0 => fish_freq[1] || 0,
      1 => fish_freq[2] || 0,
      2 => fish_freq[3] || 0,
      3 => fish_freq[4] || 0,
      4 => fish_freq[5] || 0,
      5 => fish_freq[6] || 0,
      6 => (fish_freq[0] || 0) + (fish_freq[7] || 0),
      7 => fish_freq[8] || 0,
      # babies!
      8 => fish_freq[0] || 0
    }
    |> advance_fast(day + 1)
  end
end
