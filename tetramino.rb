# Получаем какаую то букву - константу
# Класс обращаеться к тетраминус и берёт необходимую фигуру
# Присваевает эту фигур классу терамино
# Возвращает содержание константы

class Tetramino 
  
  def initialize(tetramino_letter)
    # tetramino_letter = 'o', :s, 'O', 'hui'
    letter = tetramino_letter.to_s.upcase
    unless Tetraminos::NAMES.include?(letter)
      raise "Wrong tetramino: #{letter}"
    end
    @tetramino = Tetraminos.const_get(letter)
  end
end

