#==============================================================================
# ** H87Item
#------------------------------------------------------------------------------
# modulo base con impostazioni per settare lo script
#==============================================================================
module H87Item
  # IMPOSTAZIONI DELLO SCRIPT
  module Settings
    # Disegnare il prezzo di vendita dell'oggetto?
    DRAW_PRICE = true
    # Impostare la formula di vendita
    SELLPRICE_FORMULAS = {
      :default => 'item.price / 3',
      :weapons => 'item.price / 3',
      :armors => 'item.price / 2',
      :items => 'item.price * 3 / 4'
    }
    # Dettagli da disegnare per oggetti e skill
    USABLE_DETAILS = [
      :scope,
      :formula,
      :mp_damage,
      :elements,
      :absorb,
      :type_effectiveness,
      :plus_state_set,
      :minus_state_set,
      :anger_rate,
      :state_properties
    ]
    # Dettagli da disegnare negli oggetti
    ITEM_DETAILS = [:hp_recover, :mp_recover, :param_growth,]
    # Dettagli da disegnare nelle skill
    SKILL_DETAILS = [
      :skill_hit, :cri, :autostate, :charge_time, :recharge, :total_aggro, :state_inf_bonus,
      :state_inf_dur, :sin_bonus, :esper, :mp_cost, :hp_cost, :anger_cost, :item_cost,
      :gold_cost, :skill_requirements, :skill_extensions, :max_assimilable_skills,
      :steal_skill, :robbery_skill
    ]
    # quali dettagli mostrare per gli attributi comuni di equipaggiamento,
    COMMON_DETAILS = [:hit, :cri, :eva, :odds, :element_rates, :state_rates,
                      :element_amplifiers, :hp_on_guard, :mp_on_guard,
                      :hp_on_win, :mp_on_win, :charge_bonus, :normal_attack_bonus,
                      :heal_amplify, :heal_rate, :dom_bonus, :incentive, :sin_durab,
                      :sin_bonus, :sin_on_kill, :sin_on_guard, :sin_on_cri, :sin_on_weak,
                      :sin_on_heal, :sin_on_eva, :sin_on_start, :sin_on_state,
                      :atb_base, :steal_bonus, :buy_discount, :sell_bonus,
                      :drop_bonus, :gold_bonus, :exp_bonus, :ap_bonus, :mp_cost_rate,
                      :hp_on_kill, :mp_on_kill, :anger_bonus, :anger_init,
                      :anger_kill, :anger_turn, :max_anger, :anger_damage, :magic_def,
                      :magic_dmg, :physical_dmg, :buff_durability, :debuff_durability,
                      :state_inf_per, :state_inf_dur, :critical_damage, :synth_bonus,
                      :low_hpmp_bonus,  :battle_triggers]
    EQUIP_DETAILS = [:rarity, :required_level, :atk, :def, :spi, :agi, :stat_bonuses,
                     :magic_states_plus, :heal_states_plus, :recharge, :perpetual_states]
    ARMOR_DETAILS = [:armor_kind, :protected_states, :halved_elements, :set_bonus]
    WEAPON_DETAILS = [:weapon_kind, :elements, :plus_state_set, :type_effectiveness, :weapon_power_ups]
    STATE_DETAILS = [:stat_bonuses, :duration, :restrictions, :slip_damages, :resistances, :protected_states,
                     :attack_elements, :halved_elements, :state_extensions, :apeiron]
    # la grandezza del testo dei dettagli. Se 0, usa predefinito
    TEXTSIZE = 0
    # le categorie degli oggetti
    ITEM_CATEGORIES = {
      1 => [:usable, 'Utilizzabili'],
      2 => [:resource, 'Materiali'],
      3 => [:weapon, 'Armi'],
      4 => [:armor, 'Armature'],
      5 => [:key, 'Importanti'],
      6 => [:battle, 'Battaglia']
    }

    FEATURE_SHOW_CONDITION = {
      :ranged? => 'item.is_a?(RPG::Weapon) or item.for_opponent?',
      :ignore_defense => 'item.is_a?(RPG::Weapon) or item.for_opponent?'
    }
  end

  # prezzo di vendita predefinito
  def self.default_sell_price(item)
    formulas = Settings::SELLPRICE_FORMULAS
    case item
    when RPG::Item
      eval formulas[:items]
    when RPG::Armor
      eval formulas[:armors]
    when RPG::Weapon
      eval formulas[:weapons]
    else
      eval formulas[:default]
    end
  end
end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
# Nuovi vocaboli per oggetti e dettagli
#==============================================================================
module Vocab
  # vari vocaboli
  ITEM_SCOPE = 'Bersaglio'
  ITEM_USE = 'Uso'
  ITEM_DAMAGE = 'Danno %s'
  ITEM_ELEMENT = 'Elemento'
  ITEM_ABSORB = 'Assorbe il danno'
  ITEM_RECOVER = 'Recupero %s'
  ITEM_POSSESS = 'Posseduti'
  ITEM_CONSUME = 'Consuma'
  ITEM_COST = 'Costo %s'
  SKILL_ATK_F = 'Inf. Attacco'
  SKILL_SPI_F = 'Inf. Spirito'
  SKILL_DEF_F = 'Inf. Difesa'
  SKILL_AGI_F = 'Inf. Velocità'
  EQUIP_KIND = 'Tipo'
  WEAPON_STATE = 'Infligge'
  ARMOR_ELEMENT = 'Dimezza elemento'
  ARMOR_ATTRIBUTE = 'Dimezza danni da'
  ATTACK_ATTRIBUTE = 'Tipo danni'
  ATTR_EFFECTIVENESS = 'Efficace contro %s'
  STATE_DURATION = 'Durata'
  STATE_DURATION_TURNS = '%d turni'
  STATE_DURATION_TURN = 'un turno'
  RESTRICTIONS = [
    'Nessuna', 'Impossibile usare magie', 'Perdita di controllo',
    'Attacca gli alleati', 'Blocca le mosse', 'Blocca i movimenti'
  ]
  STATE_RESISTANCE = 'Prob. Media'

  # Vocaboli per l'obiettivo
  SCOPES = [
    'Nessuno',
    'Un nemico',
    'Tutti i nemici',
    'Un nemico, due volte',
    'Un nemico a caso',
    'Due nemici a caso',
    'Tre nemici a caso',
    'Alleato',
    'Alleati',
    'Alleato KO',
    'Alleati KO',
    'L\'utilizzatore',
    'Tutti i presenti',
    'Nemici specifici',
    'Altri alleati'
  ]
  # Vocaboli per il tipo di armatura
  ARMOR_KINDS = {
    0 => 'Supporto',
    1 => 'Elmo',
    2 => 'Corpo',
    3 => 'Accessorio',
    7 => 'Magnetite',
  }
  # Vocaboli per l'occasione
  OCCASIONS = ['Sempre', 'Solo in battaglia', 'Solo dal Menu', 'Mai']
  # Restituisce il bersaglio
  def self.scope(id)
    SCOPES[id]
  end

  # Restituisce l'occasione
  def self.occasion(id)
    OCCASIONS[id]
  end

  # Restituisce il tipo di armatura
  def self.armor_kind(kind)
    ARMOR_KINDS[kind]
  end

  def self.state_restriction(id)
    RESTRICTIONS[id]
  end

  # @param [Symbol] trigger_type
  # @return [Array<String>]
  def self.battle_trigger(trigger_type)
    description = {
      :state_on_eva => ['Quando si evita un attacco','Attiva %s (%d%% prob.)'],
      :state_on_heal => ['Con le magie curative','Causa %s (%d%% prob.)'],
      :state_on_off_skill =>  ['Con magie offensive','Causa %s (%d%% prob.)'],
      :state_on_damage => ['Quando si subiscono danni','Attiva %s (%d%% prob.)'],
      :state_on_curse => ['Quando si subiscono danni','Causa %s (%d%% prob.)'],
      :state_on_damage_user => ['Quando si viene attaccati da vicino','Causa %s (%d%% prob.)'],
      :state_on_defense => ['Quando attaccato durante Difendi','Causa %s (%d%% prob.)'],
    }[trigger_type]
    description ||= [trigger_type.to_s, '%s %d']
  end
end

#==============================================================================
# ** BaseItem
#------------------------------------------------------------------------------
#  Aggiunge gli elementi di BaseItem
#==============================================================================
class RPG::BaseItem
  attr_reader :custom_dets # dettaglio personalizzato con categoria
  attr_reader :custom_desc # dettaglio con sola descrizione
  attr_reader :no_description # nasconde la descrizione automatica se true
  attr_reader :key_item # oggetto chiave
  attr_reader :features # mostra le funzioni importanti
  attr_reader :resource # risorsa per la forgiatura
  attr_reader :use_method # metodo da usare per un oggetto
  attr_reader :use_scene # scena dove andare dopo l'uso di un oggetto
  attr_reader :max_number #numero massimo
  attr_reader :key_item # oggetto chiave?
  attr_reader :trade_lock #non permette lo scambio tra giocatori
  # caricamento dei dettagli personalizzati
  def load_custom_details
    return if @det_loaded
    @det_loaded = true
    @no_description = false
    @custom_dets = []
    @custom_desc = []
    @key_item = false
    @resource = false
    @features = []
    @sellprice = nil
    @trade_lock = false
    @max_number = H87Item::Settings::DEFAULT_MAX_ITEMS
    self.note.split(/[\r\n]+/).each { |line|
      case line
        #---
      when /<nessuna descrizione>/i, /<no info>/i
        @no_description = true
      when /<attr[ ]+(.*):[ ](.*)\[(\d+)]>/i
        @custom_dets.push([$1, $2, $3.to_i])
      when /<attr[ ]+(.*):[ ](.*)>/i
        @custom_dets.push([$1, $2, 0])
      when /<feature:[ ]*(.*)>/i
        @features.push($1)
      when /<cdesc:[ ]*(.*)>/i
        @custom_desc.push($1)
      when /<key[ ]+item>/i
        @key_item = true
      when /<ingrediente>/i
        @resource = true
      when /<tipoggetto:[ ]*(.*)>/i
        @category = $1.to_sym
      when /<sellprice:[ ]*(\d+)>/i
        @sellprice = $1.to_i
      when /<metd:[ ]*(.*)>/i
        @use_method = $1
      when /<scene:[ ]*(.*)>/i
        @use_scene = $1
      when /<num massimo:[ ]*(\d+)>/i
        @max_number = $1.to_i
      when /<blocca scambi>/i
        @trade_lock = true
      else
        # niente
      end
    }
  end

  # Restituisce true se è scambiabile tra giocatori
  def traddable?
    return false if is_key_item? #non traddabile se è una chiave
    return false if self.price == 0 #non traddabile se il prezzo è 0
    # noinspection RubyResolve
    return false if @trade_lock #non traddabile se bloccato da tag
    return false if @rarity > 1 # se è un oggetto da leggendario in su
    true #traddabile
  end

  # metodo alias sellable
  def sellable?
    traddable?
  end

  def is_key_item?
    @key_item
  end

  # Restituisce il prezzo di vendita
  # @return [Integer]
  def selling_price
    @sellprice || H87Item.default_sell_price(self)
  end

  # Restituisce la categoria
  # @return [Symbol]
  def category
    #return :in_battle if battle_ok? && $game_temp.in_battle
    return @category if @category != nil
    return :key if @key_item
    return :resource if @resource
    return :weapon if self.is_a?(RPG::Weapon)
    return :armor if self.is_a?(RPG::Armor)
    return :usable if menu_ok?
    return :battle if battle_ok?
    :generic
  end
end

class RPG::UsableItem
  def single_state?
    self.plus_state_set.size == 1
  end
end

class RPG::State
  attr_reader :custom_dets # dettaglio personalizzato con categoria
  attr_reader :custom_desc # dettaglio con sola descrizione
  attr_reader :no_description # nasconde la descrizione automatica se true
  attr_reader :features # mostra le funzioni importanti

  def load_custom_details
    return if @det_loaded
    @det_loaded = true
    @no_description = false
    @custom_dets = []
    @custom_desc = []
    @features = []
    self.note.split(/[\r\n]+/).each do |line|
      case line
        #---
      when /<nessuna descrizione>/i, /<no info>/i
        @no_description = true
      when /<attr[ ]+(.*):[ ](.*)\[(\d+)]>/i
        @custom_dets.push([$1, $2, $3.to_i])
      when /<attr[ ]+(.*):[ ](.*)>/i
        @custom_dets.push([$1, $2, 0])
      when /<feature:[ ]*(.*)>/i
        @features.push($1)
      when /<desc:[ ]*(.*)>/i
        @custom_desc.push($1)
      else
        # niente
      end
    end
  end

  # @return [Array<Symbol>]
  def extensions_sym
    self.extension.collect do |str|
      if str =~ /(\w+)\/[\d]+/
        $1.downcase.to_sym
      else
        nil
      end
    end.compact
  end
end

class RPG::Weapon
  # @return [Array<Integer>]
  def plus_state_set
    @state_set
  end
end

#==============================================================================
# ** Sprite_ItemPopup
#------------------------------------------------------------------------------
#  Mostra il numero di oggetti restante
#==============================================================================
class Sprite_ItemPopup < Sprite
  attr_accessor :padding
  # Inizializzazione
  def initialize(viewport)
    super(viewport)
    self.visible = false
    @padding = 2
    @item = nil
  end

  # Imposta l'oggetto
  # @param[RPG::BaseItem]
  def set_item(item)
    @item = item
    refresh_bitmap
  end

  # Numero di oggetti posseduti
  def item_number
    $game_party.item_number(@item)
  end

  # Aggiorna la bitmap
  def refresh_bitmap
    self.bitmap = create_bitmap
    draw_on_bitmap
  end

  # Crea o pulisce la bitmap
  # @return [Bitmap]
  def create_bitmap
    if self.bitmap.nil?
      bitmap = Bitmap.new(70, 28)
      bitmap.font.color = Color::WHITE
      bitmap.font.shadow = false
    else
      bitmap = self.bitmap
      bitmap.clear
    end
    w = bitmap.width - self.padding * 2
    h = bitmap.height - self.padding * 2
    bitmap.fill_rect(self.padding, self.padding, w, h, Color.new(0, 0, 0, 170))
    bitmap.blur
    bitmap
  end

  # Disegna sulla bitmap
  def draw_on_bitmap
    return if @item.nil?
    bitmap = self.bitmap
    bitmap.draw_icon(@item.icon_index, self.padding, self.padding, item_number > 0)
    w = self.width - 24 - self.padding * 2
    h = self.height - self.padding * 2
    text = sprintf('x%d', item_number)
    bitmap.font.color.alpha = item_number > 0 ? 255 : 128
    bitmap.draw_text(24 + self.padding, self.padding, w, h, text)
  end
end

#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  La schermata degli oggetti (ridisegnata)
# noinspection RubyResolve
#==============================================================================
class Scene_Item < Scene_Base
  alias h87item_start start unless $@
  alias h87item_terminate terminate unless $@
  alias h87item_update update unless $@
  alias h87item_use_item_nontarget use_item_nontarget unless $@
  # Inizio
  def start
    #super
    create_main_viewport
    h87item_start
    create_popup_viewport
    adjust_windows
    create_category_window
    create_info_window
    create_item_number_popup
  end

  # Adatta le finestre
  def adjust_windows
    #@item_window.width = Graphics.width/2
    @target_window.x = 0 - @target_window.width
    @target_window.height = Graphics.height - @target_window.y
  end

  # Fine
  def terminate
    #super
    h87item_terminate
    @category_window.dispose
    @info_window.dispose
    @item_popup.dispose
    @popup_viewport.dispose
  end

  # Aggiornamento
  def update
    #super
    h87item_update
    @category_window.update
    @viewport.update
    @item_popup.y = @target_window.strcursor.y + 30 if @item_popup.visible
  end

  # Crea la finestra delle categorie
  # noinspection RubyArgCount
  def create_category_window
    @category_window = Window_ItemCategory.new(0, 0, 4)
    #@category_window.viewport = @viewport
    @item_window.set_category_window(@category_window)
    @category_window.set_list(@item_window)
    @target_window.visible = false
  end

  def create_popup_viewport
    @popup_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @popup_viewport.z = 999
  end

  # Crea la finestra delle informazioni
  def create_info_window
    x = @item_window.width
    y = @item_window.y
    w = Graphics.width - x
    h = Graphics.height - y
    @info_window = Window_ItemInfo.new(x, y, w, h)
    @item_window.set_info_window(@info_window)
    @info_window.viewport = @viewport
  end

  def create_item_number_popup
    @item_popup = Sprite_ItemPopup.new(@popup_viewport)
    @item_popup.z = 999
  end

  # Nada!
  def return_scene
  end

  # Aggiornamento della selezione oggetto
  def update_item_selection
    if Input.trigger?(:B)
      Sound.play_cancel
      return_scene
    elsif Input.trigger?(:C)
      @item = @item_window.item
      if @item != nil
        $game_party.last_item_id = @item.id
      end
      if $game_party.item_can_use?(@item)
        Sound.play_decision
        determine_item
      else
        Sound.play_buzzer
      end
    end
  end

  # Show Target Window
  #     right : Right justification flag (if false, left justification)
  # noinspection RubyUnusedLocalVariable
  def show_target_window(right)
    @item_window.active = false
    @target_window.x = 0 - @target_window.width
    @viewport.smooth_move(@target_window.width, 0)
    @target_window.smooth_move(0, 0)
    @target_window.visible = true
    @target_window.active = true
    #if @item_popup
    @item_popup.set_item(@item_window.item)
    @item_popup.visible = true
    @item_popup.x = 10
    #end
  end

  # Hide Target Window
  def hide_target_window
    @item_window.active = true
    @target_window.active = false
    @viewport.smooth_move(0, 0)
    @target_window.smooth_move(0 - @target_window.width, 0)
    @item_popup.visible = false if @item_popup && !@item_popup.disposed?
  end

  # Usa un oggetto senza bersaglio
  def use_item_nontarget
    if @item.use_method != nil
      eval(@item.use_method)
    elsif @item.use_scene != nil
      SceneManager.call(eval(@item.use_scene))
    else
      h87item_use_item_nontarget
      @item_popup.refresh_bitmap
    end
  end
end

#==============================================================================
# ** Window_ItemInfo
#------------------------------------------------------------------------------
# finestra che mostra i dettagli dell'oggetto
#==============================================================================
class Window_ItemInfo < Window_DataInfo
  # Variabili d'istanza pubbliche
  attr_accessor :see_possessed # visualizza la quantità posseduta
  attr_accessor :show_requirements
  attr_accessor :show_item_name
  attr_accessor :hidden_stats

  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] w
  # @param [Integer] h
  def initialize(x, y, w, h)
    @see_possessed = false
    @see_sellprice = H87Item::Settings::DRAW_PRICE
    refresh_size
    super(x, y, w, h)
  end

  # Riaggiorna il contenuto
  def refresh
    @line = 0
    contents.clear
    return if item.nil?
    draw_item_data
  end

  def update
    super
    return unless visible
    update_scrolling
  end

  def update_scrolling
    return if item.nil?
    return if contents.height <= contents_height
    # reset quando arrivato alla fine
    if scrolling_at_end? and @timing <= 0
      return reset_content_position
    end
    # attesa prima di cominciare a scorrere
    if self.oy == 0 and @timing < H87Item::Settings::SCROLL_FRAME_WAIT
      return @timing += 1
    end
    # attesa quando arriva alla fine
    if scrolling_at_end?
      return @timing -= 1
    end
    # scorrimento
    self.oy += H87Item::Settings::SCROLL_FRAME_SPEED
  end

  def scrolling_at_end?
    self.oy + contents_height > contents.height
  end

  # ottiene il rettangolo corrente
  # @return [Rect]
  def current_rect
    @line = 0 if @line.nil?
    rect = Rect.new(0, @line, contents_width, line_height)
    if @original_item != nil
      rect.x += 12
      rect.width -= 12
    end
    rect
  end

  # crea i contenuti della finestra. Il flag test serve per creare
  # un contents senza altezza
  # @param [Boolean] test
  def create_contents(test = false)
    contents.dispose
    if contents_width > 0 && contents_height > 0 && !test
      self.contents = Bitmap.new(contents_width, calc_contents_height)
    else
      self.contents = Bitmap.new(1, 1)
    end
  end

  # Imposta un oggetto
  # @param [RPG::BaseItem, nil] new_item
  def set_item(new_item)
    return if @item.equal?(new_item)
    @item = new_item
    reset_content_position
    create_contents
    refresh
  end

  def reset_content_position
    self.oy = 0
    @timing = 0
  end

  # @return [Fixnum]
  #noinspection RubyYardReturnMatch
  def calc_contents_height
    @simulate = true
    @line = 0
    draw_item_data
    @simulate = false
    height = @line
    @line = 0
    [height, contents_height].max
  end

  # Restituisce l'oggetto della finestra
  # @return [RPG::UsableItem,RPG::Armor,RPG::Weapon, RPG::Skill, RPG::State]
  def item
    @item
  end

  # Restituisce l'oggetto iniziale della finestra
  # @return [RPG::UsableItem,RPG::Armor,RPG::Weapon, RPG::Skill, RPG::State, nil]
  def original_item
    @original_item
  end

  # Disegna i dati principali dell'oggetto
  def draw_item_data
    return if item.nil?
    draw_current_item_name if @show_item_name
    draw_item_possessed if @see_possessed
    draw_item_price
    draw_skill_learn_requirements
    unless item.no_description
      case item
      when RPG::Item
        draw_usable_item_detail
        draw_item_detail
      when RPG::Weapon
        draw_equip_detail
        draw_weapon_detail
        draw_common_detail
      when RPG::Armor
        draw_equip_detail
        draw_armor_detail
        draw_common_detail
      when RPG::Skill
        draw_usable_item_detail
        draw_skill_detail
      when RPG::State
        draw_state_detail
        draw_common_detail
      else
        # niente
      end
      draw_all_features
    end
    draw_item_custom_details
  end

  # @param [Array<Symbol>] ary
  def draw_all_attributes(ary)
    ary.each { |element| draw_attribute(element) }
  end

  # disegna i dettagli comuni degli oggetti utilizzabili in battaglia o sul menu
  def draw_usable_item_detail
    draw_all_attributes H87Item::Settings::USABLE_DETAILS - @hidden_stats
  end

  # Disegna i dettagli di un oggetto
  def draw_item_detail
    draw_all_attributes H87Item::Settings::ITEM_DETAILS - @hidden_stats
  end

  # disegna i dettagli comuni a tutti gli oggetti
  def draw_common_detail
    draw_all_attributes H87Item::Settings::COMMON_DETAILS - @hidden_stats
  end

  # Disegna i dettagli dell'equipaggiamento
  def draw_equip_detail
    draw_all_attributes H87Item::Settings::EQUIP_DETAILS - @hidden_stats
  end

  # Disegna i dettagli dell'arma
  def draw_weapon_detail
    draw_all_attributes H87Item::Settings::WEAPON_DETAILS - @hidden_stats
  end

  # Disegna i dettagli dell'armatura
  def draw_armor_detail
    draw_all_attributes H87Item::Settings::ARMOR_DETAILS - @hidden_stats
  end

  # disegna i dettagli delle abilità
  def draw_skill_detail
    draw_all_attributes H87Item::Settings::SKILL_DETAILS - @hidden_stats
  end

  # disegna i dettagli degli status (per passive)
  def draw_state_detail
    draw_all_attributes H87Item::Settings::STATE_DETAILS - @hidden_stats
  end

  def draw_all_features
    parse_features(Settings::FEATURES.keys - @hidden_stats)
    parse_innested_features(Settings::VARIABLE_FEATURES.keys - @hidden_stats)
  end

  # Riaggiorna la grandezza
  def refresh_size
    if H87Item::Settings::TEXTSIZE != 0
      contents.font.size = H87Item::Settings::TEXTSIZE
    end
  end

  # Altezza delle lettere automatica in modo da massimizzare il contenuto
  # in finestra.
  # @return [Fixnum]
  def line_height
    return super if H87Item::Settings::TEXTSIZE == 0
    contents.text_size("A").height + 2
  end

  # disegna un determinato attributo. Controlla prima se c'è
  # il metodo draw_nome_attributo, altrimenti cerca in automatico
  # l'attributo dall'oggetto e lo disegna.
  def draw_attribute(attr_sym)
    method_name = sprintf('draw_%s', attr_sym).to_sym
    if self.class.method_defined?(method_name)
      self.send(method_name)
    else
      fetch_discrete_parameter(attr_sym)
    end
  end

  # disegna tutti i parametri contenuti nell'array. I parametri sono
  # definiti all'intnerno elle classi degli item. Se non esistono salta.
  # Questo metodo non dovrebbe essere più usato.
  # @deprecated parsare gli attributi è meglio.
  # @param [Array<Symbol>] parameter_array
  def parse_parameters(parameter_array)
    parameter_array.each do |param|
      fetch_discrete_parameter param
    end
  end

  def draw_current_item_name
    return if original_item
    unless @simulate
      rect = current_rect
      draw_item_name(item, rect.x, rect.y, true, rect.width)
    end

    @line += line_height
  end

  # @param [Array<Symbol>] feature_array
  def parse_features(feature_array)
    feature_array.each do |feature|
      next unless item.has? feature
      next if H87Item::Settings::FEATURE_SHOW_CONDITION[feature] &&
        !eval(H87Item::Settings::FEATURE_SHOW_CONDITION[feature])
      old_shadow = contents.font.shadow unless @simulate
      if Settings::FEATURE_COLORS[feature] and !@simulate
        color1 = get_feature_color(Settings::FEATURE_COLORS[feature][0])
        color2 = get_feature_color(Settings::FEATURE_COLORS[feature][1])
        if color2
          color2.deopacize!(100)
          contents.font.shadow = false
        end
      else
        color1 =  power_up_color
        color2 = nil
      end
      draw_feature Vocab.feature(feature), color1, color2
      contents.font.shadow = old_shadow unless @simulate
    end
  end

  # @return [Color, nil]
  def get_feature_color(val)
    return nil if val.nil?
    return self.send(val) if val.is_a?(Symbol)
    return text_color(val) if val.is_a?(Integer)
    return val if val.is_a?(Color)
    nil
  end

  # @param [Array<Symbol>] feature_array
  def parse_innested_features(feature_array)
    feature_array.each do |feature|
      next unless item.has? feature
      value = item.send(feature)
      val = Parameter_Value.new(feature).calc_val(value)
      draw_feature(Vocab.feature(feature, val))
    end
  end

  def fetch_discrete_parameter(param)
    value = item.get_val param
    return if value.nil? or value == 0
    param_data = Parameter_Value.new(param)
    value = param_data.calc_val value
    showed = param_data.parse_val value
    reverse = param_data.reverse?
    color = normal_color
    if value.is_a?(Numeric)
      if value > 0 or (value < 0 and reverse)
        color = power_up_color
      elsif value < 0 or (value > 0 and reverse)
        color = power_down_color
      end
    end
    icon = param_data.icon_index
    draw_detail(param_data.param_name, showed, icon, line_height, color, :left)
  end

  # Disegna un dettaglio generico
  # @param [String] param
  # @param [String, Integer, Float, nil] value
  # @param [Integer] icon
  # @param [Integer] height
  # @param [Color] color
  def draw_detail(param, value = nil, icon = 0, height = line_height,
                  color = normal_color, icon_pos = :right)
    if @simulate
      create_contents(true) if contents.disposed?
      x = (icon > 0 ? ICON_WIDTH : 0) + current_rect.x
      if text_width(param.to_s + value.to_s) + x > current_rect.width
        @line += height
      end
      return @line += height
    end
    rect = current_rect
    #draw_underline(@line / line_height)
    if value.nil?
      change_color(color)
      draw_text(rect, param, 1)
    else
      need_newline = text_width(param.to_s + value.to_s) + (icon > 0 ? ICON_WIDTH : 0) > rect.width
      if need_newline
        draw_bg_srect(rect.x, rect.y, rect.width, rect.height + line_height)
      else
        draw_bg_from_rect(rect)
      end
      if icon != 0 and icon_pos == :left
        draw_icon(icon, rect.x, rect.y)
        rect.x += ICON_WIDTH
        rect.width -= ICON_WIDTH
      end
      change_color(system_color)
      draw_text(rect, param)
      change_color(color)
      if need_newline
        @line += height
        rect.y += line_height
      end
      draw_text(rect, value, 2)
      #xx = width - contents.text_size(value).width - 28
      #draw_icon(icon, xx, y)
    end
    if icon != 0 and icon_pos == :right
      icon_x = rect.x + rect.width - (value != nil ? text_width(value.to_s) : 0) - ICON_WIDTH
      draw_icon(icon, icon_x, rect.y)
    end
    @line += height
  end

  # @param [Array<String>] lines
  # @param [Color] color
  # @param [nil, Color] bg_color
  def draw_multiline_feature(lines, color = normal_color, bg_color = nil)
    return @line += (line_height * lines.size) if @simulate
    rect = current_rect
    rect.height = line_height * lines.size
    if bg_color
      draw_bg_from_rect(rect, bg_color.deopacize(75), bg_color.deopacize)
    else
      draw_bg_from_rect(rect, sc2)
    end
    change_color color
    lines.each do |line|
      draw_text(current_rect, line, 1)
      @line += line_height
    end
  end

  # Mostra una funzione speciale
  # @param [String] feature
  # @param [Color] color
  # @param [Color] bg_color
  def draw_feature(feature, color = power_up_color, bg_color = nil)
    return @line += line_height if @simulate
    rect = current_rect
    if bg_color
      draw_bg_from_rect(rect, bg_color.deopacize(75), bg_color.deopacize)
    else
      draw_bg_from_rect(rect, sc2)
    end
    draw_detail(feature, nil, 0, line_height, color)
  end

  # Disegna un parametro
  # @param [String] param
  # @param [String, Integer] value
  # @param [Boolean] percentuale
  # @param [Integer] icon
  # @param [Boolean] reverse
  def draw_parameter(param, value, percentuale = false, icon = 0, reverse = false)
    return if value == 0
    color = normal_color
    color = power_up_color if value > 0 or (value < 0 and reverse)
    color = power_down_color if value < 0 or (value > 0 and reverse)
    perc = percentuale ? "%" : ""
    draw_detail(param, sprintf('%+d%s', value, perc), icon, line_height, color, :left)
  end

  # disegna il nome del paraemtro e un elenco di icone
  # @param [String] param
  # @param [Array<Integer>] icon_array
  def draw_param_with_icons(param, icon_array)
    unless @simulate
      change_color system_color
      draw_text(current_rect, param)
      change_color normal_color
    end
    @line += line_height
    draw_icon_set(icon_array)
  end

  def draw_param_gauge(param, rate, text, gauge_color1 = mp_gauge_color1, gauge_color2 = mp_gauge_color2)
    unless @simulate
      change_color system_color
      rect = current_rect
      draw_text(rect, param)
      x = rect.x + text_width(param.to_s + ' ')
      y = rect.y
      width = rect.width - x
      draw_gauge(x, y, width, rate, gauge_color1, gauge_color2)
      draw_text(x, y, width, line_height, text, 1)
    end
    @line += 24
  end

  # @param [Array<Hash>] params
  # @param [String] title
  def draw_param_list(params, title = nil)
    draw_param_title(title) if title
    params.each do |param|
      unless @simulate
        rect = current_rect
        enabled = param[:enabled].nil? ? true : param[:enabled]
        if param[:icon]
          draw_icon(param[:icon], rect.x, rect.y, enabled)
          rect.x += ICON_WIDTH
          rect.width -= ICON_WIDTH
          color = param[:color] ? param[:color] : normal_color
          change_color(color, enabled)
          draw_text(rect, param[:text])
        end
      end
      @line += line_height
    end
  end

  # Disegna un set di icone
  # @param [Array<Integer>] icon_array
  def draw_icon_set(icon_array)
    columns = contents_width / 24
    (0..icon_array.size - 1).each { |i|
      draw_icon(icon_array[i], 24 * (i % columns), @line + (i / columns * 24))
    }
    @line += 24 * (icon_array.size / columns * 24 + 2)
  end

  # disegna il numero posseduto di quest'oggetto dal gruppo
  def draw_item_possessed
    draw_detail(Vocab::ITEM_POSSESS, $game_party.item_number(item))
  end

  # disegna un titolo di sezione e va a capo
  def draw_param_title(title)
    unless @simulate
      change_color system_color
      draw_text(current_rect, title)
    end
    @line += line_height
  end

  def draw_skill_learn_requirements
    return unless item.is_a?(RPG::Skill) or item.is_a?(RPG::State)
    return if actor.nil?
    return unless @show_requirements
    requirements = []
    if item.ap_cost > 0
      enabled = actor.ap >= item.ap_cost
      param = {
        :icon => Icon.check(enabled),
        :text => sprintf('%d %s', item.ap_cost, Vocab.ap_long),
        :color => enabled ? power_up_color : power_down_color,
        :enabled => !enabled
      }
      requirements.push(param)
    end
    if item.required_level > 1
      enabled = actor.level >= item.required_level
      param = {
        :icon => Icon.check(enabled),
        :text => sprintf('%s %d', Vocab.level, item.required_level),
        :color => enabled ? power_up_color : power_down_color,
        :enabled => !enabled
      }
      requirements.push(param)
    end
    item.required_skills.each do |skill_id|
      enabled = actor.skill_level(skill_id) >= $data_skills[skill_id].level
      param = {
        :icon => Icon.check(enabled),
        :text => $data_skills[skill_id].name,
        :color => enabled ? power_up_color : power_down_color,
        :enabled => !enabled
      }
      requirements.push(param)
    end
    item.required_passives.each do |skill_id|
      enabled = actor.passive_learn?($data_states[skill_id])
      param = {
        :icon => Icon.check(enabled),
        :text => $data_states[skill_id].name,
        :color => enabled ? power_up_color : power_down_color,
        :enabled => !enabled
      }
      requirements.push(param)
    end
    return if requirements.empty?
    draw_param_list(requirements, Vocab.requirements)
  end

  # Disegna il prezzo di un oggetto
  def draw_item_price
    return if item.is_a?(RPG::Skill)
    return if item.is_a?(RPG::State)
    return unless item.sellable?
    draw_detail(Vocab.attribute(:selling_price), sprintf("%d %s", item.selling_price, Vocab.gold))
  end
end

#==============================================================================
# ** Window_ItemCategory
#------------------------------------------------------------------------------
# mostra le categorie degli oggetti
#==============================================================================
class Window_ItemCategory < Window_Category
  # Metodo astratto per i dati
  def default_data
    categories_from_hash(H87Item::Settings::ITEM_CATEGORIES)
  end
end

#==============================================================================
# ** Window_Item
#------------------------------------------------------------------------------
# La finestra che mostra gli oggetti posseduti
#==============================================================================
class Window_Item < Window_Selectable
  include ListWindow
  # Object Initialization
  #     x      : window x-coordinate
  #     y      : window y-coordinate
  #     width  : window width
  #     height : window height
  alias h87item_initialize initialize unless $@

  def initialize(x, y, width, height)
    super(x, y, width, height)
    self.index = 0
    if $game_temp.in_battle
      @column_max = 2
      category = :in_battle
    else
      category = :usable
      @column_max = 1
      self.width = 340
    end
    set_list(category)
  end

  # Refresh
  def refresh
    return if @category.nil?
    return if @data.nil?
    (0...@item_max).each(&method(:draw_item))
  end

  # Ottiene i dati
  def get_data
    @data = []
    $game_party.items.each { |item|
      next if item.nil?
      next unless include?(item)
      if $game_temp.in_battle
        next unless item.is_a?(RPG::Item)
        next unless item.battle_ok?
      else
        next unless item.category == @category or @category == :all
      end
      @data.push(item)
      #noinspection RubyResolve
      if item.is_a?(RPG::Item) and item.id == $game_party.last_item_id
        self.index = @data.size - 1
      end
    }
    #@data.push(nil) if include?(nil)
  end

  # Aggiunge i metodi di x e y iniziali del viewport
  # @param [Viewpoer] viewport
  def viewport=(viewport)
    super(viewport)
    @view_x = viewport.rect.x
    @view_y = viewport.rect.y
  end

  # Aggiornamento
  def update
    super
    update_info_window
    back if Input.trigger?(:B)
  end

  # Alias per utilizzare tutta la larghezza
  def draw_item_name(item, x, y, enabled = true, width = nil)
    width = contents_width if width.nil?
    if (item.is_a?(RPG::Weapon) or item.is_a?(RPG::Armor)) and @category != :all
      enabled = true
    end
    super(item, x, y, enabled, width)
  end
end

class Game_Party < Game_Unit
  # restituisce il numero degli oggetti posseduti compresi quelli del gruppo
  # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
  def all_item_number(item)
    item_number(item) + members_item_number(item)
  end

  # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
  # @return [Integer]
  def members_item_number(item)
    sum = 0
    members.each { |member| sum += member.equips.select { |equip| equip == item }.size }
    sum
  end
end

#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
# caricamento degli attributi delle classi
#==============================================================================
class Scene_Title < Scene_Base
  alias h87item_load_database load_database unless $@
  # Carica il database
  def load_database
    h87item_load_database
    load_h87_items
  end

  # Inizializza i parametri degli oggetti
  def load_h87_items
    $data_items.compact.each { |item| item.load_custom_details }
    $data_weapons.compact.each { |weapon| weapon.load_custom_details }
    $data_armors.compact.each { |armor| armor.load_custom_details }
    $data_skills.compact.each { |skill| skill.load_custom_details }
    $data_states.compact.each { |state| state.load_custom_details }
  end
end
