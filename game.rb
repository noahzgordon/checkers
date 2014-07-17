#!/usr/bin/env ruby
require_relative 'board'
require 'yaml'

# features to add:
# + other lose condition (losing player cannot move)
# + human/computer player support
# + draw conditions?

class InvalidInputError < RuntimeError
end

class GameSavedError < StandardError
end

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

  def initialize
    @board = Board.new
    @turn = :dark
  end

  def play

    until won?

      puts "#{@turn.to_s.capitalize}'s turn!\n"

      begin

        board.display

        start, moves = get_input

        board[start].perform_moves(moves, turn)

      rescue InvalidMoveError => e
        puts e.message
        retry
      rescue InvalidInputError
        puts "Invalid input! Try again."
        retry
      rescue GameSavedError
        puts "\nGame successfully saved!"
        retry
      end

      turn == :light ? self.turn = :dark : self.turn = :light
    end

    puts "Game over! #{winner.to_s.capitalize} wins!"
  end

  private

  attr_reader :board
  attr_accessor :turn

  def get_input
    puts "\nInput a piece's coordinate, or type SAVE if you want to save your game."
    input = gets.chomp.downcase

    if input == 'save'
      save
      raise GameSavedError
    end

    piece_pos = [ROWS[input[1]], COLS[input[0]]]

    puts "Input a move or sequence of moves (separated by commas)."
    input = gets.chomp.downcase.gsub(' ', '').split(',')
    sequence = input.map { |pair| [ROWS[pair[1]], COLS[pair[0]]] }

    (sequence + [piece_pos]).each do |pair|
      raise InvalidInputError unless pair.count == 2
      raise InvalidInputError unless COLS.values.include?(pair[0])
      raise InvalidInputError unless ROWS.values.include?(pair[1])
      raise InvalidMoveError, "No piece there!" if board[piece_pos].nil?
    end

    [piece_pos, sequence]
  end

  def won?
    winner == :light || winner == :dark
  end

  def winner
    :light if board.pieces.all? { |piece| piece.color == :light }
    :dark if board.pieces.all? { |piece| piece.color == :dark }
  end

  def save
    puts "What do you want to name your save file?"
    filename = gets.chomp
    File.write("./saves/#{filename}.yml", YAML.dump(self))
  end
end

if __FILE__ == $PROGRAM_NAME
  print "Would you like to LOAD a game or start a NEW one?:"
  choice = gets.chomp.downcase

  if choice == 'load'
    print "Type the name of the save file you want to load:"
    filename = gets.chomp
    puts "\nLoading...\n"
    YAML.load_file("./saves/#{filename}.yml").play
  elsif choice == 'new'
    puts "Creating your game!\n"
    Game.new.play
  else
    puts "Invalid command! Please run the program and try again."
  end
end