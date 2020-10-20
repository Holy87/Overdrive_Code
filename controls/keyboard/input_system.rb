#===============================================================================
# Inserimento testo da Tastiera di Holy87
# Difficoltà utente: ★★★★
# Versione 1.2
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#
# changelog
# v1.2 => • Possibilità di incollare il testo con CTRL+V
#         • Possibilità di impostare un handler su aggiornamento
#           del testo come evento (set_handler (:change, method(:nome_metodo)))
# v1.1 => • Possibilità di inserire un placeholder
#         • Possibilità di disattivare a capo automatico
#         • Possibilità di impostare un testo (window.text=)
#         • Modifica ai simboli
#         • Quando si ottiene il testo, ora vengono rimossi autoamticamente
#           spazi all'inizio ed alla fine
#         • Miglioramenti e risoluzione di bug
#===============================================================================
# Questo script permette agli scripter di creare delle finestre dove è possibile
# inserire il testo direttamente dalla tastiera in modo semplice e completamente
# personalizzabile.
#
# FUNZIONI SPECIALI:
# ● Puoi decidere quali caratteri sono permessi (ad es. solo lettere, numeri o
#   anche simboli e spaziature)
# ● Puoi forzare il testo in maiuscolo
# ● Puoi creare un inserimento password, offuscando il testo con un pallino •
# ● Puoi decidere il numero massimo di righe
# ● Puoi decidere un numero massimo di caratteri (o lasciare decidere alla
#   finestra di non permettere inserimenti quando lo spazio finisce)
# ● Segue il layout della tastiera, nessuna configurazione!
# ● Puoi impostare un placeholder (testo descrittivo) prima di scrivere
# ● Puoi scegliere se poter andare a capo automaticamente o no
# ● Puoi far incollare il testo copiato negli appunti con CTRL+V
#
#===============================================================================
# ISTRUZIONI: inserire lo script sotto Materials, prima del Main. Richiede
# lo script "Interfaccia Tastiera".
#
#  Puoi creare una nuova finestra della classe Window_TextInput (o creando una
#  sottoclasse se vuoi personalizzarla meglio) o creare qualcosa di completamente
#  nuovo includendo il modulo Text_Inputtable (se sei esperto!)
#
# ■ Utilizzo:
# crea una finestra con Window_TextInput.new(x, y, width, height, options)
# per quanto riguarda x, y, width ed height non ci sono particolari spiegazioni
# da dare.
# Il parametro options è un hash che include tutte le opzioni di personalizzazione
# della tastiera:
# - force_upcase: se true, tutti i caratteri sono scritti in maiuscolo (false se
#   non metti l'opzione)
# - max_characters: il numero massimo di caratteri (0 di default, infinito o fino
#   a quando lo spazio nella finestra lo permette)
# - max_lines: il numero di righe disponibile per l'inserimento del testo (1 di
#   default). Se il numero di righe è 1, il tasto INVIO conferma il testo.
#   Se invece sono permesse più righe, il tasto INVIO va a capo mentre per
#   confermare devi premere CTRL+INVIO.
# - password: Se true, tutto il testo visibile viene offuscato con un carattere
#   speciale (false di default)
# - placeholder: una stringa che viene mostrata quando il campo è vuoto
# - text_prap: se true, il testo va a capo automaticamente (true di default)
# - permit_paste: determina se permettere o no l'inserimento di testo copiato
#   dagli appunti
# - permitted: i tipi di caratteri permessi. Puoi assegnare questi valori:
#   * Text_Inputable::WORDS: sono ammesse solo lettere
#   * Text_Inputable::NUMERIC: sono ammessi solo numeri
#   * Text_Inputable::SPACING: sono ammessi solo spazi
#   * Text_Inputable::ALPHA_WITH_SPACING: sono ammesse lettere, numeri e spazi
#   * Text_Inputable::BASE_SYMBOLS: sono ammessi solo i simboli -, _, ., e @
#   * Text_Inputable::STANDARD_SYMBOLS: sono ammessi altri simboli
#   * Text_Inputable::ALL_SYMBOLS: sono ammessi tutti i simboli
#   * Text_Inputable::NO_RESTRICTIONS: tutto il testo è permesso.
#   Se non specificato, il parametro di default è Text_Inputable::NO_RESTRICTIONS.
#   Puoi anche inserire delle combinazioni, ad esempio se metti come paraemtro
#   Text_Inputable::WORDS|Text_Inputable::NUMERIC (separati da |) puoi permettere
#   l'inserimento di lettere e numeri.
# - ok_callback: il metodo che viene chiamato quando l'utente conferma l'inserimento
# - cancel_callback: il metodo che viene chiamato quando l'utente annulla
# - change_callback: il metodo che viene chiamato quando il testo cambia
#   l'inserimento con ESC. Se non è definito, l'inserimento non può essere
#   annullato.
#   * Nota: puoi assegnare i metodi ok e cancel anche chiamando le funzioni
#     set_done_handler e set_cancel_handler della finestra.
#
# ■ Esempio d'uso:
#   options = {
#     max_characters: 100,
#     max_lines: 2,
#     permitted_values: Text_Inputable::WORDS|Text_Inputable::SPACING
#   }
#   @text_window = Window_TextInput.new(0, 0, 140, 69, options)
#   @text_window.set_done_handler(method(:process_text))
#   @text_window.set_cancel_handler(method(:return_scene))
#   @text_window.activate
#
#
#
#===============================================================================

#===============================================================================
# ** Impostazioni dello script
#===============================================================================
module Input_Keyboard
  # questi sono i tasti abilitati per l'input da tastiera
  LISTENED_KEYS = [
      :NUM_0, :NUM_1, :NUM_2, :NUM_3, :NUM_4, :NUM_5, :NUM_6, :NUM_7, :NUM_8,
      :NUM_9, :KEY_A, :KEY_B, :KEY_C, :KEY_D, :KEY_E, :KEY_F, :KEY_G, :KEY_H,
      :KEY_I, :KEY_J, :KEY_K, :KEY_L, :KEY_M, :KEY_N, :KEY_O, :KEY_P, :KEY_Q,
      :KEY_R, :KEY_S, :KEY_T, :KEY_U, :KEY_V, :KEY_W, :KEY_X, :KEY_Y, :KEY_Z,
      :VK_NUMPAD0, :VK_NUMPAD1, :VK_NUMPAD2, :VK_NUMPAD3, :VK_NUMPAD4,
      :VK_NUMPAD5, :VK_NUMPAD6, :VK_NUMPAD7, :VK_NUMPAD8, :VK_NUMPAD9,
      :VK_MULTIPLY , :VK_ADD, :VK_SEPARATOR, :VK_SUBTRACT, :VK_DECIMAL,
      :VK_DIVIDE, :VK_OEM_1, :VK_OEM_PLUS, :VK_OEM_COMMA , :VK_OEM_MINUS ,
      :VK_OEM_PERIOD, :VK_OEM_2, :VK_OEM_3, :VK_OEM_4, :VK_OEM_5, :VK_OEM_6,
      :VK_OEM_7, :VK_OEM_8, :VK_OEM_102, :VK_SPACE
  ]

  # determina se vuoi eseguire dei suoni all'input da tastiera.
  # ATTENZIONE: SONO STATI REGISTRATI DEI CRASH ANOMALI CON I SUONI
  PLAY_SE = false

  # Configura i suoni dell'input
  #               SE name      Volume  Pitch
  INPUT_SE =      ['Cursor1',  100,    150]
  BACKSPACE_SE =  ['Cursor1',  100,    100]
  SPACE_SE =      ['Cursor1',  100,     50]
  FORBIDDEN_SE =  ['Cursor2',  100,     50]
  PASTE_SE =      ['Cursor2',  100,    150]

  # carattere mostrato quando si digita una password
  PASSWORD_CHARACTER = '•'
end



# --- NON MODIFICARE OLTRE SE NON SAI QUELLO CHE FAI! ---

#===============================================================================
# ** Text_Inputable
#-------------------------------------------------------------------------------
# modulo per la gestione del testo da una tastiera.
#===============================================================================
module Text_Inputable
  WORD_PATTERN = /[A-zÀ-ú]/i
  NUMERIC_PATTERN = /\d/
  SPACING_PATTERN = /[\s\t]/
  BASE_SYMBOL_PATTERN = /[\-_\.@,\']/
  STANDARD_SYMBOL_PATTERN = /[!\?"\+\*\(\)<\>=\#&\%\^\\|\/°]/

  # SETTINGS CONSTANTS
  WORDS               = 0x01 # only alphabetic characters
  NUMERIC             = 0x02 # only numeric characters (0-9)
  ALPHANUMERIC        = 0x03 # alphabetic and numeric
  SPACING             = 0x04 # spaces and tabs
  ALPHA_WITH_SPACING  = 0x0F # all above
  BASE_SYMBOLS        = 0x10 # -, _, ., @, ,, '
  STANDARD_SYMBOLS    = 0x30 # !, ?, (, ), ", +, *, <, >, =, #, &, %, ^, \, |, /, ° and above
  ALL_SYMBOLS         = 0x70 # no symbol limit.
  NO_RESTRICTIONS     = 0x7F # all alphanumeric, spacing an symbols

  SPACE_CHARACTER   = " "
  NEWLINE_CHARACTER = "\n"

  # @return[String]
  attr_reader :text
  # @return[Integer] the max number of lines
  attr_accessor :max_lines
  # @return [Integer] the maximum number of characters
  attr_accessor :max_characters
  # @return [Integer]
  attr_accessor :permitted_values
  # @return [String]
  attr_accessor :placeholder
  attr_accessor :text_wrap

  # inizializza i parametri principali dell'input
  # @param [Hash] options
  def initialize_input_parameters(options)
    @text = ''
    @handlers = {}
    @force_upcase = options[:upcase] || false
    @permitted_values = options[:permitted] || NO_RESTRICTIONS
    @max_characters = options[:max_characters] || 0
    @max_lines = options[:max_lines] || 1
    @handlers[:ok] = options[:ok_callback]
    @handlers[:cancel] = options[:cancel_callback]
    @handlers[:change] = options[:change_callback]
    @password_hide = options[:password] || false
    @placeholder = options[:placeholder]
    @text_wrap = options[:text_wrap].nil? ? true : options[:text_wrap]
    @permit_paste = options[:permit_paste] || false
    @current_line = 0
    @line_x = [0]
    if Input_Keyboard::PLAY_SE
      @effects = {
          :input => init_se(Input_Keyboard::INPUT_SE),
          :backspace => init_se(Input_Keyboard::BACKSPACE_SE),
          :space => init_se(Input_Keyboard::SPACE_SE),
          :forbidden => init_se(Input_Keyboard::FORBIDDEN_SE),
          :paste => init_se(Input_Keyboard::PASTE_SE)
      }
    end
  end

  # @param [Array] set
  # @return [RPG::SE]
  def init_se(set)
    RPG::SE.new(set[0], set[1], set[2])
  end

  # aggiorna l'inserimento da tastiera
  def update_input
    return unless active?
    process_done
    process_escape
    return process_paste if Input.paste_command?
    return process_input_return if Input.return_pressed?
    return process_input_backspace if Input.backspace_pressed?
    process_input_character
  end

  # restituisce il numero di caratteri
  def characters_count
    @text.size
  end

  # determina il numero di caratteri rimanenti
  def remaining_characters
    @max_characters - characters_count
  end

  # restituisce il conteggio delle parole
  def word_count
    @text.split(/[\s\t\n\r]+/).size
  end

  def add_character(character)
    raise NotImplementedError
  end

  # deactivates all
  def deactivate
    raise NotImplementedError
  end

  def active?
    raise NotImplementedError
  end

  def process_input_character
    return unless active?
    key = Input.any_keyboard_input?
    return unless key
    begin
      character = Keyboard.unicode_char(key)
    rescue
      puts sprintf('Error in processing character for %s', key)
      return
    end
    return unless character_permitted?(character)
    add_character(character)
  end

  def process_paste
    raise NotImplementedError
  end

  def process_input_return
    raise NotImplementedError
  end

  def process_input_backspace
    raise NotImplementedError
  end

  def process_escape
    return unless active?
    return unless Input.escape_triggered?
    return unless handle? :cancel
    deactivate
    call_handler :cancel
  end

  def process_done
    return unless active?
    if @max_lines > 1
      return unless Input.force_return?
    else
      return unless Input.return_pressed?
    end
    return unless handle? :ok
    deactivate
    call_handler :ok
  end

  # set the function when the user press CTRL + RETURN
  # @param [Method] handler
  def set_done_handler(handler)
    @handlers[:ok] = handler
  end

  # set the function when the user press ESC
  # @param [Method] handler
  def set_cancel_handler(handler)
    @handlers[:cancel] = handler
  end

  # @param [Symbol] symbol
  # @param [Method] method
  def set_handler(symbol, method)
    @handlers[symbol] = method
  end

  def call_handler(symbol)
    return unless handle? symbol
    @handlers[symbol].call
  end

  def handle?(symbol)
    @handlers[symbol] != nil
  end

  # @param [String] character
  def character_permitted?(character)
    return true if permitted?(ALL_SYMBOLS)
    return true if character =~ WORD_PATTERN and permitted?(WORDS)
    return true if character =~ SPACING_PATTERN and permitted?(SPACING)
    return true if character =~ NUMERIC_PATTERN and permitted?(NUMERIC)
    return true if character =~ BASE_SYMBOL_PATTERN and permitted?(BASE_SYMBOLS)
    return true if character =~ STANDARD_SYMBOL_PATTERN and permitted?(STANDARD_SYMBOLS)
    false
  end

  def permitted?(const_setting)
    (@permitted_values | const_setting) == @permitted_values
  end

  # determina se tutto viene scritto in maiuscolo
  def force_upcase?
    @force_upcase
  end

  def password?
    @password_hide
  end

  def space_remaining?(char)
    raise NotImplementedError
  end

  def play_input_se
    return unless Input_Keyboard::PLAY_SE
    @effects[:input].play
  end

  def play_backspace_se
    return unless Input_Keyboard::PLAY_SE
    @effects[:backspace].play
  end

  def play_space_se
    return unless Input_Keyboard::PLAY_SE
    @effects[:space].play
  end

  def play_forbidden_se
    return unless Input_Keyboard::PLAY_SE
    @effects[:forbidden].play
  end

  def play_paste_se
    return unless Input_Keyboard::PLAY_SE
    @effects[:paste].play
  end

  # @return [String]
  def password_char
    Input_Keyboard::PASSWORD_CHARACTER
  end
end


#===============================================================================
# ** Window_TextInput
#-------------------------------------------------------------------------------
# Finestra per immettere testo da una tastiera.
#===============================================================================
class Window_TextInput < Window_Base
  include Text_Inputable
  attr_accessor :active

  def initialize(x, y, width, height, options = {})
    initialize_input_parameters(options)
    super(x, y, width, height)
    clear_text
    create_cursor_sprite
    deactivate
  end

  # returns the text with spacing removed
  # @return [String]
  def text
    @text.strip
  end

  # @param [String] new_text
  def text=(new_text)
    return if @text == new_text
    clear_text
    add_text(new_text)
  end

  # @param [String] new_text
  def add_text(new_text)
    new_text.each_char { |c| break unless add_character(c.chr, true) }
    call_handler :change
  end

  # restituisce il rettangolo di  input
  # @return [Rect]
  def text_input_rect
    Rect.new(0, 0, contents_width, contents_height)
  end

  def refresh
    draw_placeholder if @text.empty?
  end

  def refresh_cursor_position
    return if @cursor.nil?
    @cursor.x = padding + self.x + text_x + 1
    @cursor.y = padding + self.y + text_y
    @cursor.z = self.z + 10
    @cursor.force_show if active? && open?
  end

  def clear_text
    contents.clear_rect(text_input_rect)
    @text = ''
    @line_x = [0]
    @current_line = 0
    refresh_cursor_position
    call_handler :change
    refresh
  end

  def draw_placeholder
    return unless @placeholder
    change_color(normal_color, false)
    rect = text_input_rect
    rect.height = line_height
    draw_text(rect, @placeholder)
    change_color normal_color
  end

  def create_cursor_sprite
    @cursor = Sprite_InputCursor.new(normal_color, 1, line_height - 6, self.viewport)
    @cursor.visible = false
    @cursor.oy -= 3
  end

  # determina se c'è abbastanza spazio per inserire il carattere
  # @param [String] character
  # @return [TrueClass, FalseClass]
  def space_remaining?(character)
    return false if character_limit? && remaining_characters <= 0
    return true if @text_wrap and !max_line_reached?
    return false if remaining_line_space - text_size(character).width < 0
    true
  end

  # aggiornamento
  def update
    super
    update_input
    update_cursor
  end

  # aggiornamento del cursore
  def update_cursor
    return unless active?
    return unless open?
    @cursor.update
  end

  # rende invisibile il cursore alla chiusura
  def close
    super
    @cursor.visible = false
  end

  # rende visibile il cursore all'apertura
  def open
    super
    @cursor.visible = true
  end

  def visible=(value)
    super
    @cursor.visible = value
  end

  def activate
    Input.update
    @cursor.visible = true
    @active = true
  end

  def deactivate
    @cursor.visible = false
    @active = false
    Input.update
  end

  def active?
    @active
  end

  # @param [Fixnum] val
  def x=(val)
    super
    refresh_cursor_position
  end

  # @param [Fixnum] val
  def y=(val)
    super
    refresh_cursor_position
  end

  # @param [Fixnum] val
  def z=(val)
    super
    refresh_cursor_position
  end

  # @param [Viewport] viewport
  def viewport=(viewport)
    super
    @cursor.viewport = viewport
  end

  # aggiunge il carattere, va a capo se necessario ed aggiorna
  # il cursore
  # @param [String] character
  # @param [Boolean] hidden
  def add_character(character, hidden = false)
    character.upcase! if force_upcase?
    return true unless character_permitted?(character)
    unless space_remaining?(character)
      play_forbidden_se unless hidden
      return false
    end
    contents.clear_rect(text_input_rect) if @placeholder != nil and @text.empty?
    character =~ SPACING_PATTERN ? play_space_se : play_input_se unless hidden
    add_new_line if remaining_line_space - char_width(character) < 0
    write_character(character)
    @line_x[@current_line] += char_width(character)
    refresh_cursor_position
    @text << character
    call_handler(:change) unless hidden
    true
  end

  # rimuove l'ultimo carattere aggiunto ed aggiorna la grafica
  def remove_character
    return play_forbidden_se if @text.empty?
    play_backspace_se
    character = last_character
    @line_x[@current_line] -= char_width(character)
    refresh_cursor_position
    @text.chop!
    delete_character(character)
    remove_line if text_x <= text_input_rect.x && last_character != NEWLINE_CHARACTER && @current_line > 0
    clear_text if @text.empty?
    call_handler :change
  end

  # aggiunge una nuova riga
  def process_input_return
    return unless Input.return_pressed?
    return play_forbidden_se if max_line_reached?
    play_input_se
    add_new_line
    @text << NEWLINE_CHARACTER
  end

  # incolla il testo dagli appunti
  def process_paste
    return unless active?
    return unless @permit_paste
    play_paste_se
    add_text Clipboard.read_text_safe
  end

  # esecuzione del tasto BACKSPACE
  def process_input_backspace
    return unless Input.backspace_pressed?
    remove_character
  end

  # disegna il carattere sul contenuto
  # @param [String] character
  def write_character(character)
    character = password_char if password?
    width = text_size(character).width
    draw_text(text_x, text_y, width + 1, line_height, character)
  end

  # cancella il carattere dalla bitmap
  def delete_character(character)
    rect = Rect.new(text_x, text_y, char_width(character) + 1, line_height)
    contents.clear_rect(rect)
  end

  # determina se la finestra ha un limite di caratteri
  def character_limit?
    @max_characters > 0
  end

  # determina se è stata raggiunta l'ultima riga disponibile
  # per l'inserimento del testo
  def max_line_reached?
    @current_line == @max_lines - 1
  end

  # restituisce lo spazio rimanente nella riga attuale
  def remaining_line_space
    text_input_rect.width - text_x + text_input_rect.x
  end

  # aggiunge una nuova riga
  def add_new_line
    @current_line += 1
    @line_x[@current_line] = 0
    refresh_cursor_position
  end

  # rimuove l'ultima riga e torna su
  def remove_line
    @current_line -= 1
    refresh_cursor_position
  end

  # @param [String] character
  # @return [Integer]
  def char_width(character)
    return 0 if character == NEWLINE_CHARACTER
    return text_size(password_char).width if password?
    text_size(character).width
  end

  # restituisce la coordinata X del testo rispetto al rettangolo di
  # input nella riga attuale
  def text_x
    text_input_rect.x + @line_x[@current_line]
  end

  # restituisce la coordinata Y del testo
  def text_y
    text_input_rect.y + line_height * @current_line
  end

  # restituisce l'ultimo carattere del testo (per cancellazione)
  # @return [String]
  def last_character
    return '' if @text.empty?
    @text.split('').last
  end

  # eliminazione (anche per la grafica del cursore)
  def dispose
    @cursor.dispose
    super
  end
end

#===============================================================================
# ** Sprite_InputCursor
#-------------------------------------------------------------------------------
# Sprite speciale specifico per i cursori
#===============================================================================
class Sprite_InputCursor < Sprite
  # @param [Color] color
  # @param [Fixnum] width
  # @param [Fixnum] height
  # @param [Viewport] viewport
  def initialize(color, width, height, viewport=nil)
    super(viewport)
    self.bitmap = Bitmap.new(width, height)
    self.bitmap.fill_rect(0, 0, bitmap.width, bitmap.height, color)
    @blink_timing = 0
  end

  # aggiornamento
  def update
    super
    update_blink
  end

  # aggiorna la grafica (mostra/nascondi)
  def update_blink
    @blink_timing += 1
    return if @blink_timing < 30
    @blink_timing = 0
    self.visible = !self.visible
  end

  # the cursor should be visible while typing
  def force_show
    self.visible = true
    @blink_timing = 0
  end
end

#===============================================================================
# ** Input
#-------------------------------------------------------------------------------
# Aggiunta di metodi per l'inserimento da tastiera
#===============================================================================
module Input

  # determina (e viene restituito) se è stato premuto un tasto della tastiera
  # che è assegnato ad una lettera, numero o simbolo.
  def self.any_keyboard_input?
    Input_Keyboard::LISTENED_KEYS.each { |key| return key if repeat?(key) }
    false
  end

  # determina se è stato premuto il tasto INVIO
  def self.return_pressed?
    repeat?(:VK_RETURN)
  end

  # determina se è stato premuto il tasto BACKSPACE
  def self.backspace_pressed?
    repeat?(:VK_BACK)
  end

  # determina se è stato premuto il tasto CANC
  def self.canc_pressed?
    repeat?(:VK_DELETE)
  end

  # determina se è stato premuto il tasto ESC
  def self.escape_triggered?
    trigger?(:VK_ESCAPE)
  end

  # determina se è stato premuto CTRL + INVIO.
  def self.force_return?
    press?(:VK_CONTROL) && trigger?(:VK_RETURN)
  end

  def self.paste_command?
    press?(:VK_CONTROL) && trigger?(:KEY_V)
  end
end