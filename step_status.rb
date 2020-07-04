#===============================================================================
# ** STATI CHE SVANISCONO CAMMINANDO **
# Versione: 1.1 (19/04/2020)
# Difficoltà utente: ★★
#===============================================================================
# DESCRIZIONE:
# Questo script fa in modo che uno stato alterato che perdura su mappa, svanisca
# dopo un certo numero di passi.
# Si può anche fare in modo che la duara dello stato venga mostrata su mappa.
#===============================================================================
# UTILIZZO:
# Installare lo script sotto Materials e prima del Main.
# Inserire nel blocco delle note dello status, le seguenti etichette:
# <durata passi: x> per fare in modo che lo stato alterato svanisca dopo x
# passi sulla mappa.
# <barra visibile>, per fare in modo che, se un eroe ha quello stato alterato,
# venga mostrata un contatore in alto a destra dello schermo, che mostra quanto
# resta perchè svanisca.
#===============================================================================
# COMPATIBILITA':
# Compatibile con quasi tutti gli script.
#===============================================================================
# NOTE:
# È possibile personalizzare la grafica del contatore su mappa.
#===============================================================================
module H87_StepStates
#===============================================================================
# ** CONFIGURAZIONE **
#===============================================================================
#Quanto dev'essere larga la finestra del contatore su mappa?
  L_Finestra = 150

  #Quanto dev'essere spessa (in pixel) la barra che mostra la durata?
  BAR_HEIGHT   = 2

  #Personalizza i colori della barra:
  #Rosso  #Verde    #Blu    #Trasparenza
  Colore    = [0,     250,      100,    255] #Barra piena
  Sfondo    = [255,   0,        0,      150] #Barra vuota
  Bordo     = [0,     0,        0,      150] #Bordo della barra

  #===============================================================================
  # ** FINE CONFIGURAZIONE **
  # Attenzione: Non modificare ciò che c'è oltre, a meno che tu non sappia ciò che
  # fai!
  #===============================================================================


  #stringhe
  ActorStep    = /<(?:DURATA PASSI|durata passi):[ ]*(\d+)>/i
  ShowGauge    = /<(?:BARRA VISIBILE|barra visibile)>/i
end

$imported = {} if $imported == nil
$imported["H87_StepStates"] = 1.1

#===============================================================================
# ** Classe RPG::State
#===============================================================================
class RPG::State
  attr_accessor :actor_duration #durata passi
  attr_accessor :gauge_visible  #visibile su mappa?
  #-----------------------------------------------------------------------------
  # * Carica cache
  #-----------------------------------------------------------------------------
  def carica_cache_personale4
    return if @cache_caricata4
    @cache_caricata4 = true
    @party_duration = 0
    @actor_duration = 0
    @gauge_visible = false
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
      when H87_StepStates::ActorStep
        @actor_duration = $1.to_i
      when H87_StepStates::ShowGauge
        @gauge_visible = true
      else
        # type code here
      end
    }
  end
end #state

#===============================================================================
# ** Classe Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  #-----------------------------------------------------------------------------
  # *Alias metodo load_bt_database
  #-----------------------------------------------------------------------------
  alias carica_db4 load_bt_database unless $@
  def load_bt_database
    carica_db4
    carica_stati4
  end
  #-----------------------------------------------------------------------------
  # *Alias metodo load_database
  #-----------------------------------------------------------------------------
  alias carica_db_24 load_database unless $@
  def load_database
    carica_db_24
    carica_stati4
  end
  #-----------------------------------------------------------------------------
  # Inizializza nel caricamento
  #-----------------------------------------------------------------------------
  def carica_stati4
    $data_states.compact.each { |state| state.carica_cache_personale4 }
  end
end # scene_title

#===============================================================================
# ** Classe Game_Battler
#===============================================================================
class Game_Battler
  #attr_accessor :step_states_count      #Conteggio passi

  #-----------------------------------------------------------------------------
  # * Alias metodo add_state
  #-----------------------------------------------------------------------------
  alias h87ss_as add_state unless $@
  # @param [Integer] state_id
  def add_state(state_id)
    h87ss_as(state_id)
    if actor?
      add_step_state($data_states[state_id])
      $scene.update_step_states if $scene.is_a?(Scene_Map)
    end
  end

  # Alias metodo remove_state
  alias h87ss_rs remove_state unless $@
  def remove_state(state_id)
    h87ss_rs(state_id)
    if actor?
      remove_step_state(state_id)
      $scene.update_step_states if $scene.is_a?(Scene_Map)
    end
  end

  # Aggiungi uno stato alla lista dei passi
  # @param [RPG::State] state
  def add_step_state(state)
    @step_states_count = {} if @step_states_count == nil
    @step_states_count[state.id] = state.actor_duration
  end
  #-----------------------------------------------------------------------------
  # * Rimuovi lo stato dalla lista
  #-----------------------------------------------------------------------------
  def remove_step_state(id)
    @step_states_count = {} if @step_states_count == nil
    @step_states_count.delete(id)
  end

  # Restituisce la lista degli ID stati che svaniscono a passi
  # @return [Hash]
  def step_states_count
    @step_states_count ||= {}
  end

  # @param [Integer] state_id
  # @return [Integer]
  def remaining_state_steps(state_id)
    return 0 if @step_states_count.nil?
    return 0 if @step_states_count[state_id].nil?
    @step_states_count[state_id]
  end
  #-----------------------------------------------------------------------------
  # * Diminuisce di 1 passo tutti gli stati
  #-----------------------------------------------------------------------------
  def scale_step_state
    step_states_count.each_key do |state_id|
      step_states_count[state_id] -= 1
      if step_states_count[state_id] == 0
        remove_state(state_id)
      end
    end
  end

  # @return [Array<RPG::State>]
  def states_visible_on_map
    states.select { |state| state.gauge_visible and remaining_state_steps(state.id) > 0}
  end
end #game_battler

#===============================================================================
# ** Classe Game_Party
#===============================================================================
class Game_Party < Game_Unit
  #-----------------------------------------------------------------------------
  # * Incrementa i passi
  #-----------------------------------------------------------------------------
  alias h87ss_is increase_steps unless $@
  def increase_steps
    h87ss_is
    $game_party.members.each { |member| member.scale_step_state }
    $scene.update_step_states if $scene.is_a?(Scene_Map)
  end
end #game_party

#===============================================================================
# ** Classe Game_Map
#===============================================================================
class Scene_Map < Scene_Base
  #-----------------------------------------------------------------------------
  # * Alias metodo Start
  #-----------------------------------------------------------------------------
  alias h87start_ss start  unless $@
  def start
    h87start_ss
    create_visible_states_window
  end
  #-----------------------------------------------------------------------------
  # * Alias metodo Terminate
  #-----------------------------------------------------------------------------
  alias h87terminate_ss terminate  unless $@
  def terminate
    h87terminate_ss
    delete_visible_states_window
  end
  #-----------------------------------------------------------------------------
  # * Crea la finestra
  #-----------------------------------------------------------------------------
  def create_visible_states_window
    @visible_states_window = Window_StatusName.new
  end
  #-----------------------------------------------------------------------------
  # * Aggiorna la finestra
  #-----------------------------------------------------------------------------
  def update_step_states
    @visible_states_window.refresh if @visible_states_window != nil
  end
  #-----------------------------------------------------------------------------
  # * Elimina la finestra
  #-----------------------------------------------------------------------------
  def delete_visible_states_window
    @visible_states_window.dispose
  end
end #scene_map

#===============================================================================
# ** Classe Window_StatusName
#===============================================================================
class Window_StatusName < Window_Base
  include H87_StepStates
  #-----------------------------------------------------------------------------
  # * Inizializzazione
  #-----------------------------------------------------------------------------
  def initialize
    super(Graphics.width-L_Finestra,0,L_Finestra,Graphics.height)
    self.opacity = 0
    refresh
  end

  # Refresh
  def refresh
    contents.clear
    contents.font.size = 18
    $game_party.battle_members.each_with_index do |member, line|
      next if member.states_visible_on_map.empty?
      draw_actor_visible_states(line, member)
    end
  end

  # @param [Integer] line
  # @param [Game_Actor] actor
  def draw_actor_visible_states(line, actor)
    y = line * line_height
    draw_actor_little_face(actor, 0, y)
    draw_active_states(32, y, actor)
  end

  # @param [Integer] y
  # @param [Game_Actor] actor
  def draw_active_states(x, y, actor)
    actor.states_visible_on_map.each_with_index do |state, i|
      draw_state_with_bar(actor, state, x + i*24, y)
    end
  end

  # @param [Game_Actor] actor
  # @param [RPG::State] state
  # @param [Integer] x
  # @param [Integer] y
  def draw_state_with_bar(actor, state, x, y)
    draw_icon(state.icon_index, x, y)
    draw_state_gauge(actor, state, x, y)
  end

  # * Disegna la barra dei passi mancanti
  # @param [Game_Actor] actor
  # @param [RPG::State] state
  # @param [Integer] x
  # @param [Integer] y
  def draw_state_gauge(actor, state, x, y)
    steps = actor.remaining_state_steps(state.id)
    width = 20
    x += 2
    y += 20
    height = BAR_HEIGHT
    color = Color.new(Colore[0],Colore[1],Colore[2],Colore[3])
    bg_color = Color.new(Sfondo[0],Sfondo[1],Sfondo[2],Sfondo[3])
    border_color  = Color.new(Bordo[0], Bordo[1], Bordo[2], Bordo[3])
    rate = steps.to_f/state.actor_duration.to_f
    fill_width = width * rate
    contents.fill_rect(x-1, y-1, width+2, height+2, border_color)
    contents.fill_rect(x, y, width, height, bg_color)
    contents.fill_rect(x, y, fill_width, height, color)
  end
end #finestra_status