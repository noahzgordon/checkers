# encoding: utf-8

class Piece

  attr_accessor :board, :position
  attr_reader :color

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
    @king = false
  end

  def perform_slide(target)
    raise InvalidMoveError unless @board[target].nil?
    raise InvalidMoveError unless valid_slides.include? target

    board[position] = nil
    board[target] = self
    self.position = target
  end

  def perform_jump(target)

  end

  def eligible_for_promotion?
    # not a king, in the right row for the right color
  end

  def promote

  end

  def is_king?
    @king
  end

  def valid_slides
    move_diffs.each_with_object do |(dx, dy), []|
      [] << [@position[0] + dx, @position[1] + dy]
    end
  end

  def move_diffs
    diffs = [[forward_dir, -1], [forward_dir, 1]]
    diffs += [[backward_dir, -1], [backward_dir, 1]] if is_king?
  end

  def forward_dir
    @color == :light ? -1 : 1
  end

  def backward_dir
    @color == :light ? 1 : -1
  end

end