module Player_Settings
  V_OVERVIEW = 'Panoramica'
  V_EDIT = 'Modifica'
  V_CODE = 'Codici segreti'

  H_OVERVIEW = 'In questa schermata sono visualizzati i dettagli|ed i progressi del tuo profilo online.'
  H_EDIT = 'Modifica le informazioni del profilo, come Avatar e Titolo.'
  H_CODE = 'Hai dei codici promozionali che ti sono stati dati?|Inseriscili in questa casella per ricevere premi!'

  C_INSERT = 'Scrivi'
  C_PASTE = 'Incolla'
  C_AVATAR = 'Cambia Avatar'
  C_TITLE = 'Cambia Titolo'


end

module Vocab
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.pi_overview_command; Player_Settings::V_OVERVIEW; end
  def self.pi_edit_command; Player_Settings::V_EDIT; end
  def self.pi_code_command; Player_Settings::V_CODE; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.pi_overview_help; Player_Settings::H_OVERVIEW; end
  def self.pi_edit_help; Player_Settings::H_EDIT; end
  def self.pi_code_help; Player_Settings::H_CODE; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.paste_command; Player_Settings::C_PASTE; end
  def self.write_command; Player_Settings::C_INSERT; end
  def self.avatar_command; Player_Settings::C_AVATAR; end
  def self.p_title_command; Player_Settings::C_TITLE; end
end

class Scene_Player < Scene_MenuBase
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start
    create_help_window
    create_command_window
    create_player_info_window
    create_edit_command_window
    create_avatars_window
    create_titles_window
    create_code_command_window
    create_code_insert_window
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_player_info_window
    y = @command_window.bottom_corner
    @player_window = Window_PlayerInfo.new(0, y, Graphics.width)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_command_window
    y = @help_window.bottom_corner
    @command_window = Window_PInfoCommand.new(0, y)
    @command_window.activate
    @command_window.index = 0
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_edit_command_window
    y = @command_window.y
    x = @command_window.x
    @command_edit_window = Window_PlayerEdit.new(x, y)
    @command_edit_window.openness = 0
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_avatars_window
    y = @command_window.bottom_corner
    h = Graphics.height - y
    @avatar_window = Window_Avatar.new(0, y, Graphics.width, h)
    @avatar_window.visible = false
    @avatar_window.index = player.avatar
    @avatar_window.set_handler(:ok, method(:choose_avatar))
    @avatar_window.set_handler(:cancel, method(:hide_avatar_window))
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_titles_window

  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_code_command_window

  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_code_insert_window

  end
  #--------------------------------------------------------------------------
  # *
  # @return [Online_Player]
  #--------------------------------------------------------------------------
  def player; $game_system.player; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def show_edit_window
    @command_window.close
    @command_edit_window.open
    @command_edit_window.activate
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def hide_edit_window
    @command_edit_window.close
    @command_window.open
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def show_avatar_window
    @player_window.smooth_move(@avatar_window.width, @player_window.y)
    @avatar_window.x = 0 - @avatar_window.width
    @avatar_window.visible = true
    @avatar_window.smooth_move(0, @avatar_window.y)
    @avatar_window.activate
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def hide_avatar_window
    @player_window.smooth_move(0, @player_window.y)
    @avatar_window.smooth_move(0 - @avatar_window.width, @avatar_window.y)
    @avatar_window.deactivate
    @command_edit_window.activate
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def choose_avatar
    player.avatar = @avatar_window.index
    @player_window.refresh
    hide_avatar_window
  end
end

class Window_PInfoCommand < Window_HorzCommand
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def window_width; Graphics.width - self.x; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def window_height; line_height; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::pi_overview_command, :overview)
    add_command(Vocab::pi_edit_command, :edit)
    add_command(Vocab::pi_code_command, :code)
  end
end

class Window_PlayerEdit < Window_HorzCommand
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def window_width; Graphics.width - self.x; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def window_height; line_height; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::avatar_command, :avatar_change)
    add_command(Vocab::p_title_command, :title_change)
  end
end