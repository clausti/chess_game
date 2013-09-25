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
      @grid[position[0]][position[1]] = piece_class.new(color)
    end
  end

  def render
    @grid.each do |row|
      row.each do |square_contents|
        if square_contents #cla
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

  def piece_at(pos)
    @grid[pos[0]][pos[1]]
  end

  def move_piece(current_pos, end_pos)
    piece = piece_at(current_pos)
    #check valid move here if game does not
    @grid[current_pos[0]][current_pos[1]] = nil
    @grid[end_pos[0]][end_pos[1]] = piece
  end

  def valid_move?(current_pos, end_pos) #assumes end position is on board #question about the state of the board
    piece = piece_at(current_pos)
    return false if piece.nil?
    return false unless piece.possible_move?(current_pos, end_pos)
    return false if path_blocked?(current_pos, end_pos)
    return false if destination_is_friendly?(current_pos, end_pos) #cla
    if piece.is_a?(Pawn)
      return false unless pawn_sees_enemy_on_diagonal?(piece, current_pos, end_pos)
    end
    return false if enters_check?(piece, end_pos)
    true
  end

  def path_blocked?(current_pos, end_pos)
    #(exclude end_pos)
    piece = piece_at(current_pos)
    return false if piece.is_a?(SteppingPiece)  #Knight and King
    if piece.is_a?(SlidingPiece) #Queen, Bishop, Castle
      path = piece.path(current_pos, end_pos)
      path.each do |coord|
        return true unless piece_at(coord).nil?
      end
    end
    if piece.is_a?(Pawn) #Pawns
      return true unless piece_at(end_pos).nil?
    end
    false
  end

  def destination_is_friendly?(current_pos, ending_pos) #cla
    piece_at(current_pos).color == piece_at(ending_pos).color
  end

  def enters_check?(piece, end_pos)
    #create duplicate board #!!need deep dup of grid
    #move piece on duped board
    # pass that board to in_check?
  end

  def in_check?(color, board = self)
    #looks at a board (self for real board, dup for hypothetical board)
    king_pos = king_position(color)

    @grid.each_with_index do |row, row_index|
      row.each_with_index do |square_contents, col_index|
        next if square_contents.nil?
        next if square_contents.color == color
        return true if valid_move?([row_index, col_index], king_pos)
      end
    end
    false
  end

  def king_position(color)

  end

  def pawn_sees_enemy_on_diagonal?(piece, current_pos, end_pos)
    move_delta = piece.move_delta(current_pos, end_pos)
    is_diagonal = (move_delta[1] != 0)
    return true unless is_diagonal
    return false if piece_at(end_pos).nil?
    return true if (piece_at(end_pos).color != piece.color)
    false
  end
end