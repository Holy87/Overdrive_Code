module Keyboard
  module Settings
    DEFAULT_KEY_SET = {
        :UP     => [Keyboard::VK_UP],
        :DOWN   => [Keyboard::VK_DOWN],
        :LEFT   => [Keyboard::VK_LEFT],
        :RIGHT  => [Keyboard::VK_RIGHT],
        :START  => [], #not really used by RPG Maker
        :SELECT => [], #not used too
        :L      => [Keyboard::KEY_Q, Keyboard::VK_PRIOR],
        :R      => [Keyboard::KEY_W, Keyboard::VK_NEXT],
        :A      => [Keyboard::VK_SHIFT],
        :B      => [Keyboard::VK_ESCAPE, Keyboard::KEY_X, Keyboard::VK_NUMPAD0],
        :C      => [Keyboard::VK_SPACE, Keyboard::VK_RETURN, Keyboard::KEY_Z],
        :X      => [Keyboard::KEY_A],
        :Y      => [Keyboard::KEY_S],
        :Z      => [Keyboard::KEY_D]
    }
  end

  # key codes. The documentation can be found at
  # https://docs.microsoft.com/it-it/windows/win32/inputdev/virtual-key-codes
  VK_BACK       = 0x08 # BACKSPACE key
  VK_TAB        = 0x09 # TAB key
  VK_RETURN     = 0x0D # ENTER key
  VK_SHIFT      = 0x10 # Shift key
  VK_CONTROL    = 0x11 # CTRL key
  VK_MENU       = 0x12 # Alt key
  VK_PAUSE      = 0x13 # Pause key
  VK_CAPITAL    = 0x14 # CAPS LOCK key
  VK_ESCAPE     = 0x1B # ESCAPE key
  VK_SPACE      = 0x20 # SPACEBAR
  VK_PRIOR      = 0x21 # PAGE UP key
  VK_NEXT       = 0x22 # PAGE DOWN key
  VK_END        = 0x23 # END key
  VK_HOME       = 0x24 # HOME key
  VK_LEFT       = 0x25 # LEFT ARROW key
  VK_UP         = 0x26 # UP ARROW key
  VK_RIGHT      = 0x27 # RIGHT ARROW key
  VK_DOWN       = 0x28 # DOWN ARROW key
  VK_SELECT     = 0x29 # SELECT key
  VK_PRINT      = 0x2A # PRINT key
  VK_SNAPSHOT   = 0x2C # LEFT ARROW key
  VK_INSERT     = 0x2D # INS
  VK_DELETE     = 0x2E # DEL
  VK_HELP       = 0x2F # HELP

  # numbers
  NUM_0         = 0x30
  NUM_1         = 0x31
  NUM_2         = 0x32
  NUM_3         = 0x33
  NUM_4         = 0x34
  NUM_5         = 0x35
  NUM_6         = 0x36
  NUM_7         = 0x37
  NUM_8         = 0x38
  NUM_9         = 0x39

  # letters
  KEY_A         = 0x41
  KEY_B         = 0x42
  KEY_C         = 0x43
  KEY_D         = 0x44
  KEY_E         = 0x45
  KEY_F         = 0x46
  KEY_G         = 0x47
  KEY_H         = 0x48
  KEY_I         = 0x49
  KEY_J         = 0x4A
  KEY_K         = 0x4B
  KEY_L         = 0x4C
  KEY_M         = 0x4D
  KEY_N         = 0x4E
  KEY_O         = 0x4F
  KEY_P         = 0x50
  KEY_Q         = 0x51
  KEY_R         = 0x52
  KEY_S         = 0x53
  KEY_T         = 0x54
  KEY_U         = 0x55
  KEY_V         = 0x56
  KEY_W         = 0x57
  KEY_X         = 0x58
  KEY_Y         = 0x59
  KEY_Z         = 0x5A

  # numpad keys
  VK_NUMPAD0    = 0x60
  VK_NUMPAD1    = 0x61
  VK_NUMPAD2    = 0x62
  VK_NUMPAD3    = 0x63
  VK_NUMPAD4    = 0x64
  VK_NUMPAD5    = 0x65
  VK_NUMPAD6    = 0x66
  VK_NUMPAD7    = 0x67
  VK_NUMPAD8    = 0x68
  VK_NUMPAD9    = 0x69
  VK_MULTIPLY   = 0x6A
  VK_ADD        = 0x6B
  VK_SEPARATOR  = 0x6C
  VK_SUBTRACT   = 0x6D
  VK_DECIMAL    = 0x6E
  VK_DIVIDE     = 0x6F

  # function keys
  VK_F1         = 0x70
  VK_F2         = 0x71
  VK_F3         = 0x72
  VK_F4         = 0x73
  VK_F5         = 0x74
  VK_F6         = 0x75
  VK_F7         = 0x76
  VK_F8         = 0x77
  VK_F9         = 0x78
  VK_F10        = 0x79
  VK_F11        = 0x7A
  VK_F12        = 0x7B

  VK_NUMLOCK    = 0x90 # NUM Lock

  # control keys
  VK_LSHIFT     = 0xA0 # Left SHIFT key
  VK_RSHIFT     = 0xA1 # Right SHIFT key
  VK_LCONTROL   = 0xA2 # Left CONTROL key
  VK_RCONTROL   = 0xA3 # Right CONTROL key
  VK_LMENU      = 0xA4 # Left Menu key
  VK_RMENU      = 0xA5 # Right MENU key

  # media controls
  VK_MEDIA_NEXT_TRACK = 0xB0 # Next Track key
  VK_MEDIA_PREV_TRACK = 0xB1 # Previous Track key
  VK_MEDIA_STOP       = 0xB2 # Stop Media key
  VK_MEDIA_PLAY_PAUSE = 0xB3 # Play/Pause Media key

  # Used for miscellaneous characters; some can vary by keyboard.
  VK_OEM_1      = 0xBA # For the US standard keyboard, the ';:' key
  VK_OEM_PLUS   = 0xBB # For any country/region, the '+' key
  VK_OEM_COMMA  = 0xBC # For any country/region, the ',' key
  VK_OEM_MINUS  = 0xBD # For any country/region, the '-' key
  VK_OEM_PERIOD = 0xBE # For any country/region, the '.' key
  VK_OEM_2      = 0xBF # For the US standard keyboard, the '/?' key
  VK_OEM_3      = 0xC0 # For the US standard keyboard, the '`~' key
  VK_OEM_4      = 0xDB # For the US standard keyboard, the '[{' key
  VK_OEM_5      = 0xDC # For the US standard keyboard, the '\|' key
  VK_OEM_6      = 0xDD # For the US standard keyboard, the ']}' key
  VK_OEM_7      = 0xDE # For the US standard keyboard, the 'single-quote/double-quote' key
  VK_OEM_8      = 0xDF # Used for miscellaneous characters; it can vary by keyboard.
  VK_OEM_102    = 0xE2 # Either the angle bracket key or the backslash key on the RT 102-key keyboard

  # Win32 libraries
  GetKeyNameTextA = Win32API.new('User32', 'GetKeyNameTextA', 'LPI','I')
  GetKeyState = Win32API.new('User32', 'GetKeyState', 'I', 'I')
  GetKeyboardState = Win32API.new('User32', 'GetKeyboardState', 'P', 'I')
  GetAsyncKeyState = Win32API.new('User32', 'GetAsyncKeyState', 'I', 'I')
  GetKeyboardLayout = Win32API.new('User32', 'GetKeyboardLayout', 'I','I')
  ToUnicode = Win32API.new('User32', 'ToUnicode', 'IIPPII', 'I')

  # gets the key name
  # @param [Integer] key_id
  # @param [Integer] buffer_size
  # @return [String]
  def self.key_name(key_id, buffer_size = 32)
    buffer = " " * buffer_size
    resp = GetKeyNameTextA.call(key_id, buffer, buffer_size)
    if resp == 0
      buffer.unpack('A')
    else
      raise KeyboardInputNameError.new("Error processing character #{key_id} name")
    end
  end

  # obtains the key state in a 2-bit integer
  # the
  def self.get_key_state(key)
    GetKeyState.call key
  end

  def self.get_keyboard_state
    buffer = ' ' * 256
    GetKeyboardState.call(buffer)
    buffer
  end

  def self.get_async_key_state(key)
    GetAsyncKeyState.call key
  end

  # returns the key letter in relation to the keyboard layout
  # @param [Integer] key
  # @param [Integer] buff_size
  # @return [String] the key text
  def self.unicode_char(key, buff_size = 10)
    buffer = ' ' * buff_size
    res = ToUnicode.call(key, get_async_key_state(key), get_keyboard_state, buffer, buff_size, 0)
    res >= 0 ? buffer.unpack('A') : ''
  end

  # determines if a key is pressed
  # @param [Integer] key
  # @return [Boolean]
  def self.key_pressed?(key)
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

  # returns a keyboard layout identifier
  # see https://docs.microsoft.com/it-it/windows/win32/intl/language-identifier-constants-and-strings
  # @return [Integer] the keyboard layout identifier
  def self.get_keyboard_layout
    GetKeyboardLayout.call 0
  end
end

class Game_System
  def adjust_keyboard(original_key)
    if keyboard_set.include? original_key
      keyboard_set[original_key]
    else
      original_key
    end
  end

    # @return [Hash]
    def keyboard_set
    @keyboard_set ||= create_default_keyboard_set
    @keyboard_set
  end

  def create_default_keyboard_set
    @keyboard_set = Keyboard::Settings::DEFAULT_KEY_SET
  end
end

module Input
  @kb_timing = {}
  @kb_state = {}
  @old_kb_state = {}
  @mode = :default
  @default_keys = Keyboard::Settings::DEFAULT_KEY_SET.keys

  def self.update

  end

  def self.trigger?(key)
    real_key = adjust_kb_button(key)
    timing = @kb_timing[real_key]
    timing == 0
  end

  def self.press?(key)

  end

  def self.adjust_kb_button(key)
    if $game_system
      $game_system.adjust_keyboard(key)
    elsif Keyboard::Settings::DEFAULT_KEY_SET[key]
      Keyboard::Settings::DEFAULT_KEY_SET[key]
    else
      key
    end
  end
end

class KeyboardInputNameError < StandardError
  
end