require 'Piece' # testing

class InvalidMoveError < NoMethodError
end


class Board # Need to know: Game#current_player

  def initialize
    @grid = Array.new(10) { ["_"] * 10 }
    @captured_pieces = []

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

    perform_moves!(move_sequence)
  end

  def valid_move_sequence?(color, move_sequence)
    start_pos = move_sequence.first
    return false unless piece_at(start_pos).color == color

    # SLIDE ONLY ALLOWED WHEN NO JUMP POSSIBLE
    move_is_a_jump?(move_sequence) ? valid_jump_sequence?(color, move_sequence) : valid_slide_move?(move_sequence)
  end

  def move_is_a_jump?(move_sequence)
    start_pos = move_sequence.first
    second_pos = move_sequence[1]
    (start_pos.first - second_pos.first).abs > 1
  end

  def valid_slide_move?(move_sequence)
    start_pos = move_sequence.first
    end_pos = move_sequence.last

    return false unless piece_at(end_pos) == "_"

    piece_at(start_pos).slide_moves.any? do |slide_move|
      x_lines_up = start_pos[0] + slide_move[0] == end_pos[0]
      y_lines_up = start_pos[1] + slide_move[1] == end_pos[1]
      x_lines_up && y_lines_up
    end
  end

  def valid_jump_sequence?(color, move_sequence)
    move_sequence.each_with_index do |pos, move_idx|
      next if pos == move_sequence.last
      return false unless this_jump_possible?(color, pos, move_sequence[move_idx + 1])
    end
    true
  end

  def this_jump_possible?(color, start_pos, end_pos)
    # JUMP ONLY POSSIBLE WHEN OPPONENT PIECE IS WITHIN SLIDE MOVE
    return false unless piece_at(end_pos) == "_"
    piece_at(start_pos).jump_moves.any? do |jump_move|
      xs_line_up = start_pos.first + jump_move.first == end_pos.first
      ys_line_up = start_pos.last + jump_move.last == end_pos.last
      xs_line_up && ys_line_up && jumping_over_opponent?(color, start_pos, jump_move)
    end
  end

  def jumping_over_opponent?(color, start_pos, jump_move)
    half_jump_x, half_jump_y = jump_move[0]/2, jump_move[1]/2
    intermediate_square_x = start_pos[0] + half_jump_x
    intermediate_square_y = start_pos[1] + half_jump_y
    intermediate_square = [intermediate_square_x, intermediate_square_y]
    if piece_at(intermediate_square) != color && piece_at(intermediate_square) != "_"
      @captured_pieces << piece_at(intermediate_square)
    end
    piece_at(intermediate_square) != color && piece_at(intermediate_square) != "_"
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

board = Board.new
board.perform_moves(:o, [[6,1],[5,2]] )
board.perform_moves(:x, [[3,4],[4,3]] )
board.perform_moves(:o, [[5,2],[3,4]] )

