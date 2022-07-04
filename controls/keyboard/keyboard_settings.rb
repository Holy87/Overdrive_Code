#===============================================================================
# Personalizzazione tastiera di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script vi permette di aggiungere nelle opzioni di gioco una nuova voce
# che permetterà al giocatore di personalizzare i pulsanti della tastiera per
# eseguire i vari comandi nel gioco. Puoi definire più tasti per ogni
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main e sotto gli
# script Interfaccia Tastiera e Opzioni di gioco. I due script sono necessari
# per il corretto funzionamento, altrimenti va in crash all'avvio.
# Sotto è possibile configurare i testi per le voci e i comandi personalizzabili.
#===============================================================================

#===============================================================================
# ** Impostazioni dello script
#===============================================================================
module Keyboard
  module Settings
    KEYBOARD_COMMAND = 'Tastiera'
    KEYBOARD_HELP = 'Imposta i pulsanti della tastiera.'
    HELP_INPUT = 'Premi un tasto per assegnarlo, ESC per annullare.'
    HELP_KEY = 'Puoi cambiare i pulsanti della tastiera.
Seleziona Ripristina o premi %s per resettare.'
    RESET_KEY_COMMAND = 'Reimposta tutto'
    ASSIGNED_ERROR = 'Il tasto %s è già assegnato a %s.'
    RESERVED_ERROR = 'Non puoi usare %s.'

    # Tasti configurabili nella schermata. Nota che puoi aggiungere
    # anche :X, :Y e :Z, nonché i nuovi :START e :SELECT.
    # Sono configurabili solo se i comandi sono ARRAY
    INPUTS = [:UP, :DOWN, :LEFT, :RIGHT, :C, :B, :A, :L, :R, :START]

    # Descrizione dei comandi.
    INPUT_DESCRIPTION = {
        :UP => 'Su',
        :DOWN => 'Giù',
        :LEFT => 'Sinistra',
        :RIGHT => 'Destra',
        :C => 'Accetta/Interagisci',
        :B => 'Menu/Indietro',
        :A => 'Corri',
        :L => 'Precedente',
        :R => 'Successivo',
        :START => 'Pausa'
    }

    # Comandi che sono in sola lettura così da non bloccare il giocatore
    # per un'errata configurazione
    BLOCKED_CONFIGURATIONS = [] #es. :UP, :SELECT, :START

    # Numero massimo di tasti configurabili della tastiera per ogni
    # comando. Ad esempio per :L sono usabili :KEY_Q e :VK_PRIOR.
    # Per :C invece ce ne sono 3, ma :VK_RETURN è riservato per il
    # Reset Key (nulla vieta di fare come ti pare, comunque)
    MAX_CONFIGURABLE = 2

    # Pulsanti della tastiera che possono essere utilizzati per il gioco
    PERMITTED_KEYS = [:NUM_0, :NUM_1, :NUM_2, :NUM_3, :NUM_4, :NUM_5, :NUM_6, :NUM_7,
                      :NUM_8, :NUM_9, :KEY_A, :KEY_B, :KEY_C, :KEY_D, :KEY_E, :KEY_F,
                      :KEY_G, :KEY_H, :KEY_I, :KEY_J, :KEY_K, :KEY_L, :KEY_M, :KEY_N,
                      :KEY_O, :KEY_P, :KEY_Q, :KEY_R, :KEY_S, :KEY_T, :KEY_U, :KEY_V,
                      :KEY_W, :KEY_X, :KEY_Y, :KEY_Z, :VK_OEM_1, :VK_OEM_PLUS,
                      :VK_OEM_COMMA, :VK_OEM_MINUS, :VK_OEM_PERIOD, :VK_OEM_2,
                      :VK_OEM_3, :VK_OEM_4, :VK_OEM_5, :VK_OEM_6, :VK_OEM_7,
                      :VK_OEM_8, :VK_OEM_102, :VK_TAB, :VK_BACK, :VK_MENU,
                      :VK_SPACE, :VK_PRIOR, :VK_NEXT, :VK_END, :VK_HOME, :VK_SELECT,
                      :VK_INSERT, :VK_SHIFT, :VK_UP, :VK_DOWN, :VK_RIGHT, :VK_LEFT,
                      :VK_RETURN, :VK_CONTROL, :VK_NUMPAD0, :VK_NUMPAD1, :VK_NUMPAD2,
                      :VK_NUMPAD3, :VK_NUMPAD4, :VK_NUMPAD5, :VK_NUMPAD6, :VK_NUMPAD7,
                      :VK_NUMPAD8, :VK_NUMPAD9, :VK_MULTIPLY, :VK_ADD, :VK_SEPARATOR,
                      :VK_SUBTRACT, :VK_DECIMAL, :VK_DIVIDE
    ]

    # Pulsanti della tastiera che NON possono essere rimossi o riassegnati
    FIXED_KEYS = [:VK_RETURN, :VK_CONTROL, :VK_ESCAPE, :VK_UP, :VK_DOWN, :VK_RIGHT, :VK_LEFT]

    # Pulsante della tastiera da usare per resettare tutti i tasti
    RESET_KEY = :VK_CONTROL

    # Pulsante della tastiera da usare per annullare l'immissione
    CANCEL_KEY = :VK_ESCAPE

    # Impedisci di selezionare un tasto già assegnato ad un altro comando
    # se è l'unico assegnato a quel comando.
    BLOCK_ALREADY_ASSIGNED = true
  end

  def self.create_keys_command
    command = {:type => :advanced,
               :method => :call_keyboard_configuration,
               :text => Settings::KEYBOARD_COMMAND,
               :help => Settings::KEYBOARD_HELP}
    command
  end
end

H87Options.push_keys_option(Keyboard.create_keys_command)
$imported = {} if $imported == nil
$imported['H87-Keyboard_Settings'] = 1.0

module Vocab
  def self.keyboard_config_help
    sprintf(Keyboard::Settings::HELP_KEY, Vocab.key_name(Keyboard::Settings::RESET_KEY))
  end

  def self.command_name(command)
    Keyboard::Settings::INPUT_DESCRIPTION[command]
  end

  def self.keyboard_input_window_help_text
    Keyboard::Settings::HELP_INPUT
  end
end

class Option
  def call_keyboard_configuration
    Sound.play_ok
    SceneManager.call(Scene_KeyboardConfig)
  end
end

class Game_System
  def configure_key(command, key, index = 0)
    delete_key(key)
    keyboard_set[command][index] = key
  end

  def delete_key(key)
    keyboard_set.keys.each do |command|
      keys = keyboard_set[command]
      if keys.is_a?(Symbol)
        keyboard_set[command] = nil if keys == key
      else
        keys.each_with_index { |_key, index| keys[index] = nil if _key == key }
      end
    end
  end
end


class Scene_KeyboardConfig < Scene_MenuBase
  def start
    super
    create_help_window
    create_key_list_window
    create_input_window
  end

  def create_help_window
    super
    @help_window.set_text Vocab::keyboard_config_help
  end

  def create_key_list_window
    y = @help_window.height
    @keys_window = Window_KeyboardKeys.new(0, y, Graphics.width, Graphics.height - y)
    @keys_window.set_handler(:ok, method(:check_command))
    @keys_window.set_handler(:cancel, method(:return_scene))
    @keys_window.set_handler(:reset, method(:reset_keys))
    @keys_window.activate
    @keys_window.index = 0
  end

  def create_input_window
    @input_window = Window_KeyInput.new(method(:check_selected_key))
  end

  def check_command
    if @keys_window.item == :reset
      reset_keys
    else
      open_input_window
    end
  end

  def reset_keys
    Sound.play_load
    $game_system.create_default_keyboard_set
    @keys_window.refresh
    @keys_window.activate
  end

  def open_input_window
    @input_window.open(@keys_window.item.key)
  end

  def check_selected_key
    if @input_window.selected_key != nil
      $game_system.configure_key(
          @keys_window.item.command,
          @input_window.selected_key,
          @keys_window.item.index
      )
      @keys_window.refresh
    end
    @keys_window.activate
  end
end

#===============================================================================
# ** Input_Setting_Wrapper
#-------------------------------------------------------------------------------
# This is a container for command -> key association
#===============================================================================
class Input_Setting_Wrapper
  attr_accessor :command
  attr_accessor :key
  attr_accessor :index

  def initialize(command, key, index)
    @command = command
    @key = key
    @index = index
  end

  def editable?
    return false if Keyboard::Settings::BLOCKED_CONFIGURATIONS.include?(@command)
    return true if @key.nil?
    return false if Keyboard::Settings::FIXED_KEYS.include?(@key)
    true
  end
end

#===============================================================================
# ** Window_KeyInput
#-------------------------------------------------------------------------------
# This window awaits the user input with the keyboard
#===============================================================================
class Window_KeyInput < Window_Base
  attr_reader :selected_key

  def initialize(method)
    width = calc_width
    height = fitting_height(2)
    @closing_method = method
    @selected_key = nil
    @old_key = nil
    super(0, 0, width, height)
    center_window
    self.openness = 0
    refresh
  end

  #--------------------------------------------------------------------------
  # * Refreshj
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color normal_color
    draw_text(0, 0, contents_width, line_height, Vocab.keyboard_input_window_help_text, 1)
  end

  #--------------------------------------------------------------------------
  # * Update process with key scanning
  #--------------------------------------------------------------------------
  def update
    super
    update_key_scan
  end

  def open(key = nil)
    refresh
    @old_key = key
    super()
  end

  # * Detects the first user input
  def update_key_scan
    return unless open?
    return if @closing
    return selection_ok(nil) if canceled?
    key_selection
  end

  def canceled?
    Input.trigger?(Keyboard::Settings::CANCEL_KEY)
  end

  # Key selection process
  def reserved_fail(selected)
    text = sprintf(Keyboard::Settings::RESERVED_ERROR, selected)
    show_failure(text)
  end

  def key_selection
    selected = triggered_key
    return if selected.nil?
    assigned = already_assigned?(selected)
    return assigned_fail(assigned, selected) if assigned
    return reserved_fail(selected) if reserved?(selected)
    selection_ok selected
  end

  # @param [Symbol] key
  # @return [Symbol, nil]
  def already_assigned?(key)
    return unless Keyboard::Settings::BLOCK_ALREADY_ASSIGNED
    return if @old_key == key
    Keyboard::Settings::INPUTS.each do |command|
      next if $game_system.keyboard_set[command].compact.size > 1
      return command if $game_system.keyboard_set[command].compact.first == key
    end
    nil
  end

  def reserved?(key)
    Keyboard::Settings::FIXED_KEYS.include?(key)
  end

  def triggered_key
    Keyboard::Settings::PERMITTED_KEYS.each {|k| return k if Input.trigger?(k)}
    nil
  end

  # * Command selection success
  def selection_ok(key)
    @selected_key = key
    key.nil? ? Sound.play_cancel : Sound.play_ok
    close
  end

  # * Command selection failed
  def assigned_fail(command, key)
    text = sprintf(Keyboard::Settings::ASSIGNED_ERROR, Vocab.key_name(key), Vocab.command_name(command))
    show_failure text
  end

  def show_failure(text)
    Sound.play_buzzer
    contents.clear_rect(0, line_height, contents_width, line_height)
    change_color(knockout_color)
    draw_text(0, line_height, contents_width, line_height, text, 1)
    change_color(normal_color)
  end

  # * Centra la finestra nel campo
  def center_window
    self.x = (Graphics.width - self.width) / 2
    self.y = (Graphics.height - self.height) / 2
  end

  # Closes the window calling the refresh method
  def close
    super
    @closing_method.call
  end

  # * Gets the window width
  def calc_width
    Graphics.width
  end
end

#===============================================================================
# ** Window_KeyboardKeys
#-------------------------------------------------------------------------------
# This window show the configurable commands and assigned keys.
#===============================================================================
class Window_KeyboardKeys < Window_Selectable
  def initialize(x, y, width, height)
    super
    refresh
  end

  def make_item_list
    @data = []
    Keyboard::Settings::INPUTS.each do |command|
      Keyboard::Settings::MAX_CONFIGURABLE.times do |index|
        key = $game_system.keyboard_set[command][index]
        @data.push(Input_Setting_Wrapper.new(command, key, index))
      end
    end
    @data.push(:reset)
  end

  def col_max
    Keyboard::Settings::MAX_CONFIGURABLE
  end

  def item_max
    @data ? @data.size : 0
  end

  # @param [Integer] index
  # @return [Symbol, Input_Setting_Wrapper]
  def item(index = @index)
    @data[index]
  end

  def command_description_width
    Graphics.width / 3
  end

  def draw_command_names
    Keyboard::Settings::INPUTS.each_with_index do |input, index|
      draw_text(0, index * line_height, command_description_width, line_height, Vocab.command_name(input))
    end
  end

  def refresh
    make_item_list
    super
    draw_command_names
  end

  # @param [Integer] index
  # @return [Rect]
  def item_rect(index)
    rect = super(index)
    if item(index).is_a?(Symbol)
      rect.x = 0
      rect.width = contents_width
    else
      rect.x += command_description_width
    end
    rect
  end

  def item_width
    (width - command_description_width - standard_padding * 2 + spacing) / col_max - spacing
  end

  def draw_item(index)
    key = @data[index]
    return unless key
    return draw_reset_command(index) if key == :reset
    draw_key_command(key, index)
  end

  # @param [Symbol, Input_Setting_Wrapper] key
  def enable?(key)
    return true if key.is_a? Symbol
    key.editable?
  end

  def current_item_enabled?
    enable?(@data[index])
  end

  # @param [Input_Setting_Wrapper] key_obj
  # @param [Integer] index
  def draw_key_command(key_obj, index)
    rect = item_rect(index)
    rect.width -= 4
    enabled = enable?(key_obj)
    return if key_obj.key.nil?
    change_color(normal_color, enabled)
    draw_text(rect, Vocab.key_name(key_obj.key), 1)
  end

  def draw_reset_command(index)
    rect = item_rect(index)
    rect.width = contents_width
    rect.x = 0
    rect.width -= 4
    change_color(normal_color)
    draw_text(rect, Keyboard::Settings::RESET_KEY_COMMAND, 1)
  end

  # Handling Processing for OK and Cancel Etc.
  def process_handling
    return unless open? && active
    process_reset if handle?(:reset) && Input.trigger?(:CTRL)
    super
  end

  # CTRL key called
  def process_reset
    call_reset_handler
  end

  # Calls the reset process
  def call_reset_handler
    call_handler(:reset)
  end
end

