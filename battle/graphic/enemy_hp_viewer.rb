=begin
Finestra delle info nemico
Versione 1.0
Questo script permette di mostrare in alto dello schermo
le informazioni del nemico puntato. Se le informazioni del
nemico sono note, mostra dei suggerimenti.

ISTRUZIONI:
Lo script è pressoché automatico, ma dipende da diversi script:
- nuovo Scene_Status
- Bestiario
- Window Enanchements
- forse altro, ormai non riesco più a distinguere gli script tanto che sono incastrati

Alcuni tag utili:
<tip: x> usato su skill e nemici, aggiunge dei suggerimenti allo scan
<hide hp> nasconde gli HP ed i consigli del nemico anche se scansionato.
=end


module HintVocab
  WEAK = 'Debole'
  VERY_W = 'Molto debole'
  STRONG = 'Resiste'
  IMMUNE = 'Immune'
  ABSORB = 'Assorbe'
  SECURE = 'Sicuro'
  TYPE = 'Tipo: %s'
  ATTACK = 'Danni da'
  EVASION = 'Alta Evasione'
  LOW_HIT = 'Mira scarsa'
  PROTECTOR = 'Protegge le retrovie'
  HINT_CRITICAL = 'Alta prob. Critici'
  MAGIC_DAMAGE = 'Debole contro la magia'
  LOW_MAGIC_RES = 'Resistente alla magia'
  HIGH_MAGIC_RES = 'Molto resistente alla magia'
  IMMUNE_MAGIC = 'Immune alla magia'
  REFLECT_DMG = 'Danneggia chi lo colpisce'
  HIGH_AI = 'Molto furbo'
  PSYCHIC_AI = 'Conosce i punti deboli'


  # moves
  CAN_INFLICT = 'Può causare '
  CAN_DEFEND = 'Può difendersi'
  CAN_FLEE = 'Può fuggire se alle strette'
  CAN_HEAL = 'Può curarsi'
  CAN_HEAL_ALL = 'Può curare tutti'
  CAN_ABSORB = 'Può assorbire vita'
  CAN_AOE = 'Può colpire tutti'

  # stats
  HIGH_DEFENSE = 'Forte Difesa'
  HIGH_ATTACK = 'Attacco pericoloso'
  HIGH_SPIRIT = 'Alto Spirito'
  HIGH_SPEED = 'Molto veloce'
end

module EnemyStatusSettings

  # larghezza massima dello spazio degli status del nemico
  STATES_MAX_WIDTH = 200
  # larghezza della barra HP
  HP_WIDTH = 100
  # larghezza della barra MP
  MP_WIDTH = 70

  DIFFICULTY_COLORS = {
      :very_hard => Color::RED,
      :hard => Color::ORANGE,
      :easy => Color::GREEN,
      :very_easy => Color::BLUE
  }

  WINDOWSKIN = 'enemy_hp'

  ACTOR_PARAMS = [:atk, :def, :spi, :agi, :hit, :eva, :cri, :odds]
end

module CUSTOM_TIPS_OBJ
  # @return [String]
  attr_reader :custom_tips

  def init_custom_tips
    return if @custom_tips_defined
    @custom_tips_defined = true
    @custom_tips = []
    self.note.split(/[\n\r]+/).each do |line|
      if line =~ /<tip:[ ]*(.+)>/i
        @custom_tips.push($1)
      end
    end
  end
end

class RPG::Skill
  include CUSTOM_TIPS_OBJ
end

class RPG::Enemy
  include CUSTOM_TIPS_OBJ

  # @return [Boolean]
  attr_reader :hidden_hp

  def init_hidden_hp
    return if @init_hidden_hp
    @init_hidden_hp = true
    @hidden_hp = false
    self.note.split(/[\n\r]+/).each do |line|
      if line =~ /<hide hp>/i
        @custom_tips.push($1)
      end
    end
  end
end

module DataManager
  class << self
    alias tips_load_normal_database load_normal_database
    alias tips_load_battle_test_database load_battle_test_database
  end

  def self.load_normal_database
    tips_load_normal_database
    $data_enemies.each do |enemy|
      next if enemy.nil?
      enemy.init_custom_tips
      enemy.init_hidden_hp
    end
    $data_skills.each do |skill|
      next if skill.nil?
      skill.init_custom_tips
    end
  end

  def self.load_battle_test_database
    tips_load_battle_test_database
    $data_enemies.each do |enemy|
      next if enemy.nil?
      enemy.init_custom_tips
      enemy.init_hidden_hp
    end
    $data_skills.each do |skill|
      next if skill.nil?
      skill.init_custom_tips
    end
  end
end

class Window_Enemy_BattleInfo < Window_Base
  # @param [Viewport] viewport
  def initialize(viewport)
    super(-16, -16, Graphics.width + 32, fitting_height(1))
    @viewport = viewport
    self.visible = false
    @enemy = nil
    @hint_rect = nil
    @hint_counter = 0
    @hints = []
    @enemy_hp = 0
    @enemy_mp = 0
    @enemy_states = []
    reset_windowskin
    refresh
  end

  def reset_windowskin
    self.windowskin = Cache.system EnemyStatusSettings::WINDOWSKIN
    contents.font.bold = false
    contents.font.italic = false
    @back_opacity = 250
  end

  # @return [Game_Enemy]
  def enemy
    @enemy
  end

  def set_rects
    @name_rect = Rect.new(0, 0, text_size(enemy.name).width, line_height)
    @states_rect = Rect.new(@name_rect.width, 0, EnemyStatusSettings::STATES_MAX_WIDTH, line_height)
    @hp_rect = Rect.new(EnemyStatusSettings::STATES_MAX_WIDTH, 0, EnemyStatusSettings::HP_WIDTH, line_height)
    @mp_rect = Rect.new(@hp_rect.x + @hp_rect.width, 0, EnemyStatusSettings::MP_WIDTH, line_height)
    @hint_rect = Rect.new(@mp_rect.x + @mp_rect.width + 2, 0, contents_width - (@mp_rect.x + @mp_rect.width) - 2, line_height)
    @stats_rect = Rect.new(@name_rect.width + 5, 0, contents_width - @name_rect.width - 5, line_height)
  end

  def refresh
    contents.clear
    return if enemy.nil?
    draw_target_name(@name_rect.x, @name_rect.y, @name_rect.width)
    if enemy.actor?
      draw_target_params(@stats_rect.x, @stats_rect.y)
    else
      draw_target_states(@states_rect.x, @states_rect.y, @states_rect.width)
      return if enemy.hide_hp?
      draw_target_hp
      enemy.charge_gauge? ? draw_target_anger : draw_target_mp
      return unless show_info?
      @hints = enemy.hints
      draw_target_hints(@hint_rect.x, @hint_rect.y, @hint_rect.width)
    end
  end

  # imposta la finestra per un nuovo nemico
  # @param [Game_Enemy] enemy
  # @param [Game_Actor] commander
  def setup(enemy, commander)
    return if @enemy == enemy && @commander == commander
    @enemy = enemy
    @commander = commander
    if enemy
      set_rects
      refresh
      self.visible = true
    else
      self.visible = false
    end
  end

  def update
    super
    return unless self.visible
    return if enemy.actor?
    update_states
    return if enemy.hide_hp?
    update_hints
    update_hp_mp
  end

  def update_hints
    return unless show_info?
    return if Graphics.frame_count % 60 > 0
    @hint_counter += 1
    contents.clear_rect(@hint_rect)
    draw_current_hint
  end

  def update_hp_mp
    draw_target_hp
    enemy.charge_gauge? ? draw_target_anger : draw_target_mp
  end

  def draw_target_hp
    return if @enemy_hp == enemy.hp
    contents.clear_rect(@hp_rect)
    draw_actor_hp(enemy, @hp_rect.x, @hp_rect.y, @hp_rect.width)
  end

  def draw_target_mp
    return if @enemy_mp == enemy.mp
    contents.clear_rect(@mp_rect)
    draw_actor_mp(enemy, @mp_rect.x, @mp_rect.y, @mp_rect.width)
  end

  def draw_target_anger
    return if @enemy_mp == enemy.anger
    contents.clear_rect(@mp_rect)
    draw_actor_anger(enemy, @mp_rect.x, @mp_rect.y, @mp_rect.width)
  end

  def update_states
    return if @enemy_states == enemy.states
    @enemy_states = enemy.states.clone
    contents.clear_rect(@states_rect)
    draw_target_states(@states_rect.x, @states_rect.y, @states_rect.width)
  end

  def draw_target_name(x, y, width)
    change_color target_color_level
    contents.draw_text(x, y, width, line_height, enemy.name)
    draw_assimilable_skills_icon(x, y)
  end

  def draw_assimilable_skills_icon(x, y)
    return if enemy.actor?
    return unless commander.can_assimilate?
    assimilable_skills = enemy.assimilable_skills(commander)
    if assimilable_skills.any?
      draw_icon(H87AttrSettings::ASSIMILATE_ICON, x, y)
    end
  end

  def draw_target_params(x, y)
    return unless commander.autoscan?
    change_color normal_color
    EnemyStatusSettings::ACTOR_PARAMS.each do |param|
      x += draw_target_param(param, x, y)
    end
  end

  def draw_target_param(param, x, y)
    icon = EquipSettings::ICONS[param]
    text = enemy.send(param).to_s
    draw_icon(icon, x, y)
    draw_text(x + 24, y, 100, line_height, text)
    24 + text_size(text).width + 5
  end

  # @return [Color]
  def target_color_level
    return power_up_color if enemy.actor?
    colors = EnemyStatusSettings::DIFFICULTY_COLORS
    lvl_diff = commander.level - enemy.level
    return colors[:very_hard] if lvl_diff < -15
    return colors[:hard] if lvl_diff < 2
    return colors[:very_easy] if lvl_diff > 20
    return colors[:easy] if lvl_diff > 3
    normal_color
  end

  def draw_target_states(x, y, width)
    state_icons = enemy.states.compact.select{
        |state| state.priority > 1 && state.icon_index > 0}.map{|state| state.icon_index}
    draw_icons(state_icons, x, y, width)
  end

  def draw_target_mp_bar(x, y, width, height)
    contents.fill_rect(x, y, width, height, H87HUD_SETTINGS::BAR_COLORS[:black])
    contents.gradient_fill_rect(x, y, enemy.mp_rate * width, height,
                                H87HUD_SETTINGS::GRAD_COLORS1[:mp],
                                H87HUD_SETTINGS::GRAD_COLORS2[:mp])
    if show_info?
      contents.font.size = 15
      contents.draw_text(x, y, width, height, sprintf('%d %s', enemy.mp, Vocab.mp_a))
    end
  end

  def show_info?
    !enemy.actor? && commander.autoscan?
  end

  def draw_target_hints(x, y, width)
    @hint_rect = Rect.new(x, y, width, line_height)
    draw_current_hint
  end

  def draw_current_hint
    return if @hints.nil? or @hints.empty?
    hint = @hints[@hint_counter % @hints.size]
    if hint.is_a?(String)
      draw_text(@hint_rect, hint, 0)
    elsif hint.is_a?(Hash)
      draw_text(@hint_rect, hint[:text], 0)
      draw_hint_icons(@hint_rect, hint)
    end
  end

  def draw_hint_icons(rect, hint)
    spacing = text_size(hint[:text]).width + 1
    x = rect.x + spacing
    width = rect.width - spacing
    draw_icons(hint[:icons], x, rect.y, width)
  end

  # eroe corrente che sta scegliendo il bersaglio
  # @return [Game_Actor]
  def commander
    @commander
  end
end

class Game_Actor < Game_Battler
  def autoscan?
    has_feature? :autoscan
  end
end

class Game_Enemy < Game_Battler
  # restituisce i suggerimenti da mostrare
  # @return [Array<String,Hash>]
  def hints
    hints = []
    hints.push hint_enemy_type
    hints.push hint_damage_type
    hints.concat hint_type_weakness
    hints.concat hint_states_weakness
    hints.concat hint_params
    hints.push hint_magic_res
    hints.push hint_high_eva
    hints.push hint_low_hit
    hints.push hint_can_defend
    hints.push hint_can_flee
    hints.push hint_can_heal
    hints.push hint_can_absorb
    hints.push hint_reflect_dmg
    hints.push hint_apply_effect
    hints.push hint_protector
    hints.concat custom_hints
    hints.compact
  end

  def level
    enemy.level
  end

  def hide_hp?
    enemy.hidden_hp
  end

  def hint_type_weakness
    less_weak = []
    very_weak = []
    strong = []
    immune = []
    absorb = []
    ($data_system.magic_elements + $data_system.weapon_attributes).each do |element|
      case self.element_rate element.id
      when 0
        immune.push(element.icon_index)
      when 1..99
        strong.push(element.icon_index)
      when 101..150
        less_weak.push(element.icon_index)
      when 151..200
        very_weak.push(element.icon_index)
      when -100..-1
        absorb.push(element.icon_index)
      else
        # nothing
      end
    end
    ret = []
    ret.push hint_with_icons(HintVocab::WEAK, less_weak) if less_weak.any?
    ret.push hint_with_icons(HintVocab::VERY_W, very_weak) if very_weak.any?
    ret.push hint_with_icons(HintVocab::STRONG, strong) if strong.any?
    ret.push hint_with_icons(HintVocab::IMMUNE, immune) if immune.any?
    ret.push hint_with_icons(HintVocab::ABSORB, absorb) if absorb.any?
    ret
  end

  def hint_states_weakness
    less_weak = []
    very_weak = []
    strong = []
    immune = []
    StatusSettings::DSTATES.each do |state_id|
      state = $data_states[state_id]
      case self.state_probability(state_id)
      when 0
        immune.push(state.icon_index)
      when 1..59
        strong.push(state.icon_index)
      when 61..70
        less_weak.push(state.icon_index)
      when 71..100
        very_weak.push(state.icon_index)
      else
        # niente
      end
    end
    ret = []
    ret.push hint_with_icons(HintVocab::WEAK, less_weak) if less_weak.any?
    ret.push hint_with_icons(HintVocab::SECURE, very_weak) if very_weak.any?
    ret.push hint_with_icons(HintVocab::STRONG, strong) if strong.any?
    ret.push hint_with_icons(HintVocab::IMMUNE, immune) if immune.any?
    ret
  end

  def hint_enemy_type
    sprintf(HintVocab::TYPE, enemy.enemy_type)
  end

  def hint_damage_type
    displayable_ids = ($data_system.weapon_attributes + $data_system.magic_elements).map{|e|e.id}
    attack_elements = self.element_set & displayable_ids
    return nil if attack_elements.empty?
    if attack_elements.size == 1
      ele_name = $data_system.elements_data.select {|ele| ele.id == attack_elements.first}.first.name
      sprintf('%s %s', HintVocab::ATTACK, ele_name)
    else
      icons = $data_system.elements_data.select{|ele| attack_elements.include?(ele.id)}.collect {|e| e.icon_index}
      hint_with_icons(HintVocab::ATTACK, icons)
    end
  end

  def hint_high_eva
    HintVocab::EVASION if self.eva >= 10
  end

  def hint_low_hit
    HintVocab::LOW_HIT if self.hit < 90
  end

  def hint_magic_res
    return HintVocab::MAGIC_DAMAGE if self.magic_def > 1
    return HintVocab::IMMUNE_MAGIC if self.magic_def <= 0
    return HintVocab::HIGH_MAGIC_RES if self.magic_def < 0.5
    return HintVocab::LOW_MAGIC_RES if self.magic_def < 1
    nil
  end

  def hint_reflect_dmg
    HintVocab::REFLECT_DMG if self.physical_reflect > 0
  end

  def hint_apply_effect
    states = enemy.actions.select{|action| action.skill?}.inject([]) do |ary, action|
      ary + $data_skills[action.skill_id].plus_state_set
    end
    states.uniq!
    return if states.empty?
    if states.size == 1
      sprintf('%s %s', HintVocab::CAN_INFLICT, $data_states[states.first].name)
    else
      hint_with_icons(HintVocab::CAN_INFLICT, states)
    end
  end

  def hint_aoe
    HintVocab::CAN_AOE if enemy.actions.select{|action| action.skill? and $data_skills[action.skill_id].scope == 2}.any?
  end

  def hint_protector
    HintVocab::PROTECTOR if enemy.protector?
  end

  def hint_can_heal
    if enemy.actions.select {|act| act.skill? && $data_skills[act.skill_id].base_damage < 0}.any?
      HintVocab::CAN_HEAL
    end
  end

  def hint_can_absorb
    # noinspection RubyResolve
    vampire = enemy.actions.select {|act| act.skill? && $data_skills[act.skill_id].absorb_damage}.any?
    HintVocab::CAN_ABSORB if vampire or vampire_rate > 0
  end

  def hint_can_defend
    HintVocab::CAN_DEFEND if enemy.actions.select {|act| act.basic == 1}.any?
  end

  def hint_can_flee
    HintVocab::CAN_FLEE if enemy.actions.select {|act| act.basic == 2}.any?
  end

  def hint_ai
    return HintVocab::PSYCHIC_AI if enemy.psychic_ai or enemy.ai_level > 100
    HintVocab::HIGH_AI if enemy.ai_level > 50
  end

  def hint_params
    mids = (self.atk + self.def + self.spi + self.agi) / 4
    rets = []
    rets.push(HintVocab::HIGH_ATTACK) if self.atk > mids  * 1.4
    rets.push(HintVocab::HIGH_DEFENSE) if self.def > mids * 1.4
    rets.push(HintVocab::HIGH_SPIRIT) if self.spi > mids  * 1.4
    rets.push(HintVocab::HIGH_SPEED) if self.agi > mids   * 1.4
    rets
  end

  def custom_hints
    sk_hints = enemy.actions.select{|act| act.skill?}.inject([]){|ary, sk| ary.concat($data_skills[sk.skill_id].custom_tips)}
    sk_hints.concat(enemy.custom_tips)
  end

  # creates an hash with hint objects
  # @return [Hash]
  def hint_with_icons(text, icon_index_array)
    {:text => text, :icons => icon_index_array}
  end
end

class Scene_Battle < Scene_Base
  unless $@
    alias h87_enemy_window_start start
    alias h87_enemy_window_update update
    alias h87_enemy_window_terminate terminate
    alias h87_ew_select_member start_target_selection
    alias h87_ew_end_target_selection end_target_selection
    alias h87_ew_cursor_up cursor_up
    alias h87_ew_cursor_down cursor_down
  end

  def start
    h87_enemy_window_start
    @enemy_window = Window_Enemy_BattleInfo.new(@info_viewport)
  end

  def update
    h87_enemy_window_update
    @enemy_window.update
  end

  #def terminate
  #  h87_enemy_window_terminate
  #  @enemy_window.dispose
  #end

  def start_target_selection(actor = false)
    h87_ew_select_member(actor)
    update_enemy_window
  end

  # noinspection RubyResolve
  def update_enemy_window
    return if @target_members.nil?
    battler = @target_members[@index]
    if battler
      @enemy_window.setup battler, @commander
    else
      @enemy_window.visible = false
    end
  end

  def end_target_selection(cansel = false)
    h87_ew_end_target_selection(cansel)
    @enemy_window.setup(nil, nil)
  end

  def cursor_up
    h87_ew_cursor_up
    update_enemy_window
  end

  def cursor_down
    h87_ew_cursor_down
    update_enemy_window
  end
end