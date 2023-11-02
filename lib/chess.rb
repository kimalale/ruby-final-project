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
    possible_moves = 8
    valid_moves = []  # Empty array to store possible move

    # Combinations to generate all possible moves => Given a coordinate, for knight
    x = [2, 1, -1, -2, -2, -1, 1, 2]
    y = [1, 2, 2, 1, -1, -2, -2, -1]

    # Loop, validate and store
    possible_moves.times do |n|
      move = [coordinate[0] + x[n], coordinate[1] + y[n]]
      valid_moves << move if is_in_bounds(move)
    end

    valid_moves #=> Return (R)
  end

  # Rook and Queen common moves
  def get_rook_moves(initial_move)
    possible_moves = 8
    valid_moves = [] # Empty array to store possible move (A)

    x = initial_move[0] # Horizontal moves (a)
    y = initial_move[1] # Vertical moves (b)

    possible_moves.times do |i|
      valid_moves << [x, i] # (a)
      valid_moves << [i, y] # (b)
    end
    valid_moves #=> Return (R)
  end

  # King Moves
  def get_king_moves(initial_move)
    possible_moves = 8
    valid_moves = [] # (A)

    x_x = initial_move[0] # (a)
    y_y = initial_move[1] # (b)

    # Collection of possible horizontal and vertical moves
    x = [-1, -1, -1,  0, 0,  1, 1, 1]
    y = [-1,  0,  1, -1, 1, -1, 0, 1]

    possible_moves.times do |i|
      x_gx = x_x + x[i] # (a)
      y_by = y_y + y[i] # (b)
      valid_moves << [x_gx, y_by]
    end
    valid_moves # (R)
  end

end
# => => => => => => => => => => End Module <= <= <= <= <= <= <= <= <=


# Base class for the pieces
class ChessPieces
  attr_accessor :name, :type, :white, :black, :point
  def validate_move(initial_move, current_move, info_board);end
end

# (1)
class Pawn < ChessPieces
  @name = "Pawn"
  @white = ["b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8"] #=> Initial White Point I(w)
  @black = ["g1", "g2", "g3", "g4", "g5", "g6", "g7", "g8"] #=> Initial Black Point I(b)
  @point = 1

  def initialize(player_type)
    @type = player_type
    @first_move = true
  end

  def validate_move(initial_move, destination, board)
    y = initial_move[0]
    x = initial_move[1]
    if (destination == [y, x + 2] || [y, x - 2] && @first_move) || (destination == [y, x + 1] || [y, x - 1]) then
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

# (2)
class Bishop < ChessPieces
  @name = "Bishop"
  @white = ["c1", "f1"] #=> I(w)
  @black = ["c8", "f8"] #=> I(b)
  @point = 3

  def initialize(player_type)
    @type = player_type
  end

  def validate_move(initial_move, destination, info_board)
    begin
      diagonal = get_diagonal_elements(initial_move, destination)
    rescue OutOfBounds
      p "Given point is out of range [0-7, 0-7])"
    end

    # Check if destination is empty #=> M(c)
    diagonal.each do | position |
      return false if info_board[position[0], position[1]]
    end
    return true
  end
end

# (3)
class Knight < ChessPieces
  @name = "Knight"
  @white = ["b1", "g1"] #=> I(w)
  @black = ["b8", "g8"] #=> I(b)
  @point = 3

  def initialize(player_type)
    @type = player_type
  end

  def validate_move(initial_move, destination, info_board)
    possible_moves = get_knight_moves(initial_move)
    possible_moves.each do | position |
      return true if position == destination
    end
    return false
  end
end

# (4)
class Rook < ChessPieces
  @name = "Rook"
  @white_block = ["a1", "h1"] #=> I(w)
  @black_block = ["a8", "h8"] #=> I(b)
  @point = 5

  def initialize(player_type)
    @type = player_type
  end

  def validate_move(initial_move, current_move, info_board)
    possible_moves = get_rook_moves(initial_move)
    if possible_moves.include?(current_move) then
      return info_board[current_move[0]][current_move[1]] == false
    end
    return false
  end
end

# (5)
class King
  @name = "King"
  @white_block = "e1" #=> I(w)
  @black_block = "e8" #=> I(b)
  @point = 9

  def initialize(player_type)
    @type = player_type
  end

  def validate_move(initial_move, current_move, info_board)
    possible_moves = get_king_moves(initial_move)
    if possible_moves.include?(current_move) then
      return info_board[current_move[0]][current_move[1]] == false
    end
    return false
  end
end

# (6)
class Queen
  @name = "Queen"
  @white = "d1" #=> I(w)
  @black = "d8" #=> I(b)
  @point = 9

  def initialize(player_type)
    @type = player_type
  end

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
