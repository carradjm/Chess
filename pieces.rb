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
  RANK_DELTAS = [[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]
  ,[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]]
]
  FILE_DELTAS = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
  [-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]]

  DIAG_DELTAS = [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],
[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]
[-1,1],[-2,2],[-3,3],[-4,4],[-5,5],[-6,6],[-7,7],
[1,-1],[2,-2],[3,-3],[4,-4],[5,-5],[6,-6],[7,-7]
]


  def moves
    self.class
  end

end

class Queen < SlidingPiece

  def move_dirs
    moves []
  end

end

class Bishop <SlidingPiece

  def move_dirs
  end

end

class Rook <SlidingPiece

  def move_dirs
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