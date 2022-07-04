#===============================================================================
# ** Sprite_Engine
#-------------------------------------------------------------------------------
# Motore che gestisce le funzioni aggiuntive degli Sprite
#===============================================================================
$imported = {} if $imported == nil
$imported["H87-Sprite_Engine"] = 1.0
module Sprite_Engine
  # Avvia l'animazione dello Zoom
  #   new_x: nuovo zoom X (metti :same se non vuoi che cambi)
  #   new_y: nuovo zoom Y (metti :same se non vuoi che cambi)
  #   speed: velocità (1 di default)
  #   ricordati che devono essere valori decimali (1.0: 100%)
  # @param [Integer] new_x
  # @param [Integer] new_y
  # @param [Integer] speed
  def zoom_move(new_x, new_y, speed = 1)
    new_x = self.zoom_x if new_x == :same
    new_y = self.zoom_y if new_y == :same
    @new_zoom_move_x = new_x
    @new_zoom_move_y = new_y
    @zoom_move_speed = [[speed / 100.0, 0.001].max, 1].min
  end

  def move_x_a_bit(speed)
    @float_x += speed
    intval = @float_x.to_i
    if intval != 0
      @float_x -= intval
      self.x += intval
    end
  end

  def move_y_a_bit(speed)
    @float_y += speed
    intval = @float_y.to_i
    if intval != 0
      @float_y -= intval
      self.y += intval
    end
  end

  # Cambia la tonalità gradualmente nel tempo
  # @param [Tone] new_tone
  # @param [Integer] time
  # @param [Method] tone_handler
  def fade_tone(new_tone = Tone.new(0, 0, 0, 0), time = 30, tone_handler = nil)
    if time > 0
      @new_tone = new_tone
      @tone_time = time
      @tone_handler = tone_handler
      red = (self.tone.red - new_tone.red) / -time
      green = (self.tone.green - new_tone.green) / -time
      blue = (self.tone.blue - new_tone.blue) / -time
      gray = (self.tone.gray - new_tone.gray) / -time
      @color_portion = [red, green, blue, gray]
    else
      self.tone = new_tone
    end
  end

  # Fa brillare lo sprite con flash a intervalli regolari
  # @param [Color] color
  # @param [Integer] flash_duration
  # @param [Integer] interval
  def blink(color, flash_duration = 30, interval = 60)
    @blink_color = Color.new(color.red, color.green, color.blue, color.alpha)
    @blink_duration = flash_duration
    @blink_interval = interval
    @blink_state = interval
  end

  # Ferma il brillantio dello Sprite
  def stop_blink
    @blink_color = nil
  end

  # Cambia le dimensioni
  #   new_width:  nuova larghezza
  #   new_height: nuova altezza
  #   speed:      velocità
  # @param [Integer] new_width
  # @param [Integer] new_height
  # @param [Integer] speed
  def change_size(new_width, new_height, speed = 1)
    speed = [[speed, 1].max, 20].min
    @new_width = new_width
    @new_height = new_height
    @size_speed = speed
  end

  # Metodo cambio tono per annullare il fade della tonalità
  # @param [Tone] new_tone
  def tone=(new_tone)
    @tone = new_tone
    @new_tone = nil
  end

  # Restituisce true se l'oggetto si sta trasformando
  def zooming?
    return false unless self.is_a?(Sprite)
    self.zoom_x != @new_zoom_x || self.zoom_y != @new_zoom_y
  end

  # Coordinata X del centro della picture
  def sprite_center_x
    self.x - self.ox + self.width / 2
  end

  # Coordinata Y del centro della picture
  def sprite_center_y
    self.y - self.oy + self.height / 2
  end

  # Imposta la larghezza secondo lo zoom
  # @param [Integer] value
  def width=(value)
    return if self.width == 0
    @new_width = nil
    self.zoom_x = value / self.width.to_f
  end

  # Imposta l'altezza secondo lo zoom
  # @param [Integer] value
  def height=(value)
    return if self.height == 0
    @new_height = nil
    self.zoom_y = value / self.height.to_f
  end

  # Imposta la larghezza secondo lo zoom
  # @param [Integer] value
  def z_width=(value)
    return if self.width == 0
    self.zoom_x = value / self.width.to_f
  end

  # Imposta l'altezza secondo lo zoom
  # @param [Integer] value
  def z_height=(value)
    return if self.height == 0
    self.zoom_y = value / self.height.to_f
  end

  # Restituisce la larghezza visibile sullo schermo
  def screen_width
    (self.zoom_x * self.width).to_i
  end

  # Restituisce l'altezza visibile sullo schermo
  def screen_height
    (self.zoom_y * self.height).to_i
  end

  # Inizializzazione
  def sprite_engine_init
    @float_x = 0.0
    @float_y = 0.0
    @moving = false
  end

  # Aggiornamento
  def sprite_engine_update
    update_change_size
    udpate_normal_move
    update_fade_tone
    update_blink_e
  end

  # Aggiorna lo zoom X
  #     speed: velocità di movimento
  def update_smooth_zoom_x(speed = move_speed)
    return if @new_zoom_x.nil?
    dist = @new_zoom_x - self.zoom_x
    if dist.abs < speed
      self.zoom_x = update_smooth_zoom_x(speed / 2)
    else
      begin
        self.zoom_x += dist / speed
      rescue
        self.zoom_x += dist
      end
    end
  end

  # Aggiorna lo zoom Y
  # @param [Integer] speed
  def update_smooth_zoom_y(speed = move_speed)
    return if @new_zoom_y.nil?
    dist = @new_zoom_y - self.zoom_y
    if dist.abs < speed
      self.zoom_y = update_smooth_zoom_y(speed / 2)
    else
      self.zoom_y += dist / speed rescue self.zoom_y += dist
    end
  end

  # Aggiorna il cambio di tonalità
  def update_fade_tone
    return unless @new_tone
    self.tone.red -= @color_portion[0]
    self.tone.green -= @color_portion[1]
    self.tone.blue -= @color_portion[2]
    self.tone.gray -= @color_portion[3]
    @tone_time -= 1
    if @tone_time <= 0
      self.tone = @new_tone
      @new_tone = nil
      @tone_handler.call if @tone_handler
    end
  end

  # Aggiorna lo sbrilluccichio
  def update_blink_e
    return if @blink_color.nil?
    if @blink_state % @blink_interval == 0
      flash(@blink_color, @blink_duration)
      @blink_state = @blink_interval
    end
    @blink_state += 1
  end

  # Imposta il movimento dello Sprite
  #   new_x: coordinata X destinazione
  #   new_y: coordinata Y destinazione
  #   speed: velocità (1 di default)
  # @param [Integer, Symbol] new_x
  # @param [Integer, Symbol] new_y
  # @param [Integer] x_speed
  # @param [Integer] y_speed
  # @param [Method] method
  def move_to(new_x, new_y, x_speed = 1, y_speed = 1, method = nil)
    new_x = self.x if new_x == :same
    new_y = self.y if new_y == :same
    @new_pos_x = new_x
    @new_pos_y = new_y
    @x_state = self.x
    @y_state = self.y
    @x_speed = [[x_speed, 0.01].max, 20].min
    @y_speed = [[y_speed, 0.01].max, 20].min
    @move_handler = method
    @moving = true
  end

  # ferma il movimento dello sprite
  def stop_move
    @new_pos_x = nil
    @new_pos_y = nil
    @x_state = nil
    @y_state = nil
    @move_handler = nil
    @moving = false
  end

  private

  # Aggiornamento del movimento
  def udpate_normal_move
    return unless @moving
    if @new_pos_x.nil? and @new_pos_y.nil?
      @moving = false
      call_move_handler
    else
      update_x_move
      update_y_move
    end
  end

  def update_x_move
    return if @new_pos_x.nil?
    if (@x_state - @new_pos_x).abs <= @x_speed
      self.x = @new_pos_x
      @new_pos_x = nil
      return
    end
    @x_state += (@new_pos_x <=> self.x) * @x_speed
    self.x = @x_state.to_i
  end

  def update_y_move
    return if @new_pos_y.nil?
    if (@y_state - @new_pos_y).abs <= @y_speed
      self.y = @new_pos_y
      @new_pos_y = nil
      return
    end
    @y_state += (@new_pos_y <=> self.y) * @y_speed
    self.y = @y_state.to_i
  end

  def destination_ok?(coord1, coord2)
    (coord1 - coord2).abs <= @set_move_speed
  end

  # Chiama l'evento di fine movimento
  def call_move_handler
    return if @move_handler.nil?
    @move_handler.call
  end

  # Aggiornamento dello Zoom
  def update_zoom_move
    return if @new_zoom_move_x.nil?
    self.zoom_x += (self.zoom_x <=> @new_zoom_move_x) * speed
    self.zoom_y += (self.zoom_y <=> @new_zoom_move_y) * speed
    if self.zoom_x == @new_zoom_move_x && self.zoom_y == @new_zoom_move_y
      @new_zoom_move_x = nil
      @new_zoom_move_y = nil
    end
  end

  # Aggiorna le dimensioni in animazione
  def update_change_size
    update_change_width unless @new_width.nil?
    update_change_height unless @new_height.nil?
  end

  # Aggiorna il cambio di larghezza
  def update_change_width
    distance = (@new_width - self.screen_width).abs
    if distance < @size_speed
      self.width = @new_width
    else
      state = @new_width <=> self.screen_width
      self.z_width = self.screen_width + state * @size_speed
    end
  end

  # Aggiorna il cambio di altezza
  def update_change_height
    distance = (@new_height - self.screen_height).abs
    if distance < @size_speed
      self.height = @new_height
    else
      state = @new_height <=> self.screen_height
      self.z_height = self.screen_height + state * @size_speed
    end
  end
end #sprite engine