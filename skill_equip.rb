=begin
SKILL EQUPPABILI v1.0
Questo script mi permette di creare status ed equipaggiamenti che possono
aggiungere o nascondere skill all'eroe.
=end

#==============================================================================
# ** H87SkillAdder
#==============================================================================
module H87SkillAdder
  attr_reader :skill_adding     # ID skill da aggiungere
  attr_reader :skill_removing   # ID skill da nascondere
  #-----------------------------------------------------------------------------
  # * controllo all'avvio del gioco sugli attributi
  #-----------------------------------------------------------------------------
  def check_skill_equip
    return if @skill_equip_checked
    @skill_equip_checked
    @skill_adding = []
    @skill_removing = []
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
        #---
        when /<aggiungi skill:[ ]*(\d+)>/i
          @skill_adding.push($1.to_i)
        when /<rimuovi skill:[ ]*(\d+)>/i
          @skill_removing.push($1.to_i)
        else
          #niente
      end
    }
  end
end

#==============================================================================
# ** RPG::Weapon
#==============================================================================
class RPG::Weapon; include H87SkillAdder; end
#==============================================================================
# ** RPG::Armor
#==============================================================================
class RPG::Armor; include H87SkillAdder; end
#==============================================================================
# ** RPG::State
#==============================================================================
class RPG::State; include H87SkillAdder; end

#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  alias equip__skills skills unless $@
  #-----------------------------------------------------------------------------
  # * restituisce l'array delle skill aggiungibili all'eroe
  # @return [Array<RPG::Skill>]
  #-----------------------------------------------------------------------------
  def plus_equip_skills
    pskills = []
    equips.each {|equip|
      next if equip.nil?
      pskills |= equip.skill_adding
    }
    states.each {|state|
      next if state.nil?
      pskills |= state.skill_adding
    }
    oskills = []
    pskills.each do |skill|
      oskills.push($data_skills[skill])
    end
    oskills
  end
  #-----------------------------------------------------------------------------
  # * restituisce l'array delle skill da nascondere all'eroe
  # @return [Array<RPG::Skill>]
  #-----------------------------------------------------------------------------
  def minus_equip_skills
    mskills = []
    equips.each {|equip|
      next if equip.nil?
      mskills |= equip.skill_removing
    }
    states.each {|state|
      next if state.nil?
      mskills |= state.skill_removing
    }
    oskills = []
    mskills.each do |skill|
      oskills.push($data_skills[skill])
    end
    oskills
  end
  #-----------------------------------------------------------------------------
  # * restituisce le skill dell'eroe
  # @return [Array<RPG::Skill>]
  #-----------------------------------------------------------------------------
  def skills
    normal_skills = equip__skills
    normal_skills |= plus_equip_skills
    normal_skills -= minus_equip_skills
    normal_skills
  end
end

#==============================================================================
# ** Scene_Title
#==============================================================================
class Scene_Title < Scene_Base
  #-----------------------------------------------------------------------------
  # *Alias metodo load_bt_database
  #-----------------------------------------------------------------------------
  alias carica_dbws load_bt_database unless $@
  def load_bt_database
    carica_dbws
    load_armor_skills
    load_weapon_skills
    load_state_skills
  end
  #-----------------------------------------------------------------------------
  # *Alias metodo load_database
  #-----------------------------------------------------------------------------
  alias carica_db_ws load_database unless $@
  def load_database
    carica_db_ws
    load_armor_skills
    load_weapon_skills
    load_state_skills
  end
  #-----------------------------------------------------------------------------
  # Inizializza nel caricamento
  #-----------------------------------------------------------------------------
  def load_armor_skills
    $data_armors.each {|armor|
      next if armor == nil
      armor.check_skill_equip
    }
  end
  #-----------------------------------------------------------------------------
  # Inizializza nel caricamento
  #-----------------------------------------------------------------------------
  def load_weapon_skills
    $data_weapons.each {|weapon|
      next if weapon == nil
      weapon.check_skill_equip
    }
  end
  #-----------------------------------------------------------------------------
  # Inizializza nel caricamento
  #-----------------------------------------------------------------------------
  def load_state_skills
    $data_states.each {|state|
      next if state == nil
      state.check_skill_equip
    }
  end
end # scene_title