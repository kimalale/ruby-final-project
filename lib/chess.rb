module PieceMoves

  $board_size = 8

  # Validate generated moves bounds
  def is_in_bounds(coordinate)
    return 0 <= coordinate[0] && coordinate[0] < $board_size && 0 <= coordinate[1] && coordinate[1] < $board_size
  end

  #Bishop and Queen common moves
  def get_diagonal_elements(starting_point, destination)
    # Check if the starting and destination points is valid
    if (starting_point[0] < 0 || starting_point[1] >= 8) || (destination[0] < 0 || destination[1] >= 8)
      throw OutOfBounds # Throw an exception
    end

    diagonal_elements = [] # Empty array to store possible diagonal move

    # Starting point (row and column) for the diagonal
    row, col = starting_point[0], starting_point[1]

    # Ensure a loop executes once for the required diagonal move
    if (destination[0] < starting_point[0] && destination[1] < starting_point[1]) # upper left diagonal
      while row > 0 && col > 0
        row -= 1
        col -= 1
      diagonal_elements << [row, col]
      end
    elsif (destination[0] > starting_point[0] && destination[1] > starting_point[1]) # lower right diagonal
      while row < 7 && col < 7
        row += 1
        col += 1
       diagonal_elements << [row, col]
      end
    elsif (destination[0] < starting_point[0] && destination[1] > starting_point[1]) # upper right diagonal
      while row > 0 && col > 0
        row -= 1
        col += 1
        diagonal_elements << [row, col]
      end
    else (destination[0] > starting_point[0] && destination[1] < starting_point[1]) # lower left diagonal
      while row < 7 && col > 0
        row += 1
        col -= 1
        diagonal_elements << [row, col]
      end
    end

    diagonal_elements #=> Return (R)
  end


  # Knight and Queen common moves
  def get_knight_moves(coordinate)

    valid_moves = []  # Empty array to store possible move

    # Combinations to generate all possible moves => Given a coordinate, for knight
    x = [2, 1, -1, -2, -2, -1, 1, 2]
    y = [1, 2, 2, 1, -1, -2, -2, -1]

    # Loop, validate and store
    @possible_moves_count.times do |n|
      move = [coordinate[0] + x[n], coordinate[1] + y[n]]
      valid_moves << move if is_in_bounds(move)
    end

    valid_moves #=> Return (R)
  end

  # Rook and Queen common moves
  def get_rook_moves(initial_move)

    valid_moves = [] # Empty array to store possible move (A)

    x = initial_move[0] # Horizontal moves (a)
    y = initial_move[1] # Vertical moves (b)

    8.times do |i|
      valid_moves << [x, i] # (a)
      valid_moves << [i, y] # (b)
    end
    valid_moves #=> Return (R)
  end

  # King Moves
  def get_king_moves(initial_move)

    valid_moves = [] # (A)

    x_x = initial_move[0] # (a)
    y_y = initial_move[1] # (b)

    # Collection of possible horizontal and vertical moves
    x = [-1, -1, -1,  0, 0,  1, 1, 1]
    y = [-1,  0,  1, -1, 1, -1, 0, 1]

    8.times do |i|
      x_gx = x_x + x[i] # (a)
      y_by = y_y + y[i] # (b)
      valid_moves << [x_gx, y_by]
    end
    valid_moves # (R)
  end

end
# => => => => => => => => => => End Module <= <= <= <= <= <= <= <= <=


class ChessPieces
  attr_accessor :starting_position, :current_position, :point
  @board_size = 8
  def initialize(start_position)
    @starting_position = start_position
  end

  def validate_move(initial_move, current_move, info_board);end


end

class Pawn < ChessPieces

  attr_accessor :number_instances, :first_move, :name
  @name = "Pawn"
  @black_pawn = 6
  @white_pawn = 1

  def initialize(player_type, number_instance = 8)
    super(@white_pawn) if player_type
    super(@black_pawn) if !player_type
    @number_instances = number_instance
    @point = 1
    @first_move = true
  end
  public



#  x moves left or right, left if col is 8, then left and right if col is < 8
#  x moves left or right, right if col is 0, then left and right if col is > 0
#  y moves 2 steps up if the piece hasnt moved
# y moves 1 step up if the piece has moved

  def validate_move(initial_move, current_move, board)

    y = initial_move[0]
    x = initial_move[1]

    if (current_move == [y, x + 2] || [y, x - 2] && @first_move) || (current_move == [y, x + 1] || [y, x - 1]) then
      @first_move = false
      return true
    end

    if ((x > 0 && current == [y - 1, x - 1] || [y + 1, x - 1]) || (x < 0 && current == [y - 1, x - 1] || [y + 1, x - 1])) then
      return true
    else
      return false
    end

  end
end

class Bishop < ChessPieces

  attr_accessor :number_instances
  @name = "Bishop"
  @number_instances = 2
  @white_block = "c1"
  @black_block = "f1"
  @point = 3

  def validate_move(initial_move, current_move, info_board)

    begin
      diagonal = get_diagonal_elements(initial_move, current_move)
    rescue OutOfBounds
      p "Starting position is out of range [0-7, 0-7])"
    end

    diagonal.each do | position |
      return false if info_board[position[0], position[1]]
    end
    return true
  end
end

class Knight < ChessPieces
  attr_accessor :number_instances, :name
  @name = "Knight"
  @number_instances = 2
  @white_block = ["b1", "g1"]
  @black_block = ["b8", "g8"]
  @possible_moves_count = 8
  @point = 3

  def validate_move(initial_move, current_move, info_board)
    possible_moves = get_knight_moves(initial_move)
    possible_moves.each do | position |
      return true if position == current_move
    end
    return false
  end
end

class Rook < ChessPieces
  attr_accessor :number_instances, :name
  @name = "Rook"
  @number_instances = 2
  @possible_moves_count = 8
  @white_block = ["a1", "h1"]
  @black_block = ["a8", "h8"]
  @point = 5

  def validate_move(initial_move, current_move, info_board)
    possible_moves = get_rook_moves(initial_move)
    if possible_moves.include?(current_move) then
      return info_board[current_move[0]][current_move[1]] == false
    end
    return false
  end
end

class King
  attr_accessor :number_instances, :name
  @name = "King"
  @number_instances = 2
  @possible_moves_count = 8
  @white_block = "e1"
  @black_block = "e8"
  @point = 9

  def validate_move(initial_move, current_move, info_board)
    possible_moves = get_king_moves(initial_move)
    if possible_moves.include?(current_move) then
      return info_board[current_move[0]][current_move[1]] == false
    end
    return false
  end
end



class Chess
  attr_accessor :board, :points
  def initialize
    @board_height = 8
    @board_width = 8
    @board = nil
    @occupied_board = nil
    create_board
  end

  def create_board
    @board = Array.new(@board_height) { Array.new(@board_width) { nil } }
    @occupied_board = Array.new(@board_height) { Array.new(@board_width) { nil } }
    add_pieces(@board)
  end

  def add_pieces(board)
    throw "Invalid board" if board.empty?

    8.times do | m|
      @board[6][m] = Pawn.new(true)
    end

    occupied_board

  end

  def occupied_board
    @board_height.times do | row |
      @board_width.times do | col |
        if (@board[row][col] != nil)
          @occupied_board[row][col] = true
        else
          @occupied_board[row][col] = false
        end
      end
    end
  end

  def move_piece(piece_location, destination)

    # # Check if the starting and destination points is valid
    # if (starting_point[0] < 0 || starting_point[1] >= 8) || (destination[0] < 0 || destination[1] >= 8)
    #   throw OutOfBounds # Throw an exception
    # end


    piece = @board[piece_location[0]][piece_location[1]]
    return if !piece.validate_move(piece_location, destination, @occupied_board)

    @board[destination[0]][destination[1]] = @board[piece_location[0]][piece_location[1]]
    @board[piece_location[0]][piece_location[1]] = nil

  end

  def format_board(piece)

  end


  def show_board

    @board.each do |valueline|
      print valueline
      puts ""
    end


  end

end

board = Chess.new
board.move_piece([6, 1], [5,0])
board.show_board
