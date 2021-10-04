#===============================================================================
# ** Classe Online_Player
#-------------------------------------------------------------------------------
# Contiene delle informazioni su un qualsiasi giocatore online
#===============================================================================
class Online_Player
  include DateParser
  attr_accessor :player_id # ID giocatore sul server
  attr_accessor :name #Nome
  attr_accessor :avatar #ID Avatar
  attr_accessor :banned #Stato di ban
  attr_accessor :level #Livello raggiunto
  attr_accessor :storymode #Stato della storia
  attr_accessor :quests #Missioni secondarie
  attr_accessor :fame #fama
  attr_accessor :infame #infamia
  attr_accessor :title_id #ID del titolo
  attr_accessor :exp # esperienza raggiunta dal giocatore
  attr_accessor :gold # oro attuale del giocatore
  attr_accessor :hours # ore di gioco totali
  attr_accessor :minutes # minuti di gioco totali
  attr_accessor :points
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Hash] player_data
  #--------------------------------------------------------------------------
  def initialize(player_data)
    @name = player_data['player_name']
    @avatar = player_data['player_face']
    @banned = player_data['banned'] == 1
    @level = player_data['level']
    @quests = player_data['quests']
    @hours = player_data['hours']
    @minutes = player_data['minutes']
    @storymode = player_data['story']
    @player_id = player_data['player_id']
    @fame = player_data['fame']
    @infame = player_data['infame']
    @title_id = player_data['title_id']
    @exp = player_data['exp'] || 0
    @gold = player_data['gold'] || 0
    @points = player_data['points'] || 0
    @last_online = date_from_string(player_data['last_update'])
    @follows = nil
    @followers = nil
  end

  #--------------------------------------------------------------------------
  # * Restituisce se è stato bannato
  #--------------------------------------------------------------------------
  def banned?
    @banned
  end

  # @return [Player_Title, nil]
  def title
    Player_Titles.get_title @title_id
  end

  def follows_loaded?
    @follows != nil
  end

  # restituisce l'elenco dei giocatori che segue il giocatore
  # @return [Array<Online_Player>]
  def follows
    @follows ||= refresh_follows
  end

  # restituisce l'elenco dei giocatori che seguono il giocatore
  # @return [Array<Online_Player>]
  def followers
    @followers ||= refresh_followers
  end

  def refresh_follows
    @follows = Follow_Service.get_follows(@player_id)
  end

  def refresh_followers
    @followers = Follow_Service.get_followers(@player_id)
  end

  # @return [Time]
  def last_online
    @last_online
  end

  def hours_from_last_online
    (Time.now - last_online).to_i / (60 * 60)
  end

  def days_from_last_online
    hours_from_last_online / 24
  end

  # scarica i dati di un giocatore da internet e restituisce l'oggetto
  # @param [Integer] player_id
  # @return [Online_Player]
  def self.get(player_id)
    begin
      response = Online.get :player, :get_player, {:player_id => player_id}
    rescue => error
      Logger.error(error.message)
      return nil
    end
    return nil unless response.ok?
    return nil unless response.json?
    return Online_Player.new(response.decode_json)
  end

  # scarica i dati di un giocatore da internet e restituisce l'oggetto cercando il nome
  # @param [String] player_name
  # @return [Online_Player]
  def self.find_by_name(player_name)
    response = Online.get :player, :get_player, {:name => player_name}
    return nil unless response.ok?
    return nil unless response.json?
    return Online_Player.new(JSON.decode(response.body))
  end
end