class Piece

  attr_reader :color, :pos

  def initialize(pos, board, color)
    @pos, @color = pos, color
    @board = board
    @board[pos] = self
  end

  # def moves
#     move_spaces = []
#
#
#     move_spaces
#   end

end

class SlidingPiece < Piece
  RANK_POS_DELTAS = [[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]]

  RANK_NEG_DELTAS = [[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]]

  FILE_POS_DELTAS = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0]]
  FILE_NEG_DELTAS = [[-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]]

  DIAG_NE_DELTAS = [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]]
  DIAG_SW_DELTAS = [[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]]
  DIAG_NW_DELTAS = [[-1,1],[-2,2],[-3,3],[-4,4],[-5,5],[-6,6],[-7,7]]
  DIAG_SE_DELTAS = [[1,-1],[2,-2],[3,-3],[4,-4],[5,-5],[6,-6],[7,-7]]

  def moves
    possible_pos = []

    move_dirs.each do |direction|
      direction.each do |dx,dy|
        new_x, new_y = @pos[0] + dx, @pos[1] + dy
        break if (!(0..7).include?(new_x) || !(0..7).include?(new_y))

        unless @board[[new_x,new_y]].nil?
          break if @board[[new_x,new_y]].color == @color
        end

        possible_pos << [new_x,new_y]
      end
    end



    possible_pos
  end

end

class Queen < SlidingPiece

  def move_dirs
    dirs = [RANK_POS_DELTAS,RANK_NEG_DELTAS,FILE_POS_DELTAS,FILE_NEG_DELTAS,
            DIAG_NE_DELTAS,DIAG_SW_DELTAS,DIAG_NW_DELTAS,DIAG_SE_DELTAS]
  end

end

class Bishop <SlidingPiece

  def move_dirs
    dirs = [DIAG_NE_DELTAS,DIAG_SW_DELTAS,DIAG_NW_DELTAS,DIAG_SE_DELTAS]
  end

end

class Rook <SlidingPiece

  def move_dirs
    dirs = [RANK_POS_DELTAS,RANK_NEG_DELTAS,FILE_POS_DELTAS,FILE_NEG_DELTAS]
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

end

class King < SteppingPiece

  def deltas
    [[1, 1],[-1, -1],
     [1, -1],[-1, 1],
     [1, 0],[-1, 0],
     [0, 1],[0, -1]]
  end

end

class Pawn < Piece

  def moves
    moves = []

    if color == :white
      moves << [pos[0], pos[1]+1] if @board[[pos[0], pos[1]+1]].nil?
      moves << [pos[0], pos[1]+2] if pos[1] == 1
      unless @board[[pos[0]+1, pos[1]+1]].nil?
        moves << [pos[0]+1, pos[1]+1] if @board[[pos[0]+1, pos[1]+1]].color == :black
      end
      unless @board[[pos[0]-1, pos[1]+1]].nil?
        moves << [pos[0]-1, pos[1]+1] if @board[[pos[0]-1, pos[1]+1]].color == :black
      end

    else
      moves << [pos[0], pos[1]-1] if @board[[pos[0], pos[1]-1]].nil?
      moves << [pos[0], pos[1]-2] if pos[1] == 6
      unless @board[[pos[0]+1, pos[1]-1]].nil?
        moves << [pos[0]+1, pos[1]-1] if @board[[pos[0]+1, pos[1]-1]].color == :white
      end
      unless @board[[pos[0]-1, pos[1]-1]].nil?
        moves << [pos[0]-1, pos[1]-1] if @board[[pos[0]-1, pos[1]-1]].color == :white
      end
    end

      moves
  end

end