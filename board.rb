require_relative 'piece'
require 'colorize'

class Board

  attr_reader :grid

  def initialize
    @grid = generate_grid
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def []=(pos, object)
    grid[pos[0]][pos[1]] = object
  end

  def display
    grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        if piece.nil?
          print col_square('   ', x, y)
        else
          print col_square(" #{piece.render} ", x, y)
        end
      end
      print "\n"
    end

    nil
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