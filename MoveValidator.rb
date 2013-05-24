module MoveValidator

  def valid_move_sequence?(player, move_sequence)

    color = player.color

    start_pos = move_sequence.first

    p "move_sequence: #{move_sequence}"
    move_sequence.each { |position| p piece_at(position)}

    p "current player: #{color}"
    p "piece at start pos: #{piece_at(start_pos).color}"

    return false if piece_at(start_pos) == "_"
    return false unless piece_at(start_pos).color == color

    # SLIDE ONLY ALLOWED WHEN NO JUMP POSSIBLE

    puts "move is a jump? #{move_is_a_jump?(move_sequence)}"

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

    p "piece's deltas: #{piece_at(start_pos).slide_moves}"

    piece_at(start_pos).slide_moves.any? do |slide_move|
      x_lines_up = start_pos[0] + slide_move[0] == end_pos[0]
      y_lines_up = start_pos[1] + slide_move[1] == end_pos[1]
      x_lines_up && y_lines_up
    end
  end

  def valid_jump_sequence?(color, move_sequence)
    grid = @grid.deep_dup

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

end