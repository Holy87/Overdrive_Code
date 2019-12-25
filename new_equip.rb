#==============================================================================
# ** Vocab
#==============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Restituisce la stringa per nessun equipaggiamento
  # @return [String]
  #--------------------------------------------------------------------------
  def self.equip_none(symbol)
    EquipSettings::NONE_VOCABS[symbol]
  end

  #--------------------------------------------------------------------------
  # * Restituisce la stringa del tipo equipaggiamento
  # @return [String]
  #--------------------------------------------------------------------------
  def self.equip_type(symbol)
    EquipSettings::TYPE_RULES[symbol][0]
  end

  #--------------------------------------------------------------------------
  # * Restituisce la stringa dell'aiuto per rimuovere oggetti
  # @return [String]
  #--------------------------------------------------------------------------
  def self.help_remove
    ' rimuovi'
  end

  #--------------------------------------------------------------------------
  # * Restituisce la stringa dell'aiuto per cambiare personaggio
  # @return [String]
  #--------------------------------------------------------------------------
  def self.help_actor_change
    ' scorri eroe '
  end
end

#==============================================================================
# ** EquipSettings
#------------------------------------------------------------------------------
# Impostazioni della schermata equipaggiamenti
#==============================================================================
module EquipSettings
  #--------------------------------------------------------------------------
  # * I parametri che verranno mostrati nella finestra dell'eroe
  #--------------------------------------------------------------------------
  PARAMS = [:mhp, nil, :mmp, :atk, :def, :spi, :agi, :hit, :cri, :eva,
            :odds, :res]
  #--------------------------------------------------------------------------
  # * Le icone dei parametri
  #--------------------------------------------------------------------------
  ICONS = {:mhp => 1008, :mmp => 1009, :atk => 1010, :def => 1011,
           :spi => 1012, :agi => 1013, :hit => 1015, :cri => 1014,
           :eva => 1016, :odds => 1249, :res => 1251,
           :mag => 1250, :maxhp => 1008, :maxmp => 1009}
  # quali parametri vengono mostrati in percentuale?
  PARAM_PERCENTAGES = [:hit, :cri, :eva, :res]
  # quali parametri occupano il doppio dello spazio?
  DOUBLE_SIZED_PARAMS = [:mhp]
  #--------------------------------------------------------------------------
  # * Altri parametri
  #--------------------------------------------------------------------------
  UNEQUIP_ICON = 238 #icona disequipaggia
  EQUIP_WIDTH = 360 #larghezza della finestra equipaggiamento
  #--------------------------------------------------------------------------
  # * Vocaboli per equipaggiamento
  #--------------------------------------------------------------------------
  NONE_VOCABS = {
      :weapon => 'Nessun\'arma',
      :shield => 'Nessun supporto',
      :helmet => 'Nessun elmo',
      :armour => 'Nessuna armatura',
      :other => 'Nessun accessorio',
      :gloves => 'Nessun guanto',
      :boots => 'Nessuno stivale',
      :esper => 'Nessuna evocazione'
  }
  #--------------------------------------------------------------------------
  # * Regole (preso da YEM Equip)
  #--------------------------------------------------------------------------
  TYPE_RULES = {
      # Equip  => [ Nome,       Tipo, Vuoto?],
      :weapon => ['Arma', nil, true],
      :shield => ['Scudo', 0, true],
      :helmet => ['Testa', 1, true],
      :armour => ['Corpo', 2, true],
      :other => ['Acc.', 3, true],
      :gloves => ['Mani', 5, true],
      :boots => ['Gambe', 6, true],
      :esper => ['Pietra', 7, true]
  } # Do not remove this.

  SUPPORT_CHANGE_WEAPON_GROUPS = {
      #gruppo => nome supporto
      :gun => ['Munizioni', 'No muniz. speciali'],
      :bow => ['Faretra','Nessuna faretra']
  }

  # Restituisce se può essere disequipaggiato
  # @param [Symbol] type
  # @return [Boolean]
  def self.can_unequip?(type)
    TYPE_RULES[type][2]
  end

  # Restituisce il tipo slot equipaggiamento
  def self.equip_type(symbol)
    TYPE_RULES[symbol][1]
  end

  # Restituisce se il parametro è a doppia dimensione
  def self.param_dsized?(symbol)
    DOUBLE_SIZED_PARAMS.include?(symbol)
  end

  # Restituisce l'array dei nomi degli equip
  def self.type_vocabs
    vocabs = []
    TYPE_RULES.each_value do |value|
      vocabs.push(value[0])
    end
    vocabs
  end

  #--------------------------------------------------------------------------
  # * Restituisce il vocabolo più lungo
  #--------------------------------------------------------------------------
  def self.longest_vocab
    type_vocabs.max {|x| x.size}
  end
end

#==============================================================================
# ** Game_Player
#==============================================================================
class Game_Actor < Game_Battler
  alias class_equippable? equippable? unless $@
  #--------------------------------------------------------------------------
  # * Restituisce l'arma principale
  # @return [RPG::Weapon]
  #--------------------------------------------------------------------------
  def first_weapon;
    self.weapons[0];
  end

  #--------------------------------------------------------------------------
  # * Restituisce la furia massima
  # @return [Integer]
  #--------------------------------------------------------------------------
  def mag;
    max_anger;
  end

  # @param [RPG::Weapon,RPG::Armor] item
  def equippable?(item)
    if item.is_a?(RPG::Armor) and item.another_support_type?
      return false if two_swords_style
      return false if first_weapon.nil?
      return false unless first_weapon.changes_support_type?
      first_weapon.use_support == item.support_type
    else
      return false if item.is_a?(RPG::Armor) and first_weapon != nil and first_weapon.changes_support_type? and item.kind == 0
      class_equippable?(item)
    end
  end
end

#==============================================================================
# ** Window_ActorStats
#------------------------------------------------------------------------------
# Questa finestra mostra i parametri dell'eroe con l'equipaggiamento.
#==============================================================================
class Window_ActorStats < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] y
  # @param [Game_Actor] actor
  #--------------------------------------------------------------------------
  def initialize(y, actor)
    super(0, y, Graphics.width, fitting_height(4))
    @last_item = nil
    @last_slot_type = nil
    @actor = actor
    create_contents
    refresh
  end

  #--------------------------------------------------------------------------
  # * L'eroe selezionato
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def actor;
    @actor;
  end

  #--------------------------------------------------------------------------
  # * Imposta l'eroe e aggiorna la finestra
  # @param [Game_Actor] actor
  #--------------------------------------------------------------------------
  def set_actor(actor)
    @actor = actor
    @clone = nil
    refresh
  end

  # Restituisce l'elenco dei parametri da visualizzare
  # @return [Array<Symbol>]
  def params
    EquipSettings::PARAMS
  end

  # Restituisce l'icona del parametro
  # @param [Symbol] param
  # @return [Integer]
  def param_icon(param)
    EquipSettings::ICONS[param]
  end

  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di righe
  # @return [Integer]
  #--------------------------------------------------------------------------
  def max_lines;
    4;
  end

  #--------------------------------------------------------------------------
  # * Restituisce la posizione x dove cominciano i parametri
  # @return [Integer]
  #--------------------------------------------------------------------------
  def params_rect_x;
    250;
  end

  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di colonne visualizzabili
  # @return [Integer]
  #--------------------------------------------------------------------------
  def max_columns;
    (params.size / max_lines.to_f).ceil;
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'eroe clonato
  #--------------------------------------------------------------------------
  def actor_clone;
    @clone;
  end

  #--------------------------------------------------------------------------
  # * Imposta l'oggetto da equiparare
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def set_item(item, slot_type, clear = false)
    return if @last_item == item.id && @last_slot_type == slot_type
    @last_item = item.id
    @last_slot_type = slot_type
    if clear
      @clone = nil
    else
      @clone = clone_actor
      @clone.change_equip(slot_type, item, true)
    end
    refresh_params_rect
  end

  #--------------------------------------------------------------------------
  # * Restituisce un clone scollegato dell'eroe (per evitare bug)
  # @return [Game_Actor]
  # noinspection RubyResolve
  #--------------------------------------------------------------------------
  def clone_actor
    Marshal.load(Marshal.dump(actor))
  end

  #--------------------------------------------------------------------------
  # * Pulisce gli oggetti
  #--------------------------------------------------------------------------
  def clear_items
    set_item(nil, nil, true)
  end

  #--------------------------------------------------------------------------
  # * Reimposta la bitmap
  #--------------------------------------------------------------------------
  def refresh_params_rect
    x = params_rect_x
    contents.clear_rect(x, 0, contents_width - x, contents_height)
    draw_actor_params
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless actor
    draw_actor_basic_info
    draw_actor_params
  end

  #--------------------------------------------------------------------------
  # * Disegna le informazioni base dell'eroe
  #--------------------------------------------------------------------------
  def draw_actor_basic_info
    draw_actor_face(actor, 0, 0)
    draw_actor_name(actor, 100, 0)
    draw_actor_level(actor, 100, line_height)
    draw_actor_class(actor, 100, line_height * 2)
  end

  #--------------------------------------------------------------------------
  # * Disegna i parametri dell'eroe
  #--------------------------------------------------------------------------
  def draw_actor_params
    width = (contents_width - params_rect_x) / max_columns
    (0..params.size - 1).each {|i|
      next if params[i].nil?
      x = (i % max_columns) * width
      y = (i / max_columns) * line_height
      w = width
      w *= 2 if EquipSettings.param_dsized?(params[i])
      draw_param(x + params_rect_x, y, params[i], w)
    }
  end

  #--------------------------------------------------------------------------
  # * Disegna il parametro fissato
  # @param [Integer] x
  # @param [Integer] y
  # @param [Symbol] param_type
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def draw_param(x, y, param_type, width)
    if param_type == :mmp && actor.charge_gauge?
      draw_param(x, y, :mag, width)
      return
    end
    draw_bg_rect(x, y, width)
    param = actor_parameter(actor, param_type)
    draw_icon(param_icon(param_type), x, y)
    drawing_width = (width - 48) / 2
    change_color(normal_color)
    text = param.to_s
    text = sprintf('%d%%', param) if param_perc?(param_type)
    draw_text(x + 24, y, drawing_width, line_height, text)
    if actor_clone != nil
      x2 = x + 48 + drawing_width
      param2 = actor_parameter(actor_clone, param_type)
      case param <=> param2
      when 0
        change_color(normal_color)
      when -1 #migliore
        change_color(power_up_color)
      when 1 #peggiore
        change_color(power_down_color)
      else
        change_color(anger_color)
      end
      text = param2
      text = sprintf('%d%%', param2) if param_perc?(param_type)
      draw_text(x2, y, drawing_width, line_height, text)
      draw_text(x + 24, y, width - 24, line_height, '>', 1)
    end
  end

  #--------------------------------------------------------------------------
  # * Restituisce il parametro dell'eroe
  # @param [Game_Actor] actor
  # @param [Symbol] param_type
  # @return [Integer]
  #--------------------------------------------------------------------------
  def actor_parameter(actor, param_type)
    return unless actor
    eval("actor.#{param_type}")
  end

  #--------------------------------------------------------------------------
  # * Determina se il parametro viene mostrato in percentuale
  # @param [Symbol] param
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def param_perc?(param)
    EquipSettings::PARAM_PERCENTAGES.include?(param)
  end

  #--------------------------------------------------------------------------
  # * Rimuove l'equip dalla valutazione
  #--------------------------------------------------------------------------
  def remove_item
    @clone = nil
    refresh_params_rect
  end
end

#==============================================================================
# ** Window_ActorEquips
#------------------------------------------------------------------------------
# Finestra dei tipi di equip dell'eroe
#==============================================================================
class Window_ActorEquips < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.index = 0
    @attached_windows = []
    @data = 0
    refresh
  end

  #--------------------------------------------------------------------------
  # * Aggiorna il contenuto della finestra
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    return if actor.nil?
    draw_equip_categories
    draw_equipment_items
  end

  #--------------------------------------------------------------------------
  # * Imposta l'eroe
  # @param [Game_Actor] actor
  #--------------------------------------------------------------------------
  def set_actor(actor)
    @actor = actor
    refresh
  end

  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di oggetti
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max;
    actor.nil? ? 0 : actor.equip_type.size + 1;
  end

  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di colonne
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max;
    1;
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def item(index = @index)
    return nil if actor.nil?
    actor.equips[slot_type(index)]
  end

  #--------------------------------------------------------------------------
  # * Determina se l'oggetto selezionato è attivo
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(item)
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
    @attached_windows.each do |window|
      if window.is_a?(Window_ActorStats)
        window.set_item(item, slot_type)
      else
        window.set_item(item)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Aggiunge una finestra per aggiornarsi
  # @param [Window_Base] window
  #--------------------------------------------------------------------------
  def attach_window(window)
    @attached_windows.push(window)
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'eroe della finestra
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def actor;
    @actor;
  end

  #--------------------------------------------------------------------------
  # * La larghezza del testo della categoria equip
  # @return [Integer]
  #--------------------------------------------------------------------------
  def category_width
    if @cat_width.nil?
      vocabs = EquipSettings.type_vocabs
      @cat_width = vocabs.collect {|x| contents.text_size(x).width}.max + 5
    end
    @cat_width
  end

  #--------------------------------------------------------------------------
  # * Disegna le categorie d'equipaggiamento
  #--------------------------------------------------------------------------
  def draw_equip_categories
    change_color(system_color)
    (0..actor.equip_type.size).each {|i|
      if i == 0 and actor.first_weapon != nil and actor.first_weapon.two_handed
        text = actor.first_weapon.two_hand_text
      elsif i == 0
        text = Vocab.equip_type(:weapon)
      elsif i == 1 and actor.two_swords_style
        text = Vocab.equip_type(:weapon)
      elsif i == 1 and actor.first_weapon != nil and actor.first_weapon.two_handed
        text = ''
      elsif i ==1 and actor.first_weapon != nil and actor.first_weapon.changes_support_type?
        text = EquipSettings::SUPPORT_CHANGE_WEAPON_GROUPS[actor.first_weapon.use_support][0]
      else
        text = Vocab.equip_type(equip_category(i))
      end
      draw_text(0, line_height * i, category_width, line_height, text, 2)
    }
  end

  #--------------------------------------------------------------------------
  # * Disegna gli oggetti equipaggiati
  #--------------------------------------------------------------------------
  def draw_equipment_items
    change_color(normal_color)
    (0..actor.equip_type.size).each {|i| draw_item(i) }
  end

  #--------------------------------------------------------------------------
  # * Disegna lo slot vuoto
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def draw_empty_slot(x, y, width, index)
    draw_text(x, y, width, line_height, Vocab.equip_none(slot_type(index)))
  end

  #--------------------------------------------------------------------------
  # * Restituisce il tipo dato dall'indice
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def slot_type(index = self.index)
    index
  end

  # * Disegna l'oggetto
  # @param [Integer] index
  def draw_item(index)
    rect = item_rect(index)
    draw_bg_rect(rect.x, rect.y, rect.width)
    if item(index)
      item = item(index)
      draw_item_name(item, rect.x, rect.y, enable?(item), rect.width)
    elsif index == 1 && first_weapon_two_handed? || index == 0 && second_weapon_two_handed?
      item = index == 0 ? item(1) : item(0)
      draw_item_name(item, rect.x, rect.y, false, rect.width)
    else
      draw_empty_slot(rect.x, rect.y, rect.width, index)
    end
  end

  def first_weapon_two_handed?
    item(0) != nil && item(0).two_handed
  end

  def second_weapon_two_handed?
    item(1) != nil && item(1).is_a?(RPG::Weapon) && item(1).two_handed
  end

  #--------------------------------------------------------------------------
  # * Restituisce se l'equipaggiamento può essere sostituito
  # @param [RPG::BaseItem] item
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def enable?(item)
    !actor.fix_equipment && (item.nil? or !item.equip_locked?)
  end

  #--------------------------------------------------------------------------
  # * Restituisce il rettangolo dell'oggetto
  # @param [Integer] index
  # @return [Rect]
  #--------------------------------------------------------------------------
  def item_rect(index = self.index)
    rect = super(index)
    rect.x += category_width
    rect.width -= category_width
    rect
  end

  #--------------------------------------------------------------------------
  # Determina se l'equipaggiamento può essere sostituito
  # @deprecated
  # @param [Integer] index
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def equip_changable?(index)
    if index == 0 or (index == 1 and @actor.two_swords_style)
      type = :weapon
    else
      type = @actor.equip_type[index - 1]
    end
    type
  end

  #--------------------------------------------------------------------------
  # Determina il tipo di equipaggiamento
  # @param [Integer] ndex
  # @return [Symbol]
  #--------------------------------------------------------------------------
  def equip_category(ndex = self.index)
    if ndex == 0 or (ndex == 1 and actor.two_swords_style)
      :weapon
    else
      actor.equip_type[ndex - 1]
    end
  end
end

#==============================================================================
# ** Window_EquipList
#------------------------------------------------------------------------------
# Finestra degli equip dell'eroe
#==============================================================================
class Window_EquipList < Window_Selectable
  attr_reader :category
  attr_accessor :equip_slot
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @data = []
    @equip_slot = 0
    @attached_windows = []
    @category = :weapon
    refresh
  end

  #--------------------------------------------------------------------------
  # * Ottiene la lista degli oggetti
  #--------------------------------------------------------------------------
  def make_item_list
    @data = ($game_party.all_items + $game_party.placeholder_armors).select {|item| check_condition(item)}
    sort_data
    @data += [nil] if EquipSettings.can_unequip?(self.category)
  end

  #--------------------------------------------------------------------------
  # * Ordina l'array
  #--------------------------------------------------------------------------
  def sort_data
    @data.sort! {|x, y| y.tier <=> x.tier}
  end

  #--------------------------------------------------------------------------
  # * Restituisce se la condizione di presenza è soddisfatta
  # @param [RPG::Weapon, RPG::Armor] item
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def check_condition(item)
    return false if @category.nil?
    return false if item.nil?
    return false if actor.nil?
    return false unless actor.ex_attr_equippable?(item)
    if @category == :weapon
      return true if item.is_a?(RPG::Weapon)
    elsif item.is_a?(RPG::Armor)
      kind = EquipSettings.equip_type(@category)
      return item.kind == kind
    end
    false
  end

  #--------------------------------------------------------------------------
  # * Imposta il tipo di equipaggiamento da mostrare in finestra
  # @deprecated
  # @param [Symbol] category
  #--------------------------------------------------------------------------
  def set_type(category)
    @category = category
    refresh
  end

  #--------------------------------------------------------------------------
  # * Imposta il tipo di equipaggiamento da mostrare in finestra
  # @param [Symbol] new_cat
  #--------------------------------------------------------------------------
  def category=(new_cat)
    return if @category == new_cat
    @category = new_cat
    refresh
  end

  #--------------------------------------------------------------------------
  # * Imposta l'eroe della finestra
  # @param [Game_Actor] new_actor
  #--------------------------------------------------------------------------
  def set_actor(new_actor)
    return if @actor == new_actor
    @actor = new_actor
    refresh
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'eroe
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def actor;
    @actor;
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
    make_item_list
    create_contents
    draw_all_items
  end

  #--------------------------------------------------------------------------
  # * Restituisce il numero di oggetti posseduti
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end

  #--------------------------------------------------------------------------
  # * Restituisce il numero di colonne
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max
    1
  end

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
    enable?(@data[self.index])
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto ad un indice stabilito
  # @param [Integer] index
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def data(index)
    @data[index];
  end

  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = data(index)
    rect = item_rect(index)
    rect.width -= 4
    if item
      draw_item_name(item, rect.x, rect.y, enable?(item), rect.width)
      draw_item_number(rect, item)
    else
      draw_empty_item(rect.x, rect.y)
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna il blocco per disequipaggiare
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_empty_item(x, y)
    change_color(crisis_color)
    draw_icon(EquipSettings::UNEQUIP_ICON, x, y)
    draw_text(x + 24, y, contents_width - x, line_height, Vocab.equip_none(category))
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
    @attached_windows.each do |window|
      if window.is_a?(Window_ActorStats)
        window.set_item(item, @equip_slot)
      else
        window.set_item(item)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Restituisce se l'oggetto è disponibile
  # @param [RPG::Item] item
  #--------------------------------------------------------------------------
  def enable?(item)
    return false if actor.nil?
    return true if item.nil?
    actor.equippable?(item) && actor.level >= item.equip_level
  end

  #--------------------------------------------------------------------------
  # * Disegna il numero degli oggetti posseduti
  # @param [Rect] rect
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    draw_text(rect, sprintf('x%2d', $game_party.item_number(item)), 2)
  end
end

#==============================================================================
# ** Window_EquipHelp
#------------------------------------------------------------------------------
# Mostra i comandi della schermata equipaggiamenti
#==============================================================================
class Window_EquipHelp < Window_Base
  def initialize(x, y, width)
    super(x, y, width, fitting_height(1))
    refresh
  end

  #--------------------------------------------------------------------------
  # * Scrittura
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    draw_help_remove
    draw_help_change
  end

  #--------------------------------------------------------------------------
  # * Scrive l'aiuto di rimuovere l'equip
  #--------------------------------------------------------------------------
  def draw_help_remove
    draw_key_icon(:X, 0, 0)
    draw_text(24, 0, contents_width / 2 - 24, line_height, Vocab.help_remove)
  end

  #--------------------------------------------------------------------------
  # * Scrive l'aiuto di cambiare eroe
  #--------------------------------------------------------------------------
  def draw_help_change
    width = 50 + text_size(Vocab.help_actor_change).width
    x = contents_width - width
    draw_key_icon(:LEFT, x, 0)
    draw_text(x, 0, width, line_height, Vocab.help_actor_change, 1)
    draw_key_icon(:RIGHT, contents_width - 24, 0)
  end
end

#==============================================================================
# ** Scene_NewEquip
#------------------------------------------------------------------------------
# La nuova schermata degli equipaggiamenti. Piuttosto che riscrivere la
# precedente, ho preferito crearne una completamente nuova.
#==============================================================================
class Scene_NewEquip < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Creazione delle finestre
  #--------------------------------------------------------------------------
  def start
    super
    create_actor_window
    create_help_window
    create_details_window
    create_command_help_window
    create_equips_window
    create_item_window
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'eroe attuale
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def actor;
    @actor;
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra delle informazioni sull'eroe
  #--------------------------------------------------------------------------
  def create_actor_window
    @actor_window = Window_ActorStats.new(0, @actor)
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra d'aiuto
  #--------------------------------------------------------------------------
  def create_help_window
    super
    @help_window.y = @actor_window.by
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra degli slot equipaggiamenti
  #--------------------------------------------------------------------------
  def create_equips_window
    y = @help_window.by
    width = equip_width
    height = Graphics.height - y - @comm_help_window.height
    @equip_window = Window_ActorEquips.new(0, y, width, height)
    @equip_window.set_actor(actor)
    @equip_window.help_window = @help_window
    @equip_window.attach_window(@details_window)
    @equip_window.set_handler(:ok, method(:equip_selection))
    @equip_window.set_handler(:cancel, method(:return_scene))
    @equip_window.set_handler(:function, method(:unequip))
    @equip_window.set_handler(:right, method(:next_actor))
    @equip_window.set_handler(:left, method(:prev_actor))
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra aiuto equipaggiamento
  #--------------------------------------------------------------------------
  def create_command_help_window
    @comm_help_window = Window_EquipHelp.new(0, 0, equip_width)
    @comm_help_window.y = Graphics.height - @comm_help_window.height
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra dell'elenco oggetti
  #--------------------------------------------------------------------------
  def create_item_window
    y = @help_window.by
    width = equip_width
    height = Graphics.height - y
    @item_window = Window_EquipList.new(0, y, width, height)
    @item_window.help_window = @help_window
    @item_window.visible = false
    @item_window.deactivate
    @item_window.attach_window(@actor_window)
    @item_window.attach_window(@details_window)
    @item_window.set_actor(actor)
    @item_window.set_handler(:ok, method(:item_selection))
    @item_window.set_handler(:cancel, method(:back_selection))
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra dei dettagli oggetto
  #--------------------------------------------------------------------------
  def create_details_window
    x = equip_width
    y = @help_window.by
    width = Graphics.width - x
    height = Graphics.height - y
    @details_window = Window_ItemInfo.new(x, y, width, height)
    @details_window.set_actor(@actor)
  end

  #--------------------------------------------------------------------------
  # * Attiva la selezione dell'equipaggiamento
  #--------------------------------------------------------------------------
  def equip_selection
    @item_window.category = @equip_window.equip_category
    @item_window.equip_slot = @equip_window.index
    @item_window.index = 0
    show_items
  end

  #--------------------------------------------------------------------------
  # * La larghezza della finestra di equipaggiamento
  #--------------------------------------------------------------------------
  def equip_width
    EquipSettings::EQUIP_WIDTH
  end

  #--------------------------------------------------------------------------
  # * Seleziona un oggetto da equipaggiare
  #--------------------------------------------------------------------------
  def item_selection
    Sound.play_equip
    actor.change_equip(@equip_window.index, @item_window.item)
    @actor_window.refresh
    @equip_window.refresh
    @item_window.refresh
    cover_items
  end

  #--------------------------------------------------------------------------
  # * Rimuove l'equip selezionato
  #--------------------------------------------------------------------------
  def unequip
    Sound.play_equip
    actor.change_equip(@equip_window.index, nil)
    @actor_window.refresh
    @equip_window.refresh
    @item_window.refresh
  end

  #--------------------------------------------------------------------------
  # * Torna indietro
  #--------------------------------------------------------------------------
  def back_selection
    cover_items
  end

  #--------------------------------------------------------------------------
  # * Mostra la finestra degli oggetti
  #--------------------------------------------------------------------------
  def show_items
    @item_window.y = Graphics.height
    @item_window.visible = true
    @equip_window.smooth_move(0 - @equip_window.width, @equip_window.y)
    @item_window.smooth_move(0, @help_window.by)
    @comm_help_window.smooth_move(0, Graphics.height)
    @item_window.activate
  end

  #--------------------------------------------------------------------------
  # * Nasconde la finestra degli oggetti
  #--------------------------------------------------------------------------
  def cover_items
    @item_window.smooth_move(0, Graphics.height)
    @equip_window.smooth_move(0, @help_window.by)
    @comm_help_window.smooth_move(0, Graphics.height - @comm_help_window.height)
    @equip_window.activate
    @actor_window.clear_items
  end

  #--------------------------------------------------------------------------
  # * Aggiorna le finestre al cambiamento degli eroi
  #--------------------------------------------------------------------------
  def on_actor_change
    @equip_window.set_actor($game_party.menu_actor)
    @actor_window.set_actor($game_party.menu_actor)
    @item_window.set_actor($game_party.menu_actor)
    @details_window.set_actor($game_party.menu_actor)
    @equip_window.activate
  end
end