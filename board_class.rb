require './pieces_classes.rb'
require 'colorize'
require './chess_errors.rb'

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
    puts
    @grid.each_with_index do |row, row_idx|
      print "Row: #{8 - row_idx}  "
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
    puts "   a       b       c       d       e       f       g       h    ".rjust(72, " ")
    puts
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

  def valid_move_from_player?(current_pos, end_pos)
    piece = piece_at(current_pos)
    raise InvalidMoveError, "Your piece can't move that way!\n\n" unless piece.possible_move?(current_pos, end_pos)
    raise InvalidMoveError, "There's a piece in your way.\n\n" if path_blocked?(current_pos, end_pos)
    raise InvalidMoveError, "You can't capture your own piece!\n\n" if destination_is_friendly?(current_pos, end_pos)
    if piece.is_a?(Pawn) && !pawn_sees_enemy_on_diagonal?(current_pos, end_pos)
      raise InvalidMoveError, "Pawn can only make a diagonal move to capture.\n\n"
    end
    raise InvalidMoveError, "You can't move into check.\n\n" if enters_check?(current_pos, end_pos)
    true
  end

  def valid_move?(current_pos, end_pos) #assumes end position is on board #question about the state of the board
    piece = piece_at(current_pos)
    return false if piece.nil?
    return false unless piece.possible_move?(current_pos, end_pos)
    return false if path_blocked?(current_pos, end_pos)
    return false if destination_is_friendly?(current_pos, end_pos) #cla
    if piece.is_a?(Pawn) && !pawn_sees_enemy_on_diagonal?(current_pos, end_pos)
      return false
    end
    return false if enters_check?(current_pos, end_pos)
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
      return false if current_pos[1] != end_pos[1] #diagonal paths never "blocked"
      return true unless piece_at(end_pos).nil?
    end
    false
  end

  def destination_is_friendly?(current_pos, ending_pos) #cla
    end_square_contents = piece_at(ending_pos)
    return false if end_square_contents.nil?
    piece_at(current_pos).color == end_square_contents.color
  end

  def pawn_sees_enemy_on_diagonal?(current_pos, end_pos)
    piece = piece_at(current_pos)
    move_delta = piece.move_delta(current_pos, end_pos)
    is_diagonal = (move_delta[1] != 0)
    return true unless is_diagonal
    return false if piece_at(end_pos).nil?
    return true if (piece_at(end_pos).color != piece.color)
    false
  end

  def enters_check?(start_pos, end_pos)#assumes move is possible and not blocked
    color = piece_at(start_pos).color
    hyp_board = self.dup
    hyp_board.move_piece(start_pos, end_pos)
    return true if hyp_board.in_check?(color)
    false
  end

  def in_check?(color)#only asks about current state of board (i.e. no move validation)
    king_pos = king_position(color)
    return true if king_pos.nil?
    iterate_through_grid do |square_contents, row_index, col_index|
      next if square_contents.nil?
      next if square_contents.color == color
      return true if valid_move?([row_index, col_index], king_pos)
    end
    false
  end

  def king_position(color)
    iterate_through_grid do |square_contents, row_index, col_index|
      if square_contents.class == King && square_contents.color == color
        return [row_index, col_index]
      end
    end
    nil
  end

  def in_checkmate?(color)
    return false unless in_check?(color)
    return false if color_any_valid_moves?(color)
    true
  end

  def in_stalemate?(color)
    return false if in_check?(color)
    return false if color_any_valid_moves?(color)
    true
  end

  def color_any_valid_moves?(color)
    iterate_through_grid do |square_contents, row_index, col_index|
      next if square_contents.nil?
      next if square_contents.color != color
      return true if piece_any_valid_moves?([row_index, col_index])
    end
    false
  end

  def piece_any_valid_moves?(position)
    iterate_through_grid do |square_contents, row_index, col_index|
      return true if valid_move?(position, [row_index, col_index])
    end
    false
  end

  def iterate_through_grid(&code_block) #will still take implicit code block
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |square_contents, col_index|
        code_block.call(square_contents, row_index, col_index)
      end
    end
  end

  def dup
    hypothetical_board = Board.new # using dup here causes an infinite loop!!! (duploop!!)
    hypothetical_board.grid = self.two_d_dup(@grid)
    hypothetical_board
  end

  def two_d_dup(two_d_array)
    duped_array = []
    two_d_array.each do |element|
      duped_array << element.dup
    end
    duped_array
  end

protected
    attr_accessor :grid
end