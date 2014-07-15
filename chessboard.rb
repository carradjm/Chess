class Board

  def initialize
    @grid = Array.new(8) {Array.new(8)}
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
    king_pos
  end

  def move(start, end_pos)
  end

end