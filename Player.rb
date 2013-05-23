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
    puts "Input a sequence of move coordinates"
    begin
      command = gets.chomp
      format_input(command)
    rescue WrongFormatError => e
      puts "Wrong format!"
      puts "Row must be a number between A and J."
      puts "Column must be a number beween 0 and 9"
      retry
    end
  end

  def format_input(command)
    move_sequence = []
    command = command.split(" ")
    command.each do |coordinates_string|
      x_coordinate = coordinates_string.match(/[a-j]/).to_s
      raise WrongFormatError if x_coordinate == ""
      x_coordinate = x_coordinate.ord - 97
      y_coordinate = coordinates_string.match(/\d/).to_s.to_i

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