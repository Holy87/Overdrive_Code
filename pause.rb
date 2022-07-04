
module Settings
  module Pause
    Pause_Name = "Gioco in pausa"
    Pause_Width = 160
    Pause_FX = 'Decision3'
  end
end

module Vocab
  def self.pause
    Settings::Pause::Pause_Name
  end
end

module Sound
  def self.play_pause
    RPG::SE.new(Settings::Pause::Pause_FX).play
  end
end

module Pause_Integration
  def create_pause
    @pause_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @pause_viewport.z = 9999
    @pause_sprite = Sprite.new(@pause_viewport)
    @pause_sprite.bitmap = create_pause_background_bitmap
    @pause_sprite.visible = false
    @pause_sprite.z = 9000
    @pause_window = Window_Pause.new
    @pause_window.viewport = @pause_viewport
    @pause_window.z = @pause_sprite.z + 1
  end

  def update_pause
    if Input.trigger?(:START)
      fade_audio
      show_pause
      Sound.play_pause
      update_pause_input
    end
  end

  def show_pause
    @pause_window.visible = true
    @pause_sprite.visible = true
    Graphics.update
  end

  def hide_pause
    @pause_window.visible = false
    @pause_sprite.visible = false
  end

  def fade_audio
    @bgs_volume = RPG::BGS::last.volume
    @bgm_volume = RPG::BGS::last.volume
    RPG::BGS::last.volume /= 1.5
    RPG::BGM::last.volume /= 1.5
    RPG::BGS::last.play
    RPG::BGM::last.play
  end

  def unfade_audio
    RPG::BGS::last.volume = @bgm_volume
    RPG::BGM::last.volume = @bgm_volume
    RPG::BGS::last.play
    RPG::BGM::last.play
  end

  def update_pause_input
    loop do
      Input.update
      if Input.trigger?(:START)
        Sound.play_pause
        unfade_audio
        hide_pause
        break
      end
    end
  end

  def dispose_pause
    @pause_sprite.dispose
    @pause_viewport.dispose
  end

  # @return [Bitmap]
  def create_pause_background_bitmap
    bitmap = Bitmap.new(Graphics.width, Graphics.height)
    bitmap.fill_rect(0, 0, bitmap.width, bitmap.height, Color::BLACK.deopacize)
    bitmap
  end
end

class Window_Pause < Window_Base
  def initialize
    super(0, 0, Settings::Pause::Pause_Width, fitting_height(1))
    center_window
    self.visible = false
    refresh
  end

  def refresh
    contents.clear
    draw_text(0, 0, contents_width, contents_height, Vocab.pause, 1)
  end
end

class Scene_Battle < Scene_Base
  include Pause_Integration

  alias :pause_initialize :start
  alias :pause_update :update_basic
  alias :pause_terminate :terminate
  def start
    pause_initialize
    create_pause
  end

  def update_basic(main = false)
    pause_update(main)
    update_pause
  end

  def terminate
    pause_terminate
    dispose_pause
  end
end

class Scene_Map < Scene_Base
  include Pause_Integration

  alias :pause_initialize :start
  alias :pause_update :update
  alias :pause_terminate :terminate
  def start
    pause_initialize
    create_pause
  end

  def update
    pause_update
    update_pause
  end

  def terminate
    pause_terminate
    dispose_pause
  end
end