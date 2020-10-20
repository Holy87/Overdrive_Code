#===============================================================================
# Inserimento Semplice di Holy87
# Difficoltà utente: ★★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script permette ai maker di far inserire del testo al
# giocatore e memorizzarlo all'interno di una VARIABILE DI GIOCO.
#===============================================================================
# ISTRUZIONI: inserire lo script sotto Materials, prima del Main. Richiede
# lo script "Interfaccia Tastiera".
#
# ■ Utilizzo:
# Esegui il comando evento "chiama script" e inserisci questo comando:
# call_text_input(titolo, id_variabile[, max_caratteri[, opzioni]])
# dove titolo è il testo mostrato come titolo della finestra ed id_variabile è
# la variabile dove verrà memorizzato il testo. I parametri max_caratteri e
# opzioni sono facoltativi. Esempio:
# call_text_input("Dai un soprannome a \\N[1]", 15, 20)
# Mostrerà una finestra con titolo "Dai un soprannome a Eric", verrà memorizzato
# nella variabile 15 e potrà avere massimo 20 caratteri. Come opzioni controlla
# la guida nel sistema di input.
#===============================================================================


# --- NON MODIFICARE OLTRE SE NON SAI QUELLO CHE FAI! ---


#===============================================================================
# ** Window_CommonTextInput
#-------------------------------------------------------------------------------
# simple text input window that shows also the title
#===============================================================================
class Window_CommonTextInput < Window_TextInput
  attr_accessor :variable_id

  # @param [Hash] options
  def set_options(options)
    @title = options[:title]
    @variable_id = options[:variable_id]
    initialize_input_parameters(options)
    adjust_width
    adjust_height
    create_contents
    center_window
    refresh
  end

  # input rectangle
  # @return [Rect]
  def text_input_rect
    Rect.new(0, line_height, contents_width, line_height * (@max_lines ? @max_lines : 1))
  end

  def refresh
    contents.clear
    draw_text_ex(0, 0, @title) if @title
    super
  end

  # adjusts width calculating the space required for text input
  def adjust_width
    self.width = [[text_size('O' * @max_characters).width + padding * 2,
    @title ? text_size(@title).width + padding * 2 : 0].max, Graphics.width].min
  end

  # adjust height regarting the number of lines
  def adjust_height
    self.height = fitting_height(1 + @max_lines)
  end

  # centers the window on the screen
  def center_window
    self.x = (Graphics.width - self.width) / 2
    self.y = (Graphics.height - self.height) / 2
    refresh_cursor_position
  end
end

#===============================================================================
# ** Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  alias h87_ti_create_all_windows create_all_windows unless $@
  alias h87_ti_scene_change_ok? scene_change_ok? unless $@
  attr_accessor :text_input_window

  def create_all_windows
    h87_ti_create_all_windows
    create_text_input_window
  end

  # can change scene?
  # @return [TrueClass, FalseClass]
  def scene_change_ok?
    return false if @text_input_window.active?
    h87_ti_scene_change_ok?
  end

  # creates the text input window
  def create_text_input_window
    @text_input_window = Window_CommonTextInput.new(0, 0, 100, 100)
    @text_input_window.openness = 0
  end
end

#===============================================================================
# ** Game_Player
#===============================================================================
class Game_Player < Game_Character
  alias h87_ti_movable? movable? unless $@

  # player movable?
  def movable?
    return false if SceneManager.scene_is?(Scene_Map) and SceneManager.scene.text_input_window.active?
    h87_ti_movable?
  end
end

#===============================================================================
# ** Game_Interpreter
#===============================================================================
class Game_Interpreter
  # calls the text input process
  # calls the text input window
  # @param [String] title
  # @param [Fixnum] variable_id
  # @param [Fixnum] max_char
  # @param [Hash] options
  def call_text_input(title, variable_id, max_char = 20, options = {})
    return unless SceneManager.scene_is?(Scene_Map)
    options[:max_characters] = max_char
    options[:variable_id] = variable_id
    options[:title] = title
    text_input_window.set_options(options)
    text_input_window.set_done_handler(method(:done_typing))
    text_input_window.open
    text_input_window.activate
  end

  # @return [Window_CommonTextInput]
  def text_input_window
    SceneManager.scene.text_input_window
  end

  # end the text input sequence and stores the data in the variable
  def done_typing
    variable_id = text_input_window.variable_id
    $game_variables[variable_id] = text_input_window.text
    text_input_window.close
  end
end