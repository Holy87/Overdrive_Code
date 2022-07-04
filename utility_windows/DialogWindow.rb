#===============================================================================
# ** Window_PopupDialog
#-------------------------------------------------------------------------------
# Finestra di dialogo che mostra un messaggio di popup
#===============================================================================
class Window_PopupDialog < Window_Selectable
  ICON_TYPES = {
    :normal => 0,
    :info => 612,
    :warning => 632,
    :error => 633,
    :success => 634
  }

  attr_accessor :next_window

  # Inizializzazione
  def initialize
    super(0, 0, 0, 0)
    self.openness = 0
    deactivate
  end


  # Imposta il testo della finestra
  # @param [String] text
  def set_text(text, max_width = Graphics.width)
    contents.clear
    return if text.nil?
    @text = text
    @data = []
    self.width = calc_width(max_width)
    self.height = calc_height
    create_contents
    refresh
    center_window
    self.x += SceneManager.scene.dialog_adjust_x
    self.y += SceneManager.scene.dialog_adjust_y
  end

  # @param [Hash] choices
  # @param [Proc] block
  def set_data(choices, block)
    @data = []
    @block = block
    choices.each_pair do |choice, text|
      @data.push({:choice => choice, :text => text})
    end
  end

  def col_max
    return 1 if @data.nil?
    @data.size == 2 ? 2 : 1
  end

  def item_max
    @data ? @data.size : 0
  end

  def draw_item(index)
    change_color normal_color
    rect = item_rect(index)
    draw_text(rect, @data[:text])
  end

  def refresh
    draw_message
    super if selection?
  end

  def selected_choice
    @data[@index][:choice]
  end

  def selection?
    @data != nil and @data.size > 0
  end

  def draw_message
    draw_icon(icon_type, 0, 0)
    draw_text_ex(@type == :normal ? 0 : 24, 0, sprintf("%s",@text))
  end

  def calc_width(max_width)
    width = [text_width(lines.max{|a,b|text_width(a) <=> text_width(b)}) + padding * 2, max_width].min
    width += 24 if @type != :normal
    width
  end

  def icon_type
    ICON_TYPES[@type] || 0
  end

  def calc_height
    fitting_height(line_number + (@data.size == 2 ? 1 : @data.size))
  end

  def line_number
    lines.size
  end

  def call_ok_handler
    close
    super
  end

  def call_cancel_handler
    close
    super
  end

  # @return [Array<String>]
  def lines
    @text.split(/[\r\n]+/)
  end

  # Mostra la finestra di dialogo
  # @param [String] text
  def show(text = nil, type = :normal)
    @type = type
    delete_handlers
    @next_window = nil
    set_text(text) if text
    open
    activate
  end

  def close
    super
    deactivate
    self.pause = false
    @next_window.activate if @next_window != nil
    @next_window = nil
  end

  def item_rect(index)
    rect = super(index)
    rect.y += super.line_number * line_height
    rect
  end

  # Cancella gli handler
  def delete_handlers
    @handler.delete(:ok)
    @handler.delete(:cancel)
  end
end


#===============================================================================
# ** Scene_MenuBase
#-------------------------------------------------------------------------------
# Aggiunta dei metodi che chiamano la finestra
#===============================================================================
class Scene_MenuBase < Scene_Base
  alias h87popdialstart start unless $@

  def start
    h87popdialstart
    create_h87dialog_window
  end

  # Creazione della finestra di dialogo
  def create_h87dialog_window
    @dialog_window = Window_PopupDialog.new
    @dialog_window.deactivate
  end

  def dialog_adjust_x
    0
  end

  def dialog_adjust_y
    0
  end

  # Mostra la finestra di dialogo. Puoi specificare anche la finestra che
  # verrà riattivata quando la finestra di dialogo si chiuderà.
  # @param [String] text
  # @param [Window_Base, Method] window
  def show_dialog(text, window = nil, type = :normal)
    @dialog_window.show(text, type)
    if window.is_a?(Window)
      window.deactivate
      @dialog_window.next_window = window
      @dialog_window.set_handler(:ok, method(:close_dialog_window))
      @dialog_window.set_handler(:cancel, method(:close_dialog_window))
    elsif window != nil
      @dialog_window.set_handler(:ok, window)
      @dialog_window.set_handler(:cancel, window)
    end
    @dialog_window.z = 9999
    @dialog_window.pause = true
  end

  # mostra una finestra di dialogo con scelte
  # @deprecated non implementato
  def show_choice(text, choices = {}, &block)
    fail NotImplementedError
  end

  # Popup con messaggio di attesa
  def show_dialog_waiting(text, instant = false)
    @dialog_window.delete_handlers
    @dialog_window.openness = 255 if instant
    @dialog_window.show(text)
    @dialog_window.z = 9999
  end

  def close_dialog_window
    @dialog_window.close
  end
end