=begin
AUTOSALVATAGGIO v1.0
Questo script serve per salvare automaticamente il gioco in determinate occasioni.
=end

#==============================================================================
# ** Vocab
#==============================================================================
module Vocab
  def self.autosave_success; 'Salvataggio automatico eseguito.'; end
  def self.autosave_failed; 'Errore di salvataggio!'; end
  def self.autosave_option; 'Salvataggio automatico'; end
  def self.autosave_help; 'Attiva o disattiva il salvataggio automatico|in determinate situazioni del gioco.'; end
end

#==============================================================================
# ** Game_System
#==============================================================================
class Game_System
  attr_accessor :autosave_setting
  #--------------------------------------------------------------------------
  # * determina se l'autosalvataggio è abilitato
  #--------------------------------------------------------------------------
  def autosave_enabled?; @autosave_setting; end
end

#==============================================================================
# ** Game_Temp
#==============================================================================
class Game_Temp
  attr_accessor :temp_fog
end

#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # * Alias dei metodi
  # noinspection RubyResolve
  #--------------------------------------------------------------------------
  class << self
    alias sgwr_autos save_game_without_rescue
    alias lgwr_autos load_game_without_rescue
  end
  #--------------------------------------------------------------------------
  # * avvia autosalvataggio
  # forced: salva anche se l'opzione è disattivata
  #--------------------------------------------------------------------------
  def self.autosave(forced = false, show_popup = true)
    return if @actual_saveslot.nil?
    return unless forced or $game_system.autosave_enabled?
    autosave_result = save_game(@actual_saveslot)
    if autosave_result
      Logger.info "Autosalvataggio riuscito"
    else
      Logger.error "Autosalvataggio fallito"
    end
    if show_popup
      autosave_result ? popup_save_ok : popup_save_failed
    end
    autosave_result
  end
  #--------------------------------------------------------------------------
  # * mostra il popup di salvataggio riuscito
  #--------------------------------------------------------------------------
  def self.popup_save_ok
    return unless SceneManager.scene_is? Scene_Map
    $game_map.add_popup([1254, Vocab.autosave_success], Tone.new(0,255,0,100))
  end
  #--------------------------------------------------------------------------
  # * mostra il popup di salvataggio fallito
  #--------------------------------------------------------------------------
  def self.popup_save_failed
    return unless SceneManager.scene_is? Scene_Map
    $game_map.add_popup([1254, Vocab.autosave_failed], Tone.new(255,0,0,100))
  end
  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  def self.save_game_without_rescue(index)
    sgwr_autos(index)
    @actual_saveslot = index
    return true
  end
  #--------------------------------------------------------------------------
  # * Execute Load (No Exception Processing)
  #--------------------------------------------------------------------------
  def self.load_game_without_rescue(index)
    lgwr_autos(index)
    @actual_saveslot = index
    return true
  end
end

#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Chiama l'autosalvataggio
  #--------------------------------------------------------------------------
  def autosave(forced = false); DataManager.autosave(forced); end
end

#==============================================================================
# ** Option
#==============================================================================
class Option
  #--------------------------------------------------------------------------
  # * aggiorna lo stato dell'autosalvataggio
  #--------------------------------------------------------------------------
  def update_autosave(value)
    $game_system.autosave_setting = value
  end
  #--------------------------------------------------------------------------
  # * ottiene lo stato dell'autosalvataggio
  #--------------------------------------------------------------------------
  def get_autosave; $game_system.autosave_enabled?; end
end

H87Options.push_game_option(
    { :type => :switch,   #tipo variabile
      :text => Vocab.autosave_option,#testo mostrato
      :help => Vocab.autosave_help, #descrizione
      :values => [1,2,3,4,5,6,7,8],
      :method => :update_autosave,
      :val_mt => :get_autosave,
      :on => 'ON', :off => 'OFF'
    }
)