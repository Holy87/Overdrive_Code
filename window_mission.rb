require 'rm_vx_data' if false

module Vocab
  def self.to_do; "Missione"; end
end

class Window_Mission < Window_Base
  def initialize(x, y)
    super(x, y, fitting_height(2), Graphics.width)
    create_flowing_sprite
    refresh
  end

  def create_flowing_sprite
    @flowing_sprite = Sprite.new(self.viewport)

  end

  def refresh
    contents.clear
    change_color(system_color)
    draw_text(0, 0, contents_width, line_height, Vocab.to_do)

  end
end

class Game_Party < Game_Unit
  # @return [String]
  def actual_mission

  end
end