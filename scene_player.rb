module Player_Settings
  V_OVERVIEW = 'Panoramica'
  V_EDIT = 'Modifica'
  V_CODE = 'Codici segreti'

  H_OVERVIEW = 'In questa schermata sono visualizzati i dettagli|ed i progressi del tuo profilo online.'
  H_EDIT = 'Modifica le informazioni del profilo, come Avatar e Titolo.'
  H_CODE = 'Hai dei codici promozionali che ti sono stati dati?|Inseriscili in questa casella per ricevere premi!'

  C_INSERT = 'Scrivi'
  C_PASTE = 'Incolla'


end

module Vocab
  def self.pi_overview_command; Player_Settings::V_OVERVIEW; end
  def self.pi_edit_command; Player_Settings::V_EDIT; end
  def self.pi_code_command; Player_Settings::V_CODE; end

  def self.pi_overview_help; Player_Settings::H_OVERVIEW; end
  def self.pi_edit_help; Player_Settings::H_EDIT; end
  def self.pi_code_help; Player_Settings::H_CODE; end

  def self.paste_command; Player_Settings::C_PASTE; end
  def self.write_command; Player_Settings::C_INSERT; end
end

class Scene_Player < Scene_MenuBase
  def start
    create_help_window
    create_command_window
    create_player_info_window
    create_edit_window
    create_avatars_window
    create_titles_window
    create_code_command_window
    create_code_insert_window
  end

  def create_player_info_window
    y = @command_window.bottom_corner
    @player_window = Window_PlayerInfo.new(0, y, Graphics.width)
  end

  def create_command_window
    y = @help_window.bottom_corner
    @command_window = Window_PInfoCommand.new(0, y)
    @command_window.activate
    @command_window.index = 0
  end

  def create_edit_window

  end

  def create_avatars_window

  end

  def create_titles_window

  end

  def create_code_command_window

  end

  def create_code_insert_window

  end
end

class Window_PInfoCommand < Window_HorzCommand
  def window_width; Graphics.width - self.x; end
  def window_height; line_height; end
  def make_command_list
    add_command(Vocab::pi_overview_command, :overview)
    add_command(Vocab::pi_edit_command, :edit)
    add_command(Vocab::pi_code_command, :code)
  end
end

class Window_PlayerEdit < Window_Selectable
  def initialize(x, y, width, height)
    super

  end

  def refresh
    contents.clear
    draw_avatar
    draw_title
  end

  def draw_avatar

  end

  def draw_item

  end
end