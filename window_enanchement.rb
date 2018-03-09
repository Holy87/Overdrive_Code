require File.expand_path('rm_vx_data')

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
# Aggiunta di metodi utili per uno sviluppo più facile
#==============================================================================
class Window_Base < Window
  ARROW_RECTS = {
      :left   => Rect.new(80, 20, 8, 24),
      :right  => Rect.new(104, 20, 8, 24),
      :up     => Rect.new(89, 8, 14, 24),
      :down   => Rect.new(89, 32, 14, 24)
  }
  #--------------------------------------------------------------------------
  # * Centra la finestra nel campo
  #--------------------------------------------------------------------------
  def center_window
    self.x = (Graphics.width - self.width)/2
    self.y = (Graphics.height - self.height)/2
  end
  #--------------------------------------------------------------------------
  # * Restituisce la coordinata della parte destra della finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def right_corner; self.x + self.width; end
  #--------------------------------------------------------------------------
  # * Restituisce la coordinata della parte sinistra della finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def bottom_corner; self.y + self.height; end
  #--------------------------------------------------------------------------
  # * Abbreviazioni per bottom_corner e right_corner
  # @return [Integer]
  #--------------------------------------------------------------------------
  def rx; right_corner; end
  def by; bottom_corner;end
  #--------------------------------------------------------------------------
  # * Disegna una linea per sottolineare il testo (per la sezione)
  # @param [Integer] line     linea
  # @param [Integer] width    larghezza (tutta la larghezza se omesso)
  # @param [Color] color      colore (predefinito, quello del testo)
  #--------------------------------------------------------------------------
  def draw_underline(line, width = contents_width, color = normal_color)
    color.alpha = 128
    contents.fill_rect(0,line_height*(line+1)-1,width,1,color)
  end
  #--------------------------------------------------------------------------
  # * disegna una miniatura del personaggio
  # @param [Game_Actor] actor
  # @param [Fixnum] x
  # @param [Fixnum] y
  #--------------------------------------------------------------------------
  def draw_actor_little_face(actor, x, y)
    bitmap = Cache.character(actor.character_name)
    bx = actor.character_index % 4# + (bitmap.width / 12)
    by = actor.character_index / 4 * (bitmap.height / 2) + 2
    rect = Rect.new(bx, by, 32, line_height)
    contents.blt(x, y, bitmap, rect)
  end
  #--------------------------------------------------------------------------
  # * Restituisce il massimo numero di righe nella finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def max_lines; (contents.width / line_height) - 1; end
  #--------------------------------------------------------------------------
  # * Colore di sfondo 1
  # @return [Color]
  #--------------------------------------------------------------------------
  def sc1
    color = gauge_back_color
    color.alpha = 75
    color
  end
  #--------------------------------------------------------------------------
  # * Colore di sfondo 2
  # @return [Color]
  #--------------------------------------------------------------------------
  def sc2
    color = gauge_back_color
    color.alpha = 150
    color
  end
  #--------------------------------------------------------------------------
  # * Disegna la barra di sfondo al parametro
  # @param [Integer] x          coordinata X
  # @param [Integer] y          coordinata Y
  # @param [Integer] width      larghezza
  # @param [Integer] height     altezza (predefinito testo)
  # @param [Color] color        colore (predefinito scuro)
  #--------------------------------------------------------------------------
  def draw_bg_rect(x, y, width = contents_width, height = line_height, color = sc1)
    contents.fill_rect(x+1, y+1, width-2, height-2, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna la barra di sfondo al parametro con bordi smussati
  # @param [Integer] x          coordinata X
  # @param [Integer] y          coordinata Y
  # @param [Integer] width      larghezza
  # @param [Integer] height     altezza (predefinito testo)
  # @param [Color] color        colore (predefinito scuro)
  #--------------------------------------------------------------------------
  def draw_bg_srect(x, y, width = contents_width, height = line_height, color = sc1)
    contents.fill_rect(x+1, y+1, width-2, height-2, color)
    contents.clear_rect(x+1, y+1, 1, 1)
    contents.clear_rect(x+1, height-2, 1, 1)
    contents.clear_rect(width-2,y+1, 1, 1)
    contents.clear_rect(width-2, height-2, 1, 1)
  end
  #-----------------------------------------------------------------------------
  # * Restituisce le coordinate di una determinata riga della finestra
  # @param [Integer] line
  # @return [Rect]
  #-----------------------------------------------------------------------------
  def get_line_coord(line = 0)
    x = self.x + self.padding
    y = self.y + self.padding + line_height * line
    Rect.new(x, y, contents_width, line_height)
  end
  #--------------------------------------------------------------------------
  # * Disegna una barra generica
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Integer] value
  # @param [Integer] max
  # @param [Color] c1
  # @param [Color] c2
  #--------------------------------------------------------------------------
  def draw_gauge_b(x, y, width, height, value, max,
                 c1 = hp_gauge_color1, c2 = hp_gauge_color2)
    y += line_height - height
    contents.fill_rect(x, y, width, height, gauge_back_color)
    rate = value.to_f/max.to_f
    gw = (rate * width).to_i
    contents.gradient_fill_rect(x,y,gw,height,c1, c2)
  end
  #--------------------------------------------------------------------------
  # * Disegna una barra generica con minimo diverso da 0 (per exp)
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Integer] value
  # @param [Integer] max
  # @param [Integer] min
  # @param [Color] c1
  # @param [Color] c2
  #--------------------------------------------------------------------------
  def draw_gauge_a(x, y, width, height, value, min, max,
                   c1 = hp_gauge_color1, c2 = hp_gauge_color2)
    draw_gauge_b(x, y, width, height, value - min, max - min, c1, c2)
  end
  #--------------------------------------------------------------------------
  # * Imposta l'eroe della finestra
  # @param [Game_Actor] new_actor
  #--------------------------------------------------------------------------
  def set_actor(new_actor)
    return if new_actor == @actor
    @actor = new_actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'eroe
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def actor; @actor; end
  #--------------------------------------------------------------------------
  # * Disegna un testo formattato (torna a capo automaticamente)
  #   Supporta anche le emoji.
  #   x:      coordinata X
  #   y:      coordinata Y
  #   width:  larghezza del box
  #   text:   testo da scrivere
  #   max:    numero massimo di righe
  #--------------------------------------------------------------------------
  def draw_formatted_text(x, y, width, text, max = nil, colors = nil)
    contents.draw_formatted_text(x, y, width, text, max, colors)
  end
  #--------------------------------------------------------------------------
  # * disegna una freccia alle coordinate specificate
  # @param [Symbol] arrow_sym [:up, :down, :left, :right]
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_arrow(arrow_sym, x, y, enabled = true)
    opacity = enabled ? 255 : 128
    rect = arrow_rect(arrow_sym)
    contents.blt(x, y, self.windowskin, rect, opacity)
  end
  #--------------------------------------------------------------------------
  # * Restituisce il rettangolo da dove prendere la risorsa nella windowskin
  # @param [Symbol] arrow_sym
  # @return [Rect]
  #--------------------------------------------------------------------------
  def arrow_rect(arrow_sym); ARROW_RECTS[arrow_sym]; end
  #--------------------------------------------------------------------------
  # * Determina se la finestra è fuori dallo schermo
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def out_of_screen?
    return true if self.rx <= 0
    return true if self.by <= 0
    return true if self.x > Graphics.width
    return true if self.y > Graphics.height
    false
  end
  #--------------------------------------------------------------------------
  # * restituisce il rect della riga della finestra
  # @param [Integer] line
  # @return [Rect]
  #--------------------------------------------------------------------------
  def line_rect(line = 0)
    Rect.new(0, line * line_height, contents_width, line_height)
  end
end

#===============================================================================
# ** Window_Selectable
#-------------------------------------------------------------------------------
# Aggiunge metodi utili alla finestra
#===============================================================================
class Window_Selectable < Window_Base
  alias h87_ph process_handling unless $@
  #--------------------------------------------------------------------------
  # * Ottiene il rettangolo in coordinate dello schermo dell'oggetto
  # @param [Integer] index
  # @return [Rect]
  #--------------------------------------------------------------------------
  def get_absolute_rect(index = self.index)
    rect = item_rect(index)
    rect.x += self.x + self.padding
    rect.y += self.y + self.padding
    rect
  end
  #--------------------------------------------------------------------------
  # * Disegna sulla bitmap l'icona dell'oggetto
  # @param [Bitmap] bitmap
  # @param [RPG::BaseItem] item
  # @return [Bitmap]
  # noinspection RubyResolve
  #--------------------------------------------------------------------------
  def fill_bitmap_icon(bitmap, item)
    bitmap.draw_icon(item.icon_index, 0, 0)
    if $imported['H87_ItemClass'] && (item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)) && item.tier > 0
      bitmap.draw_icon(H87_ItemClass::Icone[item.tier], 0, 0)
    end
    bitmap
  end
  #--------------------------------------------------------------------------
  # * Disegna sulla bitmap i dati dell'oggetto
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def fill_bitmap_item(bitmap, item)
    fill_bitmap_icon(bitmap, item)
    bitmap.draw_text(24,0,bitmap.width-24,bitmap.height,item.name)
    if $imported['H87_EquipEnchant'] && item.special_text.size > 0
      draw_specialization_text(bitmap,item,0,0)
    end
    bitmap
  end
  #--------------------------------------------------------------------------
  # * Ottiene l'immagine della voce evidenziata
  # @return [Sprite]
  #--------------------------------------------------------------------------
  def selected_item_sprite
    rect = get_absolute_rect
    bitmap = fill_bitmap_item(Bitmap.new(rect.width, rect.height), item)
    sprite = Sprite.new
    sprite.bitmap = bitmap
    sprite.x = rect.x
    sprite.y = rect.y
    sprite
  end
  #--------------------------------------------------------------------------
  # * Ottiene l'icona della voce evidenziata
  # @return [Sprite]
  #--------------------------------------------------------------------------
  def get_icon_item_sprite
    rect = get_absolute_rect
    bitmap = fill_bitmap_icon(Bitmap.new(24,24), item)
    sprite = Sprite.new
    sprite.bitmap = bitmap
    sprite.x = rect.x
    sprite.y = rect.y
    sprite
  end
  #-----------------------------------------------------------------------------
  # * disegna la scritta della specializzazione dell'arma
  #-----------------------------------------------------------------------------
  def draw_specialization_text(bitmap, item,x,y,enabled=true)
    x2=x+25+contents.text_size(item.name).width
    w = 220#-x2
    old_font = self.contents.font.size
    bitmap.font.color = text_color(14)
    bitmap.font.size = 15
    bitmap.font.color.alpha = enabled ? 255 : 128
    bitmap.draw_text(x2,y,w,line_height-8,item.special_text)
    bitmap.font.color = normal_color
    bitmap.font.size = old_font
  end
  #-----------------------------------------------------------------------------
  # * Rinfresca solo il rettangolo dell'indice
  # @param [Integer] index
  #-----------------------------------------------------------------------------
  def refresh_index(index = @index)
    contents.clear_rect(item_rect(index))
    draw_item(index)
  end
  #--------------------------------------------------------------------------
  # * Aggiunta di comandi all'handler
  # noinspection RubyUnnecessaryReturnStatement
  #--------------------------------------------------------------------------
  def process_handling
    h87_ph
    return unless open? && active
    return process_left     if handle?(:left)     && Input.repeat?(:LEFT)
    return process_right    if handle?(:right)    && Input.repeat?(:RIGHT)
    return process_function if handle?(:function) && Input.trigger?(:X)
    return process_shift    if handle?(:shift)    && Input.trigger?(:A)
  end
  #--------------------------------------------------------------------------
  # * Controllo dell'handler del movimento del cursore
  #--------------------------------------------------------------------------
  def check_cursor_handler
    return unless open? && active
    return if @last_cursor == self.index
    @last_cursor = self.index
    call_handler(:cursor_move)
  end
  #--------------------------------------------------------------------------
  # * Processo di movimento a sinistra quando è impostato un handler
  #--------------------------------------------------------------------------
  def process_left
    play_switch_sound
    Input.update
    call_left_handler
  end
  #--------------------------------------------------------------------------
  # * Processo movimento a destra
  #--------------------------------------------------------------------------
  def process_right
    play_switch_sound
    Input.update
    call_right_handler
  end
  #--------------------------------------------------------------------------
  # * Aggiunta dell'handler funzione
  #--------------------------------------------------------------------------
  def process_function
    call_handler(:function)
  end
  #--------------------------------------------------------------------------
  # * Aggiunta dell'handler funzione
  #--------------------------------------------------------------------------
  def process_shift
    call_handler(:shift)
  end
  #--------------------------------------------------------------------------
  # * Esecuzione del suono di sinistra/destra
  #--------------------------------------------------------------------------
  def play_switch_sound
    Sound.play_cursor
  end
  #--------------------------------------------------------------------------
  # * Esecuzione dell'handler sinistra
  #--------------------------------------------------------------------------
  def call_left_handler
    call_handler(:left)
  end
  #--------------------------------------------------------------------------
  # * Esecuzione dell'handler destra
  #--------------------------------------------------------------------------
  def call_right_handler
    call_handler(:right)
  end
end

#===============================================================================
# ** Window_Command
#===============================================================================
class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  # * Restituisce l'indice del simbolo
  #--------------------------------------------------------------------------
  def symbol_index(symbol)
    index = nil
    @list.each_with_index{|command, i|
      index = i if command[:symbol] == symbol}
    index
  end
end