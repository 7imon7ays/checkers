class Piece

  # moves are modified by #promotes internally so no accessor is needed/
  attr_reader :color, :slide_moves, :jump_moves

  def initialize(color)
   @color = color
   @slide_moves = # array of coordinates in slide perimeter.
   @jump_moves =  # array of coordinates in jump perimeter.
  end

  def promote
    # modifies Piece's moves
  end

end