require_relative 'piece'
require 'colorize'

class Board

  attr_reader :grid
  attr_accessor :captured_counts

  def initialize(grid = nil)
    @grid = grid.nil? ? generate_grid : grid
    @captured_counts = { :light => 0, :dark => 0 }
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def []=(pos, object)
    grid[pos[0]][pos[1]] = object
  end

  def display
    puts "   A  B  C  D  E  F  G  H"

    grid.each_with_index do |row, x|
    print "#{8 - x} "
    row.each_with_index do |piece, y|
          if piece.nil?
            print col_square("   ", x, y)
          else
            print col_square(" #{piece.render} ", x, y)
          end
        end

        if x == 0 && captured_counts[:dark] > 0
          print "   #{captured_counts[:dark]} dark piece(s) captured."
        elsif x == 7 && captured_counts[:light] > 0
          print "   #{captured_counts[:light]} light piece(s) captured."
        end

      print "\n"
    end
    nil
  end

  def dup
    new_grid = grid.map do |row|
      row.map do |piece|
        piece.nil? ? nil : piece.dup
      end
    end

    duped_board = Board.new(new_grid)

    duped_board.pieces.each do |piece|
      piece.board = duped_board
    end

    duped_board
  end

  def pieces
    self.grid.flatten.compact
  end

  private

  def generate_grid
    piece_rows = [0, 1, 2, 5, 6, 7]

    new_grid = Array.new(8) { Array.new(8) { nil } }

    new_grid.each_index do |x|
      new_grid.each_index do |y|
        if x.even? == y.odd?
          new_grid[x][y] = Piece.new([x, y], :dark, self) if x <= 2
          new_grid[x][y] = Piece.new([x, y], :light, self) if x >= 5
        end
      end
    end

    new_grid
  end

  def col_square(str, x, y)
    color = x.even? == y.odd? ? :cyan : :light_cyan
    str.colorize(:background => color)
  end
end