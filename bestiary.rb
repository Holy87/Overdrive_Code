#==============================================================================
# ** BestiaryConfig
#------------------------------------------------------------------------------
#  Configurazione del bestiario
#==============================================================================
module BestiaryConfig
  # Tipi di mostri. Imposta le categorie per il bestiario
  BOSS_TYPES = {0 => [:mid, "Boss medi"],
                1 => [:boss, "Boss"],
                2 => [:domination, "Dominazioni"]
  }

  NORMAL = "Normali"
  ALL = "Tutti"
  COMPLETED = "Completamento"
  ENEMYNAME = "Nome"
  ENEMYTYPE = "Tipo"
  ENEMYLEVEL = "Livello"
  ENEMYDEFT = "Sconfitti"
  ENEMYEXP = "Esperienza"
  ENEMYAP = "Punti Abilità"
  ENEMYGOLD = "Monete"
  NOTYPE = "Nessuno"
  DESCRIPT = "Informazioni"
  NODESCRIPT = "Nessuna informazione."
  NOPOSITION = "Pos. sconosciuta"
  STAT_RES = "Resistenze stati alterati"
  ITEM_DROP = "Oggetti rilasciati"
  ITEM_STEAL = "ruba"
  GOLD_ROBBERY = 'Puoi rubare %d %s'

  #Condizioni
  CON_HP = "PV tra %d%% e %d%%"
  CON_MP = "PM tra %d%% e %d%%"
  CON_ST = "quando ha %s"
  CON_PL = "quando sei a livello %d"

  ACTIONS = ["Attacco normale", "Difesa", "Fuga", "Attesa"]

  WORLDMAP_ID = 1
  MAPNAME = "Mappa Piccola"

  VOCAB_PAGES = {:overview => "Generale",
                 :stats => "Parametri",
                 :skills => "Abilità",
                 :drops => "Oggetti"
  }

  DAMAGE_TYPES = "Efficacia danni"
  ELEMENTS = "Elementi"
  ELEMENTS_PER_ROW = 2
  ATTACK_TYPE = "Tipo Attacco"

  ICON_RATE = [9, 96, 912, 913, 914, 915, 916, 917]
  TEXT_RATE = ["2X", "+50%", "Norm", "½", "0", "Ass. 50%", "Ass. 100%"]

  STATES = [1, 2, 3, 4, 5, 6, 7, 8, 13, 14, 15, 16, 21, 28, 87, 93, 94, 113, 115, 130, 131, 132, 133,
            134, 135, 136, 137]

  ST_RATE = [94, 96, 450, 451, 452, 453, 454, 455]

  ELE_RANKS_TYPES = {
      17 => "Umano", 18 => "Insetto", 19 => "Belva", 20 => "Drago", 21 => "Non morto",
      22 => "Volatile", 23 => "Rettile", 24 => "Pianta", 25 => "Artefatto"
  }

  STATS = [
      #parametro  scritta       icona
      [:maxhp, "Max PV", 1008],
      [:maxmp, "Max PM", 1009],
      [:atk, "Attacco", 1010],
      [:def, "Difesa", 1011],
      [:spi, "Spirito", 1012],
      [:agi, "Velocità", 1013],
      [:hit, "Mira", 1015],
      [:eva, "Evasione", 1016],
      [:cri, "Critici", 1014],
  ]

  #~   PHYSICAL_ATTR = {1,2,3,4,5,6}
  #~   ELEMENT_ATTR = [7,8,9,10,11,12,13,14,15,16]

  TYPETAG = /<tipo:[ ]*(.+)>/i
  INFOTAG = /<desc:[ ]*(.+)>/i
  POSTAG = /<posizione:[ ]*(\d+)[ ]*,[ ]*(\d+)>/i
  HIDETAG = /<nascosto>/i
  LEVEL = /<level:[ ]*(\d+)/i


  UNKNOWNCHAR = '?'
  BESTIARYORDER = [1, 31, 2, 33, 3..15, 17..30, 34..44, 57, 45..88, 113, 114, 89..112, 115..137, 16]

  PAGEFX = RPG::SE.new("Book", 80, 125)


  # Restituisce le categorie dei nemici
  def self.categories
    cat = {-2 => [:all, ALL], -1 => [:normal, NORMAL]}.merge(BOSS_TYPES).sort
    categories = []
    cat.each do |item|
      categories.push(Item_Category.new(item[1][0], item[1][1]))
    end
    return categories
  end

  # Restituisce il numero di categorie
  def self.number;
    BOSS_TYPES.size + 2;
  end

  # Restituisce l'array dei nemici
  # @return [Array<Number>]
  def self.get_enemy_array
    enemies = []
    BESTIARYORDER.each { |enemy|
      case enemy
      when Range #se è un range
        enemies += enemy.to_a
      when Integer #se è un intero
        enemies.push(enemy)
      else
        # type code here
      end
    }
    enemies
  end
end #configurazione

#==============================================================================
# ** ItemDrop
#------------------------------------------------------------------------------
#  Classe d'appoggio per semplificare i drop dei nemici
#==============================================================================
class ItemDrop
  # @return [RPG::BaseItem] item
  attr_accessor :item #oggetto
  attr_accessor :probability #probabilità
  # Inizializzazione
  #     item: oggetto (item, armor, weapon o intero se oro)
  #     probability: valore di probabilità, con la virgola
  # @param [RPG::BaseItem] item
  # @param [Number] probability
  def initialize(item, probability)
    @item = item
    @probability = probability
  end
end #itemdrop

#==============================================================================
# ** RPG::Enemy
#------------------------------------------------------------------------------
#  Aggiunta degli attributi per il bestiario
#==============================================================================
class RPG::Enemy
  attr_reader :type #tipo
  attr_reader :description #descrizione
  attr_reader :hidden_best #nascosto dal bestiario
  attr_reader :map_position #posizione della mappa
  attr_reader :level
  # Caricamento delle informazioni
  def load_bestiary_info
    return if @bestiary_loaded
    @bestiary_loaded = true
    @type = :normal
    @level = 1
    @map_position = []
    @description = BestiaryConfig::NODESCRIPT
    @hidden_best = false
    self.note.split(/[\n\r]+/).each do |line|
      case line
      when BestiaryConfig::TYPETAG
        @type = $1.to_sym
      when BestiaryConfig::INFOTAG
        @description = $1
      when BestiaryConfig::HIDETAG
        @hidden_best = true
      when BestiaryConfig::POSTAG
        @map_position.push([$1.to_i, $2.to_i])
      when BestiaryConfig::LEVEL
        @level = $1.to_i
      else
        # niente
      end
    end
  end

  # Caricamento delle informazioni
  def cri
    self.has_critical ? 10 : 1
  end

  # Restituisce la statistica dal simbolo
  def get_stat(symbol)
    method(symbol).call
  end

  # Restituisce il tipo del nemico (umano, non morto ecc...)
  # noinspection RubyYardReturnMatch
  # @return [String]
  def enemy_type
    enemy_types.map { |type| type.singular_name } * '/'
  end

  # determina se l'oggetto viene droppato dal nemico
  # @param [RPG::Item] item
  def drops_item?(item)
    items = drop_items.map {|drop_item| drop_item.item}
    items.include? item
  end

  # Restituisce true se l'oggetto può essere rubato
  #     item: oggetto da rubare
  # @param [RPG::BaseItem] item
  def can_steal_item?(item)
    items = steals.map {|steal| steal.item}
    items.include? item
  end

  # Restituisce true se il nemico ha l'oggetto da droppare o rubare
  #     item: oggetto
  # @param [RPG::BaseItem] item
  def has_item?(item)
    return true if drops_item?(item)
    return true if can_steal_item?(item)
    false
  end
end

#rpg::enemy

class RPG::Skill
  def hide_from_bestiary?
    self.note =~ /<hide bestiary>/mi
  end
end

#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  Aggiunta del caricamento degli attributi
#==============================================================================
class Scene_Title < Scene_Base
  # Alias di load_database
  alias hbest_agg_load_database load_database unless $@

  def load_database
    hbest_agg_load_database
    load_bestiary_info
  end

  # Caricamento delle informazioni sul bestiario
  def load_bestiary_info
    $data_enemies.each { |enemy|
      next if enemy.nil?
      enemy.load_bestiary_info
    }
  end
end #scene_title

#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  alias no_best_process_victory process_victory unless $@

  # processo di vittoria
  def process_victory
    add_defeated_enemies
    no_best_process_victory
  end

  # aggiunge i nemici sconfitti al bestiario
  def add_defeated_enemies
    $game_troop.dead_members.each { |enemy| $game_party.add_enemy_defeated(enemy.enemy_id) }
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Per aggiungere lo stato dei nemici sconfitti
#==============================================================================
class Game_Party < Game_Unit
  # Restituisce i nemici sconfitti
  # @return [Array<RPG::Enemy>]
  def defeated_enemies
    defeated_enemy_ids.map {|enemy_id| $data_enemies[enemy_id]}
  end

  # restituisce i nemici incontrati
  # @return [Array<RPG::Enemy>]
  def known_enemies
    defeated_enemies
  end

  # Restituisce i nemici sconfitti per ID
  # @return [Array<Integer>]
  def defeated_enemy_ids
    @defeated_enemies_count ||= {}
    @defeated_enemies_count.keys.sort
    #@defeated_enemies ||= BestiaryConfig.get_enemy_array
  end

  # Restituisce Il numero di nemici uccisi per un certo tipo
  #     enemy_id: id nemico
  def defeated_enemies_count(enemy_id)
    @defeated_enemies_count ||= {}
    return 0 if @defeated_enemies_count[enemy_id].nil?
    @defeated_enemies_count[enemy_id]
  end

  # Aggiunge un nemico a quelli sconfitti
  #     enemy_id: id nemico
  #     number: numero di nemici sconfitti
  def add_enemy_defeated(enemy_id, number = 1)
    return if enemy_id.nil?
    #if defeated_enemy_ids[enemy_id].nil?
    #  @defeated_enemies.push(enemy_id)
    #  @defeated_enemies.sort
    #end
    @defeated_enemies_count = {} if @defeated_enemies_count.nil?
    if @defeated_enemies_count[enemy_id].nil?
      @defeated_enemies_count[enemy_id] = 1
    else
      @defeated_enemies_count[enemy_id] += number
    end
    enemy = $data_enemies[enemy_id]
    enemy.enemy_types.each {|type| add_defeated_enemy_type(type.id, number)}
  end

  # restituisce il numero di nemici sconfitti
  # per un determinato tipo (ad es. 19: belva)
  def defeated_enemies_type_count(type_id)
    @defeated_enemy_types ||= {}
    @defeated_enemy_types[type_id] || 0
  end

  # aggiunge un nemico sconfitto al tipo
  def add_defeated_enemy_type(enemy_type, number = 1)
    total = defeated_enemies_type_count(enemy_type)
    @defeated_enemy_types[enemy_type] = total + number
  end

  # Restituisce se un dato nemico è nel bestiario
  #     enemy_id: id nemico
  def known_enemy?(enemy_id)
    defeated_enemy_ids.include?(enemy_id)
  end
end #game_party

#==============================================================================
# ** Scene_Bestiary
#------------------------------------------------------------------------------
#  Schermata del bestiario che chiama tutte le finestre
#==============================================================================
class Scene_Bestiary < Scene_MenuBase
  # initializzazione
  def initialize(menu_index = 0)
    $game_temp.last_menu_index = menu_index
  end

  # Inizio
  def start
    super
    create_main_viewport
    create_category_window
    create_enemy_list_window
    create_info_window
    create_bestiary_window
  end

  # Aggiornamento
  def update
    super
    @viewport.update
  end

  # Chiusura
  def terminate
    super
    @viewport.dispose
  end

  # Creazione della finestra delle categorie
  def create_category_window
    @category_window = Window_EnemyCategory.new(0, 0)
  end

  # Creazione della lista dei nemici
  def create_enemy_list_window
    y = 0 #@category_window.height + @category_window.y
    h = Graphics.height - y - 80
    @enemy_list_window = Window_EnemyList.new(0, y, 180, h)
    @category_window.set_list(@enemy_list_window)
    @enemy_list_window.set_category_window(@category_window)
    @enemy_list_window.viewport = @viewport
  end

  # Creazione della finestra delle informazioni
  def create_info_window
    y = @enemy_list_window.y
    x = @enemy_list_window.width
    @info_window = Window_EnemyInfo.new(x, y, Graphics.width - x, Graphics.height - y)
    @enemy_list_window.set_info_window(@info_window)
    @category_window.z = 9999
    @info_window.viewport = @viewport
  end

  # Creazione della finestra delle informazioni del bestiario
  def create_bestiary_window
    y = @enemy_list_window.height
    w = @enemy_list_window.width
    @bestiary_window = Window_BestiaryInfo.new(0, y, w)
    @bestiary_window.viewport = @viewport
  end
end #scene_bestiary

#==============================================================================
# ** Window_Category
#------------------------------------------------------------------------------
#  Finestra che mostra le categorie del bestiario
#==============================================================================
class Window_EnemyCategory < Window_Category
  # Metodo astratto per i dati
  def default_data
    BestiaryConfig.categories
  end
end #window_category

#==============================================================================
# ** Window_EnemyList
#------------------------------------------------------------------------------
#  Mostra l'elenco dei nemici visti
#==============================================================================
class Window_EnemyList < Window_List
  # refresh
  def refresh
    get_items
    create_contents
    draw_items
  end

  # Ottiene i dati
  def get_data
    @data = []
    BestiaryConfig.get_enemy_array.each do |enemy_id|
      next if enemy_id.nil?
      enemy = $data_enemies[enemy_id]
      next if enemy.nil? || enemy.name == ""
      next if enemy.hidden_best
      if @category == :all
        @data.push(enemy)
      else
        @data.push(enemy) if enemy.type == @category
      end
    end
  end

  # Disegna l'oggetto
  #     index: indice dell'oggetto
  def draw_item(index)
    rect = item_rect_for_text(index)
    self.contents.clear_rect(rect)
    item = @data[index]
    if $game_party.known_enemy?(item.id)
      self.contents.font.color.alpha = 255
      self.draw_text(rect.x, rect.y, rect.width, line_height, item.name)
    else
      self.contents.font.color.alpha = 128
      str = item.name.gsub(/\w/, BestiaryConfig::UNKNOWNCHAR)
      self.draw_text(rect.x, rect.y, rect.width, line_height, str)
    end
  end
end #enemy_list

#==============================================================================
# ** Window_BestiaryInfo
#------------------------------------------------------------------------------
#  Mostra le informazioni sul bestiario
#==============================================================================
class Window_BestiaryInfo < Window_Base
  # Inizializzazione
  def initialize(x, y, w)
    h = Graphics.height - y
    super(x, y, w, h)
    refresh
  end

  # Refresh
  def refresh
    self.contents.clear
    self.change_color(system_color)
    self.draw_text(0, 0, contents.width, line_height, BestiaryConfig::COMPLETED, 1)
    self.change_color(normal_color)
    text = sprintf("%d/%d", $game_party.defeated_enemies.size, BestiaryConfig.get_enemy_array.size)
    self.draw_text(0, line_height, contents.width, line_height, text, 1)
  end
end #bestiaryinfo

#==============================================================================
# ** Window_EnemyInfo
#------------------------------------------------------------------------------
#  Mostra le informazioni su un nemico
#==============================================================================
class Window_EnemyInfo < Window_DataInfo
  # Inizializzazione
  def initialize(x, y, w, h)
    super(x, y, w, h)
    @known_stats = {}
    @pages = [:overview, :stats, :skills, :drops]
  end

  # Imposta il nemico da visualizzare
  #     enemy: RPG::Enemy
  def set_item(enemy)
    enemy = nil unless $game_party.known_enemy?(enemy.id)
    super(enemy)
  end

  # Restituisce il nemico impostato
  # @return [RPG::Enemy]
  def enemy;
    @item;
  end

  # Restituisce il nemico impostato
  # @return [RPG::Enemy]
  def item;
    @item;
  end

  # Ottiene il nome della pagina
  # @param [String] symbol
  def page_name(symbol)
    BestiaryConfig::VOCAB_PAGES[symbol]
  end

  # Disegna il contenuto delle informazioni a seconda della pagina
  def draw_content
    change_color normal_color
    case selected_page
    when :overview;
      draw_overview_content
    when :stats;
      draw_stats_content
    when :skills;
      draw_skills_content
    when :drops;
      draw_drops_content
    else #nulla
    end
  end

  # Disegna le informazioni di base
  def draw_overview_content
    rectw = 192
    draw_enemy_graphic(0, line_height, rectw, rectw)
    draw_enemy_name(0, rectw + line_height, rectw, line_height * 2)
    draw_enemy_killed(0, rectw + line_height * 3, rectw)
    draw_enemy_info(rectw + 20, line_height, contents.width - rectw - 20)
    draw_enemy_description(0, rectw + line_height * 5, contents.width, contents.height - rectw - line_height * 5)
    draw_enemy_position(rectw + 10, line_height * 6)
  end

  # Disegna la grafica del nemico
  def draw_enemy_graphic(x, y, width, height)
    contents.fill_rect(x, y, width, height, sc2)
    contents.fill_rect(x + 2, y + 2, width - 4, height - 4, sc1)
    battler_bitmap = Cache.battler(enemy.battler_name, enemy.battler_hue)
    rw = battler_bitmap.width
    rh = battler_bitmap.height
    if rw > width
      rw = width
      rh = (rh * width) / battler_bitmap.width
    end
    if rh > height
      rh = height
      rw = (rw * height) / battler_bitmap.height
    end
    rx = x + (width - rw) / 2
    ry = y + (height - rh) / 2
    rect = Rect.new(rx, ry, rw, rh)
    contents.stretch_blt(rect, battler_bitmap, battler_bitmap.rect)
  end

  # Disegna il nome del nemico
  def draw_enemy_name(x, y, width, height)
    change_color(system_color)
    draw_text(x, y, width, height, enemy.name)
    change_color(normal_color)
  end

  def draw_enemy_killed(x, y, width)
    change_color system_color
    draw_text(x, y, width, line_height, BestiaryConfig::ENEMYDEFT)
    change_color normal_color
    draw_text(x, y, width, line_height, $game_party.defeated_enemies_count(enemy.id), 2)
  end

  # Disegna tutte le informazioni di base
  def draw_enemy_info(x, y, width)
    (1..5).each { |i|
      contents.gradient_fill_rect(x, y + line_height * i, width, 1, Color.new(0, 0, 0, 128), Color.new(0, 0, 0, 0))
    }
    change_color(system_color)
    draw_text(x + 4, y, width, line_height, BestiaryConfig::ENEMYTYPE)
    draw_text(x, y + line_height, width, line_height, BestiaryConfig::ENEMYLEVEL)
    draw_text(x, y + line_height * 2, width, line_height, BestiaryConfig::ENEMYEXP)
    draw_text(x, y + line_height * 3, width, line_height, BestiaryConfig::ENEMYAP)
    draw_text(x, y + line_height * 4, width, line_height, BestiaryConfig::ENEMYGOLD)
    change_color(normal_color)
    draw_text(x, y, width, line_height, enemy.enemy_type, 2)
    draw_text(x, y + line_height, width, line_height, enemy.level, 2)
    draw_text(x, y + line_height * 2, width, line_height, enemy.exp, 2)
    draw_text(x, y + line_height * 3, width, line_height, enemy.jp, 2)
    draw_text(x, y + line_height * 4, width, line_height, enemy.gold, 2)
  end

  # Disegna la mappa con la posizione del nemico
  def draw_enemy_position(x, y)
    map = Cache.picture(BestiaryConfig::MAPNAME)
    contents.blt(x, y, map, map.rect)
    if enemy.map_position.size == 0 && get_area_array.size == 0
      change_color(power_down_color)
      draw_text(x, y, map.rect.width, map.rect.height, BestiaryConfig::NOPOSITION, 1)
      change_color(normal_color)
    else
      get_area_array.each { |area|
        change_bitmap_color(area, x, y)
      }
      enemy.map_position.each { |position|
        xx = x + position[0] - 1
        yy = y + position[1] - 1
        draw_map_position(xx, yy)
      }
    end
  end

  # Cambia una porzione di schermo in un altro colore senza cancellarne il
  #   contenuto precedente
  #     rect: rettangolo di base
  #     x, y: posizione spostata rispetto all'origine
  def change_bitmap_color(rect, x, y)
    xx = x + rect.x
    xy = y + rect.y
    xw = xx + rect.width
    xh = xy + rect.height
    (xx..xw).each { |i|
      (xy..xh).each { |j|
        change_pixel_color(i, j)
      }
    }
  end

  # Cambia il colore dei pixel in rosso (filtro, non fa completamente rosso)
  def change_pixel_color(x, y)
    color = contents.get_pixel(x, y)
    color.red *= 2
    color.blue /= 2
    color.green /= 2
    contents.set_pixel(x, y, color)
  end

  # Disegna il puntatore sulla mappa
  def draw_map_position(x, y)
    contents.fill_rect(x, y, 3, 3, Color.new(255, 0, 0))
  end

  # Disegna la descrizione del nemico
  def draw_enemy_description(x, y, width, height)
    contents.fill_rect(x, y, width, height, sc2)
    contents.clear_rect(x + 2, y + line_height, width - 4, height - line_height - 2)
    draw_text(x + 4, y, width, line_height, BestiaryConfig::DESCRIPT)
    draw_formatted_text(x + 4, y + line_height, width - 8, enemy.description)
    #contents.draw_paragraph(x+4, y+line_height, width-8, height-line_height-4, enemy.description)
  end

  # Disegna la pagina delle statistiche
  def draw_stats_content
    draw_base_stats(0, line_height, contents_width / 3)
    right_x = contents_width / 3 + 10
    right_w = contents_width / 3 * 2 - 10
    draw_damage_type(right_x, line_height, right_w)
    draw_damage_efficiency(right_x, line_height * 2, right_w)
    draw_states_rate(0, line_height * 12, contents.width)
  end

  # Mostra i parametri di battaglia
  #     x: posizione X
  #     y: posizione Y
  #     width: larghezza massima
  def draw_base_stats(x, y, width)
    (0..BestiaryConfig::STATS.size - 1).each { |i|
      stat = BestiaryConfig::STATS[i][0]
      name = BestiaryConfig::STATS[i][1]
      icon = BestiaryConfig::STATS[i][2]
      draw_enemy_stat(x, y, width, stat, name, icon)
      y += line_height
    }
  end

  def draw_damage_type(x, y, width)
    damage_type = enemy.attack_attribute
    return if damage_type.nil?
    change_color system_color
    draw_text x, y, width, line_height, BestiaryConfig::ATTACK_TYPE
    change_color normal_color
    draw_text x, y, width, line_height, damage_type.name, 2
    icon_x = width + x - text_size(damage_type.name).width - 24
    draw_icon damage_type.icon_index, icon_x, y
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_damage_efficiency(x, y, width)
    y = draw_damage_type_rate(x, y, width)
    draw_element_rate(x, y, width)
  end

  # disegna i rate degli elementi
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_element_rate(x, y, width)
    draw_rates(x, y, width, $data_system.magic_elements, BestiaryConfig::ELEMENTS)
  end

  # disegna i rate dei danni
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_damage_type_rate(x, y, width)
    draw_rates(x, y, width, $data_system.weapon_attributes, BestiaryConfig::DAMAGE_TYPES)
  end

  # Disegna le resistenze ad attributi specifici
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Array<RPG::Element_Data] attributes
  # @param [String] descr
  def draw_rates(x, y, width, attributes, descr)
    change_color(crisis_color)
    draw_text(x, y, width, line_height, descr)
    y += line_height
    columns = BestiaryConfig::ELEMENTS_PER_ROW
    block_width = width / columns
    attributes.each_with_index do |element, index|
      block_x = block_width * (index % columns) + x
      block_y = line_height * (index / columns) + y
      draw_element(element, block_x, block_y, block_width)
    end
    change_color(normal_color)
    y + line_height * (attributes.size / columns)
  end

  # Disegna le resistenze degli stati
  #     x: posizoine X
  #     y: posizione Y
  #     width: larghezza
  def draw_states_rate(x, y, width)
    single_w = 24 * 2 + contents.text_size(">").width
    columns = width % single_w - 1
    change_color(system_color)
    draw_text(x, y, width, line_height, BestiaryConfig::STAT_RES)
    change_color(normal_color)
    y += line_height
    (0..BestiaryConfig::STATES.size - 1).each { |i|
      xx = i % columns * single_w + x
      yy = i / columns * line_height + y
      draw_state_rate(xx, yy, single_w, BestiaryConfig::STATES[i])
    }
  end

  # Disegna la resistenza del singolo stato
  #     x: posizoine X
  #     y: posizione Y
  #     width: larghezza
  #     state_id: id dello status
  def draw_state_rate(x, y, width, state_id)
    contents.fill_rect(x + 1, y + 1, width - 2, line_height - 2, sc1)
    draw_icon($data_states[state_id].icon_index, x, y)
    draw_text(x + 24, y, line_height, line_height, ">")
    draw_icon(state_rate_icon(state_id), x + width - 24, y)
  end

  # Disegna l'icona del rateo dello stato
  #     state_id: id dello stato
  # noinspection RubyResolve
  def state_rate_icon(state_id)
    BestiaryConfig::ST_RATE[enemy.state_ranks[state_id]]
  end

  # disegna un attributo (elemento, tipo danno...)
  # @param [RPG::Element_Data] attribute il tipo elemento
  # @param [Integer] x posizione X
  # @param [Integer] y posizione Y
  # @param [Integer] width larghezza
  # noinspection RubyResolve
  def draw_element(attribute, x, y, width)
    draw_bg_rect(x, y, width, line_height)
    draw_icon(attribute.icon_index, x, y)
    rate = enemy.element_ranks[attribute.id] - 1
    case rate
    when 0, 1
      change_color(power_up_color)
    when 2
      change_color(normal_color)
    when 3, 4, 5
      change_color(power_down_color)
    else
      change_color(normal_color)
    end
    draw_text(x + 24, y, width - 24, line_height, text_rate(rate))
  end

  # Restituisce l'icona del rate dell'elemento (attualmente non è usato)
  #     rate: 0,1,2,3,4,5,6
  def icon_rate(rate)
    BestiaryConfig::ICON_RATE[rate]
  end

  # Restituisce il testo del rate dell'elemento
  #     rate: 0,1,2,3,4,5,6
  def text_rate(rate)
    BestiaryConfig::TEXT_RATE[rate]
  end

  # Disegna il parametro
  #     x: posizione X
  #     y: posizione Y
  #     width: larghezza massima
  #     stat: simbolo della statistica
  #     name: Testo del parametro
  #     icon: id dell'icona
  def draw_enemy_stat(x, y, width, stat, name, icon)
    value = get_enemy_stat(stat)
    draw_stat_gauge(x, y + line_height - 3, width, stat, value)
    draw_icon(icon, x, y)
    change_color(system_color)
    draw_text(x + 24, y, width - 24, line_height, name)
    change_color(normal_color)
    draw_text(x + 24, y, width - 24, line_height, value, 2)
  end

  # Disegna la barra del parametro
  #     x: coordinata X
  #     y: coordinata Y
  #     width: larghezza
  #     stat: parametro
  #     value: valore
  def draw_stat_gauge(x, y, width, stat, value)
    max = max_known_value(stat)
    contents.fill_rect(x, y, width, 3, gauge_back_color)
    gw = (value * width).to_f
    gw /= max
    contents.gradient_fill_rect(x, y, gw.to_i, 3, mp_gauge_color1, mp_gauge_color2)
  end

  # Ottiene il parametro del nemico
  #     stat: simbolo del parametro
  def get_enemy_stat(stat)
    enemy.get_stat(stat)
  end

  # Ottiene il massimo valore conosciuto di quel parametro
  def max_known_value(stat)
    @known_stats[stat] = get_max_over(stat) if @known_stats[stat].nil?
    @known_stats[stat]
  end

  # Cerca il massimo valore di un parametro
  #     stat: parametro
  def get_max_over(stat)
    max = 0
    $data_enemies.each { |enemy|
      next if enemy.nil?
      next if enemy.hidden_best
      next unless $game_party.known_enemy?(enemy.id)
      value = enemy.get_stat(stat)
      max = value if value > max
    }
    max
  end

  # Disegna la pagina delle abilità
  def draw_skills_content
    y = draw_basic_actions
    draw_skills(y)
  end

  # Disegna le azioni di base
  def draw_basic_actions
    y = line_height
    enemy.actions.each do |action|
      next unless action.kind == 0
      draw_basic_action(y, action)
      y += line_height
    end
    y
  end

  # Disegna le skill
  #     y: coordinata Y iniziale
  # noinspection RubyResolve
  def draw_skills(y)
    enemy.actions.each do |action|
      next unless action.skill?
      next if $data_skills[action.skill_id].hide_from_bestiary?
      draw_skill(y, action)
      y += line_height
    end
  end

  # Disegna l'azione di base
  #     y: coordinata Y
  #     action: azione
  def draw_basic_action(y, action)
    draw_bg_rect(0, y, contents.width, line_height)
    draw_text(0, y, contents.width, line_height, BestiaryConfig::ACTIONS[action.basic])
    draw_condition(y, action)
  end

  # Disegna l'abilità
  #     y: coordinata Y
  #     action: azione
  def draw_skill(y, action)
    draw_bg_rect(0, y, contents.width, line_height)
    skill = $data_skills[action.skill_id]
    draw_icon(skill.icon_index, 0, y)
    if $game_party.all_members.select { |member| member.can_assimilate? }.any?
      draw_icon(H87AttrSettings::ASSIMILATE_ICON, 0, y) if skill.assimilable?
    end
    draw_text(24, y, contents.width - 24, line_height, skill.name)
    draw_condition(y, action)
  end

  # Disegna la condizione per la verifica dell'azione
  #     y: coordinata Y
  #     action: azione
  def draw_condition(y, action)
    return if [0, 1, 6].include?(action.condition_type)
    change_color(crisis_color)
    case action.condition_type
    when 2
      text = sprintf(BestiaryConfig::CON_HP, action.condition_param1, action.condition_param2)
    when 3
      text = sprintf(BestiaryConfig::CON_MP, action.condition_param1, action.condition_param2)
    when 4
      text = sprintf(BestiaryConfig::CON_ST, $data_states[action.condition_param1].name)
    when 5
      text = sprintf(BestiaryConfig::CON_PL, action.condition_param1)
    else
      text = 'error'
    end
    draw_text(0, y, contents.width - 4, line_height, "*" + text, 2)
    change_color(normal_color)
  end

  # Disegna la pagina dei drop
  def draw_drops_content
    y = draw_drops
    draw_steals(y)
    if enemy.robbery_amount > 0
      draw_steal_gold(contents_height - line_height)
    end
  end

  # Mostra i drop
  def draw_drops
    drops = enemy.drop_items.sort_by{|drop| drop.drop_percentage}.reverse
    drops.each_with_index do |drop, i|
      draw_drop(drop, line_height * (i + 1))
    end
    drops.size * line_height + line_height
  end

  # Mostra gli oggetti da rubare
  #     y: posizione Y
  def draw_steals(y)
    steals = enemy.steals
    return if steals.empty?
    steals.each_with_index do |item, index|
      next if item.nil?
      draw_steal(item, index * line_height + y)
    end
  end

  # Disegna il drop
  # @param [RPG::Enemy::DropItem] drop_item
  # @param [Integer] y
  def draw_drop(drop_item, y)
    draw_bg_rect(0, y, contents.width, line_height)
    change_color normal_color
    draw_item_name(drop_item.item, 0, y, true, contents_width)
    text = sprintf("%g%%", drop_item.drop_percentage)
    draw_text(24, y, contents.width - 24, line_height, text, 2)
  end

  # Disegna l'oggetto che può essere rubato
  # @param [RPG::Enemy::StealItem] steal_item
  # @param [Integer] y
  def draw_steal(steal_item, y)
    draw_bg_rect(0, y, contents.width, line_height, sc2)
    draw_item_name(steal_item.item, 0, y, true, contents_width)
    text = sprintf('%s %d%%', BestiaryConfig::ITEM_STEAL, steal_item.probability)
    draw_text(24, y, contents.width - 24, line_height, text, 2)
  end

  # Mostra l'oro che si può rubare
  #     gold: oro
  #     y: posizione Y
  def draw_steal_gold(y)
    draw_icon(205, 0, y)
    message = sprintf(BestiaryConfig::GOLD_ROBBERY, enemy.robbery_amount, Vocab.gold)
    draw_text(24, y, contents.width - 24, line_height, message)
  end

  # Restituisce le aree della worldmap
  # noinspection RubyResolve
  def worldmap_areas
    areas = []
    $data_areas.values.each { |area|
      areas.push(area) if area.map_id == BestiaryConfig::WORLDMAP_ID
    }
    areas
  end

  # Ottiene il rect dell'area se c'è il nemico definito, nil altrimenti
  def area_rect(area)
    return area.rect if enemy_in_area?(area)
    nil
  end

  # Restituisce true se un nemico è presente nell'area
  def enemy_in_area?(area)
    area.encounter_list.each { |troop|
      $data_troops[troop].members.each { |member|
        return true if member.enemy_id == enemy.id
      }
    }
    false
  end

  # Ottiene l'array dei rect delle aree dove è presente il nemico
  def get_area_array
    areas = []
    worldmap_areas.each { |area|
      areas.push(area_rect(area))
    }
    areas.compact
  end
end #fine dello script
