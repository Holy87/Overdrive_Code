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

  def register(player_id, player_name, avatar, title_id)
    init_player_data
    @player_id = player_id
    @player_name = player_name
    @player_face = avatar
    @current_title_id = title_id
    Logger.info sprintf('player_id: %s, player_nme: %s', @player_id, @player_name) if $TEST
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

  # Cambia l'avatar sia in locale che sul server.
  # @param [Integer] new_avatar_id
  # @return [Online::Operation_Result]
  # @deprecated usa Online.change_avatar
  def change_avatar(new_avatar_id, auto_upload = true)
    @player_face = new_avatar_id
    return unless auto_upload
    Online.change_avatar new_avatar_id
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
    online_enabled? and !user_banned?
  end

  def online_enabled?
    user_registered? and Online.enabled?
  end

  def auth_params
    {
      :player_id => @player_id,
      :game_token => game_token
    }
  end

  # carica lo stato online dei server
  def load_online_data
    load_online_placeholder
    if user_registered? && Online.enabled?
      Online.logout
      Online.login
    end
  end

  # lascia un segno nei salvataggi universali sulla registrazione del giocatore,
  # così da fare in modo che, una volta registrato, nel caso il giocatore carichi
  # la partita da un altro slot con un altro ID partita, recuperi direttamente le
  # informazioni sulla registrazione senza registrare un nuovo profilo. Quante
  # cose si devono fare per retrocompatibilità!
  def save_online_placeholder
    return if $game_party.id_partita.nil?
    return unless user_registered?
    $game_settings[:register_placeholder] ||= {}
    $game_settings[:register_placeholder][$game_party.id_partita] = {
        :game_token => game_token,
        :player_id => @player_id,
        :player_name => @player_name
    }
    $game_settings.save
  end

  def load_online_placeholder
    return if user_registered?
    return if $game_party.id_partita.nil?
    return if $game_settings[:register_placeholder].nil?
    return if $game_settings[:register_placeholder][$game_party.id_partita].nil?
    data = $game_settings[:register_placeholder][$game_party.id_partita]
    @player_id = data[:player_id]
    @player_name = data[:player_name]
    @game_token = data[:game_token]
  end

  private

  def init_game_token
    String.random(50)
  end
end

#===============================================================================
# ** Game_Party
#===============================================================================
class Game_Party < Game_Unit
  # @deprecated non viene più usato
  attr_accessor :id_partita # per retrocompatibilità
  attr_accessor :nome_giocatore

  # @return [Array<Game_Actor>]
  def standard_battle_members
    battle_members.select { |member| !member.domination? && !member.guest?}
  end

  def max_exp
    members.map { |member| member.exp }.max
  end

  def base64_party
    base64_encode(JSON.encode(active_members_data_hash))
  end

  # @return [Array<Hash{Symbol->Fixnum}>]
  def active_members_data_hash
    standard_battle_members.map{|member| member.data_hash}
  end
end

class Game_Actor < Game_Battler
  # @return [String, nil]
  def to_json
    JSON.encode data_hash
  end

  #noinspection RubyResolve
  def guest?
    actor.fix_equipment
  end

  # @return [Hash{Symbol->Fixnum}]
  #noinspection RubyResolve
  def data_hash
    {
        :actor_id => @actor_id, :name => @name,
        :level => @level, :atk_p => @atk_plus,
        :def_p => @def_plus, :spi_p => @spi_plus,
        :agi_p => @agi_plus, :mhp_p => @maxhp_plus,
        :mmp_p => @maxmp_plus,
        :weapon_id => @weapon_id,
        :armor1_id => @armor1_id,
        :armor2_id => @armor2_id,
        :armor3_id => @armor3_id,
        :armor4_id => @armor4_id,
        :extra_armor_ids => extra_armor_id,
        :equip_types => equip_type.map{|t|t.to_s},
        :skills => @skills,
        :passives => @learned_passives
    }
  end

  # @return [String]
  def to_base64
    base64_encode(to_json)
  end
end

#===============================================================================
# ** DataManager
#===============================================================================
module DataManager
  class << self
    alias h87_online_load_game load_game
    alias h87_online_save_game save_game
  end

  def self.load_game(index)
    if h87_online_load_game(index)
      load_online_data
      true
    else
      false
    end
  end

  # scarica tutti i dati dal server online
  def self.load_online_data
    $game_system.load_online_data
    $game_system.refresh_titles
    $game_system.refresh_active_events
    $game_system.check_new_notifications
  end

  def self.save_game(index)
    $game_system.upload_titles
    if h87_online_save_game(index)
      Online.update_player_data if index.is_a?(Integer)
      true
    else
      false
    end
  end
end