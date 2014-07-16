require './pieces.rb'
require 'colorize'
require 'debugger'

class Board

  attr_accessor :white_king, :black_king

  def initialize(duplicate = false)
    @grid = Array.new(8) {Array.new(8)}
    setup_board if !duplicate
    @jail = []
  end

  def setup_board

    @white_king = King.new([4,0], self, :white)
    @black_king = King.new([4,7], self, :black)

    Queen.new([3,0], self, :white)
    Queen.new([3,7], self, :black)

    Bishop.new([2,0], self, :white)
    Bishop.new([5,0], self, :white)
    Bishop.new([2,7], self, :black)
    Bishop.new([5,7], self, :black)

    Knight.new([1,0], self, :white)
    Knight.new([6,0], self, :white)
    Knight.new([1,7], self, :black)
    Knight.new([6,7], self, :black)

    Rook.new([0,0], self, :white)
    Rook.new([7,0], self, :white)
    Rook.new([0,7], self, :black)
    Rook.new([7,7], self, :black)

    8.times do |i|
      Pawn.new([i,1], self, :white)
      Pawn.new([i,6], self, :black)
    end

    nil
  end

  # def display
 #      print "   ┌#{"───┬"* (7)}───┐ ".colorize(:light_cyan)
 #      @jail.each {|piece| print piece.display if piece.color == :black}
 #      print "\n"
 #
 #      (0...8).to_a.reverse.each do |y|
 #        print " #{y+1}".colorize(:light_black)
 #        print " │".colorize(:light_cyan)
 #        8.times do |x|
 #          if !self[[x,y]].nil?
 #            print " #{self[[x,y]].display} "
 #          else
 #            print "   "
 #          end
 #          print "│".colorize(:light_cyan)
 #        end
 #        print "\n"
 #        print "   ├#{"───┼" * (7)}───┤\n".colorize(:light_cyan) unless y == 0
 #      end
 #      print "   └#{"───┴"* (7)}───┘ ".colorize(:light_cyan)
 #      @jail.each {|piece| print piece.display if piece.color == :white}
 #      print "\n"
 #      print "     A   B   C   D   E   F   G   H  \n".colorize(:light_black)
 #      nil
 #  end

   def display
     colors = { 0 => :light_white, 1 => :white }
     7.downto(0) do |y| #underscore?
        print " #{y+1} ".colorize(:light_black)

        8.times do |x|
          if self[[x,y]].nil?
            print "  ".colorize( :background => colors[(x+y)%2] )
          else
            print "#{self[[x,y]].display} ".colorize( :background => colors[(x+y)%2] )
          end
        end

        if y == 7
          @jail.each {|piece| print piece.display if piece.color == :black}
        elsif y == 0
          @jail.each {|piece| print piece.display if piece.color == :white}
        end

        print "\n"
      end


      print "   A B C D E F G H \n".colorize(:light_black)
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

  def move(start, end_pos, color)

    if self[start].nil?
      raise NoPieceError
    end

    if self[start].color != color
      raise NotYoPieceError
    end

    if self[start].valid_moves.include?(end_pos)
      @jail << self[end_pos]
      self[end_pos] = self[start]
      self[end_pos].pos = end_pos
      self[start] = nil
      if self[end_pos].class == King || self[end_pos].class == Rook
        self[end_pos].has_moved = true
      end

    else
      if self[start].moves.include?(end_pos)
        raise MoveToCheckError
      else
        raise IllegalMoveError
      end
    end

    @jail.compact!
    @jail.sort_by! {|piece| piece.power}

    #check for pawn promotion
    last_rank = (color == :white ? 7 : 0 )
    if self[end_pos].class == Pawn && end_pos[1] == last_rank
      raise PromotePawn
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

  def castle(color, side)
    y = (color == :white ? 0 : 7)
    king_x = 4
    rook_x = (side == :long ? 0 : 7)

    king_x_new = ( side == :long ? 2 : 6 )
    rook_x_new = ( side == :long ? 3 : 5 )

    king_x_path = ( side == :long ? [3, 2] : [5, 6] )
    in_between_x = ( side == :long ? [1,2,3] : [5,6] )

    raise NoCastleError if self[[king_x,y]].has_moved ||
                            self[[rook_x,y]].has_moved

    in_between_x.each do |x|
      raise NoCastleError unless self[[x,y]].nil?
    end

    raise NoCastleError if in_check?(color) #may not be in check

    king_x_path.each do |x| #king must not pass through check
      temp_board = self.dup
      temp_board[[x,y]], temp_board[[king_x,y]] = temp_board[[king_x,y]], nil
      temp_board[[x,y]].pos = [x,y]

      raise NoCastleError if temp_board.in_check?(color)
    end

    #king
    self[[2,y]], self[[4,y]] = self[[4,y]], nil
    self[[2,y]].pos = [2,y]

    #rook
    self[[3,y]], self[[0,y]] = self[[0,y]], nil
    self[[3,y]].pos = [3,y]
  end

  def promote_pawn(color)
    last_rank = (color == :white ? 7 : 0)

    position = nil
    8.times do |x|
      if self[[x,last_rank]].class == Pawn
        position = [x,last_rank]
        break
      end
    end

    puts "You must promote your pawn.\n
          Enter 'Q', 'R', 'B', or 'N' to select a piece."
    begin
      piece = gets.chomp.downcase

      new_piece = case piece
      when 'q' then Queen.new(position, self, color)
      when 'r' then Rook.new(position, self, color)
      when 'b' then Bishop.new(position, self, color)
      when 'n' then Knight.new(position, self, color)
      else raise BadInput
      end

    rescue BadInput
      puts "Try again."
      retry
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

class NotYoPieceError < StandardError
end

class MoveToCheckError < StandardError
end

class NoCastleError < StandardError
end

class PromotePawn < StandardError
end