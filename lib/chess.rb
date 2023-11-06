require_relative 'chess_pieces'

class Chess
  attr_accessor :board, :points, :white_captured, :black_captured, :player, :check_mate
  @check_mate = false
  @white_captured = []
  @black_captured = []

  @message = ""
  def initialize
    @board_height = 8
    @board_width = 8
    @board = nil
    @occupied_board = nil
    create_board
    @check = { "black" => [], "white" => []}
    @player = "black"
  end

  def capture(piece, player_type)
    @black_captured << piece if player_type == "black"
    @white_captured << piece if player_type == "white"
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

  def promote(pawn_coordinate)
    puts "Pawn promotion:"
    puts "1. Queen\n2. Knight\n3. Bishop\n4. Rook"
    answer = gets.chomp

    case answer
    when 1
      @board[pawn_coordinate[0]][pawn_coordinate[1]] = Queen.new(@player)
    when 2
      @board[pawn_coordinate[0]][pawn_coordinate[1]] = Knight.new(@player)
    when 3
      @board[pawn_coordinate[0]][pawn_coordinate[1]] = Bishop.new(@player)
    when 4
      @board[pawn_coordinate[0]][pawn_coordinate[1]] = Rook.new(@player)
    end
  end

  def check_castle
    king_coordinates = []
    rook_coordinates = []

    # TODO: check if the King or Rook are white or black
    king = []
    rooks = []
    if @player == "white" then
      king = King.white
      rooks = Rook.white
    else
      king = King.black
      rooks = Rook.black
    end

    #check if the King has moved
    king_coordinates = chess_to_coordinates(king[0])

    return if @board[king_coordinates[0]][king_coordinates[1]]::class == King

    #check if the rook has moved
    rooks.each do | coordinate |
      rook_coordinates << chess_to_coordinates(coordinate)
    end

    # Get number of rook that have not moved
    rook_castles = 0
    valid_rook_coordinates = [] # If the rook has not moved then store
    rook_coordinates.each do | coordinate |
      rook_castles += @board[coordinate[0]][coordinate[1]]::class == Rook
      valid_rook_coordinates << coordinate if @board[coordinate[0]][coordinate[1]]::class == Rook
    end

    # Check all rooks have moved
    return if rook_castles == 0

    # Check if onr or two rooks have not moved
    possible_castles = []
    begin
      if rook_castles == 2 then

        # Check if the Rook 1 has space to move
        rook_one = king_to_rook(king_coordinates, valid_rook_coordinates[0])
        possible_castles << valid_rook_coordinates[0] if rook_one

        # Check if the Rook 2 has space to move
        rook_two = king_to_rook(king_coordinates, valid_rook_coordinates[1])
        possible_castles << valid_rook_coordinates[1] if rook_two
        # Apply Castling to rook one
        return possible_castles
      else
        only_rook = king_to_rook(king_coordinates, valid_rook_coordinates[0])
        possible_castles << valid_rook_coordinates[0] if only_rook
        possible_castles
      end
    rescue KingRookException
    p "King and Rook not in same row"
    end
    return false
  end

  # Checks if there is nothing between King and Rook
  def king_to_rook(king_coordinate, rook_coordinate)
    result = nil

    # Throw an exception if King Rook are not in the same row
    throw KingRookException if king_coordinate[0] != rook_coordinate[0]

    # Check if King is before Rook
    if (king_coordinate[1] < rook_coordinate[1])
      (king_coordinate[1] + 1).upto(rook_coordinate[1] - 1).each do | i |
        result = @board[king_coordinate[0]][i] == nil
        break if !result
      end
    else # Check if King is after Rook
      (rook_coordinate[1] + 1).downto(king_coordinate[1] - 1).each do | i |
        result = @board[rook_coordinate[0]][i] == nil
        break if !result
      end
    end
    result
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
    return [7 - x.to_i, y.to_i]
  end

  # Convert chess notation to coordinates (e.g., [0, 0] to "A1")
  def coordinates_to_chess(coordinate)
    x = coordinate[1] + 1
    y = ('a'.ord - coordinate[0].ord).chr
    return "#{y}#{x}".upcase
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

  def move_piece(piece_location, destination, castle = nil)
    occupied_board
    piece_location = chess_to_coordinates(piece_location)
    destination = chess_to_coordinates(destination)


    # Check if a king piece is checked
    check_flag = false
    check_flag = !check.empty?


    # # Check if the starting and destination points is valid
    # if (starting_point[0] < 0 || starting_point[1] >= 8) || (destination[0] < 0 || destination[1] >= 8)
    #   throw OutOfBounds # Throw an exception
    # end


    piece = @board[piece_location[0]][piece_location[1]]

    puts "End here..."
    return if !piece.validate_move(piece_location, destination, @occupied_board)
    puts "End here..."
    # If the slot we're going to is occupied by a piece, then we capture the piece
    if @board[destination[0]][destination[1]] != nil then
      capture(@board[destination[0]][destination[1]], @player)
      @board[destination[0]][destination[1]] = nil
    end

    check_flag = check.empty?
    return if check_flag

    # If there is nothing then we move the piece to the destination
    @board[destination[0]][destination[1]] = @board[piece_location[0]][piece_location[1]]
    @board[piece_location[0]][piece_location[1]] = nil


    # Check if player wants to castle
    @message = if check_castle then
       "Castling is availble on: #{coordinates_to_chess(check_castle[0])} , #{check_castle[1]}"
      else
        ""
      end
    rook_castles(castle) if castle && check_castle

    # Promote pawn
    promote(destination) if @board[destination[0]][destination[1]]::class == Pawn && (destination[0] == chess_to_coordinates("a1")[0] || destination[0] == chess_to_coordinates("a8")[0])

    # Store possible checks
    @check[@player] = check

    # Check if king is checkmated
    check_mate = @board[get_king_coordinate[0]][get_king_coordinate[1]].get_king_moves(get_king_coordinate, nil).all? { | element | check.include?(element) }
    game_over = true if check_mate
    @message = "Player #{@player} has won by checkmate" if game_over

    # Change the player
    switch_player
  end

  def switch_player
    @player = if @player == "white" then
                    "black"
                    else
                      "white"
                    end
  end
  def rook_castles(rook_coordinate)
    king_coordinate = if @player == "white" then
                  King.white
                else
                  King.black
                end
    rook_coordinate = chess_to_coordinates(rook_coordinate)
    return if !check_castle.include?(rook_coordinate)


    if king_coordinate[1] < rook_coordinate[1] then
    @board[king_coordinate[0]][king_coordinate[1] + 2] = @board[king_coordinate[0]][king_coordinate[1]]
    @board[king_coordinate[0]][king_coordinate[1] + 2].moved
    @board[king_coordinate[0]][king_coordinate[1]] = nil
    @board[king_coordinate[0]][king_coordinate[1] + 1] = @board[rook_coordinate[0]][rook_coordinate[1]]
    @board[rook_coordinate[0]][rook_coordinate[1]] = nil
    elsif king_coordinate[1] < rook_coordinate[1] then
      @board[king_coordinate[0]][king_coordinate[1] - 2] = @board[king_coordinate[0]][king_coordinate[1]]
      @board[king_coordinate[0]][king_coordinate[1] - 2].moved
      @board[king_coordinate[0]][king_coordinate[1]] = nil
      @board[king_coordinate[0]][king_coordinate[1] - 1] = @board[rook_coordinate[0]][rook_coordinate[1]]
      @board[rook_coordinate[0]][rook_coordinate[1]] = nil
    else
      return
    end

    @message = "Castled Rook to #{coordinates_to_chess(rook_coordinate)}"
  end

  def get_king_coordinate
    king_coordinate = []
    @board.each_with_index do |row, outter_index|
      row.each_with_index do | col, inner_index|
        #print col.type if col != nil
        king_coordinate << outter_index << inner_index if col::class == King && col.type == @player
        break if !king_coordinate.empty?
      end
    end

    king_coordinate
  end

  def check
    king_coordinate = get_king_coordinate

    opponent_player = []
    @board.each_with_index do | piece_row, outter_index |
      piece_row.each_with_index do | piece_column, inner_index |
        common_coordinates = []
        common_coordinates = piece_column.get_moves([outter_index, inner_index],king_coordinate) if piece_column != nil
        if @player == "white" && piece_column != nil then
          opponent_player << common_coordinates if @board[outter_index][inner_index]::type == "black" && common_coordinates.include?(king_coordinate)
        elsif @player == "black" && piece_column != nil then
          opponent_player << common_coordinates if @board[outter_index][inner_index]::type == "white" && common_coordinates.include?(king_coordinate)
        end
      end
    end
    opponent_player
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

  def format_piec(piece)
    case piece::class.to_s
    when "Pawn" then
      case piece::type
      when "white"
        "wP"
      else
        "bP"
      end
    when "Bishop"
      case piece::type
      when "white"
        "wB"
      else
        "bB"
      end
    when "Knight"
      case piece::type
      when "white"
        "wKn"
      else
        "bKn"
      end
    when "Rook"
      case piece::type
      when "white"
        "wR"
      else
        "bR"
      end
    when "King"
      case piece::type
      when "white"
        "wK"
      else
        "bK"
      end
    when "Queen"
      case piece::type
      when "white"
        "wQ"
      else
        "bQ"
      end
    end
  end

  def show_board

    @board.each_with_index do |valueline, index|
      print "#{8 - index} "
      valueline.each do | piece |
        print " #{self.format_piec(piece)} "
      end
      puts ""
    end
    print "  "
    ('a'...'h').each do | letter |
      print " #{letter}   "
    end
    puts ""
  end

end

