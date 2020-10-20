#===============================================================================
# ** Scene_File
#-------------------------------------------------------------------------------
# Finestra personalizzata di Scene_File che verrà ereditata da Save e Load
#===============================================================================
class Scene_File < Scene_MenuBase
  include SaveConfig

  # inizio
  def start
    super
    create_help_window
    create_detail_window
    create_window_saves
    create_command_window
    create_rename_window
  end

  # Crea la finestra dei dettagli
  def create_detail_window
    y = Graphics.height - 200
    @detail_window = Window_SaveDetails.new(0, y, Graphics.width)
    @detail_window.opacity = menu_opacity
  end

  # Crea la finestra dei salvataggi
  def create_window_saves
    x = 0
    y = @help_window.height
    w = Graphics.width
    h = Graphics.height - y - @detail_window.height
    @saves_window = Window_SaveList.new(x, y, w, h, @saving)
    @saves_window.set_handler(:ok, method(:on_slot_selection))
    @saves_window.set_handler(:cancel, method(:return_scene)) unless $game_temp.save_slot_creation
    @saves_window.set_handler(:function, method(:action_rename_save))
    @saves_window.activate
    @saves_window.detail_window = @detail_window
    @saves_window.opacity = menu_opacity
  end

  # Creazione finestra di domanda
  def create_command_window(saving = false)
    @command_window = Window_SaveConfirm.new(0, 0, saving)
    @command_window.set_handler(:rename, method(:action_rename_save))
    @command_window.set_handler(:cancel, method(:do_nothing))
  end

  # Creazione della finestra di rinomina
  def create_rename_window
    x = Graphics.width / 2 - 200
    y = Graphics.height / 2
    w = 400
    options = {
        :max_characters => 15,
        :permitted => Text_Inputable::ALPHA_WITH_SPACING|Text_Inputable::BASE_SYMBOLS,
        :permit_paste => false,
        :title => Vocab.renaming
    }
    @rename_window = Window_SingleLineInput.new(x, y, options)
    @rename_window.set_handler(:ok, method(:do_rename))
    @rename_window.set_handler(:cancel, method(:do_nothing))
    @rename_window.openness = 0
    @rename_window.back_opacity = 255
  end

  # Impostazione del salvataggio
  def on_slot_selection
    open_command_window
  end

  # Apertura della richiesta di sovrascrittura
  def open_command_window
    @command_window.x = @saves_window.absolute_rect.x
    @command_window.y = @saves_window.absolute_rect.bottom
    @command_window.open
    @command_window.activate
  end

  # Restituisce l'opacità del menu
  def menu_opacity
    255
  end

  def action_rename_save
    @saves_window.deactivate
    @command_window.close
    @rename_window.text = @saves_window.item.name
    x = [@saves_window.absolute_rect.x, Graphics.width - @rename_window.width].min
    @rename_window.x = x
    @rename_window.y = @saves_window.absolute_rect.bottom
    @rename_window.open
    @rename_window.activate
  end

  def do_rename
    @rename_window.close
    @saves_window.activate
    begin
      DataManager.rename_save(@saves_window.item.slot, @rename_window.text)
    rescue => error
      Logger.error(error.message)
      Sound.play_buzzer
    end
    @saves_window.refresh
  end

  def do_nothing
    Sound.play_cancel
    @command_window.close
    @rename_window.close
    @saves_window.activate
  end

  def delete_savefile
    DataManager.delete_save_file(@saves_window.item.slot)
    @saves_window.refresh
    @saves_window.activate
  end

end

#scene_file