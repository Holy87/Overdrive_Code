require File.expand_path 'rm_vx_data'


module H87_BattleBackground
  module_function

  Areas = {
      0 => :grass,
      1 => :grass,
      2 => :forest,
      3 => 'Caverna2',
      4 => 'Torre',
      5 => 'Ponte',
      6 => :forest,
      7 => :tower_outs,
      8 => 'Casa1',
      9 => :mountains,
      10 => 'Espers',
      11 => 'Nave',
      12 => 'NaveInt',
      13 => 'Villaggio2',
      14 => 'Castello',
      15 => :desert,
      16 => 'Airship',
      17 => 'Panda',
      18 => 'Miniere',
      20 => 'Casa Stregata',
      21 => 'Background Green',
      22 => 'Piramidi',
      23 => :sewers,
      24 => 'città',
      25 => :castle,
      26 => :castle_outs,
      27 => 'Trono',
      28 => 'Adele',
      29 => 'Rovine',
      30 => 'Tempio',
      31 => 'Caverna',
      32 => 'Lava1',
      33 => 'Lava2',
      34 => 'Demoni',
      35 => 'CavernaGhiaccio',
      36 => 'NevandraNotte',
      37 => 'Porto Neve',
      38 => 'Neve',
      39 => 'ForestaNeve',
      40 => 'Diamantica',
      41 => 'Base',
      42 => :wastelands
  }

  def get_tile(id)
    case id
      #Tile A1
      when 2048..2095 #Mare
        return 'BluMare' #Colore che andrà ad usare (vedi in basso)
      when 2096..2143 #Oceano
        return 'BluScuro'
      when 2144..2191 #Scogli
        return 'BluMare'
      when 2192..2239 #Iceberg
        return 'BluMare'
      when 2240..2287 #Fiume
        return 'BluMare'
      when 2288..2335 #Cascata
        return 'BluMare'
      when 2336..2383 #Vasca
        return 'Lava'
      when 2384..2431 #Ruscello
        return 'Lava'
      when 2432..2479 #Corso d'acqua
        return 'BluMare'
      when 2480..2527 #Ruscello
        return 'BluMare'
      when 2528..2575 #Vasca artificiale
        return 'BluMare'
      when 2576..2623 #Ruscello
        return 'BluMare'
      when 2624..2671 #Fogne
        return 'BluMare'
      when 2672..2719 #Cascata fogne
        return 'BluMare'
      when 2720..2767 #Lava
        return 'Lava'
      when 2768..2815 #Cascata lavica
        return 'Lava'

      #Tile A2
      when 2816..2863 #Pianure mappa del mondo
        return :grass
      when 2864..2911 #Foreste
        return :forest
      when 2912..2959 #Montagne
        return :mountains
      when 2960..3007 #Erba delle mappe chiuse
        return :grass
      when 3008..3055 #Erba alta
        return :rough_grass
      when 3056..3103 #Recinto di legno
        return :grass
      when 3104..3151 #Mulattiere
        return :grass
      when 3152..3199 #Tavolo di legno
        return :grass
      when 3200..3247 #Terre aride
        return :wastelands
      when 3248..3295 #Alberi secchi
        return :wastelands
      when 3296..3343 #Montagne rocciose
        return :wastelands
      when 3344..3391 #Terra interiore
        return :wastelands
      when 3392..3439 #Steppe aride
        return :wastelands
      when 3440..3487 #Recinto di pietra
        return :wastelands
      when 3488..3535 #Tappeto di stoffa
        return :grass
      when 3536..3583 #Tavolo di noce
        return :grass
      when 3584..3631 #Deserto
        return :desert
      when 3632..3679 #Palme desertiche
        return :desert
      when 3680..3727 #Montagne desertiche
        return :mountains
      when 3728..3775 #Sabbia
        return :desert
      when 3776..3823 #Oasi
        return :desert
      when 3824..3871 #Recinto del deserto
        return :desert
      when 3872..3919 #Tappeto rosso
        return :grass
      when 3920..3967 #Tavolo di marmo
        return :grass
      when 3968..4015 #Neve
        return :snow
      when 4016..4063 #Foresta innevata
        return :snow_forest
      when 4064..4111 #Monti innevati
        return :snow_mountains
      when 4112..4159 #Passaggio innevato
        return :rock
      when 4160..4207 #Steppa innevata
        return :rock
      when 4208..4255 #Recinto innevato
        return :rock
      when 4256..4303 #Pavimento di marmo
        return :grass
      else
        return nil
    end
  end

  ADVANCED_BACKGROUNDS = {
      #pictures:    Immagini di sfondo del frame. Se è un array, vengono
      #             presi tutti e ruotati
      #frame_speed: La velocità di rotazione dei frame, ogni x frame.
      #opacity:     Ovviamente, opacità. Da 0 a 255.
      #start_x:     posizione x iniziale
      #start_y:     posizione y iniziale
      #move_x:      movimento coordinata x, velocità 1/100 di frame
      #move_y:      movimento coordinata y, velocità 1/100 di frame
      #wave_amp:    ampiezza onda
      #wave_length: lunghezza onda
      #wave_speed:  velocità onda
      #mirror:      specchio
      #blend:       tipo blending (0: normale, 1: aggiungi, 2: sottrai)
      #zoom_x:      zoom (1.0 = 100%, 2.0 = 200%, 0.5 = 50%)
      #zoom_y:      come zoom_x, ma altezza
      #tone:        Array di tonalità (ad es. [255,0,50,32])
      #pulse_speed: velocità di pulsazione (opaco-trasparente)
      #pulse_min:   opacità minima da raggiungere
      #pulse_max:   opacità massima da raggiungere
      #move_x e move_y non compatibili con wave, start_x e start_y perché diventa
      #un plane!
      :grass      =>[ {:pictures => 'Erba'},
                      {:pictures => 'Nuvole3', :move_x => -1},
                      {:pictures => 'Nuvole2', :move_x => -5},
                      {:pictures => 'Nuvole1', :move_x => -7},
                      {:pictures => 'Nuvole3', :move_x => -1, :start_x => 640},
                      {:pictures => 'Nuvole2', :move_x => -5, :start_x => 640},
                      {:pictures => 'Nuvole1', :move_x => -7, :start_x => 640}],

      :forest     =>[ {:pictures => 'Forest'}],
      # terre aride con nuvole che si muovono
      :wastelands =>[ {:pictures => 'wastelands_bottom'},
                      {:pictures => 'wastelands_mid'},
                      {:pictures => 'Nuvole3', :move_x => -1},
                      {:pictures => 'Nuvole2', :move_x => -5},
                      {:pictures => 'Nuvole1', :move_x => -7},
                      {:pictures => 'Nuvole3', :move_x => -1, :start_x => 640},
                      {:pictures => 'Nuvole2', :move_x => -5, :start_x => 640},
                      {:pictures => 'Nuvole1', :move_x => -7, :start_x => 640},
                      {:pictures => 'wastelands_top'}],
      :desert     => [{:pictures => 'desert_bottom'},
                      {:pictures => 'desert_blur', :opacity => 50, :wave_amp => 8, :wave_length => 11, :wave_speed => 40, :wave_phase => 0},
                      {:pictures => 'desert_blur', :opacity => 50, :wave_amp => 8, :wave_length => 10, :wave_speed => 40, :wave_phase => 100},
                      {:pictures => 'desert_blur', :opacity => 50, :wave_amp => 8, :wave_length => 9,  :wave_speed => 40, :wave_phase => 200},
                      {:pictures => 'desert_blur2', :opacity => 100, :wave_amp => 12, :wave_length => 9,  :wave_speed => 40, :wave_phase => 200},
                      {:pictures => 'Nuvole3', :move_x => -1},
                      {:pictures => 'Nuvole2', :move_x => -5}],
      :rough_grass=> [{:pictures => 'Erba Alta'}],
      :mountains  => [{:pictures => 'Montagna'}],
      :castle_outs=> [{:pictures => 'dark_sky', :move_x => 10},
                      {:pictures => 'dark_sky', :move_x => 10, :start_x => -640},
                      {:pictures => 'red_cloud1', :move_x => 15, :opacity => 50},
                      #{:pictures => 'red_cloud2', :move_x => 20, :opacity => 50},
                      {:pictures => 'red_cloud3', :move_x => 30, :opacity => 50},
                      {:pictures => 'red_cloud1', :move_x => 15, :opacity => 50, :start_x => -640},
                      #{:pictures => 'red_cloud2', :move_x => 20, :opacity => 50, :start_x => -640},
                      {:pictures => 'red_cloud3', :move_x => 30, :opacity => 50, :start_x => -640},
                      #{:pictures => 'light_alone'},
                      {:pictures => 'castle_wall'},
                      {:pictures => %w(castle_torch1 castle_torch2 castle_torch3), :frame_speed => 10}],
      :sewers     => [{:pictures => 'sewer_water', :start_x => -35, :wave_amp => 10, :wave_length => 150, :wave_speed => 200},
                      {:pictures => 'sewer_back'},
                      {:pictures => 'sewer_dirt', :start_y => 324, :start_x => -5, :wave_amp => 5, :wave_length => 120},
                      {:pictures => %w(sew_torch1 sew_torch2 sew_torch3), :frame_speed => 10},
                      {:pictures => %w(zoccola1 zoccola2 zoccola3 zoccola4), :start_y => 148, :start_x => -1000, :move_x => 200, :re_x => -2000, :frame_speed => 5},
                      {:pictures => %w(bottle1 bottle2), :start_y => 410, :start_x => 540, :re_x => 100, :move_x => -25, :frame_speed => 50}],
      :tower_outs => [{:pictures => 'dark_sky', :move_x => 10},
                      {:pictures => 'dark_sky', :move_x => 10, :start_x => -640},
                      {:pictures => 'dark_cloud1', :move_x => 20, :start_y => -300, :re_x => -1368, :start_x => -1368, :opacity => 100},
                      {:pictures => 'dark_cloud1', :move_x => 20, :start_y => -300, :start_x => -2736, :re_x => -1368, :opacity => 100},
                      {:pictures => 'dark_cloud2', :move_x => 40, :re_x => -160, :start_y => -100, :opacity => 100},
                      {:pictures => 'dark_cloud2', :move_x => 40, :re_x => -160, :start_y => -100, :start_x => -800, :opacity => 100},
                      {:pictures => 'tower_ground'},
                      {:pictures => 'dark_cloud3', :move_x => 80, :re_x => -160, :start_y => -100, :start_x => -400, :opacity => 100},
                      {:pictures => 'dark_cloud3', :move_x => 80, :re_x => -160, :start_y => -100, :start_x => 400, :opacity => 100},
                      {:pictures => 'dark_cloud2', :move_x => 40, :re_x => -160, :start_y => 260, :opacity => 100},
                      {:pictures => 'dark_cloud2', :move_x => 40, :re_x => -160, :start_y => 260, :start_x => -800, :opacity => 100},
                      {:pictures => 'dark_cloud3', :move_x => 80, :re_x => -160, :start_y => 320, :start_x => -400, :opacity => 100},
                      {:pictures => 'dark_cloud3', :move_x => 80, :re_x => -160, :start_y => 320, :start_x => 400, :opacity => 100},],


  }
  #Variabile di selezione sfondo battaglia
  BATTLEGROUND_VARIABLE = 5
  #Mappe che hanno la selezione automatica dello sfondo (tramite tile)
  AUTO_BG_MAPS = [1,2]
end

#===============================================================================
# ** Spriteset_Battle
#-------------------------------------------------------------------------------
# Classe che gestisce le immagini di battaglia (e quindi lo sfondo)
#===============================================================================
class Spriteset_Battle
  include H87_BattleBackground
  attr_reader :background_name
  alias custom_bg_create_battleback create_battleback unless $@
  alias custom_bg_create_battlefloor create_battlefloor unless $@
  #--------------------------------------------------------------------------
  # * Creazione dello sfondo di battaglia
  #--------------------------------------------------------------------------
  def create_battleback
    if use_default_bg?
      custom_bg_create_battleback
    else
      create_custom_bg
    end
  end
  #--------------------------------------------------------------------------
  # * Creazione del pavimento di battaglia
  # noinspection RubyResolve
  #--------------------------------------------------------------------------
  def create_battlefloor
    custom_bg_create_battlefloor
    unless use_default_bg?
      @battlefloor_sprite.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # * È impostato uno sfondo di battaglia personalizzato?
  #--------------------------------------------------------------------------
  def custom_bg_set?; $game_variables[BATTLEGROUND_VARIABLE] >= 0; end
  #--------------------------------------------------------------------------
  # * Si trova in una mappa con sfondo battaglia per tile?
  #--------------------------------------------------------------------------
  def in_auto_background_map?; AUTO_BG_MAPS.include?($game_map.map_id); end
  #--------------------------------------------------------------------------
  # * Si deve utilizzare lo sfondo di battaglia predefinito in VX?
  #--------------------------------------------------------------------------
  def use_default_bg?; !(custom_bg_set? or in_auto_background_map?); end
  #--------------------------------------------------------------------------
  # * Creazione dello sfondo battaglia personalizzato
  #--------------------------------------------------------------------------
  def create_custom_bg
    if in_auto_background_map?
      background = get_tile_background
    else
      background = get_variable_background(BATTLEGROUND_VARIABLE)
    end
    create_battleground(background)
  end
  #--------------------------------------------------------------------------
  # * Ottiene lo sfondo dal tile dov'è situato l'eroe
  #--------------------------------------------------------------------------
  def get_tile_background
    x = $game_player.x
    y = $game_player.y
    tile = get_tile($game_map.data[x, y, 1]) #prova con layer 1
    tile = get_tile($game_map.data[x, y, 0]) if tile == nil
    if tile.nil?
      print('Errore: Nessun background impostato per tile ' + tile.to_s)
    end
    tile
  end
  #--------------------------------------------------------------------------
  # * Restituisce lo sfondo battaglia da un valore
  #--------------------------------------------------------------------------
  def get_variable_background(value)
    Areas[$game_variables[value]]
  end
  #--------------------------------------------------------------------------
  # * Creazione dello sfondo battaglia personalizzato.
  #   Se è incluso tra quelli animati, crea quello animato. Altrimenti carica
  #   un'immagine.
  #   background_name: nome dello sfondo battaglia
  # @param [String] background_name
  #--------------------------------------------------------------------------
  def create_battleground(background_name)
    @background_name = background_name
    if ADVANCED_BACKGROUNDS.include?(background_name)
      @battleback_sprite = animated_background(background_name, @viewport1)
    else
      @battleback_sprite = Sprite.new(@viewport1)
      @battleback_sprite.bitmap = Cache.battleback(background_name.to_s)
    end
  end
  #--------------------------------------------------------------------------
  # * Crea lo sfondo di battaglia animato
  # @param [String] name
  # @param [Viewport] viewport
  # @return [Animated_Background]
  #--------------------------------------------------------------------------
  def animated_background(name, viewport = nil)
    backg = ADVANCED_BACKGROUNDS[name]
    if backg.is_a?(Array)
      Animated_Background.new(backg, viewport)
    else
      eval(sprintf('%s.new', backg))
    end
  end
  #--------------------------------------------------------------------------
  # * Cambia lo sfondo di gioco
  # @param [String] new_background
  # @param [Integer] transition_time
  # @param [String] graphic
  #--------------------------------------------------------------------------
  def change_background(new_background, transition_time = 40, graphic = 'Trans11')
    Graphics.freeze
    @battleback_sprite.dispose
    create_battleground(new_background)
    Graphics.transition(transition_time, "Graphics/System/#{graphic}")
  end
  #--------------------------------------------------------------------------
  # * Cambia lo sfondo di gioco da qualsiasi punto
  # @param [String] new_background
  # @param [Integer] transition_time
  # @param [String] graphic
  #--------------------------------------------------------------------------
  def self.change_background(new_background, transition_time = 40, graphic = 'Trans11')
    return unless $game_temp.in_battle
    $scene.spriteset.change_background(new_background, transition_time, graphic)
  end
  #--------------------------------------------------------------------------
  # * Cambia lo sfondo di gioco da qualsiasi punto conservando il vecchio sfondo
  # @param [String] new_background
  # @param [Integer] transition_time
  # @param [String] graphic
  #--------------------------------------------------------------------------
  def self.switch_background(new_background, transition_time = 40, graphic = 'Trans11')
    return unless $game_temp.in_battle
    @old_background = $scene.spriteset.background_name
    $scene.spriteset.change_background(new_background, transition_time, graphic)
  end
  #--------------------------------------------------------------------------
  # * Ripristina il vecchio sfondo di battaglia
  # @param [Integer] transition_time
  # @param [String] graphic
  #--------------------------------------------------------------------------
  def self.reset_background(transition_time = 40, graphic = 'Trans11')
    return unless $game_temp.in_battle
    return unless @old_background
    $scene.spriteset.change_background(@old_background, transition_time, graphic)
    @old_background = nil
  end
  #--------------------------------------------------------------------------
  # * Override del metodo
  #--------------------------------------------------------------------------
  def dispose_battleback_bitmap; end
end

#===============================================================================
# ** Animated_Background
#-------------------------------------------------------------------------------
# Classe che contiene gli sfondi animati
#===============================================================================
class Animated_Background
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #   pictures_array: Array di hash che specificano i layer delle immagini
  #   viewport: (facoltativo) viewport assegnato
  # @param [Array] pictures_array
  # @param [Viewport] viewport
  #--------------------------------------------------------------------------
  def initialize(pictures_array, viewport = nil)
    @components = []
    create_pictures(pictures_array)
    create_veil
    self.viewport = viewport if viewport
  end
  #--------------------------------------------------------------------------
  # * Crea tutti i componenti animati
  #--------------------------------------------------------------------------
  def create_pictures(array)
    (0..array.size-1).each {|i|
      @components.push(Animated_Sprite.new(array[i], i))
    }
  end
  #--------------------------------------------------------------------------
  # * Crea il velo per inscurire il paesaggio
  #--------------------------------------------------------------------------
  def create_veil
    @veil = Sprite.new
    bitmap = Bitmap.new(Graphics.width, Graphics.height)
    bitmap.fill_rect(0, 0, bitmap.width, bitmap.height, Color.new(0,0,0))
    @veil.bitmap = bitmap
    @veil.opacity = 0
    @veil.z = 500
    @new_opacity = nil
    @timing = 0
  end
  #--------------------------------------------------------------------------
  # * Scurisce l'ambiente secondo un valore definito (usato per skill)
  #--------------------------------------------------------------------------
  def set_opacity(new_opacity, speed = 60)
    @veil.fade(new_opacity, speed, false)
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    @components.each{|comp|comp.update}
    @veil.update
  end
  #--------------------------------------------------------------------------
  # * Eliminazione
  #--------------------------------------------------------------------------
  def dispose
    @components.each{|comp|comp.dispose}
    @veil.dispose
  end
  #--------------------------------------------------------------------------
  # * Assegnazione del viewpoer (viene aggiunto a tutti gli elementi)
  #   new_viewport: nuovo viewport
  #--------------------------------------------------------------------------
  def viewport=(new_viewport)
    @components.each{|comp|comp.viewport=new_viewport}
    @veil.viewport = new_viewport
  end
  #--------------------------------------------------------------------------
  # * Gestione del print
  #--------------------------------------------------------------------------
  def to_s
    ret = 'Animated_Background elementi:'
    @components.each{|component|
      ret += sprintf('\n%s, z:%d', component.picture_name, component.z)
    }
  end
end #animated backgrond

#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  Aggiunta del modulo per caricare i battlebacks
#==============================================================================
module Cache
  #--------------------------------------------------------------------------
  # * Returns the windowskin bitmap
  # @param [String] filename
  # @param [String] path
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def self.battleback(filename, path = 'Graphics/Battlebacks/')
    load_bitmap(path, filename)
  end
end #cache

#===============================================================================
# ** Animated_Sprite
#-------------------------------------------------------------------------------
# Classe che gestisce i frame animati del campo di battaglia
#===============================================================================
class Animated_Sprite
  # @attr [Picture] picture
  # @attr [Array<String>] bitmaps
  attr_reader :picture_name   # => Nome della picture
  attr_accessor :picture      # => Oggetto immagine (Sprite o Plane)
  attr_accessor :type         # => Tipo immagine (:sprite o :plane)
  attr_accessor :bitmaps      # => Array di nomi di frame
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Hash] data_hash
  #--------------------------------------------------------------------------
  def initialize(data_hash, z)
    @type = get_type(data_hash)
    @picture = @type == :sprite ? Sprite.new : Plane.new
    @picture.z = z
    @bitmaps = get_bitmaps(data_hash[:pictures])
    @picture_name = data_hash[:pictures].to_s
    @picture.blend_type = data_hash[:blend] if data_hash[:blend]
    @picture.opacity = data_hash[:opacity] if data_hash[:opacity]
    @picture.tone = get_tone(data_hash[:tone]) if data_hash[:tone]
    if data_hash[:pulse_min] || data_hash[:pulse_max]
      min = data_hash[:pulse_min].nil? ? 0 : data_hash[:pulse_min]
      max = data_hash[:pulse_max].nil? ? 255 : data_hash[:pulse_max]
      speed = data_hash[:pulse_speed].nil? ? 10 : data_hash[:pulse_speed]
      @picture.pulse(min, max, speed)
    end
    if @type == :sprite
      set_data_sprite(data_hash)
    else
      set_data_plane(data_hash)
    end
    set_frame
    @frame_speed = 1
    @frame_speed = data_hash[:frame_speed] if data_hash[:frame_speed]
    @frame_state = 0
  end
  #--------------------------------------------------------------------------
  # * Restituisce il tipo (:sprite o :plane)
  # @param [Hash]
  # @return [Symbol]
  #--------------------------------------------------------------------------
  def get_type(data_hash)
    :sprite if data_hash
    #return :sprite if data_hash[:move_x].nil? && data_hash[:move_y].nil?
    #:plane
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se è uno Sprite, false se è un Plane
  #--------------------------------------------------------------------------
  def is_sprite?; @type == :sprite; end
  #--------------------------------------------------------------------------
  # * Ottiene l'array dei nomi delle immagini
  #   pics: immagini configurate in Array<String> contenenti i nomi
  # @param [Array] pics
  # @return [Array]
  #--------------------------------------------------------------------------
  def get_bitmaps(pics)
    return [] if pics.nil?
    return pics if pics.is_a?(Array)
    [pics]
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di frame attuale
  #--------------------------------------------------------------------------
  def frame_number; @bitmaps.size; end
  #--------------------------------------------------------------------------
  # * Imposta gli attributi dello Sprite
  #   data_hash: hash di
  # @param [Hash] data_hash
  #--------------------------------------------------------------------------
  def set_data_sprite(data_hash)
    @picture.mirror = true if data_hash[:mirror]
    @picture.x = data_hash[:start_x] if data_hash[:start_x]
    @picture.y = data_hash[:start_y] if data_hash[:start_y]
    @start_x = data_hash[:re_x] ? data_hash[:re_x] : 0
    @start_y = data_hash[:re_y] ? data_hash[:re_y] : 0
    @picture.wave_amp = data_hash[:wave_amp] if data_hash[:wave_amp]
    @picture.wave_length = data_hash[:wave_length] if data_hash[:wave_length]
    @picture.wave_speed = data_hash[:wave_speed] if data_hash[:wave_speed]
    @picture.wave_phase = data_hash[:wave_phase] if data_hash[:wave_phase]
    @x_speed = data_hash[:move_x] ? data_hash[:move_x] : 0
    @y_speed = data_hash[:move_y] ? data_hash[:move_y] : 0
    @x_state = 0
    @y_state = 0
  end
  #--------------------------------------------------------------------------
  # * Imposta gli attributi del Plane
  #   data_hash: hash di dati
  # @param [Hash] data_hash
  #--------------------------------------------------------------------------
  def set_data_plane(data_hash)
    @picture.x_speed = data_hash[:move_x] if data_hash[:move_x]
    @picture.y_speed = data_hash[:move_y] if data_hash[:move_y]
  end
  #--------------------------------------------------------------------------
  # * Imposta il viewport della grafica
  #   new_viewport: nuovo viewport
  # @param [Viewport] new_viewport
  #--------------------------------------------------------------------------
  def viewport=(new_viewport)
    @picture.viewport = new_viewport
  end
  #--------------------------------------------------------------------------
  # * Eliminazione
  #--------------------------------------------------------------------------
  def dispose; @picture.dispose; end
  #--------------------------------------------------------------------------
  # * Imposta il numero di frame.
  #   new_frame: nuovo frame. Se superiore al numero massimo, viene adattato
  #--------------------------------------------------------------------------
  def set_frame(new_frame = 0)
    return if frame_number == 0
    @frame = new_frame%frame_number
    @picture.bitmap = Cache.battleback(@bitmaps[@frame])
    @frame_state = 0
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    @picture.update
    update_picture_placement
    update_frames
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della coordinata X in movimento
  #--------------------------------------------------------------------------
  def update_x
    @x_state += @x_speed
    @picture.x += (@x_state/100)
    @x_state = @x_state % 100
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della coordinata Y in movimento
  #--------------------------------------------------------------------------
  def update_y
    @y_state += @y_speed
    @picture.y += (@y_state/100)
    @y_state = @y_state % 100
  end
  #--------------------------------------------------------------------------
  # * Aggiorna i movimenti dello Sprite
  #--------------------------------------------------------------------------
  def update_picture_placement
    return if @x_speed == 0 and @y_speed == 0
    update_x
    update_y
    if @x_speed > 0 and @picture.x >= Graphics.width
      @picture.x = 0 - @picture.width + (@start_x < 0 ? @start_x : 0)
    elsif @x_speed < 0 and @picture.right_x < 0
      @picture.x = Graphics.width + (@start_x > Graphics.width ? @start_x : 0)
    end
    if @y_speed > 0 and @picture.y > Graphics.height
      @picture.y = 0 - @picture.height + (@start_y < 0 ? @start_y : 0)
    elsif @y_speed < 0 and @picture.y < 0
      @picture.y = Graphics.height + (@start_y > Graphics.height ? @start_y : 0)
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento dei frame
  #--------------------------------------------------------------------------
  def update_frames
    @frame_state += 1
    set_frame(@frame + 1) if @frame_state >= @frame_speed
  end
end

#===============================================================================
# ** Plane
#===============================================================================
class Plane; attr_accessor :viewport; end