require './board_class.rb'
require './player_classes.rb'
require './pieces_classes.rb'
require './chess_errors.rb'

class ChessGame

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

  def initialize
    @board = Board.new
    @active_player = :white
    play
  end

  def play
    #who is going first
    #how many human players
    #AI stuff lateR?
    @board.render
    until checkmate || stalemate?
      one_turn
    end
    winner, loser = checkmate
    if checkmate
      puts "#{loser.to_s.capitalize} is in checkmate! #{winner.to_s.capitalize} wins!"
    else
      puts "Stalemate. You both lose. :P"
    end
  end

  def one_turn
    puts "#{@active_player.to_s.capitalize}'s turn!"
    puts "You're in check!" if @board.in_check?(@active_player)
    begin
      start_pos, end_pos = player_move
    rescue InvalidMove => err
      puts err.message
      retry
    end
    @board.move_piece(start_pos, end_pos)
    @board.render
    change_players
  end

  def checkmate
    #returns [winner, loser]
    return [:black, :white] if @board.in_checkmate?(:white)
    return [:white, :black] if @board.in_checkmate?(:black)
    nil
  end

  def stalemate?
    return true if @board.in_stalemate?(:black)
    return true if @board.in_stalemate?(:white)
    false
  end

  def player_move
    begin
      start_pos, end_pos = ask_coord_from_player
    rescue InputError => err
      puts err.message
      retry
    end

    valid_move = @board.valid_move?(start_pos, end_pos)
    raise InvalidMove, "That's not a valid move." unless valid_move

    [start_pos, end_pos]
  end

  def ask_coord_from_player #should really be in HumanPlayer class.
    print "Move from? (format: a7, etc)  "
    start_pos = convert_player_input_to_coords(gets.chomp)

    raise InputError, "There's no piece there!" if @board.piece_at(start_pos).nil?
    raise InputError, "That's not your piece!" unless @board.piece_at(start_pos).color == @active_player
    raise InputError, "Not valid start coordinates" unless (start_pos.is_a?(Array) && start_pos.length == 2)
    raise InputError, "Not valid start coordinates" unless start_pos.all? {|ord| ord >= 0 && ord < 8}

    print "Move to? (format: a7, etc)  "
    end_pos = convert_player_input_to_coords(gets.chomp)
    raise InputError, "Not valid end coordinates" unless (end_pos.is_a?(Array) && end_pos.length == 2)
    raise InputError, "Not valid end coordinates" unless end_pos.all? {|ord| ord >= 0 && ord < 8}

    [start_pos, end_pos]
  end

  def convert_player_input_to_coords(input)
    input = input.downcase.reverse.split('')
    row, column = input
    row = ROW_NOTATION[row]
    column = COLUMN_NOTATION[column]
    [row, column]
  end

  def change_players
    @active_player = (@active_player == :white) ? :black : :white
  end

end




