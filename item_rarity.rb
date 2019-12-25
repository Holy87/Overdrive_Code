=begin
===============================================================================
 ** RARITÀ OGGETTI di Holy87 (v1.0)
-------------------------------------------------------------------------------
 Descrizione:
 Questo script serve per assegnare una rarità agli oggetti (ovviamente).
 Verrà mostrata una cornice colorata attorno l'icona dell'equip.
-------------------------------------------------------------------------------
 Istruzioni:
 ● Inserire lo script sotto Materials e prima del Main.
 ● Assegnare il tag <rarity: X> dove X è il tipo di rarità (da configurare)
===============================================================================
=end

#==============================================================================
# ** Impostazioni della rarità
#==============================================================================
module Rarity_Settings
  SHOW_RARITY_ICONS = false

  RARITY_ICONS = {
      0 => 0,   # Icona cornice per oggetti comuni
      1 => 685, # Icona cornice per oggetti rari
      2 => 686, # Icona cornice per oggetti leggendari
      3 => 687, # Icona cornice per oggetti esotici
      4 => 684, # Icona cornice per oggetti evento
  }

  # Nomi dei livelli di rarità
  RARITY_STRINGS = {
      0 => 'Comune',
      1 => 'Raro',
      2 => 'Leggendario',
      3 => 'Esotico',
      4 => 'Evento',
  }

  # Colori dei livelli di rarità (dal tema)
  RARITY_THEME_COLORS = {
      1 => 23,
      2 => 31,
      3 => 21,
      4 => 29
  }
end

#==============================================================================
# ** Vocab
#---------------------------------------------------------------------------
# Aggiunta del vocabolo di tipo rarità (per essere utilizzato altrove)
#==============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Restituisce il grado della rarità
  # @param [Integer] grade
  # @return [String]
  #--------------------------------------------------------------------------
  def self.rarity(grade)
    Rarity_Settings::RARITY_STRINGS[grade]
  end
end

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Restituisce il colore del livello di rarità
  # @param [Integer] rarity
  # @return [Color]
  #--------------------------------------------------------------------------
  def rarity_color(rarity)
    text_color(Rarity_Settings::RARITY_THEME_COLORS[rarity])
  end
end

#==============================================================================
# ** Rarity Module
#---------------------------------------------------------------------------
# Aggiunge i metodi all'item
#==============================================================================
module Rarity_Mod
  attr_reader :rarity #rarità dell'oggetto
  #--------------------------------------------------------------------------
  # * Inizializzazione della rarità degli oggetti
  #--------------------------------------------------------------------------
  def initialize_rarity
    return if @rarity_initialized
    @rarity_initialized = true
    @rarity = 0
    self.note.split(/[\r\n]+/).each { |riga|
      if riga =~ /<rarity:[ ]*(\d+)>/i
        @rarity = $1.to_i
      end
    }
  end
  #--------------------------------------------------------------------------
  # * Restituisce se l'oggetto è comune
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def not_common?; @rarity > 0; end
  #--------------------------------------------------------------------------
  # * Restituisce l'icona della cornice della rarità
  # @return [Integer]
  #--------------------------------------------------------------------------
  def rarity_icon
    Rarity_Settings::RARITY_ICONS[@rarity]
  end
end

#==============================================================================
# ** DataManager
#---------------------------------------------------------------------------
# Aggiunta dei metodi per caricare le informazioni della rarità sugli equip
#==============================================================================
module DataManager
  # noinspection ALL
  class << self
    alias h87_ir_l_n_db load_normal_database
    alias h87_ir_l_bt_db load_battle_test_database
  end
  #--------------------------------------------------------------------------
  # * Carica il db per il gioco
  #--------------------------------------------------------------------------
  def self.load_normal_database
    h87_ir_l_n_db
    load_rarity_params
  end
  #--------------------------------------------------------------------------
  # * Carica il db per il battle test
  #--------------------------------------------------------------------------
  def self.load_battle_test_database
    h87_ir_l_bt_db
    load_rarity_params
  end
  #--------------------------------------------------------------------------
  # * Carica i parametri di rarità
  #--------------------------------------------------------------------------
  # noinspection RubyResolve
  def self.load_rarity_params
    datas = [$data_armors, $data_weapons, $data_items]
    datas.each do |data|
      data.each do |item|
        next if item.nil?
        item.initialize_rarity
      end
    end
  end
end

#==============================================================================
# ** Modifica armi e armature
#==============================================================================
module RPG
  class BaseItem
    include Rarity_Mod
  end
end

#==============================================================================
# ** Window_Base
#---------------------------------------------------------------------------
# Aggiunta dei metodi per il disegno della cornice
#==============================================================================
class Window_Base < Window
  alias h87_ir_draw_item_name draw_item_name unless $@
  alias h87_ir_normal_color normal_color unless $@
  #--------------------------------------------------------------------------
  # * Disegna il nome dell'oggetto (alias)
  # @param [RPG::BaseItem] item
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    if item && (item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor))
      draw_item_rarity(item, x, y, enabled)
      @rarity = item.not_common? ? Rarity_Settings::RARITY_THEME_COLORS[item.rarity] : nil
    end
    h87_ir_draw_item_name(item, x, y, enabled, width)
  end
  #--------------------------------------------------------------------------
  # * Mostra la rarità dell'oggetto
  # @param [RPG::BaseItem] item
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def draw_item_rarity(item, x, y, enabled)
    return unless item.not_common? && Rarity_Settings::SHOW_RARITY_ICONS
    contents.draw_icon(item.rarity_icon, x, y, enabled)
  end
  #--------------------------------------------------------------------------
  # * Ridefinizione del metodo normal_color per cambiare colore ad oggetti
  #   rari
  # @return [Color]
  #--------------------------------------------------------------------------
  def normal_color
    return h87_ir_normal_color unless @rarity
    color = text_color(@rarity)
    @rarity = nil
    color
  end
end