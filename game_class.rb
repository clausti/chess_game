require './board_class.rb'
require './player_classes.rb'
require './pieces_classes.rb'
require './chess_errors.rb'

class ChessGame

  def initialize
    @board = Board.new
    @active_player = :white
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
    puts "#{loser.to_s.capitalize} is in checkmate! #{winner.to_s.capitalize} wins!"
  end

  def one_turn
    "#{@active_player.to_s.capitalize}'s turn!"
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
    #only one valid move per player, no way to escape loop
    #will only ever be true or false bc if stalemate, stalemate for everyone
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
    print "Move from? (format: row, column)"
    start_pos = gets.chomp.split(", ").map {|digit| digit.to_i}
    raise InputError, "Not valid start coordinates" unless (start_pos.is_a?(Array) && start_pos.length == 2)
    raise InputError, "Not valid start coordinates" unless start_pos.all? {|ord| ord >= 0 && ord < 8}

    print "Move to? (format: row, column)"
    end_pos = gets.chomp.split(", ").map {|digit| digit.to_i}
    raise InputError, "Not valid end coordinates" unless (end_pos.is_a?(Array) && end_pos.length == 2)
    raise InputError, "Not valid end coordinates" unless end_pos.all? {|ord| ord >= 0 && ord < 8}

    [start_pos, end_pos]
  end

  def change_players
    @active_player = (@active_player == :white) ? :black : :white
  end

end




