#===============================================================================
# ** Scene_Save
#-------------------------------------------------------------------------------
# Schermata di salvataggio
#===============================================================================
class Scene_Save < Scene_File

  def create_help_window
    super
    @help_window.set_text(Vocab::SaveMessage)
  end

  def create_command_window
    super(true)
    @command_window.set_handler(:save_override, method(:on_savefile_ok))
  end

  # Conferma il salvataggio
  def on_savefile_ok
    if DataManager.save_game(@saves_window.item.slot)
      on_save_success
    else
      Sound.play_buzzer
    end
  end

  # Processing When Save Is Successful
  def on_save_success
    Sound.play_save
    $game_temp.save_slot_creation = false
    return_scene
  end

  def on_slot_selection
    return on_savefile_ok unless @saves_window.item.present?
    super
  end
end