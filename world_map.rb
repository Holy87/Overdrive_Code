module MapConfig
  module_function

  #CONFIGURAZIONE MAPPA PICCOLA
  WORLDMAP_ID = 1 #ID della mappa del mondo
  P_X = 5 #Aggiusta posizione mappa X
  P_Y = 30 #Aggiusta posizione mappa Y
  MINIMAP_PICTURE = 'Mappa piccola' #Nome immagine della mappa
  MAP_SIGNAL = 'Segnalino' #Nome immagine del segnalino
  MAP_TARGET = 'Segnalino3'
  MINIMAP_RATIO = 1 #proporzioni (1 tile = 1 pixel)
  MAP_ITEM_ID = 153 #oggetto mappa posseduto (0 se non necess.)

  #CONFIGURAZIONE MAPPA GRANDE
  M_X = 10 # posizione X nello schermo
  M_Y = 20 # posizione Y nello schermo

  # Pictures
  MAP_PICTURE = 'WorldMap' # Immagine world map
  BACKGROUND_PICTURE = 'Annerisci' # Immagine sfondo
  POINT_PICTURE = 'Segnalino2' # Immagine segnalino
  CIRCLE_PICTURE = 'CerchioMappa' # Immagine cerchio
  TARGET_PICTURE = 'Obiettivo' # Immagine obiettivo
  LOCATION_PICTURE = 'LuogoWM' # Immagine segnalino luogo
  PUSHPIN_PICTURE = 'Segnalino4' # Immagine segnalino missione

  # Altre impostazioni
  BACKGROUND_OPACITY = 150 # Opacità dello sfondo
  TARGET_X_VAR = 95 # Variabile pos. X obiettivo
  TARGET_Y_VAR = 96 # Variabile pos. Y obiettivo
  MAP_RATIO = 2 # Ingrandimento coordinate mappa
  HELP_REDUCTION = 1.0 # Riduzione del testo d'aiuto sulla minimappa
  TARGET_ICON = 813 # Icona obiettivo
  POSITION_ICON = 814 # Icona posizione
  PLACE_ICON = 815 # Icona luogo scelto
  STORY_VAR_ID = 72 # ID variabile storia
  WINDOW_WIDTH = 210 # Larghezza finestra

  # Controlli
  WORLDMAP_KEY = :L # Tasto apertura world map
  HIDE_MAP_KEY = :X # Tasto per nascondere minimap

  # Elenco missione (valore variabile storia con quello che devi fare)
  MISSIONS = {
      0 => '',
      1 => 'Trova qualche altro disperso',
      2 => 'Trova qualche altro disperso. Prova nel pub di Baduelle...',
      3 => 'Trova una chiave per accedere alle caverne di Baltimora.',
      4 => 'Attraversa le caverne di Baltimora', #hyuges
      5 => 'Raggiungi la Torre ad Ovest (puoi rifocillarti prima a Sirenas se vuoi)', #cerantopos
      6 => 'Trova Luisa e cerca di scoprire perché è stata rapita.',
      7 => 'Ottimo lavoro, ora ricongiungi il gruppo!',
      8 => 'È il momento di far fuori il cattivo! Ti aspetta in ufficio...',
      9 => 'Torna da Hyuger e mostra il PC. Potresti passare per il ponte...',
      10 => 'Vai a Sirenas e prendi la nave per Florea.',
      11 => 'Dirigiti a Pigwarts.',
      12 => 'Resta nel castello per questa notte. Le stanze sono nell\'ala Ovest.',
      13 => 'Al mattino, incontra la tua guida nel cortile del castello.',
      14 => 'Per raggiungere Pigwarts devi attraversare i Monti Ciclamini!',
      15 => 'Parla con il rettore dell\'accademia, lo troverai nel suo ufficio.',
      16 => 'Trova Alicia nell\'aula A2.',
      17 => 'Vai a sud, attraversa il fiume e dirigiti nel deserto.',
      18 => 'Incontra i ragazzi sul ponte.',
      19 => 'Raggiungi il barcaiolo per passare "all\'altra sponda".',
      20 => 'Scopri cos\'è successo a Carpia: I cittatini sono nella chiesa.',
      21 => 'Trova un modo per entrare nella villa stregata.',
      22 => 'Addentrati nella villa stregata per liberare i prigionieri.',
      23 => 'Libera le persone imprigionate dopo aver sconfitto il vampiro',
      24 => 'Riparti verso Sud.',
      25 => 'Dirigiti verso il deserto.',
      26 => 'Cerca qualcuno a Faide-Eiba che possa portarti nel deserto.',
      27 => 'Aiuta Erza a tenere a bada i bambini.',
      28 => 'Fatti accompagnare nel deserto Yascha da Erza.',
      29 => 'Trova la tana del Dahaka seguendo i pilastri.',
      30 => 'Trova un modo per fuggire dall\'aereonave.',
      31 => 'Salpa per Balthazar. Puoi andare al porto di Fasbury.',
      32 => 'Trova un modo per ricongiungerti con Monica e gli altri.',
      33 => 'Supera le miniere e dirigiti a Nord.',
      34 => 'Dirigiti a Balthazar, Antonio e Francesco potrebbero essere lì.',
      35 => 'Vai a Balthazar. Monica e gli altri sono già in città.',
      36 => 'Il castello e la città sono in pericolo! Ferma l\'orda!',
      37 => 'Bisogna convocare Reinard. Forse parlando prima con Circe...',
      38 => 'Bisogna conoscere la storia di Eridea: entra nelle rovine di Adele.',
      39 => 'Addentrati fino in fondo all\'antico tempio dove si celano i segreti.',
      40 => 'Una strana ragazza ci ha attaccati: sei nella direzione giusta!',
      41 => 'Quanto è profondo il tempio?',
      42 => 'Prendi la nave da Balthazar, vai a Yugure e incontra il sacerdote Shinji',
      43 => 'Devi trovare un modo per distruggere le torri magiche!',
      44 => 'Raggiungi Nevandra. Se non sai come ci si arriva, puoi chiedere a Reinard...',
      46 => 'Vai verso Nord-Ovest da Balthazar per attraversare la dogana per Nevandra.',
      47 => 'Il passaggio è bloccato, forse c\'è un passaggio ad ovest dalla dogana...',
      48 => 'Attraversa i monti innevati per arrivare a Nevandra.',
      49 => 'Trova un modo per raggiungere Diamantica (e magari capire di più sui "mostri").',
      50 => 'Ora puoi attraversare il bosco per giungere a Diamantica.',
      51 => 'Dirigiti a Diamantica, all\'estremo est di Nevandra.',
      52 => 'Entra nella base di Havoc e trovalo.',
      53 => 'Ora che hai sconfitto Ciop puoi accedere alle porte dipinte di verde.',
      54 => 'Ora puoi accedere anche alle porte blu. Trova Cip per l\'ultima chiave!',
      55 => 'Ora puoi andare da Havoc e dargli ciò che si merita!',
      56 => 'Fuggi dalla base!',
      57 => 'Vai sul ponte di comando.',
      58 => '',

  }
  #ultimi parametri
  #0: niente, 1: città, 2: casa, 3: dungeon, 4: porto
  PLACES = {
      :noplace => [0, 0, 'Nessun luogo', 0],
      :baduelle => [79, 84, 'Baduelle', 1],
      :hyuges => [80, 84, 'Casa di Hyuges', 2],
      :baltimora => [58, 84, 'Caverne di Baltimora', 3],
      :sirenas => [19, 85, 'Sirenas', 1],
      :bejed => [21, 94, 'Torre Bejed', 3],
      :selva => [42, 75, 'Selva di salici', 3],
      :monferras => [31, 36, 'Monferras', 1],
      :florea => [42, 32, 'Castello di Florea', 1],
      :ciclam => [22, 23, 'Monti Ciclamini', 3],
      :pigwarts => [23, 18, 'Pigwarts', 1],
      :carpia => [44, 104, 'Carpia', 1],
      :villa => [35, 106, 'Villa misteriosa', 3],
      :molosud => [47, 106, 'Barca per il sud', 4],
      :faide => [25, 122, 'Faide-Eiba', 1],
      :piramid => [13, 126, 'Piramide Gassosa', 3],
      :fasbury => [48, 142, 'Porto di Fasbury', 4],
      :balthaz => [157, 40, 'Balthazar', 1],
      :balthacast => [157, 39, 'Castello di Balthazar', 1],
      :elmwood => [144, 34, 'Bosco di Elmore', 3],
      :adele => [139, 43, 'Adele', 1],
      :farse => [140, 62, 'Farse', 1],
      :elminer => [145, 66, 'Miniere di Elmore', 3],
      :elporto => [114, 36, 'Attracco', 4],
      :yugure => [149, 141, 'Yugure', 1],
      :kaji => [145, 130, 'Vulcano Kaji', 3],
      :kumo => [147, 144, 'Monte Kumo', 3],
      :yugup => [145, 152, 'Porto di Yugure', 4],
      :dogan => [130, 25, 'Dogana di Elmore', 2],
      :neve => [120, 25, 'Monti innevati', 3],
      :nevandra => [122, 14, 'Nevandra', 1],
      :nevacast => [122, 13, 'Castello di Nevandra', 1],
      :northur => [119, 10, 'Porto di Northur', 4],
      :boscnev => [142, 021, 'Bosco di Nevandra', 3],
      :diamant => [159, 20, 'Diamantica', 3],
      :erm => [98, 19, 'Casa di Jarvas', 2],
      :akaimor => [157, 70, 'Torre Akaimor', 3],
  }

  ICONS = {
      0 => 238, #NULLA
      1 => 1152, #ICONA CITTA\'
      2 => 1155, #ICONA CASA
      3 => 1153, #ICONA DUNGEON
      4 => 1154 #ICONA PORTO
  }
  #--------------------------------------------------------------------------
  # * Restituisce il luogo predefinito
  # @return [Array<Symbol>]
  #--------------------------------------------------------------------------
  def default_place
    [:noplace, :baduelle, :baltimora];
  end

  #--------------------------------------------------------------------------
  # * Restituisce se il party ha l'oggetto per visualizzare la mappa
  #--------------------------------------------------------------------------
  def item_ok?
    return true if MAP_ITEM_ID == 0
    $game_party.has_item?($data_items[MAP_ITEM_ID])
  end
end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
# Vocaboli dello script
#==============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Posizione del giocatore
  #--------------------------------------------------------------------------
  def self.player_position
    'Posizione';
  end

  #--------------------------------------------------------------------------
  # * Prossimo obiettivo
  #--------------------------------------------------------------------------
  def self.target_position
    'Obiettivo';
  end

  #--------------------------------------------------------------------------
  # * Nessuna informazione sul prossimo obiettivo
  #--------------------------------------------------------------------------
  def self.no_info
    'Nessuna informazione disponibile.';
  end

  #--------------------------------------------------------------------------
  # * Segnalino
  #--------------------------------------------------------------------------
  def self.place_position
    'Segnaposto';
  end

  #--------------------------------------------------------------------------
  # * Aiuto mappa
  #--------------------------------------------------------------------------
  def self.wm_tips
    'A: Nascondi    S: Mappa grande';
  end

  #--------------------------------------------------------------------------
  # * Scritta per nascondere
  #--------------------------------------------------------------------------
  def self.minimap_hide
    'Nascondi';
  end

  #--------------------------------------------------------------------------
  # * Scritta per mappa grande
  #--------------------------------------------------------------------------
  def self.go_worldmap
    'Mappa grande';
  end
end

#==============================================================================
# ** Map_Location
#------------------------------------------------------------------------------
# Rappresenta le informazioni della posizione
#==============================================================================
class Map_Location
  # @attr[Integer] map_x
  # @attr[Integer] map_y
  # @attr[String] name
  # @attr[Integer] type
  # @attr[Symbol] place_tag
  attr_accessor :map_x
  attr_accessor :map_y
  attr_accessor :name
  attr_accessor :type
  attr_accessor :place_tag
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Array] location_data
  #--------------------------------------------------------------------------
  def initialize(location_data, place_tag)
    @map_x = location_data[0]
    @map_y = location_data[1]
    @name = location_data[2]
    @type = location_data[3]
    @place_tag = place_tag
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'ID icona del luogo
  # @return [Integer]
  #--------------------------------------------------------------------------
  def icon_index
    MapConfig::ICONS[@type];
  end
end

#==============================================================================
# ** World_Map
#------------------------------------------------------------------------------
# Mappa del mondo
#==============================================================================
class World_Minimap
  include MapConfig
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Viewport] viewport
  #--------------------------------------------------------------------------
  def initialize(viewport)
    @viewport = viewport
    create_map_picture
    create_tips_picture
    create_signal_picture
    create_target_picture
    @opened = false
    @disposed = false
    @counter = 0
  end

  #--------------------------------------------------------------------------
  # * Crea l'immagine della minimappa
  #--------------------------------------------------------------------------
  def create_map_picture
    @picture = Sprite.new(@viewport)
    @picture.bitmap = Cache.picture(MINIMAP_PICTURE)
    @picture.x = P_X; @picture.y = P_Y
    @picture.opacity = 0
  end

  #--------------------------------------------------------------------------
  # * Crea l'immagine dei suggerimenti della minimappa
  #--------------------------------------------------------------------------
  def create_tips_picture
    @tips = Sprite.new(@viewport)
    @tips.bitmap = tip_bitmap(@picture.width * HELP_REDUCTION)
    @tips.x = P_X
    @tips.y = @picture.y - 24 / HELP_REDUCTION
    @tips.z = @picture.z + 1
    @tips.opacity = 0
    ratio = @picture.width.to_f / @tips.width
    @tips.zoom_x = ratio
    @tips.zoom_y = ratio
  end

  #--------------------------------------------------------------------------
  # * Crea l'immagine della posizione del giocatore
  #--------------------------------------------------------------------------
  def create_signal_picture
    @segnal = Sprite.new(@viewport)
    @segnal.bitmap = Cache.picture(MAP_SIGNAL)
    center(@segnal)
    @segnal.opacity = 0
  end

  #--------------------------------------------------------------------------
  # * Crea l'immagine del segnalino
  #--------------------------------------------------------------------------
  def create_target_picture
    @target = Sprite.new(@viewport)
    @target.bitmap = Cache.picture(MAP_TARGET)
    center(@target)
    @target.opacity = 0
  end

  #--------------------------------------------------------------------------
  # * Centra ox e oy dello sprite
  # @param [Sprite] sprite
  #--------------------------------------------------------------------------
  def center(sprite)
    sprite.ox = sprite.width / 2
    sprite.oy = sprite.height / 2
  end

  #--------------------------------------------------------------------------
  # * Restituisce la bitmap d'aiuto
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def tip_bitmap(width)
    bit = basic_bitmap(width, 24)

    # creazione dello sfondo
    bit.fill_rect(2, 2, bit.width - 4, bit.height - 4, Color.new(0, 0, 0, 128))
    bit.blur

    text_width = width / 2 - 24
    text_height = bit.height

    # scrittura primo comando
    bit.draw_key_icon(HIDE_MAP_KEY, 0, 0)
    bit.draw_text(24, 0, text_width, text_height, Vocab.minimap_hide)

    # scrittura secondo comando
    bit.draw_key_icon(WORLDMAP_KEY, width / 2, 0)
    bit.draw_text(width / 2 + 24, 0, text_width, text_height, Vocab.go_worldmap)

    bit
  end

  #--------------------------------------------------------------------------
  # * Restituisce una bitmap con settaggi della grafica d'aiuto
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def basic_bitmap(width, height)
    bmp = Bitmap.new(width, height)
    bmp.font.color = Color.new(255, 255, 255)
    bmp.font.size = 15
    bmp.font.shadow = true
    bmp.font.bold = false
    bmp.font.italic = false
    bmp
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    return unless @opened
    @picture.update
    #update_picture
    update_position
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la picture
  #--------------------------------------------------------------------------
  def update_picture
    return unless @opened
    return if @picture.zoom_y >= 1
    @picture.zoom_y += 0.1
  end

  #--------------------------------------------------------------------------
  # * Flash della picture
  #--------------------------------------------------------------------------
  def flash
    @picture.flash(Color.new(255, 0, 0, 200), 5)
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la posizione
  #--------------------------------------------------------------------------
  def update_position
    @counter += 1
    player = $game_player
    tg = $game_system.selected_place
    if tg != nil
      @target.x = adx(tg.map_x)
      @target.y = ady(tg.map_y)
    else
      @target.opacity = 0
    end
    @segnal.x = adx(player.x)
    @segnal.y = ady(player.y)
    case @counter
    when 6
      @target.opacity = 0
      @segnal.opacity = 0
    when 12
      @target.opacity = 255 if tg != nil
      @segnal.opacity = 255
      @counter = 0
    else
      # type code here
    end
  end

  #--------------------------------------------------------------------------
  # * Aggiusta la coordinata X del cursore giocatore
  #--------------------------------------------------------------------------
  def adx(x)
    x * MINIMAP_RATIO + P_X
  end

  #--------------------------------------------------------------------------
  # * Aggiusta la coordinata Y del cursore del giocatore
  #--------------------------------------------------------------------------
  def ady(y)
    y * MINIMAP_RATIO + P_Y
  end

  #--------------------------------------------------------------------------
  # * Apertura della minimappa
  #--------------------------------------------------------------------------
  def open
    return if @disposed
    @opened = true
    @segnal.opacity = 255
    @picture.opacity = 255
    @counter = 0
    @tips.opacity = 255
    update
  end

  #--------------------------------------------------------------------------
  # * Chiusura della minimappa
  #--------------------------------------------------------------------------
  def close
    return if @disposed
    @opened = false
    @tips.opacity = 0
    @segnal.opacity = 0
    @picture.opacity = 0
    @target.opacity = 0
  end

  #--------------------------------------------------------------------------
  # * Cancellazione della minimappa
  #--------------------------------------------------------------------------
  def dispose
    @disposed = true
    @picture.dispose
    @segnal.dispose
    @tips.dispose
    @target.dispose
  end
end

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
# Aggiunta dello sprite della minimappa
#==============================================================================
class Spriteset_Map
  alias add_cr_world create_timer unless $@
  alias add_up_world update unless $@
  alias add_ds_world dispose unless $@
  #--------------------------------------------------------------------------
  # * Inserisco la minimappa nel processo di creazione del timer
  #--------------------------------------------------------------------------
  def create_timer
    add_cr_world
    create_world_map
  end

  #--------------------------------------------------------------------------
  # * Fai un flash alla mappa del mondo (quando compare un nemico)
  #--------------------------------------------------------------------------
  def flash_worldmap
    @world_map.flash;
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    add_up_world
    update_world_map
  end

  #--------------------------------------------------------------------------
  # * Cancellazione
  #--------------------------------------------------------------------------
  def dispose
    dispose_world_map
    add_ds_world
  end

  #--------------------------------------------------------------------------
  # * Crea la minimappa del mondo
  #--------------------------------------------------------------------------
  def create_world_map
    @world_map = World_Minimap.new(@viewport2)
    open_world_map
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la minimappa
  #--------------------------------------------------------------------------
  def update_world_map
    @world_map.update
  end

  #--------------------------------------------------------------------------
  # * Cancella la minimappa
  #--------------------------------------------------------------------------
  def dispose_world_map
    @world_map.dispose
  end

  #--------------------------------------------------------------------------
  # * Apri la minimappa
  #--------------------------------------------------------------------------
  def open_world_map
    @world_map.open if MapConfig.item_ok? and in_world_map? and $game_system.worldmap_settings
  end

  #--------------------------------------------------------------------------
  # * Chiudi la minimappa
  #--------------------------------------------------------------------------
  def close_world_map
    @world_map.close;
  end

  #--------------------------------------------------------------------------
  # * Restitituisce l'ID della mappa del mondo
  #--------------------------------------------------------------------------
  def worldmap_id
    MapConfig::WORLDMAP_ID;
  end

  #--------------------------------------------------------------------------
  # * Determina se il giocatore si trova nella mappa del mondo
  #--------------------------------------------------------------------------
  def in_world_map?
    worldmap_id == $game_map.map_id;
  end
end

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
# Aggiunta delle impostazioni della minimappa
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Cambia le impostazioni di visualizzazione della minimap
  #--------------------------------------------------------------------------
  def worldmap_settings_change
    @worldmap_settings = true if @worldmap_settings.nil?
    @worldmap_settings = !@worldmap_settings
  end

  #--------------------------------------------------------------------------
  # * Restituisce le impostazioni di visualizzazione della minimap
  #--------------------------------------------------------------------------
  def worldmap_settings
    @worldmap_settings = true if @worldmap_settings.nil?
    @worldmap_settings
  end

  #--------------------------------------------------------------------------
  # * Sblocca una locazione (inserire il simbolo)
  # @param [Symbol] place
  #--------------------------------------------------------------------------
  def unlock_place(place)
    @known_places ||= MapConfig.default_place
    @known_places.push(place) unless @known_places.include?(place)
  end

  #--------------------------------------------------------------------------
  # * determina se un posto della mappa è sbloccato
  #--------------------------------------------------------------------------
  def place_unlocked?(place)
    @known_places.include?(place)
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'array dei posti conosciuti
  # @return [Array<Map_Location>]
  #--------------------------------------------------------------------------
  def places_unlocked
    @known_places ||= MapConfig.default_place
    @known_places.collect { |place|
      Map_Location.new(MapConfig::PLACES[place], place)
    }
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'array dei posti conosciuti in simboli
  # @return [Array<Symbol>]
  #--------------------------------------------------------------------------
  def symbols_places_unlocked
    @known_places ||= MapConfig.default_place
    @known_places
  end

  #--------------------------------------------------------------------------
  # * Seleziona una locazione per visualizzarla
  # @param [Symbol, Map_Location] place
  #--------------------------------------------------------------------------
  def select_place(place)
    if place.is_a?(Map_Location)
      @selected_place = place.place_tag
    else
      @selected_place = place
    end
  end

  #--------------------------------------------------------------------------
  # * Restituisce la locazione selezionata
  # @return [Map_Location]
  #--------------------------------------------------------------------------
  def selected_place
    places_unlocked.find { |place|
      place.place_tag == @selected_place
    }
  end

  #--------------------------------------------------------------------------
  # * Cancella la locazione selezionata
  #--------------------------------------------------------------------------
  def unselect_place
    @selected_place = nil;
  end

  #--------------------------------------------------------------------------
  # * Imposta un suggerimento
  #--------------------------------------------------------------------------
  def worldtip=(string)
    ; @worldtip = string;
  end

  #--------------------------------------------------------------------------
  # * Restituisce il suggerimento
  # @return [String]
  #--------------------------------------------------------------------------
  def worldtip
    @worldtip;
  end
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
# Mostra la minimappa
#==============================================================================
class Scene_Map < Scene_Base
  alias wm_init start unless $@
  alias wm_upd update unless $@
  #--------------------------------------------------------------------------
  # * Mostra la minimappa
  #--------------------------------------------------------------------------
  def show_worldmap
    @spriteset.open_world_map;
  end

  #--------------------------------------------------------------------------
  # * Nascondi la minimappa
  #--------------------------------------------------------------------------
  def hide_worldmap
    @spriteset.close_world_map;
  end

  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    wm_init
    if in_worldmap and $game_system.worldmap_settings
      show_worldmap
    end
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    wm_upd
    update_map_commands
  end

  #--------------------------------------------------------------------------
  # * Aggiorna input comandi mappa
  #--------------------------------------------------------------------------
  def update_map_commands
    return if $game_map.interpreter.running?
    switch_map if Input.trigger?(MapConfig::HIDE_MAP_KEY)
    show_big_map if Input.trigger?(MapConfig::WORLDMAP_KEY)
  end

  #--------------------------------------------------------------------------
  # * Determina se sei nella worldmap
  #--------------------------------------------------------------------------
  def in_worldmap
    return false unless $game_map.map_id == MapConfig::WORLDMAP_ID
    MapConfig.item_ok?
  end

  #--------------------------------------------------------------------------
  # * Vai alla schermata della worldmap
  #--------------------------------------------------------------------------
  def show_big_map
    return unless in_worldmap
    Sound.play_decision
    SceneManager.call(Scene_Worldmap)
  end

  #--------------------------------------------------------------------------
  # * Mostra / Nascondi minimappa
  #--------------------------------------------------------------------------
  def switch_map
    return unless in_worldmap
    RPG::SE.new('Book').play
    $game_system.worldmap_settings_change
    $game_system.worldmap_settings ? show_worldmap : hide_worldmap
  end
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
# Impostazioni della worldmap
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Mostra la worldmap
  #--------------------------------------------------------------------------
  def show_worldmap
    SceneManager.scene.show_worldmap if SceneManager.scene.is_a?(Scene_Map)
  end

  #--------------------------------------------------------------------------
  # * Nascondi la worldmap
  #--------------------------------------------------------------------------
  def hide_worldmap
    SceneManager.scene.hide_worldmap if SceneManager.scene.is_a?(Scene_Map)
  end
end

#==============================================================================
# ** Scene_Worldmap
#------------------------------------------------------------------------------
# Schermata della mappa del mnondo in grande
#==============================================================================
class Scene_Worldmap < Scene_MenuBase
  include MapConfig
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_other_background
    create_variables
    create_pictures
    create_windows
  end

  #--------------------------------------------------------------------------
  # * Creazione delle variabili d'istanza
  #--------------------------------------------------------------------------
  def create_variables
    @flag = false
    @target_x = adx($game_variables[TARGET_X_VAR])
    @target_y = ady($game_variables[TARGET_Y_VAR])
  end

  #--------------------------------------------------------------------------
  # * Creazione delle immagini
  #--------------------------------------------------------------------------
  def create_pictures
    create_background
    create_map
    create_positions
  end

  #--------------------------------------------------------------------------
  # * Creazione dello sfondo secondario
  #--------------------------------------------------------------------------
  def create_other_background
    @background = Sprite.new
    @background.bitmap = Cache.picture(BACKGROUND_PICTURE)
    @background.opacity = BACKGROUND_OPACITY
    @background.z = 10
  end

  #--------------------------------------------------------------------------
  # * Adatta la coordinata X sulla figura
  #--------------------------------------------------------------------------
  def adx(n)
    ; n * MAP_RATIO + M_X;
  end

  #--------------------------------------------------------------------------
  # * Adatta la coordinata Y sulla figura
  #--------------------------------------------------------------------------
  def ady(n)
    ; n * MAP_RATIO + M_Y;
  end

  #--------------------------------------------------------------------------
  # * Creazione dell'immagine della mappa
  #--------------------------------------------------------------------------
  def create_map
    @map = Sprite.new
    @map.bitmap = Cache.picture(MAP_PICTURE)
    @map.x = M_X
    @map.y = M_Y
    @map.z = 11
  end

  #--------------------------------------------------------------------------
  # * Crea i cursori di posizione
  #--------------------------------------------------------------------------
  def create_positions
    create_player_position
    create_target_position
    create_select_position
    create_object_position
  end

  #--------------------------------------------------------------------------
  # * Crea la posizione del giocatore
  #--------------------------------------------------------------------------
  def create_player_position
    player = $game_player
    @position = Sprite.new
    @position.bitmap = Cache.picture(POINT_PICTURE)
    center_im(@position)
    @position.x = adx(player.x)
    @position.y = ady(player.y)
    @position.z = 12
    @circlep = Sprite.new
    @circlep.bitmap = Cache.picture(CIRCLE_PICTURE)
    center_im(@circlep)
    @circlep.z = 13
    @circlep.blend_type = 1
    @circlep.x = @position.x
    @circlep.y = @position.y
    @circlep.zoom_x = 0
    @circlep.zoom_y = 0
  end

  #--------------------------------------------------------------------------
  # * Crea la posizione dell'obiettivo
  #--------------------------------------------------------------------------
  def create_target_position
    @target = Sprite.new
    return if no_target
    @target.bitmap = Cache.picture(TARGET_PICTURE)
    center_im(@target)
    @target.x = @target_x
    @target.y = @target_y
    @target.z = 14
  end

  #--------------------------------------------------------------------------
  # * Crea l'immagine della posizione del luogo selezionato
  #--------------------------------------------------------------------------
  def create_select_position
    @selected = Sprite.new
    @selected.bitmap = Cache.picture(PUSHPIN_PICTURE)
    center_im(@selected)
    @selected.z = 15
    place_selected
  end

  #--------------------------------------------------------------------------
  # * Piazza il luogo selezionato nelle giuste coordinate
  #--------------------------------------------------------------------------
  def place_selected
    place = $game_system.selected_place
    if place.nil?
      @selected.opacity = 0
    else
      @selected.opacity = 255
      @selected.x = adx(place.map_x)
      @selected.y = ady(place.map_y)
    end
  end

  #--------------------------------------------------------------------------
  # *  Crea gli oggetti di posizione
  #--------------------------------------------------------------------------
  def create_object_position
    @location = Sprite.new
    @location.bitmap = Cache.picture(LOCATION_PICTURE)
    center_im(@location)
    @location.z = 16
    @circlel = Sprite.new
    @circlel.tone.set(255, 0, 0)
    @circlel.blend_type = 1
    @circlel.bitmap = Cache.picture(CIRCLE_PICTURE)
    center_im(@circlel)
    @circlel.z = 16
    place_object
  end

  #--------------------------------------------------------------------------
  # * Piazza il cursore di posizione
  #--------------------------------------------------------------------------
  def place_object
    if @places_window.nil?
      hide_object
      return
    end
    place = @places_window.item
    if place.type == 0
      hide_object
      return
    end
    visible_before = @location.opacity == 255
    @location.opacity = 255
    if visible_before
      @location.smooth_move(adx(place.map_x), ady(place.map_y))
    else
      @location.x = adx(place.map_x)
      @location.y = ady(place.map_y)
    end
    @circlel.x = adx(place.map_x)
    @circlel.y = ady(place.map_y)
  end

  #--------------------------------------------------------------------------
  # * Nascondi il cursore di posizione
  #--------------------------------------------------------------------------
  def hide_object
    @location.opacity = 0
    @circlel.opacity = 0
  end

  #--------------------------------------------------------------------------
  # * Imposta il centro dello sprite
  #--------------------------------------------------------------------------
  def center_im(sprite)
    sprite.ox = sprite.width / 2
    sprite.oy = sprite.height / 2
  end

  #--------------------------------------------------------------------------
  # * Crea le finestre
  #--------------------------------------------------------------------------
  def create_windows
    create_legend_window
    create_mission_window
    create_places_window
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra della legenda
  #--------------------------------------------------------------------------
  def create_legend_window
    @legend_window = Window_Legend.new
    @legend_window.x = Graphics.width - @legend_window.width
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra della lista dei luoghi conosciuti
  #--------------------------------------------------------------------------
  def create_places_window
    y = @legend_window.y + @legend_window.height
    height = Graphics.height - @mission_window.height - @legend_window.height
    @places_window = Window_PlaceList.new(y, height)
    @places_window.set_handler(:ok, method(:place_selection))
    @places_window.set_handler(:cancel, method(:return_scene))
    @places_window.activate
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra di missione
  #--------------------------------------------------------------------------
  def create_mission_window
    @mission_window = Window_Mission.new(0, 0)
    @mission_window.y = Graphics.height - @mission_window.height
  end

  #--------------------------------------------------------------------------
  # * Nessun obiettivo di missione?
  #--------------------------------------------------------------------------
  def no_target
    return false if $game_variables[TARGET_X_VAR] != 0
    true
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_positions
  end

  #--------------------------------------------------------------------------
  # * Seleziona la posizione per aggiungerla alla mappa
  #--------------------------------------------------------------------------
  def place_selection
    switch_location
    place_selected
    @places_window.refresh
    @places_window.activate
  end

  #--------------------------------------------------------------------------
  # * Cambia la posizione
  #--------------------------------------------------------------------------
  def switch_location
    place = @places_window.item
    if place.type == 0
      $game_system.unselect_place
    elsif place.place_tag == $game_system.selected_place
      $game_system.unselect_place
    else
      $game_system.select_place(place.place_tag)
    end
  end

  #--------------------------------------------------------------------------
  # * Aggiorna le posizioni
  #--------------------------------------------------------------------------
  def update_positions
    update_player_position
    update_target_position
    update_object_position
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la posizione del giocatore
  #--------------------------------------------------------------------------
  def update_player_position
    update_circle(@circlep)
  end

  #--------------------------------------------------------------------------
  # * Aggiorna il cerchietto di posizione
  #--------------------------------------------------------------------------
  def update_circle(circle)
    circle.opacity -= 10
    circle.zoom_x += 0.04
    circle.zoom_y += 0.04
    if circle.zoom_x > 3
      circle.opacity = 255
      circle.zoom_x = 0.0
      circle.zoom_y = 0.0
    end
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la posizione dell'obiettivo
  #--------------------------------------------------------------------------
  def update_target_position
    return if no_target
    @target.opacity -= 20 if @flag
    @target.opacity += 20 unless @flag
    @flag = true if @target.opacity >= 250
    @flag = false if @target.opacity <= 50
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la posizione del cerchio dell'obiettivo
  #--------------------------------------------------------------------------
  def update_object_position
    place_object
    update_circle(@circlel) unless @places_window.item.type == 0
    @location.update
  end

  #--------------------------------------------------------------------------
  # * Chiusura
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_map
    dispose_positions
    dispose_background
  end

  #--------------------------------------------------------------------------
  # * Eliminazione dello sfondo secondario
  #--------------------------------------------------------------------------
  def dispose_background
    @background.dispose;
  end

  #--------------------------------------------------------------------------
  # * Eliminazione della mappa
  #--------------------------------------------------------------------------
  def dispose_map
    @map.dispose;
  end

  #--------------------------------------------------------------------------
  # * Eliminazione dei segnalini
  #--------------------------------------------------------------------------
  def dispose_positions
    @position.dispose
    @circlep.dispose
    @target.dispose
    @location.dispose
    @circlel.dispose
    @selected.dispose
  end
end

#==============================================================================
# ** Window_Legend
#------------------------------------------------------------------------------
# Semplice legenda
#==============================================================================
class Window_Legend < Window_Base
  include MapConfig
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, fitting_height(3))
    refresh
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_icon(POSITION_ICON, 0, 0)
    draw_text(24, 0, contents_width, line_height, Vocab.player_position)
    draw_icon(TARGET_ICON, 0, line_height)
    draw_text(24, line_height, contents_width, line_height, Vocab.target_position)
    draw_icon(PLACE_ICON, 0, line_height * 2)
    draw_text(24, line_height * 2, contents_width, line_height, Vocab.place_position)
  end

  #--------------------------------------------------------------------------
  # * Larghezza della finestra
  #--------------------------------------------------------------------------
  def window_width
    WINDOW_WIDTH;
  end
end

#==============================================================================
# ** Window_Mission
#------------------------------------------------------------------------------
# Finestra che mostra la prossima missione
#==============================================================================
class Window_Mission < Window_Base
  include MapConfig
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, Graphics.width, fitting_height(1))
    refresh
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text(0, 0, contents_width, line_height, get_mission)
  end

  #--------------------------------------------------------------------------
  # * Restituisce il testo della missione
  # @return[String]
  #--------------------------------------------------------------------------
  def get_mission
    if $game_system.worldtip.nil?
      missiontext = MISSIONS[$game_variables[STORY_VAR_ID]]
    else
      missiontext = $game_system.worldtip
    end
    return Vocab.no_info if missiontext == nil
    missiontext
  end
end

#==============================================================================
# ** Window_WorldCommand
#------------------------------------------------------------------------------
# Finestra dei comandi della schermata
#==============================================================================
class Window_PlaceList < Window_Selectable
  include MapConfig
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(y, height)
    make_item_list
    super(Graphics.width - window_width, y, window_width, height)
    refresh
    self.index = 0
  end

  #--------------------------------------------------------------------------
  # * Ottiene la lista dei luoghi
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_system.places_unlocked;
  end

  #--------------------------------------------------------------------------
  # * Larghezza della finestra
  #--------------------------------------------------------------------------
  def window_width
    WINDOW_WIDTH;
  end

  #--------------------------------------------------------------------------
  # * Get Digit Count
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max
    1;
  end

  #--------------------------------------------------------------------------
  # * Get Number of Items
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1;
  end

  #--------------------------------------------------------------------------
  # * Restituisce la posizione selezionata
  # @return [Map_Location]
  #--------------------------------------------------------------------------
  def item
    @data[@index];
  end

  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    item = @data[index]
    draw_icon(item.icon_index, rect.x, rect.y)
    color = active_location?(index) ? crisis_color : normal_color
    change_color(color)
    rect.width -= 24; rect.x += 24
    draw_text(rect, item.name)
  end

  #--------------------------------------------------------------------------
  # * Determina se il giocatore ha marchiata la posizione in index
  #--------------------------------------------------------------------------
  def active_location?(index)
    return false if $game_system.selected_place.nil?
    $game_system.selected_place.place_tag == @data[index].place_tag
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
# Aggiunta dei comandi evento per aggiungere luoghi
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Aggiungi un luogo
  #--------------------------------------------------------------------------
  def add_place(place)
    $game_system.unlock_place(place)
  end

  #--------------------------------------------------------------------------
  # * Imposta un consiglio
  #--------------------------------------------------------------------------
  def set_worldtip(string)
    $game_system.worldtip = string
  end

  #--------------------------------------------------------------------------
  # * Cancella il consiglio
  #--------------------------------------------------------------------------
  def delete_worldtip
    $game_system.worldtip = nil
  end
end