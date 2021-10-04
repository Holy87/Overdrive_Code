#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
# Aggiunta di metodi utili per uno sviluppo più facile
#==============================================================================
$imported = {} if $imported == nil
$imported["H87-Window_Enhancement"] = 1.0

class Window_Base < Window
  ICON_WIDTH = 24
  FACE_WIDTH = 92
  # larghezza del face su una riga
  LFACE_WIDTH = 83
  LFACE_Y_IND = 22

  alias draw_no_emoji_text_ex draw_text_ex unless $@
  alias process_no_emoji_character process_character unless $@
  alias process_no_emoji_escape process_escape_character unless $@

  ARROW_RECTS = {
      :left => Rect.new(80, 20, 8, 24),
      :right => Rect.new(104, 20, 8, 24),
      :up => Rect.new(89, 8, 14, 24),
      :down => Rect.new(89, 32, 14, 24)
  }
  # Centra la finestra nel campo
  def center_window
    self.x = (Graphics.width - self.width) / 2
    self.y = (Graphics.height - self.height) / 2
  end

  # Restituisce la coordinata della parte destra della finestra
  # @return [Integer]
  def right_corner
    self.x + self.width;
  end

  # Restituisce la coordinata della parte sinistra della finestra
  # @return [Integer]
  def bottom_corner
    self.y + self.height;
  end

  # Abbreviazioni per bottom_corner e right_corner
  # @return [Integer]
  def rx
    right_corner;
  end

  def by
    bottom_corner;
  end

  # Disegna il testo andando a capo automaticamente (usa text_ex, quindi
  # utilizza anche i caratteri escape)
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [String] text
  def draw_text_wrapped(x, y, text, width = contents_width)
    all_text = []
    text.split("\n").each do |paragraph|
      if text_size(paragraph).width <= width
        all_text.push(paragraph)
      else
        all_text += wrap_text(paragraph, width)
      end
    end
    draw_text_ex(x, y, all_text.join("\n"))
  end

  # taglia una riga se troppo lunga per la larghezza
  # @param [String] text
  # @param [Integer] width
  def wrap_text(text, width)
    lines = []
    first_index = 0
    text.size.times do |char_index|
      next if text_size_without_escape(text[first_index..char_index]).width < width and char_index < text.size - 1
      lines.push(text[first_index..char_index - 1])
      first_index = char_index
    end
    lines
  end

  # Draw Emoji
  #     emoji_index : Emoji number
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     enabled    : Enabled flag. When false, draw semi-transparently.
  def draw_emoji(emoji_index, x, y, enabled = true)
    bitmap = Cache.system('Emojiset')
    rect = Rect.new(emoji_index % 16 * 24, emoji_index / 16 * 24, 24, 24)
    self.contents.blt(x, y, bitmap, rect, enabled ? 255 : 128)
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [String] text
  def draw_text_ex(x, y, text)
    #text = convert_unicode_characters(text)
    text = convert_emoji_characters(text)
    draw_no_emoji_text_ex(x, y, text)
  end

  # @param [String] c
  # @param [String] text
  # @param [Hash] pos
  def process_character(c, text, pos)
    return process_draw_emoji(Emoji.get(c), pos) if Emoji.has?(c)
    process_no_emoji_character(c, text, pos)
  end

  # @param [String] code
  # @param [String] text
  # @param [Hash] pos
  def process_escape_character(code, text, pos)
    return process_draw_emoji(obtain_escape_param(text), pos) if code.upcase == 'J'
    process_no_emoji_escape(code, text, pos)
  end

  def process_draw_emoji(emoji_index, pos)
    draw_emoji(emoji_index, pos[:x], pos[:y])
    pos[:x] += 24
  end

  # converte i codici unicode in caratteri
  # esempio "vi voglio bene \u2764" -> "vi voglio bene ❤"
  # @param [String] text
  def convert_unicode_characters(text)
    text.gsub(/\\u([\da-e]{4,5})/i) {[$1.hex].pack('U*')}
  end

  # @param [String] text
  # @return [String]
  def convert_emoji_characters(text)
    Emoji.elements.each do |emoji|
      next if emoji.char.nil?
      next if text.nil?
      text = text.gsub(emoji.char, "\\J[#{emoji.icon}]")
    end
    text
  end

  # restituisce le dimensioni del testo senza tener conto dei caratteri
  # escape speciali.
  # @param [String] text
  # @return [Rect]
  def text_size_without_escape(text)
    text_size(text.gsub(/\\\\[A-Z]\[[\d]+\]/, ''))
  end

  # Disegna una linea per sottolineare il testo (per la sezione)
  # @param [Integer] line     linea
  # @param [Integer] width    larghezza (tutta la larghezza se omesso)
  # @param [Color] color      colore (predefinito, quello del testo)
  def draw_underline(line, width = contents_width, color = normal_color)
    color.alpha = 64
    contents.fill_rect(0, line_height * (line + 1) - 1, width, 1, color)
  end

  # disegna una miniatura del personaggio
  # @param [Game_Actor] actor
  # @param [Fixnum] x
  # @param [Fixnum] y
  def draw_actor_little_face(actor, x, y)
    bitmap = Cache.character(actor.character_name)
    bx = actor.character_index % 4 # + (bitmap.width / 12)
    by = actor.character_index / 4 * (bitmap.height / 2) + 2
    rect = Rect.new(bx, by, 32, line_height)
    contents.blt(x, y, bitmap, rect)
  end

  # draws all icons of equips in a single line
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  def draw_actor_equip_icons(actor, x, y, width = 110)
    icons = actor.equips.compact.map { |e| e.icon_index }
    draw_icons(icons, x, y, width)
  end

  # disegna il volto del personaggio tagliato per entrare in una riga di 24 pixel
  # @param [Game_Actor] actor
  # @param [Fixnum] x
  # @param [Fixnum] y
  def draw_actor_line_face(actor, x, y)
    draw_line_face(actor.face_name, actor.face_index, x, y)
  end

  # disegna un face tagliato per entrare in una riga di 24 pixel
  # @param [String] face_name
  # @param [Fixnum] face_index
  # @param [Fixnum] x
  # @param [Fixnum] y
  def draw_line_face(face_name, face_index, x, y)
    bitmap = Cache.face(face_name)
    rect = Rect.new(0, 0, 0, 0)
    x_index = FACE_WIDTH - LFACE_WIDTH
    rect.x = (face_index % 4 * 96 + (96 - size) / 2) + x_index
    rect.y = (face_index / 4 * 96 + (96 - size) / 2) + LFACE_Y_IND
    rect.width = LFACE_WIDTH
    rect.height = 24
    self.contents.blt(x, y, bitmap, rect)
    bitmap.dispose
  end

  # Restituisce il massimo numero di righe nella finestra
  # @return [Integer]
  def max_lines
    (contents.width / line_height) - 1;
  end

  # @param [String] text
  # @return [Fixnum]
  def text_width(text)
    text_size(text).width
  end

  # Colore di sfondo 1
  # @return [Color]
  def sc1
    color = gauge_back_color
    color.alpha = 75
    color
  end

  # Colore di sfondo 2
  # @return [Color]
  def sc2
    color = gauge_back_color
    color.alpha = 150
    color
  end

  # Disegna la barra di sfondo al parametro
  # @param [Integer] x          coordinata X
  # @param [Integer] y          coordinata Y
  # @param [Integer] width      larghezza
  # @param [Integer] height     altezza (predefinito testo)
  # @param [Color] color        colore (predefinito scuro)
  def draw_bg_rect(x, y, width = contents_width, height = line_height, color = sc1)
    contents.fill_rect(x + 1, y + 1, width - 2, height - 2, color)
  end

  # Disegna la barra di sfondo al parametro con bordi smussati
  # @param [Integer] x          coordinata X
  # @param [Integer] y          coordinata Y
  # @param [Integer] width      larghezza
  # @param [Integer] height     altezza (predefinito testo)
  # @param [Color] color        colore (predefinito scuro)
  def draw_bg_srect(x, y, width = contents_width, height = line_height, color = sc1)
    contents.fill_rect(x + 1, y + 1, width - 2, height - 2, color)
    contents.clear_rect(x + 1, y + 1, 1, 1)
    contents.clear_rect(x + 1, height - 2, 1, 1)
    contents.clear_rect(width - 2, y + 1, 1, 1)
    contents.clear_rect(width - 2, height - 2, 1, 1)
  end

  # Restituisce le coordinate di una determinata riga della finestra
  # @param [Integer] line
  # @return [Rect]
  def get_line_coord(line = 0)
    x = self.x + self.padding
    y = self.y + self.padding + line_height * line
    Rect.new(x, y, contents_width, line_height)
  end

  # Disegna una barra generica
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Integer] value
  # @param [Integer] max
  # @param [Color] c1
  # @param [Color] c2
  def draw_gauge_b(x, y, width, height, value, max,
                   c1 = hp_gauge_color1, c2 = hp_gauge_color2)
    y += line_height - height
    contents.fill_rect(x, y, width, height, gauge_back_color)
    rate = value.to_f / max.to_f
    gw = (rate * width).to_i
    contents.gradient_fill_rect(x, y, gw, height, c1, c2)
  end

  # Disegna una barra generica con minimo diverso da 0 (per exp)
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Integer] value
  # @param [Integer] max
  # @param [Integer] min
  # @param [Color] c1
  # @param [Color] c2
  def draw_gauge_a(x, y, width, height, value, min, max,
                   c1 = hp_gauge_color1, c2 = hp_gauge_color2)
    draw_gauge_b(x, y, width, height, value - min, max - min, c1, c2)
  end

  # Imposta l'eroe della finestra
  # @param [Game_Actor] new_actor
  def set_actor(new_actor)
    return if new_actor == @actor
    @actor = new_actor
    refresh
  end

  # disegna un array di icone in una certa larghezza
  # Se la larghezza è inferiore al numero di icone,
  # le icone sono più strette
  def draw_icons(icons, x, y, width = contents_width - x)
    if icons.size * 24 <= width
      spacing = 0
    else
      spacing = (width - icons.size * 24) / icons.size
    end
    icons.each do |icon_index|
      draw_icon(icon_index, x, y)
      x += 24 + spacing
    end
  end

  # Restituisce l'eroe
  # @return [Game_Actor]
  def actor
    @actor;
  end

  # Disegna un testo formattato (torna a capo automaticamente)
  #   Supporta anche le emoji.
  #   x:      coordinata X
  #   y:      coordinata Y
  #   width:  larghezza del box
  #   text:   testo da scrivere
  #   max:    numero massimo di righe
  def draw_formatted_text(x, y, width, text, max = nil, colors = nil)
    contents.draw_formatted_text(x, y, width, text, max, colors)
  end

  # disegna una freccia alle coordinate specificate
  # @param [Symbol] arrow_sym [:up, :down, :left, :right]
  # @param [Integer] x
  # @param [Integer] y
  def draw_arrow(arrow_sym, x, y, enabled = true)
    opacity = enabled ? 255 : 128
    rect = arrow_rect(arrow_sym)
    contents.blt(x, y, self.windowskin, rect, opacity)
  end

  # Restituisce il rettangolo da dove prendere la risorsa nella windowskin
  # @param [Symbol] arrow_sym
  # @return [Rect]
  def arrow_rect(arrow_sym)
    ARROW_RECTS[arrow_sym]
  end

  # Determina se la finestra è fuori dallo schermo
  # @return [Boolean]
  def out_of_screen?
    return true if self.rx <= 0
    return true if self.by <= 0
    return true if self.x > Graphics.width
    return true if self.y > Graphics.height
    false
  end

  # restituisce il rect della riga della finestra
  # @param [Integer] line
  # @return [Rect]
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
  alias :h87_ph :process_handling unless $@
  alias :h87_uc :update_cursor unless $@
  alias :h87_dai :draw_all_items unless $@

  # testo da mostrare nel caso la lista sia vuota
  # @return [String, nil]
  def empty_text
    nil
  end

  # elimina il listener evento
  def delete_handler(symbol)
    @handler.delete(symbol)
  end

  # Ottiene il rettangolo in coordinate dello schermo dell'oggetto
  # @param [Integer] index
  # @return [Rect]
  def get_absolute_rect(index = self.index)
    rect = item_rect(index)
    rect.x += self.x + self.padding - self.ox
    rect.y += self.y + self.padding - self.oy
    rect
  end

  alias :absolute_rect :get_absolute_rect

  # Disegna sulla bitmap l'icona dell'oggetto
  # @param [Bitmap] bitmap
  # @param [RPG::BaseItem] item
  # @return [Bitmap]
  # noinspection RubyResolve
  def fill_bitmap_icon(bitmap, item)
    bitmap.draw_icon(item.icon_index, 0, 0)
    if $imported['H87_ItemClass'] && (item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)) && item.tier > 0
      bitmap.draw_icon(H87_ItemClass::Icone[item.tier], 0, 0)
    end
    bitmap
  end

  # Disegna sulla bitmap i dati dell'oggetto
  # @return [Bitmap]
  def fill_bitmap_item(bitmap, item)
    fill_bitmap_icon(bitmap, item)
    bitmap.draw_text(24, 0, bitmap.width - 24, bitmap.height, item.name)
    if $imported['H87_EquipEnchant'] && item.special_text.size > 0
      draw_specialization_text(bitmap, item, 0, 0)
    end
    bitmap
  end

  # Ottiene l'immagine della voce evidenziata
  # @return [Sprite]
  def selected_item_sprite
    rect = get_absolute_rect
    bitmap = fill_bitmap_item(Bitmap.new(rect.width, rect.height), item)
    sprite = Sprite.new
    sprite.bitmap = bitmap
    sprite.x = rect.x
    sprite.y = rect.y
    sprite
  end

  # Ottiene l'icona della voce evidenziata
  # @return [Sprite]
  def get_icon_item_sprite
    rect = get_absolute_rect
    bitmap = fill_bitmap_icon(Bitmap.new(24, 24), item)
    sprite = Sprite.new
    sprite.bitmap = bitmap
    sprite.x = rect.x
    sprite.y = rect.y
    sprite
  end

  # genera e restituisce la bitmap contenente la grafica
  # del contenuto selezionato dalla finestra
  # @return [Bitmap]
  def current_item_bitmap
    rect = item_rect(@index)
    bitmap = Bitmap.new(rect.width, rect.height)
    bitmap.blt(0, 0, contents, rect)
    bitmap
  end

  # disegna la scritta della specializzazione dell'arma
  # @param [Bitmap] bitmap
  # @param [RPG::BaseItem] item
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  def draw_specialization_text(bitmap, item, x, y, enabled = true)
    x2 = x + 25 + contents.text_size(item.name).width
    w = 220 #-x2
    old_font = self.contents.font.size
    bitmap.font.color = text_color(14)
    bitmap.font.size = 15
    bitmap.font.color.alpha = enabled ? 255 : 128
    bitmap.draw_text(x2, y, w, line_height - 8, item.special_text)
    bitmap.font.color = normal_color
    bitmap.font.size = old_font
  end

  # Rinfresca solo il rettangolo dell'indice
  # @param [Integer] index
  def refresh_index(index = @index)
    contents.clear_rect(item_rect(index))
    draw_item(index)
  end

  # Aggiunta di comandi all'handler
  # noinspection RubyUnnecessaryReturnStatement
  def process_handling
    h87_ph
    return unless open? && active
    return process_left if handle?(:left) && Input.repeat?(:LEFT)
    return process_right if handle?(:right) && Input.repeat?(:RIGHT)
    return process_function if handle?(:function) && Input.trigger?(:X)
    return process_shift if handle?(:shift) && Input.trigger?(:A)
  end

  # Controllo dell'handler del movimento del cursore
  def check_cursor_handler
    return unless open? && active
    return if @last_cursor == self.index
    @last_cursor = self.index
    call_handler(:cursor_move)
  end

  # Ridefinizione del metodo select per aggiornare la schermata
  def update_cursor
    h87_uc; check_cursor_handler;
  end

  # Processo di movimento a sinistra quando è impostato un handler
  def process_left
    play_switch_sound
    Input.update
    call_left_handler
  end

  # Processo movimento a destra
  def process_right
    play_switch_sound
    Input.update
    call_right_handler
  end

  # Aggiunta dell'handler funzione
  def process_function
    call_handler(:function)
  end

  # Aggiunta dell'handler funzione
  def process_shift
    call_handler(:shift)
  end

  # Esecuzione del suono di sinistra/destra
  def play_switch_sound
    Sound.play_cursor
  end

  # Esecuzione dell'handler sinistra
  def call_left_handler
    call_handler(:left)
  end

  # Esecuzione dell'handler destra
  def call_right_handler
    call_handler(:right)
  end

  def draw_all_items
    if @data != nil and empty_text != nil and @data.empty?
      change_color normal_color, false
      draw_text(item_rect_for_text(0), empty_text)
    else
      h87_dai
    end
  end
end

#===============================================================================
# ** Window_Command
#===============================================================================
class Window_Command < Window_Selectable
  # Restituisce l'indice del simbolo
  def symbol_index(symbol)
    index = nil
    @list.each_with_index { |command, i|
      index = i if command[:symbol] == symbol }
    index
  end
end

class Rect

  # @return [Fixnum]
  def bottom
    self.y + self.height
  end

  # @return [Fixnum]
  def right_border
    self.x + self.width
  end
end