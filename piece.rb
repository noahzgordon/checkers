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

  def perform_moves(move_sequence, piece_color)
    if piece_color != color
      raise InvalidMoveError, "You can only move your own pieces!"
    end

    if valid_move_seq?(move_sequence)
      self.perform_moves!(move_sequence)
    else
      raise InvalidMoveError, "Not a valid move!"
    end
  end

  def perform_moves!(move_sequence)
    # too many nested if/else loops. Consider refactoring.
    move_sequence.each_with_index do |move|

      if move_sequence.count == 1

        if valid_slides.include? move
          perform_slide(move)
        elsif valid_jumps.include? move
          perform_jump(move)
          raise InvalidMoveError if jump_available?(self)
        else
          raise InvalidMoveError
        end

      elsif move_sequence.count > 1
        # to check if the move promoted the piece to a king
        perform_jump(move)

        # ensures that jump chains cannot be ended early (unless just promoted)
        if move == move_sequence.last && jump_available?(self)
          raise InvalidMoveError
        end
      end
    end
  end

  def valid_move_seq?(move_sequence)
    duped_board = board.dup
    duped_piece = duped_board[position]

    begin
      duped_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError
      return false
    end

    true
  end

  def perform_slide(target)
    raise InvalidMoveError, "Can't slide onto piece" unless @board[target].nil?
    raise InvalidMoveError, "Not valid slide" unless valid_slides.include? target
    raise InvalidMoveError, "Jump available elsewhere" if jump_available?

    board[position] = nil
    board[target] = self
    self.position = target
  end

  def perform_jump(target)
    raise InvalidMoveError, "Can't jump onto piece" unless @board[target].nil?
    raise InvalidMoveError, "Not valid jump" unless valid_jumps.include? target

    # there must be a way to write this better... REFACTOR!
    x_dir = (target[0] - position[0]) / 2
    y_dir = (target[1] - position[1]) / 2

    jumped_pos = [position[0] + x_dir, position[1] + y_dir]
    jumped = board[jumped_pos]
    raise InvalidMoveError, "Invalid jump" if jumped.nil? || jumped.color == color

    board[position] = nil
    board[target] = self
    self.position = target
    # jumped piece gets captured
    board[jumped_pos] = nil

    board.captured_counts[jumped.color] += 1
  end

  def jump_available?(piece = nil)
    # you would pass this message a single piece when checking mid-sequence if
    # it has to keep making jumps.
    if piece.nil?
      pieces = board.pieces.select { |piece| piece.color == color }
    else
      pieces = [piece]
    end

    pieces.any? do |piece|
      piece.valid_jumps.any? do |jump|
        piece.valid_move_seq?([jump])
      end
    end
  end

  def eligible_for_promotion?
    return false if is_king?

    kings_row = color == :light ? 0 : 7

    position[0] == kings_row
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

    moves.reject do |move|
      move[0] < 0 || move[0] > 7 || move[1] < 0 || move[1] > 7
    end
  end

  def valid_jumps
    # same as valid_slides, but everything is multiplied by 2. Refactor?
    moves = []
    move_diffs.each do |(dx, dy)|
      moves << [@position[0] + (dx * 2), @position[1] + (dy * 2)]
    end

    moves.reject do |move|
      move[0] < 0 || move[0] > 7 || move[1] < 0 || move[1] > 7
    end
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
      is_king? ? '♔' : '◎'
    else
      is_king? ? '♚' : '◉'
    end
  end


end