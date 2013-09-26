class HumanPlayer

     ROW_NOTATION = { "8" => 0,
                      "7" => 1,
                      "6" => 2,
                      "5" => 3,
                      "4" => 4,
                      "3" => 5,
                      "2" => 6,
                      "1" => 7 }


  COLUMN_NOTATION = { "a" => 0,
                      "b" => 1,
                      "c" => 2,
                      "d" => 3,
                      "e" => 4,
                      "f" => 5,
                      "g" => 6,
                      "h" => 7 }

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def ask_coord_from_player
    print "Move from? (format: a7, etc)  "
    start_pos = gets.chomp
    raise InputError, "Not valid coordinates" if start_pos.length != 2
    start_pos = convert_player_input_to_coords(start_pos)
    raise InputError, "Not valid start coordinates" if start_pos.any? {|el| el.nil?}
    raise InputError, "Not valid start coordinates" unless (start_pos.is_a?(Array) && start_pos.length == 2)
    raise InputError, "Not valid start coordinates" unless start_pos.all? {|ord| ord >= 0 && ord < 8}

    print "Move to? (format: a7, etc)  "
    end_pos = gets.chomp
    raise InputError, "Not valid coordinates" if end_pos.length != 2
    end_pos = convert_player_input_to_coords(end_pos)
    raise InputError, "Not valid end coordinates" if end_pos.any? {|el| el.nil?}
    raise InputError, "Not valid end coordinates" unless (end_pos.is_a?(Array) && end_pos.length == 2)
    raise InputError, "Not valid end coordinates" unless end_pos.all? {|ord| ord >= 0 && ord < 8}

    [start_pos, end_pos]
  end

  private
    def convert_player_input_to_coords(input)
      input = input.downcase.reverse.split('')
      row, column = input
      row = ROW_NOTATION[row]
      column = COLUMN_NOTATION[column]
      [row, column]
    end
end