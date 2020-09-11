#===============================================================================
# Icone tasti di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
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
# PER SMANETTONI:
# Gli scripter possono usare il metodo delle finestre e delle bitmap
# draw_key_icon(comando, x, y)
# per mostrare l'icona del comando nella finestra, dove nel parametro comando
# inserirete il simbolo del comando (:C, :B, :LEFT, :RIGHT ecc...)
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
    # File immagine delle icone dei tasti del controller
    PAD_ICONS_GRAPHIC = 'GamepadKeys'
    # File immagine delle icone dei tasti della tastiera
    KEY_ICONS_GRAPHIC = 'KeyboardKeys'

    # Comandi del gamepad con le rispettive icone (dell'immagine
    # PAD_ICONS_GRAPHIC)
    PAD_ICONS = {
        # comando         indice
        :DPAD_DOWN      => 0,
        :DPAD_LEFT      => 1,
        :DPAD_UP        => 2,
        :DPAD_RIGHT     => 3,
        :PAD_A          => 4,
        :PAD_B          => 5,
        :PAD_X          => 6,
        :PAD_Y          => 7,
        :DIR_KEY        => 8,
        :LEFT_SHOULDER  => 9,
        :RIGHT_SHOULDER => 10,
        :L_TRIG         => 11,
        :R_TRIG         => 12,
        :L_AXIS_X       => 13,
        :L_AXIS_Y       => 13,
        :R_AXIS_X       => 14,
        :R_AXIS_Y       => 14,
        :L_AXIS_LEFT		=> 13,
        :L_AXIS_RIGHT		=> 13,
        :L_AXIS_UP			=> 13,
        :L_AXIS_DOWN		=> 13,
        :R_AXIS_LEFT		=> 14,
        :R_AXIS_RIGHT		=> 14,
        :R_AXIS_UP			=> 14,
        :R_AXIS_DOWN		=> 14,
        :PAD_BACK       => 15,
        :PAD_START      => 16
    }

    # Tasti della tastiera con le rispettive icone (dell'immagine
    # KEY_ICONS_GRAPHIC)
    KEY_ICONS = {
        :ESC => 0,
        :ENTER => 1,
        :PAG_UP => 2,
        :PAG_DOWN => 3,
        :KEY_A => 4,
        :KEY_S => 5,
        :KEY_D => 6,
        :KEY_DOWN => 7,
        :KEY_LEFT => 8,
        :KEY_UP => 9,
        :KEY_RIGHT => 10,
        :SHIFT => 11,
        :DIR_KEY => 12
    }

    # Settaggi predefiniti della tastiera (ad un comando di gioco,
    # corrisponde un tasto della tastiera).
    DEFAULT_KEY_SET = {
        #input => tasto
        :A => :SHIFT,
        :B => :ESC,
        :C => :ENTER,
        :X => :KEY_A,
        :Y => :KEY_S,
        :Z => :KEY_D,
        :L => :PAG_UP,
        :R => :PAG_DOWN,
        :LEFT => :KEY_LEFT,
        :RIGHT => :KEY_RIGHT,
        :UP => :KEY_UP,
        :DOWN => :KEY_DOWN
    }

    # Questo array serve per mostrare il pulsante nella finestra di messaggio
    # e di aiuto. Ad ogni indice corrisponde un pulsante. Ad esempio, se
    # scrivi \K[2] nel messaggio, mostrerà l'icona del tasto invio della
    # tastiera o del tasto A del gamepad (perché nell'array si riferisce a
    # :C, dato che l'ordine parte da 0)
    #               0   1   2   3   4   5   6   7   8      9       10   11     12
    KEY_INDEXES = [:A, :B, :C, :X, :Y, :Z, :L, :R, :LEFT, :RIGHT, :UP, :DOWN, :DIR_KEY]
  end

# ---------ATTENZIONE: MODIFICARE SOTTO QUESTO PARAGRAFO COMPORTA SERI RISCHI
#           PER IL CORRETTO FUNZIONAMENTO DELLO SCRIPT! -------------


  $imported = {} if $imported == nil
  $imported['H87-ControllerMapper'] = 1.0


  #--------------------------------------------------------------------------
  # * Controller used condition
  #--------------------------------------------------------------------------
  def self.use_controller?
    $imported['H87-XInput'] && Input.controller_connected?
  end
  #--------------------------------------------------------------------------
  # * Gets the bitmap of the proper device (gamepad or keyboard)
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def self.actual_device_keys
    if use_controller?
      Cache.system(Settings::PAD_ICONS_GRAPHIC)
    else
      Cache.system(Settings::KEY_ICONS_GRAPHIC)
    end
  end
  #--------------------------------------------------------------------------
  # * Gets the index of the key icon
  # @param [Symbol] key_symbol
  # @return [Integer]
  #--------------------------------------------------------------------------
  def self.key_icon_index(key_symbol)
    if use_controller?
      index = Settings::PAD_ICONS[$game_system.adjust_buttons(key_symbol)]
    else
      index = Settings::KEY_ICONS[$game_system.adjust_commands(key_symbol)]
    end
    index ? index : -1
  end
end

#===============================================================================
# ** Game_System
#===============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Adjust commands method (so someone can overwrite this method)
  # @param [Symbol] original_key
  # @return [Symbol]
  #--------------------------------------------------------------------------
  def adjust_commands(original_key)
    key_set = Controller_Mapper::Settings::DEFAULT_KEY_SET
    key_set[original_key] ? key_set[original_key] : original_key
  end
end

#===============================================================================
# ** Bitmap
#===============================================================================
class Bitmap
  #--------------------------------------------------------------------------
  # * Draws the key on the bitmap.
  # @param [Symbol] key_symbol
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_key_icon(key_symbol, x, y, enabled = true)
    bitmap = Controller_Mapper.actual_device_keys
    index = Controller_Mapper.key_icon_index(key_symbol)
    rect = Rect.new(index * 24, 0, 24, 24)
    opacity = enabled ? 255 : 128
    blt(x, y, bitmap, rect, opacity)
  end
end

#===============================================================================
# ** Window_Base
#===============================================================================
class Window_Base < Window
  alias h87_normal_process_escape process_character unless $@
  #--------------------------------------------------------------------------
  # * Draws the proper key icon
  # @param [Symbol] key
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def draw_key_icon(key, x, y, enabled = true)
    contents.draw_key_icon(key, x, y, enabled)
  end
  #--------------------------------------------------------------------------
  # * Alias method: process_escape_character
  # @param [String] code
  # @param [String] text
  # @param [Hash<Integer>] pos
  #--------------------------------------------------------------------------
  def process_escape_character(code, text, pos)
    if code.upcase == 'K'
      process_draw_key_icon(obtain_escape_param(text), pos)
      return
    end
    h87_normal_process_escape(code, text, pos)
  end
  #--------------------------------------------------------------------------
  # * Draws the key icon
  # @param [Integer] index
  # @param [Hash<Integer>] pos
  #--------------------------------------------------------------------------
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
  #--------------------------------------------------------------------------
  # * Overwrite method
  #--------------------------------------------------------------------------
  def draw_key_command(key, index)
    rect = item_rect(index)
    rect.width -= 4
    change_color(normal_color)
    draw_text(rect.x, rect.y, rect.width/2, line_height, Vocab.command_name(key))
    if $game_system.xinput_key_set[key]
      if Controller_Mapper.key_icon_index(key) >= 0
        x = rect.width/4 * 3
        draw_key_icon(key, x, rect.y)
      else
        change_color(crisis_color)
        draw_text(rect.width/2, rect.y, rect.width/2, line_height, Vocab.gamepad_key($game_system.xinput_key_set[key]), 1)
      end
    else
      change_color(knockout_color)
      draw_text(rect.width/2, rect.y, rect.width/2, line_height, ControllerSettings::NO_KEY_SET, 1)
    end
  end
end
end