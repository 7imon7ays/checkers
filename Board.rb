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
    x_coord, y_coord = pos
    @grid[x_coord][y_coord]
  end

  def perform_moves(player, move_sequence)

    # move_sequence is just an array of coordinate arrays.

    # valid_move_sequence?
    # if yes, perform_moves! otherwise InvalidMoveError

    raise InvalidMoveError unless valid_move_sequence?(player, move_sequence)

    perform_moves!
  end

  def valid_move_sequence?(color, move_sequence)

    start_pos = move_sequence.first
    return false unless piece_at(start_pos).color == color

    move_is_a_jump?(move_sequence) ? valid_jump_move?(move_sequence) : valid_slide_move?(move_sequence)
  end

  def move_is_a_jump?(move_sequence)
    start_pos = move_sequence.first
    second_pos = move_sequence[1]
    (start_pos.first - second_pos.first).abs > 1
  end

  def valid_jump_move?(move_sequence)
    move_sequence.each_with_index do |pos, move_idx|
      return true if pos == move_sequence.last
      return false unless this_jump_possible?(pos, move_sequence[move_idx + 1])
    end
  end

  def this_jump_possible?(start_pos, end_pos)
    piece_at(start_pos).jump_moves.any? do |jump_move|
      xs_line_up = start_pos.first + jump_move.first == end_pos.first
      ys_line_up = start_pos.last + jump_move.last == end_pos.last
      xs_line_up && ys_line_up
    end
  end

  def valid_slide_move?(move_sequence)
    start_pos = move_sequence.first
    end_pos = move_sequence.last
    piece_at(start_pos).slide_moves.any? do |slide_move|
      x_lines_up = start_pos[0] + slide_move[0] == end_pos[0]
      y_lines_up = start_pos[1] + slide_move[1] == end_pos[1]
      x_lines_up && y_lines_up
    end
  end



    # Iterate over each coordinate set in the move_sequence:
      # from this_pos to next_pos
      # is next_pos reachable from this_pos? if not, return false.
        # a slide move is only allowed when no jump moves are allowed
        # a jump_move is only possible when an opponent piece
        # is at a slide_move position.

    # If you get through the iteration, return true.

  def perform_moves!(move_sequence)
    # moves the piece and removes captured pieces.


    render
  end

end

board = Board.new

