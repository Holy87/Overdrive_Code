require 'rm_vx_data'

#===============================================================================
# **
#-------------------------------------------------------------------------------
#
#===============================================================================
module Skill_PUP_Settings
  PAIRING_PARAMS = [:base_damage, :spi_f, :atk_f, :def_f, :agi_f, :plus_state_set,
                    :minut_state_set, :damage, :mp_cost, :hp_cost, :anger_cost,
                    :element_set, :hit, :aggro_set, :grudge_set, :state_inf_dur,
                    :anger_rate, :tank_odd, :syn_bonus]

  SKILL_LEVELS = {
      5 => [
          {:spi_f => 100}
      ]
  }

end

#===============================================================================
# ** RPG::Enemy
#-------------------------------------------------------------------------------
# Aggiunta delle informazioni delle skill potenziate
#===============================================================================
class RPG::Enemy
  attr_accessor :skill_levels
  #--------------------------------------------------------------------------
  # * caricamento delle informazioni
  #--------------------------------------------------------------------------
  def load_powerups
    return if @powered_skills_loaded
    @powered_skills_loaded = true
    @powered_skills = {}
    self.note.split(/[\r\n]+/).each { |line|
      if line =~ /<skill[ ]+(\d+)[ ]+level[ ]+(\d+)>/i
        @powered_skills[$1] = $2 - 1
      end
    }
  end
end

#===============================================================================
# ** RPG::Skill
#-------------------------------------------------------------------------------
# Aggiunta di tutti i metodi per potenziare le skill
#===============================================================================
class RPG::Skill < UsableItem
  attr_accessor :skill_level
  #--------------------------------------------------------------------------
  # * carica le informazioni sui potenziamenti
  #--------------------------------------------------------------------------
  def load_powerups
    return if @power_ups_loaded
    @power_ups_loaded = true
    @base_name = @name
    @power_ups = Skill_PUP_Settings::SKILL_LEVELS[self.id] || []
    @skill_level = 1
  end
  #--------------------------------------------------------------------------
  # * livello massimo
  # @return [Integer]
  #--------------------------------------------------------------------------
  def max_level; power_ups.size + 1; end
  #--------------------------------------------------------------------------
  # * restituisce i potenziamenti per ogni livello
  # @return [Array<Hash>]
  #--------------------------------------------------------------------------
  def power_ups; @power_ups; end
  #--------------------------------------------------------------------------
  # * determina se è potenziata al massimo
  #--------------------------------------------------------------------------
  def level_maxed?; self.skill_level >= max_level; end
  #--------------------------------------------------------------------------
  # * aumenta di livello
  #--------------------------------------------------------------------------
  def level_up
    return if level_maxed?
    apply_level_up(@skill_level + 1)
  end
  #--------------------------------------------------------------------------
  # * livello richiesto per il prossimo potenziamento dell'abilità
  #--------------------------------------------------------------------------
  def required_upgrade_level
    return 1 if level_maxed?
    power_ups[@skill_level][:level_req] || 1
  end
  #--------------------------------------------------------------------------
  # * PA richiesti per il potenziamento
  #--------------------------------------------------------------------------
  def required_upgrade_jp
    return 0 if level_maxed?
    power_ups[@skill_level][:jp_req] || 0
  end
  #--------------------------------------------------------------------------
  # * cambia il livello della skill
  #--------------------------------------------------------------------------
  def apply_level_up(level)
    changes = power_ups[level - 1]
    if changes.nil?
      puts "[ERROR] Powering up #{@name} at lvl #{level} not found"
      return false
    end
    @skill_level = level
    if level > 1
      @name = sprintf('%s lv%d', @base_name, @skill_level)
    else
      @name = @base_name
    end
    changes.each_pair {|key, value| process_level_up_attr(key, value)}
    true
  end
  #--------------------------------------------------------------------------
  # * modifica i parametri della skill a seconda dell'attributo
  # @param [Symbol] param
  # @param [Object] value
  #--------------------------------------------------------------------------
  def process_level_up_attr(param, value)
    case param
    when :damage;     @base_damage = value
    when :states;     @plus_state_set = value
    when :min_states; @minus_state_set = value
    when :animation;  @animation_id = value
    when :icon;       @icon_id = value
    when :aggro;      @aggro_set = value
    when :grudge;     @grudge_set = value
    when :state_dur;  @state_inf_dur = value
    when :anger;      @anger_rate = value
    when :tk_odd;     @tank_odd = value
    else; load_base_attrs(param, value)
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def load_base_attrs(param, value)
    begin
      eval(sprintf('@%s=%s'), param, value.inspect)
    rescue
      err_str = "Error setting skill %d, param %s to %s"
      puts_e(sprintf(err_str, @id, param, value.inspect))
    end
  end
  #--------------------------------------------------------------------------
  # *
  # @param [Integer] level
  # @return [RPG::Skill]
  #--------------------------------------------------------------------------
  def get_skill_for_level(level)
    new_skill = self.clone
    new_skill.plus_state_set = @plus_state_set.clone
    new_skill.apply_level_up(level)
    new_skill
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def power_up_cost(level); power_ups[level - 1][:cost]; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def next_level_cost
    power_up_cost(self.level)
  end
  #--------------------------------------------------------------------------
  # * restituisce le differenze tra i livelli
  # @return [Array]
  #--------------------------------------------------------------------------
  def next_level_compare
    next_lev = get_skill_for_level(@skill_level + 1)
    differences = []
    Skill_PUP_Settings::PAIRING_PARAMS.each{|param|
      if eval("@#{param} == next_lev.#{param}")
        differences.push(param)
      end
    }
    differences
  end
end

#===============================================================================
# **
#-------------------------------------------------------------------------------
#
#===============================================================================
module DataManager
  class << self
    alias h87_spu_load_normal_database load_normal_database
    alias h87_spu_load_battle_test_database load_battle_test_database
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.load_normal_database
    h87_spu_load_normal_database
    parse_powerup_data($data_skills)
    parse_powerup_data($data_enemies)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.load_battle_test_database
    h87_spu_load_battle_test_database
    parse_powerup_data($data_skills)
    parse_powerup_data($data_enemies)
  end
  #--------------------------------------------------------------------------
  # * Carica i dati degli oggetti
  #   collection: collezione di oggetti
  #--------------------------------------------------------------------------
  def self.parse_powerup_data(collection)
    collection.each{|obj| next if obj.nil?; obj.load_powerups}
  end
end

#===============================================================================
# **
#-------------------------------------------------------------------------------
#
#===============================================================================
class Game_Battler < Game_Unit
  alias all_normal_skills skills unless $@
  #--------------------------------------------------------------------------
  # *
  # @return [Array<RPG::Skill>]
  #--------------------------------------------------------------------------
  def skills
    all_skills = all_normal_skills
    all_skills.collect!{|sk|
      sk.get_skill_for_level(skill_level(sk.id) + 1) if skill_leveled?(sk.id)
    }
    all_skills
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_level(skill_id)
    # da implementare nelle sottoclassi
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_leveled?(skill_id); skill_level(skill_id) != nil; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def can_level_up_skill?(skill_id)
    false
  end
end

#===============================================================================
# **
#-------------------------------------------------------------------------------
#
#===============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def level_up_skill(skill_id)
    @skill_levels ||= {}
    if skill_leveled?(skill_id)
      @skill_levels[skill_id] += 1
    else
      @skill_levels[skill_id] = 1
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_level(skill_id)
    @skill_levels ||= {}
    @skill_levels[skill_id] || 1
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def can_level_up_skill?(skill_id)
    skill = $data_skills[skill_id].get_skill_for_level(skill_level(skill_id))
    return false if skill.level_maxed?
    return false if self.jp < skill.required_upgrade_jp
    return false if self.level < skill.required_upgrade_level
    true
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def levellable_skills; skills.select{|skill| !skill.level_maxed?}; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def try_level_skill(skill_id)
    if can_level_up_skill?(skill_id)
      skill = $data_skills[skill_id].get_skill_for_level(skill_level(skill_id))
      level_up_skill(skill_id)
      lose_jp(skill.required_upgrade_jp)
      true
    else
      false
    end
  end
end

#===============================================================================
# **
#-------------------------------------------------------------------------------
#
#===============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_level(skill_id)
    enemy.powered_skills[skill_id]
  end
end