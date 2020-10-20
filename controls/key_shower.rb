#===============================================================================
# Icone tasti di Holy87
# Difficoltà utente: ★
# Versione 2.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#
# Novità: supporto alla gestione completa della tastiera e genera automaticamente
# le icone dei tasti A-Z, 0-9 e simboli.
#===============================================================================
# Questo script vi permette di mostrare l'icona del pulsante del comando nel
# gioco. La peculiarità principale di questo script è che sa riconoscere se
# il giocatore sta usando un controller ed i comandi configurati, e mostrare
# l'icona appropriata del tasto. Esempio:
# Si vuole mostrare al giocatore il messaggio "Premi [Tasto corsa] per correre"
# Quello che bisogna fare è scrivere nel box del messaggio
# "Premi \K[0] per correre", dove \K è il nuovo comando del messaggio e 0 è
# l'ID del comando (puoi controllare gli ID in basso nella configurazione,
# dove è definito KEY_INDEXES)
# Al giocatore verrà mostrato al posto di \K[0]
# ● L'icona del tasto SHIFT sulla tastiera, se ha solo la tastiera;
# ● L'icona del tasto Y del controller, se il controller è collegato;
# ● Oppure l'icona del tasto che il giocatore ha scelto di configurare nelle
#   opzioni di gioco come corsa.
#
# Per quanto riguarda la tastiera, è possibile far generare molti dei tasti
# senza dover creare una grafica per ognuno. Ad esempio, puoi creare una
# grafica dedicata per Spazio, Invio ecc... ma non vuoi perdere tempo nel
# creare tutti i tasti dalla A alla Z, i numeri ed i simboli. Nella grafica
# dei pulsanti della tastiera, usa il primo quadrato per il colore del testo
# ed il secondo per il tasto vuoto... Lo script farà il resto!
#
# PER SMANETTONI:
# Gli scripter possono usare il metodo delle finestre e delle bitmap
# draw_key_icon(comando, x, y) -> disegna l'icona del pulsante del pad o della
# tastiera a seconda di quale sia quello attivo per mostrare l'icona del comando
# nella finestra, dove nel parametro comando inserirete il simbolo del comando
# (:C, :B, :LEFT, :RIGHT ecc...)
# draw_keyboard_icon(comando, x, y) -> disegna l'icona della tastiera
# draw_gamepad_icon(comando, x, y) -> disegna l'icona del controller anche se
# non collegato
#
#
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main e sotto lo
# script di configurazione del controller (se presente, ma non è necessario
# averlo se non si vuole usarlo)
#===============================================================================

#===============================================================================
# ** Impostazioni dello script
#===============================================================================
module Controller_Mapper
  module Settings
    # Questo array serve per mostrare il pulsante nella finestra di messaggio
    # e di aiuto. Ad ogni indice corrisponde un pulsante. Ad esempio, se
    # scrivi \K[2] nel messaggio, mostrerà l'icona del tasto invio della
    # tastiera o del tasto A del gamepad (perché nell'array si riferisce a
    # :C, dato che l'ordine parte da 0)
    #               0   1   2   3   4   5   6   7   8      9       10   11     12
    KEY_INDEXES = [:A, :B, :C, :X, :Y, :Z, :L, :R, :LEFT, :RIGHT, :UP, :DOWN, :DIR_KEY]

    # File immagine delle icone dei tasti del controller
    PAD_ICONS_GRAPHIC = 'GamepadKeys'
    # File immagine delle icone dei tasti della tastiera
    KEY_ICONS_GRAPHIC = 'KeyboardKeys'

    # Comandi del gamepad con le rispettive icone (dell'immagine
    # PAD_ICONS_GRAPHIC)
    PAD_ICONS = {
        # comando         indice
        :DPAD_DOWN => 0,
        :DPAD_LEFT => 1,
        :DPAD_UP => 2,
        :DPAD_RIGHT => 3,
        :PAD_A => 4,
        :PAD_B => 5,
        :PAD_X => 6,
        :PAD_Y => 7,
        :DIR_KEY => 8,
        :LEFT_SHOULDER => 9,
        :RIGHT_SHOULDER => 10,
        :L_TRIG => 11,
        :R_TRIG => 12,
        :L_AXIS_X => 13,
        :L_AXIS_Y => 13,
        :R_AXIS_X => 14,
        :R_AXIS_Y => 14,
        :L_AXIS_LEFT => 13,
        :L_AXIS_RIGHT => 13,
        :L_AXIS_UP => 13,
        :L_AXIS_DOWN => 13,
        :R_AXIS_LEFT => 14,
        :R_AXIS_RIGHT => 14,
        :R_AXIS_UP => 14,
        :R_AXIS_DOWN => 14,
        :PAD_BACK => 15,
        :PAD_START => 16,
        :LEFT_THUMB => 17,
        :RIGHT_THUMB => 18
    }

    # Tasti della tastiera con le rispettive icone (dell'immagine
    # KEY_ICONS_GRAPHIC)
    KEY_ICONS = {
        :VK_ESCAPE => 3,
        :VK_RETURN => 4,
        :VK_PRIOR => 5,
        :VK_NEXT => 6,
        :VK_DOWN => 7,
        :VK_LEFT => 8,
        :VK_UP => 9,
        :VK_RIGHT => 10,
        :VK_SHIFT => 11,
        :DIR_KEY => 12
    }

    # Indice del bitmap dei tasti della tastiera dove ottenere
    # il colore della lettera
    FOREGROUND_COLOR_KEY_ICON_INDEX = 0
    # indice del bitmap dei tasti della tastiera dove ottenere
    # il tasto vuoto da scrivere
    EMPTY_KEY_ICON_INDEX = 1
    # rettangolo delle coordinate su cui scrivere la lettera
    #                  X  Y  LARG ALT
    GENERATION_RECT = [3, 2, 19, 17]

    # Impostazioni del font del pulsante per l'auto-generazione
    GENERATION_FONT_NAME = 'Arial'
    GENERATION_FONT_SIZE = 15
    GENERATION_FONT_BOLD = true
    GENERATION_FONT_ITALIC = false
    GENERATION_FONT_SHADOW = false
    GENERATION_FONT_OUTLINE = false


    # Inserisci qui i tasti che genereranno l'icona automaticamente. L'icona
    # generata prenderà l'unica lettera o simbolo che costituisce il nome
    # del tasto. Assicurati che il nome del tasto non sia composto da più
    # di un carattere, in caso contrario potresti avere degli artefatti.
    # Puoi personalizzare il nome del tasto nello script dell'interfaccia da
    # tastiera aggiungendolo in CUSTOM_KEY_TRANSLATION e cambiando, ad esempio,
    # il tasto :VK_BACKSPACE con il simbolo 🔙 per essere stampato.
    GENERATED_KEY_ICONS = [
        :NUM_0, :NUM_1, :NUM_2, :NUM_3, :NUM_4, :NUM_5, :NUM_6, :NUM_7, :NUM_8,
        :NUM_9, :KEY_A, :KEY_B, :KEY_C, :KEY_D, :KEY_E, :KEY_F, :KEY_G, :KEY_H,
        :KEY_I, :KEY_J, :KEY_K, :KEY_L, :KEY_M, :KEY_N, :KEY_O, :KEY_P, :KEY_Q,
        :KEY_R, :KEY_S, :KEY_T, :KEY_U, :KEY_V, :KEY_W, :KEY_X, :KEY_Y, :KEY_Z,
        :VK_OEM_1, :VK_OEM_PLUS, :VK_OEM_COMMA, :VK_OEM_MINUS,
        :VK_OEM_PERIOD, :VK_OEM_2, :VK_OEM_3, :VK_OEM_4, :VK_OEM_5, :VK_OEM_6,
        :VK_OEM_7, :VK_OEM_8, :VK_OEM_102
    ]
  end

  # ---------ATTENZIONE: MODIFICARE SOTTO QUESTO PARAGRAFO COMPORTA SERI RISCHI
  #           PER IL CORRETTO FUNZIONAMENTO DELLO SCRIPT! -------------


  $imported = {} if $imported == nil
  $imported['H87-ControllerMapper'] = 2.0


  # Controller used condition
  def self.use_controller?
    $imported['H87-XInput'] && Input.controller_connected?
  end

  # determines if the key icon is defined in KEY_ICONS setting
  # @param [Symbol] key
  def self.key_has_custom_icon?(key)
    Settings::KEY_ICONS.keys.include?(key)
  end

  # determines if the key has an auto-generated or custom icon
  # @param [Symbol] key
  def self.key_has_icon?(key)
    return true if key_has_custom_icon?(key)
    return true if Settings::GENERATED_KEY_ICONS.include?(key)
    false
  end
end

module Cache
  include Controller_Mapper::Settings

  # @param [Symbol] key
  # @return [Bitmap]
  def self.generated_keyboard_icon(key)
    @generated_keys ||= {}
    @generated_keys[key] = generate_key(Vocab.keyboard_button(key)) if @generated_keys[key].nil?
    @generated_keys[key]
  end

  # @param [String] key_name
  # @return [Bitmap]
  def self.generate_key(key_name)
    bitmap = Bitmap.new(24, 24)
    background = system(KEY_ICONS_GRAPHIC)
    rect = Rect.new(24 * EMPTY_KEY_ICON_INDEX, 0, 24, 24)
    bitmap.blt(0, 0, background, rect)
    color = background.get_pixel(24 * FOREGROUND_COLOR_KEY_ICON_INDEX, 0)
    bitmap.font.color = color
    bitmap.font.size = GENERATION_FONT_SIZE
    bitmap.font.name = GENERATION_FONT_NAME
    bitmap.font.bold = GENERATION_FONT_BOLD
    bitmap.font.italic = GENERATION_FONT_ITALIC
    bitmap.font.outline = GENERATION_FONT_OUTLINE
    bitmap.font.shadow = GENERATION_FONT_SHADOW
    params = GENERATION_RECT
    rect = Rect.new(params[0], params[1], params[2], params[3])
    bitmap.draw_text(rect, key_name, 1)
    bitmap
  end
end

#===============================================================================
# ** Game_System
#===============================================================================
class Game_System
  # @param [Symbol] command
  # @return [Symbol]
  def best_key_representation(command)
    keys = adjust_keyboard(command)
    return command if keys.nil?
    return keys if keys.is_a?(Symbol)
    return nil if keys.size == 0
    return keys.first if keys.size == 1
    #noinspection RubyArgCount
    icons = keys.select { |key| Controller_Mapper.key_has_icon?(key) }
    return icons.first unless icons.empty?
    keys.first
  end
end

#===============================================================================
# ** Bitmap
#===============================================================================
class Bitmap

  # Draws the key on the bitmap.
  # @param [Symbol] key_symbol
  # @param [Integer] x
  # @param [Integer] y
  def draw_key_icon(key_symbol, x, y, enabled = true)
    return draw_gamepad_icon(key_symbol, x, y, enabled) if Controller_Mapper.use_controller?
    draw_keyboard_icon(key_symbol, x, y, enabled)
  end

  # force drawing the controller key icon
  # @param [Symbol] key_symbol
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  def draw_gamepad_icon(key_symbol, x, y, enabled = true)
    bitmap = Cache.system(Controller_Mapper::Settings::PAD_ICONS_GRAPHIC)
    index = Controller_Mapper::Settings::PAD_ICONS[$game_system.adjust_buttons(key_symbol)]
    return if index.nil?
    return if index < 0
    rect = Rect.new(index * 24, 0, 24, 24)
    opacity = enabled ? 255 : 128
    blt(x, y, bitmap, rect, opacity)
  end

  # force drawing the keyboard key icon
  # @param [Symbol] key_symbol
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  def draw_keyboard_icon(key_symbol, x, y, enabled = true)
    key = $game_system.best_key_representation(key_symbol)
    return draw_custom_keyboard_key_icon(key, x, y, enabled) if Controller_Mapper.key_has_custom_icon?(key)
    draw_generated_keyboard_icon(key, x, y, enabled)
  end

  private

  # draws an auto-generated key icon (with letter)
  # @param [Symbol] key
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  def draw_generated_keyboard_icon(key, x, y, enabled = true)
    key_bmp = Cache.generated_keyboard_icon(key)
    return if key_bmp.nil?
    rect = Rect.new(0, 0, 24, 24)
    blt(x, y, key_bmp, rect, enabled ? 255 : 128)
  end

  # draws the keyboard key icon graphic loaded in System folder
  # @param [Symbol] key_symbol
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  def draw_custom_keyboard_key_icon(key_symbol, x, y, enabled = true)
    bitmap = Cache.system(Controller_Mapper::Settings::KEY_ICONS_GRAPHIC)
    index = Controller_Mapper::Settings::KEY_ICONS[$game_system.adjust_keyboard(key_symbol)]
    return if index < 0
    rect = Rect.new(index * 24, 0, 24, 24)
    opacity = enabled ? 255 : 128
    blt(x, y, bitmap, rect, opacity)
  end
end

#===============================================================================
# ** Window_Base
#===============================================================================
class Window_Base < Window
  alias h87_normal_process_escape process_escape_character unless $@
  # Draws the proper key icon using automatically keyboard or
  # gamepad if connected
  # @param [Symbol] key
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  def draw_key_icon(key, x, y, enabled = true)
    contents.draw_key_icon(key, x, y, enabled)
  end

  # force drawing the keyboard icon
  # @param [Symbol] key
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  def draw_keyboard_icon(key, x, y, enabled = true)
    contents.draw_keyboard_icon(key, x, y, enabled)
  end

  # force drawing the gamepad icon
  # @param [Symbol] key
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  def draw_gamepad_icon(key, x, y, enabled = true)
    contents.draw_gamepad_icon(key, x, y, enabled)
  end

  # Alias method: process_escape_character
  # @param [String] code
  # @param [String] text
  # @param [Hash<Integer>] pos
  def process_escape_character(code, text, pos)
    if code.upcase == 'K'
      process_draw_key(obtain_escape_param(text), pos)
      return
    end
    h87_normal_process_escape(code, text, pos)
  end

  # draws the key - gamepad icon, keyboard icon or key name
  # @param [Integer] index
  # @param [Hash] pos
  def process_draw_key(index, pos)
    symbol = Controller_Mapper::Settings::KEY_INDEXES[index]
    puts "Key not found for index #{index}" if symbol.nil?
    return process_draw_key_icon(index, pos) if Controller_Mapper.use_controller?
    key = $game_system.best_key_representation(symbol)
    if Controller_Mapper.key_has_icon?(key)
      process_draw_key_icon(index, pos)
    else
      process_draw_key_name(index, pos)
    end

  end

  # Draws the key icon
  # @param [Integer] index
  # @param [Hash<Integer>] pos
  def process_draw_key_icon(index, pos)
    symbol = Controller_Mapper::Settings::KEY_INDEXES[index]
    puts "Key not found for index #{index}" if symbol.nil?
    draw_key_icon(symbol, pos[:x], pos[:y])
    pos[:x] += 24
  end
end

if $imported['H87-PadSettings'] # for showing the icons in the configuration
  #===============================================================================
  # ** Window_PadKeys
  #===============================================================================
  class Window_PadKeys < Window_Selectable
    # Overwrite method
    def draw_key_command(key, index)
      rect = item_rect(index)
      rect.width -= 4
      change_color(normal_color)
      draw_text(rect.x, rect.y, rect.width / 2, line_height, Vocab.command_name(key))
      if $game_system.xinput_key_set[key]
        if Controller_Mapper::Settings::PAD_ICONS[$game_system.adjust_buttons(key)] >= 0
          x = rect.width / 4 * 3
          draw_gamepad_icon(key, x, rect.y)
        else
          change_color(crisis_color)
          draw_text(rect.width / 2, rect.y, rect.width / 2, line_height, Vocab.gamepad_key($game_system.xinput_key_set[key]), 1)
        end
      else
        change_color(knockout_color)
        draw_text(rect.width / 2, rect.y, rect.width / 2, line_height, ControllerSettings::NO_KEY_SET, 1)
      end
    end
  end
end

if $imported['H87-Keyboard_Settings']
  #===============================================================================
  # ** Input_Setting_Wrapper
  #===============================================================================
  class Input_Setting_Wrapper
    # determines if icon can be drawn
    def has_icon?
      return false if @key.nil?
      Controller_Mapper.key_has_icon?(@key)
    end
  end

  #===============================================================================
  # ** Window_KeyboardKeys
  #===============================================================================
  class Window_KeyboardKeys < Window_Selectable
    alias draw_text_key_command draw_key_command unless $@

    # @param [Input_Setting_Wrapper] key_obj
    # @param [Integer] index
    def draw_key_command(key_obj, index)
      return draw_text_key_command(key_obj, index) unless key_obj.has_icon?
      rect = item_rect(index)
      rect.width -= 4
      enabled = enable?(key_obj)
      return if key_obj.key.nil?
      x = rect.x + rect.width / 2 - 12
      draw_keyboard_icon(key_obj.key, x, rect.y, enabled)
    end
  end
end