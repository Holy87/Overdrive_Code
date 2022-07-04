module SkillSettings
  SKILL_ICON_ANIMATION = 527
  CHARACTER_APPEAR_ANIMATION = 528
  CHARACTER_LEARN_ANIMATION = 529
  CHARACTER_UPGRADE_ANIMATION = 533
  FRAME_WAIT = 10 # numero di frame da attendere per cmabiare sprite
  SPRITE_CHAR_INDEX = 1
  SPRITE_INDEX = 0
  DISTANCE = 3
  CHARACTER_TERRAIN = 'terreno_personaggio'
  ARROW_IMAGE = 'arrow_next_single'
  ARROW_DISTANCE = -5
  ARROW_FLASH_TIMING = 10
  AP_POWER_BALOON = 'fumetto-potenziamento'
end

class Scene_NewSkill < Scene_MenuBase
  def create_animated_items
    create_req_level_sprite
    create_ap_cost_sprite
    create_animated_sprites
    create_arrow_sprites
    create_upgraded_skill_icon_sprite
  end

  def animate_skill_learn
    rect = @learns_window.get_absolute_rect
    @skill_icon_sprite.x = rect.x
    @skill_icon_sprite.y = rect.y
    @character_sprite.x = Graphics.width / 2
    @character_sprite.y = Graphics.height / 2
    adjust_terrain_under_character
    @character_sprite.show
    @terrain_sprite.visible = true
    @skill_icon_sprite.show(@learns_window.item.icon_index)
  end

  def update
    super
    @character_sprite.update
    @skill_icon_sprite.update
    @arrow_sprites.update
    @upgraded_skill_icon.update
    #@next_arrow_sprite.update
    update_req_level
    update_ap_cost_sprite
    @animation_viewport.update
  end

  def update_req_level
    return unless @learns_window.active
    @req_level_sprite.update
    return if @learns_window.index == @last_index
    @last_index = @learns_window.index
      if actor.level >= @learns_window.item.required_level
      return @req_level_sprite.visible = false
    end
    rect = @learns_window.get_absolute_rect
    @req_level_sprite.x = rect.x
    @req_level_sprite.y = rect.y - 24
    @req_level_sprite.show(@learns_window.item.required_level)
  end

  def update_ap_cost_sprite
    return unless @skills_window.active or @passives_window.active
    @ap_cost_sprite.update
    window = active_window
    return if window.index == @last_index
    @last_index = window.index
    unless actor.can_level_up_skill?(window.item)
      return @ap_cost_sprite.visible = false
    end
    rect = window.get_absolute_rect
    @ap_cost_sprite.x = rect.x + 100
    @ap_cost_sprite.y = rect.y
    @ap_cost_sprite.show(window.item.ap_cost)
  end

  def terminate
    super
    @skill_icon_sprite.dispose
    @character_sprite.dispose
    @terrain_sprite.dispose
    @req_level_sprite.dispose
    @animation_viewport.dispose
    @hidden_viewport.dispose
    @arrow_sprites.dispose
    @ap_cost_sprite.dispose
    @upgraded_skill_icon.dispose
  end

  def close_animation_learn
    @skill_icon_sprite.hide
    @character_sprite.hide
    @terrain_sprite.visible = false
  end

  def create_req_level_sprite
    @req_level_sprite = Level_Require_Sprite.new(@hidden_viewport)
    @req_level_sprite.z = @skills_window.z + 10
    @req_level_sprite.visible = false
  end

  def create_ap_cost_sprite
    @ap_cost_sprite = Skill_PowerableSprite.new(@hidden_viewport)
    @ap_cost_sprite.z = @skills_window.z + 10
    @ap_cost_sprite.visible = false
  end

  def create_animated_sprites
    @terrain_sprite = Sprite.new(@animation_viewport)
    @terrain_sprite.bitmap = Cache.picture(SkillSettings::CHARACTER_TERRAIN)
    @terrain_sprite.visible = false
    @character_sprite = Skill_Actor_Sprite.new(actor, @animation_viewport)
    @skill_icon_sprite = SkillIconSprite.new(@character_sprite, @animation_viewport)
    @character_sprite.z = 1000
    @skill_icon_sprite.z = 1001
  end

  def create_arrow_sprite
    @next_arrow_sprite = Sprite.new
    @next_arrow_sprite.bitmap = Cache.picture(SkillSettings::ARROW_IMAGE)
    @next_arrow_sprite.viewport = @animation_viewport
    @next_arrow_sprite.z = 10002
    @next_arrow_sprite.ox = @next_arrow_sprite.width / 2
    @next_arrow_sprite.oy = @next_arrow_sprite.height / 2
    @next_arrow_sprite.opacity = 0
    @next_arrow_sprite.x = Graphics.width / 2
    @next_arrow_sprite.y = Graphics.height / 2
  end

  def create_arrow_sprites
    x = @compare1_window.width - @compare1_window.padding
    y = Graphics.height / 2
    width = Graphics.width -
      @compare1_window.width -
      @compare2_window.width +
      @compare1_window.padding +
      @compare2_window.padding
    @arrow_sprites = Arrow_SpriteContainer.new(x, y, width, @animation_viewport)
  end

  def create_upgraded_skill_icon_sprite
    @upgraded_skill_icon = Sprite_Base.new
    @upgraded_skill_icon.bitmap = Bitmap.new(24, 24)
    @upgraded_skill_icon.viewport = @animation_viewport
    @upgraded_skill_icon.z = 1002
    @upgraded_skill_icon.visible = false
    @upgraded_skill_icon.ox = 12
    @upgraded_skill_icon.oy = 12
    @upgraded_skill_icon.zoom_x = 2
    @upgraded_skill_icon.zoom_y = 2
    @upgraded_skill_icon.x = Graphics.width / 2
    @upgraded_skill_icon.y = Graphics.height / 2
  end

  def adjust_terrain_under_character
    @terrain_sprite.x = @character_sprite.x - (@terrain_sprite.width + @character_sprite.width) / 2
    @terrain_sprite.y = @character_sprite.y + @character_sprite.height - @terrain_sprite.height / 2
    @terrain_sprite.z = @character_sprite.z - 10
  end

  def animate_learning
    @skill_icon_sprite.move_to_actor(method(:trigger_actor_moved))
  end

  def trigger_actor_moved
    animation = $data_animations[SkillSettings::CHARACTER_LEARN_ANIMATION]
    @skill_icon_sprite.hide
    @character_sprite.start_animation(animation)
    learn_action
    text = sprintf(SkillSettings::VOCAB_ACTOR_LEARNT, actor.name, @learns_window.item.name)
    show_dialog(text, method(:command_learning))
  end

  def trigger_skill_upgrade
    @upgraded_skill_icon.bitmap.clear
    @upgraded_skill_icon.bitmap.draw_icon(@compare2_window.item.icon_index, 0, 0)
    @upgraded_skill_icon.visible = true
    @compare1_window.visible = false
    animation = $data_animations[SkillSettings::CHARACTER_UPGRADE_ANIMATION]
    @upgraded_skill_icon.start_animation(animation)

    #noinspection RubyMismatchedParameterType
    actor.try_level_skill(@compare1_window.item)
    text = sprintf(SkillSettings::VOCAB_ACTOR_LEARNT, actor.name, @compare2_window.item.name)
    show_dialog(text, method(:command_upgrade_end))
  end
end

class SkillIconSprite < Sprite_Base
  # @param [Skill_Actor_Sprite] actor_sprite
  # @param [Viewport, nil] viewport
  def initialize(actor_sprite, viewport = nil)
    super(viewport)
    self.spark_direction = Spark_Engine::UP
    self.visible = false
    self.bitmap = Bitmap.new(24,24)
    self.spark_spawn_ray = 12
    self.spark_density = 20
    @actor_sprite = actor_sprite
    @step = :none
  end

  def update
    super
    #update_animation_trigger
  end

  def show(icon_index)
    self.visible = true
    self.bitmap.clear
    self.bitmap.draw_icon(icon_index, 0, 0)
    self.spark_bitmap = create_spark_bitmap
    self.spark_active = true
    set_coordinates
    move_to_next
  end

  # @return [Skill_Actor_Sprite]
  def actor_sprite
    @actor_sprite
  end

  def hide
    self.visible = false
    start_animation(nil)
    stop_sparks
    stop_move
  end

  def set_coordinates
    @coordinate = 0
    @coordinates = [
      coordinate(actor_sprite.x - a_distance - self.width, actor_sprite.y),
      coordinate(actor_sprite.x, actor_sprite.y + a_distance),
      coordinate(actor_sprite.x + a_distance + actor_sprite.width, actor_sprite.y),
      coordinate(actor_sprite.x, actor_sprite.y - a_distance)
    ]
  end

  def move_to_actor(method)
    move_to(@actor_sprite.x, :same, 1, 1, method)
  end

  def move_to_next
    coordinate = @coordinates[@coordinate]
    _x = coordinate[:x]
    _y = coordinate[:y]
    @coordinate += 1
    @coordinate = 0 if @coordinate >= @coordinates.size
    self.z = actor_sprite.z + (_y - actor_sprite.y)
    #move_to(_x, _y, 4, 3)
    smooth_move(_x, _y, 2)
  end



  private

  def a_distance
    SkillSettings::DISTANCE
  end

  def coordinate(x, y)
    {:x => x, :y => y}
  end

  def update_animation_trigger
    return unless self.visible
    return if Graphics.frame_count % 120 > 0
    start_animation($data_animations[SkillSettings::SKILL_ICON_ANIMATION])
  end

  # @return [Color]
  def sample_color
    color = self.bitmap.get_pixel(12,12)
    if color.alpha == 0
      color = self.bitmap.get_pixel(8, 12)
    end
    color
  end

  # @return [Bitmap]
  def create_spark_bitmap
    bitmap = Bitmap.new(1,2)
    bitmap.set_pixel(0, 0, sample_color)
    bitmap.set_pixel(0, 1, sample_color.deopacize)
    bitmap
  end
end

class Skill_Actor_Sprite < Sprite_Base
  def initialize(actor, viewport = nil)
    super(viewport)
    @sprite_bitmaps = []
    @sprites_sequence = [0,1,2,1]
    @sequence = 0
    set_actor(actor)
    self.visible = false
  end

  def set_actor(actor)
    @actor = actor
    create_sprites
    @sequence = 0
  end

  def show
    self.visible = true
    start_animation($data_animations[SkillSettings::CHARACTER_APPEAR_ANIMATION])
  end

  # @return [Game_Actor]
  def actor
    @actor
  end

  def hide
    self.visible = false
    start_animation(nil)
  end

  def update
    super
    update_sprite
  end

  def update_sprite
    return unless visible
    if Graphics.frame_count % SkillSettings::FRAME_WAIT == 0
      @sequence += 1
      @sequence = 0 if @sequence >= @sprites_sequence.size
      self.bitmap = @sprite_bitmaps[@sprites_sequence[@sequence]]
    end
  end

  def create_sprites
    @sprite_bitmaps.each { |bitmap| bitmap.dispose }
    @sprite_bitmaps.clear
    image_name = sprintf('%s_%d', actor.character_name, SkillSettings::SPRITE_CHAR_INDEX)
    char = Cache.character(image_name)
    char_w = char.width / 3
    char_h = char.height / 4
    _y = SkillSettings::SPRITE_INDEX * (char_h)
    3.times do |index|
      bitmap = Bitmap.new(char_w, char_h)
      rect = Rect.new(index * char_w, _y, char_w, char_h)
      bitmap.blt(0, 0, char, rect)
      @sprite_bitmaps.push(bitmap)
    end
    self.bitmap = @sprite_bitmaps[0]
  end
end

class Arrow_SpriteContainer
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Viewport] viewport
  def initialize(x, y, width, viewport)
    sprite_width = Cache.picture(SkillSettings::ARROW_IMAGE).width + SkillSettings::ARROW_DISTANCE
    arrow_no = width / sprite_width
    @viewport = viewport
    @sprites = []
    @visible = false
    @time_counter = 0
    arrow_no.times do |pos|
      x_sprite = x + (sprite_width * pos)
      @sprites.push(create_sprite(x_sprite, y))
    end
  end

  def create_sprite(x, y)
    sprite = Sprite.new
    sprite.bitmap = Cache.picture(SkillSettings::ARROW_IMAGE)
    sprite.viewport = @viewport
    sprite.x = x
    sprite.y = y
    sprite.visible = false
    sprite
  end

  def update
    return unless @visible
    if Graphics.frame_count % 3 == 0
      @sprites[@time_counter].visible = true
      @sprites[@time_counter].flash(Color::WHITE.deopacize, SkillSettings::ARROW_FLASH_TIMING)
      @time_counter += 1
      @time_counter = 0 if @time_counter >= @sprites.size
    end
    @sprites.each { |sprite| sprite.update }
  end

  def dispose
    @sprites.each { |sprite| sprite.dispose }
  end

  # @param [Boolean] value
  def visible=(value)
    return if @visible == value
    @visible = value
    if @visible
      @time_counter = 0
    else
      @sprites.each do |sprite|
        sprite.visible = false
        sprite.flash(Color.new(0,0,0,0),0)
      end
    end
  end

  def height
    @sprites[0].height
  end
end