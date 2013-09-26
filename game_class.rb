require './board_class.rb'
require './player_classes.rb'
require './pieces_classes.rb'
require './chess_errors.rb'

class ChessGame

  def initialize
    @board = Board.new
    @players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
    @active_player = @players.first
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
    puts "#{@active_player.color.to_s.capitalize}'s turn!"
    puts "You're in check!" if @board.in_check?(@active_player.color)
    begin
      start_pos, end_pos = player_move
    rescue InvalidMoveError => err
      puts err.message
      retry
    end
    @board.move_piece(start_pos, end_pos)
    @board.render
    change_players
  end

  def player_move
    begin
      start_pos, end_pos = @active_player.ask_coord_from_player
    rescue InputError => err
      puts err.message
      retry
    end
    raise InvalidMoveError, "There's no piece at start location!" if @board.piece_at(start_pos).nil?
    raise InvalidMoveError, "That's not your piece at start location!" unless @board.piece_at(start_pos).color == @active_player.color
    valid_move = @board.valid_move_from_player?(start_pos, end_pos)

    [start_pos, end_pos]
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

  def change_players
    @active_player = (@active_player == @players.first) ? @players.first : @players.last
  end

end




