require './lib/chess.rb'

def play(board)
  until board.check_mate do
    system("clear") || system("cls")
    puts "  meChess\n"
    puts "    Player: #{board.player.upcase}\n"
    #puts "Score: #{board.score}"
    board.show_board
    puts "\n  Enter \"S\" to save."
    puts "  Enter \"E\" to exit."
    puts "Enter Initial Piece Location & Destination Location: (e.g: \"A2 A4\") or (e.g: \"A1 D1\" 1)"
    initial, destination, castle = gets.chomp.split(" ")

    #save
    if initial == "S"
      puts " Enter filename to save:"
      filename = gets.chomp + ".json"
      save(filename, board)
      puts "Saved game state: #{filename}!"
      sleep(4)
      next
    end

    #exit
    if initial == "E" then
      puts "#{board.player} quits!"
      sleep(2)
      exit
    end

    next if initial == nil || destination == nil
    castle = nil if castle != "1"
    board.move_piece(initial, destination, castle)
  end
end


choice = 0
choice_list = [1, 2, 3]
until choice_list.include?(choice) do
  puts "Welcome to meChess!"
  puts "1. Create a new game"
  puts "2. Load saved game"
  puts "3. See how to play"
  print "Choice: "
  choice = gets.chomp.to_i
end

system("clear") || system("cls")

case choice
when 1 then
  # Create a new board
  board = Chess.new

  play(board)

when 2 then
  puts " Select filename to load:"
  directory_path = './saved'

  # Get a list of all files in the specified directory
  files = Dir.entries(directory_path)

  # Filter the list to include only JSON files (files ending with .json)
  json_files = files.select { |file| file.end_with?('.json') }

# Print the list of JSON files
  json_files.each_with_index do |json_file, index|
    puts "#{index}. #{json_file}"
  end

  # Select File
  choice = gets.chomp.to_i
  filename = json_files[choice]

  # Load saved file to new Board !Continuation
  board = Chess.new
  load("#{directory_path}/" + filename, board)

  # Resume
  play(board)
when 3 then
  puts how_to_play # Guide
  exit
end










