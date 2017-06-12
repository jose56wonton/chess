require_relative 'pieces.rb'
require 'io/console'
class Board
  attr_accessor  :board, :current_player, :current_piece, :moves, :current_move
  def initialize
    system("clear")
    puts "Please enter 'load' to play an old game or 'new' for a new one."
    input = ""
    loop do
      input = gets.chomp
      break if input == "new" || input == "load"
    end
    if input == "new"
      new_game
      select_piece
    else
      load_game
    end


  end
#file serialization
  def new_game
    @board = [[],[],[],[],[],[],[],[]]
    @board[7][4] = King.new("light")
    @board[0][4] = King.new("dark")

    @board[7][3] = Queen.new("light")
    @board[0][3] = Queen.new("dark")

    @board[7][5] = Bishop.new("light")
    @board[7][2] = Bishop.new("light")
    @board[0][5] = Bishop.new("dark")
    @board[0][2] = Bishop.new("dark")

    @board[7][1] = Knight.new("light")
    @board[7][6] = Knight.new("light")
    @board[0][1] = Knight.new("dark")
    @board[0][6] = Knight.new("dark")

    @board[7][0] = Rook.new("light")
    @board[7][7] = Rook.new("light")
    @board[0][0] = Rook.new("dark")
    @board[0][7] = Rook.new("dark")

    @board[1][0] = Pawn.new("dark")
    @board[1][1] = Pawn.new("dark")
    @board[1][2] = Pawn.new("dark")
    @board[1][3] = Pawn.new("dark")
    @board[1][4] = Pawn.new("dark")
    @board[1][5] = Pawn.new("dark")
    @board[1][6] = Pawn.new("dark")
    @board[1][7] = Pawn.new("dark")

    @board[6][0] = Pawn.new("light")
    @board[6][1] = Pawn.new("light")
    @board[6][2] = Pawn.new("light")
    @board[6][3] = Pawn.new("light")
    @board[6][4] = Pawn.new("light")
    @board[6][5] = Pawn.new("light")
    @board[6][6] = Pawn.new("light")
    @board[6][7] = Pawn.new("light")
    @current_player = "light"
    @current_piece = @board[6][0]
    @moves = []
    @current_move = 0
  end
  def save_game
    File.open('saves/saved_game', 'w') do |file|
      file.puts Marshal::dump(self)
    end
    puts "Saved!"
  end
  def load_game
    File.open('saves/saved_game', 'r') do |file|
      if file.eof?
        puts "There was no saved game!"
        sleep 2
        new_game
        select_piece
      else
        old_game = Marshal::load(file)
        @board = old_game.board
        @current_player = old_game.current_player
        @current_piece = old_game.current_piece
        @moves = old_game.moves
        @current_move = old_game.current_move
        puts "Game Loaded"
        if @moves.length == 0
          select_piece
        else
          select_move
        end
      end

    end
  end
#reset the class for the next player
  def change_player
    @current_player == "light" ? @current_player = "dark" : @current_player = "light"
  end
  def get_new_current_piece
    8.times do |i|
      8.times do |j|
        unless @board[i][j].nil?

          if @current_player == "light" && @board[i][j].color == "light"
            @current_piece = @board[i][j]
            return
          elsif @current_player == "dark" && @board[i][j].color == "dark"
            @current_piece = @board[i][j]
            return
          end
        end

      end
    end
  end


=begin
I am honestly just copying this.
I got it from http://www.alecjacobson.com/weblog/?p=75
Thank you Alec Jacobson <3
=end
  def get_input
    begin
    old_state = `stty -g`
    system "stty raw -echo"
    c = STDIN.getc.chr
    if(c=="\e")
      extra_thread = Thread.new{
        c = c + STDIN.getc.chr
        c = c + STDIN.getc.chr
      }
      extra_thread.join(0.00001)
      extra_thread.kill
    end

    rescue => ex
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace


    ensure
      system "stty #{old_state}"
    end
    return c
  end
#assess game state
  def victory?
    count = 0

    8.times do |i|
      8.times do |j|
        if @board[i][j].class.to_s == "King"
          count+=1
        end
      end
    end
    (count == 2) ? (return false) : (return true)
  end
#declare victory
  def victory
    puts "#{self.current_player}'s win!"
  end


#gettings a piece
  def select_piece

    print_board
    input = " "
    loop do
      input = get_input
      case input
      when "\r"
        generate_moves
        if @moves.length > 0
          @moves = []
          break
        end
      when "s"
        self.save_game
        break
      when "\e"
        break
      when "\e[C"
        get_next_piece
        print_board
      when "\e[D"
        get_previous_piece
        print_board
      end
    end
    select_move if input =="\r"
  end
  def get_next_piece
    passed = false
    location = []
    8.times do |i|
      8.times do |j|
        if passed && !@board[i][j].nil? && @current_piece.color == @board[i][j].color
          @current_piece = @board[i][j]
          location[0] = i
          location[1] = j
          return location
        end
        if @board[i][j] == @current_piece
          passed = true
          location[0] = i
          location[1] = j
        end
      end
    end
    return location
  end
  def get_previous_piece
    passed = false
    location = []
    7.downto(0) do |i|
      7.downto(0) do |j|
        if passed && !@board[i][j].nil? && @current_piece.color == @board[i][j].color
          @current_piece = @board[i][j]
          location[0] = i
          location[1] = j
          return location
        end
        if @board[i][j] == @current_piece
          passed = true
          location[0] = i
          location[1] = j
        end
      end
    end
    return location
  end
  def get_location_of_current_piece
    8.times do |i|
      8.times do |j|
        if @board[i][j] == @current_piece
          location=[]
          location[0] = i
          location[1] = j
          return location
        end
      end
    end
  end
  def print_board
    system("clear")
    puts "Select a piece #{@current_player}'s!"
    8.times do |i|
      8.times do |j|

        if @board[i][j].nil?
          print "  "
        elsif @board[i][j] == @current_piece
          print "* "
        else
          case @board[i][j].class.to_s
          when "Queen"
            (@board[i][j].color == "light") ?  (print "♕ ") : (print "♛ ")
          when "King"
            (@board[i][j].color == "light") ?  (print "♔ ") : (print "♚ ")
          when "Bishop"
            (@board[i][j].color == "light") ?  (print "♗ ") : (print "♝ ")
          when "Knight"
            (@board[i][j].color == "light") ?  (print "♘ ") : (print "♞ ")
          when "Rook"
            (@board[i][j].color == "light") ?  (print "♖ ") : (print "♜ ")
          when "Pawn"
            (@board[i][j].color == "light") ?  (print "♙ ") : (print "♟ ")
          else
            print "  "
          end
        end

      end
      puts ""
    end
  end

#getting a move
  def generate_moves
    location = get_location_of_current_piece
    c = location[1]
    r = location[0]

    current = @board[r][c]
    case current.class.to_s
    when "King"
      if r-1 >=0 && c+1 < 8 && (@board[r-1][c+1].nil? || @board[r-1][c+1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-1][c+1] = Piece.new(@current_player)
        @moves<< temp_board
      end
      if c+1 < 8 && (@board[r][c+1].nil? || @board[r][c+1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r][c+1] = Piece.new(@current_player)
        @moves<< temp_board
      end
      if r+1 < 8 && c+1 < 8 && (@board[r+1][c+1].nil? || @board[r+1][c+1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+1][c+1] = Piece.new(@current_player)
        @moves<< temp_board
      end
      if r+1 < 8 && (@board[r+1][c].nil? || @board[r+1][c].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+1][c] = Piece.new(@current_player)
        @moves<< temp_board
      end
      if r+1 < 8 && c-1 >=0 && (@board[r+1][c-1].nil? || @board[r+1][c-1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+1][c-1] = Piece.new(@current_player)
        @moves<< temp_board
      end
      if c-1 >=0 && (@board[r][c-1].nil? || @board[r][c-1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r][c-1] = Piece.new(@current_player)
        @moves<< temp_board
      end
      if r-1 >=0 && c-1 >=0 && (@board[r-1][c-1].nil? || @board[r-1][c-1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-1][c-1] = Piece.new(@current_player)
        @moves<< temp_board
      end
      if r-1 >=0 && (@board[r-1][c].nil? || @board[r-1][c].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-1][c] = Piece.new(@current_player)
        @moves<< temp_board
      end

    when "Queen"
      1.upto(7) do |i|
        break if r-i < 0 || c+i >= 8 || (!@board[r-i][c+i].nil? && @board[r-i][c+i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-i][c+i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r-i][c+i].nil? && @board[r-i][c+i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if c+i >= 8 || (!@board[r][c+i].nil? && @board[r][c+i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r][c+i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r][c+i].nil? && @board[r][c+i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r+i >= 8 || c+i >= 8 || (!@board[r+i][c+i].nil? && @board[r+i][c+i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+i][c+i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r+i][c+i].nil? && @board[r+i][c+i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r+i >= 8 || (!@board[r+i][c].nil? && @board[r+i][c].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+i][c] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r+i][c].nil? && @board[r+i][c].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r+i >= 8 || c-i < 0 || (!@board[r+i][c-i].nil? && @board[r+i][c-i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+i][c-i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r+i][c-i].nil? && @board[r+i][c-i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if c-i < 0 || (!@board[r][c-i].nil? && @board[r][c-i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r][c-i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r][c-i].nil? && @board[r][c-i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r-i < 0 || c-i < 0 || (!@board[r-i][c-i].nil? && @board[r-i][c-i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-i][c-i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r-i][c-i].nil? && @board[r-i][c-i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r-i < 0 || (!@board[r-i][c].nil? && @board[r-i][c].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-i][c] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r-i][c].nil? && @board[r-i][c].color != @board[r][c].color)
      end
    when "Bishop"
      1.upto(7) do |i|
        break if  r-i < 0 || c+i >= 8 || (!@board[r-i][c+i].nil? && @board[r-i][c+i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-i][c+i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r-i][c+i].nil? && @board[r-i][c+i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
          break if r+i >= 8 || c+i >= 8 || (!@board[r+i][c+i].nil? && @board[r+i][c+i].color == @board[r][c].color)
          temp_board = @board.map(&:clone)
          temp_board[r+i][c+i] = Piece.new(@current_player)
          @moves<< temp_board
          break if (!@board[r+i][c+i].nil? && @board[r+i][c+i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r+i >= 8 || c-i < 0 || (!@board[r+i][c-i].nil? && @board[r+i][c-i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+i][c-i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r+i][c-i].nil? && @board[r+i][c-i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r-i < 0 || c-i < 0 || (!@board[r-i][c-i].nil? && @board[r-i][c-i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-i][c-i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r-i][c-i].nil? && @board[r-i][c-i].color != @board[r][c].color)
      end


    when "Knight"
      if r-2 >= 0 && c+1 < 8 && (@board[r-2][c+1].nil? || @board[r-2][c+1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-2][c+1] = Piece.new(@current_player)
        @moves << temp_board
      end
      if r-1 >= 0 && c+2 < 8 && (@board[r-1][c+2].nil? || @board[r-1][c+2].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-1][c+2] = Piece.new(@current_player)
        @moves << temp_board
      end

      if r+1 < 8 && c+2 < 8 && (@board[r+1][c+2].nil? || @board[r+1][c+2].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+1][c+2] = Piece.new(@current_player)
        @moves << temp_board
      end
      if r+2 < 8 && c+1 < 8 && (@board[r+2][c+1].nil? || @board[r+2][c+1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+2][c+1] = Piece.new(@current_player)
        @moves << temp_board
      end
      if r+2 < 8 && c-1 >= 0 && (@board[r+2][c-1].nil? || @board[r+2][c-1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+2][c-1] = Piece.new(@current_player)
        @moves << temp_board
      end
      if r+1 < 8 && c-2 >= 0 && (@board[r+1][c-2].nil? || @board[r+1][c-2].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+1][c-2] = Piece.new(@current_player)
        @moves << temp_board
      end
      if r-1 >= 0 && c-2 >= 0 && (@board[r-1][c-2].nil? || @board[r-1][c-2].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-1][c-2] = Piece.new(@current_player)
        @moves << temp_board
      end
      if r-2 >= 0 && c-1 >= 0 && (@board[r-2][c-1].nil? || @board[r-2][c-1].color != @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-2][c-1] = Piece.new(@current_player)
        @moves << temp_board
      end



    when "Rook"
      1.upto(7) do |i|
          break if c+i >= 8 || (!@board[r][c+i].nil? && @board[r][c+i].color == @board[r][c].color)
          temp_board = @board.map(&:clone)
          temp_board[r][c+i] = Piece.new(@current_player)
          @moves<< temp_board
          break if (!@board[r][c+i].nil? && @board[r][c+i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r+i >= 8 || (!@board[r+i][c].nil? && @board[r+i][c].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r+i][c] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r+i][c].nil? && @board[r+i][c].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if c-i < 0 || (!@board[r][c-i].nil? && @board[r][c-i].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r][c-i] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r][c-i].nil? && @board[r][c-i].color != @board[r][c].color)
      end
      1.upto(7) do |i|
        break if r-i < 0 || (!@board[r-i][c].nil? && @board[r-i][c].color == @board[r][c].color)
        temp_board = @board.map(&:clone)
        temp_board[r-i][c] = Piece.new(@current_player)
        @moves<< temp_board
        break if (!@board[r-i][c].nil? && @board[r-i][c].color != @board[r][c].color)
      end



    when "Pawn"
      if current.color == "light" && r-1 >= 0 && @board[r-1][c].nil?
        temp_board = @board.map(&:clone)
        temp_board[r-1][c] = Piece.new(@current_player)
        @moves << temp_board
        if  !current.moved && current.color == "light" && r-2 >= 0 && @board[r-2][c].nil?
          temp_board = @board.map(&:clone)
          temp_board[r-2][c] = Piece.new(@current_player)
          @moves << temp_board
        end
      end
      if current.color == "light" && r-1 >= 0 && c-1 >= 0 && !@board[r-1][c-1].nil? && @board[r-1][c-1].color != current.color
        temp_board = @board.map(&:clone)
        temp_board[r-1][c-1] = Piece.new(@current_player)
        @moves << temp_board
      end
      if current.color == "light" && r-1 >= 0 && c+1 < 8 && !@board[r-1][c+1].nil? && @board[r-1][c+1].color != current.color
        temp_board = @board.map(&:clone)
        temp_board[r-1][c+1] = Piece.new(@current_player)
        @moves << temp_board
      end
      if current.color == "dark" && r+1 < 8 && @board[r+1][c].nil?
        temp_board = @board.map(&:clone)
        temp_board[r+1][c] = Piece.new(@current_player)
        @moves << temp_board
        if  !current.moved && current.color == "dark" && r+2 < 8 && @board[r+2][c].nil?
          temp_board = @board.map(&:clone)
          temp_board[r+2][c] = Piece.new(@current_player)
          @moves << temp_board
        end
      end
      if current.color == "dark" && r+1 < 8 && c+1 < 8 && !@board[r+1][c+1].nil? &&  @board[r+1][c+1].color != current.color
        temp_board = @board.map(&:clone)
        temp_board[r+1][c+1] = Piece.new(@current_player)
        @moves << temp_board
      end
      if current.color == "dark" && r+1 < 8 && c-1 >= 0 && !@board[r+1][c-1].nil? && @board[r+1][c-1].color != current.color
        temp_board = @board.map(&:clone)
        temp_board[r+1][c-1] = Piece.new(@current_player)
        @moves << temp_board
      end

    end
  end
  def select_move
    generate_moves
    puts "Select a move #{@current_player}!"
    print_board_moves
    input = ""
    loop do
      input = get_input
      case input
      when "\r"
        break
      when "s"
        self.save_game
        break
      when "\e"
        break
      when "\e[C"
        get_next_move
        print_board_moves
      when "\e[D"
        get_previous_move
        print_board_moves
      end
    end
    move_piece if input == "\r"
  end
  def get_next_move
    @current_move += 1
    @current_move %= @moves.length
    puts @current_move
    print_board_moves
  end
  def get_previous_move
    @current_move -= 1
    @current_move %= @moves.length
    puts @current_move
    print_board_moves
  end
  def move_piece


    @board = @moves[@current_move].map(&:clone)
    if @current_piece.class.to_s == "Pawn"
      @current_piece.moved = true
    end
    move_from = get_location_of_current_piece

    move_to = find_value
    r1 = move_from[0]
    c1 = move_from[1]
    r2 = move_to[0]
    c2 = move_to[1]
    @board[r2][c2] = @current_piece
    @board[r1][c1] = nil

    print_board

    if self.victory?
      self.victory
    else
      self.moves = []
      self.current_move = 0
      self.change_player
      self.get_new_current_piece
      self.select_piece
    end
  end
  def find_value
    8.times do |i|
      8.times do |j|
        if @board[i][j].class.to_s == "Piece"
          location=[]
          location[0] = i
          location[1] = j
          return location
        end
      end
    end
  end
  def print_board_moves
    system("clear")
    puts "Select a move #{@current_player}'s!"
    #puts "# of moves = #{@moves.length}"

    temp_board = @moves[@current_move]
    8.times do |i|
      8.times do |j|
        if temp_board[i][j] == @current_piece
          print "* "
        elsif temp_board[i][j].nil?
          print "  "
        else

          case temp_board[i][j].class.to_s
          when "Piece"
            print "x "
          when "Queen"
            (temp_board[i][j].color == "light") ?  (print "♕ ") : (print "♛ ")
          when "King"
            (temp_board[i][j].color == "light") ?  (print "♔ ") : (print "♚ ")
          when "Bishop"
            (temp_board[i][j].color == "light") ?  (print "♗ ") : (print "♝ ")
          when "Knight"
            (temp_board[i][j].color == "light") ?  (print "♘ ") : (print "♞ ")
          when "Rook"
            (temp_board[i][j].color == "light") ?  (print "♖ ") : (print "♜ ")
          when "Pawn"
            (temp_board[i][j].color == "light") ?  (print "♙ ") : (print "♟ ")
          end
        end

      end
      puts ""
    end
  end

end
x = Board.new
