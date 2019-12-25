module BattlePopups_Options
  INIT_X = 10
  INIT_Y = 24
  Y_SPACING = 2
  MAX_POPUPS = 5
  POOL_TIME = 40
  POPUP_LIFE = 160
  POPUP_BACKGROUND = 'BarraPopup'
  POPUP_SOUND = ['Cursor2', 60, 150]

end

class Popup_Container
  attr_reader :x
  attr_reader :y

  # @param [Viewport] viewport
  def initialize(viewport)
    @x = BattlePopups_Options::INIT_X
    @y = BattlePopups_Options::INIT_Y
    @viewport = viewport
    @popups = []
    @stack = []
    @stack_timer = 0
    @visible = true
  end

  # @param [String] message
  # @param [Integer] icon_index
  # @param [Tone] tone
  # @param [RPG::SE] sound
  def push(message, icon_index = 0, tone = nil, sound = nil)
    data = Popup_Data.new(message, icon_index, tone, sound)
    #full? ? add_stack(data) : create_popup(data)
    empty? ? create_popup(data) : add_stack(data)
  end

  # @param [Popup_Data] data
  def create_popup(data)
    popup = Graphic_Popup.new(data, 0, self.y, @viewport)
    popup.x = 0 - popup.width
    slide_popups(popup)
    @popups.push(popup)
    data.sound.play
    popup.smooth_move(@x, popup.y)
    @stack_timer = 0
  end

  def delete_first_popup
    @popups.shift.kill
  end

  # @param [Popup_Data] data
  def add_stack(data)
    @stack.push(data)
  end

  def full?
    @popups.size >= BattlePopups_Options::MAX_POPUPS
  end

  def empty?
    @popups.empty?
  end

  def update_popups_disappear
    @popups.each do |popup|
      popup.update
      if popup.dead?
        @popups.delete(popup)
        popup.kill
      end
    end
  end

  def update_stack
    return if @stack.empty?
    #return pop_stack unless full?
    @stack_timer += 1
    return if @stack_timer < BattlePopups_Options::POOL_TIME
    delete_first_popup if full?
    pop_stack
  end

  # @param [Graphic_Popup] new_popup
  def slide_popups(new_popup)
    @popups.each do |popup|
      new_x = BattlePopups_Options::INIT_X
      new_y = popup_y(popup)
      #new_y = new_popup.height + BattlePopups_Options::Y_SPACING + popup.y
      popup.smooth_move(new_x, new_y)
    end
  end

  # @param [Graphic_Popup] popup
  # @param [Graphic_Popup] new_popup
  def popup_y(popup)
    index = @popups.reverse.index(popup)
    return 0 if index.nil?
    BattlePopups_Options::INIT_Y + (popup.height + BattlePopups_Options::Y_SPACING) * (index + 1)
  end

  def pop_stack
    @stack_timer = 0
    # noinspection RubyYardParamTypeMatch
    create_popup(@stack.shift)
  end

  def update
    update_stack
    update_popups_disappear
  end

  def dispose
    @popups.each { |popup| popup.dispose }
  end

  def visible=(value)
    return if @visible == value
    @visible = value
    @popups.each { |popup| popup.visible = value }
  end
end

class Popup_Data
  # @return [String]
  attr_reader :text
  # @return [Integer]
  attr_reader :icon_index
  # @return [Tone]
  attr_reader :tone
  # @return [RPG::SE]
  attr_reader :sound

  def initialize(text, icon_index = 0, tone = nil, sound = nil)
    @text = text
    @icon_index = icon_index
    @tone = tone
    if sound.nil?
      s = BattlePopups_Options::POPUP_SOUND
      # noinspection RubyYardParamTypeMatch
      @sound = RPG::SE.new(s[0], s[1], s[2])
    else
      @sound = sound
    end
  end
end

class Graphic_Popup
  include Smooth_Movements

  attr_reader :foreground_sprite
  attr_reader :background_sprite
  attr_reader :life

  # @param [Popup_Data] data
  # @param [Viewport] viewport
  def initialize(data, x, y, viewport = nil)
    @background_sprite = Sprite.new(viewport)
    @background_sprite.bitmap = Cache.picture(BattlePopups_Options::POPUP_BACKGROUND)
    @background_sprite.x = x
    @background_sprite.y = y
    @foreground_sprite = Sprite.new(viewport)
    @foreground_sprite.bitmap = generate_text(data)
    @foreground_sprite.z = @background_sprite.z + 1
    @foreground_sprite.x = x
    @foreground_sprite.y = y
    @background_sprite.tone = data.tone if data.tone != nil
    @life = BattlePopups_Options::POPUP_LIFE
  end

  # @param [Bitmap] bitmap
  def set_font(bitmap)
    bitmap.font.name = 'VL PGothic'
    bitmap.font.color = Color::WHITESMOKE
    bitmap.font.shadow = true
    bitmap.font.bold = false
    bitmap.font.size = 23
    bitmap.font.italic = false
  end

  # @param [Popup_Data] data
  # @return [Bitmap]
  def generate_text(data)
    width = @background_sprite.width
    height = @background_sprite.height
    bitmap = Bitmap.new(width, height)
    set_font bitmap
    center_y = (@background_sprite.height - 24) / 2
    bitmap.draw_icon(data.icon_index, 5, center_y)
    bitmap.draw_text(29, 0, width - 29, height, data.text)
    bitmap
  end

  def visible=(value)
    @background_sprite.visible = value
    @foreground_sprite.visible = value
  end

  def dispose
    @background_sprite.dispose
    @foreground_sprite.dispose
  end

  def update
    update_smooth_movements
    @life -= 1
    if @life <= 50
      @background_sprite.opacity -= 5
      @foreground_sprite.opacity -= 5
    end
  end

  def dead?
    @life <= 0
  end

  def kill
    @life = 0
    self.visible = false
    dispose
  end

  def x=(value)
    @foreground_sprite.x = value
    @background_sprite.x = value
  end

  def y=(value)
    @background_sprite.y = value
    @foreground_sprite.y = value
  end

  def x
    @background_sprite.x
  end

  def y
    @foreground_sprite.y
  end

  def width
    @foreground_sprite.width
  end

  def height
    @foreground_sprite.height
  end
end

class Scene_Battle < Scene_Base
  alias h87_pop_update_basic update_basic unless $@
  alias h87_pop_dispose_info_viewport dispose_info_viewport unless $@
  alias h87_pop_create_info_viewport create_info_viewport unless $@
  alias h87_pop_process_victory process_victory unless $@
  alias h87_pop_execute_action_skill execute_action_skill unless $@

  def create_info_viewport
    h87_pop_create_info_viewport
    create_popup_viewport
    @popup_container = Popup_Container.new(@popup_viewport)
  end

  def create_popup_viewport
    @popup_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @popup_viewport.z = @info_viewport.z + 1
  end

  def dispose_info_viewport
    h87_pop_dispose_info_viewport
    @popup_container.dispose
    @popup_viewport.dispose
  end

  def update_basic(main = false)
    h87_pop_update_basic(main)
    @popup_container.update
  end

  def push_popup(message, icon_index = 0, tone = nil, sound = nil)
    @popup_container.push(message, icon_index, tone, sound)
  end

  def process_victory
    @popup_container.visible = false
    h87_pop_process_victory
  end

  # @param [Game_Battler] target
  # @param [RPG::State, RPG::Skill] obj
  def display_added_states(target, obj = nil)
    target.added_states.each { |state|
      if target.actor?
        next if state.message1.empty?
        next if state.priority < 1
        text = sprintf(state.message1, target.name)
      else
        next if state.message2.empty?
        next if state.priority < 1
        text = sprintf(state.message2, target.name)
      end
      if state.id == 1 # Incapacitated
        target.perform_collapse
      end
      push_popup(text, state.icon_index)
    }
  end

  # @param [Game_Battler] target
  # @param [RPG::State, RPG::Skill] obj
  def display_removed_states(target, obj = nil)
    target.removed_states.each { |state|
      next if state.message4.empty?
      next if state.priority < 1
      text = sprintf(state.message4, target.name)
      push_popup(text, state.icon_index)
    }
  end


  # @param [Game_Battler] target
  # @param [RPG::State, RPG::Skill] obj
  def display_remained_states(target, obj = nil)
    target.remained_states.each { |state|
      next if state.message3.empty?
      next if state.priority < 1
      text = sprintf(state.message3, target.name)
      icon = obj ? obj.icon_index : 0
      push_popup(text, icon)
    }
  end

  def execute_action_skill
    h87_pop_execute_action_skill
    skill = @active_battler.action.skill
    targets = @active_battler.action.make_targets
    return if targets.nil?
    targets.compact.each { |target|
      display_action_effects(target, skill)
    }
  end

  def display_action_effects(target, obj = nil)
    display_state_changes(target, obj)
  end

  def display_state_changes(target, obj = nil)
    return if target.missed or target.evaded
    return unless target.states_active?
    display_added_states(target, obj)
    display_removed_states(target, obj)
    display_remained_states(target, obj)
  end
end