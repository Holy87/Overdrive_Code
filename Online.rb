require File.expand_path('rm_vx_data')

#===============================================================================
# ** Configurazione
#===============================================================================
module Settings
  NO_PLAYER_VOCAB = 'Giocatore non trovato.'
  WRONG_DATA_VOCAB = 'Errore del server.'
  CONN_ERROR_VOCAB = 'Errore di connessione. Potrebbe essere un problema di server o della tua linea.'
end

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# Stringhe necessarie al gioco
#===============================================================================
module Vocab
  def self.no_player; Settings::NO_PLAYER_VOCAB; end
  def self.wrong_player_data; Settings::WRONG_DATA_VOCAB; end
  def self.connection_error; Settings::CONN_ERROR_VOCAB; end
end
# - SCRIPT DI BASE PER L'ONLINE

#===============================================================================
# ** Classe Online_Player
#-------------------------------------------------------------------------------
# Contiene delle informazioni sul giocatore (profilo online)
#===============================================================================
class Online_Player
  attr_accessor :name       #Nome
  attr_accessor :avatar     #ID Avatar
  attr_accessor :banned     #Stato di ban
  attr_accessor :level      #Livello raggiunto
  attr_accessor :points     #Punteggio obiettivo
  attr_accessor :playtime   #Tempo di gioco
  attr_accessor :storymode  #Stato della storia
  attr_accessor :quests     #Missioni secondarie
  attr_accessor :fame       #fama
  attr_accessor :infame     #infamia
  attr_accessor :title_id   #ID del titolo
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [String] name
  # @param [Integer] avatar
  # @param [Integer] banned
  #--------------------------------------------------------------------------
  def initialize(name, avatar, banned = 0)
    @name = name
    @avatar = avatar.to_i
    @banned = banned == 1
  end
  #--------------------------------------------------------------------------
  # * ID della partita
  #--------------------------------------------------------------------------
  def id; $game_party.id_partita; end
  #--------------------------------------------------------------------------
  # * Restituisce se è stato bannato
  #--------------------------------------------------------------------------
  def banned?; @banned; end
  #--------------------------------------------------------------------------
  # I titoli sbloccati dal giocatore
  # @return [Array]
  #--------------------------------------------------------------------------
  def unlocked_titles
    @unlocked_titles ||= []
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def unlock_title(title_id)
    return if unlocked_titles.include?(title_id)
    unlocked_titles.push(title_id)
    unless $game_system.cached_titles.include?(title_id)
      $game_system.cached_titles.push(title_id)
    end
  end
  #--------------------------------------------------------------------------
  # *
  # @return [Player_Title]
  #--------------------------------------------------------------------------
  def title; Titles.get_title(@title_id); end
  #--------------------------------------------------------------------------
  # * Sblocca i titoli in batch. Non cacha perché si suppone che venga fatto
  # appena sincronizzato.
  # @param [Array] array_ids
  #--------------------------------------------------------------------------
  def unlock_titles(array_ids)
    array_ids.each {|id|
      return if unlocked_titles.include?(title_id)
      unlocked_titles.push(id)
    }
  end
end

#===============================================================================
# ** Online
#-------------------------------------------------------------------------------
# Modulo core per la connessione online
#===============================================================================
module Online
  WRONG_DATA  = '-1'
  NO_PLAYER   = '0'
  CONN_ERROR  = ''
  SUCCESS     = '1'
  #--------------------------------------------------------------------------
  # * Percorso directory contenenti le chiamate alle azioni
  #--------------------------------------------------------------------------
  def self.api_path; HTTP.domain + '/gameapi'; end
  #--------------------------------------------------------------------------
  # * determina se la componente online è abilitata
  #--------------------------------------------------------------------------
  def self.enabled?; $game_variables[0]; end
  #--------------------------------------------------------------------------
  # * Procedura di registrazione giocatore. True se l'operazione ha successo
  # @param [String] name
  # @param [Integer] avatar
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def self.register_player(name, avatar)
    params = {
        :name => name,
        :id => $game_system.game_id,
        :avatar => avatar
    }
    begin
      res = submit_post_request(api_path + '/regnew.php', params)
    rescue InternetConnectionException
      return false
    end
    res == SUCCESS
  end
  #--------------------------------------------------------------------------
  # * Ottiene i dati del giocatore dal web e ne restituisce l'oggetto Player
  # @param [String] player_name
  # @return [Online_Player]
  #--------------------------------------------------------------------------
  def self.get_player_info(player_name)
    params = base64_encode(player_name)
    response = await_response(HTTP.domain+"/player_info.php?name=#{params}")
    begin
      result = base64_decode(response)
    rescue Exception
      raise(ConnectionException.new(Vocab.connection_error))
    end
    raise(ConnectionException.new(Vocab.no_player)) if result == NO_PLAYER
    raise(ConnectionException.new(Vocab.wrong_player_data)) if result == WRONG_DATA
    raise(ConnectionException.new(Vocab.connection_error)) if result == CONN_ERROR
    PlayerParser.str_to_player(result)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.sync_all
    sync_player_infos
    sync_unlocked_titles
  end
  #--------------------------------------------------------------------------
  # * Sincronizza i dati della partita con il server
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def self.sync_player_infos
    player = $game_system.player
    playtime = $game_system.playtime_time
    params = {
        :id => player.id,
        :points => H87_Achievements.gained_points,
        :level => $game_party.max_level,
        :hours => playtime.hour,
        :minutes => playtime.min,
        :story => $game_system.story_progress,
        :quests => $game_system.completed_quests,
        :title => player.title
    }
    submit_post_request(api_path + '/profile_update.php', params) rescue false
    true
  end
  #--------------------------------------------------------------------------
  # * Cambia l'avatar del giocatore
  # @param [Integer] new_avatar
  # @return [Boolean]
  # @throws [InternetConnectionException]
  #--------------------------------------------------------------------------
  def self.change_avatar(new_avatar)
    params = {:id => $game_system.player.id, :avatar => new_avatar}
    r = submit_post_request(api_path + '/avatar_update.php', params)
    r == SUCCESS
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.sync_unlocked_titles
    send_cached_titles
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.send_cached_titles
    return if $game_system.cached_titles.empty?
    request = {
        :game_id => $game_system.player.id,
        :title_ids => $game_system.cached_titles * ','
    }
    url = HTTP.domain + '/push_titles.php'
    result = submit_post_request(url, request)
    $game_system.cached_titles.clear if result == SUCCESS
  end

  def self.get_online_titles
    params = {:game_id => $game_system.player.id}
    url = HTTP.domain + '/get_titles.php'
    response = submit_post_request(url, params)
    if response =~ /ok:(.+)/i
      ids = $1.split(',')
      $game_system.player.unlock_titles(ids)
    end
  end
end

class ConnectionException < Exception; end
class PlayerParseError < Exception; end

#===============================================================================
# ** Game_System
#-------------------------------------------------------------------------------
# Aggiunta delle info dell'utente registrato
#===============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # Restituisce le informazioni sul giocatore registrato
  # * Se è già presente, lo restituisce
  # * Se non è presente, lo scarica online e lo restituisce
  # * Se non è presente neanche online, restituisce nil
  # @return [Online_Player]
  #--------------------------------------------------------------------------
  def player
    @player ||= safe_player_from_web
  end
  #--------------------------------------------------------------------------
  # * Imposta il giocatore
  # @param [Online_Player] player
  #--------------------------------------------------------------------------
  def player=(player); @player = player; end
  #--------------------------------------------------------------------------
  # * Scarica le informazioni del giocatore in modo sicuro (tenta 3 volte)
  # @return [Online_Player]
  #--------------------------------------------------------------------------
  def safe_player_from_web
    i = 0
    tries = 3 # numero di tentativi prima di smettere
    while @player == nil && i < tries
      @player = player_from_web
      i += 1
    end
    @player
  end
  #--------------------------------------------------------------------------
  # * Scarica le informazioni del giocatore da internet
  # @return [Online_Player]
  #--------------------------------------------------------------------------
  def player_from_web
    id = Base64.encode($game_party.id_partita)
    sp = await_response(HTTP.domain+"/player_info_code.php?id=#{id}")
    return nil unless sp
    response = Base64.decode(sp)
    if response == Online::NO_PLAYER || response == Online::CONN_ERROR || response == Online::WRONG_DATA
      nil
    else
      res = response.split(',')
      Online_Player.new(res[0], res[1], res[7].to_i)
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'utente è registrato
  #--------------------------------------------------------------------------
  def user_registered?; player != nil; end
  #--------------------------------------------------------------------------
  # * Restituisce true se il giocatore è stato bannato
  #--------------------------------------------------------------------------
  def user_banned?; player.banned?; end
  #--------------------------------------------------------------------------
  # * Restituisce l'ID della partita
  #--------------------------------------------------------------------------
  def game_id; $game_party.id_partita; end
  #--------------------------------------------------------------------------
  # * Restituisce i titoli sbloccati dal giocatore che non sono ancora stati
  # sincronizzati online
  # @return [Array]
  #--------------------------------------------------------------------------
  def cached_titles; @cached_titles ||= []; end
end

#===============================================================================
# ** PlayerParser
#-------------------------------------------------------------------------------
# Crea l'oggetto giocatore da una stringa
#===============================================================================
module PlayerParser
  #--------------------------------------------------------------------------
  # * Converte la stringa ad oggetto giocatore
  # @param [String] str
  # @raise [ParseException]
  #--------------------------------------------------------------------------
  def self.str_to_player(str)
    name = pdata(str, 'name'); face = pdata(str, 'face')
    banned = pdata(str, 'banned').to_i
    player = Online_Player.new(name, face, banned)
    player.points = pdata(str, 'points').to_i
    player.level = pdata(str, 'level').to_i
    player.playtime = {h: pdata(str, 'hours').to_i, m: pdata(str, 'minutes').to_i}
    player.storymode = pdata(str, 'story').to_i
    player.quests = pdata(str, 'quests').to_i
    player.fame = pdata(str, 'fame').to_i
    player.infame = pdata(str, 'infame').to_i
    player.title_id = pdata(str, 'title').to_i
    player
  end
  #--------------------------------------------------------------------------
  # * Restituisce il valore della chiave da un file xml
  # @param [String] origin
  # @param [String] key
  # @return [String]
  #--------------------------------------------------------------------------
  def self.pdata(origin, key)
    return $1 if origin =~ /<#{key}>(.*)<\/#{key}>/i
    raise PlayerParseError.new, 'Chiave invalida: ' + key
  end
end

