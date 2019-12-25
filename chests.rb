require File.expand_path('rm_vx_data')

#===============================================================================
# ** Chest_Core
#-------------------------------------------------------------------------------
# Contiene i metodi di collegamento base con il server.
#===============================================================================
module Chest_Core
  CHEST_REGX = /<mc:[ ]+(.+),(\d+)>/i
  RESP_CHEST_FULL = 'full'
  RESP_SAME = 'same'
  RESP_NO_DATA = 'nodata'
  RESP_LOGIN_ERR = 'loginerror'
  CONN_ERROR = -2
  NORMAL_CHEST = -2
  FAME = 0
  INFAME = 1
  #--------------------------------------------------------------------------
  # * Controllo online dello stato
  #    chest_key: nome dello scrigno
  # @param [String] chest_key
  # @return [String]
  #--------------------------------------------------------------------------
  def get_online_state_chest(chest_key)
    request = '/chest_check.php?chest=' + base64_encode(chest_key)
    response = await_response(HTTP.domain + request)
    base64_decode(response) != RESP_CHEST_FULL
  end
  #--------------------------------------------------------------------------
  # * Tenta di prendere l'oggetto dallo scrigno online.
  #    event_name: nome dell'evento (da cui prendere il nome dello scrigno)
  #    restituisce:
  #    ● un oggetto Online_Chest se il collegamento è andato a buon fine
  #    ● -2 se c'è stato un problema di connessione
  # @param [String] event_name
  # @return [Online_Chest]
  #--------------------------------------------------------------------------
  def get_chest_item(event_name)
    if event_name =~ CHEST_REGX
      key = $1
      player = $game_system.player
      params = {
          chest: key,
          game_id: player.id,
          player_name: player.name
      }
      # vecchie chiamate per get
      #data = base64_encode([key, player.id, player.name]*",")
      #request = "/chest_take.php?get=" + data
      url = Online.api_path + '/chest_take.php'
      tries = 0
      response = nil
      while response.nil? && tries < 3
        #response = await_response(HTTP.domain + request)
        begin
          response = submit_post_request(url, params)
          tries += 1
        rescue
          return CONN_ERROR
        end
      end
      chest_from_response(base64_decode(response))
    else
      CONN_ERROR
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce le informazioni dell'evento dello scrigno magico.
  #    event_name: nome dell'evento
  #    restituisce -2 se lo scrigno non è uno scrigno magico
  # @return [Local_Chest]
  #--------------------------------------------------------------------------
  def get_chest_info(event_name)
    return Local_Chest.new($1, $2.to_i) if event_name =~ CHEST_REGX
    NORMAL_CHEST
  end
  #--------------------------------------------------------------------------
  # * Processa la risposta del server e restituisce le informazioni dello
  #   scrigno online.
  #    response_data: una stringa di risposta
  #    Restituisce un oggetto Online_Chest con parametro item_type:
  #    ● -1 se l'utente non è registrato (e non può prendere dagli scrigni
  #    ● 0 se lo scrigno è vuoto
  #    ● 1 se contiene un oggetto
  #    ● 2 se contiene un'arma
  #    ● 3 se contiene un'armatura
  #    ● 4 se chi ha messo l'oggetto è lo stesso giocatore
  # @param [String] response_data
  # @return [Online_Chest]
  #--------------------------------------------------------------------------
  def chest_from_response(response_data)
    case response_data
      when RESP_SAME #stesso giocatore
        return Online_Chest.new(4, nil, nil, nil)
      when RESP_NO_DATA #lo scrigno non esiste
        return Online_Chest.new(0, nil, nil, nil)
      when RESP_LOGIN_ERR #dati utente errati
        return Online_Chest.new(-1, nil, nil, nil)
      when /<chest:(.*)>/i #lo scrigno c'è
        params = $1.split('|')
        type = params[0].to_i
        id = params[1].to_f
        name = params[2]
        token = params[3]
        println "Tipo: #{type}, ID: #{id}, Nome: #{name}, Token: #{token}"
        return Online_Chest.new(type, id, name, token)
      else #altrimenti - errore di connessione
        CONN_ERROR
    end
  end
  #--------------------------------------------------------------------------
  # * Invia un feedback al giocatore che ha messo l'oggetto nello srigno.
  #    type: tipo di feedback (0: fama, 1: infamia)
  #    value: quantità
  #    chest: scrigno che contiene nome e token. Il token è una stringa di
  #     20 caratteri generata casualmente dal server per fare in modo che
  #     non possa ricevere feedback infiniti.
  # @param [Integer] type
  # @param [Integer] value
  # @param [Online_Chest] chest
  #--------------------------------------------------------------------------
  def request_feedback(type, value, chest)
    #user_id, user_name, token, type, value
    player = $game_system.player
    #params = [player.id, player.name, chest.token, type, value]
    params = {
        game_id: player.id,
        player_name: player.name,
        token: chest.token,
        type: type,
        value: value
    }
    #data = base64_encode(params * ",")
    #request = "/feedback_send.php?get=" + data
    url = Online.api_path + '/feedback_send.php'
    base64_decode(submit_post_request(url, params)) rescue CONN_ERROR
    #println base64_decode(await_response(HTTP.domain + request))
  end
  #--------------------------------------------------------------------------
  # * Richiede al server di aggiungere un oggetto allo scrigno.
  #    item: ogggetto
  #    la risposta viene memorizzata in $game_temp.chest.response.
  # @param [RPG::BaseItem] item
  # @throws [InternetConnectionException]
  #--------------------------------------------------------------------------
  def request_fill(item)
    player = $game_system.player
    params = {
        game_id: player.id,
        player_name: player.name,
        type: get_type(item),
        item_id: item.id,
        chest: $game_temp.chest.name
    }
    url = Online.api_path + '/chest_fill.php'
    # name = player.name
    # game = player.id
    # type = get_type(item)
    # id = item.id
    # chest_name = $game_temp.chest.name
    # data = [game,name,type,id,chest_name] # parametri da inviare
    # request = base64_encode(data * ",")
    # response = await_response(HTTP.domain+"/chest_fill.php?get="+request)
    response = submit_post_request(url, params)
    $game_temp.chest.response = base64_decode(response)
    $game_temp.chest.item = item
  end
  #--------------------------------------------------------------------------
  # * Ottiene un valore da 1 a 3 a seconda del tipo di oggetto
  # @param [RPG::BaseItem] item
  # @return [Integer]
  #--------------------------------------------------------------------------
  def get_type(item)
    case item
      when RPG::Item;   type = 1
      when RPG::Weapon; type = 2
      when RPG::Armor;  type = 3
      else;             type = 0
    end
    type
  end
end

#===============================================================================
# ** Game_Map
#-------------------------------------------------------------------------------
# Aggiunge il controllo degli scrigni online e li mostra chiusi o aperti.
#===============================================================================
class Game_Map
  include Chest_Core
  alias h87_mc_setup_events setup_events unless $@
  #--------------------------------------------------------------------------
  # * Settaggio Eventi
  #--------------------------------------------------------------------------
  def setup_events
    h87_mc_setup_events
    begin
      refresh_magic_chests
    rescue Exception
      print $!
    end
  end
  #--------------------------------------------------------------------------
  # * Controllo dello stato degli scrigni magici
  #--------------------------------------------------------------------------
  def refresh_magic_chests
    @map.events.each_value do |event|
      if event.name =~ CHEST_REGX
        key = [@map_id, event.id, 'A']
        $game_self_switches[key] = get_online_state_chest($1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'evento con ID richiesto
  # @param [Integer] event_id
  # @return [RPG::Event]
  #--------------------------------------------------------------------------
  def event_data(event_id); @map.events[event_id]; end
end

#===============================================================================
# ** Online_Chest
#-------------------------------------------------------------------------------
# Classe che contiene le informazioni online dello scrigno.
#===============================================================================
class Online_Chest
  attr_reader :item_type   #tipo oggetto
  attr_reader :player     #nome giocatore
  attr_reader :item_id    #ID dell'oggetto
  attr_reader :token      #token per il feedback
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] type
  # @param [Integer] item_id
  # @param [String] player_name
  # @param [String] token
  #--------------------------------------------------------------------------
  def initialize(type, item_id, player_name, token)
    @item_type = type
    @player = player_name
    @item_id = item_id
    @token = token
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto
  #--------------------------------------------------------------------------
  def item
    case @item_type
      when 1; $data_items[@item_id]
      when 2; $data_weapons[@item_id]
      when 3; $data_armors[@item_id]
      else; 0
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'ID del gruppo di mostri
  #--------------------------------------------------------------------------
  def troop
    return 0 if @item_type != 1
    item.troop_id
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto è un mostro
  #--------------------------------------------------------------------------
  def monster?; troop > 0; end
end

#===============================================================================
# ** Local_Chest
#-------------------------------------------------------------------------------
# Classe che contiene le informazioni dell'evento dello scrigno.
#===============================================================================
class Local_Chest
  attr_reader   :name       #nome dello scrigno
  attr_reader   :level      #livello dello scrigno
  attr_accessor :response   #risposta dello scrigno
  attr_accessor :item       #oggetto da scalare
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #     name: nome dello scrigno
  #     level: livello dello scrigno (per limitare gli oggetti)
  #--------------------------------------------------------------------------
  def initialize(name, level)
    @name = name
    @level = level
    @response = nil
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'utente non è registrato
  #--------------------------------------------------------------------------
  def not_reg; self.response.to_i == -1; end
  #--------------------------------------------------------------------------
  # * Restituisce true se è stato bannato
  #--------------------------------------------------------------------------
  def banned?; self.response.to_i == -2; end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto è stato inserito nello scrigno
  #--------------------------------------------------------------------------
  def fill_ok?; self.response == 'ok'; end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto non è stato riempito (perché pieno)
  #--------------------------------------------------------------------------
  def not_filled?; self.response == '1'; end
  #--------------------------------------------------------------------------
  # * Restituisce true se c'è stato un problema di connessione
  #--------------------------------------------------------------------------
  def connected?
    println "Risposta: #{@response}"
    ['-2','-1','ok','1',''].include?(self.response)
  end
end

#==================================================================1=============
# ** Game_Temp
#-------------------------------------------------------------------------------
# Aggiunta la memorizzazione dello scrigno per passarlo tra le schermate
#===============================================================================
class Game_Temp
  # @return [Online_Chest] chest
  attr_accessor :chest
end

#===============================================================================
# ** Game_Interpreter
#-------------------------------------------------------------------------------
# Comandi evento per il controllo
#===============================================================================
# noinspection RubyResolve
class Game_Interpreter
  include Chest_Core
  #--------------------------------------------------------------------------
  # * Restituisce il nome dell'evento
  #--------------------------------------------------------------------------
  def event_name; $game_map.event_data(@event_id).name; end
  #--------------------------------------------------------------------------
  # * Restituisce true se lo scrigno è pieno
  #--------------------------------------------------------------------------
  def chest_full?; @online_chest.item_type > 0; end
  #--------------------------------------------------------------------------
  # * Restituisce true se lo scrigno è vuoto
  #--------------------------------------------------------------------------
  def chest_empty?; @online_chest.item_type == 0; end
  #--------------------------------------------------------------------------
  # * Ottiene l'oggetto online (e lo rimuove dallo scrigno)
  # @return [Online_Chest]
  #--------------------------------------------------------------------------
  def open_online_chest; @online_chest = get_chest_item(event_name); end
  #--------------------------------------------------------------------------
  # * Aggiunge all'inventario l'oggetto ottenuto
  #--------------------------------------------------------------------------
  def gain_chest_item; $game_party.gain_item(@online_chest.item, 1); end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto è stato immesso dallo stesso giocatore
  #--------------------------------------------------------------------------
  def item_mine?; @online_chest.item_type == 4; end
  #--------------------------------------------------------------------------
  # * Restituisce true se i dati di login non sono corretti
  #--------------------------------------------------------------------------
  def login_error?; @online_chest.item_type == -1; end
  #--------------------------------------------------------------------------
  # * Restituisce true se c'è un problema di connessione
  #--------------------------------------------------------------------------
  def connection_error?; @online_chest == Chest_Core::CONN_ERROR; end
  #--------------------------------------------------------------------------
  # * Restituisce true se c'è un problema di connessione (dopo inserimento)
  #--------------------------------------------------------------------------
  def c_connection_error?; !$game_temp.chest.connected?; end
  #--------------------------------------------------------------------------
  # * Inserisce nei dati temporanei lo scrigno per passarlo alla schermata
  #--------------------------------------------------------------------------
  def load_chest_data; $game_temp.chest = get_chest_info(event_name); end
  #--------------------------------------------------------------------------
  # * Ottiene il risultato dell'operazione
  #--------------------------------------------------------------------------
  def get_chest_data; @online_chest = $game_temp.chest.response; end
  #--------------------------------------------------------------------------
  # * Invio del feedback di ringraziamento o sconfitta
  #--------------------------------------------------------------------------
  def send_feedback(value)
    if value > 0
      request_feedback(0, value, @online_chest)
    elsif value < 0
      request_feedback(1, value*-1, @online_chest)
    end
  end
  #--------------------------------------------------------------------------
  # * Un oggetto è stato selezionato?
  #--------------------------------------------------------------------------
  def chest_item_selected?; $game_temp.chest.item != nil; end
  #--------------------------------------------------------------------------
  # * L'oggetto è stato correttamente inserito?
  #--------------------------------------------------------------------------
  def chest_filled?; $game_temp.chest.fill_ok?; end
  #--------------------------------------------------------------------------
  # * L'utente è bannato?
  #--------------------------------------------------------------------------
  def user_banned?; $game_temp.chest.banned?; end
  #--------------------------------------------------------------------------
  # * L'utente non è registrato?
  #--------------------------------------------------------------------------
  def not_registered?; $game_temp.chest.not_reg; end
  #--------------------------------------------------------------------------
  # * Restituisce true se lo scrigno è pieno
  #--------------------------------------------------------------------------
  def online_state_chest_full?; !get_online_state_chest(event_name); end
end

#===============================================================================
# ** Scene_Chest
#-------------------------------------------------------------------------------
# Viene chiamata per selezionare l'oggetto da mettere nello scrigno.
#===============================================================================
class Scene_Chest < Scene_MenuBase
  include Chest_Core
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_item_list_window
    create_info_window
    $game_temp.chest.item = nil
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra degli oggetti
  #--------------------------------------------------------------------------
  def create_item_list_window
    x = 0;                y = @help_window.height
    w = Graphics.width/2; h = Graphics.height - y
    @item_window = Window_ItemC.new(x, y, w, h)
    @item_window.set_handler(:ok, method(:select_item))
    @item_window.set_handler(:cancel, method(:return_scene))
    @item_window.help_window = @help_window
    @item_window.set_list(:all)
    @item_window.activate
    @item_window.index = 0
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra delle informazioni
  #--------------------------------------------------------------------------
  def create_info_window
    x = @item_window.width; y = @help_window.height
    w = Graphics.width - x; h = Graphics.height - y
    @info_window = Window_ItemInfo.new(x, y, w, h)
    @item_window.set_info_window(@info_window)
  end
  #--------------------------------------------------------------------------
  # * Seleziona l'oggetto da inserire nello scrigno
  #--------------------------------------------------------------------------
  def select_item
    begin
      request_fill(@item_window.item)
    rescue InternetConnectionException
      show_dialog('Errore di connessione.', @item_window)
    end
    SceneManager.return
  end
end

#===============================================================================
# ** Window_ItemC
#-------------------------------------------------------------------------------
# Finestra degli oggetti modificata per mostrare abilitati gli oggetti che puoi
# mettere negli scrigni.
#===============================================================================
class Window_ItemC < Window_Item
  #--------------------------------------------------------------------------
  # * Restituisce se l'oggetto è attivo
  # @param [RPG::Item] item
  #--------------------------------------------------------------------------
  def enable?(item)
    return false unless item.traddable?
    item.tier <= $game_temp.chest.level
  end
end
