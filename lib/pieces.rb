class Piece
  attr_accessor :pos, :color
  def initialize(color)
    @color = color
  end
end

class King < Piece
  attr_accessor
  def initialize (color)
    super(color)
  end
end
class Queen < Piece
  attr_accessor :moves
  def initialize (color)
    super(color)
  end
end
class Bishop < Piece
  attr_accessor :moves
  def initialize (color)
    super(color)
  end
end
class Knight < Piece
  attr_accessor :moves
  def initialize (color)
    super(color)
  end
end
class Rook < Piece
  attr_accessor :moves
  def initialize (color)
    super(color)
  end
end
class Pawn < Piece
  attr_accessor :moves, :moved
  def initialize (color, moved = false)
    super(color)
    @moved = moved
  end
end

