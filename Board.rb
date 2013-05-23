require 'Move_validator'

class InvalidMoveError < NoMethodError
end


class Board
  include MoveValidator

  def initialize
    @grid = Array.new(10) { ["_"] * 10 }
    @captured_pieces = []

    place_pieces

    render
  end

  def render
  letters = "    " + ("A"..'J').to_a.join("   ")
  puts letters
  @grid.each_with_index do |row, y_coord|
    print "#{y_coord} |"
    print row.join(" | ")
    puts "| #{y_coord}"
  end
  puts letters
  end

  def place_pieces
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |square, column_index|
        row[column_index] = Piece.new(:x) if row_index.between?(0, 3) && (row_index + column_index).odd?
        row[column_index] = Piece.new(:o) if row_index.between?(6, 9) && (row_index + column_index).odd?
      end
    end
  end

  def piece_at(pos)
    x_coord, y_coord = pos
    @grid[x_coord][y_coord]
  end

  def perform_moves(player, move_sequence)

    color = player.color

    raise InvalidMoveError unless valid_move_sequence?(player, move_sequence)

    perform_moves!(move_sequence)
  end

  def perform_moves!(move_sequence)
    clear_prisoners_from_board

    start_pos, end_pos = move_sequence.first, move_sequence.last

    starting_x, starting_y = start_pos
    ending_x, ending_y = end_pos

    moved_piece = piece_at(start_pos)
    @grid[starting_x][starting_y] = "_"
    @grid[ending_x][ending_y] = moved_piece

    render
  end

  def clear_prisoners_from_board
    @captured_pieces.each do |captured_piece|
      @grid.each do |row|
        row.each_index do |column_index|
          row[column_index] = "_" if row[column_index] == captured_piece
        end
      end
    end
  end

end