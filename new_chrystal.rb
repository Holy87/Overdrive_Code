# CRISTALLO DI SALVATAGGIO - OVERDRIVE
# Questo script mostra la finestra di salvataggio quando ci si interagisce
# con un cristallo di salvataggio.
# La seconda funzione di questo script è permettere il salvataggio dal menu
# quando il giocatore è abbastanza vicino

module ChrystalSettings
  # distanza massima in tile per essere vicino ad un cristallo
  # di salvataggio per poter salvare dal menu
  SAVE_DISTANCE = 2

  # status da aggiungere con il power up
  POWER_UP_STATE = 216

  # animazione sul personaggio quando guarisce tutti
  RECOVER_ANIMATION = 41

  # animazione sul personaggio quando viene potenziato
  POWER_ANIMATION = 442

  # eventi comuni nell'evento che lo identificano come
  # cristallo di salvataggio
  COMMON_EVENTS = [5,6,7]

  HEAL_ALL_VOCAB = 'Cura tutti'
  POWER_UP_VOCAB = 'Potenzia'
  EXIT_VOCAB = 'Indietro'
end

module ChrystalManager

  def self.heal_all
    $game_party.all_members.each{ |member| member.recover_all }
  end

  def self.power_up_all
    $game_party.all_members.each{ |member| member.add_state(216) }
  end
end

module Vocab
  # @return [String]
  def self.heal_all
    ChrystalSettings::HEAL_ALL_VOCAB
  end

  # @return [String]
  def self.power_up_all
    ChrystalSettings::POWER_UP_VOCAB
  end

  def self.chrystal_cancel
    ChrystalSettings::EXIT_VOCAB
  end
end

class Game_Temp
  # tipo di cristallo (:blue, :green, :red)
  # @return [Symbol]
  attr_accessor :chrystal_type
end

class Game_Party < Game_Unit

  # determina se il gruppo si trova vicino ad un cristallo di salvataggio
  def near_save?
    $game_player.near_save_chrystal?
  end
end

class Game_Event < Game_Character
  # determina se l'evento è un cristallo di salvataggio attivo
  # attualmente è determinato dalla chiamata evento comune del
  # cristallo di salvataggio
  # @return [Boolean]
  def save_chrystal?
    return false if @list.nil?
    @list.select { |command| command.code == 117 and ChrystalSettings::COMMON_EVENTS.include?(command.parameters[0]) }.any?
  end
end

class Game_Player < Game_Character
  alias h87_chrystal_check_event_trigger_here check_event_trigger_here unless $@
  alias h87_chrystal_check_event_trigger_there check_event_trigger_there unless $@
  alias h87_chrystal_check_event_trigger_touch check_event_trigger_touch unless $@
  alias h87_chrystal_movable? movable? unless $@

  def check_event_trigger_there(triggers)
    return false if chrystal_process?
    h87_chrystal_check_event_trigger_there(triggers)
  end

  def check_event_trigger_here(triggers)
    return false if chrystal_process?
    h87_chrystal_check_event_trigger_here(triggers)
  end

  def check_event_trigger_touch(x, y)
    return false if chrystal_process?
    h87_chrystal_check_event_trigger_touch(x, y)
  end

  def movable?
    return false if chrystal_process?
    h87_chrystal_movable?
  end

  # determina se l'eroe è vicino ad un cristallo di salvataggio
  # @return [TrueClass, FalseClass]
  def near_save_chrystal?
    save_chrystal = $game_map.nearest_save_chrystal
    return false if save_chrystal.nil?
    $game_map.player_distance_from_event(save_chrystal) <= ChrystalSettings::SAVE_DISTANCE
  end

  private

  def chrystal_process?
    return false unless SceneManager.scene.is_a?(Scene_Map)
    SceneManager.scene.chrystal_process?
  end
end

class Game_Map
  # restituisce tutti i cristalli di salvataggio nella mappa
  # corrente
  # @return [Array<Game_Event>]
  def save_chrystals
    events.select{|_, event| event.save_chrystal? }.map{ |evt| evt[1] }
  end

  # @return [Game_Event]
  def nearest_save_chrystal
    save_chrystals.sort_by{|chrystal| player_distance_from_event chrystal}.first
  end

  # determina la distanza tra eroe ed evento, in tile
  # @param [Game_Event] event
  def player_distance_from_event(event)
    event_distance($game_player, event)
  end

  # determina la distanza tra due oggetti nella mappa, in tile
  # @param [Game_Event, Game_Player] character1
  # @param [Game_Event] character2
  def event_distance(character1, character2)
    Math.sqrt((character1.x - character2.x)**2 + (character1.y - character2.y)**2).to_i
  end
end

class Window_ChrystalCommand < Window_Command
  def initialize
    @type = $game_temp.chrystal_type
    super(0, 0)
    refresh
    update_placement
    self.openness = 0
  end

  def reset
    @type = $game_temp.chrystal_type
    clear_command_list
    make_command_list
    self.height = window_height
    create_contents
    refresh
    update_placement
    self.index = 0
  end

  def window_width
    160
  end

  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end

  def make_command_list
    add_command(Vocab::save, :save)
    add_command(Vocab::partyform_command, :formation, $game_system.formation_enabled) if $game_system.formation_unlocked
    add_command(Vocab::heal_all, :heal) if @type == :green
    add_command(Vocab::power_up_all, :power_up) if @type == :red
    add_command(Vocab::chrystal_cancel, :cancel)
  end
end

class Scene_Map < Scene_Base
  alias h87_chrystal_start start unless $@
  alias h87_chrystal_updade update unless $@
  alias h87_chrystal_terminate terminate unless $@
  alias h87_chrystal_update_call_menu update_call_menu unless $@

  def create_chrystal_window
    @chrystal_window = Window_ChrystalCommand.new
    @chrystal_window.set_handler(:save, method(:call_save))
    @chrystal_window.set_handler(:formation, method(:command_partyform))
    @chrystal_window.set_handler(:heal, method(:command_heal))
    @chrystal_window.set_handler(:power_up, method(:command_power_up))
    @chrystal_window.set_handler(:cancel, method(:close_chrystal_window))
  end

  def close_chrystal_window
    @chrystal_window.close
  end

  def command_power_up
    ChrystalManager.power_up_all
    $game_player.animation_id = ChrystalSettings::POWER_ANIMATION
    close_chrystal_window
  end

  def command_heal
    ChrystalManager.heal_all
    $game_player.animation_id = ChrystalSettings::RECOVER_ANIMATION
    close_chrystal_window
  end

  def command_partyform
    SceneManager.call(Scene_PartyFormation)
  end

  def open_chrystal_window
    @chrystal_window.reset
    @chrystal_window.open
    @chrystal_window.activate
  end

  def update_chrystal_window
    @chrystal_window.update
  end

  def dispose_chrystal_window
    @chrystal_window.dispose
  end

  def chrystal_process?
    @chrystal_window.openness > 0
  end

  def start
    h87_chrystal_start
    create_chrystal_window
  end

  def update
    h87_chrystal_updade
    update_chrystal_window
  end

  def terminate
    h87_chrystal_terminate
    dispose_chrystal_window
  end

  def update_call_menu
    return if chrystal_process?
    h87_chrystal_update_call_menu
  end
end

class Window_MenuCommand < Window_Command
  alias classic_save_enabled save_enabled unless $@

  def save_enabled
    classic_save_enabled or $game_party.near_save?
  end
end

class Game_System
  alias h87_chrystal_formation_grated_position formation_grated_position? unless $@

  def formation_grated_position?
    h87_chrystal_formation_grated_position or $game_party.near_save?
  end
end

class Game_Interpreter
  def call_save_chrystal(chrystal_type)
    return unless SceneManager.scene.is_a?(Scene_Map)
    $game_temp.chrystal_type = chrystal_type
    SceneManager.scene.open_chrystal_window
  end
end