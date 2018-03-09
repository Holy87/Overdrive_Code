#===============================================================================
# ** Window_Typing
#-------------------------------------------------------------------------------
# Questa finestra multiuso serve per inserire un testo da tastiera.
# L'uso è semplice:
# - Si crea la finestra
# - Si impostano i nomi dei metodi per accettazione che vengono chiamati
# - Si prende il testo inserito dal parametro text.
#===============================================================================
class Window_Typing < Window_Selectable
  STANDARD = 1  #Testo normale
  NICKNAME = 2  #Nickname senza spazi e punteggiature
  PROMOCOD = 3  #Inserimento di codici promozionali
  #--------------------------------------------------------------------------
  # Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_accessor :max_char         #numero massimo di caratteri
  attr_accessor :input_scope      #tipo di testo
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, width, title)
    super(x, y, width, WLH*2+32)
    @text = ""
    @max_char = 30
    @title = title
    @rect = Rect.new(4, WLH, 8192, 24)
    self.openness = 0
    @input_scope = STANDARD
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    cw = contents.width
    self.contents.font.color = system_color
    self.contents.draw_text(0,0,cw,WLH,@title)
    self.contents.font.color = normal_color
    self.contents.fill_rect(0, WLH, cw, WLH, Color.new(192, 192, 192))
    self.contents.clear_rect(1,WLH+1,cw-2,WLH-2)
    if @blink
      self.contents.draw_text(@rect, @text + "|", 0)
    else
      self.contents.draw_text(@rect, @text, 0)
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    cls = @closing
    super
    #execute_closing_handler if cls
    return unless open? || self.visible == false
    @blink = !@blink if (Graphics.frame_count % 30 == 0)
    if Input.typing?
      if @text.size < @max_char
        @text += filter_scope(Input.key_type)
      else
        Sound.play_buzzer
      end
    elsif Input.repeat?(Input::BACK) and @text.size > 0
      @text[@text.size - 1] = ""
    end
    @rect.x = @text.size < 52 ? 4 : 4 - (@text.size - 52) * 10
#~     if Input.trigger?(Input::ENTER) && !@press_event.nil?
#~       eval("$scene."+@press_event)
#~     elsif Input.trigger?(Input::ESC) && !@back_event.nil?
#~       eval("$scene."+@back_event)
#~     end
    refresh
  end
  
  def update_openness
    if @opening
      self.openness += 24
      @opening = false if self.openness == 255
    elsif @closing
      self.openness -= 24
      @closing = false if self.openness == 0
    end
  end
  
  def filter_scope(char)
    return char if @input_scope == STANDARD
    return char if char =~ /[a-zA-Z0-9àèéìòù\-_]/ && @input_scope == NICKNAME
    return char.upcase if char =~ /[a-z0-9]/i && @input_scope == PROMOCOD
    return ""
  end
  
  def text
    return @text.strip
  end
  
  def text=(new_text)
    @text = new_text.clone
  end
  
  def execute_closing_handler
    return unless @closing_handler
    return unless self.openness <= 0
    @closing_handler.call(@text)
  end
  #--------------------------------------------------------------------------
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger?(:ENTER)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:ESC)
    return process_pagedown if handle?(:pagedown) && Input.trigger?(:R)
    return process_pageup   if handle?(:pageup)   && Input.trigger?(:L)
  end
  
  def set_closing_handler(method)
    @closing_handler = method
  end
  #--------------------------------------------------------------------------
  # * Imposta l'evento quando si preme invio
  #--------------------------------------------------------------------------
  def set_event_handler(event)
    @press_event = event
  end
  #--------------------------------------------------------------------------
  # * Imposta l'evento quando si preme ESC
  #--------------------------------------------------------------------------
  def set_back_handler(event)
    @back_event = event
  end
end # Window_DebugInput