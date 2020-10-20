require 'rm_vx_data'

#===============================================================================
# ** Impostazioni
#-------------------------------------------------------------------------------
# definire qui cosa avranno di particolare i vari livelli delle abilità
#===============================================================================
module Skill_PUP_Settings
  # gli attributi dell'abilità che verranno confrontati
  PAIRING_PARAMS = [:base_damage, :spi_f, :atk_f, :def_f, :agi_f, :plus_state_set,
                    :minut_state_set, :damage, :mp_cost, :hp_cost, :anger_cost,
                    :element_set, :hit, :aggro_set, :grudge_set, :state_inf_dur,
                    :anger_rate, :tank_odd, :syn_bonus]

  # le varie abilità con i cambiamenti rispetto al livello base
  # ID_SKILL => [{liv2},{liv3}...]
  SKILL_LEVELS = {
      5 => [
          {:spi_f => 100}
      ]
  }

  REQ_VOCAB = 'Requisiti'



end

#===============================================================================
# ** RPG::Enemy
#-------------------------------------------------------------------------------
# Aggiunta delle informazioni delle skill potenziate
#===============================================================================
class RPG::Enemy
  attr_accessor :skill_levels
  # caricamento delle informazioni
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
  # @return [Integer]
  attr_accessor :skill_level
  # carica le informazioni sui potenziamenti
  def load_powerups
    return if @power_ups_loaded
    @power_ups_loaded = true
    @base_name = @name
    @power_ups = Skill_PUP_Settings::SKILL_LEVELS[self.id] || []
    @skill_level = 1
  end

  # livello massimo
  # @return [Integer]
  def max_level; power_ups.size + 1; end

  # restituisce i potenziamenti per ogni livello
  # @return [Array<Hash>]
  def power_ups; @power_ups; end

  # determina se è potenziata al massimo
  def level_maxed?; self.skill_level >= max_level; end

  # aumenta di livello
  def level_up
    return if level_maxed?
    apply_level_up(@skill_level + 1)
  end

  # livello richiesto per il prossimo potenziamento dell'abilità
  # @return [Integer]
  def required_upgrade_level
    return 1 if level_maxed?
    power_ups[@skill_level][:level_req] || 1
  end

  # PA richiesti per il potenziamento
  # @return [Integer]
  def required_upgrade_jp
    return 0 if level_maxed?
    power_ups[@skill_level][:jp_req] || 0
  end

  # determina se l'abilità richiede un oggetto per poter essere potenziata
  # ulteriormente
  # @return [true, false]
  def requires_item_for_upgrade?
    power_ups[@skill_level][:item_req] != nil
  end

  # oggetto richiesto per il potenziamento
  # @return [RPG::Item]
  def required_upgrade_item
    $data_items[power_ups[@skill_level][:item_req] || 0]
  end

  # cambia il livello della skill
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
    changes.each_pair(&method(:process_level_up_attr))
    true
  end

  # modifica i parametri della skill a seconda dell'attributo
  # @param [Symbol] param
  # @param [Object] value
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

  # carica gli attributi di base
  def load_base_attrs(param, value)
    begin
      eval(sprintf('@%s=%s'), param, value.inspect)
    rescue
      err_str = "Error setting skill %d, param %s to %s"
      puts_e(sprintf(err_str, @id, param, value.inspect))
    end
  end

  # ottiene l'abilità con un determinato livello
  # @param [Integer] level
  # @return [RPG::Skill]
  # noinspection RubyResolve
  def get_skill_for_level(level)
    new_skill = self.clone
    new_skill.plus_state_set = @plus_state_set.clone
    new_skill.apply_level_up(level)
    new_skill
  end

  # restituisce il costo speso per potenziare l'abilità ad
  # un determinato livello
  # @param [Integer] level
  # @return [Integer]
  def power_up_cost(level); power_ups[level - 1][:cost]; end

  # restituisce il costo per potenziare l'abilità al livello
  # successivo
  # @return [Integer]
  def next_level_cost
    power_up_cost(self.level)
  end

  # restituisce le differenze tra i livelli dell'abilità
  # @return [Array<Array>]
  def next_level_compare
    return [] if level_maxed?
    next_lev = get_skill_for_level(@skill_level + 1)
    differences = []
    Skill_PUP_Settings::PAIRING_PARAMS.each do |param|
      if self.send(param) == next_lev.send(param)
        differences.push([param, self.send(param), next_lev.send(param)])
      end
    end
    differences
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
    parse_powerup_data($data_skills)
    parse_powerup_data($data_enemies)
  end

  # carica il database per test
  def self.load_battle_test_database
    h87_spu_load_battle_test_database
    parse_powerup_data($data_skills)
    parse_powerup_data($data_enemies)
  end

  # Carica i dati degli oggetti
  #   collection: collezione di oggetti
  # @param [Array<#load_powerups>] collection
  def self.parse_powerup_data(collection)
    collection.each{|obj| next if obj.nil?; obj.load_powerups}
  end
end

#===============================================================================
# ** Game_Battler
#-------------------------------------------------------------------------------
# aggiunge supporto ai metodi di base per Game_Actor e Game_Enemy
#===============================================================================
class Game_Battler < Game_Unit
  alias all_normal_skills skills unless $@
  # alias del metodo skill per ottenere le abilità potenziate
  # @return [Array<RPG::Skill>]
  def skills
    all_skills = all_normal_skills
    all_skills.collect!{|sk|
      sk.get_skill_for_level(skill_level(sk.id) + 1) if skill_leveled?(sk.id)
    }
    all_skills
  end

  # ottiene il livello dell'abilità
  # @abstract viene implementato da Game_Actor e Game_Enemy
  def skill_level(skill_id)
    raise NotImplementedError
  end

  # determina se l'abilità è potenziata
  def skill_leveled?(skill_id); skill_level(skill_id) > 1; end

  # determina se l'abilità si può migliorare ulteriormente (da definire)
  def can_level_up_skill?(skill_id)
    false
  end
end

#===============================================================================
# ** Game_Actor
#-------------------------------------------------------------------------------
# aggiunta del supporto alle skill livellabili
#===============================================================================
class Game_Actor < Game_Battler
  # potenzia l'abilità di 1 livello
  # @param [Integer] skill_id
  def level_up_skill(skill_id)
    @skill_levels ||= {}
    if skill_leveled?(skill_id)
      @skill_levels[skill_id] += 1
    else
      @skill_levels[skill_id] = 1
    end
  end

  # restituisce il livello dell'abilità
  # @param [Integer] skill_id
  # @return [Integer]
  def skill_level(skill_id)
    @skill_levels ||= {}
    @skill_levels[skill_id] || 1
  end

  # determina se può far aumentare la skill di livello
  # @param [Integer] skill_id
  # @return [true, false]
  def can_level_up_skill?(skill_id)
    skill = $data_skills[skill_id].get_skill_for_level(skill_level(skill_id))
    return false if skill.level_maxed?
    return false if self.jp < skill.required_upgrade_jp
    return false if self.level < skill.required_upgrade_level
    return false if skill.requires_item_for_upgrade? and
        !$game_party.has_item?(skill.required_upgrade_item)
    true
  end

  # ottiene l'elenco delle abilità che possono essere avanzate di livello
  # @return [Array<RPG::Skill>]
  def levellable_skills; skills.select{|skill| !skill.level_maxed?}; end

  # prova a far salire di livello la skill. Se i requisiti non sono stati
  # soddisfatti, restituisce false.
  # @param [Integer] skill_id
  # @return [true, false]
  def try_level_skill(skill_id)
    if can_level_up_skill?(skill_id)
      skill = $data_skills[skill_id].get_skill_for_level(skill_level(skill_id))
      level_up_skill(skill_id)
      lose_jp(skill.required_upgrade_jp)
      if skill.requires_item_for_upgrade?
        $game_party.lose_item(skill.required_upgrade_item, 1)
      end
      true
    else
      false
    end
  end
end

#===============================================================================
# ** Game_Enemy
#===============================================================================
class Game_Enemy < Game_Battler
  # restituisce il livello dell'abilità
  # @param [Integer] skill_id
  # @return [Integer]
  def skill_level(skill_id)
    enemy.powered_skills[skill_id] || 1
  end
end

#===============================================================================
# ** Window_SkillCompare
#-------------------------------------------------------------------------------
# finestra di confronto abilità
#===============================================================================
class Window_SkillCompare < Window_Base
  # @return [RPG::Skill] abilità attuale
  attr_reader :actual_skill

  def initialize(x, y, width, height)
    super
    @actual_skill = nil
  end

  def refresh
    contents.clear
    return if @skill.nil?
    return if @skill.level_maxed?
    draw_compairing_properties
  end

  def draw_next_skill_name
    draw_bg_srect(0, 0)
    draw_item_name(skill, 0, 0)
  end

  # assegna una nuova abilità
  # @param [RPG::Skill] new_skill
  def skill=(new_skill)
    return if same_skill_and_level? @actual_skill, new_skill
    @actual_skill = new_skill
    refresh
  end

  # determina se le abilità sono uguali
  # @param [RPG::Skill] old_skill
  # @param [RPG::Skill] new_skill
  # @return [true, false]
  def same_skill_and_level?(old_skill, new_skill)
    return true if new_skill.nil? and old_skill.nil?
    return false if new_skill.nil? ^ old_skill.nil?
    old_skill.id == new_skill.id and new_skill.skill_level == old_skill.skill_level
  end

  # l'abilità attuale
  # @return [RPG::Skill]
  def skill; @actual_skill; end

  # mostra le differenze tra la skiil attuale e quella al livello
  # successivo
  def draw_compairing_properties
    @y_count = 0
    differences = skill.next_level_compare
    differences.each(&method(:draw_difference))
  end

  # disegna le differenze
  # @param [Symbol] diff
  def draw_difference(diff)
    param = diff[0]
    prev_p = diff[1]
    next_p = diff[2]
    change_color system_color
    if param == :base_damage and skill.base_damage < 0
      title = Vocab::skill_param_vocab(:heal)
    else
      title = Vocab::skill_param_vocab(param)
    end
    draw_text(0, @y_count, contents_width, line_height, title)
    @y_count += line_height
    if prev_p.is_a?(Array)
      draw_difference_as_icons prev_p, next_p
    else
      draw_difference_as_numbers param, prev_p, next_p
    end
  end

  # mostra la differenza del parametro come numeri
  # @param [Symbol] param
  # @param [Integer] prev_p
  # @param [Integer] next_p
  def draw_difference_as_numbers(param, prev_p, next_p)
    change_color normal_color
    draw_text(0, @y_count, contents_width, line_height, prev_p)
    draw_text(0, y, contents_width, line_height, '➡', 1)
    change_color better_param_color param, prev_p, next_p
    draw_text(0, @y_count, contents_width, line_height, next_p, 2)
    @y_count += line_height
  end

  # mostra la differenza del parametro tra icone di stati
  # @param [Array<Integer>] prev_p
  # @param [Array<Integer>] next_p
  def draw_difference_as_icons(prev_p, next_p)
    width = (contents_width - 24) / 2
    y1 = draw_state_icons(prev_p, 0, @y_count, width)
    y2 = draw_state_icons(next_p, width, @y_count, width)
    @y_count += [y1, y2].max
  end

  # @param [Array<Integer>] states
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_state_icons(states, x, y, width)
    cols = width / 24
    icon_ids = states.map{|state| $data_states[state].icon_index}
    rows = (icon_ids.size / cols) + 1
    icon_ids.each_with_index { |icon, index|
      draw_icon(icon, x + ((index % cols) * 24), y + index / cols)
    }
    @y_count += rows * 24
  end

  # definisce il parametro migliore tra i due
  # @param [Symbol] param
  # @param [Integer] prev_p
  # @param [Integer] next_p
  # @return [Integer]
  def better_param(param, prev_p, next_p)
    case param
    when :base_damage
      prev_p < 0 ? [prev_p, next_p].min : [prev_p, next_p].max
    when :mp_cost, :hp_cost, :anger_cost
      [prev_p, next_p].min
    else
      [prev_p, next_p].max
    end
  end

  # definisce il colore da mostrare al parametro successivo
  # @param [Symbol] param
  # @param [Integer] prev_p
  # @param [Integer] next_p
  # @return [Color]
  def better_param_color(param, prev_p, next_p)
    next_p == better_param(param, prev_p, next_p) ? power_up_color : power_down_color
  end

end

class Window_UpgradeReq < Window_Base
  def initialize(x, y, width, height = fitting_height(4))
    super
    @skill = nil
    @actor = nil
  end

  # @param [Game_Actor] new_actor
  def set_actor(new_actor)
    return if @actor == new_actor
    @actor = new_actor
    refresh
  end

  # @return [Game_Actor]
  def actor
    @actor
  end

  # @return [RPG::Skill]
  def skill
    @skill
  end

  def set_skill(new_skill)
    return if @skill == new_skill
    @skill = new_skill
    refresh
  end

  def refresh
    contents.clear
    draw_bg_srect(0 ,0)
    change_color crisis_color
    draw_text(0, 0, contents_width, line_height, Skill_PUP_Settings::REQ_VOCAB)
    return if skill.nil?
    @line = 1
    draw_required_jp
    draw_required_level
    draw_required_item
  end

  def draw_required_jp
    return if skill.required_upgrade_jp == 0
    change_color system_color, enough_jp?
    draw_text(0, @line * line_height, contents_width, line_height, Vocab.jp)
    change_color normal_color, enough_jp?
    draw_text(0, @line * line_height, contents_width, line_height, skill.required_upgrade_jp, 2)
    @line += 1
  end

  def draw_required_level
    return if skill.required_upgrade_level == 0
    change_color system_color, enough_level?
    draw_text(0, @line * line_height, contents_width, line_height, Vocab.level)
    change_color normal_color, enough_level?
    draw_text(0, @line * line_height, contents_width, line_height, skill.required_upgrade_level, 2)
    @line += 1
  end

  def draw_required_item
    return unless skill.requires_item_for_upgrade?
    draw_item_name($data_items[skill.required_upgrade_item], 0, @line * line_height, enough_item?)
    @line += 1
  end

  def enough_jp?
    actor.jp >= skill.required_upgrade_jp
  end

  def enough_level?
    actor.level >= skill.required_upgrade_level
  end

  def enough_item?
    return true unless skill.requires_item_for_upgrade?
    $game_party.has_item?(skill.required_upgrade_item)
  end
end