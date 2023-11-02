require './common_moves'

# Base class for the pieces
class ChessPieces
  attr_accessor :name, :type, :white, :black, :point
  def validate_move(initial_move, current_move, info_board);end
  @white = []
  @point = nil
  @black = []
  def self.white
    @white
  end
  def self.black
    @black
  end
  def self.type
    @type
  end
  def self.point
    @point
  end
end

# (1)
class Pawn < ChessPieces
  @@name = "Pawn"
  @white = ["a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2"] #=> Initial White Point I(w)
  @black = ["a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7"] #=> Initial Black Point I(b)
  @point = 1

  def initialize(player_type)
    @type = player_type
    @first_move = true
  end

  def validate_move(initial_move, destination, board)
    y = initial_move[0]
    x = initial_move[1]

    # Check for backwards movement
    return false if (destination[0] > initial_move[0] && type == "white") || (destination[0] < initial_move[0] && type == "black")

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

    # Check if destination is empty #=> M(B)
    diagonal.each do | position |
      return false if info_board[position[0]][position[1]]
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
  @white = ["a1", "h1"] #=> I(w)
  @black = ["a8", "h8"] #=> I(b)
  @point = 5

  def initialize(player_type)
    @type = player_type
  end

  def validate_move(initial_move, current_move, info_board)
    possible_moves = get_rook_moves(initial_move)
    if possible_moves.include?(current_move) then
      possible_moves.each do | position |
        return false if info_board[position[0]][position[1]]
      end
      return info_board[current_move[0]][current_move[1]] == false
    end
    return false
  end
end

# (5)
class King < ChessPieces
  @name = "King"
  @white = ["e1"] #=> I(w)
  @black = ["e8"] #=> I(b)
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
class Queen < ChessPieces
  @name = "Queen"
  @white = ["d1"] #=> I(w)
  @black = ["d8"] #=> I(b)
  @point = 9

  def initialize(player_type)
    @type = player_type
  end

  def validate_move(initial_move, destination, info_board)

    possible_moves = get_queen_moves(initial_move, destination)

    #Handle queen using bishop
    #TODO: handle this => - @type] if info_board.piece_at(destination) == nil

    #=> M(Q-B)
    if possible_moves[0].include?(destination) then
      possible_moves[0].each do | position |
        return false if info_board[position[0]][position[1]]
      end
    elsif possible_moves[1].include?(destination) then
      possible_moves[1].each do | position |
        return false if info_board[position[0]][position[1]]
      end
      return info_board[destination[0]][destination[1]] == nil
    else
      return false
    end
    return true
  end
end


