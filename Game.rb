require './Board.rb'
require './Piece.rb'
require './Player.rb'
require './MoveValidator.rb'
require 'colorize'
require 'yaml'

class Game

  def self.load
    YAML.load_file("savegame")
  end

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
      @board.render
      begin
        puts "Now playing: #{@current_player.color.upcase}".colorize(:white)
        move = @current_player.get_input
        save if move == :save
        @board.perform_moves(@current_player, move)
        @current_player = ([@o_player, @x_player] - [@current_player]).first
      rescue InvalidMoveError
        @board.render
        puts "That is not a valid move!".colorize(:white)
        retry
      rescue WrongFormatError => e
        @board.render
        puts "Wrong format!".colorize(:white)
        puts "Row must be a number between A and J.".colorize(:white)
        puts "Column must be a number beween 0 and 9".colorize(:white)
        retry
      end
    end
  end

  def save
    File.open("savegame", "w") { |file| file.puts self.to_yaml }
    abort
  end

end





if __FILE__ == $PROGRAM_NAME
  puts "Would you like to open a saved game? (y/n)"
  if gets.chomp.downcase == ( 'y' or 'yes' )
    game = Game.load
  else
    o = HumanPlayer.new(:o)
    x = HumanPlayer.new(:x)
    game = Game.new(o, x)
  end
  game.play
end