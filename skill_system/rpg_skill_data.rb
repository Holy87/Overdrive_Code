class RPG::UsableItem
  # restituisce l'animazione personalizzata dell'abilitò
  # @return [RPG::Animation, nil]
  def animation
    return nil if self.animation_id == 0
    $data_animations[self.animation_id]
  end

  # restituisce il primo SE dell'animazione dell'abilitò
  # @return [RPG::SE, nil]
  def fx_se
    return nil if self.animation_id == 0
    timing = animation.timings.select { |timing| timing.se != nil}.first
    return nil if timing.nil?
    timing.se
  end

end

#===============================================================================
# ** RPG::Skill
#-------------------------------------------------------------------------------
# Aggiunta di tutti i metodi per potenziare le skill
#===============================================================================
#noinspection RubyResolve
class RPG::Skill < RPG::UsableItem
  include Levellable
  include Learnable

  # restitusice l'abilità potenziata del prossimo livello
  # @return [RPG::Skill]
  def upgraded
    $data_skills[generated_id(self.level + 1)]
  end

  # @return [Array<Skill_PowerUp>]
  def power_ups

    LevelManager.skill_levels_for(@id)
  end

  def overview
    [@icon_index, name]
  end

  # l'aggro totale della skill (per dettagli)
  def total_aggro
    @grudge_set + @aggro_set
  end

  # la durata totale dello status che viene inflitto dalla skill
  def state_duration
    return 0 if @plus_state_set.empty?
    state = $data_states[@plus_state_set.first]
    state.hold_turn + @state_inf_dur
  end

  # la probabilità di effetto dello status
  def state_probability
    return 0 if @plus_state_set.nil?
    state = $data_states[@plus_state_set.first]
    return 0 if state.nonresistance
    (StatusAffinitySettings.default_state_rank(state.id) * (self.state_inf_per + 1.0)).to_i
  end

  # restituisce il costo totale per imparare l'abilità e portarla al massimo
  def total_ap_cost
    return @ap_cost if power_ups.empty?
    @ap_cost + power_ups.inject(0) { |sum, pup| sum + pup.required_ap }
  end

  # @param [RPG::Skill] other_skill
  def compare_attributes(other_skill)
    (H87Item::Settings::USABLE_DETAILS + H87Item::Settings::SKILL_DETAILS).map do |attribute|
      if self.has?(attribute) == false and other_skill.has?(attribute) == false
        attribute
      elsif self.send(attribute) == other_skill.send(attribute)
        attribute
      else
        nil
      end
    end
  end

  private

  # modifica i parametri della skill a seconda dell'attributo
  # @param [Symbol] param
  # @param [Object] value
  def process_level_up_attr(param, value)
    case param
    when :mp
      @mp_cost = value
    when :hp
      @hp_cost = value
    when :damage
      @base_damage = value
    when :states
      @plus_state_set = value
    when :min_states
      @minus_state_set = value
    when :state
      @plus_state_set = [value]
    when :animation
      @animation_id = value
    when :icon
      @icon_index = value
    when :aggro
      @aggro_set = value
    when :grudge
      @grudge_set = value
    when :state_dur
      @state_inf_dur = value
    when :anger
      @anger_rate = value
    when :tk_odd
      @tank_odd = value
      # per tankentai
    when :charge
      @charge_values[1] = value
    when :recharge
      @recharge_value = value
    when :action
      @action_key = value
    when :assimilate
      @assimilate_data[:max] = value
    when :target
      @scope = [nil, :single, :multi, :double, :random,
                :two_random, :three_random, :ally, :allies,
                :dead, :deads, :self].index(value)

    else
      if H87AttrSettings::FORMULA_CALC_PARAMS.include?(param)
        set_battle_param(param, value)
      else
        load_base_attrs(param, value)
      end
    end
  end
end

class RPG::State
  include Levellable
  include Learnable

  def name
    @showed_level > 1 ? sprintf('%s %s%d', @name, Vocab.level_a, @showed_level) : @name
  end

  # @return [Float]
  def id
    __id
  end

  # restitusice l'abilità potenziata del prossimo livello
  # @return [RPG::State]
  def upgraded
    $data_states[generated_id(self.level + 1)]
  end

  # @return [Array<Skill_PowerUp>]
  def power_ups
    LevelManager.state_levels_for(@id)
  end

  # restituisce il costo totale per imparare l'abilità e portarla al massimo
  def total_ap_cost
    return @ap_cost if power_ups.empty?
    @ap_cost + power_ups.inject(0) { |sum, pup| sum + pup.required_ap }
  end

  def passive?
    @ap_cost > 0
  end

  private

  # modifica i parametri della skill a seconda dell'attributo
  # @param [Symbol] param
  # @param [Object] value
  def process_level_up_attr(param, value)
    case param
    when :mhp
      return process_level_up_attr(:maxhp, value)
    when :mmp
      return process_level_up_attr(:maxmp, value)
    when :maxhp, :maxmp, :atk, :def, :spi, :agi
      @stat_per[param] = value
    when /def_ele_(\d+)/
      @element_rate_set[$1.to_i] = value
    when /def_sta_(\d+)/
      @state_rate_set[$1.to_i] = value
    when /atk_ele_(\d+)/
      @element_amplify[$1.to_i] = value
    when :icon
      @icon_index = value
    else
      load_base_attrs(param, value)
    end
  end
end

#===============================================================================
# ** RPG_Item
#===============================================================================
class RPG::Item
  
  # inizializza e restituisce le abilità che verranno sbloccate
  # possedendo questo oggetto
  # @return [Array<Integer>]
  def book_for_skills
    return @book_skills if @book_skills
    #TODO: aggiungere il resto
  end
end

#===============================================================================
# ** RPG_Enemy
#===============================================================================
class RPG::Enemy
  # carica i livelli di abilità e gli AP
  def check_skill_and_levels
    return if @skill_levels_checked
    @skill_levels_checked = true
    @ap = 0
    self.note.split(/[\r\n]+/).each do |row|
      case row
      when SkillSettings::ENEMY_SKILL_LEVEL
        apply_level_skill($1.to_i, $3.to_i)
      when SkillSettings::AP_ENEMY
        @ap = $1.to_i
      end
    end
  end

  # gli AP guadagnati uccidendo il nemico
  def ap
    @ap
  end

  # imposta il livello di una sua abilità.
  # Non fa nulla se la skill non è presente nelle sue abilità.
  def apply_level_skill(skill_id, level)
    action_skill = self.actions.select { |action| action.skill? && action.skill_id == skill_id }.first
    if action_skill.nil?
      Logger.error("Enemy #{@name} does not have skill #{skill_id}")
    else
      action_skill.skill_id = sprintf("%d.%02d", skill_id, level)
    end
  end
end

class RPG::Class
  # @return [Array<Integer>]
  attr_accessor :learnable_skills
  # @return [Array<Integer>]
  attr_accessor :learnable_passives

  def load_learnable_skills
    return if @learnable_loaded
    @learnable_loaded = true
    @learnable_skills = process_ranges_to_array(learnable_skills_range)
    @learnable_passives = process_ranges_to_array(learnable_passives_range)
  end

  private

  def learnable_skills_range
    class_skills = SkillSettings::CLASS_SKILLS[self.id] || []
    common_skills = SkillSettings::CLASS_SKILLS[0]
    class_skills | common_skills
  end

  def learnable_passives_range
    class_passives = SkillSettings::CLASS_PASSIVES[self.id] || []
    common_passives = SkillSettings::CLASS_PASSIVES[0]
    class_passives | common_passives
  end

  # @param [Array<Integer, Range>] source
  # @return [Array<Fixnum>]
  def process_ranges_to_array(source)
    ary = []
    source.each do |comp|
      if comp.is_a?(Range)
        ary = ary | comp.to_a
      else
        ary.push(comp)
      end
    end
    ary
  end
end