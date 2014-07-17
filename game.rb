require_relative 'board'

class Game

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play

    until won?

    end
  end

  def won?
    board.pieces.all? { |piece| piece.color == :light || piece.color == :dark }
  end

end