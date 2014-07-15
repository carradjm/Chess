class Piece

  def initialize(loc, board, color)
    @loc, @color = loc, color
    @board = board
  end

  def moves
    move_spaces = []


    move_spaces
  end

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
        break if (!(0..7).include?(new_x) || !(0..7).include?(new_y)) ||
        @board[new_x,new_y].color == @color

          possible_moves << [new_x,new_y]
        end
    end



    possible_moves
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

end

class Knight < SteppingPiece

  def move_dirs
  end

end

class King < SteppingPiece

  def move_dirs
  end

end

class Pawn < Piece

end