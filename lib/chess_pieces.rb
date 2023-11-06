require_relative 'common_moves.rb'

# Base class for the pieces
class ChessPieces
  attr_accessor :name, :type, :white, :black, :point, :has_moved
  include PieceMoves
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

  def get_moves(initial_move, destination)
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

  def validate_move(initial_move, destination, info_board)
  possible_moves = get_pawn_moves(initial_move)
  if possible_moves.include?(destination) then
      return true if destination[1] == initial_move[1] && info_board[destination[0]][destination[1]] == false
      return false if destination[1] == initial_move[1] && info_board[destination[0]][destination[1]] != false
      return true
  end
  return false
  end

  def get_moves(initial_move, destination)
    get_pawn_moves(initial_move)
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
    else
      p "Some kak kak kak kak kak happened"
    end

    # Check if destination is empty #=> M(B)
    diagonal.each do | position |
      return true if destination == position
      return false if info_board[position[0]][position[1]]
    end
    return true
  end

  def get_moves(initial_move, destination)
    get_diagonal_elements(initial_move,destination)
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

  def get_moves(initial_move, destination)
    get_knight_moves(initial_move,destination)
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
    @has_moved = false
  end

  def validate_move(initial_move, destination, info_board)
    @has_moved = true
    possible_moves = get_rook_moves(initial_move)
    if possible_moves.include?(destination) then
      possible_moves.each do | position |
        return true if destination == position
        return false if info_board[position[0]][position[1]]
      end
      return info_board[destination[0]][destination[1]] == false
    end
    return false
  end

  def get_moves(initial_move, destination)
    get_rook_moves(initial_move,destination)
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
    @has_moved = false
  end

  def moved
    @has_moved == true
  end

  def validate_move(initial_move, destination, info_board)
    @has_moved = true
    possible_moves = get_king_moves(initial_move, nil)
      return possible_moves.include?(destination)
  end
  def get_moves(initial_move, destination)
    get_king_moves(initial_move,destination)
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
        return true if destination == position
        return false if info_board[position[0]][position[1]]
      end
    elsif possible_moves[1].include?(destination) then
      possible_moves[1].each do | position |
        return true if destination == position
        return false if info_board[position[0]][position[1]]
      end
      return info_board[destination[0]][destination[1]] == nil # Might not get reached
    else
      return false
    end
    return true
  end

  def get_moves(initial_move, destination)
    get_queen_moves(initial_move,destination)
  end
end


