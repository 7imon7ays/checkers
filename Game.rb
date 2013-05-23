require './Board.rb'
require './Piece.rb'
require './Player.rb'
require './MoveValidator.rb'

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
      puts "Now playing: #{@current_player.color.upcase}"
      begin
        move = @current_player.get_input
        @board.perform_moves(@current_player, move)
        @current_player = ([@o_player, @x_player] - [@current_player]).first
      rescue InvalidMoveError
        puts "That is not a valid move!"
        retry
      rescue WrongFormatError => e
        puts "Wrong format!"
        puts "Row must be a number between A and J."
        puts "Column must be a number beween 0 and 9"
        retry
      end
    end
  end

end




o = HumanPlayer.new(:o)
x = HumanPlayer.new(:x)

chess = Game.new(o, x)

chess.play