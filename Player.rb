class Player

  attr_reader :color

  def initialize(color)
    @color = color
  end

end



class HumanPlayer < Player

  def get_input
    puts "Input a sequence of move coordinates"
    command = gets.chomp
    format_input(command)
  end

  def format_input(command)
    move_sequence = []

    command = command.split(" ")

    command.each do |coordinate_string|
      x_coordinate = coordinate_string.match(/[a-j]/).to_s
      y_coordinate = coordinate_string.match(/\d/).to_s.to_i

      x_coordinate = x_coordinate.ord - 97
      move_sequence << [x_coordinate, y_coordinate]
    end
    move_sequence
  end
end



class ComputerPlayer < Player

  def get_input
    # generate semi-random input
  end

end