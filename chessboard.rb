class Board

  def initialize(duplicate = false)
    @grid = Array.new(8) {Array.new(8)}
    setup_board if !duplicate
  end

  def setup_board
    Queen.new([3,0], self, :white)
    Queen.new([3,7], self, :black)

    @white_king = King.new([4,0], self, :white)
    @black_king = King.new([4,7], self, :black)

    Bishop.new([2,0], self, :white)
    Bishop.new([5,0], self, :white)
    Bishop.new([2,7], self, :black)
    Bishop.new([5,7], self, :black)

    Rook.new([0,0], self, :white)
    Rook.new([7,0], self, :white)
    Rook.new([0,7], self, :black)
    Rook.new([7,7], self, :black)

    Knight.new([1,0], self, :white)
    Knight.new([6,0], self, :white)
    Knight.new([1,7], self, :black)
    Knight.new([6,7], self, :black)

    8.times do |i|
      Pawn.new([i,1], self, :white)
      Pawn.new([i,6], self, :black)
    end

    nil
  end

  def display
      print "┌#{"──┬"* (7)}──┐\n"

      (0...8).to_a.reverse.each do |y|
        print "│"
        8.times do |x|
          if !self[[x,y]].nil?
            print self[[x,y]].display
          else
            print "  "
          end
          print "│"
        end
        print "\n"
        print "├#{"──┼" * (7)}──┤\n" unless y == 0
      end
      print "└#{"──┴"* (7)}──┘\n"
      nil
    end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def []=(pos, obj)
    x,y = pos
    @grid[x][y] = obj
    nil
  end

  def in_check?(color)
    king_pos = (color == :white ? @white_king.pos : @black_king.pos)

    @grid.flatten.compact.each do |piece|
      unless piece.color == color
        piece.moves.each do |move|
          return true if move == king_pos
        end
      end
    end

    false
  end

  def move(start, end_pos)

    if self[start].nil?
      raise NoPieceError
    end

    if self[start].valid_moves.include?(end_pos)
      self[end_pos] = self[start]
      self[end_pos].pos = end_pos
    else
      raise IllegalMoveError
    end

    nil
  end

  def move!(start, end_pos)

    if self[start].moves.include?(end_pos)
      self[end_pos] = self[start]
      self[end_pos].pos = end_pos
    end

    nil
  end


  def on_board?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end

  def dup
    dup_board = Board.new(true)
    @grid.flatten.compact.each do |piece|
      piece.dup(dup_board)
    end

    dup_board
  end

  def checkmate?
    return false if !self.in_check?

    @grid.flatten.compact.each do |piece|
      return false unless piece.valid_moves.empty?
    end

    true
  end

end

class IllegalMoveError < StandardError
end

class NoPieceError < StandardError
end