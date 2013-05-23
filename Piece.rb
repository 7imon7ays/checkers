class Piece

  # moves are modified by #promotes internally so no accessor is needed/
  attr_reader :color, :slide_moves, :jump_moves

  def initialize(color)
   @color = color
   @color == :o ? o_move_deltas : x_move_deltas
   @slide_moves = @color == :o ? o_move_deltas : x_move_deltas
   @jump_moves = [
     [-2, -2],
     [-2, 2],
     [2, -2],
     [2, 2]
   ]
   @status = :man
  end

  def o_move_deltas
    [[-1, -1], [-1, 1]]
  end

  def x_move_deltas
    [[1, -1],[1, 1]]
  end

  def promote
    @status = :king
  end

  def to_s
    if color == :o
      @status == :man ? "o" : "O"
    else
      @status == :man ? "x" : "X"
    end
  end

end