require 'gosu'

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
CENTER = WINDOW_WIDTH / 2
MAP_WIDTH = 300
MAP_HEIGHT = 450
PIXEL = 1
SQUARE_WIDTH = 15  # Уменьшаем размер квадратов
BORDER_WIDTH = 5
X_BORDER_START = CENTER - MAP_WIDTH / 2
X_BORDER_END = CENTER + MAP_WIDTH / 2
BORDER_Y_END = ((WINDOW_HEIGHT - WINDOW_HEIGHT * 0.05) / 10.0).round * 10

module ZOrder
  BACKGROUND, BLOCKS, PLAYER, UI = *0..3
end

class Tetraminos
  SHAPES = {
    'O' => [
      [0,0,0,0],
      [0,0,0,0],
      [1,1,0,0],
      [1,1,0,0]
    ],
    'I' => [
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0],
      [0,0,0,0]
    ],
    'S' => [
      [0,0,0,0],
      [0,1,1,0],
      [1,1,0,0],
      [0,0,0,0]
    ],
    'Z' => [
      [0,0,0,0],
      [1,1,0,0],
      [0,1,1,0],
      [0,0,0,0]
    ],
    'L' => [
      [0,0,0,0],
      [1,0,0,0],
      [1,0,0,0],
      [1,1,0,0]
    ],
    'J' => [
      [0,0,0,0],
      [0,0,1,0],
      [0,0,1,0],
      [0,1,1,0]
    ],
    'T' => [
      [0,0,0,0],
      [0,1,1,1],
      [0,0,1,0],
      [0,0,0,0]
    ]
  }

  def initialize(x, y, shape)
    @x = x
    @y = y
    @shape = SHAPES[shape]
    @color = Gosu::Color::YELLOW
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
    @y + @shape.size * SQUARE_WIDTH
  end

  def left
    @x
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

class Tetris < Gosu::Window
  BLOCKS = Tetraminos::SHAPES.keys.freeze

  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = "TETRIS"
    @x_offset = 0
    @y = 0
    @block = new_block
    @blocks = [@block]
    @timer = 0
  end

  def update
    sleep 0.1
    @bottom = @block.bottom
    if @block.bottom <= BORDER_Y_END # Остановка у нижней границы
      @block.move_down
    else
      @block.freeze
      @block = new_block
      @blocks << @block
      @y = 0
      @x_offset = 0
    end

  #def update
  #  @timer += 0.5
  #  if @timer % 5 == 0 # Фигура падает каждые 5 кадров
  #    if @block.bottom < BORDER_Y_END # Остановка у нижней границы
  #      @block.move_down
  #    else
  #      @block = new_block # Новая фигура, когда текущая достигает дна
  #    end
  #    @timer = 0
  #  end

    # Управление перемещением
    if button_down?(Gosu::KbLeft) && (@block.left > X_BORDER_START)
      @block.move_left
    end
    if button_down?(Gosu::KbRight) && (@block.right < X_BORDER_END)
      @block.move_right
    end
    if button_down?(Gosu::KbDown)
      @block.move_down if @block.bottom < BORDER_Y_END
    end

    # Поворот
    if button_down?(Gosu::KbUp)
      @block.rotate!
    end
  end

  def draw
    draw_map
    @blocks.each do |block|
      block.draw
    end
  end

  def new_block
    shape = BLOCKS.sample
    Tetraminos.new(CENTER, 0, shape)
  end

  def draw_map
    y_start = 0
    Gosu.draw_rect(X_BORDER_START, y_start, BORDER_WIDTH, BORDER_Y_END, Gosu::Color::WHITE, ZOrder::BACKGROUND)
    Gosu.draw_rect(X_BORDER_END, y_start, BORDER_WIDTH, BORDER_Y_END, Gosu::Color::WHITE, ZOrder::BACKGROUND)
    Gosu.draw_rect(X_BORDER_START, BORDER_Y_END, MAP_WIDTH + BORDER_WIDTH, BORDER_WIDTH, Gosu::Color::WHITE, ZOrder::BACKGROUND)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close # Закрытие программы по кнопке "Escape"
    end
  end
end

Tetris.new.show
