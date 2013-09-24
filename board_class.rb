require './pieces_classes.rb'

class Board

  INITIAL_BLACK = {[0, 0] => Castle,
                   [0, 1] => Knight,
                   [0, 2] => Bishop,
                   [0, 3] => Queen,
                   [0, 4] => King,
                   [0, 5] => Bishop,
                   [0, 6] => Knight,
                   [0, 7] => Castle,
                   [1, 0] => Pawn,
                   [1, 1] => Pawn,
                   [1, 2] => Pawn,
                   [1, 3] => Pawn,
                   [1, 4] => Pawn,
                   [1, 5] => Pawn,
                   [1, 6] => Pawn,
                   [1, 7] => Pawn }

  INITIAL_WHITE = {[7, 0] => Castle,
                   [7, 1] => Knight,
                   [7, 2] => Bishop,
                   [7, 3] => Queen,
                   [7, 4] => King,
                   [7, 5] => Bishop,
                   [7, 6] => Knight,
                   [7, 7] => Castle,
                   [6, 0] => Pawn,
                   [6, 1] => Pawn,
                   [6, 2] => Pawn,
                   [6, 3] => Pawn,
                   [6, 4] => Pawn,
                   [6, 5] => Pawn,
                   [6, 6] => Pawn,
                   [6, 7] => Pawn }

  def initialize
    @grid = Array.new(8){Array.new(8)}
    populate_board
  end

  def populate_board
    pieces_one_color(:white)
    pieces_one_color(:black)
  end

  def pieces_one_color(color)
    if color == :white
      initial_positions = INITIAL_WHITE
    elsif color == :black
      initial_positions = INITIAL_BLACK
    end

    initial_positions.each do |position, piece_class|
      @grid[position[0]][position[1]] = piece_class.new(color, position)
    end
  end

  def render
    @grid.each do |row|
      row.each do |column|
        print @grid[row][column].class
      end
      puts
    end
  end

  def valid_move?(current_pos, end_pos) #assumes end position is on board #question about the state of the board
    piece = piece_at(current_pos)
    return false unless piece.possible_move?(end_pos)
    # duplicating the board and the current game state to check the result of a proposed move
    #for pawns, check for enemies in diagonal moves
    #check and see if there is anything in the way
    #check and see if left in check for color of piece
  end

  def piece_at(pos)
    #returns piece at position
  end

end