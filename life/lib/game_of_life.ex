defmodule GameOfLife do
  alias GameOfLife.Board
  alias GameOfLife.Markdown
  alias GameOfLife.RLE

  @moduledoc false

  @markdown_file_path "../README.md"

  @spec update_markdown(Board.t()) :: :ok
  def update_markdown(board) do
    {:ok, contents} = File.read(@markdown_file_path)
    md = Markdown.replace_markdown(contents, board)
    :ok = File.write(@markdown_file_path, md)
  end

  @rle_file_path "../life.rle"

  @spec load_rle :: Board.t()
  def load_rle do
    {:ok, contents} = File.read(@rle_file_path)
    RLE.from_rle(contents)
  end

  @spec save_rle(Board.t()) :: :ok
  def save_rle(board) do
    contents = RLE.to_rle(board)
    :ok = File.write(@rle_file_path, contents)
  end

  @spec main :: :ok
  def main do
    board = load_rle()
    new_board = Board.tick(board)
    save_rle(new_board)

    Board.print_board(new_board)
    update_markdown(new_board)
  end
end
