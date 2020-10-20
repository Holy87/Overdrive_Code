module SaveConfig
  module_function

  MENUOPACITY = 0
  EMPTYSLOT_ICON = 496
  FULLSLOT_ICON = 497
end

#==============================================================================
# ** modulo Vocab
#==============================================================================
module Vocab
  def self.help_profile
    "Seleziona il profilo con cui giocare."
  end

  def self.save_loading
    "Caricamento in corso..."
  end

  def self.save_delete
    "Elimina"
  end

  def self.save_move
    "Sposta"
  end

  def self.save_export
    "Esporta"
  end

  def self.delete_confirm
    "Sei sicuro di volerlo eliminare?"
  end

  def self.play_time
    "Tempo di gioco: "
  end

  def self.story
    "Storia %d%"
  end

  def self.slot_empty
    "File vuoto"
  end

  def self.slot
    "Blocco %d"
  end

  def self.player_name
    "Giocatore: "
  end

  def self.slot_empty_info
    "Il blocco di salvataggio è vuoto.|Puoi salvare il gioco qui."
  end

  def self.save_date
    "Data: "
  end

  def self.screen_loading
    "Caricamento..."
  end

  def self.missions
    "Missioni:"
  end

  def self.renaming
    "Nuovo nome del salvataggio:"
  end

  SAVE_RENAME = "Rinomina"
  SAVE_DELETE = "Elimina"
  SAVE_NON = "Annulla"
  SAVE_RENAME_DESC = "Assegna un nome al salvataggio."
  SAVE_DELETE_DESC = "Elimina questo salvataggio."
  SAVE_DELETE_QUESTION = "Elimina"
  SAVE_OVERRIDE_QUESTION = "Sovrascrivi"
  SAVE_LOAD_QUESTION = "Carica"
end

#==============================================================================
# ** modulo DataManager
#==============================================================================
module DataManager
  class << self
    alias msh make_save_header
    alias sgwr_h87s save_game_without_rescue
    alias rgss3_save_game_without_rescue save_game_without_rescue
    alias rgss3_load_game_without_rescue load_game_without_rescue
    alias rgss3_last_savefile_index last_savefile_index
  end

  def self.make_save_header
    header = msh
    header[:map_name] = $game_map.map_name
    header[:save_name] = $game_system.save_name
    header[:player_name] = $game_system.player_name
    header[:gold] = $game_party.gold
    header[:story] = $game_variables[72]
    header[:key] = $game_system.refresh_key
    header[:missions] = $game_variables[17]
    header
  end

  def self.save_game_without_rescue(index)
    rgss3_save_game_without_rescue(index)
    $game_settings[:last_savefile_index] = @last_savefile_index
  end

  def self.load_game_without_rescue(index)
    rgss3_load_game_without_rescue(index)
    $game_settings[:last_savefile_index] = @last_savefile_index
  end

  def self.last_savefile_index
    $game_settings[:last_savefile_index] ||= latest_savefile_index
  end

  # rinomina il salvataggio
  #noinspection RubyResolve
  def self.rename_save(index, new_name)
    File.open(make_filename(index), "rb") do |file|
      @header = Marshal.load(file)
      @game = (Marshal.load(file))
    end
    @header[:save_name] = new_name
    @game[:system].set_save_name(new_name)
    File.open(make_filename(index), "wb") do |file|
      Marshal.dump(@header, file)
      Marshal.dump(@game, file)
    end
  end
end

#==============================================================================
# ** classe Game_Temp
#==============================================================================
class Game_Temp
  attr_accessor :last_savefile_index
  attr_accessor :save_slot_creation
end

#==============================================================================
# ** classe Game_System
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Restituisce il nome del salvataggio
  #--------------------------------------------------------------------------
  def save_name
    @save_name ||= ''
  end

  #--------------------------------------------------------------------------
  # * Crea una nuova chiave
  #--------------------------------------------------------------------------
  def refresh_key
    @save_key = String.random(10)
  end

  #--------------------------------------------------------------------------
  # * Ottiene la chiave
  #--------------------------------------------------------------------------
  def save_key
    @save_key ||= refresh_key
  end

  #--------------------------------------------------------------------------
  # * Imposta un nuovo nome per il salvataggio
  #--------------------------------------------------------------------------
  def set_save_name(new_name)
    @save_name = new_name
  end
end

#gane_system
