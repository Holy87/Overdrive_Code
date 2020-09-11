# questo script permette di cambiare bersaglio di alcune abilità
# da amico a nemico e viceversa.
# Se un'abilità può cambiare bersaglio da nemico/amico, bisogna mettere
# il tag <switchable> nelle note (definito negli attributi aggiuntivi)
#
#
#==============================================================================
# ** Impostazioni generiche
#==============================================================================
module SETTINGS
  SWITCH_TARGET_BTN = :R
  SWITCH_HELP = 'Cambia bersagli'
  SWITH_HELP_WIDTH = 200
  SWITCH_HELP_X = 340
  SWITCH_HELP_Y = 280

end

#==============================================================================
# ** UsableItem
#==============================================================================
class RPG::UsableItem

  # determina se l'oggetto o l'abilità è switchabile.
  # Restituisce sempre falso se è una skill totale, random
  # o seleziona sé stesso
  def switchable?
    return false unless need_selection?
    @switchable
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  alias h87switchable_update update_basic unless $@
  alias h87switchable_sts start_target_selection unless $@
  alias h87switchable_ets end_target_selection unless $@
  alias h87switchable_start start unless $@
  alias h87switchable_terminate terminate unless $@

  # inizio
  def start
    h87switchable_start
    create_switchable_helper
  end

  # fine
  def terminate
    @switchable_sprite.dispose
    h87_enemy_window_terminate
  end

  # aggiornamento
  def update_basic(main = false)
    #noinspection RubyArgCount
    h87switchable_update(main)
    @switchable_sprite.update
    check_switchable_skills
  end

  def show_switch_help_sprite
    @switchable_sprite.fade(255, 40)
    @switchable_sprite.smooth_move(SETTINGS::SWITCH_HELP_X + 80, SETTINGS::SWITCH_HELP_Y, 6)
  end

  def hide_switch_help_sprite
    @switchable_sprite.fade(0, 40)
    @switchable_sprite.smooth_move(SETTINGS::SWITCH_HELP_X, SETTINGS::SWITCH_HELP_Y, 6)
  end

  # inizia la selezione del bersaglio
  # @param [Boolean] actor
  def start_target_selection(actor = false)
    @selection_active = true
    @commander.action.target_member = actor ? :friend : :enemy
    $game_temp.is_meele_skill = !@commander.action.ranged? unless actor
    show_switch_help_sprite if action_switchable(@commander.action)
    @selection_active_actor = actor
    h87switchable_sts(actor)
    $game_temp.is_meele_skill = nil
  end

  # fine della selezione del bersaglio
  def end_target_selection(cansel = false)
    @selection_active = false
    hide_switch_help_sprite
    h87switchable_ets(cansel)
  end

  # determina se stai selezionando un nemico e si deve
  # cambiare tipo di bersaglio
  def check_switchable_skills
    return unless @selection_active
    return if @commander.nil?
    return unless Input.trigger?(SETTINGS::SWITCH_TARGET_BTN)
    return unless action_switchable(@commander.action)
    Sound.play_cursor
    start_target_selection(!@selection_active_actor)
  end

  # determina se l'azione attuale può essere switchata
  # @param [Game_BattleAction] action
  def action_switchable(action)
    return true if action.attack?
    if action.skill?
      return action.skill.switchable?
    end
    if action.item?
      return action.item.switchable?
    end
    false
  end

  # crea lo sprite che informa il giocatore della possibilità
  # di cambio tipo bersaglio
  def create_switchable_helper
    @switchable_sprite = Sprite.new(@info_viewport)
    @switchable_sprite.bitmap = switchable_bitmap
    @switchable_sprite.opacity = 0
    @switchable_sprite.x = SETTINGS::SWITCH_HELP_X
    @switchable_sprite.y = SETTINGS::SWITCH_HELP_Y
  end

  private

  # restituisce la bitmap del comando
  # @return [Bitmap]
  def switchable_bitmap
    height = 24
    bitmap = Bitmap.new(SETTINGS::SWITH_HELP_WIDTH, height)
    bitmap.gradient_fill_rect(2, 2, SETTINGS::SWITH_HELP_WIDTH - 4, height - 4, Color::BLACK.clone.deopacize(128), Color::BLACK.clone.deopacize(0))
    bitmap.blur
    bitmap.blur
    bitmap.draw_key_icon(SETTINGS::SWITCH_TARGET_BTN, 0, 0)
    bitmap.font.color = Color::WHITE
    bitmap.font.size = 22
    bitmap.font.bold = false
    bitmap.font.italic = true
    bitmap.font.shadow = false
    bitmap.font.name = 'VL PGothic'
    bitmap.draw_text(26, 0, bitmap.width - 26, height, SETTINGS::SWITCH_HELP)
    bitmap
  end
end

#==============================================================================
# ** Game_BattleAction
#==============================================================================
class Game_BattleAction
  attr_accessor :target_member
  alias h87sw_clear clear unless $@
  alias h87sw_make_attack_targets make_attack_targets unless $@
  alias h87sw_make_obj_targets make_obj_targets unless $@

  # pulizia
  def clear
    h87sw_clear
    @target_member = nil
  end

  # determina il bersaglio da attaccare
  def make_attack_targets
    return h87sw_make_attack_targets unless @target_member
    select_target_member
  end

  # @param [RPG::UsableItem] obj
  def make_obj_targets(obj)
    return h87sw_make_obj_targets(obj) unless @target_member
    select_target_member
  end

  # restituisce il bersaglio selezionato
  # @param [RPG::UsableItem] obj
  def select_target_member(obj = nil)
    unit = @target_member == :enemy ? opponents_unit : friends_unit
    if obj && obj.for_dead_friend? && @target_member == :friend
      [unit.smooth_dead_target(@target_index)]
    else
      [unit.smooth_target(@target_index)]
    end
  end
end