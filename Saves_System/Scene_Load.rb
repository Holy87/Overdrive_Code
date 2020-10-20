#===============================================================================
# ** Scene_Load
#-------------------------------------------------------------------------------
# Schermata di caricamento
#===============================================================================
class Scene_Load < Scene_File

  #noinspection RubyResolve
  def create_background
    if Animated_Titles.animated_title_exist?
      @background_sprite = Animated_Titles.animated_title
      @background_sprite.go_dark
    else
      super
    end
  end

  def dispose_background
    if Animated_Titles.animated_title_exist?
      @background_sprite.dispose
    else
      super
    end
  end

  def update
    super
    update_background
  end

  def create_command_window
    super(false)
    @command_window.set_handler(:do_load, method(:on_loadfile_ok))
  end

  def create_help_window
    super
    @help_window.opacity = menu_opacity
    @help_window.set_text(Vocab::LoadMessage)
  end

  def return_scene
    if Animated_Titles.animated_title_exist?
      @background_sprite.fade_dark
      @background_sprite.prepare_for_pass
    end
    super
  end

  def menu_opacity
    0
  end

  # Aggiornamento dello sfondo
  #noinspection RubyResolve
  def update_background
    @background_sprite.update
  end

  # Conferma il caricamento
  def on_loadfile_ok
    if DataManager.load_game(@saves_window.item.slot)
      on_load_success
    else
      Sound.play_buzzer
    end
  end

  # Esegue quando il caricamento è riuscito
  def on_load_success
    Sound.play_load
    if $game_system.is_legacy_save && !$game_system.new_chapter_introduction && !$game_system.user_registered?
      $game_system.on_after_load
      SceneManager.goto(Scene_Registration)
    else
      fadeout_all
      $game_system.on_after_load
      SceneManager.goto(Scene_Map)
    end
  end
end