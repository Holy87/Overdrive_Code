module LevelManager
  # @param [Fixnum] skill_id
  # @return [Array<Skill_PowerUp>]
  def self.skill_levels_for(skill_id)
    @skill_levels ||= {}
    @skill_levels[skill_id] = load_skill_levels(skill_id) if @skill_levels[skill_id].nil?
    @skill_levels[skill_id]
  end

  # @param [Fixnum] state_id
  # @return [Array<Skill_PowerUp>]
  def self.state_levels_for(state_id)
    @state_levels ||= {}
    @state_levels[state_id] = load_state_levels(state_id) if @state_levels[state_id].nil?
    @state_levels[state_id]
  end

  # @param [Fixnum] skill_id
  # @return [Array<Skill_PowerUp>]
  def self.load_skill_levels(skill_id)
    return [] if SkillSettings::SKILL_LEVELS[skill_id].nil?
    levels = []
    SkillSettings::SKILL_LEVELS[skill_id].each_with_index do |lv, i|
      levels.push(Skill_PowerUp.new(lv, i, skill_id))
    end
    levels
  end

  # @param [Fixnum] state_id
  # @return [Array<Skill_PowerUp>]
  def self.load_state_levels(state_id)
    return [] if SkillSettings::STATE_LEVELS[state_id].nil?
    levels = []
    SkillSettings::STATE_LEVELS[state_id].each_with_index do |lv, i|
      levels.push(Skill_PowerUp.new(lv, i, state_id))
    end
    levels
  end
end

#noinspection ALL
module Learnable
  attr_reader :ap_cost
  # lista delle abilità necessarie per apprenderla
  # @return [Array<Float>]
  attr_reader :required_skills
  # lista delle passive necessarie per apprenderla
  # @return [Array<Float>]
  attr_reader :required_passives
  attr_reader :required_level
  attr_reader :required_item_id
  attr_reader :required_learn_switch_id

  def load_learnable_params
    return if @learnable_loaded
    @learnable_loaded = true
    @ap_cost = SkillSettings::DEFAULT_AP_COST
    @required_skills = []
    @required_passives = []
    @required_level = 1
    @required_learn_item_id = 0
    @required_learn_switch_id = 0
    self.note.split(/[\r\n]+/).each do |row|
      case row
      when SkillSettings::AP_COST
        @ap_cost = $1.to_i
      when SkillSettings::SKILL_REQ
        case $1
        when 'skill'
          @required_skills.push($2.to_f)
        when 'passive'
          @required_passives.push($2.to_f)
        when 'item'
          @required_learn_item_id = $2.to_i
        when 'level'
          @required_level = $2.to_i
        when 'switch'
          @required_learn_switch_id = $2.to_i
        end
      when SkillSettings::SKILLS_REQ
        case $1
        when 'skills'
          @required_skills += $2.split(',').map { |id| id.to_i }
        when 'passives'
          @required_passives += $2.split(',').map { |id| id.to_i }
        end
      end
    end
  end

  # restituisce l'oggetto richiesto per imparare l'abilità
  # @return [RPG::Item]
  def required_learn_item
    $data_items[@required_learn_item_id]
  end

  # determina se l'abilità può essere mostrata al giocatore
  def can_show?
    (required_learn_item.nil? or $game_party.has_item?(required_learn_item)) and
      (@required_learn_switch_id == 0 or $game_switches[@required_learn_switch_id])
  end

  # @param [TrueClass, FalseClass] other_item
  def equal?(other_item)
    return false if self.class != other_item.class
    self.id == other_item.id
  end
end

module Levellable
  attr_reader :level

  def parse_powerup_data
    return if @powerup_data_parsed
    @powerup_data_parsed = true
    @level = 1
    @showed_level = 1
  end

  def name
    @showed_level > 1 ? sprintf('%s %s%d', @name, Vocab.level_a, @showed_level) : @name
  end

  def real_name
    @name
  end

  # @return [Float]
  def id
    __id
  end

  # @return [Integer]
  def real_id
    @id
  end

  # @return [Float]
  def __id
    generated_id self.level
  end

  # @param [Integer] level
  # @return [Float]
  def generated_id(level)
    return @id if level == 1
    sprintf("%d.%02d", self.real_id, level).to_f
  end

  # Restituisce il potenziamento del prossimo livello
  # @return [Array<Skill_PowerUp>]
  def power_ups
    fail NotImplementedError
  end

  # livello massimo
  # @return [Integer]
  def max_level
    power_ups.size + 1
  end

  def level=(value)
    return if level >= value
    value = [[value, max_level].min, 1].max - 1
    value.times { apply_level_up }
  end

  # @return [Levelable]
  def next_level_skill
    #noinspection RubyResolve
    new_skill = Marshal.load(Marshal.dump(self))
    new_skill.apply_level_up
    new_skill
  end

  # livello richiesto per il prossimo potenziamento dell'abilità
  # @return [Integer]
  def required_upgrade_level
    return 1 if max_level_reached?
    next_level.required_level
  end

  # PA richiesti per il potenziamento
  # @return [Integer]
  def required_upgrade_ap
    return 0 if max_level_reached?
    next_level.required_ap
  end

  # determina se l'abilità richiede un oggetto per poter essere potenziata
  # ulteriormente
  # @return [true, false]
  def requires_item_for_upgrade?
    next_level.requires_item?
  end

  def requires_skill_for_upgrade?
    next_level.requires_skill?
  end

  def requires_passive_for_upgrade?
    next_level.requires_passive?
  end

  # oggetto richiesto per il potenziamento
  # @return [RPG::Item]
  def required_upgrade_item
    next_level.required_item
  end

  # @return [RPG::Skill]
  def required_upgrade_skill
    next_level.required_skill
  end

  # @return [RPG::State]
  def required_upgrade_passive
    next_level.required_passive
  end

  # restituisce i parametri del prossimo livello
  # @return [Skill_PowerUp]
  def next_level
    power_ups[level]
  end

  # determina se è potenziata al massimo
  def max_level_reached?
    level >= max_level
  end

  def base_level?
    level == 1
  end

  def powered_up?
    level > 1
  end

  # determina se il prossimo livello è un'evoluzione, ossia cambia nome
  def next_level_evolution?
    next_level.param_modificators[:name] != nil
  end

  # cambia il livello della skill
  def apply_level_up
    changes = next_level
    if changes.nil?
      puts "[ERROR] Powering up #{@name} at lvl #{@level+1} not found"
      return false
    end
    @level +=1
    if changes.param_modificators[:name] != nil
      @showed_level = 1
    else
      @showed_level += 1
    end
    changes.param_modificators.each_pair(&method(:process_level_up_attr))
    true
  end

  private

  # modifica i parametri della skill a seconda dell'attributo
  # @param [Symbol] param
  # @param [Object] value
  def process_level_up_attr(param, value)
    load_base_attrs(param, value)
  end

  # carica gli attributi di base
  def load_base_attrs(param, value)
    begin
      var_name = sprintf('@%s', param).to_sym
      self.instance_variable_set(var_name, value)
      #eval(sprintf('@%s=%s', param, value.inspect))
    rescue => error
      err_str = "Error setting skill %d, param %s to %s"
      Logger.error(sprintf(err_str, @id, param, value.inspect))
      Logger.error(error.class, ' ', error.message)
    end
  end
end

class Skill_PowerUp
  attr_reader :skill_id
  attr_reader :level
  attr_reader :param_modificators
  attr_reader :required_ap
  attr_reader :required_level
  attr_reader :required_classes
  attr_reader :required_skill
  attr_reader :required_passive

  def initialize(level_data, level, skill_id)
    @param_modificators = level_data[:params] || []
    @level = level
    @skill_id = skill_id
    @required_ap = level_data[:required_ap] || level_data[:ap] || 0
    @required_level = level_data[:required_level] || level_data[:level] || 1
    @required_item = level_data[:item_id] || level_data[:item]
    @required_classes = level_data[:classes] || []
    @required_skill = level_data[:required_skill]
    @required_passive = level_data[:required_passive]
  end

  # determina se la classe è adatta
  def actor_class_ok?(class_id)
    @required_classes.empty? or @required_classes.include?(class_id)
  end

  def requires_item?
    @required_item != nil
  end

  # @return [RPG::Item]
  def required_item
    $data_items[@required_item]
  end

  def requires_skill?
    @required_skill != nil
  end

  # @return [RPG::Skill]
  def required_skill
    $data_skills[@required_skill]
  end

  def requires_passive?
    @required_passive != nil
  end

  # @return [RPG::State]
  def required_passive
    $data_states[@required_passive]
  end
end

class RPG_Skills < Array
  # @return [RPG::Skill]
  def [](*args)
    return super(*args) unless args[0].is_a?(Float)
    return super(*args) if args.size > 1
    skill_from_id(args[0])
  end

  # @return [RPG::Skill]
  # @param [Float] id
  def skill_from_id(id)
    real_id = id.to_s.split(".")[0].to_i
    level = id.to_s.split(".")[1].to_i
    at_level(real_id, level)
  end

  # @return [RPG::Skill]
  # @param [Integer] skill_id
  # @param [Integer] level
  def at_level(skill_id, level)
    #noinspection RubyResolve
    skill = Marshal.load(Marshal.dump(self[skill_id]))
    skill.level = level
    skill
  end
end

class RPG_States < Array
  # @return [RPG::State]
  def [](*args)
    return super(*args) unless args[0].is_a?(Float)
    return super(*args) if args.size > 1
    state_from_id(args[0])
  end

  # @return [RPG::State]
  # @param [Float] id
  def state_from_id(id)
    real_id = id.to_s.split(".")[0].to_i
    level = id.to_s.split(".")[1].to_i
    at_level(real_id, level)
  end

  # @return [RPG::State]
  # @param [Integer] state_id
  # @param [Integer] level
  def at_level(state_id, level)
    #noinspection RubyResolve
    state = Marshal.load(Marshal.dump(self[state_id]))
    state.level = level
    state
  end
end