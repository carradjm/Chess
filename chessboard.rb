require './pieces.rb'
require 'colorize'

class Board

  attr_accessor :white_king, :black_king

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
      print "   ┌#{"───┬"* (7)}───┐\n".colorize(:light_cyan)

      (0...8).to_a.reverse.each do |y|
        print " #{y+1}".colorize(:light_black)
        print " │".colorize(:light_cyan)
        8.times do |x|
          if !self[[x,y]].nil?
            print " #{self[[x,y]].display} "
          else
            print "   "
          end
          print "│".colorize(:light_cyan)
        end
        print "\n"
        print "   ├#{"───┼" * (7)}───┤\n".colorize(:light_cyan) unless y == 0
      end
      print "   └#{"───┴"* (7)}───┘\n".colorize(:light_cyan)
      print "     A   B   C   D   E   F   G   H  \n".colorize(:light_black)
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
      self[start] = nil
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
      if piece.class == King
        if piece.color == :white
          dup_board.white_king = piece.dup(dup_board)
        else
          dup_board.black_king = piece.dup(dup_board)
        end
      else
        piece.dup(dup_board)
      end
    end

    dup_board
  end

  def color_checkmate?(color)
    return false if !self.in_check?(color)

    @grid.flatten.compact.each do |piece|
      next if piece.color != color
      return false unless piece.valid_moves.empty?
    end

    true
  end

  def checkmate?
    self.color_checkmate?(:white) || self.color_checkmate?(:black)
  end

end

class IllegalMoveError < StandardError
end

class NoPieceError < StandardError
end