defmodule AOC.Utilities do
  def read_lines(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
  end
end
