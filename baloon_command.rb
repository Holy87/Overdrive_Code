require 'rm_vx_data'

class Window_ActorCommand < Window_Command
  alias standard_init initialize unless $@
  alias standard_setup setup unless $@
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    #noinspection RubyArgCount
    super(128, [], 1, 5)
    self.active = false
    #reset_font_settings
  end

  def reset_font_settings
    self.windowskin = Cache.windowskin('Bing')
    self.back_opacity = 128
    contents.font.shadow = false
    contents.font.name = ["VL PGothic","Verdana","Arial", "Courier New"]
    contents.font.italic = false
    contents.font.bold = false
  end
  #--------------------------------------------------------------------------
  # * aggiunta del disegno del volto dell'eroe
  # @param [Game_Actor] actor
  #--------------------------------------------------------------------------
  def setup(actor)
    standard_setup(actor)
    draw_actor_bface(actor)
  end
  #--------------------------------------------------------------------------
  # * disegna il volto dell'eroe
  # @param [Game_Actor] actor
  #--------------------------------------------------------------------------
  def draw_actor_bface(actor)
    bmp = Cache.battle_face(actor.id)
    contents.blt(0,0,bmp,Rect.new(0, 0, bmp.width, bmp.height))
  end
  #--------------------------------------------------------------------------
  # * abbassa il rettangolo di una riga
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super(index)
    rect.y += line_height
    rect
  end
end

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  alias old_start_command start_actor_command_selection unless $@
  alias old_start_skill_selection start_skill_selection unless $@
  alias old_start_target_enemy_selection start_target_enemy_selection unless $@
  alias old_start_item_selection start_item_selection unless $@
  alias old_end_skill_selection end_skill_selection unless $@
  alias old_end_item_selection end_item_selection unless $@
  alias old_end_target_enemy_selection end_target_enemy_selection unless $@
  alias old_end_target_selection end_target_selection unless $@
  alias atb_next_commander next_commander unless $@
  alias atb_back_commander back_commander unless $@
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start_actor_command_selection
    old_start_command
    place_command_window(@commander.index)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start_skill_selection
    old_start_skill_selection
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start_target_enemy_selection
    old_start_target_enemy_selection
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start_item_selection
    old_start_item_selection
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def end_target_enemy_selection
    old_end_target_enemy_selection
    if @actor_command_window.index == 0
      @actor_command_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def end_target_selection(cansel = false)
    old_end_target_selection(cansel)
    if @actor_command_window.index == 0
      @actor_command_window.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def end_skill_selection
    old_end_skill_selection
    @actor_command_window.visible = true
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def end_item_selection
    old_end_item_selection
    @actor_command_window.visible = true
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def place_command_window(index)
    sprite = @spriteset.actor_sprite(index)
    x = sprite.x - @actor_command_window.width / 4
    y = sprite.y - @actor_command_window.height
    @actor_command_window.smooth_move(x, y)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def next_commander
    atb_next_commander
    place_command_window(@commander.index)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def back_commander
    atb_back_commander
    place_command_window(@commander.index)
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