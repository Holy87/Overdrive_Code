require File.expand_path('rm_vx_data')

module ControllerDebugger
end

class Window_PadDebugger
  attr_reader :width
  attr_reader :height
  attr_reader :viewport

  BLOCK_WIDTH = 25
  TRIGR_WIDTH = 100
  WHITE = Color.new(255, 255, 255)

  def initialize(width, height, viewport, controller_index = 0)
    @height = height
    @width = width
    @viewport = viewport
    @controller_index = controller_index
    create_background_sprite
    create_content_sprite
    init_variables
    set_bitmap_font
    refresh
  end

  def init_variables
    @lx = 0
    @ly = 0
    @rx = 0
    @ry = 0
    @lt = 0
    @rt = 0
    @keys = []
  end

  def create_background_sprite
    background_bitmap = Bitmap.new(width, height)
    black = Color.new(0, 0, 0)
    background_bitmap.fill_rect(0, 0, bitmap.width, bitmap.height, black)
    @background_sprite = Sprite.new(@viewport)
    @background_sprite.bitmap = bitmap
    @background_sprite.opacity = 128
    @background_sprite.visible = false
  end

  def create_content_sprite
    bitmap = Bitmap.new(width - padding*2, height - padding*2)
    @sprite = Sprite.new(viewport)
    @sprite.bitmap = bitmap
    @sprite.visible = false
  end

  def set_bitmap_font
    font = @sprite.bitmap.font
    font.color = WHITE
    font.size = 12
    font.name = ['Consolas', 'Lucida Console']
    font.outline = false
    font.shadow = false
    font.italic = false
    font.bold = false
    @line_height = @sprite.bitmap.text_size('A').height + 2
  end

  def draw_text(x, y, width, height, text, align = 0)
    @sprite.bitmap.draw_text(x, y, width, height, text, align)
  end

  def line_height; @line_height; end

  def line(line_index); line_height * line_index; end

  def draw_controller_name
    text = sprintf('Controller N°%d', @controller_index)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

  def draw_left_analog_state
    draw_square(0, line(1), @lx, @ly)
    contents.clear_rect(0, line(3), contents_width/2, line(2))
    draw_text(0, line(3), contents_width/2, line_height, sprintf('LX: %d', @lx))
    draw_text(0, line(4), contents_width/2, line_height, sprintf('LY: %d', @ly))
  end

  def draw_right_analog_state
    x = width = contents_width / 2
    draw_square(x, line(1), @rx, @ry)
    contents.clear_rect(x, line(3), width, line(2))
    draw_text(x, line(3), width, line_height, sprintf('RX: %d', @rx))
    draw_text(x, line(4), width, line_height, sprintf('RY: %d', @ry))
  end

  def draw_trigger(y, value, name)
    contents.clear_rect(0, y, contents_width, line_height)
    draw_text(0, y, 100, line_height, sprintf('%s: %d', name, value))
    width = value * (contents_width - 100)
    bitmap.fill_rect(100, y+1, width, line_height-2, WHITE)
  end

  def draw_square(x, y, vx, vy)

  end

  def padding; 2; end

  def contents; @sprite.bitmap; end
  
  def contents_opacity; @sprite.opacity; end

  def contents_opacity=(value); @sprite.opacity = value; end

  def background_opacity; @background_sprite.opacity; end
  
  def background_opacity=(value); @background_sprite.opacity = value; end

  def x; @background_sprite.x; end

  def y; @background_sprite.y; end

  def x=(value)
    @sprite.x = value + padding
    @background_sprite.x = value
  end

  def y=(value)
    @sprite.y = value + padding
    @background_sprite.y = value
  end

  def contents_width; @sprite.width; end

  def contents_height; @sprite.height; end

  def visible?; visible; end

  def visible=(value)
    @sprite.visible = value
    @background_sprite.visible = value
  end

  def update
  end

  def refresh
    @sprite.bitmap.clear
    draw_controller_name
    draw_left_analog_state
    draw_right_analog_state
    draw_triggers_state
    draw_key_state
  end
end