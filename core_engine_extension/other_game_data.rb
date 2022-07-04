#==============================================================================
# ** Game_Unit
#---------------------------------------------------------------------------
# Metodo per il contagio delle unità
#==============================================================================
class Game_Unit

  # Controlla e diffonde il contagio tra i membri
  def check_plague
    members.each { |member|
      inf = member.infected
      if inf > 0
        expand_plague(inf)
        break
      end
    }
  end

  # restituisce i membri bersagliabili
  # @return [Array<Game_Battler>]
  def targettable_members
    members
  end

  # Espande il contagio
  # inf: id dello stato virale
  def expand_plague(inf)
    sane = []
    members.each { |member| sane.push(member) if member.infected == 0 }
    if sane.size > 0
      battler = sane[rand(sane.size)]
      battler.apply_state_changes(FakeStObj.new(inf))
    end
  end
end

#==============================================================================
# ** FakeStObj
#---------------------------------------------------------------------------
# Classe che serve come rimpiazzo delle skill per applicare gli status.
#==============================================================================
class FakeStObj
  # @attr[Array<Integer>] plus_state_set
  # @attr[Array<Integer>] minut_state_set
  attr_reader :plus_state_set
  attr_reader :minus_state_set
  # @param [Integer] state_id
  def initialize(state_id)
    @plus_state_set = [state_id]
    @minus_state_set = []
  end
end

class Game_Troop < Game_Unit
  # restituisce i membri del gruppo che sono bersagliabili
  # @return [Array<Game_Enemy>]
  def targettable_members
    return members unless $game_temp.is_meele_skill
    members.select { |member| !member.protected? }
  end

  # @return [Game_Enemy]
  def smooth_target(index)
    return super(index) unless $game_temp.is_meele_skill
    return smooth_target(index + 1) if members[index].protected?
    #noinspection RubyYardReturnMatch
    super(index)
  end

  # @return [Array<Game_Battler>, nil]
  def random_target
    return super unless $game_temp.is_meele_skill
    roulette = []
    #noinspection RubyResolve
    existing_members.select { |member| !member.protected? }.
      each { |member| member.odds.times { roulette.push(member) } }
    roulette.size > 0 ? roulette[rand(roulette.size)] : nil
  end
end

#==============================================================================
# ** Game_Party
#---------------------------------------------------------------------------
# Metodi d'informazione per il gruppo
#==============================================================================
class Game_Party < Game_Unit
  alias h87attr_item_number item_number unless $@
  alias h87attr_gain_item gain_item unless $@
  alias h87attr_item_can_use item_can_use? unless $@

  # Restituisce il difensore del gruppo o nil (colui che prende danno al
  # posto degli alleati)
  # @return [Game_Actor, nil]
  def defender
    battle_members.select { |member| member.defender? }.first
  end

  # @param [RPG::Item, RPG::Armor, RPG::Weapon] item
  def item_number(item)
    return 0 if item.nil?
    if item.is_placeholder?
      items_with_placeholder = all_items.select { |i| i.has_placeholder? }
      items_with_placeholder.each do |p_item|
        return h87attr_item_number(p_item) if p_item.placeholder_id == item.id
      end
      0
    else
      h87attr_item_number(item)
    end
  end

  # @param [RPG::Item] item
  def item_can_use?(item)
    return false unless h87attr_item_can_use item
    return false if req_menu_witch(item)
    true
  end

  # determina se l'oggetto è utilizzabile dal menu
  # solo nella condizione che il suo switch sia ON
  # @param [RPG::Skill,RPG::Item] obj
  def req_menu_witch(obj)
    return false if obj.nil?
    return false if $game_temp.in_battle
    return false if obj.required_menu_switch.nil?
    return false if obj.required_menu_switch == 0
    !$game_switches[obj.required_menu_switch]
  end

  # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
  # @param [Integer] n
  # @param [FalseClass] include_equip
  def gain_item(item, n = 1, include_equip = false)
    return if item.nil?
    return if item.is_placeholder?
    h87attr_gain_item(item, n, include_equip)
  end

  # Restituisce il tank del gruppo
  # @return [Game_Actor]
  def tank
    (0..H87AttrSettings::TANKS.size - 1).each { |actor_id|
      return $game_actors[i] if battle_members.include?($game_actors[actor_id])
    }
    nil
  end

  # Restituisce il bonus parametro del gruppo
  # param: parametro (atk, def, spi, agi, cri, hit, eva)
  def party_bonus(param)
    members.inject(0) { |bonus, member| bonus + member.actor_party_bonus(param) }
  end

  # Restituisce il parametro aggiunto da un membro del gruppo
  # param: parametro (atk, def, spi, agi)
  def param_gift(param)
    return 0 unless $game_temp.in_battle
    members.inject(0) { |bonus, member| bonus + member.param_gift(param) }
  end

  # Non fa consumare l'oggetto con la giusta probabilità
  alias force_consume_item consume_item unless $@
  # @param [RPG::Item] item
  def consume_item(item)
    return force_consume_item(item) unless $game_temp.in_battle
    force_consume_item(item) if save_prob <= rand
  end

  # Alias del metodo per incrementare passi per scalare l'ira
  alias h87attr_increase_steps increase_steps unless $@

  def increase_steps
    h87attr_increase_steps
    # Non riduce più la furia.
    #members.each { |member|
    # member.reduce_anger if member.charge_gauge?
    #}
  end

  # Restituisce la probabilità di salvare l'oggetto
  def save_prob
    return 0 unless $game_temp.in_battle
    $game_temp.active_battler.save_item_bonus
  end

  # Restituisce true se un membro del gruppo ha scassinatore
  def ha_scassinatore?
    members.select { |member| member.scassinatore? }.any?
  end

  # Restituisce true se un membro del gruppo ha virilità
  def ha_virile?
    members.select { |member| member.virile? }.any?
  end

  # Restituisce il bonus di durata delle dominazioni
  # @return [Float]
  def domination_bonus
    members.inject(1.0) { |bonus, member| bonus + member.dom_bonus }
  end

  # Restituisce lo charm totale dei membri del gruppo
  # @return [Integer]
  def total_charm
    member.inject(0) { |charm, member| charm + member.charm }
  end

  # Restituisce true se almeno un giocatore può saltare lontano
  def has_long_jump?
    members.each { |member|
      return true if member.can_jump_longer?
    }
    false
  end

  # Restituisce true se almeno un giocatore è un meccanico
  def has_mechanic?
    members.select { |member| member.mechanic? }.any?
  end

  def can_show_atb?
    members.select { |member| member.show_atb? }.any?
  end

  def placeholder_armors
    all_items.select { |item| item.has_placeholder? }.collect { |item| $data_armors[item.placeholder_id] }
  end
end

#game_party

class Game_Temp
  # @return[Game_Battler] active_battler
  attr_accessor :active_battler
  attr_accessor :is_meele_skill

end

#==============================================================================
# ** Scene_Battle
#---------------------------------------------------------------------------
# Cambiamento dei metodi in Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  unless $@
    alias start_attr start
    alias execute_action_item_sav execute_action_item
    alias terminate_attr terminate
    alias h87attr_eas execute_action_skill
    alias consume_item_skill_attr consume_item_skill
    alias h87attr_process_victory process_victory
    alias execute_action_attr execute_action
    alias h87_attragg_turn_end turn_end
  end
  # Inizio
  def start
    start_attr
    $game_party.members.each { |member|
      member.init_for_battle
    }
    $game_troop.members.each { |enemy|
      enemy.init_for_battle
    }
  end

  # Alias esecuzione azione oggetto
  def execute_action_item
    $game_temp.active_battler = @active_battler if @active_battler.actor?
    execute_action_item_sav
  end

  # Consuma l'oggetto con l'abilità speciale
  # @param [Object] item_id
  # @param [Object] item_number
  # noinspection RubyNilAnalysis
  def consume_item_skill(item_id, item_number)
    return if @active_battler.save_item_bonus >= rand
    consume_item_skill_attr(item_id, item_number)
  end

  # Esecuzione dell'azione
  def execute_action
    execute_action_attr
    ab = @active_battler
    update_actor_song(ab.action.kind == 1) if !ab.nil? && ab.actor?
  end

  # Aggiorna il conteggio delle canzoni
  # noinspection RubyResolve,RubyNilAnalysis
  def update_actor_song(skill_type)
    return unless @active_battler.has_rhytm?
    if !skill_type || @active_battler.action.skill.skill_type == 'Canto'
      @active_battler.song_count = 0
    else
      @active_battler.song_count += 1
    end
  end

  # Alias di fine scena
  def terminate
    terminate_attr
    $game_party.members.each do |member|
      member.song_count = 0
    end
  end

  # esecuzione della skill del battler
  def execute_action_skill
    h87attr_eas
    ab = @active_battler
    # @param [Game_Battler] ab
    return if ab.nil?
    skill = ab.action.skill
    return if skill.nil?
    ab.set_last_skill_used skill.id
    ab.anger -= ab.calc_anger_cost(skill) if ab.charge_gauge?
    ab.anger = 0 if skill.clear_anger
    if ab.assimilated?(skill)
      ab.consume_assimilated_skill(skill)
    end
  end

  # Esplosione di un nemico colpito da Bombifica
  def bomb_explode(battler)
    $game_troop.members.each { |member|
      next if member.dead?
      skill = $data_skills[ExtraAttr::BOMB_SKILL]
      member.skill_effect(battler, skill)
      if member == battler
        member.animation_id = skill.animation_id
      else
        damage = member.hp_damage
        member.animation_id = 82
        @spriteset.enemy_sprites[member.index].damage_pop(damage)
        @spriteset.enemy_sprites[member.index].start_action(member.damage_hit)
      end
    }
  end

  # forza l'apparizione del danno sul battler
  # @param [Game_Battler] battler su cui mostrare il danno
  # @param [Integer] animation_id animazione da mostrare
  # @param [Integer] damage danno in caso non è definito un hp_damage
  def force_damage_pop(battler, animation_id = 0, damage = nil)
    sprite = battler_sprite(battler)
    if damage.nil?
      damage = battler.hp_damage != 0 ? battler.hp_damage : battler.mp_damage
    else
      battler.hp_damage = damage
    end
    battler.double_damage = battler.hp_damage != 0 && battler.mp_damage != 0
    sprite.damage_pop(damage)
    force_battler_animation(battler, animation_id) if animation_id > 0
    battler.execute_damage_without_action(battler)
  end

  # mostra l'animazione sul battler
  # @param [Game_Battler] battler su cui mostrare il danno
  # @param [Integer] animation_id animazione da mostrare
  def force_battler_animation(battler, animation_id)
    sprite = battler_sprite(battler)
    battler.animation_id = animation_id
    battler.animation_mirror = !battler.actor?
  end

  # Alias di fine turno
  # @param [Game_Battler] param
  def turn_end(member = nil)
    process_autostate_skill(member)
    process_turn_resets(member)
    # noinspection RubyArgCount
    h87_attragg_turn_end(member)
    infect_plague
    charge_anger
  end

  # restituisce lo sprite del battler
  # @param [Game_Battler] battler
  # @return [Sprite_Battler]
  def battler_sprite(battler)
    if battler.actor?
      index = $game_party.members.index(battler)
      sprite = @spriteset.actor_sprites[index]
    else
      index = $game_troop.members.index(battler)
      sprite = @spriteset.enemy_sprites[index]
    end
    sprite
  end

  # @param [Game_Battler] battler
  def process_autostate_skill(battler = @active_battler)
    return if battler.nil?
    skill = battler.action.skill
    return if skill.nil?
    return if skill.autostate.nil?
    return if battler.has_state?(skill.autostate.state_id)
    return if skill.autostate.state_rate <= rand
    state = $data_states[skill.autostate.state_id]
    return if state.message1.empty?
    return if state.priority < 1
    text = sprintf(state.message1.gender(battler.gender), battler.name)
    push_popup(text, state.icon_index)
  end

  # @param [Game_Battler] battler
  def process_turn_resets(battler = @active_battler)
    return if battler.nil?
    skill = battler.action.skill
    return if skill.nil?
    @cumuled_damage = 0 if skill.reset_damage
  end

  # Processo di vittoria
  def process_victory
    h87attr_process_victory
    $game_party.battle_members.each { |member|
      next if member.dead?
      member.hp_damage -= member.win_hp
      member.mp_damage -= member.win_mp
      force_damage_pop(member)
    }
  end

  # Epidemia alla fine del turno
  def infect_plague
    $game_troop.check_plague
    $game_party.check_plague
  end

  # Carica la furia dei membri
  def charge_anger
    $game_party.battle_members.each { |member|
      next if member.nil?
      next if member.dead?
      next unless member.charge_gauge?
      member.anger += member.anger_turn
    }
  end
end

class Window_Skill < Window_Selectable
  alias h87attr_draw_mpc draw_mp_cost unless $@
  alias h87attr_draw_item draw_item unless $@
  # alias del metodo draw_mp_cost per mostrare la furia se l'eroe usa la skill
  # noinspection RubyUnusedLocalVariable
  # @param [RPG::Skill] skill abilità in oggetto
  # @param [Rect] rect
  # @param [Game_Actor] actor eroe che possiede l'abilità
  # @param [true, false] enabled se abilitato o diasabilitato
  # @return [Integer] la nuova larghezza sottratta
  def draw_mp_cost(skill, rect, actor, enabled)
    if actor.charge_gauge?
      draw_anger_cost(skill, rect, actor, enabled)
    else
      h87attr_draw_mpc(skill, rect, actor, enabled)
    end
  end

  # @param [RPG::Skill] skill abilità in oggetto
  # @param [Rect] rect rettangolo
  # @param [Game_Actor] actor eroe che possiede l'abilità
  # @param [true, false] enabled se abilitato o diasabilitato
  # @return [Integer] la nuova larghezza sottratta
  def draw_anger_cost(skill, rect, actor, enabled)
    return width if actor.calc_anger_cost(skill) == 0
    change_color anger_color, enabled
    cost = sprintf('%d%s', actor.calc_anger_cost(skill), Vocab.anger)
    draw_text(rect, cost, 2)
    rect.width -= text_size(cost).width + H87_SKILL_COSTS::SPACING
  end

  def draw_item(index)
    h87attr_draw_item(index)
    skill = @data[index]
    rect = item_rect(index)
    if @actor.assimilated?(skill)
      draw_icon(H87AttrSettings::ASSIMILATE_ICON, rect.x, rect.y)
    end
  end
end

class Window_Base < Window
  alias h87attr_draw_actor_mp draw_actor_mp
  # Colore della Furia
  # @return [Color]
  def anger_color
    text_color(3)
  end

  # Colore sfondo 1 della Furia
  # @return [Color]
  def anger_gauge_color1
    text_color(3)
  end

  # Colore sfondo 2 della Furia
  # @return [Color]
  def anger_gauge_color2
    text_color(11)
  end

  # Alias del metodo draw_actor_mp. Disegna Furia se il personaggio ne è
  # dotato.
  # @param [Game_Battler] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_mp(actor, x, y, width = 120)
    if actor.charge_gauge? and actor.mp_gauge?
      h87attr_draw_actor_mp(actor, x, y, width / 2 - 2)
      draw_actor_anger(actor, x + (width / 2) + 1, y, width / 2 - 1)
    elsif actor.charge_gauge?
      draw_actor_anger(actor, x, y, width)
    elsif actor.mp_gauge?
      h87attr_draw_actor_mp(actor, x, y, width)
    end
  end

  # Disegna la furia dell'eroe
  # @param [Game_Battler] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_anger(actor, x, y, width = 120)
    draw_actor_anger_gauge(actor, x, y, width)
    contents.font.color = system_color
    contents.draw_text(x + 2, y, 30, line_height, Vocab::fu_a)
    contents.font.color = normal_color
    #last_font_size = contents.font.size
    text = sprintf('%2d/%2d', actor.anger, actor.max_anger)
    if width - 33 < contents.text_size(text).width
      contents.draw_text(x + 32, y, width - 33, line_height, actor.anger.group, 1)
    else
      contents.draw_text(x + 32, y, width - 33, line_height, text, 1)
    end
  end

  # Disegna la furia dell'eroe
  # @param [Game_Battler] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_anger_gauge(actor, x, y, width = 120)
    actor.anger = [actor.anger, actor.max_anger].min
    gc0 = gauge_back_color
    gc1 = anger_gauge_color1
    gc2 = anger_gauge_color2
    gh = Y6::SETTING::GAUGE_HEIGHT
    gh += 2 if Y6::SETTING::OUTLINE
    gy = y + line_height - 8 - (gh - 6)
    contents.fill_rect(x, gy, width, gh, gc0)
    gy += 1 if Y6::SETTING::OUTLINE
    gh -= 2 if Y6::SETTING::OUTLINE
    width -= 2 if Y6::SETTING::OUTLINE
    max_anger = [[actor.max_anger, 1].max, 999].min
    gbw = width * actor.anger / max_anger
    x += 1 if Y6::SETTING::OUTLINE
    contents.gradient_fill_rect(x, gy, gbw, gh, gc1, gc2)
  end
end

class Game_BattleAction
  alias set_normal_guard set_guard unless $@
  alias set_normal_attack set_attack unless $@
  alias h87attr_make_attack_targets make_attack_targets unless $@
  alias h87attr_make_obj_targets make_obj_targets unless $@

  def set_attack
    if @battler.actor? and @battler.has_custom_attack?
      set_skill(@battler.custom_attack_skill.id)
    else
      set_normal_attack
    end
  end

  # imposta il comando di guardia
  def set_guard
    if @battler.actor? and @battler.has_custom_guard?
      set_skill(@battler.custom_guard_skill.id)
    else
      set_normal_guard
      @battler.apply_guard_bonus
    end
  end

  def make_attack_targets
    $game_temp.is_meele_skill = meele_and_actor?
    targets = h87attr_make_attack_targets
    $game_temp.is_meele_skill = nil
    targets
  end

  # @param [RPG::UsableItem] obj
  def make_obj_targets(obj)
    if !@battler.actor? && obj.only_for_actor?
      return $game_party.alive_members.select { |member| !member.domination? }
    end
    if !@battler.actor? && obj.only_for_domination?
      return $game_party.alive_members.select { |member| member.domination? }
    end
    if obj.for_all_in_field?
      return opponents_unit.alive_members + friends_unit.alive_members
    end
    if obj.for_opponents_with_state?
      return opponents_unit.alive_members.
        select { |member| obj.target_states.all? { |state_id| member.state_ids.include?(state_id) } }
    end
    if obj.for_other_friends?
      return friends_unit.alive_members.select {|member| member.id != self.id}
    end
    $game_temp.is_meele_skill = meele_and_actor?
    targets = h87attr_make_obj_targets(obj)
    $game_temp.is_meele_skill = nil
    targets
  end

  # restituisce l'oggetto dell'azione
  # @return [RPG::Skill,RPG::Item]
  def action_object
    skill || item
  end

  # determina se è una skill a distanza
  def ranged?
    return battler.ranged_attack? if attack?
    return skill.ranged? if skill?
    true
  end

  def meele_and_actor?
    battler.actor? && !ranged?
  end
end

class Spriteset_Battle
  # @return [Array<Sprite_Enemy>]
  attr_reader :enemy_sprites
  # @return [Array<Sprite_Actor>]
  attr_reader :actor_sprites

  # restituisce lo sprite del battler
  # @param [Game_Battler] battler
  # @param [Integer] index
  # @return [Sprite_Battler]
  def battler_sprite(battler, index)
    sprites = battler.actor? ? @actor_sprites : @enemy_sprites
    sprites[index]
  end
end