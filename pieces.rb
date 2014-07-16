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

    move_pos = []

    current_pos = pos

    move_directions.each do |dx,dy|
      current_pos = [current_pos[0] + dx, current_pos[1] + dy]

      while @board.on_board?(current_pos)
        if @board[current_pos].nil?
          move_pos << current_pos
          current_pos = [current_pos[0] + dx, current_pos[1] + dy]
        else
          move_pos << current_pos unless @board[current_pos].color == @color
          break
        end
      end

      current_pos = pos
    end

    move_pos
  end

end

class Queen < SlidingPiece

  def display
    color == :white ? "♕" : "♛"
  end

  def power
    1
  end

  private

  def move_directions
    dirs = RANK_FILE_DELTAS + DIAG_DELTAS
  end

end

class Bishop <SlidingPiece

  def display
    color == :white ? "♗" : "♝"
  end

  def power
    3
  end

  private

  def move_directions
    dirs = DIAG_DELTAS
  end

end

class Rook <SlidingPiece

  def display
    color == :white ? "♖" : "♜"
  end

  def power
    2
  end

  private

  def move_directions
    dirs = RANK_FILE_DELTAS
  end

end

class SteppingPiece < Piece

  def moves
    move_pos = []

    deltas.each do |dx, dy|
      new_x, new_y = @pos[0] + dx, @pos[1] + dy
      if (0..7).include?(new_x) && (0..7).include?(new_y)
        move_pos << [new_x, new_y]
      end
    end

    move_pos.select { |new_pos| @board[new_pos].nil? ||
      @board[new_pos].color != @color }
  end

end

class Knight < SteppingPiece

  def display
    color == :white ? "♘" : "♞"
  end

  def power
    4
  end

  private

  def deltas
    [[2, 1],[2, -1],
     [-2, 1],[-2, -1],
     [1, 2],[1, -2],
     [-1, 2],[-1, -2]]
  end

end

class King < SteppingPiece

  def display
    color == :white ? "♔" : "♚"
  end

  private

  def deltas
    [[1, 1],[-1, -1],
     [1, -1],[-1, 1],
     [1, 0],[-1, 0],
     [0, 1],[0, -1]]
  end

end

class Pawn < Piece

  def display
    color == :white ? "♙" : "♟"
  end

  def power
    5
  end

  def moves
    moves_to_empty + captures
  end

  private

  def moves_to_empty
    home_row = ( color == :white ? 1 : 6 )
    dy = ( color == :white ? 1 : -1 )
    move_pos = []

    new_pos = [pos[0], pos[1] + dy] #regular move

    if @board.on_board?(new_pos)
      move_pos << new_pos if @board[new_pos].nil?
    end

    new_pos = [pos[0], pos[1] + (2 * dy)] #optional for first move only

    if @board.on_board?(new_pos)
      move_pos << new_pos if pos[1] == home_row && @board[new_pos].nil?
    end

    move_pos
  end

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

end