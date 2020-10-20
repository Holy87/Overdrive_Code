class Scene_Achievements < Scene_MenuBase
  #noinspection RubyResolve
  def create_background
    if Animated_Titles.animated_title_exist?
      @background_sprite = Animated_Titles.animated_title
      @background_sprite.go_dark
    else
      super
    end
    @plus_sprite = Sprite.new
    @plus_sprite.bitmap = Cache.picture(H87_Achievements::BACKIMAGE)
    @plus_sprite.z = @background_sprite.last_z + 1 if Animated_Titles.animated_title_exist?
  end

  def dispose_background
    @plus_sprite.visible = false
    @plus_sprite.dispose
    if Animated_Titles.animated_title_exist?
      @background_sprite.dispose
    else
      super
    end
  end

  def return_scene
    if Animated_Titles.animated_title_exist?
      @background_sprite.fade_dark
      @background_sprite.prepare_for_pass
    end
    super
  end

  # Aggiornamento dello sfondo
  #noinspection RubyResolve
  def update_background
    @background_sprite.update
  end

  alias anim_update update unless $@
  def update
    anim_update
    update_background
  end
end

class Scene_Title < Scene_Base
  alias animated_command_achievements command_achievements
  def command_achievements
    @background.prepare_for_pass
    animated_command_achievements
    @background.hide_title
  end
end