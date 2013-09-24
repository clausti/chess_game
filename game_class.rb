require './board_class.rb'
require './player_classes.rb'
require './pieces_classes.rb'

class ChessGame


  #verify end position on board, raise exception if not


  def play
    player_move


  end

  def player_move
    #ask player where to move using x,y coordinates
    #ask board if input move is valid
    @board.valid_move?(start_pos, end_pos)
    #if move is not valid ask again, exception handling?

    #tell board to execute move
  end

end




