require "gosu"

PIXEL = 1
SQUARE_WIDTH = 10
BORDER_WIDTH = 5
X_BORDER_START = CENTER - MAP_WIDTH / 2
X_BORDER_END = CENTER + MAP_WIDTH / 2
BORDER_Y_END = ((WINDOW_HEIGHT - WINDOW_HEIGHT * 0.05) / 10.0).round * 10

module Colors
    SQUARE = Gosu::Color::YELLOW
    STICK = Gosu::Color::AQUA
    L_STICK = Gosu::Color.rgba(255, 165, 0, 255) # Оранжевый цвет
    J_STICK = Gosu::Color::FUCHSIA
    S_FIGURE = Gosu::Color::RED
  end