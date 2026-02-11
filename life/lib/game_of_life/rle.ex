defmodule GameOfLife.RLE do
  alias GameOfLife.Board

  @shortdoc "Run length encoding for Game of Life patterns"
  @moduledoc @shortdoc

  @spec to_rle(Board.t()) :: binary()
  def to_rle(%Board{grid: grid, height: height, width: width}) do
    rle_string = to_rle_string(grid)
    "x = #{width}, y = #{height}, name = state\n#{rle_string}\n"
  end

  defp encode_rle_char(nil, _), do: ""
  defp encode_rle_char(:eol, _), do: "$"
  defp encode_rle_char(0, 1), do: "b"
  defp encode_rle_char(0, count), do: "#{count}b"
  defp encode_rle_char(1, 1), do: "o"
  defp encode_rle_char(1, count), do: "#{count}o"

  @spec to_rle_string(Board.grid()) :: binary()
  def to_rle_string(grid) do
    {:ok, pid} = StringIO.open("")

    _ =
      grid
      |> Enum.map(&(&1 ++ [:eol]))
      |> List.flatten()
      |> Enum.reduce({nil, 0}, fn x, {prev, count} ->
        if x == prev or prev == nil do
          {x, count + 1}
        else
          IO.write(pid, encode_rle_char(prev, count))

          {x, 1}
        end
      end)

    IO.write(pid, "!")

    {_, out} = StringIO.contents(pid)
    out |> String.split("", trim: true) |> Enum.chunk_every(70) |> Enum.join("\n")
  end

  @spec from_rle(binary()) :: Board.t()
  def from_rle(string) do
    lines = String.split(string, ~r/\r\n|\r|\n/)

    rle_string =
      lines
      |> Enum.reject(fn line ->
        String.starts_with?(line, "#") or String.starts_with?(line, "x =")
      end)
      |> Enum.join("")

    grid = from_rle_string(rle_string)

    {width, height} =
      lines
      |> Enum.find("x = 0, y = 0", fn line -> String.starts_with?(line, "x =") end)
      |> parse_dimensions()

    %Board{grid: grid, height: height, width: width}
  end

  @spec parse_dimensions(binary()) :: {integer(), integer()}
  defp parse_dimensions(str) do
    parts =
      str
      |> String.split(", ")
      |> Enum.map(fn part ->
        part
        |> String.split(" = ")
      end)

    [["x", x], ["y", y] | _] = parts

    {String.to_integer(x), String.to_integer(y)}
  end

  @spec from_rle_string(binary()) :: Board.grid()
  def from_rle_string(rle_string) do
    rle_string |> from_rle_string_reversed() |> reverse_grid()
  end

  @spec reverse_grid(Board.grid()) :: Board.grid()
  defp reverse_grid(grid) do
    grid
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.reverse()
    |> Enum.map(&Enum.reverse/1)
  end

  defp next_char(""), do: {:eof, ""}

  defp next_char(<<char::utf8, rest::binary>>) do
    {<<char::utf8>>, rest}
  end

  @spec from_rle_string_reversed(binary(), Board.grid(), integer() | nil) ::
          Board.grid()
  defp from_rle_string_reversed(rle_string, grid \\ [[]], count \\ nil) do
    {c, rest_rle_string} = next_char(rle_string)

    [last_row | other_rows] = grid

    case c do
      c when c in [:eof, "!"] ->
        grid

      c when c in ["\r", "\n"] ->
        from_rle_string_reversed(rest_rle_string, grid, count)

      "$" ->
        from_rle_string_reversed(rest_rle_string, [[] | grid])

      <<char::utf8>> when char in ?0..?9 ->
        from_rle_string_reversed(rest_rle_string, grid, (count || 0) * 10 + String.to_integer(c))

      c when c in ["o", "b"] ->
        cell = if(c == "o", do: 1, else: 0)
        row = List.duplicate(cell, count || 1) ++ last_row
        from_rle_string_reversed(rest_rle_string, [row | other_rows])
    end
  end
end
