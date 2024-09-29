require 'gosu'
require 'pry'

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
CENTER = WINDOW_WIDTH / 2
MAP_WIDTH = 300
MAP_HEIGHT = 450
PIXEL = 1
SQUARE_WIDTH = 10
BORDER_WIDTH = 5
X_BORDER_START = CENTER - MAP_WIDTH / 2
X_BORDER_END = CENTER + MAP_WIDTH / 2
BORDER_Y_END = ((WINDOW_HEIGHT - WINDOW_HEIGHT * 0.05) / 10.0).round * 10



module ZOrder
  BACKGROUND, BLOCKS, PLAYER, UI = *0..3
end

module Colors
  SQUARE = Gosu::Color::YELLOW
  STICK = Gosu::Color::AQUA
  L_STICK = Gosu::Color.rgba(255, 165, 0, 255) # Оранжевый цвет
  J_STICK = Gosu::Color::FUCHSIA
  S_FIGURE = Gosu::Color::RED
end

class Block
  attr_reader :x, :y, :bottom

  def initialize(x, y = 0)
    @x = x
    @y = y
    @bottom = y
    @frozen = false
  end

  def freeze!
    @frozen = true
  end

  def frozen?
    @frozen
  end
end

class Square < Block
  def initialize(x, y = 0)
    @color = Colors::SQUARE
    super(x, y)
  end

  def draw(x, y)
    @x, @y = x, y unless frozen?

    Gosu.draw_rect(CENTER - SQUARE_WIDTH + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER - SQUARE_WIDTH + @x, @y + SQUARE_WIDTH, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, SQUARE_WIDTH + @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    @bottom = @y + SQUARE_WIDTH unless frozen?
  end
end

class Stick < Block
  def initialize(x, y = 0)
    @color = Colors::STICK
    super(x, y)
  end

  def draw(x, y)
    @x, @y = x, y unless frozen?

    4.times do |i|
      Gosu.draw_rect(CENTER + @x, @y + SQUARE_WIDTH * i, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    end
    @bottom = @y + SQUARE_WIDTH * 3 unless frozen?
  end
end

class LStick < Block
  def initialize(x, y = 0)
    @color = Colors::L_STICK
    super(x, y)
  end

  def draw(x, y)
    @x, @y = x, y unless frozen?

    Gosu.draw_rect(CENTER - SQUARE_WIDTH + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, @y + SQUARE_WIDTH, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, @y + SQUARE_WIDTH * 2, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    @bottom = @y + SQUARE_WIDTH * 2 unless frozen?
  end
end

class JStick < Block
  def initialize(x, y = 0)
    @color = Colors::J_STICK
    super(x, y)
  end

  def draw(x, y)
    @x, @y = x, y unless frozen?

    # J-образная фигура
    Gosu.draw_rect(CENTER + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)                 # Верхняя часть палки
    Gosu.draw_rect(CENTER + @x, @y + SQUARE_WIDTH, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)   # Средняя часть палки
    Gosu.draw_rect(CENTER + @x, @y + SQUARE_WIDTH * 2, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS) # Нижняя часть палки
    Gosu.draw_rect(CENTER - SQUARE_WIDTH + @x, @y + SQUARE_WIDTH * 2, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS) # Блок слева от нижней части
    @bottom = @y + SQUARE_WIDTH * 2 unless frozen?
  end
end

class S_Figure < Block
  def initialize(x, y = 0)
    @color = Colors::S_FIGURE
    super(x, y)
  end

  def draw(x, y)
    @x, @y = x, y unless frozen?

    Gosu.draw_rect(CENTER - SQUARE_WIDTH + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER - SQUARE_WIDTH*2 + @x, @y + SQUARE_WIDTH, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER - SQUARE_WIDTH + @x, @y+ SQUARE_WIDTH, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    @bottom = @y + SQUARE_WIDTH unless frozen?
  end
end




  # it draws L-shaped block
  # def draw(x, y)
  #   @x, @y = x, y unless frozen?
  #
  #   Gosu.draw_rect(CENTER - SQUARE_WIDTH + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
  #   Gosu.draw_rect(CENTER + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
  #   Gosu.draw_rect(CENTER + @x, SQUARE_WIDTH + @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
  #   Gosu.draw_rect(CENTER + @x, SQUARE_WIDTH * 2 + @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
  #   @bottom = @y + SQUARE_WIDTH * 3 unless frozen?
  # end

  class Tetris < Gosu::Window
    BLOCKS = [Square, Stick, LStick, JStick,S_Figure].freeze
  
    def initialize
      super WINDOW_WIDTH, WINDOW_HEIGHT
      self.caption = "TETRIS"
      @x_offset = 0
      @y = 0
      @bottom = 0
      @blocks = [@block = new_block]
    end
  
    def update
      sleep 0.1
      @bottom = @block.bottom
      if @bottom <= BORDER_Y_END - SQUARE_WIDTH * 2
        @y += SQUARE_WIDTH
      else
        @block.freeze!
        @block = new_block
        @blocks << @block
        @y = 0
        @x_offset = 0
      end
  
      if button_down?(Gosu::KbLeft) && (CENTER - SQUARE_WIDTH * 3 + @x_offset >= X_BORDER_START)
        @x_offset -= 10
      end
      if button_down?(Gosu::KbRight) && (CENTER + SQUARE_WIDTH * 3 + @x_offset <= X_BORDER_END)
        @x_offset += 10
      end
    end
  
    def draw
      draw_map
      @blocks.each do |block|
        block.draw(@x_offset, @y)
      end
    end
  
    def new_block
      block_class = BLOCKS.sample
      block_class.new(0, 0)
    end
  
    def draw_map
      y_start = 0
      Gosu.draw_rect(X_BORDER_START, y_start, BORDER_WIDTH, BORDER_Y_END, Gosu::Color::WHITE, ZOrder::BACKGROUND)
      Gosu.draw_rect(X_BORDER_END, y_start, BORDER_WIDTH, BORDER_Y_END, Gosu::Color::WHITE, ZOrder::BACKGROUND)
      Gosu.draw_rect(X_BORDER_START, BORDER_Y_END, MAP_WIDTH + BORDER_WIDTH, BORDER_WIDTH, Gosu::Color::WHITE, ZOrder::BACKGROUND)
    end
  end
  
  Tetris.new.show