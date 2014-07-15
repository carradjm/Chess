require './chessboard.rb'


class Game
  attr_reader :board

  def initialize(white, black)
    @white, @black = white, black
  end

  def play
    playing = @white
    @board = Board.new
    until @board.checkmate?
      @board.display

      @board.move(*playing.choose_move)

      playing = ( playing == @white ? @black : @white )
    end
  end

end

class HumanPlayer

  def initialize(name)
    @name = name
  end

  def choose_move
    puts "#{@name}, please enter your move in the form of a8,b8 (move from a8 to b8)."
    input = gets.chomp.split(',')
    start = [file_to_x(input[0][0]), rank_to_y(input[0][1].to_i)]
    end_pos = [file_to_x(input[1][0]), rank_to_y(input[1][1].to_i)]

    [start, end_pos]
  end

  def rank_to_y(rank)
    rank - 1
  end

  def file_to_x(file)
    'abcdefgh'.index(file)
  end

end