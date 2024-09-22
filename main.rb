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
  def initialize(...)
    @color = Colors::SQUARE
    super
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
  def initialize(...)
    @color = Colors::STICK
    super
  end

  def draw(x, y)
    @x, @y = x, y unless frozen?

    Gosu.draw_rect(CENTER + @x, @y, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, @y + SQUARE_WIDTH, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, @y + SQUARE_WIDTH * 2, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    Gosu.draw_rect(CENTER + @x, @y + SQUARE_WIDTH * 3, SQUARE_WIDTH - PIXEL, SQUARE_WIDTH - PIXEL, @color, ZOrder::BLOCKS)
    @bottom = @y + SQUARE_WIDTH * 3 unless frozen?
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
end

class Tetris < Gosu::Window
  BLOCKS = [Square, Stick].freeze

  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = "TETRIS BLYATI"
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
      puts "Left button has pressed"
    end
    if button_down?(Gosu::KbRight) && (CENTER + SQUARE_WIDTH * 3 + @x_offset <= X_BORDER_END)
      @x_offset += 10
      puts "Right button has pressed"
    end
  end

  def draw
    puts 'hui'
    draw_map
    @blocks.each do |block|
      block.draw(@x_offset, @y)
    end
  end

  def new_block
    block_class =  BLOCKS.sample
    @block = block_class.new(0, 0)
    @block
  end

  def draw_map
    # .draw_rect(x, y, width, height, c, z = 0, mode = :default
    y_start = 0
    Gosu.draw_rect(X_BORDER_START, y_start, BORDER_WIDTH, BORDER_Y_END, Gosu::Color::WHITE, ZOrder::BACKGROUND)
    Gosu.draw_rect(X_BORDER_END, y_start, BORDER_WIDTH, BORDER_Y_END, Gosu::Color::WHITE, ZOrder::BACKGROUND)
    Gosu.draw_rect(X_BORDER_START, BORDER_Y_END, MAP_WIDTH + BORDER_WIDTH, BORDER_WIDTH, Gosu::Color::WHITE, ZOrder::BACKGROUND)
  end
end

Tetris.new.show
