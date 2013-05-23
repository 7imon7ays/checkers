class Player

  def initialize(color)
    @color = color
  end

end



class HumanPlayer < Player

  def get_input
    # prompt for input
    format_input(command)
  end

  def format_input(command)
    #translate command string into coordinates
  end
end



class ComputerPlayer < Player

  def get_input
    # generate semi-random input
  end

end