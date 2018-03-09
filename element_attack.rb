require 'rm_vx_data'
=begin
EFFETTI ELEMENTALI V1.0
Questo script aggiunge gli effetti elementali e di status delle armi anche alle skill.
Ad esempio, se la spada ha elemento fuoco, anche la skill Sferzata avrà lo stesso
elemento.
=end
module StateRateSettings
  RATE = 30 # % PROBABILITA' DI INSERIRE LO STATO NELLA SKILL
  OFF_MAGICRATE = 20
  DEF_MAGICRATE = 10
end
#===============================================================================
# ** Classe Game_Battler
#===============================================================================
class Game_Battler
  alias default_make_obk_damage_value make_obj_damage_value unless $@
  #--------------------------------------------------------------------------
  # * Calcolo del danno di un'Abilità o Oggetto
  #     user : Chi usa l'oggetto o l'abilità
  #     obj  : Potere o oggetto (Se è nil è un attacco normale)
  #    I risultati sono assegnati a @hp_damage o @mp_damage.
  # @param [Game_Battler] user
  # @param [RPG::UsableItem] obj
  #--------------------------------------------------------------------------
  def make_obj_damage_value(user, obj)
    if obj.atk_f > 0
      $game_temp.equip_elements = user.element_set
      $game_temp.equip_states = user.plus_state_set
    else
      $game_temp.equip_elements = []
      $game_temp.equip_states = []
    end
    if user.actor?
      $game_temp.equip_elements |= user.plus_state_equip if obj.offensive_magic?
      $game_temp.equip_states |= user.heal_state_equip if obj.defensive_magic?
    end
    default_make_obk_damage_value(user, obj)
    $game_temp.equip_states.clear
    $game_temp.equip_elements.clear
  end
  #-----------------------------------------------------------------------------
  # * stati inflitti dall'equipaggiamento (ridefinito in game_actor)
  #-----------------------------------------------------------------------------
  def plus_state_equip; []; end
end #game_battler

#===============================================================================
# ** Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  #-----------------------------------------------------------------------------
  # * aggiunge gli status alla skill derivanti dall'equipaggiamento
  # @return [Arrayt]
  #-----------------------------------------------------------------------------
  def plus_state_equip
    states = []
    equips.each {|equip|
      next if equip.nil?
      equip.magic_states_plus.each {|state_id|
        next if rand(100) >= StateRateSettings::OFF_MAGICRATE - 1
        states.push(state_id)
      }
    }
    states
  end
  #-----------------------------------------------------------------------------
  # * restituisce gli stati aggiunti alla skill curativa dall'equipaggiamento
  #-----------------------------------------------------------------------------
  def heal_state_equip
    states = []
    equips.each {|equip|
      next if equip.nil?
      equip.heal_states_plus.each {|state_id|
        next if rand(100) >= StateRateSettings::DEF_MAGICRATE - 1
        states.push(state_id)
      }
    }
    states
  end
end

#===============================================================================
# ** Game_Temp
#===============================================================================
class Game_Temp
  # @attr [Array] equip_elements
  # @attr [Array] equip_states
  attr_accessor :equip_elements   # elementi aggiunti dall'equipaggiamento
  attr_accessor :equip_states     # elementi aggiunti allo status
  # mi serve utilizzare una variabile globale temporanea perché non c'è modo di
  # passare i dati dell'eroe all'arma per ricavarne gli stati elementali senza
  # riscrivere buona parte dei metodi. Così invece è più pulito
end

#===============================================================================
# ** RPG::UsableItem
#===============================================================================
class RPG::UsableItem
  alias obelemset element_set unless $@
  alias obstateset plus_state_set unless $@
  #-----------------------------------------------------------------------------
  # *caricamento poteri
  #-----------------------------------------------------------------------------
  def carica_eoa
    return if @cache_eoa
    @cache_eoa = true
    @force_noelement = false
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
        #---
        when /<noelement>/i
          @force_noelement = true
        else
          # type code here
      end
    }
  end
  #-----------------------------------------------------------------------------
  # * Alias element_set
  # @return [Array]
  #-----------------------------------------------------------------------------
  def element_set
    first_set = obelemset
    if !force_noelement and $game_temp.equip_elements != nil
      first_set |= $game_temp.equip_elements
    end
    first_set
  end
  #-----------------------------------------------------------------------------
  # * Alias plus_state_set
  #-----------------------------------------------------------------------------
  def plus_state_set
    first_set = obstateset.clone
    if !force_noelement and $game_temp.equip_states != nil
      $game_temp.equip_states.each {|state_id|
        next if first_set.include?(state_id)
        next if rand(100) > StateRateSettings::RATE - 1
        first_set.add(state_id)
      }
    end
    first_set
  end
  #-----------------------------------------------------------------------------
  # * Controlla se l'arma non deve dare elementi
  #-----------------------------------------------------------------------------
  def force_noelement; true if @force_noelement; end
  #-----------------------------------------------------------------------------
  # * è una magia d'attacco?
  #-----------------------------------------------------------------------------
  def offensive_magic?
    return false unless self.is_a?(RPG::Skill)
    return false if self.spi_f <= 0
    self.for_opponent?
  end
  #-----------------------------------------------------------------------------
  # * è una magia curativa?
  #-----------------------------------------------------------------------------
  def defensive_magic?
    return false unless self.is_a?(RPG::Skill)
    return false if self.spi_f <= 0
    for_friend? || for_user?
  end
end #usable_item

#===============================================================================
# ** RPG::Weapon
#===============================================================================
class RPG::Weapon
  attr_reader :magic_states_plus
  attr_reader :heal_states_plus
  #-----------------------------------------------------------------------------
  # *caricamento poteri
  #-----------------------------------------------------------------------------
  def carica_eoa
    return if @cache_eoa
    @cache_eoa = true
    @magic_states_plus = []
    @heal_states_plus = []
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
        #---
        when /<magic state[ ]*:[ ](\d+)[ ]*>/i
          @magic_states_plus.push($1.to_i)
        when /<heal state[ ]*:[ ](\d+)[ ]*>/i
          @heal_states_plus.push($1.to_i)
        else
          # type code here
      end
    }
  end
end

#===============================================================================
# ** RPG::Armor
#===============================================================================
class RPG::Armor
  attr_reader :magic_states_plus
  attr_reader :heal_states_plus
  #-----------------------------------------------------------------------------
  # *caricamento poteri
  #-----------------------------------------------------------------------------
  def carica_eoa
    return if @cache_eoa
    @cache_eoa = true
    @magic_states_plus = []
    @heal_states_plus = []
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
        #---
        when /<magic state[ ]*:[ ](\d+)[ ]*>/i
          @magic_states_plus.push($1.to_i)
        when /<heal state[ ]*:[ ](\d+)[ ]*>/i
          @heal_states_plus.push($1.to_i)
        else
          # type code here
      end
    }
  end
end

#===============================================================================
# ** Classe Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  #-----------------------------------------------------------------------------
  # *Alias metodo load_bt_database
  #-----------------------------------------------------------------------------
  alias carica_dbeoa load_bt_database unless $@
  def load_bt_database
    carica_dbeoa
    carica_skills_eoa
  end
  #-----------------------------------------------------------------------------
  # *Alias metodo load_database
  #-----------------------------------------------------------------------------
  alias carica_db_eoa load_database unless $@
  def load_database
    carica_db_eoa
    carica_skills_eoa
  end
  #-----------------------------------------------------------------------------
  # Inizializza nel caricamento
  #-----------------------------------------------------------------------------
  def carica_skills_eoa
    $data_skills.each {|skill|
      next if skill == nil
      skill.carica_eoa
    }
    $data_items.each {|item|
      next if item == nil
      item.carica_eoa
    }
    $data_armors.each {|armor|
      next if armor.nil?
      armor.carica_eoa
    }
    $data_weapons.each {|weapon|
      next if weapon.nil?
      weapon.carica_eoa
    }
  end
end # scene_title