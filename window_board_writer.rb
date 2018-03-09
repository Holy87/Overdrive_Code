require File.expand_path('rm_vx_data')

#===============================================================================
# ** Window_BoardWriter
#-------------------------------------------------------------------------------
# Finestra per scrivere il messaggio
#===============================================================================
class Window_BoardWriter < Window_Base
  attr_accessor :max_char       #massimi caratteri
  attr_accessor :emoji_window   #finestra delle emoji
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, Graphics.width,fitting_height(4))
    self.visible = false
    @emoji_window = nil
    @text = ''
    @max_char = 50
    @boxw = contents_width - 104
    @boxh = line_height * 4
    @boxx = 100
    @boxy = 0
    @caret = Text_Caret.new
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if $game_system.player.nil?
    draw_avatar($game_system.player.avatar,0,0)
    #draw_text(0,0,96,line_height,$game_system.player.name)
    refresh_text
  end
  #--------------------------------------------------------------------------
  # * Colore di sfondo
  # @return [Color]
  #--------------------------------------------------------------------------
  def sc1; c = gauge_back_color; c.alpha = 75; c; end
  #--------------------------------------------------------------------------
  # * aggiorna il testo
  #--------------------------------------------------------------------------
  def refresh_text
    pos = {:x => 0, :y => 0}
    contents.clear_rect(@boxx,@boxy,@boxw,@boxh)
    contents.fill_rect(@boxx,@boxy,@boxw,@boxh, sc1)
    #ch = @blink && active ? '|' : ' '
    #cl = Tag_Rules.new(normal_color)
    #cl.add(/\[@(.+)\]/, crisis_color)
    #cl.add(/#(.+)/, power_up_color, '#')
    cl = Color_Rule.new(/\[/, /\]/, crisis_color)
    begin
      pos = contents.draw_formatted_text(@boxx+1, @boxy+1, @boxw-2, @text, 4, cl)
      @caret.x = pos[:x]
      @caret.y = pos[:y]
      @caret.character_number = @text.size
    rescue Exception
      Sound.play_buzzer
      @text = @text[0, @text.size-2]
    end
    draw_remaning_characters
  end
  #--------------------------------------------------------------------------
  # * Disegna il numero di caratteri restanti
  #--------------------------------------------------------------------------
  def draw_remaning_characters
    old_size = contents.font.size
    contents.font.size = 12
    draw_text(0,contents.height - 12, contents.width-10, 12, rem, 2)
    contents.font.size = old_size
  end
  #--------------------------------------------------------------------------
  # * Il numero di caratteri restanti
  #--------------------------------------------------------------------------
  def rem
    rem = @max_char - (@text.size + contents.emojis)
    [rem, 0].max
  end
  #--------------------------------------------------------------------------
  # * Assegna un nuovo testo
  #--------------------------------------------------------------------------
  def text=(value)
    @text = value
    refresh_text
  end
  #--------------------------------------------------------------------------
  # * Restituisce il testo
  #--------------------------------------------------------------------------
  def text; @text.strip; end
  #--------------------------------------------------------------------------
  # * Restituisce se è possibile scrivere nella finestra
  #--------------------------------------------------------------------------
  def writable?
    open? && self.visible && self.active && self.x == 0 && emoji_window_closed?
  end
  #--------------------------------------------------------------------------
  # * True se la finestra emoji è chiusa
  #--------------------------------------------------------------------------
  def emoji_window_closed?
    @emoji_window != nil && @emoji_window.openness == 0
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    if writable?
      update_typing
      update_cursor
      update_input
    end
  end
  #--------------------------------------------------------------------------
  # * aggiorna la scrittura
  #--------------------------------------------------------------------------
  def update_typing
    if Input.typing?
      if rem > 0#@text.size + contents.emojis*5 < @max_char
        @text += Input.key_type
      else
        Sound.play_buzzer
      end
    elsif Input.repeat?(Input::BACK) and @text.size > 0
      if @text =~/\[@([^\[\]]+)\]$/
        @text.gsub(/\[@([^\[\]]+)\]$/, '')
      else
        @text[@text.size - 1] = ''
      end
    end
    refresh_text
  end
  #--------------------------------------------------------------------------
  # * aggiorna il cursore
  #--------------------------------------------------------------------------
  def update_cursor
    #@caret.update
    #if Graphics.frame_count % 30 == 0
    #  @blink = !@blink
    #  refresh_text
    #end
  end
  #--------------------------------------------------------------------------
  # * aggiorna l'input
  #--------------------------------------------------------------------------
  def update_input
    #@text+= "\n" if Input.trigger?(:ENTER)
    send_message if Input.trigger?(Input::ENTER)
    back if Input.trigger?(Input::ESC)
    open_emoji if Input.trigger?(Input::F5)
    Input.update
  end
  #--------------------------------------------------------------------------
  # * invia il messaggio
  #--------------------------------------------------------------------------
  def send_message
    return if @text.empty? || @text.nil?
    close_right
    deactivate
    @send_method.call
  end
  #--------------------------------------------------------------------------
  # * Comando per annullare il messaggio
  #--------------------------------------------------------------------------
  def back
    close_left
    deactivate
    @text =''
    @back_method.call
  end
  #--------------------------------------------------------------------------
  # * Comando per aprire le emoji
  #--------------------------------------------------------------------------
  def open_emoji
    deactivate
    @emoji_method.call
  end
  #--------------------------------------------------------------------------
  # * Chiude la finestra a sinistra
  #--------------------------------------------------------------------------
  def close_left; smooth_move(0 - self.width, self.y); end
  #--------------------------------------------------------------------------
  # * Chiude la finestra a destra
  #--------------------------------------------------------------------------
  def close_right; smooth_move(Graphics.width, self.y); end
  #--------------------------------------------------------------------------
  # * Imposta gli eventi
  #--------------------------------------------------------------------------
  def set_handlers(method_back, method_ok, method_emoji)
    @send_method = method_ok
    @back_method = method_back
    @emoji_method = method_emoji
  end
  #--------------------------------------------------------------------------
  # * Eliminazione
  #--------------------------------------------------------------------------
  def dispose
    super
    @caret.dispose
  end
end #class Window_BoardWriter

class Text_Caret < Sprite
  attr_accessor :character_number
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Viewport] viewport
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    create_bitmap
    @timing = 0
    @character_number = 0
  end
  #--------------------------------------------------------------------------
  # * Creazione della bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    bitmap = Bitmap.new(1, 24)
    bitmap.fill_rect(x, y, 1, 24, Color.new(255,255,255))
    self.bitmap = bitmap
  end
  #--------------------------------------------------------------------------
  # * Carattere indietro
  #--------------------------------------------------------------------------
  def back(x, y)
    self.x = x
    self.y = y
    smooth_move(x, y)
    @character_number -= 1
  end
  #--------------------------------------------------------------------------
  # * Carattere avanti
  #--------------------------------------------------------------------------
  def forward(x, y)
    smooth_move(x, y)
    @character_number += 1
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_blink
  end
  #--------------------------------------------------------------------------
  # * Aggiorna l'animazione lampeggiante
  #--------------------------------------------------------------------------
  def update_blink
    @timing += 1
    if @timing >= 30
      self.visible = !self.visible
      @timing = 0
    end
  end
end