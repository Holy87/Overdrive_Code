require File.expand_path('rm_vx_data')
$imported = {} if $imported == nil
$imported["H87_Synthetis"] = true
module Vocab
  # @return [String]
  def self.synth_req; 'Richiede'; end
  # @return [String]
  def self.synth_lv; 'Livello sintesi'; end
  # @return [String]
  def self.synth_exp;'Punti esperienza'; end
  # @return [String]
  def self.go_synth;'Sintetizza'; end
  # @return [String]
  def self.synth_result;'Prodotti della sintesi:'; end
  # @return [String]
  def self.synth_ask;'Stai per distruggere'; end
  # @return [String]
  def self.synth_yes;'Sintetizza!'; end
  # @return [String]
  def self.synth_no;'Annulla'; end
  # @return [String]
  def self.synth_lvlup; 'Livello sintesi superiore!'; end
  # @return [String]
  def self.synth_reward; 'Oggetti ottenuti:'; end
end

#==============================================================================
# ** Synthetis_Config
#------------------------------------------------------------------------------
# Configurazione
#==============================================================================
module Synthetis_Config
  # Imposta la larghezza della finestra dei risultati
  RESULT_WIDTH = 350
  # Imposta l'icona del livello superiore
  LEVEL_UP_ICON = 1070
  # Imposta il bonus percentuale di successo per ogni livello sintesi superiore
  # a quello dell'oggetto
  PROBABILITY_BONUS_LEVEL = 8
  # Imposta il bonus percentuale di successo per il grado incantamento dell'equip
  PROBABILITY_BONUS_ENCHANT = 2
  # Icona esperienza
  EXP_ICON = 986

  SYNTH_SE = 'Magic3'

  SYNTH_EXP_CAP = {
      #livello => exp
      2 => 10,
      3 => 25,
      4 => 50,
      5 => 80,
      6 => 120,
      7 => 170,
      8 => 250,
      9 => 340,
      10=> 440,
  }
end

#==============================================================================
# ** BaseItem
#------------------------------------------------------------------------------
# Aggiunta degli attributi
#==============================================================================
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubblici
  #--------------------------------------------------------------------------
  attr_accessor :synth_exp      # esperienza donata
  attr_accessor :synth_level    # livello sintesi richiesto
  #--------------------------------------------------------------------------
  # * Inizializzazione dei dati della sintetizzazione
  #--------------------------------------------------------------------------
  def initialize_synthetis_data
    return if @synth_data
    @synth_data = true
    @synthetis_items = []
    @synth_exp = 0
    @synth_level = 1
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
        when /<synth level:[ ]+(\d+)>/i
          @synth_level = $1.to_i
        when /<synth exp:[ ]+(\d+)>/i
          @synth_exp = $1.to_i
        when /<synth item:[ ]+(\d+)x(\d+),[ ]+(\d+)%>/i
          @synthetis_items.push(Synthetis_Data.new($1.to_i, $2.to_i, $3.to_i))
        when /<synth weapon:[ ]+(\d+),[ ]+(\d+)%>/i
          @synthetis_items.push(Synthetis_Data.new($1.to_i, 1, $2.to_i, 1))
        when /<synth armor:[ ]+(\d+),[ ]+(\d+)%>/i
          @synthetis_items.push(Synthetis_Data.new($1.to_i, 1, $2.to_i, 2))
        when /<synth item:[ ]+(\d+),[ ]+(\d+)%>/i
          @synthetis_items.push(Synthetis_Data.new($1.to_i, 1, $2.to_i))
        else
          # va avanti
      end
    }
  end
  #--------------------------------------------------------------------------
  # * Restituisce gli oggetti che si ottengono dalla sintetizzazione
  # @return [Array<Synthetis_Data>]
  #--------------------------------------------------------------------------
  def synthetis_items
    return [] if @synthetis_items.nil?
    @synthetis_items
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto può essere sintetizzato
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def can_synthetize?
    @synthetis_items.size > 0
  end
  #--------------------------------------------------------------------------
  # * Restituisce il tipo dell'oggetto (poi da definire nelle sottoclassi)
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_type; 0; end
end

#==============================================================================
# ** Item, Weapon, Armor
#------------------------------------------------------------------------------
# Modifica i tipi oggetto
#==============================================================================
class RPG::Item; def item_type; 0; end; end
class RPG::Weapon; def item_type; 1; end; end
class RPG::Armor; def item_type; 2; end; end

#==============================================================================
# ** Synthetis_Data
#------------------------------------------------------------------------------
# Contiene i dati di un oggetto ottenuto tramite sintesi
#==============================================================================
class Synthetis_Data
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubblici
  #--------------------------------------------------------------------------
  attr_accessor :item_id      # ID dell'oggetto
  attr_accessor :item_type    # tipo dell'oggetto
  attr_accessor :item_number  # numero dell'oggetto
  attr_accessor :probability  # probabilità
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] id
  # @param [Integer] number
  # @param [Integer] probability
  # @param [Integer] type
  #--------------------------------------------------------------------------
  def initialize(id, number, probability, type = 0)
    @item_id = id
    @item_number = number
    @item_type = type
    @probability = probability
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto a cui fa riferimento
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def item
    case item_type
      when 0
        return $data_items[item_id]
      when 1
        return $data_weapons[item_id]
      when 2
        return $data_armors[item_id]
      else
        return nil
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce se è uguale
  # @param [Synthetis_Data] other_data
  # @return [boolean] se coincide
  #--------------------------------------------------------------------------
  def equal?(other_data)
    return false unless other_data.item_id == @item_id
    return false unless other_data.item_type == @item_type
    return false unless other_data.item_number == @item_number
    return false unless other_data.probability == @probability
    true
  end
end

#==============================================================================
# ** ItemSynth
#------------------------------------------------------------------------------
# Contiene le procedure necessarie alla sintesi dell'oggetto.
#==============================================================================
module ItemSynth
  #--------------------------------------------------------------------------
  # * Calcola la probabilità di ottenere l'oggetto
  # @param [RPG::BaseItem] item,
  # @param [Synthetis_Data] data
  # @return [Integer]
  #--------------------------------------------------------------------------
  def self.calc_item_probability(item, data)
    result = item_probability_bonus(item) + data.probability + rand(100)
    return [[0, result].max, 100].min
  end
  #--------------------------------------------------------------------------
  # * Prova ad ottenere degli oggetti dall'oggetto originale.
  # @param [RPG::BaseItem] item
  # @return [Array<Synthetis_Data>]
  # @param [Integer] prob
  #--------------------------------------------------------------------------
  def self.try_to_get_item(item)
    result = []
    item.synthetis_items.each do |element|
      result.push(element) if calc_item_probability(item, element) >= 100
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Avvia la sintetizzazione
  # @param [RPG::BaseItem] item
  # @param [Boolean] lose
  # @return [Array<Synthetis_Data>]
  #--------------------------------------------------------------------------
  def self.synthetize(item, lose = false)
    return [] unless item.can_synthetize?
    $game_party.lose_item(item, 1) if lose
    obtained = false
    result = []
    until obtained
      result = try_to_get_item(item)
      obtained = result.size > 0
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Restituisce il bonus sulla probabilità di riuscita
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def self.item_probability_bonus(item)
    $game_party.synth_probability_bonus(item)
  end
  #--------------------------------------------------------------------------
  # * Sintetizza l'oggetto e ne restituisce gli oggetti risultanti
  #   Inoltre, fa scoprire gli oggetti e li aggiunge all'inventario
  # @param [RPG::BaseItem] item
  # @return [Array<RPG::BaseItem>]
  #--------------------------------------------------------------------------
  def self.synthetize_and_obtain_items(item)
    result = synthetize(item)
    items = []
    result.each do |data|
      number = rand(data.item_number)+1
      items.push([data.item, number])
      $game_party.discover_item(item, data)
      $game_party.gain_item(data.item, number)
    end
    return items
  end
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
# Aggiunta del caricamento dei dati sintesi degli oggetti
#==============================================================================
module DataManager
  # noinspection RubyResolve
  class << self
    alias h87_synth_lndb load_normal_database
    alias h87_synth_lbtd load_battle_test_database
  end
  #--------------------------------------------------------------------------
  # * Carica il database normale
  #--------------------------------------------------------------------------
  def self.load_normal_database
    h87_synth_lndb
    load_synth_data
  end
  #--------------------------------------------------------------------------
  # * Carica il database nel battle test
  #--------------------------------------------------------------------------
  def self.load_battle_test_database
    h87_synth_lbtd
    load_synth_data
  end
  #--------------------------------------------------------------------------
  # * Carica i dati degli oggetti
  #--------------------------------------------------------------------------
  def self.load_synth_item_data
    $data_items.each do |item|
      next if item.nil?
      item.initialize_synthetis_data
    end
  end
  #--------------------------------------------------------------------------
  # * Carica i dati delle armi
  #--------------------------------------------------------------------------
  def self.load_synth_weapon_data
    $data_weapons.each do |weapon|
      next if weapon.nil?
      weapon.initialize_synthetis_data
    end
  end
  #--------------------------------------------------------------------------
  # * Carica i dati delle armature
  #--------------------------------------------------------------------------
  def self.load_synth_armor_data
    $data_armors.each do |armor|
      next if armor.nil?
      armor.initialize_synthetis_data
    end
  end
  #--------------------------------------------------------------------------
  # * Carica i dati della sintesi
  #--------------------------------------------------------------------------
  def self.load_synth_data
    load_synth_item_data
    load_synth_armor_data
    load_synth_weapon_data
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
# Aggiunta della memorizzazione del livello sintesi e oggetti scoperti
#==============================================================================
class Game_Party < Game_Unit
  include Synthetis_Config
  #--------------------------------------------------------------------------
  # * Restituisce gli oggetti scoperti per la sintesi
  # @return [Hash]
  #--------------------------------------------------------------------------
  def synthetis_items_discovered
    new_discovered_array if @synthetis_discovered.nil?
    @synthetis_discovered
  end
  #--------------------------------------------------------------------------
  # * Crea l'hash delle scoperte
  #--------------------------------------------------------------------------
  def new_discovered_array
    @synthetis_discovered = {1 => {}, 2 => {}, 3 => {}}
  end
  #--------------------------------------------------------------------------
  # * Restituisce il livello sintesi raggiunto
  # @return [Integer]
  #--------------------------------------------------------------------------
  def synthetis_level
    @synthetis_level = 1 if @synthetis_level.nil?
    @synthetis_level
  end
  #--------------------------------------------------------------------------
  # * Ottiene l'esperienza ottenuta per la sintesi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def synthetis_exp
    @synthetis_exp = 0 if @synthetis_exp.nil?
    @synthetis_exp
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto può essere sintetizzato dal giocatore
  # @param [RPG::BaseItem] item
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def item_can_synthetize?(item)
    synthetis_level >= item.synth_level
  end
  #--------------------------------------------------------------------------
  # * Restituisce se l'oggetto è stato trovato
  # @param [RPG::BaseItem] item
  # @param [Synthetis_Data] synthetis_data
  # @return [Boolean] se il party conosce l'oggetto
  #--------------------------------------------------------------------------
  def synth_item_discovered?(item, synthetis_data)
    item_id = $imported['H87_EquipEnchant'] ? item.real_id : item.id
    item_type = item.item_type
    return false unless synthetis_items_discovered[item_type][item_id]
    synthetis_items_discovered[item_type][item_id].each do |item2|
      return true if synthetis_data.equal?(item2)
    end
    false
  end
  #--------------------------------------------------------------------------
  # * Scopre un nuovo materiale dall'oggetto scomposto
  # @param [RPG::BaseItem] item
  # @param [Synthetis_data] synthetis_data
  #--------------------------------------------------------------------------
  def discover_item(item, synthetis_data)
    return if synth_item_discovered?(item, synthetis_data)
    item_id = $imported['H87_EquipEnchant'] ? item.real_id : item.id
    item_type = item.item_type
    if synthetis_items_discovered[item_type][item_id].nil?
      synthetis_items_discovered[item_type][item_id] = []
    end
    synthetis_items_discovered[item_type][item_id].push(synthetis_data)
  end
  #--------------------------------------------------------------------------
  # * Ottiene l'esperienza inserita (e sale di livello se necessario)
  #   Restituisce true se ottiene un level up
  # @param [Integer] exp
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def gain_synthetis_exp(exp)
    @synthetis_exp = 0 unless @synthetis_exp
    @synthetis_exp += exp
    if !synth_level_max? && @synthetis_exp >= next_level_exp
      synthetis_level_up
      return true
    end
    false
  end
  #--------------------------------------------------------------------------
  # * Restituisce se si è raggiunti il livello massimo
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def synth_level_max?
    synthetis_level >= max_level_cap
  end
  #--------------------------------------------------------------------------
  # * Restituisce il livello massimo raggiungibile
  # @return [Integer]
  #--------------------------------------------------------------------------
  def max_level_cap
    SYNTH_EXP_CAP.keys.max
  end
  #--------------------------------------------------------------------------
  # * restituisce l'esperienza necessaria per il livello
  # @param [Integer] sl
  # @return [Integer]
  #--------------------------------------------------------------------------
  def get_level_exp(sl = synthetis_level)
    return 0 if sl <= 1
    SYNTH_EXP_CAP[sl]
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'esperienza necessaria per il prossimo livello
  # @return [Integer]
  #--------------------------------------------------------------------------
  def next_level_exp
    get_level_exp(synthetis_level + 1)
  end
  #--------------------------------------------------------------------------
  # * Avanza di livello sintesi
  #--------------------------------------------------------------------------
  def synthetis_level_up
    @synthetis_level = 1 if @synthetis_level.nil?
    @synthetis_level += 1
  end
  #--------------------------------------------------------------------------
  # * Ritorna il bonus per il successo della sintesi
  # @param [RPG::BaseItem] item
  # @return [Integer]
  #--------------------------------------------------------------------------
  def synth_probability_bonus(item)
    if synthetis_level > item.synth_level
      el = Synthetis_Config::PROBABILITY_BONUS_LEVEL
      probability = (synthetis_level - item.synth_level) * el
    else
      probability = 0
    end
    probability += members_probability_bonus
    if $imported['H87_EquipEnchant'] && item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
      probability += item.enchant_state * Synthetis_Config::PROBABILITY_BONUS_ENCHANT
    end
    probability
  end
  #--------------------------------------------------------------------------
  # * Ritorna il bonus per il successo aggiunto dagli eroi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def members_probability_bonus
    bonus = 0
    members.each do |member|
      bonus += member.synth_probability_bonus
    end
    bonus
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
# Per il bonus riuscita della sintesi
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Restituisce il bonus per la probabilità di riuscita di una scomposizione.
  # * Viene ridefinito nello script degli attributi aggiuntivi.
  # @return [Integer]
  #--------------------------------------------------------------------------
  def synth_probability_bonus; 0; end

end

#==============================================================================
# ** Window_SynthList
#------------------------------------------------------------------------------
# Finestra che mostra gli oggetti sintetizzabili posseduti
#==============================================================================
class Window_SynthList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Window_Help] help_window
  #--------------------------------------------------------------------------
  def initialize(help_window)
    super(0, help_window.height, Graphics.width/2, Graphics.height - help_window.height)
    @data = []
    @attached_windows = []
    select(0)
    self.help_window = help_window
    make_item_list
    create_contents
    refresh
  end
  #--------------------------------------------------------------------------
  # * Genera la lista di oggetti sintetizzabili
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.all_items.select {|item| include?(item)}
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto è disponibile
  # @param [RPG::BaseItem] item
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def include?(item)
    $game_party.has_item?(item) && item.can_synthetize?
  end
  #--------------------------------------------------------------------------
  # * Aggiunge una finestra per aggiornarsi
  # @param [Window_Base] window
  #--------------------------------------------------------------------------
  def attach_window(window)
    @attached_windows.push(window)
  end
  #--------------------------------------------------------------------------
  # * Riaggiorna la finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Restituisce il numero di oggetti posseduti
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 1; end
  #--------------------------------------------------------------------------
  # * Restituisce il numero di colonne
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto selezionato dal cursore
  # @return [RPG::Item]
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Ottiene lo stato di attivazione dell'oggetto corrente
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto ad un indice stabilito
  # @param [Integer] index
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def data(index); @data[index]; end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = data(index)
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item), rect.width)
      draw_item_number(rect, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
    @attached_windows.each do |window|
      window.item = item
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce se l'oggetto è disponibile
  # @param [RPG::Item] item
  #--------------------------------------------------------------------------
  def enable?(item)
    return false if item.nil?
    $game_party.item_can_synthetize?(item) && $game_party.has_item?(item)
  end
  #--------------------------------------------------------------------------
  # * Disegna il numero degli oggetti posseduti
  # @param [Rect] rect
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    draw_text(rect, sprintf(':%2d', $game_party.item_number(item)), 2)
  end
end

#==============================================================================
# ** Window_SynthLevel
#------------------------------------------------------------------------------
# Finestra che mostra il livello di sintesi posseduto dal party
#==============================================================================
class Window_SynthLevel < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, Graphics.width - x, line_height * 2 + standard_padding * 2)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Disegna il livello sintesi raggiunto
  #--------------------------------------------------------------------------
  def draw_level
    change_color(system_color)
    draw_text(0,0,contents_width, line_height, Vocab.synth_lv)
    change_color(normal_color)
    draw_text(0,0,contents_width, line_height, $game_party.synthetis_level, 2)
  end
  #--------------------------------------------------------------------------
  # * Disegna la barra
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_exp_gauge(y)
    draw_exp_back_gauge(y, 5)
    draw_exp_foreground_gauge(y, get_exp_width, 5)
    change_color(system_color)
    draw_text(0, y, contents_width, line_height, Vocab.synth_exp)
  end
  #--------------------------------------------------------------------------
  # * Rinfresca la finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_level
    draw_exp_data
  end
  #--------------------------------------------------------------------------
  # * Disegna il testo dell'esperienza
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_exp_text(y = 0)
    change_color(normal_color)
    current_exp = $game_party.synthetis_exp
    next_exp = $game_party.get_level_exp($game_party.synthetis_level + 1)
    experience = sprintf('%d/%d',current_exp, next_exp)
    draw_text(0, y, contents_width, line_height, experience, 2)
  end
  #--------------------------------------------------------------------------
  # * Disegna i dati dell'esperienza
  #--------------------------------------------------------------------------
  def draw_exp_data
    draw_exp_gauge(line_height)
    draw_exp_text(line_height)
  end
  #--------------------------------------------------------------------------
  # * Disegna lo sfondo della barra dell'esperienza
  # @param [Integer] y
  # @param [Integer] thickness
  #--------------------------------------------------------------------------
  def draw_exp_back_gauge(y, thickness = 10)
    new_y = y + (line_height - thickness)
    width = contents_width
    height = thickness
    contents.fill_rect(0, new_y, width, height, gauge_back_color)
  end
  #--------------------------------------------------------------------------
  # * Disegna lo sfondo della barra dell'esperienza
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] thickness
  #--------------------------------------------------------------------------
  def draw_exp_foreground_gauge(y, width, thickness = 10)
    c1 = tp_gauge_color1
    c2 = tp_gauge_color2
    new_y = y + (line_height - thickness)
    height = thickness
    contents.gradient_fill_rect(0, new_y, width, height, c1, c2)
  end
  #--------------------------------------------------------------------------
  # * Ottiene la larghezza con cui disegnare la barra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def get_exp_width
    current_exp = $game_party.synthetis_exp
    prev_exp = $game_party.get_level_exp
    next_exp = $game_party.get_level_exp($game_party.synthetis_level + 1)
    current = current_exp - prev_exp
    target = next_exp - prev_exp
    rate = [[current.to_f/target, 1].min, 0].max
    width * rate
  end
end

#==============================================================================
# ** Window_SynthReq
#------------------------------------------------------------------------------
# Finestra che mostra i requisiti della sintetizzazione (il livello sintesi)
#==============================================================================
class Window_SynthReq < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, Graphics.width - x, fitting_height(2))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Rinfresca la finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_title
    draw_level_required
  end
  #--------------------------------------------------------------------------
  # * Disegna il titolo della finestra
  #--------------------------------------------------------------------------
  def draw_title
    change_color(system_color)
    draw_text(0,0,contents_width,line_height, Vocab.synth_req)
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def item; @item; end
  #--------------------------------------------------------------------------
  # * Imposta l'oggetto della finestra
  # @param [RPG::BaseItem] new_item
  #--------------------------------------------------------------------------
  def item=(new_item)
    return if new_item == @item
    @item = new_item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Disegna il livello richiesto
  #--------------------------------------------------------------------------
  def draw_level_required
    return if @item.nil?
    if $game_party.item_can_synthetize?(@item)
      change_color(power_up_color, false)
    else
      change_color(power_down_color, true)
    end
    draw_text(0,line_height,contents_width,line_height,Vocab.synth_lv)
    draw_text(0,line_height,contents_width,line_height,item.synth_level, 2)
  end
  #--------------------------------------------------------------------------
  # * Imposta l'oggetto della finestra
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def set_item(item)
    @item = item
    refresh
  end
end

#==============================================================================
# ** Window_ResultItems
#------------------------------------------------------------------------------
# Finestra che mostra gli oggetti ottenuti dalla scomposizione
#==============================================================================
class Window_ResultItems < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, Graphics.width - x, Graphics.height - y)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh della finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_title
    return if item.nil?
    draw_item_exp
    draw_items
  end
  #--------------------------------------------------------------------------
  # * Disegna il titolo
  #--------------------------------------------------------------------------
  def draw_title
    change_color(system_color)
    draw_text(0,0,contents_width,line_height,Vocab.synth_result)
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'item della finestra
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def item
    @item
  end
  #--------------------------------------------------------------------------
  # * Imposta il nuovo item della finestra
  # @param [RPG::BaseItem] new_item
  #--------------------------------------------------------------------------
  def item=(new_item)
    return if new_item == @item
    @item = new_item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Disegna l'esperienza che otterrai
  #--------------------------------------------------------------------------
  def draw_item_exp
    change_color(normal_color)
    draw_bg_srect(0, line_height)
    text = sprintf('%s x%d',Vocab.synth_exp, item.synth_exp)
    draw_icon(Synthetis_Config::EXP_ICON,0,line_height)
    draw_text(24,line_height,contents_width-24,line_height,text)
  end
  #--------------------------------------------------------------------------
  # * Disegna gli oggetti
  #--------------------------------------------------------------------------
  def draw_items
    for i in 1..item.synthetis_items.size
      synthetis_item = item.synthetis_items[i-1]
      if $game_party.synth_item_discovered?(item, synthetis_item)
        prob = synthetis_item.probability + $game_party.synth_probability_bonus(item)
        draw_known_item(i+1, synthetis_item.item, prob, synthetis_item.item_number)
      else
        draw_unknown_item(i+1, synthetis_item.item)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto se sconosciuto
  # @param [Integer] line
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def draw_unknown_item(line, item)
    text = unknown_string(item.name.size)
    change_color(normal_color, false)
    draw_text(0, line_height * line, contents_width, line_height, text)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto se conosciuto con la relativa probabilità
  # @param [Integer] line
  # @param [RPG::BaseItem] item
  # @param [Integer] probability
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def draw_known_item(line, item, probability, number = 1)
    draw_bg_srect(0, line * line_height)
    change_color(normal_color, true)
    text = item.name
    text += " x1~" + number.to_s if number > 1
    draw_icon(item.icon_index,0,line_height*line)
    draw_text(24, line_height * line, contents_width-24, line_height, text)
    if probability < 100
      text = sprintf('(%d%%)', [probability, 100].min)
      draw_text(0, line_height * line, contents_width, line_height, text, 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Genera una stringa di punti interrogativi
  # @param [Integer] char_number
  # @return [String]
  #--------------------------------------------------------------------------
  def unknown_string(char_number)
    '?' * char_number
  end
end

#==============================================================================
# ** Sprite_AlchemyCircle
#------------------------------------------------------------------------------
# Mostra l'animazione del cerchio alchemico
#==============================================================================
class Sprite_AlchemyCircle
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    @picture = Sprite.new
    @picture.bitmap = Cache.picture('Cerchio Alchemico Background')
    @picture.opacity = 100
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    @picture.update
    @picture.opacity > 200 ? update_flashing : update_squeezing
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento del flash
  #--------------------------------------------------------------------------
  def update_flashing
    @picture.opacity -= 1
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della pulsazione
  #--------------------------------------------------------------------------
  def update_squeezing
    @picture.opacity += rand(2) - 1
    @picture.opacity = 100 if @picture.opacity < 100
    @picture.opacity = 200 if @picture.opacity > 200
  end
  #--------------------------------------------------------------------------
  # * Attivazione del flash
  #--------------------------------------------------------------------------
  def flash
    @picture.flash(Color::RED, 60)
    @picture.opacity = 255
  end
  #--------------------------------------------------------------------------
  # * Eliminazione
  #--------------------------------------------------------------------------
  def dispose
    @picture.dispose
  end
end

class Window_SynthAsk < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    super(0,0,Synthetis_Config::RESULT_WIDTH, fitting_height(2))
    create_contents
    refresh
    center_window
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Rinfresca la finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_request
    draw_item
  end
  #--------------------------------------------------------------------------
  # * Disegna il testo di domanda
  #--------------------------------------------------------------------------
  def draw_request
    change_color(crisis_color)
    draw_text(0,0,contents_width, line_height, Vocab.synth_ask)
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto
  # @return RPG::BaseItem
  #--------------------------------------------------------------------------
  def item
    @item
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item
    draw_bg_rect(0, line_height)
    return if item.nil?
    draw_item_name(item, 0, line_height)
  end
  #--------------------------------------------------------------------------
  # * Assegna l'oggetto
  # @param [RPG::BaseItem] new_item
  #--------------------------------------------------------------------------
  def item=(new_item)
    @item = new_item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Apre la finestra
  #--------------------------------------------------------------------------
  def open
    super
    center_window
    if @command_window
      @command_window.move(self.x, self.by, self.width, fitting_height(2))
    end
  end
  #--------------------------------------------------------------------------
  # * Imposta la finestra di comando
  # @param [Window_SynthAsk] window
  #--------------------------------------------------------------------------
  def command_window=(window)
    @command_window = window
  end
end

class Window_SynthCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    super(0,0)
    self.openness = 0
    @call_close = false
  end
  #--------------------------------------------------------------------------
  # * Aggiunta dei comandi
  #--------------------------------------------------------------------------
  def make_command_list
    super
    add_command(Vocab.synth_yes, :synthetize)
    add_command(Vocab.synth_no, :cancel)
  end
  #--------------------------------------------------------------------------
  # * Assegna un metodo da chiamare dopo la chiusura della finestra
  # @param [Method] method
  #--------------------------------------------------------------------------
  def close_handler(method)
    @close_method = method
  end
  #--------------------------------------------------------------------------
  # * Apre la finestra resettando la chiusura
  #--------------------------------------------------------------------------
  def open
    super
    @call_close = false
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento con controllo chiusura della finestra
  #--------------------------------------------------------------------------
  def update
    super
    if @call_close && self.openness == 0 && @close_method
      @call_close = false
      @close_method.call
    end
  end
  #--------------------------------------------------------------------------
  # * Chiusura della finestra con attivazione controllo evento
  #--------------------------------------------------------------------------
  def close(callc = true)
    super()
    @call_close = callc
  end
end

#==============================================================================
# ** Window_SynthetisResult
#------------------------------------------------------------------------------
# Finestra che mostra i risultati della sintetizzazione
#==============================================================================
class Window_SynthetisResult < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    w = Synthetis_Config::RESULT_WIDTH
    super(Graphics.width/2-(w/2),0,w, fitting_height(4))
    self.index = -1
    @data = []
    self.openness = 0
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Non ci sono oggetti
  #--------------------------------------------------------------------------
  def col_max; 0; end
  def item_max; 0; end
  #--------------------------------------------------------------------------
  # * Mostra la finestra
  # @param [Array<RPG::BaseItem>] items
  # @param [Boolean] level_up
  #--------------------------------------------------------------------------
  def call(items, level_up = false)
    @items = items
    @level_up = level_up
    refresh
    activate
    open
  end
  #--------------------------------------------------------------------------
  # * Restituisce gli oggetti
  # @return [Array <RPG::BaseItem>]
  #--------------------------------------------------------------------------
  def items
    @items
  end
  #--------------------------------------------------------------------------
  # * Rinfresca e crea i contenuti
  #--------------------------------------------------------------------------
  def refresh
    self.height = fitting_height(calc_line_number)
    create_contents
    draw_contents
    center_window
  end
  #--------------------------------------------------------------------------
  # * Calcola di quante righe sarà composta la finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def calc_line_number
    line_count = 1
    line_count += 1 if @level_up
    line_count += @items.size
    line_count + 0
  end
  #--------------------------------------------------------------------------
  # * Disegna il testo nella finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def draw_contents
    line_count = 0
    line_count += text_for_level_up
    text_for_description(line_count)
    line_count += text_for_items(line_count + 1 )
    line_count + 0
  end
  #--------------------------------------------------------------------------
  # * Disegna (se disponibile) il testo del livello superiore e restituisce 1
  #   se il testo è stato disegnato
  # @return [Integer]
  #--------------------------------------------------------------------------
  def text_for_level_up
    line_number = 0
    if @level_up
      draw_bg_rect(0, 0)
      draw_icon(Synthetis_Config::LEVEL_UP_ICON, 0, 0)
      change_color(power_up_color)
      draw_text(24,0,contents_width - 24, line_height, Vocab.synth_lvlup)
      line_number += 1
    end
    line_number
  end
  #--------------------------------------------------------------------------
  # * Aggiunge i metodi scelti
  # @param [Method] method
  #--------------------------------------------------------------------------
  def set_handlers(method)
    set_handler(:ok, method)
    set_handler(:cancel, method)
  end
  #--------------------------------------------------------------------------
  # * Disegna il testo per la descrizione degli oggetti ricevuti
  # @param [Integer] line_count
  #--------------------------------------------------------------------------
  def text_for_description(line_count)
    draw_underline(line_count)
    change_color(crisis_color)
    draw_text(0, line_count * line_height, contents_width, line_height, Vocab.synth_reward,1)
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # * Disegna gli oggetti acquisiti
  # @param [Integer] line_count
  # @return [Integer]
  #--------------------------------------------------------------------------
  def text_for_items(line_count)
    items.each do |item|
      draw_synth_item(item[0], item[1], line_count)
      line_count += 1
    end
    line_count
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto alla riga scelta
  # @param [RPG::BaseItem] item
  # @param [Integer] item_number
  # @param [Integer] line_count
  #--------------------------------------------------------------------------
  def draw_synth_item(item, item_number, line_count)
    draw_icon(item.icon_index, 0, line_count * line_height)
    text = item.name
    text += ' x' + item_number.to_s if item_number > 1
    draw_text(24,line_count*line_height,contents_width-24,line_height,text)
  end
  #--------------------------------------------------------------------------
  # * Chiusura
  #--------------------------------------------------------------------------
  def close
    super
    deactivate
  end
end

#==============================================================================
# ** Scene_Synthetize
#------------------------------------------------------------------------------
# Schermata principale di sintetizzazione
#==============================================================================
class Scene_Synthetize < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_background       #creazione dello sfondo
    create_sub_viewport     #creazione del viewport
    create_animated_cyrcle  #crea il cerchio alchemico di sfondo
    create_help_window      #crea finestra d'aiuto
    create_item_window      #crea elenco oggetti
    create_level_window     #crea finestra livello
    create_req_window       #crea finestra requisiti
    create_result_window    #crea la finestra del risultato
    create_ask_windows      #crea le finestre di conferma
    create_animation_sprite #crea lo sprite di animazione come risultato
    create_end_window       #crea la finestra con gli oggetti ottenuti
  end
  #--------------------------------------------------------------------------
  # * Creazione del secondo viewport
  #--------------------------------------------------------------------------
  def create_sub_viewport
    @viewport2 = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport2.z = 300
  end
  #--------------------------------------------------------------------------
  # * Creazione del cerchio animato
  #--------------------------------------------------------------------------
  def create_animated_cyrcle
    @alchemy_cyrcle = Sprite_AlchemyCircle.new
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra degli oggetti
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_SynthList.new(@help_window)
    @item_window.activate
    @item_window.set_handler(:ok, method(:item_ok))
    @item_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra livello alchimia
  #--------------------------------------------------------------------------
  def create_level_window
    @level_window = Window_SynthLevel.new(@item_window.width, @help_window.height)
  end
  #--------------------------------------------------------------------------
  # * Creazione dello sprite di animazione (quello visualizzato alla
  # scomposizione)
  #--------------------------------------------------------------------------
  def create_animation_sprite
    @anim_sprite = Sprite.new(@viewport2)
    @anim_sprite.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Anima lo sprite con l'animazione di scomparsa
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def animate_sprite(item)
    @anim_sprite.bitmap = bitmap_from_item(item)
    @anim_sprite.ox = @anim_sprite.width/2
    @anim_sprite.oy = @anim_sprite.height/2
    @anim_sprite.x = Graphics.width/2
    @anim_sprite.y = Graphics.height/2
    @anim_sprite.zoom_x = 7.0
    @anim_sprite.zoom_y = 7.0
    @anim_sprite.opacity = 255
    @anim_sprite.flash(Color::WHITE, 60)
    @anim_sprite.change_size(0,0,4)
    @anim_sprite.fade
  end
  #--------------------------------------------------------------------------
  # * Restituisce una bitmap dall'icona di un oggetto
  # @param [RPG::BaseItem] item
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def bitmap_from_item(item)
    bmp = Bitmap.new(24,24)
    bmp.draw_icon(item.icon_index, 0, 0)
    bmp
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei risultati
  #--------------------------------------------------------------------------
  def create_result_window
    @result_window = Window_ResultItems.new(@level_window.x, @req_window.y + @req_window.height)
    @item_window.attach_window(@result_window)
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei risultati della sintetizzazione
  #--------------------------------------------------------------------------
  def create_end_window
    @end_window = Window_SynthetisResult.new
    @end_window.set_handlers(method(:close_window))
  end
  #--------------------------------------------------------------------------
  # * Crea le finestre di conferma
  #--------------------------------------------------------------------------
  def create_ask_windows
    @ask_window = Window_SynthAsk.new
    @selection_window = Window_SynthCommand.new
    @selection_window.close_handler(method(:call_results))
    @ask_window.command_window = @selection_window
    @selection_window.set_handler(:synthetize, method(:close_and_synth))
    @selection_window.set_handler(:cancel, method(:close_and_reselect))
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    @alchemy_cyrcle.update
    @item_sprite.update if @item_sprite
    @anim_sprite.update if @anim_sprite.opacity > 0
  end
  #--------------------------------------------------------------------------
  # * Chiusura
  #--------------------------------------------------------------------------
  def terminate
    super
    @alchemy_cyrcle.dispose
    @anim_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei requisiti
  #--------------------------------------------------------------------------
  def create_req_window
    @req_window = Window_SynthReq.new(@level_window.x, @level_window.y + @level_window.height)
    @item_window.attach_window(@req_window)
  end
  #--------------------------------------------------------------------------
  # * Su selezione dell'oggetto
  #--------------------------------------------------------------------------
  def item_ok
    @ask_window.open
    @item_sprite = @item_window.selected_item_sprite
    @item_sprite.viewport = @viewport2
    @item_sprite.spark_active = true
    scope = @ask_window.get_line_coord(1)
    @item_sprite.smooth_move(scope.x, scope.y, 1, method(:start_ask))
    $game_party.lose_item(@item_window.item, 1)
    @item_window.refresh_index
  end
  #--------------------------------------------------------------------------
  # * Apre la finestra dei comandi per confermare la sintesi
  #--------------------------------------------------------------------------
  def start_ask
    #delete_item_sprite
    #@ask_window.item = @item_window.item
    @item_sprite.spark_spawn_ray = 24
    @item_sprite.spark_active = false
    @selection_window.open
    @selection_window.activate
  end
  #--------------------------------------------------------------------------
  # * Chiude ed avvia la sintesi
  #--------------------------------------------------------------------------
  def close_and_synth
    delete_item_sprite
    @selection_window.close
    @ask_window.close
    #@ask_window.item = nil
    animate_sprite(@item_window.item)
  end
  #--------------------------------------------------------------------------
  # * Chiude e restituisce l'oggetto
  #--------------------------------------------------------------------------
  def close_and_reselect
    scope = @item_window.get_absolute_rect
    @item_sprite.smooth_move(scope.x, scope.y, 2, method(:reselect_item))
    @ask_window.close
    #@ask_window.item = nil
    @selection_window.close(false)
    #reselect_item
  end
  #--------------------------------------------------------------------------
  # * Riavvia la selezione dell'oggetto
  #--------------------------------------------------------------------------
  def reselect_item
    delete_item_sprite
    $game_party.gain_item(@item_window.item, 1)
    @item_window.refresh_index
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * Cancella lo sprite dell'oggetto
  #--------------------------------------------------------------------------
  def delete_item_sprite
    @item_sprite.visible = false
    @item_sprite.dispose
    @item_sprite = nil
  end
  #--------------------------------------------------------------------------
  # * Esegue la sintesi e chiama la finestra di risultati
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def call_results(item = @item_window.item)
    RPG::SE.new(Synthetis_Config::SYNTH_SE).play
    items = ItemSynth.synthetize_and_obtain_items(item)
    level_up = $game_party.gain_synthetis_exp(item.synth_exp)
    @alchemy_cyrcle.flash
    show_results(items, level_up)
    @req_window.refresh
    @result_window.refresh
    @level_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Mostra la inestra del risultato della scomposizione
  # @param [Array<RPG::BaseItem] items
  # @param [Boolean] level_up
  #--------------------------------------------------------------------------
  def show_results(items, level_up)
    @item_window.refresh
    @end_window.call(items, level_up)
  end
  #--------------------------------------------------------------------------
  # * Chiude la finestra del risultato
  #--------------------------------------------------------------------------
  def close_window
    @end_window.close
    @item_window.refresh
    @item_window.activate
  end
end