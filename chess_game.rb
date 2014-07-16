require './chessboard.rb'

class Game

  attr_reader :board

  def initialize(white, black)
    @white, @black = white, black
    @white.color = :white
    @black.color = :black
  end

  def play
    playing = @white
    @board = Board.new

    until @board.checkmate?
      @board.display
      puts "Check!" if board.in_check?(playing.color)

      begin
        @board.move(*playing.choose_move, playing.color)

      rescue NotYoPieceError
        puts "Stop cheating. Move your own piece.  Come on man."
        retry

      rescue IllegalMoveError
        puts "You can't move there."
        retry

      rescue MoveToCheckError
        if board.in_check?(playing.color)
          puts "You are in check! Move out of check."
        else
          puts "That will put your King in check. Choose again."
        end
        retry

      rescue NoPieceError
        puts "There is no piece at that position."
        retry
      end

      playing = ( playing == @white ? @black : @white ) #switches turns
    end

    if playing == @white
      puts "Checkmate! Black wins."
    else
      puts "Checkmate! White wins."
    end

    @board.display
  end

end

class HumanPlayer

  attr_accessor :color

  def initialize(name)
    @name = name
    @color = nil
  end

  def choose_move
    puts "#{@name}, please enter your move in the form of a8,b8 (move from a8 to b8)."

    begin
      input = gets.chomp
      check_input(input)
    rescue BadInput, ArgumentError
      puts "Please enter a correctly formatted move."
      retry
    end

    input = input.split(",")

    start = [file_to_x(input[0][0]), rank_to_y(input[0][1].to_i)]
    end_pos = [file_to_x(input[1][0]), rank_to_y(input[1][1].to_i)]

    [start, end_pos]
  end

  private

  def check_input(input)
    raise BadInput if input.size != 5

    Integer(input[1])
    Integer(input[4])

    raise BadInput if !("a".."z").to_a.include?(input[0])
    raise BadInput if !("a".."z").to_a.include?(input[3])
  end

  def rank_to_y(rank)
    rank - 1
  end

  def file_to_x(file)
    'abcdefgh'.index(file)
  end

end

class BadInput < StandardError
end
