class WrongFormatError < NoMethodError
end

class Player

  attr_reader :color

  def initialize(color)
    @color = color
  end

end


class HumanPlayer < Player

  def get_input
    puts "Input a sequence of move coordinates".colorize(:white)
    command = gets.chomp
    if command == "save"
      return :save
    elsif command == "load"
      return :load
    else
      format_input(command)
    end
  end

  def format_input(command)
    move_sequence = []
    command = command.split(" ")
    command.each do |coordinates_string|
      y_coordinate = coordinates_string.match(/[a-j]/).to_s
      raise WrongFormatError if y_coordinate == ""
      y_coordinate = y_coordinate.ord - 97
      x_coordinate = coordinates_string.match(/\d/).to_s.to_i

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
