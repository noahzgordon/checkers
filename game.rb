require_relative 'board'

class Game
  COLS = {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7
    }

    ROWS = {
      "1" => 7,
      "2" => 6,
      "3" => 5,
      "4" => 4,
      "5" => 3,
      "6" => 2,
      "7" => 1,
      "8" => 0
    }

  attr_reader :board

  def initialize
    @board = Board.new
    @turn = :light
  end

  def play

    until won?
      puts "#{@turn.to_s.capitalize}'s turn!\n"

      board.display

      start, moves = get_input

      board[start].perform_moves(moves)

      @turn == :light ? @turn = :dark : @turn = :light
    end

    puts "Game over! #{winner.to_s.capitalize} wins!"
  end

  def get_input
    puts "What piece would you like to move?"
    coords = gets.chomp.downcase
    piece_pos = [ROWS[coords[1]], COLS[coords[0]]]

    puts "Input a move or sequence of moves (separated by commas)."
    input = gets.chomp.downcase.gsub(' ', '').split(',')
    sequence = input.map { |pair| [ROWS[pair[1]], COLS[pair[0]]] }

    [piece_pos, sequence]
  end

  def won?
    winner == :light || winner == :dark
  end

  def winner
    :light if board.pieces.all? { |piece| piece.color == :light }
    :dark if board.pieces.all? { |piece| piece.color == :dark }
  end

end