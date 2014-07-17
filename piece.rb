# encoding: utf-8

class Piece

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
    @king = false
  end

  def perform_slide(target)

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

  def forward_dir
    @color == :light ? -1 : 1
  end

  def backward_dir
    @color == :light ? 1 : -1
  end

end