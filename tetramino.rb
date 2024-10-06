# Получаем какаую то букву - константу
# Класс обращаеться к тетраминус и берёт необходимую фигуру
# Присваевает эту фигур классу терамино
# Возвращает содержание константы

class Tetramino 
  include Tetraminos
  
  def initialize(tetramino_letter, x, y)
    letter = tetramino_letter.to_s.upcase
    unless Tetraminos::SHAPES.include?(letter)
      raise "Wrong tetramino: #{letter}"
    end
    @x = x
    @y = y
    @color = COLORS[letter]
   
    @shape = Tetraminos.const_get(letter)
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

  def bottom
    (@y + @shape.size * SQUARE_WIDTH) + 15
  end

  def left
    @x - 15

  end

  def right
    @x + @shape[0].size * SQUARE_WIDTH
  end

  def move_down
    @y += SQUARE_WIDTH
  end

  def move_left
    @x -= SQUARE_WIDTH
  end

  def move_right
    @x += SQUARE_WIDTH
  end
end

