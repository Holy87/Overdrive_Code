# questo script serve a creare un file di salvataggio "temporaneo" nel caso
# in cui il gioco si chiuda in modo errato ed il giocatore rischia di perdere
# i progressi di gioco. Purtroppo ci sono alcune chiamate ad API che chiudono
# il gioco mentre si scrive da tastiera e non posso controllarne il comportamento.
# Questo script richiede Homepath Saving.
module Vocab
  def self.temp_file_exist
    "Sembra l'ultima volta il gioco non si sia chiuso correttamente.\nÈ presente un salvataggio di emergenza. Vuoi caricarlo?"
  end

  def self.load_temp_save
    "Carica e riprendi dall'ultima posizione registrata"
  end

  def self.delete_temp_save
    "No, caricherò un salvataggio (il salvataggio d'emergenza verrà cancellato)"
  end
end

module DataManager
  TEMP_FILENAME = 'temp_save'

  class << self
    alias temp_make_filename make_filename
  end

  def self.create_temp_save
    save_game(TEMP_FILENAME)
  end

  def self.load_temp_save
    load_game(TEMP_FILENAME)
  end

  def self.temp_file_exist?
    File.exist?(make_temp_filename)
  end

  def self.delete_temp_save
    return unless temp_file_exist?
    delete_save_file(TEMP_FILENAME)
  end

  # @param [String] index
  def self.make_filename(index)
    index.is_a?(String) ? make_temp_filename(index) : temp_make_filename(index)
  end

  # @return [String]
  # @param [String] name
  def self.make_temp_filename(name = TEMP_FILENAME)
    Homesave.saves_path + "/" + name + '.rvdata'
  end
end

class Scene_Map < Scene_Base
  alias h87_temp_save_start start unless $@
  alias h87_temp_save_terminate terminate unless $@

  def start
    h87_temp_save_start
    DataManager.delete_temp_save
  end

  def terminate
    h87_temp_save_terminate
    DataManager.create_temp_save
  end
end

class Scene_Title < Scene_Base
  alias h87_temp_create_command_window create_command_window unless $@
  alias h87_temp_open_command_window select_command unless $@
  alias h87_temp_update update unless $@
  alias h87_temp_terminate terminate unless $@

  def create_command_window
    create_temp_load_window
    h87_temp_create_command_window
  end

  def create_temp_load_window
    @temp_load_window = Window_TempFile.new
    @temp_load_window.set_handler(:load_temp, method(:command_load_temp_save))
    @temp_load_window.set_handler(:delete_temp, method(:command_delete_temp_save))
  end

  def command_load_temp_save
    fadeout_all
    DataManager.load_temp_save
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end

  def command_delete_temp_save
    @temp_load_window.visible = false
    DataManager.delete_temp_save
    h87_temp_open_command_window
  end

  def select_command
    if DataManager.temp_file_exist?
      @temp_load_window.visible = true
    else
      h87_temp_open_command_window
    end
  end

  def update
    h87_temp_update
    @temp_load_window.update if @temp_load_window.visible
  end

  def terminate
    h87_temp_terminate
    @temp_load_window.dispose
  end
end

class Window_TempFile < Window_Command
  def initialize
    super(0, 0)
    center_window
    self.visible = false
  end

  def window_width
    Graphics.width - 60
  end

  def window_height
    fitting_height(4)
  end

  def make_command_list
    add_command(Vocab.load_temp_save, :load_temp)
    add_command(Vocab.delete_temp_save, :delete_temp)
  end

  def item_rect(index)
    rect = super
    rect.y += (line_height * 2)
    rect
  end

  def refresh
    super
    draw_text_ex(0, 0, Vocab.temp_file_exist)
  end
end