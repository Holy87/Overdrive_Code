require 'rm_vx_data'
# sperimentale
class Window_Writable < Window_base
  attr_accessor :scope      #tipologia :text, :password, :code, :numbers
  attr_reader   :max_char   #numero di caratteri massimi
  attr_reader   :max_lines  #numero di righe massime
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
    @cursor_pos = 0
    @cursor = Writable_Cursor.new(@viewport, normal_color, line_height)
    @cursor.x = writing_rect.x
    @cursor.y = writing_rect.y

  end
  #--------------------------------------------------------------------------
  # * Restituisce il rettangolo usato per scrivere
  # @return [Rect]
  #--------------------------------------------------------------------------
  def writing_rect; Rect.new(0, 0, contents_width, contents_height); end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def backspace
    if cursor_can_go_back?
      @text[@cursor_pos] = ''
      @cursor_pos -= 1
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def canc
    if cursor_can_go_forward?
      @text[@cursor_pos + 1] = ''
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def cursor_can_go_back?
    @cursor_pos > 0
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def cursor_can_go_forward?
    @cursor_pos < @text.size - 1
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def cursor_left
    if cursor_can_go_back?
      @cursor_pos -= 1

    end
  end
end

class Writable_Cursor < Sprite
  attr_accessor :active
  attr_accessor :timing
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize(viewport, color, line_height)
    super(viewport)
    self.visible = false
    @active = false
    @timing = 30
    create_bitmap(color, line_height)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_bitmap(color, line_height)
    bitmap = Bitmap.new(1, line_height)
    bitmap.fill_rect(0,0,1,line_height, color)
    self.bitmap = bitmap
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def switch_visibility; self.visible = !self.visible; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def update
    super
    @active ? update_blink : self.visible = false
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def update_blink
    switch_visibility if Graphics.frame_count % @timing == 0
  end
end

class Char_Point
  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    @x = x
    @y = y
    @width = width
  end
end

class Words_Container
  attr_accessor :color
  attr_reader :x
  attr_reader :y
  attr_reader :width
  attr_reader :height
  attr_reader :viewport
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height = 24, line_height = 24, color = Color::WHITE, viewport = nil)
    @text = ''
    @pics = []
    @viewport = viewport
    @x = x
    @y = y
    @color = color
    @bitmaps = {}
    @width = width
    @height = height
    @cursor = Writable_Cursor.new(viewport, color, line_height)
    @cursor.x = x
    @cursor.y = y
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def add_char(char, position = @text.size)

  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def delete_char(position)

  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def recalc_cursor_pos

  end
end