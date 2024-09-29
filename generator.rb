class Generator
  TETROMINOS = [:O, :I, :S, :Z, :L, :J, :T]

  def random_tetromino
    TETROMINOS.sample
  end

  def initialize
    @current = random_tetromino
    @next = random_tetromino
  end

  attr_reader :current, :next

  def next!
    @curent = @next
    @next = random_tetromino
  end
    
end