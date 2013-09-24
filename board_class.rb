require './pieces_classes.rb'
require 'colorize'

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
      row.each do |square_contents|
        if !square_contents.nil?
          square_display = square_contents.class
          text_color = square_contents.color
          background_color = :cyan
        else
          square_display = "_______"
          text_color = :default
          background_color = :black
        end

        print "#{square_display}".center(7, " ").colorize(text_color).colorize( :background => background_color) + "|"
      end
      puts "\n\n"
    end
  end

  def move_piece(current_pos, end_pos)
    piece = piece_at(current_pos)
    #check valid move here if game does not
    @grid[piece.position[0]][piece.position[1]] = nil
    piece.move_to(end_pos)
    @grid[end_pos[0]][end_pos[1]] = piece
  end

  def valid_move?(current_pos, end_pos) #assumes end position is on board #question about the state of the board
    piece = piece_at(current_pos)
    return false if piece.nil?
    return false unless piece.possible_move?(end_pos)
    return false if path_blocked?(piece, end_pos)
    if piece.is_a?(Pawn)
      return false unless pawn_sees_enemy_on_diagonal?(piece, end_pos)
    end
    return false if enters_check?(piece, end_pos)
    true
  end

  def piece_at(pos)
    @grid[pos[0]][pos[1]]
  end

  def path_blocked?(piece, end_pos) #not inside classes bc classes don't know what's on the board
    #look at intermediate squares and see if blocked by any piece (exclude end_pos)
    return false if piece.is_a?(SteppingPiece)  #Knight and King

    if piece.is_a?(SlidingPiece) #Queen, Bishop, Castle

    end

    if piece.is_a?(Pawn)
      return true unless piece_at(end_pos).nil?
    end
    false
  end

  def enters_check?(piece, end_pos)

  end

  def pawn_sees_enemy_on_diagonal?(piece, end_pos)
    move_delta = piece.move_delta(end_pos)
    is_diagonal = (move_delta[1] != 0)
    return true unless is_diagonal
    return false if piece_at(end_pos).nil?
    return true if (piece_at(end_pos).color != piece.color)
    false
  end
end