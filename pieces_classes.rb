module SlidingPiece

  def move

  end

  def possible_move?(end_pos) #question about the way the piece CAN move in isolation
    delta = move_delta(end_pos)
    piece_moves?(delta)
  end

end

module SteppingPiece

  def move

  end

  def possible_move?(end_pos) #question about the way the piece CAN move in isolation
    DELTAS.include?(move_delta(end_pos))
  end

end




class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(color, starting_position)
    @color = color
    @position = starting_position
  end

  def move_delta(end_pos)
    start_x, start_y = @position
    end_x, end_y = end_pos
    delta = [(end_x - start_x), (end_y - start_y)]
  end


end



class King < Piece
  include SteppingPiece

  DELTAS = [ [-1, -1],
             [-1,  0],
             [-1,  1],
             [ 0,  1],
             [ 1,  1],
             [ 1,  0],
             [ 1, -1],
             [ 0, -1] ]

  #array of move deltas

end

class Queen < Piece
  include SlidingPiece

  def piece_moves?(delta)
    if delta[0].abs == delta[1].abs
      true
    elsif delta.include?(0) && !delta.all?(0)
      true
    else
      false
    end
  end

end

class Knight < Piece
  include SteppingPiece

  DELTAS = [ [ 2,  1],
             [-2, -1],
             [ 1,  2],
             [-1, -2],
             [ 1, -2],
             [-1,  2],
             [ 2, -1],
             [-2,  1] ]

end

class Bishop < Piece
  include SlidingPiece

  def piece_moves?(delta)
    if delta[0].abs == delta[1].abs
      true
    else
      false
    end
  end

end

class Castle < Piece
  include SlidingPiece

  def piece_moves?(delta)
    if delta.include?(0) && !delta.all?(0)
      true
    else
      false
    end
  end

end


class Pawn < Piece

  DELTAS_WHITE = [[-1,-1],
                  [-1, 0],
                  [-1, 1]]

  DELTAS_BLACK = [[1,-1],
                  [1, 0],
                  [1, 1]]

  DELTAS_WHITE_FIRST = [[-2,0]]

  DELTAS_BLACK_FIRST = [[ 2,0]]

 def possible_move?(end_pos)
   deltas = []
   if @color == :white
     deltas = DELTAS_WHITE
     deltas += DELTAS_WHITE_FIRST if @position[0] == 6
   else
     deltas = DELTAS_BLACK
     deltas += DELTAS_BLACK_FIRST if @position[0] == 1
   end
   deltas.include?(move_delta(end_pos))
 end


end