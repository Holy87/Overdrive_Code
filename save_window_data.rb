#===============================================================================
# ** Window_GameStatus
#-------------------------------------------------------------------------------
# mostra i dati sul gioco attuale
#===============================================================================
class Window_GameStatus < Window_Base

  def initialize(x, y, width)
    super(x, y, width, Graphics.height - fitting_height(1))
    refresh
  end

  def refresh
    contents.clear
    change_color system_color
    draw_text(0, 0, contents_width, line_height, $game_system.player.name, 1)
  end
end