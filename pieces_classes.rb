class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def move_delta(start_pos, end_pos)
    start_x, start_y = start_pos
    end_x, end_y = end_pos
    delta = [(end_x - start_x), (end_y - start_y)]
  end

end

class SlidingPiece < Piece

  def possible_move?(start_pos, end_pos) #question about the way the piece CAN move in isolation
    delta = move_delta(start_pos, end_pos)
    piece_moves?(delta)
  end

  def path(start_pos, end_pos) #do not want the landing square
    path = []
    start_x, start_y = start_pos
    end_x, end_y = end_pos
    delta_x, delta_y = move_delta(start_pos, end_pos)

    case move_vector(start_pos, end_pos)
      when :n
        ((end_x+1)...start_x).each do |x_coord|
          path << [x_coord, start_y]
        end
      when :s
        ((start_x+1)...end_x).each do |x_coord|
          path << [x_coord, start_y]
        end
      when :e
        ((start_y+1)...end_y).each do |y_coord|
          path << [start_x, y_coord]
        end
      when :w
        ((end_y+1)...start_y).each do |y_coord|
          path << [start_x, y_coord]
        end
      when :ne
        (1...delta_x.abs).each do |diff|
          path << [start_x-diff, start_y+diff]
        end
      when :se
        (1...delta_x.abs).each do |diff|
          path << [start_x+diff, start_y+diff]
        end
      when :sw
        (1...delta_x.abs).each do |diff|
          path << [start_x+diff, start_y-diff]
        end
      when :nw
        (1...delta_x.abs).each do |diff|
          path << [start_x-diff, start_y-diff]
        end
    end
    path
  end

  def move_vector(start_pos, end_pos) #assumes move is valid
    delta_x, delta_y = move_delta(start_pos, end_pos)
    return :n  if delta_x  < 0 && delta_y == 0
    return :s  if delta_x  > 0 && delta_y == 0
    return :e  if delta_x == 0 && delta_y  > 0
    return :w  if delta_x == 0 && delta_y  < 0
    return :ne if delta_x  < 0 && delta_y  > 0
    return :se if delta_x  > 0 && delta_y  > 0
    return :sw if delta_x  > 0 && delta_y  < 0
    return :nw if delta_x  < 0 && delta_y  < 0
  end

end

class SteppingPiece < Piece

  def possible_move?(start_pos, end_pos) #question about the way the piece CAN move in isolation
    self.class::DELTAS.include?(move_delta(start_pos, end_pos))
  end

end

class King < SteppingPiece

  DELTAS = [ [-1, -1],
             [-1,  0],
             [-1,  1],
             [ 0,  1],
             [ 1,  1],
             [ 1,  0],
             [ 1, -1],
             [ 0, -1] ]

end

class Knight < SteppingPiece

  DELTAS = [ [ 2,  1],
             [-2, -1],
             [ 1,  2],
             [-1, -2],
             [ 1, -2],
             [-1,  2],
             [ 2, -1],
             [-2,  1] ]

end

class Queen < SlidingPiece

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


class Bishop < SlidingPiece

  def piece_moves?(delta)
    if delta[0].abs == delta[1].abs
      true
    else
      false
    end
  end

end

class Castle < SlidingPiece

  def piece_moves?(delta)
    if delta.include?(0) && !delta.all?{|element| element == 0}
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

 def possible_move?(start_pos, end_pos)
   deltas = []
   if @color == :white
     deltas = DELTAS_WHITE
     deltas += DELTAS_WHITE_FIRST if start_pos[0] == 6
   else
     deltas = DELTAS_BLACK
     deltas += DELTAS_BLACK_FIRST if start_pos[0] == 1
   end
   deltas.include?(move_delta(start_pos, end_pos))
 end

end