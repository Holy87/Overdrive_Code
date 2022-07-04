class Game_Troop < Game_Unit
  # restituisce il numero totale di punti abilità guadagnati
  # dai nemici morti
  def ap_total
    dead_members.compact.inject(0){|sum, enemy|sum + enemy.ap}
  end

  # distribuisce gli AP totali per gli eroi del party
  def distribute_ap
    ap = ap_total
    $game_party.members.each{|member|member.earn_ap(ap)}
  end
end

#===============================================================================
# ** Game_Battler
#-------------------------------------------------------------------------------
# aggiunge supporto ai metodi di base per Game_Actor e Game_Enemy
#===============================================================================
class Game_Battler
  alias :make_item_damage_value :make_obj_damage_value unless $@
  alias :lvl1_state? :state? unless $@

  # restituisce la skill e suoi potenziamenti da ID
  # @param [Fixnum, Float] skill_id
  # @return [RPG::Skill, nil]
  def skill(skill_id)
    skills.select { |skill| skill.real_id == skill_id.to_i}.first
  end

  # restituisce il livello dell'abilità. Se il personaggio non ha appreso
  # l'abilità restituisce -1
  # @param [Integer] skill_id
  # @return [Integer]
  def skill_level(skill_id)
    return -1 if skill(skill_id).nil?
    skill(skill_id).level
  end

  # determina se l'abilità è potenziata
  def skill_leveled?(skill_id)
    skill_level(skill_id) > 1
  end

  # determina se l'abilità si può migliorare ulteriormente (da definire)
  def can_level_up_skill?(skill)
    false
  end

  def state?(state_id)
    return false if state_id.nil?
    lvl1_state?(state_id.to_i)
  end
end

class Game_Actor < Game_Battler
  alias :forget_lvl1_skill :forget_skill unless $@
  alias :normal_states :states unless $@

  # @return [Array<RPG::Skill>]
  def learnable_skills
    self.class.learnable_skills.
      map { |skill_id| $data_skills[skill_id] }.
      compact.
      select { |skill| !skill_learn?(skill) }.
      select { |skill| skill.can_show? }.
      select { |skill| !skill.name.empty? }
  end

  # @return [Array<RPG::State>]
  def learnable_passives
    self.class.learnable_passives.
      map { |state_id| $data_states[state_id] }.
      compact.
      select { |state| !passive_learn?(state) }.
      select { |state| state.can_show? }.
      select { |state| !state.name.empty? }
  end

  # apprende un'abilità
  # @param [RPG::Skill, RPG::State] item
  def learn(item)
    return learn_skill(item.id) if item.is_a?(RPG::Skill)
    return learn_passive(item.id) if item.is_a?(RPG::State)
    false
  end

  # apprende un'abilità. Sovrascrive i metodi precedenti.
  # @param [Integer, Float] skill_id
  def learn_skill(skill_id)
    return if skill_learn? $data_skills[skill_id]
    @skills.push(skill_id)
    @skills.sort! unless custom_skill_sort?
  end

  # determina se una skill o passiva è appresa
  # @param [RPG::Skill, RPG::State, nil] item
  def learn?(item)
    return false if item.nil?
    return skill_learn?(item) if item.is_a?(RPG::Skill)
    return passive_learn?(item) if item.is_a?(RPG::State)
    false
  end

  # determina se l'abilità (di un qualsiasia livello) è appresa
  # @param [RPG::Skill] skill
  def skill_learn?(skill)
    return false if skill.nil?
    @skills.select { |id| id.to_i == skill.id.to_i }.any?
  end

  # @param [Learnable] learnable
  def can_learn?(learnable)
    return false if ap < learnable.ap_cost
    return false if self.level < learnable.required_level
    learnable.required_skills.each { |skill_id| return false unless (skill_learn?(skill_id) and skill_level(skill_id) >= $data_skills[skill_id].level)  }
    learnable.required_passives.each { |passive_id| return false unless passive_learn?($data_states[passive_id]) }
    return false unless learnable.can_show?
    true
  end

  # riordina le abilità e rimuove le personalizzazioni
  def sort_skills
    @skills.sort!
    @custom_skill_sort = false
  end

  # @param [RPG::Skill, nil] skill1
  # @param [RPG::Skill, nil] skill2
  def swap_skills(skill1, skill2)
    return if skill1 == skill2
    index1 = @skills.index(skill1.id)
    index2 = @skills.index(skill2.id)
    @skills[index1], @skills[index2] = @skills[index2], @skills[index1]
    @custom_skill_sort = true
  end

  # potenzia l'abilità di 1 livello
  # @param [RPG::Skill] skill
  def level_up_skill(skill)
    return false unless skill_learn?(skill)
    index = @skills.index(skill.id)
    @skills[index] = skill.id + (skill.level == 1 ? 0.02 : 0.01)
  end

  # potenzia l'abilità di 1 livello
  # @param [RPG::State] passive
  def level_up_passive(passive)
    return false unless passive_learn?(passive)
    index = @learned_passives.index(passive.id)
    @learned_passives[index] = passive.id + (passive.level == 1 ? 0.02 : 0.01)
  end

  # dimentica una abilità
  # @param [Integer, Float] skill_id
  def forget_skill(skill_id)
    forget_lvl1_skill(skill_id)
    @skills.delete_if { |learnt_skill_id| learnt_skill_id.to_i == skill_id.to_i }
  end

  # mostra solo le abilità imparate, non quelle ottenute da equip, stati ecc...
  # @return [Array<RPG::Skill>]
  def native_skills
    @skills.map { |skill_id| $data_skills[skill_id] }
  end

  # @param [Levellable] skill
  def skill_max_level_reached?(skill)
    return true if skill.nil?
    return true if skill.max_level_reached?
    return true if skill.is_a?(RPG::Skill) and !native_skill?(skill.id)
    return true if skill.is_a?(RPG::State) and !passive_learn?(skill)
    !skill.next_level.actor_class_ok?(@class_id)
  end

  # determina se può far aumentare la skill di livello
  # @param [RPG::Skill, RPG::State] skill
  # @return [true, false]
  def can_level_up_skill?(skill)
    return false if skill.nil?
    return false if skill_max_level_reached?(skill)
    return false if self.ap < skill.required_upgrade_ap
    return false if self.level < skill.required_upgrade_level
    return false if skill.requires_item_for_upgrade? and
      !$game_party.has_item?(skill.required_upgrade_item)
    return false if skill.requires_skill_for_upgrade? and
      self.skill_level(skill.required_upgrade_skill.id) < skill.required_upgrade_skill.level
    return false if skill.requires_passive_for_upgrade? and
      self.passive_level(skill.required_upgrade_passive.id) < skill.required_upgrade_passive.level
    true
  end

  # ottiene l'elenco delle abilità che possono essere avanzate di livello
  # @return [Array<RPG::Skill>]
  def levellable_skills
    native_skills.select { |skill| !skill.max_level_reached? };
  end

  # prova a far salire di livello la skill. Se i requisiti non sono stati
  # soddisfatti, restituisce false.
  # @param [RPG::Skill, RPG::State] skill
  # @return [true, false]
  def try_level_skill(skill)
    return false unless can_level_up_skill? skill
    level_up_skill(skill) if skill.is_a?(RPG::Skill)
    level_up_passive(skill) if skill.is_a?(RPG::State)
    lose_ap(skill.required_upgrade_ap)
    if skill.requires_item_for_upgrade?
      $game_party.lose_item(skill.required_upgrade_item, 1)
    end
    true
  end

  # determina se è una skill appresa
  def native_skill?(skill_id)
    native_skills.map { |skill| skill.real_id == skill_id.to_i }.any?
  end

  def ap
    @jp[self.class_id] ||= 0
  end

  def ap=(value)
    @jp ||= {self.class_id => 0}
    @jp[self.class_id] += value
  end

  def earn_ap(value = 0)
    @jp ||= {self.class_id => 0}
    @jp[self.class_id] += (value * ap_rate).to_i
  end

  def lose_ap(value)
    @jp ||= {self.class_id => 0}
    @jp[self.class_id] -= value
  end

  def custom_skill_sort?
    @custom_skill_sort ||= false
  end

  def ap_rate
    1 + features_sum(:ap_rate)
  end

  # @return [Array<RPG::State>]
  def all_passives
    @learned_passives ||= []
    @learned_passives.map { |state_id| $data_states[state_id] }
  end

  def passive(passive_id)
    passives.select { |passive| passive.real_id == passive_id.to_i }.first
  end

  # restituisce il livello dell'abilità passiva.
  # Se non è appresa restituisce -1
  # @param [Float,Integer] passive_id
  # @return [Fixnum]
  def passive_level(passive_id)
    _passive = passive(passive_id)
    return -1 if _passive.nil?
    _passive.level
  end

  # @return [Array<RPG::State>]
  def passives
    all_passives
  end

  # @return [Array<RPG::State>]
  def enabled_passives
    all_passives.select { |passive| passive_enabled?(passive) }
  end

  # @param [RPG::State] passive
  # @param [Boolean] enabled
  def set_passive_enabled(passive, enabled = true)
    return unless passive_learn?(passive)
    return if passive_enabled?(passive) == enabled
    if enabled
      @disabled_passives.delete(passive.real_id)
    else
      @disabled_passives.push(passive.real_id) if passive_enabled?(passive)
    end
  end

  def switch_passive_enabled(passive)
    set_passive_enabled(passive, !passive_enabled?(passive))
  end

  def learn_passive(passive_id)
    return if passive_learn?($data_states[passive_id])
    @learned_passives.push(passive_id)
    @learned_passives.sort!
  end

  def forget_passive(passive_id)
    @learned_passives ||= []
    @learned_passives.delete(passive_id)
  end

  # @param [RPG::State] state
  # @return [TrueClass, FalseClass]
  def passive_learn?(state)
    return false if state.nil?
    passives.map { |passive| passive.real_id }.include?(state.real_id)
  end

  # @param [RPG::State] state
  def passive_enabled?(state)
    @disabled_passives ||= []
    !@disabled_passives.select { |st_id| st_id.to_i == state.id.to_i }.any?
  end

  # restituisce tutti gli status applicati e le abilità passive
  # @return [Array<RPG::State>]
  def states
    normal_states | enabled_passives
  end

  # per compatibiltà
  alias :jp :ap
  alias :earn_jp :earn_ap
  alias :lose_jp :lose_ap
  alias :jp_rate :ap_rate

  # * contiene le skill nascoste
  def hidden_skills
    @hidden_skills ||= []
  end

  # * aggiunge una skill a quelle nascoste
  def add_hidden_skill(skill_id)
    hidden_skills.push(skill_id) unless skill_hidden? skill_id
  end

  # * rimuove una skill nascosta
  def remove_hidden_skill(skill_id)
    hidden_skills.delete(skill_id)
  end

  # * determina se la skill è nascosta
  def skill_hidden?(skill_id)
    hidden_skills.include?(skill_id)
  end
end

#===============================================================================
# ** DataManager
#===============================================================================
module DataManager
  class << self
    alias h87_spu_load_normal_database load_normal_database
    alias h87_spu_load_battle_test_database load_battle_test_database
  end

  # carica il database per giocare
  def self.load_normal_database
    h87_spu_load_normal_database
    load_levelup_data
  end

  # carica il database per test
  def self.load_battle_test_database
    h87_spu_load_battle_test_database
    load_levelup_data
  end

  def self.load_levelup_data
    parse_powerup_data($data_skills)
    parse_powerup_data($data_states)
    parse_learnable_data($data_skills)
    parse_learnable_data($data_states)
    $data_enemies.compact.each { |enemey| enemey.check_skill_and_levels }
    $data_classes.compact.each { |actor_class| actor_class.load_learnable_skills }
    # wrappo nelle classi così che mi restituiscano le skill potenziate
    $data_skills = RPG_Skills.new($data_skills)
    $data_states = RPG_States.new($data_states)
  end

  # Carica i dati degli oggetti
  #   collection: collezione di oggetti
  # @param [Array<Levellable>] collection
  def self.parse_powerup_data(collection)
    collection.compact.each { |obj| next if obj.nil?; obj.parse_powerup_data }
  end

  # @param [Array<Learnable>] collection
  def self.parse_learnable_data(collection)
    collection.compact.each { |obj| next if obj.nil?; obj.load_learnable_params }
  end
end

class Scene_Battle < Scene_Base
  alias :h87_skill_be :battle_end unless $@

  def battle_end(result)
    $game_troop.distribute_ap
    h87_skill_be(result)
  end
end