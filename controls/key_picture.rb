require 'rm_vx_data' if false
=begin
 ==============================================================================
  ■ Serve per mostrare picture a schermo con indicazione sui comandi
  Istruzioni:
  Inserire in un call script dopo aver mostrato una figura
  bitmap_picture(NumPicture, '<key_pic: Tasto, Testo>')
  Esempio
  bitmap_picture(1, '<key_pic: X, Riprova>')

  oppure
  tip_pic(id, comando, testo)
  esempio:
  tip_pic(1, :X, 'Riprova')
 ==============================================================================
=end

#===============================================================================
# ** Impostazioni
#===============================================================================
module KP_Settings
  WIDTH = 100
  PADDING = 3
end

#===============================================================================
# ** Cache
#===============================================================================
module Cache
  # noinspection RubyResolve
  class << self
    alias picture_cc picture
  end
  #--------------------------------------------------------------------------
  # * Se contiene una hotstring <key_pic: key, text) genera la bitmap,
  #   altrimenti carica il file come di norma
  # @param [String] filename
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def self.picture(filename)
    if filename =~ /<key_pic:[ ]*(.+),[ ]*(.+)>/i
      generate_key_picture($1, $2)
    else
      picture_cc(filename)
    end
  end
  #--------------------------------------------------------------------------
  # * Genera la bitmap
  # @param [String] key
  # @param [String] text
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def self.generate_key_picture(key, text, width = KP_Settings::WIDTH)
    Key_Bitmap_Generator.new(key.to_sym, text, width).bitmap
  end
end

#===============================================================================
# ** Game_Interpreter
#===============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Imposta la picture della bitmap
  # @param [Integer] pic_id
  # @param [String] filename
  #--------------------------------------------------------------------------
  def bitmap_picture(pic_id, filename)
    screen.pictures[pic_id].name = filename
  end
  #--------------------------------------------------------------------------
  # * Imposta la picture della bitmap
  # @param [Integer] id
  # @param [Symbol] key
  # @param [String] text
  #--------------------------------------------------------------------------
  def tip_pic(id, key, text)
    string = sprintf('<key_pic: %s, %s>', key, text)
    bitmap_picture(id, string)
  end
end

#===============================================================================
# ** Sprite_KeyCommand
#===============================================================================
class Key_Bitmap_Generator
  # @attr[Bitmap] bitmap
  # @attr[String] text
  # @attr[Symbol] key
  attr_accessor :bitmap
  attr_reader :key
  attr_reader :text
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [String] key
  # @param [String] text
  #--------------------------------------------------------------------------
  def initialize(key, text, width = KP_Settings::WIDTH)
    @key = key
    @text = text
    @bitmap = nil
    @width = width
    initialize_bitmap
    refresh
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
    x = padding + 26
    y = padding
    w = @width
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
  def base_width; 26 + @width; end
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
  def padding; KP_Settings::PADDING; end
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
end

#===============================================================================
# ** Game_Picture
#===============================================================================
class Game_Picture
  # aggiungo l'accesso in scrittura di name
  attr_accessor :name
end