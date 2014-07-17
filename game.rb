require_relative 'board'

class Game

  attr_reader :board

  def initialize
    @board = Board.new
    @turn = :light
  end

  def play

    until won?
      puts "#{@turn.to_s.capitalize}'s turn!\n"

      @board.display

      start, moves = get_input

    end

    puts "Game over!"
  end

  def get_input
    puts "What piece would you like to move?"
    piece = gets.chomp.to_i
  end

  def won?
    board.pieces.all? { |piece| piece.color == :light || piece.color == :dark }
  end

end