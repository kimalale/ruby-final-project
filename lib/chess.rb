require './chess_pieces'

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
    #throw InvalidBoardError if board.empty?
    bundle_pieces.each do | player_piece |

      # TODO: place white piece on the board
      player_piece.white.each do | piece_location |
        chess_coordinate = chess_to_coordinates(piece_location)
        @board[chess_coordinate[0]][chess_coordinate[1]] = player_piece.new("white")
      end

      #TODO: place black piece on the board
      player_piece.black.each do | piece_location |
        chess_coordinate = chess_to_coordinates(piece_location)
        @board[chess_coordinate[0]][chess_coordinate[1]] = player_piece.new("black")
      end
    end

    occupied_board

  end

  def bundle_pieces
    pieces = []

    pieces << Pawn << Bishop << Knight <<  Rook << King << Queen
    pieces
  end

  # Convert chess notation to coordinates (e.g., "A1" to [0, 0])
  def chess_to_coordinates(chess_string)
    chess_string = chess_string.downcase
    x = chess_string[1].to_i - 1
    y = chess_string[0].ord - 'a'.ord
    return [x, y]
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

  def format_piece(piece)
    case piece::class.to_s
    when "Pawn" then
      case piece::type
      when "white"
        "\u2659"
      else
        "\u265F"
      end
    when "Bishop"
      case piece::type
      when "white"
        "\u2657"
      else
        "\u265D"
      end
    when "Knight"
      case piece::type
      when "white"
        "\u2658"
      else
        "\u265E"
      end
    when "Rook"
      case piece::type
      when "white"
        "\u2656"
      else
        "\u265C"
      end
    when "King"
      case piece::type
      when "white"
        "\u2654"
      else
        "\u265A"
      end
    when "Queen"
      case piece::type
      when "white"
        "\u2655"
      else
        "\u265B"
      end
    end
  end

  def show_board

    @board.each do |valueline|
      valueline.each do | piece |
        print " #{self.format_piece(piece)} "
      end
      puts ""
    end
  end

end
board = Chess.new
#board.move_piece([6, 1], [5,0])
board.show_board

