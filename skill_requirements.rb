$imported = {} if $imported == nil
$imported["H87_SkillReq"] = 1.1
#===============================================================================
# Requisiti abilità di Holy87
# Difficoltà utente: ★★
# Versione 1.1
#===============================================================================
# Questo script fa in modo che per usare una determinata abilità debbano essere
# soddisfatte alcune condizioni, come il tipo di equipaggiamento, uno status
# inflitto, o un certo livello di PV/PM.
# <hp minimi: x%> perchè la skill sia utilizzabile con almeno x% hp restanti
# <mp minimi: x%> perchè la skill sia utilizzabile con almeno x% mp restanti
# <hp sotto: x%> se la skill è utilizzabile solo se gli hp sono sotto il x%.
# <mp sotto: x%> se la skill è utilizzabile solo se gli mp sono sotto il x%.
# <richiede stato: x> l'abilità è utilizzabile solo se l'eroe ha lo stato x.
# <disattiva stato: x> l'abilità è inutilizzabile se l'eroe ha lo stato x.
# <richiede equip: x> l'abilità richiede un certo tipo di equipaggiamento*.
# <richiede switch: x> l'abilità può essere usata solo se lo switch x è ON.
# <custom req: x> ha un requisito speciale che viene convertito in script.
# esempio: <custom req: $game_variables[5] == 0>
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main.
# Inserisci nelle notetag dei poteri la tag desiderata.
#
# * CONFIGURAZIONE E ISTRUZIONI EQUIPAGGIAMENTO
# Puoi impostare che un equipaggiamento di un determinato tipo per poi
# essere utilizzato da un'abilità. Ad esempio, è bene impostare l'abilità
# "Spada fiammeggiante" in modo che sia utilizzabile solo se l'eroe ha
# una spada equipaggiata mettendo nelle tag dell'abilità <richiede equip: spada>
# si andrà poi a mettere dentro le note di ogni spada l'etichetta <tipo: spada>,
# in modo da far capire allo script che quella è una spada e che permette di
# utilizzare l'abilità "Spada fiammeggiante". L'equipaggiamento vale anche per
# le armature, infatti è possibile impostare la tag <tipo: scudo> agli scudi in
# modo da poter far usare all'eroe "colpo con lo scudo" solo se ha uno scudo
# effettivamente equipaggiato. È anche possibile, infine, fare in modo che
# siano necessari più equipaggiamenti per usare l'abilità. Ad esempio, l'abilità
# "Doppia lama" si usa con due spade, quindi scriveremo due volte
# <richiede equip: spada>
# <richiede equip: spada>
#===============================================================================
# Compatibilità: Compatibile al 100% con il Tankentai SBS 3.4e + ATB
#
# Game_Battler -> alias di skill_can_use?
#===============================================================================


#===============================================================================
# ** Vocab
#===============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * definisce i tipi di equipaggiamento
  #--------------------------------------------------------------------------
  WTypes = {
      :blunt => "Ascia/Mazza",
      :claw => "Artigli",
      :spada => "Spada",
      :daga => "Pugnale",
      :lancia => "Lancia",
      :boomerang => "Boomerang",
      :arco => "Arco",
      :fucile => "Arma da fuoco",
      :light => "Armatura leggera",
      :heavy => "Armatura pesante",
      :robe => "Tunica",
      :scudo => "Scudo",
  }
  #--------------------------------------------------------------------------
  # * restituisce la stringa del tipo d'arma
  #--------------------------------------------------------------------------
  def self.wtype(type)
    return WTypes[type.to_sym]
  end
end

#===============================================================================
# ** H87_SkillReq
#===============================================================================
module H87_SkillReq
  Tipo = /<tipo:[ ](.*)>/i
  Req_Eq = /<richiede equip:[ ](.*)>/i
  Req_Status = /<richiede stato:[ ]*(\d+)>/i
  Req_No_Status = /<disattiva stato:[ ]*(\d+)>/i
  Req_Switch = /<richiede switch:[ ]*(\d+)>/i
  Req_hp_minus = /<hp minimi:[ ]*(\d+)([%％])>/i
  Req_mp_minus = /<mp minimi:[ ]*(\d+)([%％])>/i
  Req_hp_max = /<hp sotto:[ ]*(\d+)([%％])>/i
  Req_mp_max = /<mp sotto:[ ]*(\d+)([%％])>/i
  Req_Custom = /^<custom req:[ ]*(.+)>$/i
end

#===============================================================================
# ** Classe Armi
#===============================================================================
class RPG::Weapon
  # @return [Array<String>] w_types
  attr_reader :w_types
  #--------------------------------------------------------------------------
  # * caricamento cache
  #--------------------------------------------------------------------------
  def load_skill_requirements
    return if @skill_requirements_charged
    @skill_requirements_charged = true
    @w_types = []
    self.note.split(/[\r\n]+/).each { |line|
      case line
        when H87_SkillReq::Tipo
          @w_types.push($1.to_s.lstrip)
        else
          # type code here
      end
    }
  end

end #weapon

#===============================================================================
# ** Classe Armature
#===============================================================================
class RPG::Armor
  # @return [Array<String>] w_types
  attr_reader :w_types
  #--------------------------------------------------------------------------
  # * cache...
  #--------------------------------------------------------------------------
  def load_skill_requirements
    return if @skill_requirements_charged
    @skill_requirements_charged=true
    @w_types = []
    self.note.split(/[\r\n]+/).each { |line|
      case line
        when H87_SkillReq::Tipo
          @w_types.push($1.to_s.lstrip)
        else
          # type code here
      end
    }
  end
end #weapon

#===============================================================================
# ** Classe Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * restituisce i tipi di equip in possesso
  # @return [Array<String>]
  #--------------------------------------------------------------------------
  def equip_types
    equip = []
    weapons.each{|weapon|
      next if weapon == nil
      weapon.w_types.each{|a|equip.push(a)}
    }
    armors.each{|eq|
      next if eq == nil
      eq.w_types.each{|a|equip.push(a)}
    }
    equip
  end

end #game_actor

#===============================================================================
# ** Classe Skill
#===============================================================================
class RPG::Skill
  # @return [Array<String>] required_eq
  attr_reader :required_eq
  # @return [Array<Integer>] required_status
  attr_reader :required_status
  attr_reader :stati_ric
  attr_reader :stato_bloc
  attr_reader :hp_req_min
  attr_reader :hp_req_max
  attr_reader :mp_req_min
  attr_reader :mp_req_max
  attr_reader :req_switch
  attr_reader :custom_req
  #--------------------------------------------------------------------------
  # * caricamento cc
  #--------------------------------------------------------------------------
  def load_skill_requirements
    return if @skill_requirements_charged
    @skill_requirements_charged=true
    @required_eq = []
    @required_status = []
    @stati_ric = 0
    @stato_bloc = 0
    @hp_req_min = 0
    @hp_req_max = 0
    @mp_req_min = 0
    @mp_req_max = -1
    @req_switch = 0
    @custom_req = nil
    self.note.split(/[\r\n]+/).each { |line|
      case line
        when H87_SkillReq::Req_Eq
          @required_eq.push($1.to_s.lstrip)
        when H87_SkillReq::Req_Status
          @stati_ric = $1.to_i
          @stati_ric = 0 if @stati_ric < 0
        when H87_SkillReq::Req_No_Status
          @stato_bloc = $1.to_i
          @stato_bloc = 0 if @stato_bloc < 0
        when H87_SkillReq::Req_hp_minus
          @hp_req_min = $1.to_i
          @hp_req_min = 0 if @hp_req_min < 0
          @hp_req_min = 100 if @hp_req_min > 100
        when H87_SkillReq::Req_mp_minus
          @mp_req_min = $1.to_i
          @mp_req_min = 0 if @mp_req_min < 0
          @mp_req_min = 100 if @mp_req_min > 100
        when H87_SkillReq::Req_hp_max
          @hp_req_max = $1.to_i
          @hp_req_max = 0 if @hp_req_max < 0
          @hp_req_max = 100 if @hp_req_max > 100
        when H87_SkillReq::Req_mp_max
          @mp_req_max = $1.to_i
          @mp_req_max = -1 if @mp_req_max < -1
          @mp_req_max = 100 if @mp_req_max > 100
        when H87_SkillReq::Req_Switch
          @req_switch = $1.to_i
        when H87_SkillReq::Req_Custom
          @custom_req = $1
        else
          # type code here
      end
    }
  end
end #skill

#==============================================================================
# ** Scene_Title
#==============================================================================
class Scene_Title < Scene_Base
  #-----------------------------------------------------------------------------
  # *Alias metodo load_bt_database
  #-----------------------------------------------------------------------------
  alias carica_dbt load_bt_database unless $@
  def load_bt_database
    carica_dbt
    carica_skills_tipo
    carica_armor_tipo
    carica_weapon_tipo
  end
  #-----------------------------------------------------------------------------
  # *Alias metodo load_database
  #-----------------------------------------------------------------------------
  alias carica_db_2t load_database unless $@
  def load_database
    carica_db_2t
    carica_skills_tipo
    carica_armor_tipo
    carica_weapon_tipo
  end
  #-----------------------------------------------------------------------------
  # Inizializza nel caricamento
  #-----------------------------------------------------------------------------
  def carica_skills_tipo
    $data_skills.each {|skill|
      next if skill == nil
      skill.load_skill_requirements
    }
  end
  #--------------------------------------------------------------------------
  # * imposta i tipi armatura
  #--------------------------------------------------------------------------
  def carica_armor_tipo
    $data_armors.each {|armor|
      next if armor == nil
      armor.load_skill_requirements
    }
  end
  #--------------------------------------------------------------------------
  # * imposta i tipi arma
  #--------------------------------------------------------------------------
  def carica_weapon_tipo
    $data_weapons.each {|weapon|
      next if weapon == nil
      weapon.load_skill_requirements
    }
  end
end # scene_title

#===============================================================================
# * Classe Game_Battler
#===============================================================================
class Game_Battler
  alias normal_requirements skill_can_use? unless $@
  #-----------------------------------------------------------------------------
  # *Alias metodo skill_can_use?
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def skill_can_use?(skill)
    return false if req_equip_no_pres(skill) and actor?
    return false if no_req_state(skill)
    return false if blocked_by_state(skill)
    return false if hp_too_much(skill)
    return false if mp_too_much(skill)
    return false if hp_no_enough(skill)
    return false if mp_no_enough(skill)
    return false if req_switch_off(skill)
    return false if req_custom(skill)
    normal_requirements(skill)
  end
  #-----------------------------------------------------------------------------
  # *Restituisce true se non sono soddisfatti i requisiti di equip
  # noinspection RubyResolve
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def req_equip_no_pres(skill)
    return unless actor?
    return false if skill.required_eq.size == 0
    etypes = equip_types
    return true if e_types.size < skill.required_eq.size
    skill.required_eq.each do |req|
      found = false
      (0..e_types.size-1).each {|i|
        if e_types[i]==req
          e_types[i]=""
          found = true
          break
        end
      }
      return true unless found
    end
    false
  end
  #-----------------------------------------------------------------------------
  # restituisce true se non è presente lo stato richiesto.
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def no_req_state(skill)
    !(skill.stati_ric == 0 or states.include?($data_states[skill.stati_ric]))
  end
  #-----------------------------------------------------------------------------
  # restituisce true se c'è uno stato che blocca la skill.
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def blocked_by_state(skill)
    states.include?($data_states[skill.stato_bloc])
  end
  #-----------------------------------------------------------------------------
  # restituisce true se gli hp sono troppi per usare la skill.
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def hp_too_much(skill)
    return false if skill.hp_req_max == 0
    perc = hp*100/maxhp
    return true if perc > skill.hp_req_max
    false
  end
  #-----------------------------------------------------------------------------
  # restituisce true se gli mp sono troppi per usare la skill.
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def mp_too_much(skill)
    return false if skill.mp_req_max == -1
    perc = mp*100/[maxmp,1].max
    return true if perc > skill.mp_req_max
    false
  end
  #-----------------------------------------------------------------------------
  # restituisce true se non ci sono abbastanza hp per usare la skill.
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def hp_no_enough(skill)
    return false if skill.hp_req_min == 0
    perc = hp*100/maxhp
    return true if perc <= skill.hp_req_min
    false
  end
  #-----------------------------------------------------------------------------
  # restituisce true se non ci sono abbastanza mp per usare la skill.
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def mp_no_enough(skill)
    return false if skill.mp_req_min == 0
    perc = mp*100/maxmp
    return true if perc <= skill.mp_req_min
    false
  end
  #-----------------------------------------------------------------------------
  # restituisce true se lo switch non è attivato.
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def req_switch_off(skill)
    return false if skill.req_switch == 0
    !$game_switches[skill.req_switch]
  end
  #-----------------------------------------------------------------------------
  # restituisce true se il requisito della skill non è valido
  # @param [RPG::Skill] skill
  #-----------------------------------------------------------------------------
  def req_custom(skill)
    return false if skill.custom_req.nil?
    !eval(skill.custom_req)
  end
  #--------------------------------------------------------------------------
  # * restituisce i tipi di equip in possesso
  # @return [Array<String>]
  #--------------------------------------------------------------------------
  def equip_types; []; end
end #game_battler