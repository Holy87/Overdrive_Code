require 'rm_vx_data' if false
#===============================================================================
# Personalizzazione controller di Holy87
# Difficoltà utente: ★
# Versione 1.1
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#
# Changleog
# 1.1   => Possibilità di inserire pulsanti del pad riservati (che non possono
#          essere assegnati)
#===============================================================================
# Questo script vi permette di utilizzare aggiungere nelle opzioni di gioco due
# nuovi comandi che permetteranno al giocatore di configurare a piacimento i
# tasti del proprio controller e la potenza della vibrazione.
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main e sotto gli
# script XInput e Opzioni di gioco. I due script sono necessari per il corretto
# funzionamento, altrimenti va in crash all'avvio.
# Sotto è possibile configurare i testi per le voci e i comandi personalizzabili.
#===============================================================================

#===============================================================================
# ** Impostazioni dello script
#===============================================================================
module ControllerSettings
  #--------------------------------------------------------------------------
  # * Testi per il menu Opzioni
  #--------------------------------------------------------------------------
  CONTROLLER_COMMAND = 'Configura Game Pad'
  CONTROLLER_HELP = 'Imposta i comandi del controller PC'
  VIBRATION_COMMAND = 'Vibrazione'
  VIBRATION_HELP = 'Imposta la potenza della vibrazione del controller'
  RESET_COMMAND = 'Ripristina comandi'
  NO_KEY_SET  = 'Nessun pulsante assegnato'
  HELP_INPUT = 'Premi un tasto sul pad per assegnarlo'
  HELP_KEY  = 'Puoi cambiare i tasti del controller.
Seleziona Ripristina o premi CTRL per resettare.'
  #--------------------------------------------------------------------------
  # * Tasti configurabili nella schermata.
  #--------------------------------------------------------------------------
  INPUTS = [:UP, :DOWN, :LEFT, :RIGHT, :C, :B, :A, :L, :R]
  #--------------------------------------------------------------------------
  # * Tasti da escludere nella selezione
  #--------------------------------------------------------------------------
  EXCLUDED = [:L_AXIS_X, :L_AXIS_Y, :R_AXIS_X, :R_AXIS_Y]
  #--------------------------------------------------------------------------
  # * Pulsanti del pad che non possono essere utilizzati perché riservati
  #--------------------------------------------------------------------------
  RESERVED = [:START]
  #--------------------------------------------------------------------------
  # * Descrizione dei comandi
  #--------------------------------------------------------------------------
  INPUT_DESCRIPTION = {
      :UP     => 'Su',
      :DOWN   => 'Giù',
      :LEFT   => 'Sinistra',
      :RIGHT  => 'Destra',
      :C      => 'Accetta/Interagisci',
      :B      => 'Menu/Indietro',
      :A      => 'Corri',
      :L      => 'Precedente',
      :R      => 'Successivo'
  }
end

#===============================================================================
# ** ATTENZIONE: NON MODIFICARE SOTTO QUESTO SCRIPT SE NON SAI COSA TOCCARE! **
#===============================================================================



$imported = {} if $imported == nil
$imported['H87-PadSettings'] = 1.0

#===============================================================================
# ** ControllerSettings
#-------------------------------------------------------------------------------
# Some core methods
#===============================================================================
module ControllerSettings
  #--------------------------------------------------------------------------
  # * Key scene command creation
  #--------------------------------------------------------------------------
  def self.create_keys_command
    command = {:type => :advanced, :method => :call_keys,
               :text => CONTROLLER_COMMAND, :help => CONTROLLER_HELP,
               :condition => 'Input.controller_connected?'}
    command
  end
  #--------------------------------------------------------------------------
  # * Vibration command creation
  #--------------------------------------------------------------------------
  def self.create_vibration_command
    command = {:type => :bar, :method => :update_vibration,
               :text => VIBRATION_COMMAND, :help => VIBRATION_HELP,
               :condition => 'Input.controller_connected?',
               :var => 0, :max => 100, :val_mt => :get_vibration,
               :distance => 10, :default => 100}
    command
  end
  #--------------------------------------------------------------------------
  # * Excluded keys from the configuration
  #--------------------------------------------------------------------------
  def self.excluded_commands; EXCLUDED; end
end

#--------------------------------------------------------------------------
# * Insert to Options list
#--------------------------------------------------------------------------
H87Options.push_keys_option(ControllerSettings.create_keys_command)
H87Options.push_keys_option(ControllerSettings.create_vibration_command)

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# Scome vocabs
#===============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Command Input friendly name
  #--------------------------------------------------------------------------
  def self.command_name(input)
    ControllerSettings::INPUT_DESCRIPTION[input]
  end
  #--------------------------------------------------------------------------
  # * Help text to input
  #--------------------------------------------------------------------------
  def self.input_window_text
    ControllerSettings::HELP_INPUT
  end
  #--------------------------------------------------------------------------
  # * Help text to key config
  #--------------------------------------------------------------------------
  def self.key_config_help
    ControllerSettings::HELP_KEY
  end
end

#===============================================================================
# ** Option
#-------------------------------------------------------------------------------
# Custom game pad methods
#===============================================================================
class Option
  #--------------------------------------------------------------------------
  # * Calls the key configuration scene
  #--------------------------------------------------------------------------
  def call_keys
    Sound.play_ok
    SceneManager.call(Scene_KeyConfig)
  end
  #--------------------------------------------------------------------------
  # * Updates the user vibration (and vibrate)
  #--------------------------------------------------------------------------
  def update_vibration(value)
    $game_system.set_vibration_rate(value)
    Input.vibrate(100, 100, 20) if SceneManager.scene_is?(Scene_Options)
  end
  #--------------------------------------------------------------------------
  # * Gets the user configured vibration
  #--------------------------------------------------------------------------
  def get_vibration
    $game_system.vibration_rate
  end
end

#===============================================================================
# ** Scene_Options
#-------------------------------------------------------------------------------
# Controller check process
#===============================================================================
class Scene_Options < Scene_MenuBase
  alias h87contr_settings_update update unless $@
  alias h87contr_settings_start start unless $@
  #--------------------------------------------------------------------------
  # * Start
  #--------------------------------------------------------------------------
  def start
    h87contr_settings_start
    @connected = Input.controller_connected?
  end
  #--------------------------------------------------------------------------
  # * Update process
  #--------------------------------------------------------------------------
  def update
    h87contr_settings_update
    update_controller_connection
  end
  #--------------------------------------------------------------------------
  # * Checks if the controller is connected/disconnected during this
  #   scene, and refresh the window
  #--------------------------------------------------------------------------
  def update_controller_connection
    if @connected != Input.controller_connected?
      @connected = Input.controller_connected?
      @option_window.refresh
    end
  end
end

#===============================================================================
# ** Scene_KeyConfig
#-------------------------------------------------------------------------------
# Keys configuration scene
#===============================================================================
class Scene_KeyConfig < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_keys_window
    create_input_window
  end
  #--------------------------------------------------------------------------
  # * Help window creation
  #--------------------------------------------------------------------------
  def create_help_window
    super
    @help_window.set_text(Vocab.key_config_help)
  end
  #--------------------------------------------------------------------------
  # * Keys list window creation
  #--------------------------------------------------------------------------
  def create_keys_window
    y = @help_window.height
    @keys_window = Window_PadKeys.new(0, y, Graphics.width, Graphics.height - y)
    @keys_window.set_handler(:ok, method(:check_command))
    @keys_window.set_handler(:cancel, method(:return_scene))
    @keys_window.set_handler(:reset, method(:reset_keys))
    @keys_window.activate
    @keys_window.index = 0
  end
  #--------------------------------------------------------------------------
  # * Input window creation
  #--------------------------------------------------------------------------
  def create_input_window
    @input_window = Window_Input_Key.new(method(:check_selected_key))
  end
  #--------------------------------------------------------------------------
  # * Checks the selected command
  #--------------------------------------------------------------------------
  def check_command
    if @keys_window.item == :reset
      reset_keys
    else
      open_input_window
    end
  end
  #--------------------------------------------------------------------------
  # * Reset all custom keymap
  #--------------------------------------------------------------------------
  def reset_keys
    $game_system.create_default_key_set
    @keys_window.refresh
    @keys_window.activate
  end
  #--------------------------------------------------------------------------
  # * Opens the key input window
  #--------------------------------------------------------------------------
  def open_input_window
    @input_window.open
  end
  #--------------------------------------------------------------------------
  # * Checks what the user chosen. If the controller is accidentally
  #   disconnected, returns to the previous scene.
  #--------------------------------------------------------------------------
  def check_selected_key
    key = @input_window.selected_key
    if key == 0
      return_scene
    else
      $game_system.xinput_key_set[@keys_window.item] = key
      @keys_window.refresh
      @keys_window.activate
    end
  end
end

#===============================================================================
# ** Window_PadKeys
#-------------------------------------------------------------------------------
# This window contains the editable commands
#===============================================================================
class Window_PadKeys < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @data = ControllerSettings::INPUTS + [:reset]
    refresh
  end
  #--------------------------------------------------------------------------
  # * Item max
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * Item (as Symbol)
  #--------------------------------------------------------------------------
  def item; @data[index]; end
  #--------------------------------------------------------------------------
  # * Draw item
  #--------------------------------------------------------------------------
  def draw_item(index)
    key = @data[index]
    if key
      if key != :reset
        draw_key_command(key, index)
      else
        draw_reset_command(index)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draws a command with friendly name and controller input
  #--------------------------------------------------------------------------
  def draw_key_command(key, index)
    rect = item_rect(index)
    rect.width -= 4
    change_color(normal_color)
    draw_text(rect.x, rect.y, rect.width/2, line_height, Vocab.command_name(key))
    if $game_system.xinput_key_set[key]
      change_color(crisis_color)
      draw_text(rect.width/2, rect.y, rect.width/2, line_height, Vocab.gamepad_key($game_system.xinput_key_set[key]), 1)
    else
      change_color(knockout_color)
      draw_text(rect.width/2, rect.y, rect.width/2, line_height, ControllerSettings::NO_KEY_SET, 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Draws the reset command
  #--------------------------------------------------------------------------
  def draw_reset_command(index)
    rect = item_rect(index)
    rect.width -= 4
    change_color(normal_color)
    draw_text(rect, ControllerSettings::RESET_COMMAND, 1)
  end
  #--------------------------------------------------------------------------
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    process_reset    if handle?(:reset)   && Input.trigger?(:CTRL)
    super
  end
  #--------------------------------------------------------------------------
  # * CTRL key called
  #--------------------------------------------------------------------------
  def process_reset
    call_reset_handler
  end
  #--------------------------------------------------------------------------
  # * Calls the reset process
  #--------------------------------------------------------------------------
  def call_reset_handler
    call_handler(:reset)
  end
end

#===============================================================================
# ** Window_Input_Key
#-------------------------------------------------------------------------------
# This window awaits the user input with the game pad
#===============================================================================
class Window_Input_Key < Window_Base
  attr_reader :selected_key
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param [Method] method
  #--------------------------------------------------------------------------
  def initialize(method)
    width = calc_width
    height = fitting_height(2)
    @closing_method = method
    @selected_key = nil
    @esc_counter = 0
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
    draw_text(0, 0, contents_width, contents_height, Vocab.input_window_text, 1)
  end
  #--------------------------------------------------------------------------
  # * Window opening with input check
  #--------------------------------------------------------------------------
  def open
    @old_packet = XInput.get_state.packet_number
    super
  end
  #--------------------------------------------------------------------------
  # * Update process with key scanning
  #--------------------------------------------------------------------------
  def update
    super
    check_key_delete
    check_forced_close
    update_key_scan
  end
  #--------------------------------------------------------------------------
  # * Detects the first user input. If the controller is disconnected,
  #   closes the window.
  #--------------------------------------------------------------------------
  def update_key_scan
    return unless open?
    return if @closing
    unless Input.controller_connected?
      @selected_key = 0
      close
      return
    end
    keymap = XInput.get_key_state.keys - ControllerSettings.excluded_commands
    key_selection(keymap)
  end
  #--------------------------------------------------------------------------
  # * Key selection process
  # @param [Array] keymap
  #--------------------------------------------------------------------------
  def key_selection(keymap)
    if keymap.any? && XInput.get_state.packet_number != @old_packet
      if ControllerSettings::RESERVED.include?(keymap.first)
        selection_fail
      else
        selection_ok(keymap.first)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Command selection success
  #--------------------------------------------------------------------------
  def selection_ok(key)
    @selected_key = key
    Sound.play_ok
    close
  end
  #--------------------------------------------------------------------------
  # * Command selection failed
  #--------------------------------------------------------------------------
  def selection_fail
    Sound.play_buzzer
  end
  #--------------------------------------------------------------------------
  # * Closes the window for ESC key (on keyboard)
  #--------------------------------------------------------------------------
  def check_forced_close
    return if @esc_counter > 0 or !open?
    if Input.legacy_trigger?(:B)
      Sound.play_cancel
      close
    end
  end
  #--------------------------------------------------------------------------
  # * Deletes the current key assignation
  #--------------------------------------------------------------------------
  def check_key_delete
    return unless open?
    return if @closing
    if Input.legacy_press?(:B)
      @esc_counter += 1
      if @esc_counter >= 50
        @esc_counter = 0
        selection_ok(nil)
      end
    else
      @esc_counter = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Centra la finestra nel campo
  #--------------------------------------------------------------------------
  def center_window
    self.x = (Graphics.width - self.width)/2
    self.y = (Graphics.height - self.height)/2
  end
  #--------------------------------------------------------------------------
  # * Closes the window calling the refresh method
  #--------------------------------------------------------------------------
  def close
    super
    @closing_method.call
  end
  #--------------------------------------------------------------------------
  # * Gets the window width
  #--------------------------------------------------------------------------
  def calc_width; Graphics.width; end
end