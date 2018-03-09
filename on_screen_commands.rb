require 'rm_vx_data'


module SKC_Settings
  WIDTH = 100
end

#===============================================================================
# ** Sprite_KeyCommand
#===============================================================================
class Sprite_KeyCommand < Sprite
  # @attr[Bitmap] bitmap
  # @attr[String] text
  # @attr[String] key
  attr_accessor :bitmap
  attr_reader :key
  attr_reader :text
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Viewport] viewport
  #--------------------------------------------------------------------------
  def initialize(viewport, hidden)
    super
    @key = nil
    @text = ''
    self.opacity = hidden ? 0 : 255
    initialize_bitmap
    @hidden = hidden
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la bitmap
  #--------------------------------------------------------------------------
  def refresh
    self.bitmap.clear
    draw_bitmap_bg
    write_on_bitmap
  end
  #--------------------------------------------------------------------------
  # * Colore sfondo 1
  # @return [Color]
  #--------------------------------------------------------------------------
  def color1; Color.new(0, 0, 0, 200); end
  #--------------------------------------------------------------------------
  # * Colore sfondo 2
  # @return [Color]
  #--------------------------------------------------------------------------
  def color2; Color.new(0, 0, 0, 0); end
  #--------------------------------------------------------------------------
  # * Disegna lo sfondo della bitmap
  #--------------------------------------------------------------------------
  def draw_bitmap_bg
    self.bitmap.gradient_fill_rect(padding, padding, base_width,
                                   base_height, color1, color2)
    self.bitmap.blur
    self.bitmap.blur
  end
  #--------------------------------------------------------------------------
  # * Disegna sulla bitmap il comando
  #--------------------------------------------------------------------------
  def write_on_bitmap
    draw_key_icon(@key, padding, padding)
    x = padding + 24
    y = padding
    w = SKC_Settings::WIDTH
    h = base_height
    bitmap.draw_text(x, y, w, h, @text)
  end
  #--------------------------------------------------------------------------
  # * Inizializza la bitmap
  #--------------------------------------------------------------------------
  def initialize_bitmap
    width = calc_width
    height = calc_height
    self.bitmap = Bitmap.new(width, height)
    set_font_bitmap(bitmap)
  end
  #--------------------------------------------------------------------------
  # * Inizializza i parametri del font della bitmap
  # @param [Bitmap] bitmap
  #--------------------------------------------------------------------------
  def set_font_bitmap(bitmap)
    bitmap.font.bold = false
    bitmap.font.italic = false
    bitmap.font.color = Color::WHITE
  end
  #--------------------------------------------------------------------------
  # * Restituisce la dimensione del campo
  #--------------------------------------------------------------------------
  def base_width; 24 + SKC_Settings::WIDTH; end
  #--------------------------------------------------------------------------
  # * Restituisce la dimensione del campo
  #--------------------------------------------------------------------------
  def base_height; 24; end
  #--------------------------------------------------------------------------
  # * Restituisce la larghezza dello sprite (calcolata)
  #--------------------------------------------------------------------------
  def calc_width; padding * 2 + base_width; end
  #--------------------------------------------------------------------------
  # * Restituisce l'altezza dello sprite (calcolata)
  #--------------------------------------------------------------------------
  def calc_height; padding * 2 + base_height; end
  #--------------------------------------------------------------------------
  # * Restituisce la spaziatura dalla cornice (per sfumatura)
  #--------------------------------------------------------------------------
  def padding; 3; end
  #--------------------------------------------------------------------------
  # * Imposta comando e descrizione
  #--------------------------------------------------------------------------
  def set_key(key, text)
    return if key == self.key and text == self.text
    @key = key
    @text = text
    refresh
  end
  #--------------------------------------------------------------------------
  # * Draws the proper key icon
  # @param [Symbol] key
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def draw_key_icon(key, x, y, enabled = true)
    self.bitmap.draw_key_icon(key, x, y, enabled)
  end
  #--------------------------------------------------------------------------
  # * Mostra la figura
  #--------------------------------------------------------------------------
  def show; return unless @hidden; fade(255); end
  #--------------------------------------------------------------------------
  # * Nasconde la figura
  #--------------------------------------------------------------------------
  def hide; return if @hidden; fade(0); end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
end

#===============================================================================
# **
#===============================================================================
class Data_KeySprite
  # @attr[String] key
  # @attr[String] text
  attr_reader :key
  attr_reader :text
  attr_reader :visible
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [String] key
  # @param [String] text
  # @param [Boolean] visible
  #--------------------------------------------------------------------------
  def initialize(key, text, visible = false)
    @key = key
    @text = text
    @visible = visible
  end

  def hide
    @visible = true

  end

  def show

  end
end

