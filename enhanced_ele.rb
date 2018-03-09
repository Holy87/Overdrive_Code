#===============================================================================
# Utility grafiche di Holy87
# Difficoltà utente: ★★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script aggiunge diversi metodi e funzioni a vari elementi del gioco:
# sprite, bitmap, plane e finestre. Integra anche le funzioni dello script
# Movimento Fluido, quindi puoi rimuoverlo se utilizzi questo script.
#
# ▼ Color
#   ● Creazione dei colori tramite codice esadecimale
#     Oltre alla classica creazione dei colori tramite RGB Color.new(r, g, b)
#     ora puoi creare colori anche con il codice esadecimale Color.new('#7CFC00')
#     come secondo valore puoi impostare l'opacità, valore da 0 a 255.
#   ● Colori CSS!
#     Sai programmare via web? Ora hai a disposizione tutta la palette di
#     colori CSS. Puoi chiamarlo con le costanti della classe Color. Ad esempio,
#     se vuoi ottenere il colore magenta del CSS, basta chiamare Color::MAGENTA.
#     Oppure, se vuoi il colore lightcoral, basta chiamare Color::LIGHTCORAL.
#
# ▼ Bitmap
#   ● draw_icon(icon_index, x, y[, enabled])
#     Come nelle finestre, puoi disegnare facilmente un'icona anche nelle bitmap
#     utilizzando lo stesso approccio.
#   ● def draw_glowed_text(x, y, width, height, text, [,align, glow_str, glow_color])
#     Disegna un testo con bagliore.
#     I parametri align, glow_str e glow_color sono facoltativi.
#     glow_str è la potenza del bagliore (2 di default), glow_color il colore
#     del bagliore (se omesso, ha lo stesso colore del testo)
#
# ▼ Sprite
#   ● smooth_move(x, y[, vel, move_hanlder])
#     Muove uno sprite alle coordinate X e Y in modo "fluido", cioè rallenta
#     quando vicino alla destinazione. Il parametro vel, se inserito, specifica
#     la velocità varia da 1 a 5. Puoi impostare un metodo che viene chiamato
#     alla fine dell'operazione tramite move_handler. Esempio:
#     sprite.smooth_move(25, 25, 2, method(:sprite_mosso))
#   ● move_speed = valore
#     Imposta la velocità di movimento predefinita
#   ● zoom_move(z_x, z_y[, speed])
#     Modfica le dimensioni di uno sprite. Tieni conto che z_x e z_y rappresentano
#     le proporzioni, quindi 1.0 sarà 100%, 2.0 200% e 0.5 50%. La velocità
#     predefinita è 1.
#   ● fade_tone(new_tone, time[, tone_handler])
#     Cambia la tonalità dello sprite con un fade. Time è il tempo di cambio
#     tonalità in frame (se omesso è 30)
#     Esempio: sprite.fade_tone(Tone.new(200,50,0,0), 15, method(:tono_cambiato)).
#   ● blink(color[, flash_duration, interval])
#     Causa flash allo sprite ad intermittenza. I parametri flash_duration e
#     interval sono facoltativi.
#     flash_duration di default è 30 ed è la durata in frame del flash.
#     interval se omesso è 60 e definisce il tempo tra un flash e l'altro.
#   ● stop_blink
#     ferma il flash ad intermittenza
#   ● fade[opacity, speed]
#     fa un fade dello sprite. Se omesso, il valore opacity è 0 e speed è 1,
#     puoi impostarlo fino ad un massimo di 255
#   ● pulse(min_opacity, max_opacity[, speed])
#     fa pulsare lo sprite nella trasparenza. Le opacità vanno da 0 a 255 e
#     la velocità è di default 10
#   ● pulse_stop
#     ferma la pulsazione
#   ● sprite_center_x
#     coordinata X al centro dello sprite rispetto allo schermo
#   ● sprite_center_y
#     coordinata Y al centro dello sprite rispetto allo schermo
#   ● width = x
#     Cambia la larghezza dello sprite in pixel
#   ● height = x
#     Cambia l'altezza dello sprite in pixel
#   ● screen_width
#     Restituisce la larghezza visibile sullo schermo
#   ● screen_height
#     Restituisce l'altezza visibile sullo schermo
#   ● left_x, right_x, bottom_y, upper_y
#     la posizione della parte dello sprite rispetto allo schermo,
#     indipendentemente dall'origine impostata
#
# ▼ Sparks
#   Si tratta di una nuova funzione degli sprite. Puoi generare scintille
#   negli sprite modificando questi attributi:
#   ● spark_active: true attiva la generazione di particelle
#   ● spark_density: definisce la densità delle particelle
#   ● spark_bitmap: la bitmap dell'immagine della scintilla
#   ● spark_spawn_ray: il raggio di comparsa delle scintille rispetto al centro
#     dello sprite
#   ● stop_sparks
#     cancella tutte le scintille e ferma la generazione
#
# ▼ Viewport
#   ● x e y
#     Restituiscono le coordinate del viewport
#
# ▼ Plane
#   ● gli attributi x_speed e y_speed
#     assegnano la velocità di scorrimento x e y
#
# ▼ Window_Base
#   ● center_window
#     centra la finestra rispetto allo schermo
#   ● right_corner (o rx), bottom_corner (o by)
#     restituisce le coordinate x e y del lato destro e basso
#   ● draw_underline(line[, width, color])
#     disegna una linea sotto il testo. Il parametro line è la riga nella
#     finestra.
#   ● max_lines
#     restituisce il massimo numero di righe visualizzabili dalla finestra
#   ● draw_bg_rect(x, y[, width, height, color])
#     disegna un rettangolo come sfondo del testo
#   ● draw_bg_srect(x, y[, width, height, color])
#     disegna un rettangolo come sfondo del testo, ma con gli angoli smussati
#   ● get_line_coord(line)
#     ottiene la coordinata x della riga rispetto allo schermo. Se omesso line,
#     è la prima riga
#   ● draw_gauge_b(x, y, width, height, value, max[, c1, c2])
#     disegna una barra generica specificando il valore e il valore massimo.
#     c1 e c2 rappresentano i colori gradienti della barra
#   ● draw_gauge_a(x, y, width, height, value, min, max[, c1, c2])
#     disegna una barra generica come la precedente, ma con valore minimo diverso
#     da 0
#
# ▼ Window_Selectable
#   ● get_absolute_rect(index)
#     ottiene il rect dell'elemento con la posizione assoluta rispetto allo schermo

# ● Non ha bisogno di immagini o configurazioni (ma puoi, se vuoi)

# ● Compatibile con tutti gli script: riesce a riconoscere i comandi aggiunti al
#   menu classico e riconvertirli al nuovo menu.
# ● Alta personalizzazione: puoi modificare la disposizione, il font, i colori,
#   usare immagini al posto di testo e cursori e altro ancora!
# ● Mostra un "Premi Start" e copyright all'avvio del gioco prima del menu
# ● Comando "Resume" che a differenza di carica partita, carica direttamente
#   l'ultimo salvataggio senza passare per la schermata di caricamento.
#===============================================================================
# ** Istruzioni:
# Copiare lo script sotto Materials e prima del Main. Configurare l'aspetto
# nelle opzioni in basso. Le eventuali immagini da usare vanno messe nella
# cartella Pictures.
#===============================================================================
# ** Impostazioni dello script
#-------------------------------------------------------------------------------
# Qui puoi personalizzare il tuo menu della schermata del titolo.
#===============================================================================
require 'rm_vx_data' if false

module Spark_Engine
  DEFAULT_SPARK_IMAGE = 'Spark'
end

$imported = {} if $imported == nil
$imported['H87_SmoothMovements'] = 1.2
$imported['H87_EnhancedEle'] = 1.0
#===============================================================================
# ** Fade_Engine
#-------------------------------------------------------------------------------
# Modulo per le funzioni di fade e pulsazione
#===============================================================================
module Fade_Engine
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_accessor :fade_speed   #velocità di dissolvenza
  attr_accessor :pulse_state  #stato della pulsazione (hash, nil di default)
  #--------------------------------------------------------------------------
  # * Inizializzazione delle variabili
  #--------------------------------------------------------------------------
  def fade_engine_init
    @fade_speed = 0
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def fade_engine_update
    update_fading
    update_pulse
  end
  #--------------------------------------------------------------------------
  # * Comando di cambio trasparenza
  #     opacity: opacità finale
  #     speed: velocità di fade
  #--------------------------------------------------------------------------
  def fade(opacity = 0, speed = 1, pulse = false)
    pulse_stop unless pulse
    @new_opacity = opacity
    @fade_speed = speed
  end
  #--------------------------------------------------------------------------
  # * Aggiorna il fade
  #--------------------------------------------------------------------------
  def update_fading
    return if @new_opacity.nil?
    speed = @fade_speed
    distance = (self.opacity - @new_opacity).abs
    if distance <= speed
      self.opacity = @new_opacity
      @new_opacity = nil
    else
      state = @new_opacity <=> self.opacity
      self.opacity += speed * state
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la pulsazione
  #--------------------------------------------------------------------------
  def update_pulse
    return if @pulse_state.nil?
    if @pulse_state[:defading] and self.opacity >= @pulse_state[:max]
      @pulse_state[:defading] = false
      fade(@pulse_state[:min], @pulse_state[:speed], true)
    elsif self.opacity <= @pulse_state[:min]
      @pulse_state[:defading] = true
      fade(@pulse_state[:max], @pulse_state[:speed], true)
    end
  end
  #--------------------------------------------------------------------------
  # * Avvia la pulsazione
  #   min_opacity:  opacità minima
  #   max_opacity:  opacità massima
  #   speed:        velocità
  #--------------------------------------------------------------------------
  def pulse(min_opacity, max_opacity, speed = 10)
    @pulse_state = {:min => min_opacity, :max => max_opacity,
                    :speed => [[speed, 1].max, 255].min, :defading => false, :init => self.opacity}
    fade(min_opacity, speed, true)
  end
  #--------------------------------------------------------------------------
  # * Ferma la pulsazione
  #--------------------------------------------------------------------------
  def pulse_stop
    return if @pulse_state.nil?
    init = @pulse_state[:init]
    speed = @pulse_state[:speed]
    @pulse_state = nil
    fade(init, speed)
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto sta cambiando trasparenza
  #--------------------------------------------------------------------------
  def fading?
    return @new_opacity != nil
  end
end #fade engine

#==============================================================================
# ** Modulo Smooth_Movements
#------------------------------------------------------------------------------
#  Questo modulo, se integrato in finestre e sprite, aggiunge nuovi tipi di
#  animazioni in movimento.
#==============================================================================
module Smooth_Movements
  #--------------------------------------------------------------------------
  # * Avvia il movimento fluido
  # @param [Integer] new_x        nuova coordinata x
  # @param [Integer] new_y        nuova coordinata y
  # @param [Integer] speed        velocità (2 di default)
  # @param [Method] move_hanlder  metodo che viene chiamato alla fine
  #--------------------------------------------------------------------------
  def smooth_move(new_x, new_y, speed = nil, move_hanlder = nil)
    self.move_speed = speed unless speed.nil?
    @move_handler = move_hanlder
    @new_x = new_x
    @new_y = new_y
    @start_move = true
    @move_end = false
  end
  #--------------------------------------------------------------------------
  # * Aggiorna il movimento fluido
  #--------------------------------------------------------------------------
  def update_smooth_movements
    return unless @start_move
    update_smooth_x
    update_smooth_y
    check_move_end
  end
  #--------------------------------------------------------------------------
  # * Restituisce la velocità di movimento preconfigurata
  #--------------------------------------------------------------------------
  def move_speed
    @speed = 2 if @speed.nil?
    @speed
  end
  #--------------------------------------------------------------------------
  # * Imposta la velocità di movimento
  #     new_speed: valore da 1 a 5
  #--------------------------------------------------------------------------
  def move_speed=(new_speed)
    @speed = 20/([[new_speed,1].max,5].min*2)
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la posizione X del movimento
  #     speed: velocità di movimento
  #--------------------------------------------------------------------------
  def update_smooth_x(speed = move_speed)
    return if @new_x.nil?
    dist = @new_x - self.x
    if dist.abs < speed
      self.x = update_smooth_x(speed/2)
    else
      self.x += dist / speed rescue self.x += dist
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la posizione Y del movimento
  #     speed: velocità di movimento
  #--------------------------------------------------------------------------
  def update_smooth_y(speed = move_speed)
    return if @new_y.nil?
    dist = @new_y - self.y
    if dist.abs < speed
      self.y = update_smooth_y(speed/2)
    else
      self.y += dist / speed rescue self.y += dist
    end
  end
  #--------------------------------------------------------------------------
  # * Controlla se il movimento è terminato
  #--------------------------------------------------------------------------
  def check_move_end
    if self.x == @new_x && self.y == @new_y
      @move_end = true
      @start_move = false
      call_move_handler
    end
  end
  #--------------------------------------------------------------------------
  # * Chiama l'evento di fine movimento
  #--------------------------------------------------------------------------
  def call_move_handler
    return if @move_handler.nil?
    @move_handler.call
    @move_handler = nil
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto ha compiuto il suo movimento
  #--------------------------------------------------------------------------
  def move_end?
    @move_end || !@start_move
  end
end #modulo smooth

#===============================================================================
# ** Spark_Engine
#-------------------------------------------------------------------------------
# Motore che gestisce le scintille degli Sprite
#===============================================================================
module Spark_Engine
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_accessor :spark_active     # se le scintille sono attive
  attr_accessor :spark_density    # densità di creazione delle scintille
  attr_accessor :spark_bitmap     # bitmap delle scintille
  attr_accessor :spark_spawn_ray  # raggio di comparsa delle scintille
  #--------------------------------------------------------------------------
  # * Inizializzazione delle variabili
  #--------------------------------------------------------------------------
  def spark_engine_init
    @sparks = []
    @spark_bitmap = spark_picture
    @spark_active = false
    @spark_density = 10
    @spark_spawn_ray = 10
    @is_spark = false
  end
  #--------------------------------------------------------------------------
  # * Restituisce la bitmap iniziale dello spark
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def spark_picture
    if DEFAULT_SPARK_IMAGE != nil
      Cache.picture(DEFAULT_SPARK_IMAGE)
    else
      create_spark_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # * Crea una bitmap
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def create_spark_bitmap
    spark_bitmap = Bitmap.new(3, 3)
    color = Color::WHITE
    spark_bitmap.set_pixel(1, 0, color)
    spark_bitmap.set_pixel(0, 1, color)
    spark_bitmap.set_pixel(2, 1, color)
    spark_bitmap.set_pixel(1, 2, color)
    spark_bitmap
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def spark_engine_update
    update_sparks
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento delle scintille
  #--------------------------------------------------------------------------
  def update_sparks
    return if @is_spark
    @sparks.each do |spark|
      spark.update
      if spark.opacity == 0
        spark.dispose
        @sparks.delete(spark)
      end
    end
    add_sparks(@spark_density) if @spark_active
  end
  #--------------------------------------------------------------------------
  # * Aggiunge delle scintille
  #   density: densità di creazione
  #--------------------------------------------------------------------------
  def add_sparks(density)
    density.times do
      add_new_spark if rand(10) == 0
    end
  end
  #--------------------------------------------------------------------------
  # * Cancellazione di tutte le scintille
  #--------------------------------------------------------------------------
  def delete_sparks
    @sparks.each do |spark|
      spark.opacity = 0
      spark.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce se è una scintilla
  #--------------------------------------------------------------------------
  def is_spark?; false; end
  #--------------------------------------------------------------------------
  # * Aggiunge una nuova scintilla
  #--------------------------------------------------------------------------
  def add_new_spark
    spark = Sprite_Spark.new(self.viewport)
    spark.bitmap = @spark_bitmap
    spark_x = rand(@spark_spawn_ray*2) - @spark_spawn_ray
    spark_y = rand(@spark_spawn_ray*2) - @spark_spawn_ray
    spark.x = spark_x + sprite_center_x
    spark.y = spark_y + sprite_center_y
    spark.set_direction(spark.x - sprite_center_x, spark.y - sprite_center_y)
    spark.opacity = self.opacity
    @sparks.push(spark)
  end
  #--------------------------------------------------------------------------
  # * Ferma tutte le scintille
  #--------------------------------------------------------------------------
  def stop_sparks
    delete_sparks
    @sparks = []
    @spark_active = false
  end
end #spark engine

#===============================================================================
# ** Plane_Engine
#-------------------------------------------------------------------------------
# Modulo che include i metodi di movimento del Plane
#===============================================================================
module Plane_Engine
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubblici
  #--------------------------------------------------------------------------
  attr_accessor :x_speed  #velocità orizzontale (1/100 di frame)
  attr_accessor :y_speed  #velocità verticale
  #--------------------------------------------------------------------------
  # * Inizializzazione delle variabili
  #--------------------------------------------------------------------------
  def plane_engine_init
    @x_speed = 0
    @y_speed = 0
    @x_state = 0
    @y_state = 0
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def plane_engine_update
    update_x
    update_y
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della coordinata X in movimento
  #--------------------------------------------------------------------------
  def update_x
    @x_state += @x_speed
    @picture.ox += (@x_state/100)
    @x_state = @x_state % 100
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della coordinata Y in movimento
  #--------------------------------------------------------------------------
  def update_y
    @y_state += @y_speed
    @picture.oy += (@y_state/100)
    @y_state = @y_state % 100
  end
end #plane engine

#===============================================================================
# ** Sprite_Engine
#-------------------------------------------------------------------------------
# Motore che gestisce le funzioni aggiuntive degli Sprite
#===============================================================================
module Sprite_Engine
  #--------------------------------------------------------------------------
  # * Avvia l'animazione dello Zoom
  #   new_x: nuovo zoom X (metti :same se non vuoi che cambi)
  #   new_y: nuovo zoom Y (metti :same se non vuoi che cambi)
  #   speed: velocità (1 di default)
  #   ricordati che devono essere valori decimali (1.0: 100%)
  # @param [Integer] new_x
  # @param [Integer] new_y
  # @param [Integer] speed
  #--------------------------------------------------------------------------
  def zoom_move(new_x, new_y, speed = 1)
    new_x = self.zoom_x if new_x == :same
    new_y = self.zoom_y if new_y == :same
    @new_zoom_move_x = new_x
    @new_zoom_move_y = new_y
    @zoom_move_speed = [[speed/100.0, 0.001].max, 1].min
  end
  #--------------------------------------------------------------------------
  # * Cambia la tonalità gradualmente nel tempo
  # @param [Tone] new_tone
  # @param [Integer] time
  # @param [Method] tone_handler
  #--------------------------------------------------------------------------
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
  #--------------------------------------------------------------------------
  # * Fa brillare lo sprite con flash a intervalli regolari
  # @param [Color] color
  # @param [Integer] flash_duration
  # @param [Integer] interval
  #--------------------------------------------------------------------------
  def blink(color, flash_duration = 30, interval = 60)
    @blink_color = Color.new(color.red, color.green, color.blue, color.alpha)
    @blink_duration = flash_duration
    @blink_interval = interval
    @blink_state = interval
  end
  #--------------------------------------------------------------------------
  # * Ferma il brillantio dello Sprite
  #--------------------------------------------------------------------------
  def stop_blink
    @blink_color = nil
  end
  #--------------------------------------------------------------------------
  # * Cambia le dimensioni
  #   new_width:  nuova larghezza
  #   new_height: nuova altezza
  #   speed:      velocità
  # @param [Integer] new_width
  # @param [Integer] new_height
  # @param [Integer] speed
  #--------------------------------------------------------------------------
  def change_size(new_width, new_height, speed = 1)
    speed = [[speed, 1].max, 20].min
    @new_width = new_width
    @new_height = new_height
    @size_speed = speed
  end
  #--------------------------------------------------------------------------
  # * Metodo cambio tono per annullare il fade della tonalità
  # @param [Tone] new_tone
  #--------------------------------------------------------------------------
  def tone=(new_tone)
    @tone = new_tone
    @new_tone = nil
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto si sta trasformando
  #--------------------------------------------------------------------------
  def zooming?
    return false unless self.is_a?(Sprite)
    self.zoom_x != @new_zoom_x || self.zoom_y != @new_zoom_y
  end
  #--------------------------------------------------------------------------
  # * Coordinata X del centro della picture
  #--------------------------------------------------------------------------
  def sprite_center_x
    self.x - self.ox + self.width / 2
  end
  #--------------------------------------------------------------------------
  # * Coordinata Y del centro della picture
  #--------------------------------------------------------------------------
  def sprite_center_y
    self.y - self.oy + self.height / 2
  end
  #--------------------------------------------------------------------------
  # * Imposta la larghezza secondo lo zoom
  # @param [Integer] value
  #--------------------------------------------------------------------------
  def width=(value)
    return if self.width == 0
    @new_width = nil
    self.zoom_x = value/self.width.to_f
  end
  #--------------------------------------------------------------------------
  # * Imposta l'altezza secondo lo zoom
  # @param [Integer] value
  #--------------------------------------------------------------------------
  def height=(value)
    return if self.height == 0
    @new_height = nil
    self.zoom_y = value/self.height.to_f
  end
  #--------------------------------------------------------------------------
  # * Imposta la larghezza secondo lo zoom
  # @param [Integer] value
  #--------------------------------------------------------------------------
  def z_width=(value)
    return if self.width == 0
    self.zoom_x = value/self.width.to_f
  end
  #--------------------------------------------------------------------------
  # * Imposta l'altezza secondo lo zoom
  # @param [Integer] value
  #--------------------------------------------------------------------------
  def z_height=(value)
    return if self.height == 0
    self.zoom_y = value/self.height.to_f
  end
  #--------------------------------------------------------------------------
  # * Restituisce la larghezza visibile sullo schermo
  #--------------------------------------------------------------------------
  def screen_width
    (self.zoom_x * self.width).to_i
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'altezza visibile sullo schermo
  #--------------------------------------------------------------------------
  def screen_height
    (self.zoom_y * self.height).to_i
  end
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def sprite_engine_init
    # niente!
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def sprite_engine_update
    update_change_size
    udpate_normal_move
    update_fade_tone
    update_blink_e
  end
  #--------------------------------------------------------------------------
  # * Aggiorna lo zoom X
  #     speed: velocità di movimento
  #--------------------------------------------------------------------------
  def update_smooth_zoom_x(speed = move_speed)
    return if @new_zoom_x.nil?
    dist = @new_zoom_x - self.zoom_x
    if dist.abs < speed
      self.zoom_x = update_smooth_zoom_x(speed/2)
    else
      begin
        self.zoom_x += dist / speed
      rescue
        self.zoom_x += dist
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna il cambio di tonalità
  #--------------------------------------------------------------------------
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
  #--------------------------------------------------------------------------
  # * Aggiorna lo sbrilluccichio
  #--------------------------------------------------------------------------
  def update_blink_e
    return if @blink_color.nil?
    if @blink_state % @blink_interval == 0
      flash(@blink_color, @blink_duration)
      @blink_state = @blink_interval
    end
    @blink_state += 1
  end
  #--------------------------------------------------------------------------
  # * Imposta il movimento dello Sprite
  #   new_x: coordinata X destinazione
  #   new_y: coordinata Y destinazione
  #   speed: velocità (1 di default)
  # @param [Integer] new_x
  # @param [Integer] new_y
  # @param [Integer] speed
  #--------------------------------------------------------------------------
  def set_move(new_x, new_y, speed = 1)
    new_x = self.x if new_x == :same
    new_y = self.y if new_y == :same
    @new_pos_x = new_x
    @new_pos_y = new_y
    @set_move_speed = [[speed, 1].max, 20].min
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento del movimento
  #--------------------------------------------------------------------------
  def udpate_normal_move
    return if @new_pos_x.nil?
    self.x += (self.x <=> @new_pos_x)
    self.y += (self.y <=> @new_pos_y)
    if self.x == @new_pos_x && self.y == @new_pos_y
      @new_pos_x = nil
      @new_pos_y = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento dello Zoom
  #--------------------------------------------------------------------------
  def update_zoom_move
    return if @new_zoom_move_x.nil?
    self.zoom_x += (self.zoom_x <=> @new_zoom_move_x) * speed
    self.zoom_y += (self.zoom_y <=> @new_zoom_move_y) * speed
    if self.zoom_x == @new_zoom_move_x && self.zoom_y == @new_zoom_move_y
      @new_zoom_move_x = nil
      @new_zoom_move_y = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna le dimensioni in animazione
  #--------------------------------------------------------------------------
  def update_change_size
    update_change_width unless @new_width.nil?
    update_change_height unless @new_height.nil?
  end
  #--------------------------------------------------------------------------
  # * Aggiorna il cambio di larghezza
  #--------------------------------------------------------------------------
  def update_change_width
    distance = (@new_width - self.screen_width).abs
    if distance < @size_speed
      self.width = @new_width
    else
      state = @new_width <=> self.screen_width
      self.z_width = self.screen_width + state*@size_speed
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna il cambio di altezza
  #--------------------------------------------------------------------------
  def update_change_height
    distance = (@new_height - self.screen_height).abs
    if distance < @size_speed
      self.height = @new_height
    else
      state = @new_height <=> self.screen_height
      self.z_height = self.screen_height + state*@size_speed
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna lo zoom Y
  # @param [Integer] speed
  #--------------------------------------------------------------------------
  def update_smooth_zoom_y(speed = move_speed)
    return if @new_zoom_y.nil?
    dist = @new_zoom_y - self.zoom_y
    if dist.abs < speed
      self.zoom_y = update_smooth_zoom_y(speed/2)
    else
      self.zoom_y += dist / speed rescue self.zoom_y += dist
    end
  end
end #sprite engine

#==============================================================================
# ** Classe Window_Base
#------------------------------------------------------------------------------
#  Inclusione del modulo smooth_movement
#==============================================================================
class Window_Base < Window
  include Smooth_Movements  #incusione del modulo del movimento fluido
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  alias smooth_udpate update unless $@
  def update
    smooth_udpate
    update_smooth_movements if SceneManager.scene.is_a?(Scene_MenuBase)
  end
end #window_base

#==============================================================================
# ** Classe Sprite
#------------------------------------------------------------------------------
#  Inclusione del modulo smooth_movement
#==============================================================================
class Sprite
  include Smooth_Movements  #incusione del modulo del movimento fluido
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  alias smooth_udpate update unless $@
  def update
    smooth_udpate
    update_smooth_movements
  end
end #sprite

#==============================================================================
# ** Classe Viewport
#------------------------------------------------------------------------------
#  Inclusione del modulo smooth_movement
#==============================================================================
class Viewport
  include Smooth_Movements  #incusione del modulo del movimento fluido
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  alias smooth_udpate update unless $@
  def update
    smooth_udpate
    update_smooth_movements
  end
  #--------------------------------------------------------------------------
  # * Restituisce la posizione X
  #--------------------------------------------------------------------------
  def x; rect.x; end
  #--------------------------------------------------------------------------
  # * Restituisce la posizione Y
  #--------------------------------------------------------------------------
  def y; rect.y; end
  #--------------------------------------------------------------------------
  # * Modifica la posizione X
  #--------------------------------------------------------------------------
  def x=(value)
    rect.x = value
  end
  #--------------------------------------------------------------------------
  # * Modifica la posizione Y
  #--------------------------------------------------------------------------
  def y=(value)
    rect.y = value
  end
end #fine dello script

#===============================================================================
# ** Sprite
#-------------------------------------------------------------------------------
# Aggiunta dei moduli per installare le nuove funzioni
#===============================================================================
class Sprite
  #--------------------------------------------------------------------------
  # * Inclusione dei moduli
  #--------------------------------------------------------------------------
  include Spark_Engine    # modulo per le particelle
  include Sprite_Engine   # modulo per metodi aggiuntivi Sprite
  include Fade_Engine     # modulo per l'opacità (fade e pulsazione)
  #--------------------------------------------------------------------------
  # * Alias dei metodi principali
  #--------------------------------------------------------------------------
  unless $@
    alias h87EnSprite_initialize initialize
    alias h87EnSprite_update update
    alias h87EnSprite_dispose dispose
  end
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #   viewport: viewport
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    h87EnSprite_initialize(viewport)
    spark_engine_init
    sprite_engine_init
    fade_engine_init
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    h87EnSprite_update rescue return
    fade_engine_update
    spark_engine_update
    sprite_engine_update
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    h87EnSprite_dispose
    delete_sparks
  end
  #--------------------------------------------------------------------------
  # * Coordinata X del lato sinistro
  #--------------------------------------------------------------------------
  def left_x; self.x - self.ox; end
  #--------------------------------------------------------------------------
  # * Coordinata X del lato destro
  #--------------------------------------------------------------------------
  def right_x; self.x - self.ox + self.width; end
  #--------------------------------------------------------------------------
  # * Coordinata Y del lato inferiore
  #--------------------------------------------------------------------------
  def bottom_y; self.y - self.oy + self.height; end
  #--------------------------------------------------------------------------
  # * Coordinata Y del lato superiore
  #--------------------------------------------------------------------------
  def upper_y; self.y - self.oy; end
end #sprite

#===============================================================================
# ** Plane
#-------------------------------------------------------------------------------
# Aggiunta delle funzioni di movimento automatico e fade al Plane
#===============================================================================
class Plane
  include Fade_Engine
  include Plane_Engine
  #--------------------------------------------------------------------------
  # * Alias dei metodi
  #--------------------------------------------------------------------------
  alias h87EnPlane_initialize initialize unless $@
  alias h87EnPlane_dispose dispose unless $@
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    h87EnPlane_initialize(viewport)
    fade_engine_init
    plane_engine_init
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    h87EnSprite_update
    fade_engine_update
    plane_engine_update
  end
end #plane

#===============================================================================
# ** Sprite_Spark
#-------------------------------------------------------------------------------
# Sottoclasse di Sprite, sono le scintille che escono da un altro sprite
#===============================================================================
class Sprite_Spark < Sprite
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_accessor :vector_x #vettore X
  attr_accessor :vector_y #vettore Y
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    self.ox = self.width/2
    self.oy = self.height/2
    self.flash(Color.new(255,255,255),10)
  end
  #--------------------------------------------------------------------------
  # * Restituisce se è una scintilla
  #--------------------------------------------------------------------------
  def is_spark?; true; end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    self.opacity -= 8
    update_direction
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della direzione
  #--------------------------------------------------------------------------
  def update_direction
    return if @dir_x.nil? || @dir_y.nil?
    self.x += @dir_x/4
    self.y += @dir_y/4
  end
  #--------------------------------------------------------------------------
  # * Imposta la direzione
  #   x: vettore X
  #   y: vettore Y
  #--------------------------------------------------------------------------
  def set_direction(x, y)
    @dir_x = x
    @dir_y = y
  end
end #sprite spark

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
# Aggiunta di metodi utili per uno sviluppo più facile
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Centra la finestra nel campo
  #--------------------------------------------------------------------------
  def center_window
    self.x = (Graphics.width - self.width)/2
    self.y = (Graphics.height - self.height)/2
  end
  #--------------------------------------------------------------------------
  # * Restituisce la coordinata della parte destra della finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def right_corner
    self.x + self.width
  end
  #--------------------------------------------------------------------------
  # * Restituisce la coordinata della parte sinistra della finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def bottom_corner
    self.y + self.height
  end
  #--------------------------------------------------------------------------
  # * Abbreviazioni per bottom_corner e right_corner
  # @return [Integer]
  #--------------------------------------------------------------------------
  def rx; right_corner; end
  def by; bottom_corner;end
  #--------------------------------------------------------------------------
  # * Disegna una linea per sottolineare il testo (per la sezione)
  # @param [Integer] line     linea
  # @param [Integer] width    larghezza (tutta la larghezza se omesso)
  # @param [Color] color      colore (predefinito, quello del testo)
  #--------------------------------------------------------------------------
  def draw_underline(line, width = contents_width, color = normal_color)
    color.alpha = 128
    contents.fill_rect(0,line_height*(line+1)-1,width,1,color)
  end
  #--------------------------------------------------------------------------
  # * Restituisce il massimo numero di righe nella finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def max_lines
    return (contents.width / line_height) - 1
  end
  #--------------------------------------------------------------------------
  # * Colore di sfondo 1
  # @return [Color]
  #--------------------------------------------------------------------------
  def sc1
    c = gauge_back_color
    c.alpha = 75
    c
  end
  #--------------------------------------------------------------------------
  # * Colore di sfondo 2
  # @return [Color]
  #--------------------------------------------------------------------------
  def sc2
    c = gauge_back_color
    c.alpha = 150
    c
  end
  #--------------------------------------------------------------------------
  # * Disegna la barra di sfondo al parametro
  # @param [Integer] x          coordinata X
  # @param [Integer] y          coordinata Y
  # @param [Integer] width      larghezza
  # @param [Integer] height     altezza (predefinito testo)
  # @param [Color] color        colore (predefinito scuro)
  #--------------------------------------------------------------------------
  def draw_bg_rect(x, y, width = contents_width, height = line_height, color = sc1)
    contents.fill_rect(x+1, y+1, width-2, height-2, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna la barra di sfondo al parametro con bordi smussati
  # @param [Integer] x          coordinata X
  # @param [Integer] y          coordinata Y
  # @param [Integer] width      larghezza
  # @param [Integer] height     altezza (predefinito testo)
  # @param [Color] color        colore (predefinito scuro)
  #--------------------------------------------------------------------------
  def draw_bg_srect(x, y, width = contents_width, height = line_height, color = sc1)
    contents.fill_rect(x+1, y+1, width-2, height-2, color)
    contents.clear_rect(x+1, y+1, 1, 1)
    contents.clear_rect(x+1, height-2, 1, 1)
    contents.clear_rect(width-2,y+1, 1, 1)
    contents.clear_rect(width-2, height-2, 1, 1)
  end
  #-----------------------------------------------------------------------------
  # * Restituisce le coordinate di una determinata riga della finestra
  # @param [Integer] line
  # @return [Rect]
  #-----------------------------------------------------------------------------
  def get_line_coord(line = 0)
    x = self.x + self.padding
    y = self.y + self.padding + line_height * line
    Rect.new(x, y, contents_width, line_height)
  end
  #--------------------------------------------------------------------------
  # * Disegna una barra generica
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Integer] value
  # @param [Integer] max
  # @param [Color] c1
  # @param [Color] c2
  #--------------------------------------------------------------------------
  def draw_gauge_b(x, y, width, height, value, max,
                   c1 = hp_gauge_color1, c2 = hp_gauge_color2)
    y += line_height - height
    contents.fill_rect(x, y, width, height, gauge_back_color)
    rate = value.to_f/max.to_f
    gw = (rate * width).to_i
    contents.gradient_fill_rect(x,y,gw,height,c1, c2)
  end
  #--------------------------------------------------------------------------
  # * Disegna una barra generica con minimo diverso da 0 (per exp)
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Integer] value
  # @param [Integer] max
  # @param [Integer] min
  # @param [Color] c1
  # @param [Color] c2
  #--------------------------------------------------------------------------
  def draw_gauge_a(x, y, width, height, value, min, max,
                   c1 = hp_gauge_color1, c2 = hp_gauge_color2)
    draw_gauge_b(x, y, width, height, value - min, max - min, c1, c2)
  end
  #--------------------------------------------------------------------------
  # * Imposta l'eroe della finestra
  # @param [Game_Actor] new_actor
  #--------------------------------------------------------------------------
  def set_actor(new_actor)
    return if new_actor == @actor
    @actor = new_actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'eroe
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def actor; @actor; end
  #--------------------------------------------------------------------------
  # * Disegna un testo formattato (torna a capo automaticamente)
  #   Supporta anche le emoji.
  #   x:      coordinata X
  #   y:      coordinata Y
  #   width:  larghezza del box
  #   text:   testo da scrivere
  #   max:    numero massimo di righe
  #--------------------------------------------------------------------------
  def draw_formatted_text(x, y, width, text, max = nil, colors = nil)
    contents.draw_formatted_text(x, y, width, text, max, colors)
  end
  #--------------------------------------------------------------------------
  # * Determina se la finestra è fuori dallo schermo
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def out_of_screen?
    return true if self.rx <= 0
    return true if self.by <= 0
    return true if self.x > Graphics.width
    return true if self.y > Graphics.height
    false
  end
end

#===============================================================================
# ** Window_Selectable
#-------------------------------------------------------------------------------
# Aggiunge metodi utili alla finestra
#===============================================================================
class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # * Ottiene il rettangolo in coordinate dello schermo dell'oggetto
  # @param [Integer] index
  # @return [Rect]
  #--------------------------------------------------------------------------
  def get_absolute_rect(index = self.index)
    rect = item_rect(index)
    rect.x += self.x + self.padding
    rect.y += self.y + self.padding
    rect
  end
  #--------------------------------------------------------------------------
  # * Ottiene la bitmap della voce della finestra
  # @param [Integer] ind
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def bitmap_rect(ind = self.index)
    rect = item_rect(ind)
    bitmap = Bitmap.new(rect.x, rect.y)
    bitmap.blt(0, 0, contents, rect)
    bitmap
  end
  #--------------------------------------------------------------------------
  # * Aggiunta di comandi all'handler
  #--------------------------------------------------------------------------
  alias h87_ph process_handling unless $@
  def process_handling
    h87_ph
    return unless open? && active
    return process_left     if handle?(:left)     && Input.repeat?(:LEFT)
    return process_right    if handle?(:right)    && Input.repeat?(:RIGHT)
    return process_function if handle?(:function) && Input.trigger?(:X)
    return process_shift    if handle?(:shift)    && Input.trigger?(:A)
  end
  #--------------------------------------------------------------------------
  # * Controllo dell'handler del movimento del cursore
  #--------------------------------------------------------------------------
  def check_cursor_handler
    return unless open? && active
    return if @last_cursor == self.index
    @last_cursor = self.index
    call_handler(:cursor_move)
  end
  #--------------------------------------------------------------------------
  # * Processo di movimento a sinistra quando è impostato un handler
  #--------------------------------------------------------------------------
  def process_left
    play_switch_sound
    Input.update
    call_left_handler
  end
  #--------------------------------------------------------------------------
  # * Processo movimento a destra
  #--------------------------------------------------------------------------
  def process_right
    play_switch_sound
    Input.update
    call_right_handler
  end
  #--------------------------------------------------------------------------
  # * Aggiunta dell'handler funzione
  #--------------------------------------------------------------------------
  def process_function
    call_handler(:function)
  end
  #--------------------------------------------------------------------------
  # * Aggiunta dell'handler funzione
  #--------------------------------------------------------------------------
  def process_shift
    call_handler(:shift)
  end
  #--------------------------------------------------------------------------
  # * Esecuzione del suono di sinistra/destra
  #--------------------------------------------------------------------------
  def play_switch_sound
    Sound.play_cursor
  end
  #--------------------------------------------------------------------------
  # * Esecuzione dell'handler sinistra
  #--------------------------------------------------------------------------
  def call_left_handler
    call_handler(:left)
  end
  #--------------------------------------------------------------------------
  # * Esecuzione dell'handler destra
  #--------------------------------------------------------------------------
  def call_right_handler
    call_handler(:right)
  end
end

#==============================================================================
# ** classe Bitmap
#------------------------------------------------------------------------------
#  Aggiunta di metodi alla classe Bitmap
#==============================================================================
class Bitmap
  #--------------------------------------------------------------------------
  # * Disegna un'icona nella bitmap
  # @param [Integer] icon_index
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y, enabled = true)
    bitmap = Cache.system('Iconset')
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.blt(x, y, bitmap, rect, enabled ? 255 : 128)
  end
  #--------------------------------------------------------------------------
  # * Returns a glowed bitmap copy
  # @param [Integer] strenght
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def glow(strenght = 2)
    copy = self.clone
    strenght.times{copy.blur}
    copy.blt(0, 0, self, Rect.new(0, 0, copy.width, copy.height))
    copy
  end
  #--------------------------------------------------------------------------
  # * Draws a glowed text
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [String] text
  # @param [Integer] align
  # @param [Integer] glow_str
  # @param [Color] glow_color
  #--------------------------------------------------------------------------
  def draw_glowed_text(x, y, width, height, text, align = 0, glow_str = 2, glow_color = self.font.color)
    padding = [glow_str, 3].min
    src_bitmap = Bitmap.new(width + padding * 2, height + padding * 2)
    rect = Rect.new(0, 0, width + padding*2, height + padding*2)
    src_bitmap.font.name = self.font.name
    src_bitmap.font.color = self.font.color
    src_bitmap.font.shadow = false
    src_bitmap.font.bold = self.font.bold
    src_bitmap.font.italic = self.font.italic
    src_bitmap.font.outline = self.font.outline
    src_bitmap.font.size = self.font.size
    glw_bitmap = src_bitmap.clone
    src_bitmap.draw_text(padding, padding, width, height, text, align)
    glw_bitmap.font.color = glow_color
    glw_bitmap.draw_text(padding, padding, width, height, text, align)
    glow_str.times{glw_bitmap.blur}
    glw_bitmap.blt(0, 0, src_bitmap, rect)
    self.blt(x-padding, y-padding, glw_bitmap, rect)
  end
end

#==============================================================================
# ** Color
#------------------------------------------------------------------------------
# Aggiunta dei colori statici
#==============================================================================
class Color
  alias rgba_initialize initialize unless $@
  #--------------------------------------------------------------------------
  # * Inizializzazione con l'aggiunta di valore esadecimale
  #--------------------------------------------------------------------------
  def initialize(*args)
    if args[0].is_a?(String)
      hex_initialize(*args)
    else
      rgba_initialize(*args)
    end
  end
  #--------------------------------------------------------------------------
  # * Inizializzazione esadecimale
  #--------------------------------------------------------------------------
  def hex_initialize(hex, opacity = 255)
    if hex =~ /^#([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})$/
      red = $1.to_i(16)
      green = $2.to_i(16)
      blue = $3.to_i(16)
      rgba_initialize(red, green, blue, opacity)
    else
      raise HexErrorFormatColorException.new('Errore: Stringa esadecimale non corretta')
    end
  end
  #--------------------------------------------------------------------------
  # * Costanti che restituiscono colori CSS
  #--------------------------------------------------------------------------
  ALICEBLUE             = Color.new('#F0F8FF')
  ANTIQUEWHITE          = Color.new('#FAEBD7')
  AQUA                  = Color.new('#00FFFF')
  AQUAMARINE            = Color.new('#7FFFD4')
  AZURE                 = Color.new('#F0FFFF')
  BEIGE                 = Color.new('#F5F5DC')
  BISQUE                = Color.new('#FFE4C4')
  BLACK                 = Color.new(0,0,0,255)
  BLUE                  = Color.new(0,0,255,255)
  BLUEVIOLET            = Color.new('#8A2BE2')
  BROWN                 = Color.new('#A52A2A')
  BURLYWOOD             = Color.new('#DEB887')
  CADETBLUE             = Color.new('#5F9EA0')
  CHARTREUSE            = Color.new('#7FFF00')
  CHOCOLATE             = Color.new('#D2691E')
  CORAL                 = Color.new('#FF7F50')
  CORNFLOWER_BLUE       = Color.new('#6495ED')
  CORNSILK              = Color.new('#FFF8DC')
  CRIMSON               = Color.new('#DC143C')
  CYAN                  = Color.new('#00FFFF')
  DARKBLUE              = Color.new('#00008B')
  DARKCYAN              = Color.new('#008B8B')
  DARKGOLDENROD         = Color.new('#B8860B')
  DARKGRAY              = Color.new('#A9A9A9')
  DARKGREY              = Color.new('#A9A9A9')
  DARKGREEN             = Color.new('#006400')
  DARKKHAKI             = Color.new('#BDB76B')
  DARKMAGENTA           = Color.new('#8B008B')
  DARKOLIVEGREEN        = Color.new('#556B2F')
  DARKORANGE            = Color.new('#FF8C00')
  DARKORCHID            = Color.new('#9932CC')
  DARKRED               = Color.new('#8B0000')
  DARKSALMON            = Color.new('#E9967A')
  DARKSEAGREEN          = Color.new('#8FBC8F')
  DARKSLATEBLUE         = Color.new('#483D8B')
  DARKSLATEGRAY         = Color.new('#2F4F4F')
  DARKSLATEGREY         = Color.new('#2F4F4F')
  DARKTURQUOISE         = Color.new('#00CED1')
  DARKVIOLET            = Color.new('#9400D3')
  DEEPPINK              = Color.new('#FF1493')
  DEEPSKYBLUE           = Color.new('#00BFFF')
  DIMGRAY               = Color.new('#696969')
  DIMGREY               = Color.new('#696969')
  DODGERBLUE            = Color.new('#1E90FF')
  FIREBRICK             = Color.new('#B22222')
  FLORALWHITE           = Color.new('#FFFAF0')
  FORESTGREEN           = Color.new('#228B22')
  FUCHSIA               = Color.new('#FF00FF')
  GAINSBORO             = Color.new('#DCDCDC')
  GHOSTWHITE            = Color.new('#F8F8FF')
  GOLD                  = Color.new('#FFD700')
  GOLDENROD             = Color.new('#DAA520')
  GRAY                  = Color.new('#808080')
  GREY                  = Color.new('#808080')
  GREEN                 = Color.new('#008000')
  GREENYELLOW           = Color.new('#ADFF2F')
  HONEYDEW              = Color.new('#F0FFF0')
  HOTPINK               = Color.new('#FF69B4')
  INDIANRED             = Color.new('#CD5C5C')
  INDIGO                = Color.new('#4B0082')
  IVORY                 = Color.new('#FFFFF0')
  KHAKI                 = Color.new('#F0E68C')
  LAVENDER              = Color.new('#E6E6FA')
  LAVENDERBLUSH         = Color.new('#FFF0F5')
  LAWNGREEN             = Color.new('#7CFC00')
  LEMONCHIFFON          = Color.new('#FFFACD')
  LIGHTBLUE             = Color.new('#ADD8E6')
  LIGHTCORAL            = Color.new('#F08080')
  LIGHTCYAN             = Color.new('#E0FFFF')
  LIGHTGOLDENRODYELLOW  = Color.new('#FAFAD2')
  LIGHTGRAY             = Color.new('#D3D3D3')
  LIGHTGREY             = Color.new('#D3D3D3')
  LIGHTGREEN            = Color.new('#90EE90')
  LIGHTPINK             = Color.new('#FFB6C1')
  LIGHTSALMON           = Color.new('#FFA07A')
  LIGHTSEAGREEN         = Color.new('#20B2AA')
  LIGHTSKYBLUE          = Color.new('#87CEFA')
  LIGHTSLATEGRAY        = Color.new('#778899')
  LIGHTSLATEGREY        = Color.new('#778899')
  LIGHTSTEELBLUE        = Color.new('#B0C4DE')
  LIGHTYELLOW           = Color.new('#FFFFE0')
  LIME                  = Color.new('#00FF00')
  LIMEGREEN             = Color.new('#32CD32')
  LINEN                 = Color.new('#FAF0E6')
  MAGENTA               = Color.new('#FF00FF')
  MAROON                = Color.new('#800000')
  MEDIUMAQUAMARINE      = Color.new('#66CDAA')
  MEDIUMBLUE            = Color.new('#0000CD')
  MEDIUMORCHID          = Color.new('#BA55D3')
  MEDIUMPURPLE          = Color.new('#9370D8')
  MEDIUMSEAGREEN        = Color.new('#3CB371')
  MEDIUMSLATEBLUE       = Color.new('#7B68EE')
  MEDIUMSPRINGGREEN     = Color.new('#00FA9A')
  MEDIUMTURQUOISE       = Color.new('#48D1CC')
  MEDIUMVIOLETRED       = Color.new('#C71585')
  MIDNIGHTBLUE          = Color.new('#191970')
  MINTCREAM             = Color.new('#F5FFFA')
  MISTYROSE             = Color.new('#FFE4E1')
  MOCCASIN              = Color.new('#FFE4B5')
  NAVAJOWHITE           = Color.new('#FFDEAD')
  NAVY                  = Color.new('#000080')
  OLDLACE               = Color.new('#FDF5E6')
  OLIVE                 = Color.new('#808000')
  OLIVEDRAB             = Color.new('#6B8E23')
  ORANGE                = Color.new('#FFA500')
  ORANGERED             = Color.new('#FF4500')
  ORCHID                = Color.new('#DA70D6')
  PALEGOLDENROD         = Color.new('#EEE8AA')
  PALEGREEN             = Color.new('#98FB98')
  PALETURQUOISE         = Color.new('#AFEEEE')
  PALEVIOLETRED         = Color.new('#D87093')
  PAPAYAWHIP            = Color.new('#FFEFD5')
  PEACHPUFF             = Color.new('#FFDAB9')
  PERU                  = Color.new('#CD853F')
  PINK                  = Color.new('#FFC0CB')
  PLUM                  = Color.new('#DDA0DD')
  POWDERBLUE            = Color.new('#B0E0E6')
  PURPLE                = Color.new('#800080')
  RED                   = Color.new('#FF0000')
  ROSYBROWN             = Color.new('#BC8F8F')
  ROYALBLUE             = Color.new('#4169E1')
  SADDLEBROWN           = Color.new('#8B4513')
  SALMON                = Color.new('#FA8072')
  SANDYBROWN            = Color.new('#F4A460')
  SEAGREEN              = Color.new('#2E8B57')
  SEASHELL              = Color.new('#FFF5EE')
  SIENNA                = Color.new('#A0522D')
  SILVER                = Color.new('#C0C0C0')
  SKYBLUE               = Color.new('#87CEEB')
  SLATEBLUE             = Color.new('#6A5ACD')
  SLATEGRAY             = Color.new('#708090')
  SLATEGREY             = Color.new('#708090')
  SNOW                  = Color.new('#FFFAFA')
  SPRINGGREEN           = Color.new('#00FF7F')
  STEELBLUE             = Color.new('#4682B4')
  TAN                   = Color.new('#D2B48C')
  TEAL                  = Color.new('#008080')
  THISTLE               = Color.new('#D8BFD8')
  TOMATO                = Color.new('#FF6347')
  TURQUOISE             = Color.new('#40E0D0')
  VIOLET                = Color.new('#EE82EE')
  WHEAT                 = Color.new('#F5DEB3')
  WHITE                 = Color.new('#FFFFFF')
  WHITESMOKE            = Color.new('#F5F5F5')
  YELLOW                = Color.new('#FFFF00')
  YELLOWGREEN           = Color.new('#9ACD32')
end

#==============================================================================
# ** HexErrorFormatColorException
#------------------------------------------------------------------------------
#  Eccezione generata artificialmente
#==============================================================================
class HexErrorFormatColorException < Exception; end
#fine dello script