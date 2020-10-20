#===============================================================================
# Comando Continua di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script aggiunge il comando "Continua" alla schermata del titolo, che
# permette al giocatore di caricare direttamente l'ultimo salvataggio.
#===============================================================================
# ** Istruzioni:
# Copiare lo script sotto Materials e prima del Main.
#===============================================================================
# ** Impostazioni dello script
#===============================================================================
module Title_Settings
  # Comando Continua (carica automaticamente l'ultimo salvataggio)
  CONTINUE_COMMAND_TEXT = 'Continua'
end

$imported = {} if $imported == nil
$imported['H87_Resume_Command'] = 1.0

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
#  Some vocabs...
#===============================================================================
module Vocab
  # Command resume
  def self.continue_game
    Title_Settings::CONTINUE_COMMAND_TEXT
  end
end

#===============================================================================
# ** Window_TitleCommand
#===============================================================================
class Window_TitleCommand < Window_Command
  alias h87_make_command_classic make_command_list unless $@
  alias h87_init_classic_load initialize unless $@

  def initialize
    h87_init_classic_load
    select_symbol(:resume) if continue_enabled
  end

  def make_command_list
    add_command(Vocab.continue_game, :resume) if continue_enabled
    h87_make_command_classic
  end
end

#===============================================================================
# ** Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  alias h87_load_create_command_window create_command_window unless $@
  def create_command_window
    h87_load_create_command_window
    @command_window.set_handler(:resume, method(:command_resume))
  end

  # Command resume (load the last save)
  def command_resume
    close_command_window
    fadeout_all
    DataManager.load_game(DataManager.last_savefile_index)
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
end