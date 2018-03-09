require 'rm_vx_data' if false
=begin
 ==============================================================================
  ■ Add-on Opzioni di Holy87
      versione 1.0.01
      Difficoltà utente: ★
      Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
      lo script nei propri progetti, sia amatoriali che commerciali. Vietata
      l'attribuzione impropria.
 ==============================================================================
    Questo script aggiunge nuovi comandi alle opzioni di gioco, tra cui:
    ● Opzioni volume (musica, sottofondo ed effetti sonori)
    ● Opzione dimensione della finestra (per ingrandirla senza andare in full-screen)
    ● Opzione corsa automatica
    ● Opzione comparsa testo rapida
    ● Opzione per disattivare le animazioni di battaglia
 ==============================================================================
  ■ Compatibilità
    DataManager -> alias create_game_objects
 ==============================================================================
  ■ Installazione e istruzioni
    Installare questo script sotto Materials e prima del Main.
    RICHIEDE IL MODULO DI SUPPORTO UNIVERSALE DI HOLY87 E LO SCRIPT DELLE
    OPZIONI (ovviamente).
    Lo script è Plug&Play. Puoi modificare alcuni settaggi in basso, nella
    sezione CONFIGURAZIONE.
 ==============================================================================
=end

#==============================================================================
# ** CONFIGURAZIONE
#------------------------------------------------------------------------------
#  Configura i testi e le opzioni
#==============================================================================
module Gameplay_Settings
  #--------------------------------------------------------------------------
  # * Impostazioni di base. Cancella o cambia l'ordine degli elementi per
  #   rimuovere o spostare le opzioni.
  #--------------------------------------------------------------------------
  COMMANDS = [:autodash, :fastmsg, :battle_anim, :bgm, :bgs, :se, :screen_size]
  #--------------------------------------------------------------------------
  # * Switch e variabili
  #--------------------------------------------------------------------------
  AUTODASH_SW = 101           # switch per l'auto corsa
  FASTMSG_SW = 102            # switch per i messaggi rapidi
  BATTLE_ANIM_SW = 103        # switch per le animazioni di battaglia
  BGM_VOLUME_VAR = 101        # variabile volume musica
  BGS_VOLUME_VAR = 102        # variabile volume sottofondo
  SE_VOLUME_VAR = 103         # variabile volume effetti
  BGM_MUTE_SW = 104           # switch musica OFF
  BGS_MUTE_SW = 105           # switch musica ON
  SE_MUTE_SW = 106            # switch effetti OFF
  #--------------------------------------------------------------------------
  # * Vocaboli
  #--------------------------------------------------------------------------
  AUTODASH_HELP = 'Scegli se attivare la corsa automatica.'
  AUTODASH_CMD = 'Auto corsa'
  AUTODASH_ON = 'Sì'
  AUTODASH_OFF = 'No'
  FASTMSG_HELP = 'Scegli se mostrare i messaggi istantaneamente.'
  FASTMSG_CMD = 'Comparsa testo'
  FASTMSG_ON = 'Istantaneo'
  FASTMSG_OFF = 'Normale'
  BATTLE_ANIM_HELP = 'Scegli se nascondere le animazioni di battaglia.'
  BATTLE_ANIM_CMD = 'Anim. battaglia'
  BATTLE_ANIM_ON = 'Nascondi'
  BATTLE_ANIM_OFF = 'Mostra'
  BGM_CMD = 'Volume Musica'
  BGM_HELP = 'Regola il volume della musica.'
  BGS_CMD = 'Volume ambiente'
  BGS_HELP = 'Regola il volume dell\'ambiente.'
  SE_CMD = 'Volume effetti'
  SE_HELP = 'Regola il volume degli effetti sonori.'
  SCREEN_CMD = 'Grandezza Finestra'
  SCREEN_HELP = 'Regola le dimensioni della finestra di gioco.'
  #--------------------------------------------------------------------------
  # * Altri settaggi
  #--------------------------------------------------------------------------
  SCREEN_SIZES = [1, 1.5, 2, 4] # proporzioni dello schermo
end

#==============================================================================
# ** FINE CONFIGURAZIONE
#------------------------------------------------------------------------------
#                 - ATTENZIONE: NON MODIFICARE OLTRE! -
#==============================================================================



$imported = {} if $imported == nil
$imported['H87_GameOptions'] = 1.0
#==============================================================================
# ** Screen_Size
#==============================================================================
class Screen_Size
  attr_accessor :width
  attr_accessor :height
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(width, height)
    @width = width.to_i
    @height = height.to_i
  end
  #--------------------------------------------------------------------------
  # *
  # @param [String] text
  # @return [Screen_Size]
  # @raise [Error]
  #--------------------------------------------------------------------------
  def self.from_s(text)
    if text =~ /(.+)x(.+)/
      Screen_Size.new($1.to_i, $2.to_i)
    else
      raise('Errore: Proporzioni non valide')
    end
  end
  #--------------------------------------------------------------------------
  # * Make a printable string format (ex. '640x480')
  # @return [String]
  #--------------------------------------------------------------------------
  def to_s; sprintf('%dx%d', self.width, self.height); end
end

#==============================================================================
# ** Gameplay_Settings
#------------------------------------------------------------------------------
# Core methods for this script
#==============================================================================
module Gameplay_Settings
  SECTIONS = { # this hash handles sections. Really, it is too complicated!
      :autodash => :game, :fastmsg => :game, :battle_anim => :game,
      :bgm => :audio, :bgs => :audio, :se => :audio, :screen_size => :graphic
  }
  #--------------------------------------------------------------------------
  # * Add the options to the settings menu
  #--------------------------------------------------------------------------
  def self.add_options
    (0..COMMANDS.size-1).each { |i|
      command = COMMANDS[i]
      hash = HASHES[command]
      case SECTIONS[command]
        when :game
          H87Options.push_game_option(hash)
        when :audio
          H87Options.push_sound_option(hash)
        when :graphic
          H87Options.push_graphic_option(hash)
        else
          H87Options.push_generic_option(hash)
      end
    }
  end
  #--------------------------------------------------------------------------
  # * Returns a Screen_Size object from the current resolution * rate
  # @param [Number] rate
  # @return [Screen_Size]
  #--------------------------------------------------------------------------
  def self.screen_size(rate)
    Screen_Size.new(Graphics.width * rate, Graphics.height * rate)
  end
  #--------------------------------------------------------------------------
  # * Gets avaiable screen sizes for your display
  # @return [Array]
  #--------------------------------------------------------------------------
  def self.get_screen_sizes
    sizes = []
    SCREEN_SIZES.each {|size|
      sizes.push(screen_size(size)) if size_possible?(screen_size(size))
    }
    sizes
  end
  #--------------------------------------------------------------------------
  # * Returns an array of sizes
  # @param [Array] screen_sizes
  #--------------------------------------------------------------------------
  def self.screen_value_array(screen_sizes)
    values = []
    screen_sizes.each{ |size| values.push(size.to_s) }
    values
  end
  #--------------------------------------------------------------------------
  # * Returns an array of strings showing all sizes possible
  # ex. [544x420, 640x480, ..] from all rates
  # @param [Screen_Size] screen
  #--------------------------------------------------------------------------
  def self.size_possible?(screen)
    resolution = Win.screen_resolution
    screen.width <= resolution[0] && screen.height <= resolution[1]
  end
  #--------------------------------------------------------------------------
  # * Returns the variable ID for the specified volume
  #--------------------------------------------------------------------------
  def self.volume_var_id(type)
    vols = {:bgm => BGM_VOLUME_VAR, :bgs => BGS_VOLUME_VAR, :se => SE_VOLUME_VAR}
    vols[type]
  end
  #--------------------------------------------------------------------------
  # * Returns the mute switch ID for the specified volume
  #--------------------------------------------------------------------------
  def self.volume_sw_id(type)
    vols = {:bgm => BGM_MUTE_SW, :bgs => BGS_MUTE_SW, :se => SE_MUTE_SW}
    vols[type]
  end
  #--------------------------------------------------------------------------
  # * Command hashes
  #--------------------------------------------------------------------------
  HASHES = {
      :autodash => { :type => :switch,
                     :text => AUTODASH_CMD,
                     :help => AUTODASH_HELP,
                     :sw   => AUTODASH_SW,
                     :on   => AUTODASH_ON,
                     :off  => AUTODASH_OFF,
                     :default => false, },
      :fastmsg => { :type => :switch,
                    :text => FASTMSG_CMD,
                    :help => FASTMSG_HELP,
                    :sw   => FASTMSG_SW,
                    :on   => FASTMSG_ON,
                    :off  => FASTMSG_OFF,
                    :default => false, },
      :battle_anim => { :type => :switch,
                        :text => BATTLE_ANIM_CMD,
                        :help => BATTLE_ANIM_HELP,
                        :sw   => BATTLE_ANIM_SW,
                        :on   => BATTLE_ANIM_ON,
                        :off  => BATTLE_ANIM_OFF,
                        :default => false, },
      :bgm => {
          :type => :bar,
          :text => BGM_CMD,
          :help => BGM_HELP,
          :max => 100,
          :var => BGM_VOLUME_VAR,
          :sw => BGM_MUTE_SW,
          :default => 100,
          :method => :update_bgm},
      :bgs => {
          :type => :bar,
          :text => BGS_CMD,
          :help => BGS_HELP,
          :max => 100,
          :var => BGS_VOLUME_VAR,
          :sw => BGS_MUTE_SW,
          :default => 100,
          :method => :update_bgs},
      :se => {
          :type => :bar,
          :text => SE_CMD,
          :help => SE_HELP,
          :max => 100,
          :var => SE_VOLUME_VAR,
          :sw => SE_MUTE_SW,
          :default => 100},
      :screen_size => {
          :type => :variable,
          :text => SCREEN_CMD,
          :help => SCREEN_HELP,
          :values => screen_value_array(get_screen_sizes),
          :var => 'screen_size',
          :method => :update_screen,
          :open_popup => get_screen_sizes.size > 3,
          :default => 0}
  }
end
# finally adds the options to the menu
Gameplay_Settings.add_options

class Option
  #--------------------------------------------------------------------------
  # * Screen update method
  #--------------------------------------------------------------------------
  def update_screen(value)
    Graphics.update_screen_resolution
  end
  #--------------------------------------------------------------------------
  # * BGM update method
  #--------------------------------------------------------------------------
  def update_bgm(value)
    RPG::BGM::last.play
  end
  #--------------------------------------------------------------------------
  # * BGS update method
  #--------------------------------------------------------------------------
  def update_bgs(value)
    RPG::BGS::last.play
  end
end

module Graphics
  #--------------------------------------------------------------------------
  # * Updates the window width
  #--------------------------------------------------------------------------
  def self.update_screen_resolution
    return unless $game_settings
    return unless $game_settings['screen_size']
    value = $game_settings['screen_size']
    rate = Gameplay_Settings::SCREEN_SIZES[value]
    if rate.nil?
      $game_settings['screen_size'] = 0
      rate = 1
    end
    screen = Gameplay_Settings.screen_size(rate)
    if Gameplay_Settings.size_possible?(screen)
      Screen.resize(screen.width, screen.height)
    end
  end
end

#==============================================================================
# ** Game_Player
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Determine if Dashing
  #--------------------------------------------------------------------------
  def dash?
    return false if @move_route_forcing
    return false if $game_map.disable_dash?
    return false if vehicle
    player_run?
  end
  #--------------------------------------------------------------------------
  # * Determine if player is running
  #--------------------------------------------------------------------------
  def player_run?
    if $game_system.autodash_on?
      !Input.press?(:A)
    else
      Input.press?(:A)
    end
  end
end

#==============================================================================
# ** Game_System
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Checks if autodash is setted ON
  #--------------------------------------------------------------------------
  def autodash_on?
    $game_switches[Gameplay_Settings::AUTODASH_SW]
  end
  #--------------------------------------------------------------------------
  # * Checks if fast message is setted ON
  #--------------------------------------------------------------------------
  def fast_message_on?
    $game_switches[Gameplay_Settings::FASTMSG_SW]
  end
  #--------------------------------------------------------------------------
  # * Checks if the battle animation is disabled
  #--------------------------------------------------------------------------
  def hide_battle_animation?
    $game_switches[Gameplay_Settings::BATTLE_ANIM_SW]
  end
end

#==============================================================================
# ** Window_Message
#==============================================================================
class Window_Message < Window_Base
  alias classic_show_fast update_show_fast unless $@
  #--------------------------------------------------------------------------
  # * Alias method update show fast
  #--------------------------------------------------------------------------
  def update_show_fast
    @show_fast = true if $game_system.fast_message_on?
    classic_show_fast
  end
end

#==============================================================================
# ** Window_Message
#==============================================================================
class Scene_Battle < Scene_Base
  alias classic_show_anim_h87 show_animation unless $@
  #--------------------------------------------------------------------------
  # * Alias method show battle animation
  #--------------------------------------------------------------------------
  def show_animation(targets, animation_id)
    return if $game_system.hide_battle_animation?
    classic_show_anim_h87(targets, animation_id)
  end
end

#==============================================================================
# ** Audio
#==============================================================================
module Audio
  # noinspection RubyResolve
  class << self
    alias opt_old_bgm_play bgm_play
    alias opt_old_bgs_play bgs_play
    alias opt_old_me_play me_play
    alias opt_old_se_play se_play
  end
  #--------------------------------------------------------------------------
  # * Returns the BGM and ME volume (value from 0 to 100)
  #--------------------------------------------------------------------------
  def self.music_volume
    return 100 unless $game_variables
    return 0 unless $game_switches[Gameplay_Settings.volume_sw_id(:bgm)]
    [[$game_variables[Gameplay_Settings.volume_var_id(:bgm)], 0].max, 100].min
  end
  #--------------------------------------------------------------------------
  # * Returns the BGS volume (value from 0 to 100)
  #--------------------------------------------------------------------------
  def self.environment_volume
    return 100 unless $game_variables
    return 0 unless $game_switches[Gameplay_Settings.volume_sw_id(:bgs)]
    [[$game_variables[Gameplay_Settings.volume_var_id(:bgs)], 0].max, 100].min
  end
  #--------------------------------------------------------------------------
  # * Returns the SE volume (value from 0 to 100)
  #--------------------------------------------------------------------------
  def self.sound_volume
    return 100 unless $game_variables
    return 0 unless $game_switches[Gameplay_Settings.volume_sw_id(:se)]
    [[$game_variables[Gameplay_Settings.volume_var_id(:se)], 0].max, 100].min
  end
  #--------------------------------------------------------------------------
  # * Alias method: bgm_play
  #--------------------------------------------------------------------------
  def self.bgm_play(filename, volume = 100, pitch = 100, pos = 0)
    volume = volume * music_volume / 100
    opt_old_bgm_play(filename, volume, pitch, pos)
  end
  #--------------------------------------------------------------------------
  # * Alias method: bgs_play
  #--------------------------------------------------------------------------
  def self.bgs_play(filename, volume = 100, pitch = 100, pos = 0)
    volume = volume * environment_volume / 100
    opt_old_bgs_play(filename, volume, pitch, pos)
  end
  #--------------------------------------------------------------------------
  # * Alias method: me_play
  #--------------------------------------------------------------------------
  def self.me_play(filename, volume = 100, pitch = 100)
    volume = volume * music_volume / 100
    opt_old_me_play(filename, volume, pitch)
  end
  #--------------------------------------------------------------------------
  # * Alias method: se_play
  #--------------------------------------------------------------------------
  def self.se_play(filename, volume = 100, pitch = 100)
    volume = volume * sound_volume / 100
    opt_old_se_play(filename, volume, pitch)
  end
end

#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  class << self
    alias h87gameopt_create_game_objects create_game_objects
  end
  #--------------------------------------------------------------------------
  # * Game objects creation
  #--------------------------------------------------------------------------
  def self.create_game_objects
    h87gameopt_create_game_objects
    adjust_sound_variables
  end
  #--------------------------------------------------------------------------
  # * Initialize sound variables and switches
  #--------------------------------------------------------------------------
  def self.adjust_sound_variables
    $game_variables[Gameplay_Settings.volume_var_id(:bgm)] = 100
    $game_variables[Gameplay_Settings.volume_var_id(:bgs)] = 100
    $game_variables[Gameplay_Settings.volume_var_id(:se)] = 100
    $game_switches[Gameplay_Settings.volume_sw_id(:bgm)] = true
    $game_switches[Gameplay_Settings.volume_sw_id(:bgs)] = true
    $game_switches[Gameplay_Settings.volume_sw_id(:se)] = true
    Graphics.update_screen_resolution
  end
end