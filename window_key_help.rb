#===============================================================================
# ** Window_KeyHelp
#-------------------------------------------------------------------------------
# Finestra generica che mostra i comandi del menu. Viene chiamata dalle
# schermate Status, Skills, Equip ecc...
#===============================================================================
class Window_KeyHelp < Window_Base
  attr_accessor :columns
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # columns: numero di colonne
  # y: coordinata y (in fondo allo schermo se non usato)
  #--------------------------------------------------------------------------
  def initialize(columns = 2, x = 0, y = Graphics.height - fitting_height(1), width = Graphics.width)
    super(x, y, width, fitting_height(1))
    @commands = []
    @columns = columns
    @controller_connected = Input.controller_connected?
  end
  #--------------------------------------------------------------------------
  # * restituisce il rettangolo del comando
  # @param [Rect] index
  #--------------------------------------------------------------------------
  def command_rect(index = 0)
    r_width = contents_width / columns
    r_height = contents_height
    x = r_width * index
    y = 0
    Rect.new(x, y, r_width, r_height)
  end
  #--------------------------------------------------------------------------
  # * aggiunge il metodo per controllare la connessione del controller
  #--------------------------------------------------------------------------
  def update
    super
    refresh if controller_changed?
  end

  # aggiorna tutti i comandi
  def refresh
    @commands.each_with_index {|command, index| set_command(index, command, true)}
  end
  #--------------------------------------------------------------------------
  # * determina se un controller è stato connesso o disconnesso
  #--------------------------------------------------------------------------
  def controller_changed?
    if @controller_connected != Input.controller_connected?
      @controller_connected = Input.controller_connected?
      Logger.info 'Controller changed'
      true
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce il numero di colonne
  #--------------------------------------------------------------------------
  def columns; @columns; end
  #--------------------------------------------------------------------------
  # * imposta il comando su una colonna
  # @param [Integer] index
  # @param [Key_Command_Container] new_command
  # @param [Boolean] force
  #--------------------------------------------------------------------------
  def set_command(index, new_command, force = false)
    return if @commands[index] == new_command and !force
    @commands[index] = new_command
    rect = command_rect(index)
    self.contents.clear_rect(rect)
    new_command.keys.each_with_index {|key, i|
      draw_key_icon(key, rect.x + ICON_WIDTH * i, rect.y, new_command.enabled?)
    }
    rect.x += ICON_WIDTH * new_command.keys.size
    rect.width -= (ICON_WIDTH * new_command.keys.size)
    change_color(normal_color, new_command.enabled?)
    draw_text(rect, new_command.text)
  end
  #--------------------------------------------------------------------------
  # * imposta il comando su una colonna passando i parametri
  # @param [Integer] index
  # @param [Array] keys
  # @param [String] text
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def execute_set_command(index, keys, text, enabled = true)
    new_command = Key_Command_Container.new(keys, text, enabled)
    set_command(index, new_command)
  end
  #--------------------------------------------------------------------------
  # * cambia l'abilitazione del comando
  #--------------------------------------------------------------------------
  def change_enable(index, enabled)
    return if @commands[index].enabled == enabled
    @commands[index].enabled = enabled
    set_command(index, @commands[index], true)
  end
  #--------------------------------------------------------------------------
  # * reimposta il testo del comando
  #--------------------------------------------------------------------------
  def set_text(index, text)
    return if @commands[index].text == text
    @commands[index].text = text
    set_command(index, @commands[text])
  end
end

#===============================================================================
# ** Key_Command_Container
#-------------------------------------------------------------------------------
# Contiene i dati del comando
#===============================================================================
class Key_Command_Container
  include Comparable
  attr_accessor :keys
  attr_accessor :text
  attr_accessor :enabled
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Array, Symbol] keys
  # @param [String] text
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def initialize(keys, text, enabled = true)
    @keys = keys.is_a?(Array) ? keys : [keys]
    @text = text
    @enabled = enabled
  end

  def enabled?
    @enabled
  end
  #--------------------------------------------------------------------------
  # * confronto
  # @param [Key_Command_Container] other
  #--------------------------------------------------------------------------
  def <=>(other)
    @keys == other.keys and @text == other.text and @enabled == other.enabled ? 0 : 1
  end
end