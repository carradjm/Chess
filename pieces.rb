require 'debugger'

class Piece

  attr_accessor :pos

  attr_reader :color

  def initialize(pos, board, color)
    @pos, @color = pos, color
    @board = board
    @board[pos] = self
  end

  def inspect
    [self.class,color,pos].inspect
  end

  def dup(new_board)
    self.class.new(@pos,new_board,@color)
  end

  def valid_moves
    valids = []

    moves.each do |new_pos|
      temp_board = @board.dup
      temp_board.move!(pos, new_pos)
      valids << new_pos if !temp_board.in_check?(@color)
    end

    valids
  end

end

class SlidingPiece < Piece

  RANK_FILE_DELTAS = [[0,1],[0,-1],[1,0],[-1,0]]

  DIAG_DELTAS = [[1,1],[-1,-1],[-1,1],[1,-1]]

  def moves

    possible_pos = []

    current_pos = pos

    move_dirs.each do |dx,dy|
      current_pos = [current_pos[0] + dx, current_pos[1] + dy]
      while @board.on_board?(current_pos)
        if @board[current_pos].nil?
          possible_pos << current_pos
          current_pos = [current_pos[0] + dx, current_pos[1] + dy]
        else
          if @board[current_pos].color == @color
            break
          else
            possible_pos << current_pos
            break
          end
        end
      end

      current_pos = pos
    end

    possible_pos
  end

end

class Queen < SlidingPiece

  def move_dirs
    dirs = RANK_FILE_DELTAS + DIAG_DELTAS
  end

  def display
    color == :white ? "♕" : "♛"
  end

end

class Bishop <SlidingPiece

  def move_dirs
    dirs = DIAG_DELTAS
  end

  def display
    color == :white ? "♗" : "♝"
  end

end

class Rook <SlidingPiece

  def move_dirs
    dirs = RANK_FILE_DELTAS
  end

  def display
    color == :white ? "♖" : "♜"
  end

end

class SteppingPiece < Piece

  def moves

    news = []
    deltas.each do |dx, dy|
      new_x, new_y = @pos[0] + dx, @pos[1] + dy
      if (0..7).include?(new_x) && (0..7).include?(new_y)
        news << [new_x, new_y]
      end
    end

    news.select { |new_pos| @board[new_pos].nil? ||
      @board[new_pos].color != @color }
  end


end

class Knight < SteppingPiece

  def deltas
    [[2, 1],[2, -1],
     [-2, 1],[-2, -1],
     [1, 2],[1, -2],
     [-1, 2],[-1, -2]]
  end

  def display
    color == :white ? "♘" : "♞"
  end

end

class King < SteppingPiece

  def deltas
    [[1, 1],[-1, -1],
     [1, -1],[-1, 1],
     [1, 0],[-1, 0],
     [0, 1],[0, -1]]
  end

  def display
    color == :white ? "♔" : "♚"
  end

end

class Pawn < Piece

  def captures
    deltas = (color == :white ?  [[1,1], [-1,1]] : [[1,-1], [-1,-1]])

    capture_pos = []

    deltas.each do |dx, dy|
      new_pos = [@pos[0] + dx, @pos[1] + dy]
      next if !@board.on_board?(new_pos)|| @board[new_pos].nil?
      capture_pos << new_pos if @board[new_pos].color != color
    end

    capture_pos
  end

  def moves
    potential_moves = []

    if color == :white

      new_pos = [pos[0], pos[1]+1]

      if @board.on_board?(new_pos)
        potential_moves << new_pos if @board[new_pos].nil?
      end

      new_pos = [pos[0], pos[1]+2]

      if @board.on_board?(new_pos)
        potential_moves << new_pos if pos[1] == 1 && @board[new_pos].nil?
      end

    else
      new_pos = [pos[0], pos[1] - 1]

      if @board.on_board?(new_pos)
        potential_moves << new_pos if @board[new_pos].nil?
      end

      new_pos = [pos[0], pos[1] - 2]

      if @board.on_board?(new_pos)
        potential_moves << new_pos if pos[1] == 6 && @board[new_pos].nil?
      end

    end

    potential_moves + captures
  end

  def display
    color == :white ? "♙" : "♟"
  end

end