# Questo script modifica l'aspetto e la posizione della finestra dei
# comandi di battaglia.

module ActorCommandOptions
  CUSTOM_GRAPHIC_SETTINGS = false
  DRAW_ACTOR_BATTLE_FACE = false
  DRAW_COMMAND_ICONS = true

  POSITION_SW = 612
  POSITION_TEXT = 'Posizione Comandi'
  POSITION_HELP = 'Scegli dove mostrare la finestra dei comandi di|battaglia durante il combattimento.'
  POSITION_ON = 'Eroi'
  POSITION_OFF = 'In basso'
  POSITION_DEFAULT = true

  # Icone per i comandi
  COMMAND_ICONS = {
      :attack => 132,
      :guard => 137,
      :heal => 128,
      :debuff => 130,
      :magic => 133,
      :sing => 134,
      :skill => 119,
      :tech => 131,
      :items => 144,
      :vampire => 136,
      :alchemy => 129
  }

  JOB_SKILL_ICONS = {
      3 => :heal,
      4 => :magic,
      8 => :vampire,
      9 => :debuff,
      11 => :tech,
      12 => :tech,
      13 => :sing,
      17 => :alchemy,
      18 => :magic
  }

  UNHARMED_ICON = :attack
  DEFAULT_GUARD_ICON = :guard
  DEFAULT_SKILL_ICON = :skill
  ITEMS_ICON = :items
end

$imported = {} if $imported == nil
$imported["H87_ActorCommand"] = 1.0

class Window_ActorCommand < Window_Command
  include ActorCommandOptions

  alias standard_init initialize unless $@
  alias standard_setup setup unless $@
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    lines = DRAW_ACTOR_BATTLE_FACE ? 5 : 4
    width = DRAW_COMMAND_ICONS ? 140 : 120
    #noinspection RubyArgCount
    super(width, [], 1, lines)
    self.active = false
    @icons = []
    reset_font_settings if CUSTOM_GRAPHIC_SETTINGS
    if classic_position?
      self.y = Graphics.height - self.height
    end
  end

  def reset_font_settings
    self.windowskin = Cache.windowskin('Bing')
    self.back_opacity = 128
    contents.font.shadow = false
    contents.font.name = ["VL PGothic", "Verdana", "Arial", "Courier New"]
    contents.font.italic = false
    contents.font.bold = false
  end

  # * aggiunta del disegno del volto dell'eroe
  # @param [Game_Actor] actor
  def setup(actor)
    prepare_command_icons(actor) if DRAW_COMMAND_ICONS
    standard_setup(actor)
    draw_actor_bface(actor) if DRAW_ACTOR_BATTLE_FACE
    update_visibility
  end

  # disegna il comando
  # @param [Integer] index
  # @param [Boolean] enabled
  def draw_item(index, enabled = true)
    rect = item_rect(index)
    contents.clear_rect(rect)
    change_color normal_color, enabled

    if DRAW_COMMAND_ICONS
      draw_icon(@icons[index], rect.x, rect.y)
      rect.x += 24
      rect.width -= 24
    end

    draw_text rect, @commands[index]
  end

  # disegna il volto dell'eroe
  # @param [Game_Actor] actor
  def draw_actor_bface(actor)
    bmp = Cache.battle_face(actor.id)
    contents.blt(0, 0, bmp, Rect.new(0, 0, bmp.width, bmp.height))
  end

  # abbassa il rettangolo di una riga
  # se abilitato il BFACE
  # @return [Rect]
  def item_rect(index)
    rect = super(index)
    rect.y += line_height if DRAW_ACTOR_BATTLE_FACE
    rect
  end

  def active=(value)
    super(value)
    update_visibility
  end

  def index=(value)
    super(value)
    update_visibility
  end

  def update_visibility
    self.visible = should_be_visible?
  end

  def should_be_visible?
    return true if classic_position?
    self.active and self.index >= 0
  end

  def classic_position?
    return true if ActorCommandOptions::POSITION_SW == 0
    !$game_switches[ActorCommandOptions::POSITION_SW]
  end

  # genera l'array delle icone
  # @param [Game_Actor] actor
  def prepare_command_icons(actor)
    @icons = []
    @icons.push(attack_icon actor)
    @icons.push(skill_icon actor)
    @icons.push(guard_icon actor)
    @icons.push(items_icon actor)
  end

  # @param [Game_Actor] actor
  def attack_icon(actor)
    return 0 if actor.nil?
    return COMMAND_ICONS[UNHARMED_ICON] if actor.unharmed?
    actor.weapons.first.icon_index
  end

  # determina l'icona della guardia.
  # restituisce l'icona dello scudo o una
  # generica se non ha alcuno scudo
  # @param [Game_Actor] actor
  def guard_icon(actor)
    shields = actor.equips.compact.select { |e| e.shield? }
    shields.any? ? shields.first.icon_index : COMMAND_ICONS[DEFAULT_GUARD_ICON]
  end

  # determina l'icona delle abilità
  # @param [Game_Actor] actor
  def skill_icon(actor)
    if JOB_SKILL_ICONS.keys.include?(actor.class_id)
      COMMAND_ICONS[JOB_SKILL_ICONS[actor.class_id]]
    else
      COMMAND_ICONS[:skill]
    end
  end

  # determina l'icona degli oggetti
  # @param [Game_Actor] actor
  def items_icon(actor)
    COMMAND_ICONS[ITEMS_ICON]
  end
end

class Scene_Battle < Scene_Base

  alias old_start_command start_actor_command_selection unless $@
  alias atb_next_commander next_commander unless $@
  alias atb_back_commander back_commander unless $@
  alias atb_update_info_viewport update_info_viewport unless $@

  # start actor command selection
  def start_actor_command_selection
    old_start_command
    # noinspection RubyResolve --> RGSS2 only
    place_command_window(@commander.index)
  end

  # piazza la finestra dei comandi sulla posizione dell'eroe
  def place_command_window(index)
    return if @actor_command_window.classic_position?
    sprite = @spriteset.actor_sprite(index)
    x = sprite.x - @actor_command_window.width / 4
    y = sprite.y - @actor_command_window.height
    @actor_command_window.smooth_move(x, y)
  end

  def update_info_viewport
    atb_update_info_viewport
    return if @old_window_on == @actor_command_window_on
    @old_window_on = @actor_command_window_on
    return unless @actor_command_window.classic_position?
    @info_viewport.ox = 0
    y = @actor_command_window.y
    if @actor_command_window_on
      x = Graphics.width - @actor_command_window.width
    else
      x = Graphics.width
    end
    @actor_command_window.smooth_move(x, y)
  end

  def move2_info_viewport
    #nothing
  end

  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def next_commander
    atb_next_commander
    place_command_window(@commander.index) if @commander
  end

  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def back_commander
    atb_back_commander
    place_command_window(@commander.index) if @commander
  end
end

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # *
  # @param [Fixnum] index
  # @return [Sprite_Battler]
  #--------------------------------------------------------------------------
  def actor_sprite(index)
    @actor_sprites[index]
  end
end

class RPG::Armor
  def shield?
    @w_types.include? 'scudo'
  end
end

class RPG::Weapon
  def shield?
    false
  end
end

class Game_Actor < Game_Battler
  def unharmed?
    weapons.compact.empty?
  end
end

# impostazioni nello script Overdrive Settings