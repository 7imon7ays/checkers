require 'Board'
require 'Piece'
require 'Player'

class Game

  def initialize(o_player, x_player)
    @o_player, @x_player = o_player, x_player
    @board = Board.new
    @current_player = @o_player
  end

  def play
    take_turn
  end

  def take_turn

    while true
      # Most error handling happens here.
      move = @current_player.get_input
      @board.perform_move(move)
      @current_player = ([o_player, x_player] - @current_player).first
    end
  end

end

