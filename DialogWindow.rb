require File.expand_path('rm_vx_data')

#===============================================================================
# ** Window_PopupDialog
#-------------------------------------------------------------------------------
# Finestra di dialogo che mostra un messaggio di popup
#===============================================================================
class Window_PopupDialog < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    super(0,0,0,0)
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Non ricordo a cosa serviva...
  #--------------------------------------------------------------------------
  def max_by #ruby 1.8 non ha il metodo max_by degli enumerable
  end
  #--------------------------------------------------------------------------
  # * Imposta il testo della finestra
  # @param [String] text
  #--------------------------------------------------------------------------
  def set_text(text)
    contents.clear
    return if text.nil?
    lines = text.split(/[\r\n]+/)
    self.width = text_size(lines.max).width + self.padding*2
    self.height = lines.size * line_height + self.padding*2
    create_contents
    draw_text_ex(0,0,text)
    center_window
  end
  #--------------------------------------------------------------------------
  # * Mostra la finestra di dialogo
  # @param [String] text
  #--------------------------------------------------------------------------
  def show(text = nil)
    set_text(text) if text
    open
    activate
  end
  #--------------------------------------------------------------------------
  # * Centra la finestra
  #--------------------------------------------------------------------------
  def center_window
    self.x = (Graphics.width - self.width)/2
    self.y = (Graphics.height - self.height)/2
  end
  #--------------------------------------------------------------------------
  # * Cancella gli handler
  #--------------------------------------------------------------------------
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
  #--------------------------------------------------------------------------
  # * Creazione della finestra di dialogo
  #--------------------------------------------------------------------------
  def create_h87dialog_window
    @dialog_window = Window_PopupDialog.new
  end
  #--------------------------------------------------------------------------
  # * Mostra la finestra di dialogo. Puoi specificare anche la finestra che
  #   verrà riattivata quando la finestra di dialogo si chiuderà.
  # @param [String] text
  # @param [Window_Base] window
  #--------------------------------------------------------------------------
  def show_dialog(text, window = nil)
    if window.is_a?(Window)
      @reactivating_window = window
    elsif window != nil
      @reactivating_method = window
    end
    @dialog_window.set_handler(:ok, method(:close_dialog))
    @dialog_window.set_handler(:cancel, method(:close_dialog))
    @dialog_window.show(text)
    @dialog_window.z = 9999
  end
  #--------------------------------------------------------------------------
  # * Popup con messaggio di attesa
  #--------------------------------------------------------------------------
  def show_dialog_waiting(text, instant = false)
    @dialog_window.delete_handlers
    @dialog_window.openness = 255 if instant
    @dialog_window.show(text)
    @dialog_window.z = 9999
  end
  #--------------------------------------------------------------------------
  # * Chiusura della finestra di dialogo
  #--------------------------------------------------------------------------
  def close_dialog
    @dialog_window.close
    @reactivating_window.activate if @reactivating_window
    @reactivating_method.call if @reactivating_method
  end
end