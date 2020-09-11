#===============================================================================
# ** Game_System
#-------------------------------------------------------------------------------
# Aggiunta delle info dell'utente registrato
#===============================================================================
class Game_System
  # ID online del giocatore
  attr_accessor :player_id
  # Nome online del giocatore
  # @return [String]
  attr_accessor :player_name
  # ID dell'avatar online
  # @return [Integer]
  attr_accessor :player_face
  attr_accessor :fame
  attr_accessor :infame
  attr_accessor :banned


  # restituisce il token di autentiazione per l'online.
  # Il codice deve rimanere segreto. Se chiamato la prima
  # volta, viene generato.
  # @return [String]
  def game_token
    @game_token ||= init_game_token
  end

  def init_player_data
    @fame = 0
    @infame = 0
    @banned = false
    @player_face = 1
    @player_name = ''
  end

  def download_player_data
    return false unless can_upload?
    player = Online_Player.get(@player_id)
    return false if player.nil?
    @player_name = player.name
    @player_face = player.avatar
    @fame = player.fame
    @infame = player.infame
    @banned = player.banned?
    true
  end

  # Carica i progressi del giocatore sul server
  # @return [HTTP::Response]
  def upload_player_data
    return unless can_upload?
    data = {
        :player_id => @player_id,
        :game_token => game_token,
        :level => $game_party.total_max_level,
        :hours => playtime.hours,
        :minutes => playtime.minutes,
        :story => story_progress,
        :quests => completed_quests
    }
    Online.upload :player, :update, data
  end

  # Cambia l'avatar sia in locale che sul server.
  # @param [Integer] new_avatar_id
  # @return [HTTP::Response]
  def change_avatar(new_avatar_id, auto_upload = true)
    @player_face = new_avatar_id
    return unless auto_upload
    return unless can_upload?
    params = {:player_id => @player_id, :game_token => game_token, :player_face => new_avatar_id}
    Online.upload :player, :update_face, params
  end

  # Restituisce true se l'utente è registrato
  def user_registered?
    @player_id != nil
  end

  # Restituisce true se il giocatore è stato bannato
  def user_banned?
    @banned
  end

  def can_upload?
    user_registered? && !user_banned? && Online.enabled?
  end

  private

  def init_game_token
    return $game_party.id_partita if $game_party.id_partita != nil
    String.random(50)
  end
end

class Game_Party < Game_Unit
  # @deprecated non viene più usato
  attr_accessor :id_partita # per retrocompatibilità
end