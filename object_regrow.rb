#===============================================================================
# Event Respawn di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script vi permette di creare eventi che respawnano dopo un determinato
# periodo di tempo. Il tempo rappresenta quello reale e non di gioco, questo
# significa che passerà, e gli eventi ricompariranno, anche se il gioco sarà
# chiuso.
# Sostanzialmente si tratta di giocare con gli switch locali, non scompaiono
# e compaiono automaticamente ma bisogna creare una nuova pagina dell'evento
# con grafica trasparente e condizione switch locale A ad ON.
#
# ISTRUZIONI:
# Piazzare come sempre lo script sotto Materials e prima del Main.
# Nei comandi evento, aggiungi un commento con uno dei seguenti tag:
# <RESPAWN IN X HOURS>: l'evento ricomparirà dopo X ore
# <RESPAWN IN X MINUTES>: l'evento ricomparirà dopo X ore
# <RESPAWN IN X DAYS>: l'evento ricomparirà in X giorni
# NOTA 1: "ricomparire" significa che lo Switch Locale A tornerà di nuovo OFF.
#         Quindi ricordati di impostare lo switch locale A su ON per farlo
#         sparire creando ovviamente una nuova pagina senza la grafica.
# NOTA 2: puoi anche scrivere i tag in minuscolo, non fa differenza.
# NOTA 3: puoi cambiare lo switch locale da usare su DEFAULT_LOCAL_SW.
#===============================================================================


# ------------------ NON MODIFICARE OLTRE SE NON SAI SCRIPTARE -----------------

$imported = {} if $imported == nil
$imported['H87_Event_Respawn'] = 1.0

module EventRespawn
  HOURS_RESPAWN = /<RESPAWN IN (\d+) HOURS>/i
  MINUTES_RESPAWN = /<RESPAWN IN (\d+) MINUTES>/i
  DAYS_RESPAWN = /<RESPAWN IN (\d+) DAYS>/i
  P_HOURS_RESPAWN = /<RESPAWN IN (\d+) PLAY HOURS>/i
  P_MINUTES_RESPAWN = /<RESPAWN IN (\d+) PLAY MINUTES>/i

  DEFAULT_LOCAL_SW = 'A'
end

class RPG::Event
  include EventRespawn

  attr_reader :playtime_respawn

  # returns the grow time
  # @return [Integer] the grow time in seconds
  def regrow_time
    time = 0
    @playtime_respawn = false
    all_comments.each do | comment_line |
      case comment_line
      when HOURS_RESPAWN
        time = $1.to_i * 3600
      when MINUTES_RESPAWN
        time = $1.to_i * 3600
      when DAYS_RESPAWN
        time = $1.to_i * 86400
      when P_HOURS_RESPAWN
        time = $1.to_i * 3600 * Graphics.frame_rate
        @playtime_respawn = true
      when P_MINUTES_RESPAWN
        time = $1.to_i * 60 * Graphics.frame_rate
        @playtime_respawn = true
      else
        #niente
      end
    end
    time
  end

  # gets all comments
  # @return [Array<String>]
  def all_comments
    comments = []
    @pages.each do |page|
      comments += page_comments(page)
    end
    comments
  end

  # returns all comments of the current page
  # @return [Array<String>]
  # @param [RPG::Event::Page] page
  def page_comments(page)
    comments = page.list.select {|cmd| [108, 408].include?(cmd.code)}
    comments.collect { |cmd| cmd.parameters[0] }
  end
end


#==============================================================================
# ** Game_Event
#==============================================================================
class Game_Event < Game_Character
  include EventRespawn
  alias h87_regrow_init initialize unless $@

  # @param [Integer] map_id
  # @param [RPG::Event] event
  def initialize(map_id, event)
    h87_regrow_init(map_id, event)
    check_regrow if can_regrow? and harvested?
  end

  # determines if the event can regrow after a certain amount of time
  def can_regrow?
    regrow_time > 0
  end

  # determines if the hevent is harvested
  def harvested?
    return false unless can_regrow?
    $game_self_switches[[@map_id, @id, DEFAULT_LOCAL_SW]] == true
  end

  # updates the local switch and refresh the event if
  # the time is passed and the event must respawn
  def check_regrow
    time = $game_system.regrow_times[[@map_id, @id]]
    return if time.nil?
    if time < Time.now
      $game_self_switches[[@map_id, @id, DEFAULT_LOCAL_SW]] = false
      $game_system.regrow_times[[@map_id, @id]] = nil
      refresh
    end
  end

  # returns the grow time
  # @return [Integer] the grow time in seconds
  def regrow_time
    @event.regrow_time
  end
end

#==============================================================================
# ** Game_RegrowTimes
#------------------------------------------------------------------------------
#  this class contians the respawn date and hour of the regrowing events
#==============================================================================

class Game_RegrowTimes

  # object initialization
  def initialize
    @data = {}
  end

  # gets respawn time of a map event
  # @param [Array<Integer>] key the key [map_id, event_id]
  # @return [Time]
  def [](key)
    @data[key]
  end

  # sets respawn date and hour
  # @param [Array<Integer>] key the key [map_id, event_id]
  # @param [Time] value
  def []=(key, value)
    @data[key] = value
  end
end

#==============================================================================
# ** Game_System
#==============================================================================
class Game_System
  # gets the regrow times object
  # @return [Game_RegrowTimes]
  def regrow_times
    @regrow_times ||= Game_RegrowTimes.new
  end
end

#==============================================================================
# ** Game_Map
#==============================================================================
class Game_Map
  # get the events that can be respawned
  # @return [Hash<Game_Event>]
  def respawning_events
    @events.select{|ev| ev.can_regrow?}
  end

  # get the events that need respawn (loc. switch A enabled)
  # @return [Hash<Game_Event>]
  def events_recharging
    respawning_events.select do |ev|
      key = [@map_id, ev.id, EventRespawn::DEFAULT_LOCAL_SW]
      $game_self_switches[key] == true
    end
  end

  # determines if it is a respawn event
  # @param [Integer] event_id
  def respawning_event?(event_id)
    event_id > 0 and @events[event_id] != nil and @events[event_id].can_regrow?
  end

  # gets the regrowing time of an event
  # @param [Integer] event_id
  def event_regrow_time(event_id)
    @events[event_id].regrow_time
  end
end

#==============================================================================
# ** Game_Interptreter
#==============================================================================
class Game_Interpreter
  alias h87_c123_regr command_123 unless $@

  # Control Self Switch
  def command_123
    h87_c123_regr
    if $game_map.respawning_event?(@original_event_id) and @params[0] == EventRespawn::DEFAULT_LOCAL_SW
      if @params[1] == 0
        time = Time.now + $game_map.event_regrow_time(@original_event_id)
        $game_system.regrow_times[[@map_id, @original_event_id]] = time
      else
        $game_system.regrow_times[[@map_id, @original_event_id]] = nil
      end
    end
  end
end