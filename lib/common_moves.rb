module PieceMoves

  $board_size = 8

  # Validate generated moves bounds
  def is_in_bounds(coordinate)
    return 0 <= coordinate[0] && coordinate[0] < $board_size && 0 <= coordinate[1] && coordinate[1] < $board_size
  end

  #Pawn moves
  def get_pawn_moves(initial_move, destination = nil)
    possible_moves = 6
    valid_moves = []

    x = [ 1, 1, 1, -1, -1, -1] # Horizontal moves (a)
    y = [-1, 0, 1, -1,  0,  1] # Vertical moves (b)

    possible_moves.times do |n|
      move = [initial_move[0] + x[n], initial_move[1] + y[n]]
      valid_moves << move if is_in_bounds(move)
    end
    valid_moves
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
        break if [row, col] == destination
      diagonal_elements << [row, col]
      end
    elsif (destination[0] > starting_point[0] && destination[1] > starting_point[1]) # lower right diagonal
      while row < 7 && col < 7
        row += 1
        col += 1
        break if [row, col] == destination
       diagonal_elements << [row, col]
      end
    elsif (destination[0] < starting_point[0] && destination[1] > starting_point[1]) # upper right diagonal
      while row > 0 && col > 0
        row -= 1
        col += 1
        break if [row, col] == destination
        diagonal_elements << [row, col]
      end
    else (destination[0] > starting_point[0] && destination[1] < starting_point[1]) # lower left diagonal
      while row < 7 && col > 0
        row += 1
        col -= 1
        break if [row, col] == destination
        diagonal_elements << [row, col]
      end
    end
    diagonal_elements << [destination[0], destination[1]]

    diagonal_elements #=> Return (R)
  end


  # Knight and Queen common moves
  def get_knight_moves(initial_move, destination)
    possible_moves = 8
    valid_moves = []  # Empty array to store possible move

    # Combinations to generate all possible moves => Given a coordinate, for knight
    x = [2, 1, -1, -2, -2, -1, 1, 2]
    y = [1, 2, 2, 1, -1, -2, -2, -1]

    # Loop, validate and store
    possible_moves.times do |n|
      move = [initial_move[0] + x[n], initial_move[1] + y[n]]
      valid_moves << move if is_in_bounds(move)
    end

    valid_moves #=> Return (R)
  end

  # Rook and Queen common moves
  def get_rook_moves(initial_move, destination)
    possible_moves = 8
    valid_moves = [] # Empty array to store possible move (A)

    x = initial_move[0] # Horizontal moves (a)
    y = initial_move[1] # Vertical moves (b)



    if x == destination[0]
      possible_moves.times do |i|
        valid_moves << [x, i] if [i, y] != initial_move  # (a)
        break if [x, i] == destination
      end
    elsif y == destination[1]
      possible_moves.times do |i|
        valid_moves << [i, y] if [i, y] != initial_move # (b)
        break if [i, y] == destination
      end
    end



    valid_moves #=> Return (R)
  end


  # King Moves
  def get_king_moves(initial_move, destination)
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
      valid_moves << [x_gx, y_by] if is_in_bounds([x_gx, y_by])
    end
    valid_moves # (R)
  end

   # Queen Moves
  def get_queen_moves(initial_move, destination)

    using_bishop = get_diagonal_elements(initial_move, destination)
    using_rook = get_rook_moves(initial_move, destination)

    [using_bishop, using_rook]
  end

end
# => => => => => => => => => => End Module <= <= <= <= <= <= <= <= <=
