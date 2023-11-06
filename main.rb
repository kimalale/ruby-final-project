require './lib/chess.rb'

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
  board = Chess.new

  until board.check_mate do
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

    castle = nil if castle != "1"
    board.move_piece(initial, destination, castle)
    system("clear") || system("cls")
  end
when 2 then
  puts " Enter filename to load:"
  directory_path = './lib'

  # Get a list of all files in the specified directory
  files = Dir.entries(directory_path)

  # Filter the list to include only JSON files (files ending with .json)
  json_files = files.select { |file| file.end_with?('.json') }

# Print the list of JSON files
  json_files.each do |json_file|
    puts "1. #{json_file}"
  end

  # select
  choice = gets.chomp.to_i

  filename = json_files[choice]
  load(filename, board)
when 3 then
  how_to_play
end










