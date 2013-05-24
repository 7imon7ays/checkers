module MoveValidator

  def valid_move_sequence?(player, move_sequence)

    color = player.color

    start_pos = move_sequence.first

    return false if piece_at(@grid, start_pos) == "_"
    return false unless piece_at(@grid, start_pos).color == color

    move_is_a_jump?(move_sequence) ? valid_jump_sequence?(color, move_sequence) : valid_slide_move?(color, move_sequence)
  end

  def move_is_a_jump?(move_sequence)
    start_pos = move_sequence.first
    second_pos = move_sequence[1]
    (start_pos.first - second_pos.first).abs > 1
  end

  def valid_slide_move?(color, move_sequence)
    start_pos = move_sequence.first
    end_pos = move_sequence.last

    return false unless piece_at(@grid, end_pos) == "_"
    return false if jump_move_available?(color)

    piece_at(@grid, start_pos).slide_moves.any? do |slide_move|
      x_lines_up = start_pos[0] + slide_move[0] == end_pos[0]
      y_lines_up = start_pos[1] + slide_move[1] == end_pos[1]
      x_lines_up && y_lines_up
    end
  end

  def jump_move_available?(color)
    team_positions = get_team_positions(color)

    team_positions.any? do |team_position|
      moves_to_check = look_around_for_jumps(color, team_position)
      moves_to_check.any? do |move_to_check|
        valid_jump_sequence?(color, move_to_check)
      end
    end
  end

  def look_around_for_jumps(color, start_pos)
    x, y = start_pos
    perimeter = [
      [x + 2, y + 2],
      [x - 2, y - 2],
      [x + 2, y - 2],
      [x - 2, y + 2]
    ]

    perimeter.map { |destination| [start_pos, destination] }
  end

  def get_team_positions(color)
    team_positions = []
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |position, column_index|
        unless position == "_" || position.color != color
          team_positions << [row_index, column_index]
        end
      end
    end
    team_positions
  end

  def valid_jump_sequence?(color, move_sequence)
    grid = @grid.deep_dup

    move_sequence.each_with_index do |pos, move_idx|
      next if pos == move_sequence.last

      if this_jump_possible?(grid, color, pos, move_sequence[move_idx + 1])
        perform_moves!(grid, [pos, move_sequence[move_idx + 1]])
      else
        return false
      end
    end
    true
  end

  def this_jump_possible?(grid, color, start_pos, end_pos)
    return false unless piece_at(grid, end_pos) == "_"
    piece_at(grid, start_pos).jump_moves.any? do |jump_move|
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
    if piece_at(@grid, intermediate_square) != color && piece_at(@grid, intermediate_square) != "_"
      @captured_pieces << piece_at(@grid, intermediate_square)
    end
    piece_at(@grid, intermediate_square) != color && piece_at(@grid, intermediate_square) != "_"
  end

end