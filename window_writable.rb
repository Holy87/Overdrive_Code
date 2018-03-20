require 'rm_vx_data'
class Window_Writable < Window_base
  attr_accessor :scope
  attr_reader   :max_char
  attr_reader   :max_lines
  #--------------------------------------------------------------------------
  # * Inizializzazione della finestra standard
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @text = ''
    @max_char = nil
    @max_lines = nil
    @scope = :text
  end
  #--------------------------------------------------------------------------
  # * Restituisce il rettangolo usato per scrivere
  # @return [Rect]
  #--------------------------------------------------------------------------
  def writing_rect; Rect.new(0, 0, contents_width, contents_height); end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
end

class Writable_Cursor < Sprite
  def initialize(viewport, color)
    super(viewport)
    self.visible = false
    create_bitmap(color)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_bitmap(color)

  end
end