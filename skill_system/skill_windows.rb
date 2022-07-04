class Window_ActorSmallInfo < Window_ActorInfo

  def fitting_height(line_number)
    super(line_number - 1)
  end

  def draw_actor_basic_info(x, y)
    draw_actor_face(actor, x, y)
    x += 100
    draw_actor_name(actor, x, 0)
    draw_actor_level(actor, x, y + line_height)
    #draw_actor_class(actor, x, y + line_height)
    draw_actor_state(actor, x, y + line_height * 2)
  end

  # Disegna lo stato dell'eroe
  def draw_actor_status
    x = 104 + 120
    draw_actor_hp(actor, x, 0, contents_width - x)
    draw_actor_mp(actor, x, line_height, contents_width - x)
    draw_actor_ap(actor, x, line_height * 2, (contents_width - x) / 2)
    draw_actor_exp(actor, x + (contents_width - x) / 2, line_height * 2, contents_width - x / 2)
  end
end

class Window_Selectable < Window_Base
  alias :draw_item_name_classic :draw_item_name unless $@

  def draw_item_name(item, x, y, enabled = true, width = 172)
    draw_item_name_classic(item, x, y, enabled, width)
    if $TEST
      draw_text(x + ICON_WIDTH + text_width(item.name), y, width, line_height, sprintf('#%d', item.id))
    end
  end
end

# * Window_SkillCommand
# la finestra dei comandi della nuova schermata delle abilità.
class Window_SkillCommand < Window_Command

  # crea la finestra dei comandi
  def make_command_list
    add_command(Vocab::skills_command, :skills)
    add_command(Vocab::passives_command, :passives)
    add_command(Vocab::learn_command, :learn)
  end

  # Restituisce il comando evidenziato
  # @return [Symbol]
  def item
    @list[@index][:symbol];
  end

  def update_cursor
    super
    check_cursor_handler
  end
end

# Finestra che mostra lo status dell'eroe con le informazioni di base.
class Window_SkillStatus < Window_Base
  # noinspection RubyArgCount
  def initialize(x, y)
    super(x, y, window_width, fitting_height(4))
    @actor = nil
    refresh

  end

  # la larghezza della finestra
  # @return [Integer]
  def window_width
    344 + (padding * 2)
  end

  # imposta l'eroe e aggiorna la finestra
  # @param [Game_Actor] new_actor
  def actor=(new_actor)
    return if @actor == new_actor

    @actor = new_actor
    refresh
  end

  def refresh
    contents.clear
    return if @actor.nil?

    draw_actor_face(actor, 0, 0)
    draw_actor_simple_status(actor, 100, 0)
  end
end

class Window_Skill < Window_Selectable
  alias :h87_normal_init :initialize unless $@
  attr_accessor :sorting
  # @return [Window_ItemInfo]
  attr_accessor :info_window

  def initialize(x, y, width, height, actor)
    #h87_normal_init(x, y, width, height, actor)
    super(x, y, width, height)
    @sorting = false
    @sorting_index = -1
    @last_index = 0
    set_actor(actor)
    self.index = -1
    create_skill_commands
  end

  # @param [Fixnum] index
  # @return [RPG::Skill]
  def skill(index = @index)
    return nil if @data.nil?
    @data[index]
  end

  # @return [RPG::Skill]
  def item
    skill
  end

  def redraw_current_item
    make_item_list
    super
  end

  def set_actor(new_actor)
    @actor = new_actor
    @last_index = 0
    make_item_list
    create_contents
    self.oy = 0
    refresh
  end

  def activate
    super
    set_key_commands unless sorting?
    self.index = sorting? ? @sorting_index : @last_index
  end

  def deactivate
    @last_index = self.index if @index >= 0
    super
  end

  # disegna l'oggetto (skill)
  def draw_item(index)
    skill = self.skill(index)
    return if skill.nil?
    rect = item_rect_for_text(index)
    enabled = enable?(skill)
    draw_sorting_rect(rect) if sorting? && @sorting_index == index
    draw_item_name(skill, rect.x, rect.y, enabled)
    if skill.toggle_type? and actor.has_state?(skill.plus_state_set.first)
      draw_disable_text(rect, skill)
    else
      draw_skill_cost(rect, skill)
      draw_skill_delay(rect, skill)
    end
  end

  # @param [Rect] rect
  # @param [RPG::Skill] skill
  def draw_disable_text(rect, skill)
    enabled = (enable?(skill) and !sorting?)
    change_color crisis_color, enabled
    draw_text(rect, sprintf('(%s)', Vocab.disable), 2)
  end

  # @param [Rect] rect
  def draw_sorting_rect(rect)
    draw_bg_srect(rect.x - 1, rect.y, rect.width + 1, rect.height, sort_color)
  end

  # @param [Rect] rect
  # @param [RPG::Skill] skill
  def draw_skill_delay(rect, skill)
    x = rect.x + 24
    y = rect.y + rect.height - H87_Delay::BAR_HEIGHT
    length = rect.width / 2 - 24
    if skill.turn_delay > 0 and ($game_temp.in_battle or H87_Delay::TURN_SKILLS_VISIBLE_ON_MENU)
      draw_skill_turn_delay(x, y, length, skill)
    elsif skill.battle_delay > 0
      draw_skill_battle_delay(x, y, length, skill)
    elsif skill.step_delay > 0
      draw_skill_step_delay(x, y, length, skill)
    elsif skill.damage_delay > 0 and ($game_temp.in_battle or H87_Delay::TURN_SKILLS_VISIBLE_ON_MENU)
      draw_skill_damage_delay(x, y, length, skill)
    end
  end

  # restituisce l'abilità che dev'essere scambiata
  # @return [RPG::Skill, nil]
  def sorting_skill
    skill(@sorting_index)
  end

  # determina se l'abilità può essere utilizzata
  # @param [RPG::Skill] item
  def enable?(item)
    return false if item.nil?
    return actor.skill_learn?(item) if actor and sorting?
    actor != nil and actor.usable?(item)
  end

  # ottiene lo stato di attivazione della skill selezionata
  def current_item_enabled?
    enable?(@data[@index])
  end

  def set_sorting(sorting)
    return if @sorting == sorting
    @sorting = sorting
    refresh
    if sorting?
      @sorting_index = @index
      redraw_current_item
      set_sort_commands
    else
      @sorting_index = -1
      set_key_commands
    end
  end

  def trigger_sort_success
    make_item_list
    set_sorting false
  end

  # colore di sfondo dell'abilità selezionata da spostare
  # @return [Color]
  def sort_color
    text_color(SkillSettings::SORT_RECT_COLOR_ID).deopacize(64)
  end

  def create_skill_commands
    @skill_commands = []
    @skill_commands.push(Key_Command_Container.new([:C], Vocab.use_skill))
    @skill_commands.push(Key_Command_Container.new([SkillSettings::POWER_UP_KEY], Vocab.power_up_skill))
    @skill_commands.push(Key_Command_Container.new([SkillSettings::SORT_KEY], Vocab.sort_command))
  end

  def set_key_commands
    return if @key_window.nil?
    return unless active
    @key_window.columns = @skill_commands.size
    @skill_commands.each_with_index { |command, i| @key_window.set_command(i, command)  }
  end

  def set_sort_commands
    return if @key_window.nil?
    @key_window.columns = 2
    @key_window.set_command(0, Key_Command_Container.new([:C], Vocab.place_position))
    @key_window.set_command(1, Key_Command_Container.new([SkillSettings::SORT_ALL_KEY], Vocab.default_sort))
  end

  def actor=(new_actor)
    return if @actor == new_actor
    @actor = new_actor
    deep_refresh
  end

  # @return [Game_Actor]
  def actor
    if SceneManager.scene_is?(Scene_NewSkill)
      @actor
    elsif SceneManager.scene_is?(Scene_Battle) and SceneManager.scene.active_battler != nil
      SceneManager.scene.active_battler
    else
      @actor
    end
  end

  # @param [Window_KeyHelp] key_window
  def keys_window=(key_window)
    @key_window = key_window
    set_key_commands if active
  end

  def col_max
    1
  end

  def item_max
    @data ? @data.size : 0
  end

  def make_item_list
    return @data = [] if actor.nil?
    @data = actor.skills
  end

  def deep_refresh
    make_item_list
    create_contents
    refresh
  end

  def refresh
    return if @data.nil?
    super
  end

  def update_keys_window
    return if @key_window.nil?
    @key_window.change_enable(0, current_item_enabled?)
    unless sorting?
      @key_window.change_enable(1, skill && !actor.skill_max_level_reached?(skill))
      @key_window.change_enable(2, skill && actor.skill_learn?(skill))
    end
  end

  def update_info_window
    return if info_window.nil?
    @info_window.set_item(skill)
  end

  def update_help_window
    return unless @help_window
    @help_window.set_item(skill)
  end

  def update_help
    super
    update_help_window
    update_keys_window
    update_info_window
  end

  def sorting?
    @sorting
  end
end

class Window_PassiveList < Window_Selectable
  attr_accessor :info_window
  attr_accessor :keys_window

  def initialize(x, y, width, height)
    super
    deactivate
    @last_index = 0
  end

  # Imposta l'eroe della finestra
  # @param [Game_Actor] new_actor
  def set_actor(new_actor)
    return if @actor == new_actor
    @actor = new_actor
    @last_index = 0
    deep_refresh
    self.oy = 0
  end

  def redraw_current_item
    make_item_list
    super
  end

  def activate
    super
    set_keys
    self.index = @last_index
  end

  def deactivate
    @last_index = self.index if @index >= 0
    super
  end

  def set_keys
    return if @keys_window.nil?
    @keys_window.columns = 2
    @keys_window.set_command(0, Key_Command_Container.new(:C, Vocab::activate_skill))
    @keys_window.set_command(1, Key_Command_Container.new(SkillSettings::POWER_UP_KEY, Vocab::power_up_skill, item.nil? || !actor.skill_max_level_reached?(item)))
  end

  # Restituisce l'eroe
  # @return [Game_Actor]
  def actor
    @actor
  end

  def make_item_list
    @data = actor.all_passives
  end

  def item_max
    @data ? @data.size : 0
  end

  def deep_refresh
    make_item_list
    create_contents
    refresh
  end

  # @return [RPG::State] stato
  def item(index = @index)
    @data[index]
  end

  def draw_item(index)
    passive = item(index)
    return if passive.nil?
    rect = item_rect_for_text(index)
    enabled = actor.passive_enabled?(passive)
    draw_item_name(passive, rect.x, rect.y, enabled, rect.width)
    x = rect.width - ICON_WIDTH
    icon_index = enabled ? Icon.on_switch : Icon.off_switch
    draw_icon(icon_index, x, rect.y, enabled)
  end

  def update_info_window
    return if info_window.nil?
    @info_window.set_item(item)
  end

  def update_keys_window
    return if @keys_window.nil?
    @keys_window.change_enable(1, item.nil? || !actor.skill_max_level_reached?(item))
  end

  def update_help_window
    return unless @help_window
    @help_window.set_item(item)
  end

  def current_item_enabled?
    !actor.fix_equipment
  end

  def update_help
    super
    update_help_window
    update_keys_window
    update_info_window
  end
end

class Window_LearnList < Window_Selectable
  attr_accessor :info_window
  attr_accessor :keys_window

  def initialize(x, y, width, height)
    super
    deactivate
    @last_index = 0
  end

  # Imposta l'eroe della finestra
  # @param [Game_Actor] new_actor
  def set_actor(new_actor)
    return if @actor == new_actor
    @actor = new_actor
    @last_index = 0
    deep_refresh
    self.oy = 0
  end

  # Restituisce l'eroe
  # @return [Game_Actor]
  def actor
    @actor
  end

  def deep_refresh
    make_item_list
    create_contents
    refresh
  end

  def activate
    super
    @info_window.show_requirements = true if @info_window
    set_keys
    self.index = @last_index
  end

  def deactivate
    @last_index = self.index if @index >= 0
    @info_window.show_requirements = false if @info_window
    super
  end

  def set_keys
    return if @keys_window.nil?
    @keys_window.columns = 1
    @keys_window.set_command(0, Key_Command_Container.new(:C, Vocab::learn_skill))
  end

  def make_item_list
    return @data = [] if actor.nil?
    @data = actor.learnable_skills + actor.learnable_passives
  end

  def item_max
    @data ? @data.size : 0
  end

  # @return [RPG::State, RPG::Skill]
  def item(index = @index)
    @data[index]
  end

  def draw_item(index)
    skill = item(index)
    return if skill.nil?
    enabled = enable?(skill)
    rect = item_rect_for_text(index)
    change_color normal_color, enabled
    draw_item_name(skill, rect.x, rect.y, enabled, rect.width)
    if !actor.learn?(skill)
      draw_text(rect, sprintf('%d%s', skill.ap_cost, Vocab.ap), 2)
    else
      change_color(power_up_color, enabled)
      draw_text(rect, Vocab.learnt, 2)
    end
  end

  def enable?(skill)
    return false if skill.nil?
    !actor.learn?(skill) && (actor.can_learn?(skill) or Input.press?(:A) and $TEST)
  end

  def current_item_enabled?
    return false if @actor.nil?
    #noinspection RubyResolve
    enable?(@data[@index]) and !actor.fix_equipment
  end

  def update_info_window
    return if info_window.nil?
    @info_window.set_item(item)
  end

  def update_help_window
    return unless @help_window
    @help_window.set_item(item)
  end

  def update_help
    super
    update_help_window
    update_info_window
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
    return if skill.nil?
    return if actor.skill_max_level_reached?(skill)
    if skill.is_a?(RPG::Skill)
      draw_compairing_skill_properties
    else
      draw_compairing_passive_properties
    end
  end

  def draw_compairing_skill_properties
    draw_skill_overview
    draw_formula_differences
    draw_scope_change
    draw_new_states_add
    draw_new_states_removed
    draw_discrete_differences SkillSettings::SKILL_DIFFERENCES
    draw_cost_change
  end

  def draw_compairing_passive_properties
    draw_skill_overview
    draw_discrete_differences SkillSettings::PASSIVE_DIFFERENCES

  end

  def draw_next_skill_name
    draw_bg_srect(0, 0)
    draw_item_name(skill, 0, 0)
  end

  # assegna una nuova abilità
  # @param [RPG::Skill] new_skill
  def skill=(new_skill)
    return if same_skill_and_level? @actual_skill, new_skill
    return if actor.skill_max_level_reached?(skill)
    @actual_skill = new_skill
    @upgraded_skill = new_skill.upgraded
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
  def skill
    @actual_skill
  end

  # l'abilità del prossimo livello
  # @return [RPG::Skill]
  def upgraded_skill
    @upgraded_skill
  end

  # @param [Array<Symbol>] param_list
  def draw_discrete_differences(param_list)
    param_list.each do |param|
      value1 = skill.send(param)
      value2 = upgraded_skill.send(param)
      if value1 != value2
        draw_difference(param, value1, value2)
      end
    end
  end

  def draw_scope_change
    return if skill.scope == upgraded_skill.scope
    draw_difference(:scope, Vocab.scope(skill.scope), Vocab.scope(upgraded_skill.scope))
  end

  def draw_cost_change

  end

  # @param [Array<Integer>] states
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_state_icons(states, x, y, width)
    cols = width / 24
    icon_ids = states.map { |state| $data_states[state].icon_index }
    rows = (icon_ids.size / cols) + 1
    icon_ids.each_with_index { |icon, index|
      draw_icon(icon, x + ((index % cols) * 24), y + index / cols)
    }
    @y_count += rows * 24
  end

  def draw_new_states_add
    new_states = upgraded_skill.plus_state_set - skill.plus_state_set
    return if new_states.empty?
    new_states.each(state_id) do |state_id|
      state = $data_states[state_id]
      draw_new_addition(Vocab.causes + ' ', state.icon_index, state.name)
    end
  end

  def draw_new_states_removed
    new_states = upgraded_skill.minus_state_set - skill.minus_state_set
    return if new_states.empty?
    new_states.each(state_id) do |state_id|
      state = $data_states[state_id]
      draw_new_addition(Vocab.removes + ' ', state.icon_index, state.name)
    end
  end

  def draw_skill_overview
    draw_rich_differences('', [skill.icon_index, skill.name],
                    [upgraded_skill.icon_index, upgraded_skill.name])
  end

  def draw_formula_differences
    return if skill.base_damage == 0
    return if skill.printable_damage_formula == upgraded_skill.printable_damage_formula
    if skill.heal?
      text = skill.damage_to_mp ? Vocab.heal_mp_power : Vocab.heal_power
    else
      text = skill.damage_to_mp ? Vocab.damage_mp_power : Vocab.damage_power
    end
    draw_difference(:formula, skill.printable_damage_formula, upgraded_skill.printable_damage_formula, text)
  end

  # @param [Symbol] param
  # @param [Integer, String ] value
  # @param [Integer, String] next_value
  # @param [String] param_text
  def draw_difference(param, value, next_value, param_text = Vocab.param(param))
    change_color(system_color)
    draw_text(param_rect, param_text)
    change_color normal_color
    text = Vocab.formatted_param(param, value)
    draw_text(prev_rect, text)
    change_color next_param_color(param, value, next_value)
    text = Vocab.formatted_param(param, next_value)
    draw_text(next_rect, text)
    @line += 1
  end

  def draw_rich_differences(param_name, values1, values2)
    change_color(system_color)
    draw_text(param_rect, param_name)
    change_color normal_color
    values1 = [values1] unless values1.is_a?(Array)
    values2 = [values2] unless values2.is_a?(Array)
    draw_rich_rect(prev_rect, *values1)
    draw_rich_rect(next_rect, *values2)
  end

  # @param [Array<String, Array<Integer>, Integer>] args
  def draw_new_addition(*args)
    change_color crisis_color
    draw_rich_rect(next_rect, *args)
  end

  # @param [Rect] rect
  # @param [Array] args
  def draw_rich_rect(rect, *args)
    curs = 0
    args.each do |item|
      if item.is_a?(Array)
        item.each_with_index { |icon, i| draw_icon(icon, rect.x + curs + (i * ICON_WIDTH), rect.y ) }
        curs += ICON_WIDTH * item.size
      elsif item.is_a?(Integer)
        draw_icon(item, rect.x + curs, rect.y)
        curs += ICON_WIDTH
      else
        draw_text(rect.x + curs, rect.y, rect.width - curs, line_height, item)
        curs += text_width(item)
      end
    end
    draw_icon(Settings::NEW_ADVICE_ICON, rect.x + curs, rect.y)
    @line += 1
  end

  # @return [Rect]
  def prev_rect
    rect = line_rect(@line)
    rect.x = contents_width / 3
    rect.width = contents_width / 3
    rect
  end

  # @return [Rect]
  def next_rect
    rect = line_rect(@line)
    rect.x = contents_width * 2 / 3
    rect.width = contents_width / 3
    rect
  end

  # @return [Rect]
  def param_rect
    rect = line_rect(@line)
    rect.width = contents_width / 3
    rect
  end

  # restituisce il colore adatto per il secondo parametro
  # @param [Symbol] param
  # @param [Integer] value1
  # @param [Integer] value2
  # @return [Color]
  def next_param_color(param, value1, value2)
    if SkillSettings::GOOD_PARAMS.include?(param)
      value2 > value1 ? power_up_color : power_down_color
    elsif SkillSettings::BAD_PARAMS.include?(param)
      value2 > value1 ? power_down_color : power_up_color
    else
      normal_color
    end
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
    @last_index = 0
    refresh
  end

  # @return [Game_Actor]
  def actor
    @actor
  end

  # @return [RPG::Skill, RPG::State]
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
    draw_bg_srect(0, 0)
    change_color crisis_color
    draw_text(0, 0, contents_width, line_height, SkillSettings::REQ_VOCAB)
    return if skill.nil?
    @line = 1
    draw_required_ap
    draw_required_level
    draw_required_item
    draw_required_skill
    draw_required_passive
  end

  def draw_required_ap
    return if skill.required_upgrade_ap == 0
    change_color system_color, enough_ap?
    draw_text(0, @line * line_height, contents_width, line_height, Vocab.ap)
    change_color normal_color, enough_ap?
    draw_text(0, @line * line_height, contents_width, line_height, skill.required_upgrade_ap, 2)
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

  def draw_required_skill
    return unless skill.requires_skill_for_upgrade?
    draw_item_name(skill.required_upgrade_skill, 0, @line * line_height, skill_learnt?)
    @line += 1
  end

  def draw_required_passive
    return unless skill.requires_passive_for_upgrade?
    draw_item_name(skill.required_upgrade_passive, 0, @line * line_height, passive_learnt?)
    @line += 1
  end

  def can_upgrade?
    enough_ap? and enough_level? and enough_item?
  end

  def enough_ap?
    actor.ap >= skill.required_upgrade_ap
  end

  def enough_level?
    actor.level >= skill.required_upgrade_level
  end

  def enough_item?
    return true unless skill.requires_item_for_upgrade?
    $game_party.has_item?(skill.required_upgrade_item)
  end

  def skill_learnt?
    return true unless skill.requires_skill_for_upgrade?
    actor.skill_level(skill.required_upgrade_skill.id) >= skill.required_upgrade_skill.level
  end

  def passive_learnt?
    return true unless skill.requires_passive_for_upgrade?
    actor.passive_level(skill.required_upgrade_passive.id) >= skill.required_upgrade_passive.level
  end
end

class Window_Learn < Window_Command
  def initialize(x, y)
    @skill = nil
    super
  end

  def make_command_list
    add_command(learn_text, :learn)
    add_command(Vocab.cancel, :cancel)
  end

  def learn_text
    return '' if @skill.nil?
    sprintf('%s (%d %s)', Vocab.learn_skill, @skill.ap_cost, Vocab.ap)
  end

  # @param [RPG::Skill, RPG::State] new_skill
  # @param [Game_Actor] new_actor
  def set_data(new_skill, new_actor)
    return if @skill == new_skill && @actor == new_actor
    @skill = new_skill
    @actor = new_actor
    @list[0][:name] = learn_text
    refresh
    select(0)
  end

  def window_width
    400
  end

  def refresh
    super
    return if @skill.nil?
    text = sprintf(Vocab.actor_will_learn, @actor.name, @skill.name)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

  # il rettangolo del testo è un rigo più in basso
  def item_rect(index)
    super(index + 1)
  end

  def visible_line_number
    super + 1
  end
end

class Level_Require_Sprite < Sprite
  def initialize(viewport = nil)
    super
    @level = nil
  end

  def show(level)
    self.visible = true
    flash(Color::WHITE, 10)
    return if level == @level
    @level = level
    create_bitmap
  end

  def create_bitmap
    text = sprintf('Richiede il livello %d', @level)
    bitmap = Bitmap.new(150, 24)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    bitmap.fill_rect(rect, Color::INDIANRED)
    bitmap.font.color = Color::IVORY
    bitmap.font.shadow = false
    bitmap.set_pixel(0,0,Color::TRANSPARENT)
    bitmap.set_pixel(bitmap.width-1,0,Color::TRANSPARENT)
    bitmap.set_pixel(bitmap.width-1,bitmap.height-1,Color::TRANSPARENT)
    bitmap.set_pixel(0,bitmap.height-1,Color::TRANSPARENT)
    bitmap.draw_text(rect, text, 1)
    self.bitmap = bitmap
  end
end

class Skill_PowerableSprite < Sprite
  def initialize(viewport = nil)
    super
    @ap_cost = nil
  end

  def show(ap_cost)
    self.visible = true
    flash(Color::WHITE, 10)
    return if ap_cost == @ap_cost
    @ap_cost = ap_cost
    self.opacity = 200
    create_bitmap
    self.oy = self.bitmap.height
  end

  def create_bitmap
    text = sprintf('Potenziabile per %d %s', @ap_cost, Vocab.ap)
    bitmap = Cache.picture(SkillSettings::AP_POWER_BALOON).clone
    bitmap.font.color = Color::BLACK
    bitmap.font.shadow = false
    bitmap.font.size = 15
    rect = Rect.new(1, 1, bitmap.width - 3, bitmap.height - 8)
    bitmap.draw_text(rect, text, 1)
    self.bitmap = bitmap
  end
end

class Window_SkillUpgrade < Window_Command
  def initialize(x, y, width)
    @skill = nil
    @actor = nil
    @width = width
    super(x, y)
    self.openness = 0
    deactivate
  end

  # @return [Game_Actor]
  def actor
    @actor
  end

  # @return [Levellable]
  def skill
    @skill
  end

  # @param [Game_Actor] actor
  # @param [Levellable] skill
  def set_data(actor, skill)
    return if @actor == actor and @skill == skill
    @actor = actor
    @skill = skill
    self.height = window_height
    refresh
  end

  def window_width
    @width
  end

  def make_command_list
    return if @skill.nil?
    add_command(skill.next_level_evolution? ? Vocab.evolve_skill : Vocab.upgrade_command, :upgrade, skill_upgradable?)
    add_command(Vocab.cancel, :cancel)
  end

  def skill_upgradable?
    return false if skill.nil?
    #noinspection RubyMismatchedParameterType
    actor.can_level_up_skill? skill
  end

  def refresh
    super
    draw_requirements
  end

  def draw_requirements
    return if @skill.nil?
    @line = 1
    draw_required_title
    draw_required_ap
    draw_required_level
    draw_required_item
    draw_underline(@line - 1)
  end

  def draw_required_title
    change_color system_color
    draw_text(0, 0, contents_width, line_height, Vocab.requirements, 1)
    draw_underline(0)
  end


  def draw_required_ap
    return unless skill.required_upgrade_ap > 0
    enabled = actor.ap >= skill.required_upgrade_ap
    change_color(normal_color, enabled)
    text = sprintf('%d %s', skill.required_upgrade_ap, Vocab.ap)
    draw_icon(Icon.check(enabled), 0, @line * line_height)
    draw_text(ICON_WIDTH, @line * line_height, contents_width - ICON_WIDTH, line_height, text)
    @line += 1
  end

  def draw_required_level
    return unless skill.required_upgrade_level > 1
    enabled = actor.level >= skill.required_upgrade_level
    change_color(normal_color, enabled)
    text = sprintf('%s %d', Vocab.level, skill.required_upgrade_level)
    draw_icon(Icon.check(enabled), 0, @line * line_height)
    draw_text(ICON_WIDTH, @line * line_height, contents_width - ICON_WIDTH, line_height, text)
    @line += 1
  end

  def draw_required_item
    return unless skill.requires_item_for_upgrade?
    enabled = $game_party.has_item?(skill.required_upgrade_item)
    draw_icon(Icon.check(enabled), 0, @line * line_height)
    draw_item_name(skill.required_upgrade_item, ICON_WIDTH, @line * line_height, enabled, contents_width - ICON_WIDTH)
    @line += 1
  end

  # il rettangolo del testo è un rigo più in basso
  def item_rect(index)
    super(index + requirements_size)
  end

  def visible_line_number
    2 + requirements_size
  end

  def requirements_size
    return 0 if skill.nil?
    requirements = 1
    requirements += 1 if skill.required_upgrade_ap > 0
    requirements += 1 if skill.required_upgrade_level > 1
    requirements += 1 if skill.requires_item_for_upgrade?
    requirements
  end
end

class Window_SkillTargets < Window_MenuActor

  def item_max
    @data ? @data.size : 0
  end

  def make_item_list
    @data = $game_party.all_members
  end

  def item_height
    line_height * 2
  end

  # @param [Integer] index
  # @return [Game_Actor]
  def actor(index)
    @data[index]
  end

  # @return [Game_Actor]
  def item
    @data[@index]
  end

  def draw_item(index)
    actor = actor(index)
    rect = item_rect_for_text(index)
    draw_actor_line_face(actor, rect.x, rect.y)
    draw_actor_name(actor, rect.x + FACE_WIDTH, rect.y)
    draw_actor_state(actor, rect.width - 96, rect.y, 96)
    width = rect.width / 2
    draw_actor_hp(actor, rect.x, rect.y + line_height, width - 1)
    draw_actor_mp(actor, rect.x + width + 1, rect.y + line_height, width - 2)
  end
end