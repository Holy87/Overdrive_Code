module Icon_Settings
  GOLD_ICON = 147

  STAT_ICONS = {
      # ID => Icon
      :hp  => 1008,
      :mp  => 1009,
      :atk => 1010,
      :def => 1011,
      :spi => 1012,
      :agi => 1013,
      :cri => 1014,
      :hit => 1015,
      :eva => 1016,
      :odd => 1249,
      :ang => 1250,
      :res => 1251
  }
end

class RPG::System
  def gold_icon
    Icon.gold
  end

  def param_icon(symbol)
    Icon.param(symbol)
  end
end

class Scene_Icons < Scene_MenuBase
  def start
    super
    create_icons_window
  end

  def create_icons_window
    @icons_window = Window_Iconset.new
    @icons_window.set_handler(:cancel, method(:return_scene))
    @icons_window.activate
  end
end

class Window_Iconset < Window_Selectable
  def initialize
    make_item_list
    super(0, 0, Graphics.width, Graphics.height)
    refresh
  end

  def col_max
    8
  end

  def spacing
    4
  end

  def make_item_list
    icons = Cache.system("Iconset")
    icon_number = (icons.height / 24) * (icons.width / 24)
    @data = []
    icon_number.times {|i| @data.push(i)}
  end

  def item_max
    @data ? @data.size : 0
  end

  def draw_item(index)
    rect = item_rect(index)
    draw_icon(index, rect.x, rect.y)
    rect.x += 24
    rect.width -= 28
    draw_text(rect, index)
  end
end

#===============================================================================
# ** Window_TitleCommand
#===============================================================================
class Window_TitleCommand < Window_Command
  alias h87_make_command_iconset make_command_list unless $@

  def make_command_list
    h87_make_command_iconset
    add_command("ICON SELECTION", :icons) if $TEST
  end
end

#===============================================================================
# ** Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  alias h87_icons_create_command_window create_command_window unless $@
  def create_command_window
    h87_icons_create_command_window
    @command_window.set_handler(:icons, method(:command_icons))
  end

  # Command resume (load the last save)
  def command_icons
    close_command_window
    SceneManager.call(Scene_Icons)
  end
end