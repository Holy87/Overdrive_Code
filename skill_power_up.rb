require 'rm_vx_data'


module Skill_PUP_Settings

  SKILL_LEVELS = {
      5 => [
          {:spi_f => 100}
      ]
  }

end


class RPG::Skill < UsableItem
  attr_accessor :skill_level
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def load_powerups
    return if @power_ups_loaded
    @power_ups_loaded = true
    @base_name = @name
    @power_ups = Skill_PUP_Settings::SKILL_LEVELS[self.id] || []
    @skill_level = 1
  end
  #--------------------------------------------------------------------------
  # *
  # @return [Integer]
  #--------------------------------------------------------------------------
  def max_level; power_ups.size + 1; end
  #--------------------------------------------------------------------------
  # *
  # @return [Array<Hash>]
  #--------------------------------------------------------------------------
  def power_ups; @power_ups; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def level_maxed?; self.skill_level >= max_level; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def level_up
    return if level_maxed?
    apply_level_up(@skill_level + 1)
  end

  def required_upgrade_level
    return 1 if level_maxed?
    power_ups[@skill_level][:level_req] || 1
  end

  def required_upgrade_jp
    return 0 if level_maxed?
    power_ups[@skill_level][:jp_req] || 0
  end
  #--------------------------------------------------------------------------
  # *
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
  # *
  # @param [Symbol] param
  # @param [Object] value
  #--------------------------------------------------------------------------
  def process_level_up_attr(param, value)
    case param
    when :spi_f;      @spi_f = value
    when :atk_f;      @atk_f = value
    when :agi_f;      @agi_f = value
    when :def_f;      @def_f = value
    when :damage;     @base_damage = value
    when :states;     @plus_state_set = value
    when :animation;  @animation_id = value
    when :mp_cost;    @mp_cost = value
    when :hp_cost;    @hp_cost = value
    when :an_cost;    @anger_cost = value
    when :hit;        @hit = value
    when :aggro;      @aggro_set = value
    when :grudge;     @grudge_set = value
    when :state_dur;  @state_inf_dur = value
    when :anger;      @anger_rate = value
    when :tk_odd;     @tank_odd = value
    when :syn_bonus; @syn_bonus = value
    else; load_extra_attrs(param, value)
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def load_extra_attrs(param, value)
    # code here
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
end

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
    @skill_levels ||= {}
    @skill_levels[skill_id] || 1
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_leveled?(skill_id); skill_level(skill_id) != nil; end
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
  def levellable_skills; skills.select{|skill| !skill.level_maxed?}; end
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
end