defmodule GameOfLife.RLETest do
  alias GameOfLife.Board
  alias GameOfLife.RLE

  use ExUnit.Case
  doctest GameOfLife.RLE

  test "RLE.to_rle" do
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

    rle = RLE.to_rle(board)
    assert rle == "x = 8, y = 8, name = state\n8b$8b$8b$8b$8b$6bob$7bo$5b3o!\n"

    re_board = RLE.from_rle(rle)
    assert re_board == board
  end

  test "RLE.from_rle with multiple digits" do
    rle =
      "
# Some comment
x = 12, y = 3, name = whatever
12b$3bo8b$12o!
"

    board = RLE.from_rle(rle)

    assert board.height == 3
    assert board.width == 12

    assert board.grid ==
             [
               [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
               [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
               [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
             ]
  end

  test "RLE.to_rle_string" do
    grid =
      [
        [0, 1, 0, 1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0, 1, 0, 1]
      ]

    rle_string = RLE.to_rle_string(grid)

    assert rle_string ==
             "bobobobo$bobobobo$bobobobo$bobobobo$bobobobo$bobobobo$bobobobo$bobobob\no!"

    re_grid = RLE.from_rle_string(rle_string)
    assert re_grid == grid
  end

  test "RLE.from_rle_string with \\r and a missing final !" do
    rle_string =
      "bobobobo$bobobobo$bobobobo$bobobobo$bobobobo$bobobobo$bobobobo$bobobob\ro"

    grid = RLE.from_rle_string(rle_string)

    assert grid ==
             [
               [0, 1, 0, 1, 0, 1, 0, 1],
               [0, 1, 0, 1, 0, 1, 0, 1],
               [0, 1, 0, 1, 0, 1, 0, 1],
               [0, 1, 0, 1, 0, 1, 0, 1],
               [0, 1, 0, 1, 0, 1, 0, 1],
               [0, 1, 0, 1, 0, 1, 0, 1],
               [0, 1, 0, 1, 0, 1, 0, 1],
               [0, 1, 0, 1, 0, 1, 0, 1]
             ]
  end
end
