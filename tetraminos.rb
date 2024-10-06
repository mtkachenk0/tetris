class Tetraminos
  NAMES = ['O', 'I', 'S', 'Z', 'L', 'J', 'T']
  
  O = [
    [0,0,0,0],
    [0,0,0,0],
    [1,1,0,0],
    [1,1,0,0]
  ]

  I = [
    [1,0,0,0],
    [1,0,0,0],
    [1,0,0,0],
    [1,0,0,0]
  ]

  S = [
    [0,0,0,0],
    [0,0,0,0],
    [0,1,1,0],
    [1,1,0,0]
  ]

  Z = [
    [0,0,0,0],
    [0,0,0,0],
    [1,1,0,0],
    [0,1,1,0]
  ]

  L = [
    [0,0,0,0],
    [1,0,0,0],
    [1,0,0,0],
    [1,1,0,0]
  ]  

  J = [
    [0,0,0,0],
    [0,1,0,0],
    [0,1,0,0],
    [1,1,0,0]
  ]

  T = [
    [0,0,0,0],
    [0,0,0,0],
    [1,1,1,0],
    [0,1,0,0]
  ]


  def initialize(x, y, shape)
    @x = x
    @y = y
    @shape = shape # одна из фигур, например, Tetraminos::O
    @color = Gosu::Color::YELLOW # Установим цвет
  end

  def draw
    @shape.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell == 1
          Gosu.draw_rect(@x + j * SQUARE_WIDTH, @y + i * SQUARE_WIDTH, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
        end
      end
    end
  end

  def rotate!
    @shape = @shape.transpose.map(&:reverse)
  end
  
end