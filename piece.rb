# encoding: utf-8
class InvalidMoveError < RuntimeError
end

class Piece

  attr_accessor :board, :position
  attr_reader :color

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
    @king = false
  end

  def inspect
    king_status = is_king? ? "King" : "Non-king"
    "#{king_status} #{color} piece at #{position}"
  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError, "Not a valid sequence of moves!"
    end
  end

  def perform_moves!(move_sequence)
    # can you put a question mark on a local variable?
    only_jumps = move_sequence.count != 1

    # too many nested if/else loops. Consider refactoring.
    valid_sequence = true
    move_sequence.each do |move|
      if only_jumps
        perform_jump(move)
      else
        if valid_slides.include? move
          perform_slide(move)
        elsif valid_jumps.include? move
          perform_jump(move)
        else
          raise InvalidMoveError, "Not a valid slide or jump!"
        end
      end
    end
  end

  def valid_move_seq?(move_sequence)
    duped_board = board.dup
    duped_piece = duped_board[position]

    begin
      duped_piece.perform_moves!
    rescue InvalidMoveError
      return false
    end

    true
  end

  def perform_slide(target)
    raise InvalidMoveError, "Can't slide onto piece" unless @board[target].nil?
    raise InvalidMoveError, "Not valid slide" unless valid_slides.include? target

    board[position] = nil
    board[target] = self
    self.position = target

    promote if eligible_for_promotion?
  end

  def perform_jump(target)
    raise InvalidMoveError, "Can't jump onto piece" unless @board[target].nil?
    raise InvalidMoveError, "Not valid jump" unless valid_jumps.include? target

    # there must be a way to write this better... REFACTOR!
    x_dir = (target[0] - position[0]) / 2
    y_dir = (target[1] - position[1]) / 2

    jumped_pos = [position[0] + x_dir, position[1] + y_dir]
    raise InvalidMoveError, "No jumped piece." if board[jumped_pos].nil?

    board[position] = nil
    board[target] = self
    self.position = target
    # jumped piece gets captured
    board[jumped_pos] = nil

    promote if eligible_for_promotion?
  end

  def eligible_for_promotion?
    return false if is_king?

    kingshead = color == :light ? 0 : 7

    position[0] == kingshead
  end

  def promote
    @king = true
  end

  def is_king?
    @king
  end

  def valid_slides
    moves = []
    move_diffs.each do |(dx, dy)|
      moves << [@position[0] + dx, @position[1] + dy]
    end

    moves
  end

  def valid_jumps
    # same as valid_slides, but everything is multiplied by 2. Refactor?
    moves = []
    move_diffs.each do |(dx, dy)|
      moves << [@position[0] + (dx * 2), @position[1] + (dy * 2)]
    end

    moves
  end

  def move_diffs
    diffs = [[forward_dir, -1], [forward_dir, 1]]
    diffs += [[backward_dir, -1], [backward_dir, 1]] if is_king?

    diffs
  end

  def forward_dir
    color == :light ? -1 : 1
  end

  def backward_dir
    color == :light ? 1 : -1
  end

  def render
    if color == :light
      is_king? ? '▵' : '◎'
    else
      is_king? ? '▲' : '◉'
    end
  end
end