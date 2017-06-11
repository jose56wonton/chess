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


=begin
KING
  def generate_moves
    valid_moves = [[@pos[0]+1,@pos[1]],[@pos[0],@pos[1]+1],[@pos[0]-1,@pos[1]],[@pos[0],@pos[1]-1],
  [@pos[0]+1,@pos[1]+1],[@pos[0]+1,@pos[1]-1],[@pos[0]-1,@pos[1]+1],[@pos[0]-1,@pos[1]-1]]
    valid_moves = generate_valid_moves(valid_moves)
  end


QUEEN
  def generate_moves
    valid_moves = []
    8.times do |i|
      valid_moves << [@pos[0]+i,@pos[1]]
      valid_moves << [@pos[0]-i,@pos[1]]
      valid_moves << [@pos[0],@pos[1]+i]
      valid_moves << [@pos[0],@pos[1]-i]
      valid_moves << [@pos[0]+i,@pos[1]+i]
      valid_moves << [@pos[0]-i,@pos[1]+i]
      valid_moves << [@pos[0]+i,@pos[1]-i]
      valid_moves << [@pos[0]-i,@pos[1]-i]
    end
    valid_moves = generate_valid_moves(valid_moves)
  end



BISHOP
def generate_moves
  valid_moves = []
  8.times do |i|
    valid_moves << [@pos[0]+i,@pos[1]+i]
    valid_moves << [@pos[0]-i,@pos[1]+i]
    valid_moves << [@pos[0]+i,@pos[1]-i]
    valid_moves << [@pos[0]-i,@pos[1]-i]
  end
  valid_moves = generate_valid_moves(valid_moves)
end


KNIGHT
def generate_moves
  valid_moves = []
  valid_moves << [@pos[0]+1,@pos[1]+2]
  valid_moves << [@pos[0]+2,@pos[1]+1]
  valid_moves << [@pos[0]-1,@pos[1]+2]
  valid_moves << [@pos[0]-2,@pos[1]+1]
  valid_moves << [@pos[0]+1,@pos[1]-2]
  valid_moves << [@pos[0]+2,@pos[1]-1]
  valid_moves << [@pos[0]-1,@pos[1]-2]
  valid_moves << [@pos[0]-2,@pos[1]-1]
  valid_moves = generate_valid_moves(valid_moves)
end

ROOK
def generate_moves
  valid_moves = []
  8.times do |i|
    valid_moves << [@pos[0]+i,@pos[1]]
    valid_moves << [@pos[0]-i,@pos[1]]
    valid_moves << [@pos[0],@pos[1]+i]
    valid_moves << [@pos[0],@pos[1]-i]
  end
  valid_moves = generate_valid_moves(valid_moves)
end

PAWN
def generate_moves
  valid_moves = []
  if (@color == "white")
    valid_moves << [@pos[0]-1,@pos[1]]
    valid_moves << [@pos[0]-2,@pos[1]] unless moved
  else
    valid_moves << [@pos[0]+1,@pos[1]]
    valid_moves << [@pos[0]+2,@pos[1]] unless moved
  end
  valid_moves = generate_valid_moves(valid_moves)
end


=end
