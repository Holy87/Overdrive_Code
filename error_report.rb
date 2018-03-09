require File.expand_path('rm_vx_data')

module ReportSettings

  REPORT_TOKEN = ''

  ERR_BACKTRACE = false
  MAP_POSITION = true
  BATTLE_STATE = true
  SYSTEM_VERSION = true
  GAME_VERSION = true
  PARTY_MEMBERS = true
  INSTALL_ID = true
  API_URL = 'http//francescobosso.altervista.org/rpgm/send_report.php'
end

module ReportSender
  include ReportSettings
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.send
    return if $game_settings && !$game_settings[:report_errors]
    submit_post_request(api_url, prepare_request)
  end
  #--------------------------------------------------------------------------
  # *
  # @return [String]
  #--------------------------------------------------------------------------
  def self.api_url
    API_URL
  end
  #--------------------------------------------------------------------------
  # *
  # @return [Hash]
  #--------------------------------------------------------------------------
  def self.prepare_request
    request = {}
    request[:err_name] = $!.message
    request[:message] = $!.backtrace[0].to_s
    request[:backtrace] = get_backtrace if ERR_BACKTRACE
    if $game_system
      get_map_info(request) if MAP_POSITION
      get_battle_state(request) if BATTLE_STATE
      request[:version] = game_version if GAME_VERSION
      request[:system] = system_version if SYSTEM_VERSION
      request[:inst_id] = $game_settings[:install_id] if INSTALL_ID
    else
      request[:no_init] = 1
    end
    request
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.get_backtrace
    backtrace = ''
    $!.backtrace.each {|trace|
      backtrace += trace.to_s + '\n'
    }
    backtrace
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.get_map_info(request)
    return if $game_map.nil?
    request[:map_id] = $game_map.map_id
    request[:m_x] = $game_player.x
    request[:m_y] = $game_player.y
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.get_battle_state(request)
    return unless $game_party
    return unless $game_party.in_battle?
    request[:troop_id] = $game_troop.troop_id
    request[:turn] = $game_troop.turn_count
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.game_version
    return nil unless $game_system
    $game_system.game_version.to_s
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.system_version
    Win.version
  end
end

module SceneManager
  class << self
    alias run_safe run
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.run
    begin
      run_safe
    rescue Exception
      ReportSender.send unless ($TEST || $!.message == '')
      raise
    end
  end
end

class Game_Troop < Game_Unit
  attr_accessor :troop_id
end

module DataManager
  class << self
    alias reps_cgo create_game_objects
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.create_game_objects
    reps_cgo
    return if $game_settings[:install_id]
    $game_settings[:install_id] = random_install_id
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.random_install_id
    str1 = String.random.upcase
    str2 = String.random.upcase
    str3 = String.random.upcase
    str4 = String.random.upcase
    sprintf('%s-%s-%s-%s', str1, str2, str3, str4)
  end
end