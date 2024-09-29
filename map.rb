WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
CENTER = WINDOW_WIDTH / 2
MAP_WIDTH = 300
MAP_HEIGHT = 450
PIXEL = 1

module ZOrder
  BACKGROUND, BLOCKS, PLAYER, UI = *0..3
end

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