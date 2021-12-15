defmodule AOC.Utilities do
  def read_lines(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split(~r/[\n|\r\n]/, trim: true)
  end
end
