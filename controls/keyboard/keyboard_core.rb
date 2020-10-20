#===============================================================================
# Interfaccia Tastiera di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script vi permette di ottenere il completo controllo della tastiera e
# sarà una base per script futuri.
# Ecco le emozionanti FICIURS!
# ● Possibilità di rimappare completamente tutti i comandi di gioco ed aggiungere
#    nuovi comandi oltre a quelli già presenti (:C, :A, :X...)
# ● Ottieni il nome del tasto da premere
# ● Segue il layout della tastiera
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main. Se avete lo
# script del Gamepad, installatelo AL DI SOPRA di quest'ultimo.
# Lo script è plug & play, ma è possibile configurarne i tasti.
#
# Alcuni metodi comuni:
# ● Vocab.key_name(key): restituisce il nome del tasto. Ad esempio,
# Vocab.key_name(:C) -> 'BARRA SPAZIATRICE' perché il pulsante di spazio è il primo
# configurato sul comando :C
# Vocab.key_name(:X) -> 'MAIUSC'
# Vocab.key_name(:VK_RETURN) -> 'INVIO' puoi anche specificare direttamente il tasto
# ● Keyboard.caps_lock? -> determina se è attivo il "blocca maiuscole"
# ● Keyboard.num_lock? -> determina se è attivo il "blocca numeri"
# ● Keyboard.unicode_char(codice) -> ok, questo dovrebbe essere utile per script
# di immissione testi. Ottiene il carattere di immissione del tasto tenendo in
# considerazione lo stato ed il layout della tastiera. Perciò, con una tastiera
# italiana, Keyboard.unicode_char(:KEY_E) dovrebbe restituire 'e' in stato normale,
# 'E' se nel frattempo si teneva premuto Maiuscole o se il Bloc Num era attivato, ed
# il simbolo dell'euro '€' se era tenuto premuto il simbolo Alt Gr.
#
# Funzioni in gioco:
# Se inserisci in un box di messaggio \K[x] dove x è il numero del comando (vedi
# in basso), puoi far dire al messaggio il nome del tasto assegnato.
# Esempio
# Usa il tasto \K[0] per correre -> 'Usa il tasto [MAIUSCOLA] per correre'
#
# ■ IMPOSTAZIONI GIOCATORE
# È possibile definire le impostazioni della tastiera che sono memorizzate in
# $game_system per impostare altri tasti per i comandi e aggiungerne anche di
# nuovi.
# Configura DEFAULT_KEY_SET per personalizzare i comandi da dare.
# Nota 1: questo script non sovrascrive le funzioni del tasto F1 e F12.
# Nota 2: le impostazioni del menu F1 verranno ignorate.
#===============================================================================

module Keyboard
  # IMPOSTAZIONI GENERALI
  module Settings

    # CONFIGURAZIONE DEI COMANDI
    # Puoi definire sia direttamente il comando associato, sia un array. In questo
    # caso qualsiasi dei tasti sarà valido.
    DEFAULT_KEY_SET = {
        :UP => [:VK_UP],
        :DOWN => [:VK_DOWN],
        :LEFT => [:VK_LEFT],
        :RIGHT => [:VK_RIGHT],
        :START => [], #not really used by RPG Maker
        :SELECT => [], #not used too, but you can if you want
        :L => [:KEY_Q, :VK_PRIOR],
        :R => [:KEY_W, :VK_NEXT],
        :A => [:VK_SHIFT],
        :B => [:KEY_X, :VK_ESCAPE, :VK_NUMPAD0],
        :C => [:KEY_Z, :VK_RETURN, :VK_SPACE],
        :X => [:KEY_A],
        :Y => [:KEY_S],
        :Z => [:KEY_D],
        :F9 => :VK_F9, # for debug window
        :F12 => :VK_F12, # not used in game
        :CTRL => :VK_CONTROL, # for pass throught objects in debug mode
        :F1 => :VK_F1 # not used in game
    }

    # TRADUZIONI PERSONALIZZATE
    # Talvolta il nome del pulsante restituito da Windows non è molto leggibile.
    # Qui puoi definire una traduzione custom (valido solo se chiami con
    # Vocab::key_name)
    CUSTOM_KEY_TRANSLATION = {
        :VK_UP => 'FR. SU',
        :VK_LEFT => 'FR. SINISTRA',
        :VK_RIGHT => 'FR. DESTRA',
        :VK_DOWN => 'FR. GIÙ',
        :VK_SHIFT => 'MAIUSCOLA',
        :VK_PRIOR => 'PAG. SU',
        :VK_NEXT => 'PAG. GIÙ'
    }

    # Questo array serve per mostrare il nome del tasto nella finestra di messaggio
    # e di aiuto. Ad ogni indice corrisponde un pulsante. Ad esempio, se scrivi \K[0]
    # nel messaggio, mostrerà 'MAIUSCOLA'. Se scrivi \K[Y] mostrerà invece 'S'.
    # NOTA: Se hai installato lo script delle icone tasti, questa configurazione
    # verrà ignorata (usa la configurazione dell'altro script)
    #               0   1   2   3   4   5   6   7   8      9       10   11
    KEY_INDEXES = [:A, :B, :C, :X, :Y, :Z, :L, :R, :LEFT, :RIGHT, :UP, :DOWN]
    # imposta questo valore a true quando vuoi mostrare le parentesi quadre [ e ]
    # quando usi \K nel messaggio. Esempio:
    # Premi \K[:UP] per salire -> Premi [FRECCIA SU] per salire
    USE_BRACKETS = true
    # Imposta un valore diverso da zero se vuoi che il testo del comando sia mostrato
    # in un colore diverso. Il colore dipende dal valore che imposterai.
    CHANGE_COLOR = 2
  end

  # key codes. The documentation can be found at
  # https://docs.microsoft.com/it-it/windows/win32/inputdev/virtual-key-codes
  VK_BACK = 0x08 # BACKSPACE key
  VK_TAB = 0x09 # TAB key
  VK_RETURN = 0x0D # ENTER key
  VK_SHIFT = 0x10 # Shift key
  VK_CONTROL = 0x11 # CTRL key
  VK_MENU = 0x12 # Alt key
  VK_PAUSE = 0x13 # Pause key
  VK_CAPITAL = 0x14 # CAPS LOCK key
  VK_ESCAPE = 0x1B # ESCAPE key
  VK_SPACE = 0x20 # SPACEBAR
  VK_PRIOR = 0x21 # PAGE UP key
  VK_NEXT = 0x22 # PAGE DOWN key
  VK_END = 0x23 # END key
  VK_HOME = 0x24 # HOME key
  VK_LEFT = 0x25 # LEFT ARROW key
  VK_UP = 0x26 # UP ARROW key
  VK_RIGHT = 0x27 # RIGHT ARROW key
  VK_DOWN = 0x28 # DOWN ARROW key
  VK_SELECT = 0x29 # SELECT key
  VK_PRINT = 0x2A # PRINT key
  VK_SNAPSHOT = 0x2C # LEFT ARROW key
  VK_INSERT = 0x2D # INS
  VK_DELETE = 0x2E # DEL
  VK_HELP = 0x2F # HELP

  # numbers
  NUM_0 = 0x30
  NUM_1 = 0x31
  NUM_2 = 0x32
  NUM_3 = 0x33
  NUM_4 = 0x34
  NUM_5 = 0x35
  NUM_6 = 0x36
  NUM_7 = 0x37
  NUM_8 = 0x38
  NUM_9 = 0x39

  # letters
  KEY_A = 0x41
  KEY_B = 0x42
  KEY_C = 0x43
  KEY_D = 0x44
  KEY_E = 0x45
  KEY_F = 0x46
  KEY_G = 0x47
  KEY_H = 0x48
  KEY_I = 0x49
  KEY_J = 0x4A
  KEY_K = 0x4B
  KEY_L = 0x4C
  KEY_M = 0x4D
  KEY_N = 0x4E
  KEY_O = 0x4F
  KEY_P = 0x50
  KEY_Q = 0x51
  KEY_R = 0x52
  KEY_S = 0x53
  KEY_T = 0x54
  KEY_U = 0x55
  KEY_V = 0x56
  KEY_W = 0x57
  KEY_X = 0x58
  KEY_Y = 0x59
  KEY_Z = 0x5A

  # numpad keys
  VK_NUMPAD0 = 0x60
  VK_NUMPAD1 = 0x61
  VK_NUMPAD2 = 0x62
  VK_NUMPAD3 = 0x63
  VK_NUMPAD4 = 0x64
  VK_NUMPAD5 = 0x65
  VK_NUMPAD6 = 0x66
  VK_NUMPAD7 = 0x67
  VK_NUMPAD8 = 0x68
  VK_NUMPAD9 = 0x69
  VK_MULTIPLY = 0x6A
  VK_ADD = 0x6B
  VK_SEPARATOR = 0x6C
  VK_SUBTRACT = 0x6D
  VK_DECIMAL = 0x6E
  VK_DIVIDE = 0x6F

  # function keys
  VK_F1 = 0x70
  VK_F2 = 0x71
  VK_F3 = 0x72
  VK_F4 = 0x73
  VK_F5 = 0x74
  VK_F6 = 0x75
  VK_F7 = 0x76
  VK_F8 = 0x77
  VK_F9 = 0x78
  VK_F10 = 0x79
  VK_F11 = 0x7A
  VK_F12 = 0x7B

  VK_NUMLOCK = 0x90 # NUM Lock

  # control keys
  VK_LSHIFT = 0xA0 # Left SHIFT key
  VK_RSHIFT = 0xA1 # Right SHIFT key
  VK_LCONTROL = 0xA2 # Left CONTROL key
  VK_RCONTROL = 0xA3 # Right CONTROL key
  VK_LMENU = 0xA4 # Left Menu key
  VK_RMENU = 0xA5 # Right MENU key

  # media controls
  VK_MEDIA_NEXT_TRACK = 0xB0 # Next Track key
  VK_MEDIA_PREV_TRACK = 0xB1 # Previous Track key
  VK_MEDIA_STOP = 0xB2 # Stop Media key
  VK_MEDIA_PLAY_PAUSE = 0xB3 # Play/Pause Media key
  VK_VOLUME_MUTE = 0xAD # Volume Mute key
  VK_VOLUME_DOWN = 0xAE # Volume Down key
  VK_VOLUME_UP = 0xAF # Volume Up key

  # Used for miscellaneous characters; some can vary by keyboard.
  VK_OEM_1 = 0xBA # For the US standard keyboard, the ';:' key
  VK_OEM_PLUS = 0xBB # For any country/region, the '+' key
  VK_OEM_COMMA = 0xBC # For any country/region, the ',' key
  VK_OEM_MINUS = 0xBD # For any country/region, the '-' key
  VK_OEM_PERIOD = 0xBE # For any country/region, the '.' key
  VK_OEM_2 = 0xBF # For the US standard keyboard, the '/?' key
  VK_OEM_3 = 0xC0 # For the US standard keyboard, the '`~' key
  VK_OEM_4 = 0xDB # For the US standard keyboard, the '[{' key
  VK_OEM_5 = 0xDC # For the US standard keyboard, the '\|' key
  VK_OEM_6 = 0xDD # For the US standard keyboard, the ']}' key
  VK_OEM_7 = 0xDE # For the US standard keyboard, the 'single-quote/double-quote' key
  VK_OEM_8 = 0xDF # Used for miscellaneous characters; it can vary by keyboard.
  VK_OEM_102 = 0xE2 # Either the angle bracket key or the backslash key on the RT 102-key keyboard

  # Special keyboard keys
  VK_BROWSER_BACK = 0xA6 # Browser Back key
  VK_BROWSER_FORWARD = 0xA7 # Browser Forward key
  VK_BROWSER_REFRESH = 0xA8 # Browser Refresh key
  VK_BROWSER_STOP = 0xA9 # Browser Stop key
  VK_BROWSER_SEARCH = 0xAA # Browser Search key
  VK_BROWSER_FAVORITES = 0xAB # Browser Favorites key
  VK_BROWSER_HOME = 0xAC # Browser Start and Home key
  VK_LAUNCH_MAIL = 0xB4 # Start Mail key
  VK_LAUNCH_MEDIA_SELECT = 0xB5 # Select Media key
  VK_LAUNCH_APP1 = 0xB6 #Start Application 1 key
  VK_LAUNCH_APP2 = 0xB7 # Start Application 2 key

  # Use as MapVirtualKeyEx second parameter function
  # ---------------------------------------------------------------------------------------------------
  # The uCode parameter is a virtual-key code and is translated into an unshifted character value in the
  # low order word of the return value. Dead keys (diacritics) are indicated by setting the top bit of
  # the return value. If there is no translation, the function returns 0.
  MAPVK_VK_TO_CHAR = 2
  # The uCode parameter is a virtual-key code and is translated into a scan code.
  # If it is a virtual-key code that does not distinguish between left- and right-hand keys, the left-hand
  # scan code is returned. If there is no translation, the function returns 0.
  MAPVK_VK_TO_VSC = 0
  # The uCode parameter is a virtual-key code and is translated into a scan code. If it is a virtual-key
  # code that does not distinguish between left- and right-hand keys, the left-hand scan code is returned.
  # If the scan code is an extended scan code, the high byte of the uCode value can contain either 0xe0 or
  # 0xe1 to specify the extended scan code. If there is no translation, the function returns 0.
  MAPVK_VK_TO_VSC_EX = 4
  # The uCode parameter is a scan code and is translated into a virtual-key code that does not distinguish
  # between left- and right-hand keys. If there is no translation, the function returns 0.
  MAPVK_VSC_TO_VK = 1
  # The uCode parameter is a scan code and is translated into a virtual-key code that distinguishes between
  # left- and right-hand keys. If there is no translation, the function returns 0.
  MAPVK_VSC_TO_VK_EX = 3

  # Win32 libraries
  # Retrieves a string that represents the name of a key
  # https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mapvirtualkeyexa
  GetKeyNameTextA = Win32API.new('User32', 'GetKeyNameTextA', 'LPI', 'I')
  # Translates (maps) a virtual-key code into a scan code or character value, or translates a scan code
  # into a virtual-key code. The function translates the codes using the input language and an input
  # locale identifier.
  # https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mapvirtualkeyexa
  MapVirtualKeyEx = Win32API.new('User32', 'MapVirtualKey', 'IIP', 'I')
  GetKeyState = Win32API.new('User32', 'GetKeyState', 'I', 'I')
  GetKeyboardState = Win32API.new('User32', 'GetKeyboardState', 'P', 'I')
  # https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getasynckeystate
  GetAsyncKeyState = Win32API.new('User32', 'GetAsyncKeyState', 'I', 'I')
  GetKeyboardLayout = Win32API.new('User32', 'GetKeyboardLayout', 'I', 'I')
  ToUnicode = Win32API.new('User32', 'ToUnicode', 'IIPPII', 'I')

  # returns a keyboard layout identifier
  # see https://docs.microsoft.com/it-it/windows/win32/intl/language-identifier-constants-and-strings
  # @return [Integer] the keyboard layout identifier
  def self.get_keyboard_layout
    GetKeyboardLayout.call 0
  end

  # gets the key name as Windows named it.
  # @param [Integer, Symbol] key_code
  # @param [Integer] buffer_size
  # @return [String]
  def self.get_key_name_text(key_code, buffer_size = 32)
    key_code = key_symbol_to_code(key_code)
    buffer = ' ' * buffer_size
    scan_code = map_virtual_key(key_code)
    name_size = GetKeyNameTextA.call(scan_code << 16 | (1 << 25), buffer, buffer_size)
    raise KeyboardInputNameError.new("Error processing character #{key_code} name") if name_size == 0
    name = buffer.unpack('A*').first
    return name if name_size > 1
    unicode_to_char(name.codepoints.map { |c| "\\u%04X" % c }.first)
  end

  # The return value is either a scan code, a virtual-key code, or a character value, depending on the value of
  # virtual_key_code and map_type. If there is no translation, the return value is zero.
  # @param [Object] virtual_key_code
  # @param [Integer] map_type
  def self.map_virtual_key(virtual_key_code, map_type = MAPVK_VK_TO_VSC)
    MapVirtualKeyEx.call(virtual_key_code, map_type, get_keyboard_layout)
  end

  # obtains the key state in a 2-bit integer
  # @param [Integer] key
  def self.get_key_state(key)
    GetKeyState.call key
  end

  # returns a 256bit array with the state of each key.
  # ex. get_keyboard_state[KEY_C] -> you get the value
  # @return [Array]
  def self.get_keyboard_state_ary
    get_keyboard_state.unpack('C*')
  end

  def self.get_keyboard_state
    buffer = ' ' * 256
    GetKeyboardState.call(buffer)
    buffer
  end

  # returns the key letter inpuy in relation to the keyboard layout
  # and status (ex. e key + SHIFT -> E)
  # @param [Integer, Symbol] key
  # @param [Integer] buff_size
  # @return [String] the key text
  def self.unicode_char(key, buff_size = 10)
    key = key_symbol_to_code(key)
    buffer = ' ' * buff_size
    res = ToUnicode.call(key, map_virtual_key(key), get_keyboard_state, buffer, buff_size, 0)
    return '' if res != 1
    unicode_to_char(sprintf('\u%04x', buffer.unpack('Q')[0]))
  end

  def self.get_async_key_state(key)
    GetAsyncKeyState.call key
  end

  # determines if a key is pressed
  # @param [Integer, Symbol] key
  # @return [Boolean]
  def self.key_pressed?(key)
    return false if key.nil?
    key = key_symbol_to_code(key)
    get_async_key_state(key).abs & 0x8000 == 0x8000
  end

  # determines if the CAPS LOCK state is on
  # @return [Boolean]
  def self.caps_lock?
    get_key_state(VK_CAPITAL) == 1
  end

  # determines if the NUMPAD LOCK state is on
  # @return [Boolean]
  def self.numpad_lock?
    get_key_state(VK_NUMLOCK) == 1
  end

  # returns the const value from a key button
  # ex. :VK_LSHIFT => 0xA0
  # @param [Symbol, Integer] key_symbol
  # @return [Integer]
  def self.key_symbol_to_code(key_symbol)
    return key_symbol if key_symbol.is_a?(Integer)
    Keyboard.const_get key_symbol
  end

  # Converts an Unicode identifier to a char
  # ex. '\u00E8'  -> 'è'
  #     '\u0034'  -> '4'
  #     '\u20AC'  -> '€'
  # @param [String] code
  # @return [String]
  def self.unicode_to_char(code)
    code.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') }
  end
end

$imported = {} if $imported == nil
$imported['H87-Keyboard'] = 1.0

#===============================================================================
# ** Game_System
#===============================================================================
class Game_System

  # converts the game key symbol with the configured virtual key
  # ex. :UP -> [:VK_UP]
  #     :C  -> [:VK_SPACE, :VK_RETURN, :KEY_Z]
  # @param [Array<Symbol>] original_key
  def adjust_keyboard(original_key)
    if keyboard_set.include? original_key
      keyboard_set[original_key]
    else
      original_key
    end
  end

  # initializes and returns the configured keyboard set
  # this attribute can be customized with a script, so the
  # player can customize the keyboard game mapping
  # @return [Hash]
  def keyboard_set
    @keyboard_set ||= create_default_keyboard_set
  end

  # creates the default keyboard game mapping
  # @return [Hash{Symbol->Array<Symbol>}]
  def create_default_keyboard_set
    #noinspection RubyResolve
    @keyboard_set = Marshal.load(Marshal.dump(Keyboard::Settings::DEFAULT_KEY_SET))
  end
end

#===============================================================================
# ** Vocab
#===============================================================================
module Vocab

  # gets the key name as configured. Example:
  # key_name(:C) -> 'SPACING'
  # key_name(:X) -> 'LEFT SHIFT'
  # Returns the custom traslation CUSTOM_KEY_TRANSLATION if present
  # @param [Symbol, Integer] key
  # @return [String, nil]
  def self.key_name(key)
    if $game_system
      conf = $game_system.keyboard_set
    else
      conf = Keyboard::Settings::DEFAULT_KEY_SET
    end
    if conf.keys.include?(key)
      key = conf[key].is_a?(Array) ? conf[key].first : conf[key]
    end
    if Keyboard::Settings::CUSTOM_KEY_TRANSLATION.include?(key)
      Keyboard::Settings::CUSTOM_KEY_TRANSLATION[key]
    else
      keyboard_button(key)
    end
  end

  # gets the key name
  # @param [Symbol, Integer] key
  # @return [String]
  def self.keyboard_button(key)
    if key.is_a?(Symbol)
      code = Keyboard.key_symbol_to_code(key)
    elsif key.is_a?(Integer)
      code = key
    else
      return '';
    end
    begin
      Keyboard.get_key_name_text(code)
    rescue KeyboardInputNameError => err
      puts err.message
      ''
    end
  end
end

#===============================================================================
# ** Keyboard_Status
#===============================================================================
class Keyboard_Status
  attr_reader :state
  attr_reader :old_state

  def initialize
    @state = keyboard_state
    @old_state = @state
    @timing = [nil] * 256
  end

  def timing(key_symbol)
    @timing[Keyboard.key_symbol_to_code(key_symbol)]
  end

  def update
    @old_state = @state
    @state = keyboard_state
    @timing.each_with_index do |count, index|
      @timing[index] = calculate_timing(count, index)
    end
  end

  def keyboard_state
    Keyboard.get_keyboard_state_ary.map { |x| x > 100 }
  end


  # @param [Symbol, Array<Symbol>] data
  # @return [TrueClass, FalseClass]
  def pressed?(data)
    return key_pressed?(data) if data.is_a?(Symbol)
    data.each { |key| return true if key_pressed?(key) }
    false
  end

  # determines if a key is pressed. needs a symbol as constant name,
  # for ex. :KEY_C. Only KEYBOARD keys, not game as :X, :UP, :L
  # @param [Symbol] key
  def key_pressed?(key)
    hw_key = Keyboard.key_symbol_to_code(key)
    @state[hw_key]
    #Keyboard_Data.key_pressed?(hw_key)
  end

  private

  def calculate_timing(count, index)
    return nil unless @state[index]
    return 0 unless @old_state[index]
    count.nil? ? 0 : count + 1
  end
end

#===============================================================================
# ** Input
#===============================================================================
module Input
  KB_NORMALIZER = {2 => :DOWN, 4 => :LEFT, 6 => :RIGHT, 8 => :UP, 11 => :A,
                   12 => :B, 13 => :C, 14 => :X, 15 => :Y, 16 => :Z, 17 => :L, 18 => :R}
  @keyboard = Keyboard_Status.new

  # @param [Integer, Symbol] key
  # @return [Symbol]
  def self.normalize_keyboard_input(key)
    KB_NORMALIZER[key]
  end

  # @return [Array<Symbol>, Symbol]
  # @param [Symbol, Integer] key
  def self.get_virtual_key(key)
    if $game_system
      $game_system.adjust_keyboard(key)
    elsif Keyboard::Settings::DEFAULT_KEY_SET[key]
      Keyboard::Settings::DEFAULT_KEY_SET[key]
    else
      key
    end
  end

  # update the keyboard status
  def self.update_keyboard_state
    @keyboard.update
  end

  # updates the input status
  def self.update
    update_keyboard_state
  end

  # Direction pressed
  def self.dir4
    return 2 if press?(:DOWN)
    return 4 if press?(:LEFT)
    return 6 if press?(:RIGHT)
    return 8 if press?(:UP)
    0
  end

  # Eight directions pressed
  def self.dir8
    return 1 if press?(:DOWN) and press?(:LEFT)
    return 3 if press?(:DOWN) and press?(:RIGHT)
    return 7 if press?(:UP) and press?(:LEFT)
    return 9 if press?(:UP) and press?(:RIGHT)
    dir4
  end

  # determines if a key is triggered down and then up.
  # You can insert a game key (:X, :L, :UP...) or a keyboard hardware
  # key (:KEY_C, :VK_TAB, :VK_RETURN...)
  # @param [Symbol] key
  def self.trigger?(key)
    return false if key.nil?
    real_key = get_virtual_key(key)
    return v_key_trigger?(real_key) if real_key.is_a?(Symbol)
    return real_key.compact.any? { |k| v_key_trigger?(k) } if real_key.is_a?(Array)
    false
  end

  # determines if a key is continuously pressed.
  # You can insert a game key (:X, :L, :UP...) or a keyboard hardware
  # key (:KEY_C, :VK_TAB, :VK_RETURN...) or an integer representing
  # the key ID.
  # @param [Integer, Symbol] key
  def self.press?(key)
    return false if key.nil?
    key = normalize_keyboard_input(key) if key.is_a?(Integer)
    hw_key = get_virtual_key(key)
    @keyboard.pressed?(hw_key)
  end

  def self.repeat?(key)
    return false if key.nil?
    real_key = get_virtual_key(key)
    return v_key_repeat?(real_key) if real_key.is_a?(Symbol)
    return real_key.compact.any? { |k| v_key_repeat?(k) } if real_key.is_a?(Array)
  end

  # @param [Symbol] key
  def self.v_key_trigger?(key)
    timing = @keyboard.timing(key)
    timing == 0
  end

  # @param [Symbol] key
  def self.v_key_repeat?(key)
    timing = @keyboard.timing(key)
    timing != nil and (timing == 0 or timing == 30 or timing > 30 and timing % 5 == 0)
  end
end

#===============================================================================
# ** Window_Base
#===============================================================================
class Window_Base < Window
  alias h87_k_normal_process_escape process_escape_character unless $@

  def process_escape_character(code, text, pos)
    if code.upcase == 'K'
      process_draw_key_name(obtain_escape_param(text), pos)
      return
    end
    h87_k_normal_process_escape(code, text, pos)
  end

  #--------------------------------------------------------------------------
  # * Draws the key name
  # @param [Integer] index
  # @param [Hash<Integer>] pos
  #--------------------------------------------------------------------------
  def process_draw_key_name(index, pos)
    if $imported['H87-ControllerMapper']
      symbol = Controller_Mapper::Settings::KEY_INDEXES[index]
    else
      symbol = Keyboard::Settings::KEY_INDEXES[index]
    end
    puts "Key not found for index #{index}" if symbol.nil?
    key_name = Vocab.key_name(symbol)
    if use_keyboard_brackets?
      key_name = sprintf('[%s]', key_name)
    end
    if custom_keyboard_color?
      old_color = contents.font.color.clone
      change_color(text_color(Keyboard::Settings::CHANGE_COLOR))
    end
    draw_text(pos[:x], pos[:y], text_size(key_name).width + 2, line_height, key_name)
    change_color(old_color) if custom_keyboard_color?
    pos[:x] += text_size(key_name).width
  end

  def custom_keyboard_color?
    Keyboard::Settings::CHANGE_COLOR > 0
  end

  def use_keyboard_brackets?
    Keyboard::Settings::USE_BRACKETS
  end
end


class KeyboardInputNameError < StandardError

end