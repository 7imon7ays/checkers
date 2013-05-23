require 'Piece' # testing

class InvalidMoveError < NoMethodError
end


class Board # Need to know: Game#current_player

  def initialize
    @grid = Array.new(10) { ["_"] * 10 }

    place_pieces

    render
  end

  def render
  letters = "    " + ("0"..'9').to_a.join("   ")
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
    # takes position coordinates and returns a piece object
  end

  def perform_moves(move_sequence)

    # move_sequence is just an array of coordinate arrays.

    # valid_move_sequence?
    # if yes, perform_moves! otherwise InvalidMoveError

    raise InvalidMoveError unless valid_move_sequence?(move_sequence)

    perform_moves!
  end

  def valid_move_sequence?(move_sequence)
    # board dups itself

    # does the move start from a piece of current_player?
    return false unless piece_at(start_pos).color == current_player.color

    # Iterate over each coordinate set in the move_sequence:
      # from this_pos to next_pos
      # is next_pos reachable from this_pos? if not, return false.
        # a slide move is only allowed when no jump moves are allowed
        # a jump_move is only possible when an opponent piece
        # is at a slide_move position.

    # If you get through the iteration, return true.
  end

  def perform_moves!(move_sequence)
    # moves the piece and removes captured pieces.


    render
  end

end

board = Board.new