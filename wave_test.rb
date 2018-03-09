require 'rm_vx_data'

class Wave_Test_Scene < Scene_Base
  def start
    super
    @plane = Plane.new
    @plane.bitmap = Cache.picture('WorldMap')
    @image = Sprite.new
    @image.bitmap = Cache.picture('Oceano')
    @info_window = Window_WaveInfo.new(@image)
    @plane.z = 1
    @image.z = 100
  end

  def update
    super
    @image.update
    @image.wave_amp += 1 if Input.repeat?(:RIGHT)
    @image.wave_amp -= 1 if Input.repeat?(:LEFT)
    @image.wave_length += 1 if Input.repeat?(:UP)
    @image.wave_length -= 1 if Input.repeat?(:DOWN)
    @image.wave_phase += 1 if Input.repeat?(:R)
    @image.wave_phase -= 1 if Input.repeat?(:L)
    @image.wave_speed += 1 if Input.repeat?(:Y)
    @image.wave_speed -= 1 if Input.repeat?(:X)
    @info_window.soft_refresh
  end

end

class Window_WaveInfo < Window_Base
  # @param [Sprite] picture
  def initialize(picture)
    @picture = picture
    super(0, 0, 200, fitting_height(4))
    refresh
  end

  def refresh
    contents.clear
    draw_key_icon(:LEFT,0,0)
    draw_key_icon(:RIGHT, 24, 0)
    draw_key_icon(:UP, 0, line_height)
    draw_key_icon(:DOWN, 24, line_height)
    draw_key_icon(:L, 0, line_height * 2)
    draw_key_icon(:R, 24, line_height * 2)
    draw_key_icon(:X, 0, line_height * 3)
    draw_key_icon(:Y, 24, line_height * 3)
    draw_text(line_rect(0), 'AMP')
    draw_text(line_rect(1), 'LENGTH')
    draw_text(line_rect(2), 'PHASE')
    draw_text(line_rect(3), 'SPEED')
    soft_refresh
  end

  def soft_refresh
    redraw_amp
    redraw_lenght
    redraw_phase
    redraw_speed
  end

  def redraw_amp
    clear_line(0)
    draw_text(number_rect(0), @picture.wave_amp)
  end

  def redraw_lenght
    clear_line(1)
    draw_text(number_rect(1), @picture.wave_length)
  end

  def redraw_phase
    clear_line(2)
    draw_text(number_rect(2), @picture.wave_phase)
  end

  def redraw_speed
    clear_line(3)
    draw_text(number_rect(3), @picture.wave_speed)
  end

  def clear_line(line)
    contents.clear_rect(number_rect(line))
  end

  def line_rect(line)
    Rect.new(48, line * line_height, contents_width - 48, line_height)
  end

  def number_rect(line)
    width = text_size('000').width
    x = contents_width - width
    Rect.new(x, line * line_height, width, line_height)
  end
end