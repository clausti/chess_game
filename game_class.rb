require './board_class.rb'
require './player_classes.rb'
require './pieces_classes.rb'

class ChessGame

  def initialize
    @board = Board.new
  end




  def play
    @board.render

    begin
     player_move
   rescue StandardError => err
     puts err.message
     retry
   end
   move = player_move
   @board.move_piece(move[0], move[1])
  end

  def player_move
    #ask player where to move using x,y coordinates
    #verify end position on board, raise exception if not


    print "Move from?"
    start_pos = gets.chomp.split(", ").map {|digit| digit.to_i}
    print "Move to?"
    end_pos = gets.chomp.split(", ").map {|digit| digit.to_i}
    valid_move = @board.valid_move?(start_pos, end_pos)
    raise StandardError "That's not a valid move." unless valid_move
    #if move is not valid ask again, exception handling?

    move = [start_pos, end_pos]
  end

end




