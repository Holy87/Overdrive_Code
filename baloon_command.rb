require 'rm_vx_data'

class Window_ActorCommand < Window_Command
  alias standard_init initialize unless $@
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize
    standard_init
    self.windowskin = Cache.windowskin('Bing')
    self.back_opacity = 128
    contents.font.shadow = false
    contents.font.name = ["VL PGothic","Verdana","Arial", "Courier New"]
    contents.font.italic = false
    contents.font.bold = false
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
  def end_target_selection(cansel = true)
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
    @actor_command_window.x = sprite.x - @actor_command_window.width / 4
    @actor_command_window.y = sprite.y - @actor_command_window.height
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