defmodule GameOfLife.MarkdownTest do
  alias GameOfLife.Board
  alias GameOfLife.Markdown

  use ExUnit.Case
  doctest GameOfLife.Markdown

  test "Markdown.replace_markdown" do
    prev_markdown = "
# Some content before

<!-- begin auto-generated game of life board -->

|     | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 1   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 2   | ◻️  | ◻️  | ◻️  | ◼️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 3   | ◻️  | ◻️  | ◻️  | ◻️  | ◼️  | ◻️  | ◻️  | ◻️  |
| 4   | ◻️  | ◻️  | ◼️  | ◼️  | ◼️  | ◻️  | ◻️  | ◻️  |
| 5   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 6   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 7   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |

<!-- end auto-generated game of life board -->

And more content after
"

    grid =
      [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
      ]

    board = %Board{grid: grid, height: 8, width: 8}

    new_markdown = Markdown.replace_markdown(prev_markdown, board)

    assert new_markdown == "
# Some content before

<!-- begin auto-generated game of life board -->

|     | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 1   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 2   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 3   | ◻️  | ◻️  | ◼️  | ◻️  | ◼️  | ◻️  | ◻️  | ◻️  |
| 4   | ◻️  | ◻️  | ◻️  | ◼️  | ◼️  | ◻️  | ◻️  | ◻️  |
| 5   | ◻️  | ◻️  | ◻️  | ◼️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 6   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |
| 7   | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  | ◻️  |

<!-- end auto-generated game of life board -->

And more content after
"
  end
end
