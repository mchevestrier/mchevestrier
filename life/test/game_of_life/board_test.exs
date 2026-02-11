defmodule GameOfLife.BoardTest do
  alias GameOfLife.Board

  use ExUnit.Case
  doctest GameOfLife.Board

  test "Board.at" do
    board = %Board{grid: [[1, 2], [3, 4]], height: 2, width: 8}
    assert Board.at(board, 0, 0) == 1
    assert Board.at(board, 0, 1) == 2
    assert Board.at(board, 1, 0) == 3
    assert Board.at(board, 1, 1) == 4
  end

  test "Board.tick" do
    grid = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 0, 0],
      [0, 0, 0, 1, 1, 1, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0]
    ]

    board = %Board{grid: grid, height: 8, width: 8}

    new_board =
      Board.tick(board)

    assert new_board.grid ==
             [
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 1, 0, 1, 0, 0],
               [0, 0, 0, 0, 1, 1, 0, 0],
               [0, 0, 0, 0, 1, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0]
             ]
  end

  test "Board.tick should wrap around" do
    grid = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0, 1, 1, 1]
    ]

    board = %Board{grid: grid, height: 8, width: 8}

    new_board =
      Board.tick(board)

    assert new_board.grid ==
             [
               [0, 0, 0, 0, 0, 0, 1, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 0, 0, 1, 0, 1],
               [0, 0, 0, 0, 0, 0, 1, 1]
             ]
  end

  test "Board.print_board" do
    grid =
      [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 1],
        [0, 0, 0, 0, 0, 1, 1, 1]
      ]

    board = %Board{grid: grid, height: 8, width: 8}

    {:ok, pid} = StringIO.open("")
    Board.print_board(pid, board)
    {_, out} = StringIO.contents(pid)

    assert out ==
             "⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬛⬜
⬜⬜⬜⬜⬜⬜⬜⬛
⬜⬜⬜⬜⬜⬛⬛⬛
"
  end
end
