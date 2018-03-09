require 'rm_vx_data'
require 'espers_status'
#===============================================================================
# ** Scene_Menu
#===============================================================================
class Scene_Menu < Scene_Base
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:skill,     method(:command_personal))
    @command_window.set_handler(:equip,     method(:command_personal))
    @command_window.set_handler(:status,    method(:command_personal))
    @command_window.set_handler(:formation, method(:command_formation))
    @command_window.set_handler(:dominations, method(:command_dominations))
    @command_window.set_handler(:save,      method(:command_save))
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
    @command_window.set_handler(:cursor_move, method(:update_vista))
  end
  #--------------------------------------------------------------------------
  # * Cancella metodi
  #--------------------------------------------------------------------------
  def update_command_selection; end
  def update_actor_selection; end
  #--------------------------------------------------------------------------
  # * [Item] Command
  #--------------------------------------------------------------------------
  def command_item
    SceneManager.call(Scene_Item)
  end
  #--------------------------------------------------------------------------
  # * [Skill], [Equipment] and [Status] Commands
  #--------------------------------------------------------------------------
  def command_personal
    @status_window.select_last
    @status_window.activate
    @status_window.set_handler(:ok,     method(:on_personal_ok))
    @status_window.set_handler(:cancel, method(:on_personal_cancel))
  end
  #--------------------------------------------------------------------------
  # * [Formation] Command
  #--------------------------------------------------------------------------
  def command_formation
    SceneManager.call(Scene_PartyForm)
    #@status_window.select_last
    #@status_window.activate
    #@status_window.set_handler(:ok,     method(:on_formation_ok))
    #@status_window.set_handler(:cancel, method(:on_formation_cancel))
  end
  #--------------------------------------------------------------------------
  # * [Save] Command
  #--------------------------------------------------------------------------
  def command_save
    SceneManager.call(Scene_Save)
  end
  #--------------------------------------------------------------------------
  # * [Dominazioni] Command
  #--------------------------------------------------------------------------
  def command_dominations
    SceneManager.call(Scene_Dominations)
  end
  #--------------------------------------------------------------------------
  # * [Exit Game] Command
  #--------------------------------------------------------------------------
  def command_game_end
    SceneManager.call(Scene_End)
  end
  #--------------------------------------------------------------------------
  # * [OK] Personal Command
  #--------------------------------------------------------------------------
  def on_personal_ok
    $game_party.menu_actor = $game_party.members[@status_window.index]
    case @command_window.current_symbol
      when :skill
        SceneManager.call(Scene_Skill)
      when :equip
        SceneManager.call(Scene_NewEquip)
      when :status
        SceneManager.call(Scene_NewStatus)
      else
        #niente
    end
  end
  #--------------------------------------------------------------------------
  # * [Cancel] Personal Command
  #--------------------------------------------------------------------------
  def on_personal_cancel
    @status_window.unselect
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Formation [OK]
  #--------------------------------------------------------------------------
  def on_formation_ok
    if @status_window.pending_index >= 0
      $game_party.swap_order(@status_window.index,
                             @status_window.pending_index)
      @status_window.pending_index = -1
      @status_window.redraw_item(@status_window.index)
    else
      @status_window.pending_index = @status_window.index
    end
    @status_window.activate
  end
  #--------------------------------------------------------------------------
  # * Formation [Cancel]
  #--------------------------------------------------------------------------
  def on_formation_cancel
    if @status_window.pending_index >= 0
      @status_window.pending_index = -1
      @status_window.activate
    else
      @status_window.unselect
      @command_window.activate
    end
  end
  #--------------------------------------------------------------------------
  # * update vista
  #--------------------------------------------------------------------------
  def update_vista
    hide_all_windows
    case @command_window.current_symbol
      when :dominations
        @esper_window.smooth_move(@command_window.width, 0)
        @esper_window.visible = true
      else
        @status_window.smooth_move(@command_window.width, 0)
    end
  end
  #--------------------------------------------------------------------------
  # * hides all windows
  #--------------------------------------------------------------------------
  def hide_all_windows
    @status_window.smooth_move(Graphics.width, 0)
    @esper_window.smooth_move(Graphics.width, 0)
  end
end

#===============================================================================
# ** Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  alias rgss2_call_menu call_menu unless $@
  #--------------------------------------------------------------------------
  # * call menu
  #--------------------------------------------------------------------------
  def call_menu
    Window_MenuCommand::init_command_position
    rgss2_call_menu
  end
end

#===============================================================================
# ** Window_MenuStatus
#===============================================================================
class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select($game_party.target_actor.index || 0)
  end
end

#===============================================================================
# ** Window_MenuCommand
#===============================================================================
class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Ridefinizione del metodo select per aggiornare la schermata
  #--------------------------------------------------------------------------
  def update_cursor; super; check_cursor_handler; end
  #--------------------------------------------------------------------------
  # * Draw Item redraw
  #--------------------------------------------------------------------------
  def draw_item(index)
    super
    rect = item_rect_for_text(index)
    if @list[index][:ext] == :arrow
      draw_arrow(:right, contents_width - 8, rect.y)
    end
  end
end