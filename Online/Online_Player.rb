#===============================================================================
# ** Classe Online_Player
#-------------------------------------------------------------------------------
# Contiene delle informazioni su un qualsiasi giocatore online
#===============================================================================
class Online_Player
  attr_accessor :player_id # ID giocatore sul server
  attr_accessor :name #Nome
  attr_accessor :avatar #ID Avatar
  attr_accessor :banned #Stato di ban
  attr_accessor :level #Livello raggiunto
  attr_accessor :playtime #Tempo di gioco
  attr_accessor :storymode #Stato della storia
  attr_accessor :quests #Missioni secondarie
  attr_accessor :fame #fama
  attr_accessor :infame #infamia
  attr_accessor :title_id #ID del titolo
  attr_accessor :points # punteggio del giocatore
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
    @points = player_data['points'] || 0
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

  # scarica i dati di un giocatore da internet e restituisce l'oggetto
  # @param [Integer] player_id
  # @return [Online_Player]
  def self.get(player_id)
    response = Online.get :player, :get_player, {:player_id => player_id}
    return nil unless response.ok?
    return nil unless response.json?
    return Online_Player.new(JSON.decode(response.body))
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