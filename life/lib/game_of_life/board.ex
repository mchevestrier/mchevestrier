defmodule GameOfLife.Board do
  alias GameOfLife.Board

  @shortdoc "Game of Life board"
  @moduledoc @shortdoc

  defstruct [:grid, :height, :width]

  @type cell :: 0 | 1
  @type grid :: list(list(cell()))

  @type t :: %__MODULE__{
          grid: grid(),
          height: integer(),
          width: integer()
        }

  @spec mod(integer(), integer()) :: integer()
  defp mod(a, n), do: rem(rem(a, n) + n, n)

  @spec at(Board.t(), integer(), integer()) :: cell()
  def at(%Board{grid: grid, height: height, width: width}, i, j) do
    row = Enum.at(grid, mod(i, height), [])
    Enum.at(row, mod(j, width), 0)
  end

  @spec count_neighbors_at(Board.t(), integer(), integer()) :: integer()
  defp count_neighbors_at(board, i, j) do
    [
      at(board, i - 1, j - 1),
      at(board, i - 1, j),
      at(board, i - 1, j + 1),
      #
      at(board, i, j - 1),
      at(board, i, j + 1),
      #
      at(board, i + 1, j - 1),
      at(board, i + 1, j),
      at(board, i + 1, j + 1)
    ]
    |> Enum.sum()
  end

  @spec next_at(Board.t(), integer(), integer()) :: cell()
  defp next_at(board, i, j) do
    case count_neighbors_at(board, i, j) do
      2 -> at(board, i, j)
      3 -> 1
      _ -> 0
    end
  end

  @spec tick(Board.t()) :: Board.t()
  def tick(board) do
    grid =
      for i <- 0..(board.height - 1) do
        for j <- 0..(board.width - 1) do
          next_at(board, i, j)
        end
      end

    %{board | grid: grid}
  end

  @spec print_with(IO.device(), Board.t(), binary(), binary(), binary()) :: :ok
  defp print_with(device, %Board{grid: grid}, on, off, break) do
    contents =
      Enum.map_join(
        grid,
        break,
        fn row -> Enum.map(row, &if(&1 == 1, do: on, else: off)) end
      )

    IO.puts(device, contents)
  end

  @spec print_board(IO.device(), Board.t()) :: :ok
  def print_board(device \\ :stdio, board),
    do: print_with(device, board, "⬛", "⬜", "\n")
end
