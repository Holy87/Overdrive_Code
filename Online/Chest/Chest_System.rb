#===============================================================================
# ** Game_Map
#-------------------------------------------------------------------------------
# Aggiunge il controllo degli scrigni online e li mostra chiusi o aperti.
#===============================================================================
class Game_Map
  alias h87_mc_setup_events setup_events unless $@
  # Settaggio Eventi
  def setup_events
    h87_mc_setup_events
    begin
      refresh_magic_chests
    rescue Exception => e
      Logger.error e.message
    end
  end

  # Controllo dello stato degli scrigni magici
  def refresh_magic_chests
    @map.events.each_value do |event|
      if event.name =~ Chest_Service::CHEST_REGX
        chest_state =  Chest_Service.get_online_state_chest($1)
        case chest_state
        when Chest_Service::CHEST_EMPTY
          local_a = true
          local_b = false
        when Chest_Service::CHEST_FULL
          local_a = false
          local_b = false
        when Chest_Service::DATA_ERROR
          local_a = false
          local_b = true
        else
          local_a = false
          local_b = true
        end
        sw_a = [@map_id, event.id, 'A']
        sw_b = [@map_id, event.id, 'B']
        $game_self_switches[sw_a] = local_a
        $game_self_switches[sw_b] = local_b
      end
    end
  end

  # Restituisce l'evento con ID richiesto
  # @param [Integer] event_id
  # @return [RPG::Event]
  def event_data(event_id)
    @map.events[event_id]
  end
end


#==================================================================1=============
# ** Game_Temp
#-------------------------------------------------------------------------------
# Aggiunta la memorizzazione dello scrigno per passarlo tra le schermate
#===============================================================================
class Game_Temp
  # @return [Local_Chest] chest
  attr_accessor :chest
end

#===============================================================================
# ** Game_Interpreter
#-------------------------------------------------------------------------------
# Comandi evento per il controllo
#===============================================================================
# noinspection RubyResolve
class Game_Interpreter
  # Restituisce il nome dell'evento
  # @return [String]
  def event_name
    $game_map.event_data(@event_id).name;
  end

  # restituisce il codice dello scrigno dimensionale
  # @return [String, nil]
  def event_chest_id
    event_name.match(Chest_Service::CHEST_REGX)[1]
  end

  # restituice le informazioni scaricate dello scrigno
  # @return [Online_Chest]
  def online_chest
    @online_chest
  end

  def can_use_online?
    $game_system.can_upload?
  end

  # Restituisce true se lo scrigno è pieno
  def chest_full?
    online_chest.full?
  end

  # Restituisce true se lo scrigno è vuoto
  def chest_empty?
    online_chest.empty?
  end

  # Ottiene l'oggetto online (e lo rimuove dallo scrigno)
  # @return [Online_Chest, Fixnum]
  def loot_online_chest
    @online_chest = Chest_Service.loot_chest(event_chest_id)
  end

  # Aggiunge all'inventario l'oggetto ottenuto
  def gain_chest_item
    $game_party.gain_item(online_chest.item, 1)
  end

  # Restituisce true se l'oggetto è stato immesso dallo stesso giocatore
  def item_same_player?
    online_chest.of_same_player?
  end

  # Restituisce true se i dati di login non sono corretti
  def login_error?
    !online_chest.ok? and online_chest.item_type == Online::PLAYER_UNREGISTERED
  end

  # Restituisce true se c'è un problema di connessione
  def loot_connection_error?
    !online_chest.ok? and online_chest.item_type == Online::DATA_ERROR
  end

  # Restituisce true se c'è un problema di connessione (dopo inserimento)
  def fill_connection_error?
    !$game_temp.chest.connected?;
  end

  def chest_already_full?
    $game_temp.chest.response == Chest_Service::CHEST_FULL
  end

  # Inserisce nei dati temporanei lo scrigno per passarlo alla schermata
  def load_chest_data
    $game_temp.chest = Chest_Service.map_chest_info(event_name);
  end

  # invio del feedback di ringraziamento
  def send_chest_fame
    Chest_Service.send_feedback(Chest_Service::FAME, online_chest)
  end

  # invio del feedback di sconfitta
  def send_chest_infame
    Chest_Service.send_feedback(Chest_Service::INFAME, online_chest)
  end

  # Un oggetto è stato selezionato?
  def chest_item_selected?
    $game_temp.chest.item != nil;
  end

  # L'oggetto è stato correttamente inserito nello scrigno?
  def chest_filled?
    $game_temp.chest.fill_ok?;
  end

  # Restituisce true se lo scrigno è pieno
  # viene chaiamato prima di provare ad
  # inserire un oggetto, nel caso qualcuno l'abbia
  # già riempito
  def online_state_chest_full?
    Chest_Service.get_online_state_chest(event_chest_id) == Chest_Service::CHEST_FULL;
  end

  def call_chest_fill_scene
    load_chest_data
    $game_temp.next_scene = "fill_chest"
  end
end

class Scene_Map < Scene_Base
  alias h87_chest_update_scene_change update_scene_change unless $@

  def update_scene_change
    return if $game_player.moving?
    #noinspection RubyResolve
    if $game_temp.next_scene == "fill_chest"
      call_fill_chest
    else
      h87_chest_update_scene_change
    end
  end

  def call_fill_chest
    #noinspection RubyResolve
    $game_temp.next_scene = nil
    SceneManager.call(Scene_Chest)
  end
end
