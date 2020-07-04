#==============================================================================
# ** H87Item
#------------------------------------------------------------------------------
# modulo base con impostazioni per settare lo script
#==============================================================================
module H87Item
  #--------------------------------------------------------------------------
  # * IMPOSTAZIONI DELLO SCRIPT
  #--------------------------------------------------------------------------
  module Settings
    # Disegnare il prezzo di vendita dell'oggetto?
    DRAW_PRICE = true
    # Impostare la formula di vendita
    SELLPRICE_FORMULAS = {
        :default => 'item.price/3',
        :weapons => 'item.price/3',
        :armors => 'item.price/2',
        :items => 'item.price * 3 / 4'
    }
    # Dettagli da disegnare per oggetti e skill
    USABLE_DETAILS = [
        :scope,
        :occasion,
        :damage,
        :attack_attribute,
        :absorb,
        :elements,
        :state_plus,
        :state_minus,
    ]
    # Dettagli da disegnare negli oggetti
    ITEM_DETAILS = [
        :hp_recover,
        :mp_recover,
        :param_growth,
    ]
    # Dettagli da disegnare nelle skill
    SKILL_DETAILS = [
        :spi_f, :atk_f, :agi_f, :def_f,
        :mp_cost, :hp_cost, :item_price, :gold_cost, :recharge, :aggro, :sinergy,
        :tank_odd, :state_inf_bonus, :state_inf_per,
        :state_inf_dur, :type_effectiveness]
    #--------------------------------------------------------------------------
    # * quali dettagli mostrare per le categorie
    #--------------------------------------------------------------------------
    EQUIP_DETAILS = [:atk, :def, :spi, :agi, :hit, :cri, :eva, :odds]
    ARMOR_DETAILS = [:kind, :states, :elements, :bonus]
    WEAPON_DETAILS = [:kind, :attack_attribute, :states, :elements, :type_effectiveness, :bonus]
    #--------------------------------------------------------------------------
    # * la grandezza del testo dei dettagli. Se 0, usa predefinito
    #--------------------------------------------------------------------------
    TEXTSIZE = 0
    #--------------------------------------------------------------------------
    # * le categorie degli oggetti
    #--------------------------------------------------------------------------
    ITEM_CATEGORIES = {
        1 => [:usable, 'Utilizzabili'],
        2 => [:resource, 'Materiali'],
        3 => [:weapon, 'Armi'],
        4 => [:armor, 'Armature'],
        5 => [:key, 'Importanti'],
        6 => [:battle, 'Battaglia']
    }
  end
  #--------------------------------------------------------------------------
  # * prezzo di vendita predefinito
  #--------------------------------------------------------------------------
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
  class << self
    # noinspection RubyResolve
    alias int_param param
  end
  #--------------------------------------------------------------------------
  # * vari vocaboli
  #--------------------------------------------------------------------------
  ITEM_VALUE = 'Prezzo vendita'
  ITEM_SCOPE = 'Bersaglio'
  ITEM_USE = 'Uso'
  ITEM_DAMAGE = 'Danno %s'
  ITEM_ELEMENT = 'Elemento'
  ITEM_STATE_P = 'Causa Stati'
  ITEM_STATE_M = 'Rimuove Stati'
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
  ARMOR_STATE = 'Conferisce immunità'
  ARMOR_ELEMENT = 'Dimezza elemento'
  WEAPON_2H = 'Richiede due mani'
  WEAPON_DUAL_A = 'Doppio attacco'
  ARMOR_PREVENT_CRITICAL = 'Previene colpi critici'
  ARMOR_HALF_MP_COST = 'Dimezza il costo delle abilità'
  ARMOR_AUTO_HP_RECOVER = 'Ripristina PV con il tempo'
  ARMOR_2EXP_GAIN = 'Raddoppia l\'esperienza acquisita'
  ATTACK_ATTRIBUTE = 'Tipo danni'
  ATTR_EFFECTIVENESS = 'Efficace contro %s'
  EQUIPPABLE_BY = 'Equipaggiabile da'
  #--------------------------------------------------------------------------
  # * Restituisce l'elemento dall'ID
  # @param [Integer] element_id
  # @return [String]
  #--------------------------------------------------------------------------
  def self.element(element_id)
    return $data_system.elements[element_id]
  end

  #--------------------------------------------------------------------------
  # * Restituisce i vocaboli dei rispettivi parametri
  # @return [String]
  #--------------------------------------------------------------------------
  def self.hit;
    'Mira';
  end

  def self.eva;
    'Evasione';
  end

  def self.cri;
    'Critici';
  end

  #--------------------------------------------------------------------------
  # * Restituisce un determinato parametro
  # @param [Symbol] symbol
  # @return [Integer]
  #--------------------------------------------------------------------------
  def self.param(symbol)
    case symbol
    when :atk
      return atk
    when :def
      return self.def
    when :spi
      return spi
    when :agi
      return agi
    when :cri
      return cri
    when :eva
      return eva
    when :hit
      return hit
    when :odds, :odd
      return odds
    when :hp_a, :mhp, :max_hp, :hp, :maxhp
      return hp
    when :mp, :max_mp, :mmp, :maxmp
      return mp
    else
      int_param(symbol)
    end
  end

  #--------------------------------------------------------------------------
  # * Vocaboli per l'obiettivo
  #--------------------------------------------------------------------------
  SCOPES = [
      'Nessuno',
      'Un nemico',
      'Tutti i nemici',
      'Un nemico, due volte',
      'Un nemico a caso',
      'Due nemici a caso',
      'Tre nemici a caso',
      'Alleato',
      'Tutti gli alleati',
      'Un alleato KO',
      'Tutti gli alleati KO',
      'L\'utilizzatore'
  ]
  #--------------------------------------------------------------------------
  # * Vocaboli per il tipo di armatura
  #--------------------------------------------------------------------------
  ARMOR_KINDS = {
      0 => 'Supporto',
      1 => 'Elmo',
      2 => 'Corpo',
      3 => 'Accessorio',
      7 => 'Magnetite',
  }
  #--------------------------------------------------------------------------
  # * Vocaboli per l'occasione
  #--------------------------------------------------------------------------
  OCCASIONS = ['Sempre', 'Solo in battaglia', 'Solo dal Menu', 'Mai']
  #--------------------------------------------------------------------------
  # * Restituisce il bersaglio
  #--------------------------------------------------------------------------
  def self.scope(id)
    return SCOPES[id]
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'occasione
  #--------------------------------------------------------------------------
  def self.occasion(id)
    return OCCASIONS[id]
  end

  #--------------------------------------------------------------------------
  # * Restituisce il tipo di armatura
  #--------------------------------------------------------------------------
  def self.armor_kind(kind)
    return ARMOR_KINDS[kind]
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
  #--------------------------------------------------------------------------
  # * caricamento dei dettagli personalizzati
  #--------------------------------------------------------------------------
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
    self.note.split(/[\r\n]+/).each { |line|
      case line
        #---
      when /<nessuna descrizione>/i
        @no_description = true
      when /<attr[ ]+(.*):[ ](.*)\[(\d+)]>/i
        @custom_dets.push([$1, $2, $3.to_i])
      when /<attr[ ]+(.*):[ ](.*)>/i
        @custom_dets.push([$1, $2, 0])
      when /<feature:[ ]*(.*)>/i
        @features.push($1)
      when /<tip:[ ]*(.*)>/i
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
      else
        # niente
      end
    }
  end

  #--------------------------------------------------------------------------
  # * Restituisce il prezzo di vendita
  # @return [Integer]
  #--------------------------------------------------------------------------
  def selling_price
    @sellprice || H87Item.default_sell_price(self)
  end

  #--------------------------------------------------------------------------
  # * Restituisce la categoria
  # @return [Symbol]
  #--------------------------------------------------------------------------
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
end #baseitem

#==============================================================================
# ** Sprite_ItemPopup
#------------------------------------------------------------------------------
#  Mostra il numero di oggetti restante
#==============================================================================
class Sprite_ItemPopup < Sprite
  attr_accessor :padding
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.visible = false
    @padding = 2
    @item = nil
  end

  #--------------------------------------------------------------------------
  # * Imposta l'oggetto
  # @param[RPG::BaseItem]
  #--------------------------------------------------------------------------
  def set_item(item)
    @item = item
    refresh_bitmap
  end

  #--------------------------------------------------------------------------
  # * Numero di oggetti posseduti
  #--------------------------------------------------------------------------
  def item_number
    $game_party.item_number(@item)
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la bitmap
  #--------------------------------------------------------------------------
  def refresh_bitmap
    self.bitmap = create_bitmap
    draw_on_bitmap
  end

  #--------------------------------------------------------------------------
  # * Crea o pulisce la bitmap
  # @return [Bitmap]
  #--------------------------------------------------------------------------
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

  #--------------------------------------------------------------------------
  # * Disegna sulla bitmap
  #--------------------------------------------------------------------------
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
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    #super
    h87item_start
    @popup_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @popup_viewport.z = 999
    adjust_windows
    create_category_window
    create_info_window
    create_item_number_popup
  end

  #--------------------------------------------------------------------------
  # * Adatta le finestre
  #--------------------------------------------------------------------------
  def adjust_windows
    #@item_window.width = Graphics.width/2
    @target_window.x = 0 - @target_window.width
    @target_window.height = Graphics.height - @target_window.y
  end

  #--------------------------------------------------------------------------
  # * Fine
  #--------------------------------------------------------------------------
  def terminate
    #super
    h87item_terminate
    @category_window.dispose
    @info_window.dispose
    @item_popup.dispose
    @popup_viewport.dispose
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    #super
    h87item_update
    @category_window.update
    @viewport.update
    @item_popup.y = @target_window.strcursor.y + 30 if @item_popup.visible
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra delle categorie
  # noinspection RubyArgCount
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemCategory.new(0, 0, 4)
    #@category_window.viewport = @viewport
    @item_window.set_category_window(@category_window)
    @category_window.set_list(@item_window)
    @target_window.visible = false
  end

  #--------------------------------------------------------------------------
  # * Crea la finestra delle informazioni
  #--------------------------------------------------------------------------
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

  #--------------------------------------------------------------------------
  # * Nada!
  #--------------------------------------------------------------------------
  def return_scene;
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento della selezione oggetto
  #--------------------------------------------------------------------------
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

  #--------------------------------------------------------------------------
  # * Show Target Window
  #     right : Right justification flag (if false, left justification)
  # noinspection RubyUnusedLocalVariable
  #--------------------------------------------------------------------------
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

  #--------------------------------------------------------------------------
  # * Hide Target Window
  #--------------------------------------------------------------------------
  def hide_target_window
    @item_window.active = true
    @target_window.active = false
    @viewport.smooth_move(0, 0)
    @target_window.smooth_move(0 - @target_window.width, 0)
    @item_popup.visible = false if @item_popup && !@item_popup.disposed?
  end

  #--------------------------------------------------------------------------
  # * Usa un oggetto senza bersaglio
  #--------------------------------------------------------------------------
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
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_accessor :see_possessed # visualizza la quantità posseduta
  attr_accessor :see_sellprice # visualizza il prezzo di vendita
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] w
  # @param [Integer] h
  #--------------------------------------------------------------------------
  def initialzie(x, y, w, h)
    @see_possessed = false
    @see_sellprice = H87Item::Settings::DRAW_PRICE
    refresh_size
    super(x, y, w, h)
  end

  #--------------------------------------------------------------------------
  # * Riaggiorna il contenuto
  #--------------------------------------------------------------------------
  def refresh
    @line = 0
    contents.clear
    return if item.nil?
    draw_item_data
  end

  #--------------------------------------------------------------------------
  # * Imposta un oggetto
  # @param [RPG::BaseItem] new_item
  #--------------------------------------------------------------------------
  def set_item(new_item)
    return if @item.equal?(new_item)
    @item = new_item
    refresh
  end

  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto della finestra
  # @return [RPG::UsableItem,RPG::Armor,RPG::Weapon]
  #--------------------------------------------------------------------------
  def item;
    @item;
  end

  #--------------------------------------------------------------------------
  # * Disegna i dati principali dell'oggetto
  #--------------------------------------------------------------------------
  def draw_item_data
    draw_item_possessed if @see_possessed
    draw_item_price if @see_sellprice
    unless item.no_description
      case item
      when RPG::Item
        draw_usable_item_detail; draw_item_detail
      when RPG::Weapon
        draw_equip_detail; draw_weapon_detail
      when RPG::Armor
        draw_equip_detail; draw_armor_detail
      when RPG::Skill
        draw_skill_detail
      else
        # niente
      end
      draw_script_detail
    end
    draw_item_custom_details
  end

  #--------------------------------------------------------------------------
  # * Riaggiorna la grandezza
  #--------------------------------------------------------------------------
  def refresh_size
    if H87Item::Settings::TEXTSIZE != 0
      contents.font.size = H87Item::Settings::TEXTSIZE
    end
  end

  #--------------------------------------------------------------------------
  # * Altezza delle lettere
  #--------------------------------------------------------------------------
  def auto_height
    if H87Item::Settings::TEXTSIZE == 0
      line_height
    else
      contents.text_size("A").height + 2
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna un dettaglio generico
  # @param [String] param
  # @param [String, Integer, Float] value
  # @param [Integer] icon
  # @param [Integer] height
  # @param [Color] color
  #--------------------------------------------------------------------------
  def draw_detail(param, value = nil, icon = 0, height = auto_height,
                  color = normal_color, icon_pos = :right)
    width = contents_width
    y = @line
    x = 0
    draw_bg_rect(0, y, contents_width, height)
    if icon != 0 and icon_pos == :left
      draw_icon(icon, 0, y)
      x = 24
    end
    if value.nil?
      change_color(color)
      draw_text(x, y, width, height, param, 1)
    else
      change_color(system_color)
      draw_text(x, y, width, height, param)
      change_color(color)
      draw_text(0, y, width, height, value, 2)
      #xx = width - contents.text_size(value).width - 28
      #draw_icon(icon, xx, y)
    end
    if icon != 0 and icon_pos == :right
      icon_x = width - (value != nil ? text_width(value) : 0) - 24
      draw_icon(icon, icon_x, y)
    end
    @line += height
  end

  #--------------------------------------------------------------------------
  # * Mostra una funzione speciale
  # @param [String] feature
  # @param [Color] color
  #--------------------------------------------------------------------------
  def draw_feature(feature, color = power_up_color)
    draw_detail(feature, nil, 0, auto_height, color)
  end

  #--------------------------------------------------------------------------
  # * Disegna un parametro
  # @param [String] param
  # @param [String, Integer] value
  # @param [Boolean] percentuale
  # @param [Integer] icon
  # @param [Boolean] reverse
  #--------------------------------------------------------------------------
  def draw_parameter(param, value, percentuale = false, icon = 0, reverse = false)
    return if value == 0
    color = normal_color
    color = power_up_color if value > 0 or (value < 0 and reverse)
    color = power_down_color if value < 0 or (value > 0 and reverse)
    perc = percentuale ? "%" : ""
    draw_detail(param, sprintf('%+d%s', value, perc), icon, auto_height, color)
  end

  #--------------------------------------------------------------------------
  # * Disegna un set di icone
  # @param [Array<Integer>] icon_array
  #--------------------------------------------------------------------------
  def draw_icon_set(icon_array)
    columns = contents_width / 24
    (0..icon_array.size - 1).each { |i|
      draw_icon(icon_array[i], 24 * (i % columns), @line + (i / columns * 24))
    }
    @line += 24 * (icon_array.size / columns * 24 + 1)
  end

  #--------------------------------------------------------------------------
  # * disegna il numero posseduto di quest'oggetto dal gruppo
  #--------------------------------------------------------------------------
  def draw_item_possessed
    draw_detail(Vocab::ITEM_POSSESS, $game_party.item_number(item))
  end

  #--------------------------------------------------------------------------
  # * Disegna il prezzo di un oggetto
  #--------------------------------------------------------------------------
  def draw_item_price
    draw_detail(Vocab::ITEM_VALUE, sprintf("%d %s", item.selling_price, Vocab.gold))
  end

  def draw_usable_item_detail
    (0..H87Item::Settings::USABLE_DETAILS.size - 1).each { |i|
      draw_usable_property(H87Item::Settings::USABLE_DETAILS[i])
    }
  end

  def draw_usable_property(sym)
    case sym
    when :scope
      draw_scope
    when :occasion
      draw_occasion
    when :damage
      draw_damage
    when :absorb
      draw_absorb
    when :element
      draw_element_set
    when :state_plus
      draw_state_set
    when :state_minus
      draw_minus_state_set
    when :attack_attribute
      draw_attack_attributes
    when :type_effectiveness
      draw_enemy_type_effectiveness
    else
      # niente
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna i dettagli di un oggetto
  #--------------------------------------------------------------------------
  def draw_item_detail
    (0..H87Item::Settings::ITEM_DETAILS.size - 1).each { |i|
      draw_item_property(H87Item::Settings::ITEM_DETAILS[i])
    }
  end

  #--------------------------------------------------------------------------
  # * Disegna le proprietà dell'ottetto
  # @param [Symbol] sym
  #--------------------------------------------------------------------------
  def draw_item_property(sym)
    case sym
    when :hp_recover
      draw_hp_recover
    when :mp_recover
      draw_mp_recover
    else
      # niente
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna le proprietà di un equipaggiamento
  # @param [Symbol] sym
  #--------------------------------------------------------------------------
  def draw_equip_property(sym)
    case sym
    when :atk
      draw_atk
    when :def
      draw_def
    when :spi
      draw_spi
    when :agi
      draw_agi
    when :hit
      item.is_a?(RPG::Weapon) ? draw_wht : draw_hit
    when :eva
      draw_eva
    when :odds
      draw_odds
    else
      # niente
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna i dettagli dell'equipaggiamento
  #--------------------------------------------------------------------------
  def draw_equip_detail
    (0..H87Item::Settings::EQUIP_DETAILS.size - 1).each { |i|
      draw_equip_property(H87Item::Settings::EQUIP_DETAILS[i])
    }
  end

  #--------------------------------------------------------------------------
  # * Disegna i dettagli dell'arma
  #--------------------------------------------------------------------------
  def draw_weapon_detail
    (0..H87Item::Settings::WEAPON_DETAILS.size - 1).each { |i|
      draw_weapon_property(H87Item::Settings::WEAPON_DETAILS[i])
    }
  end

  #--------------------------------------------------------------------------
  # * Disegna le proprietà dell'arma
  #--------------------------------------------------------------------------
  def draw_weapon_property(sym)
    case sym
    when :kind
      draw_weapon_kind
    when :states
      draw_atk_states
    when :elements
      draw_atk_element
    when :bonus
      draw_weapon_bonus
    when :attack_attribute
      draw_attack_attributes
    when :type_effectiveness
      draw_enemy_type_effectiveness
    else
      # niente
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna i dettagli dell'armatura
  #--------------------------------------------------------------------------
  def draw_armor_detail
    (0..H87Item::Settings::ARMOR_DETAILS.size - 1).each { |i|
      draw_armor_property(H87Item::Settings::ARMOR_DETAILS[i])
    }
  end

  #--------------------------------------------------------------------------
  # * Disegna le proprietà dell'armatura
  #--------------------------------------------------------------------------
  def draw_armor_property(sym)
    draw_equip_property(sym)
    case sym
    when :kind
      draw_armor_kind
    when :states
      draw_def_states
    when :elements
      draw_def_elements
    when :bonus
      draw_armor_bonus
    else
      # niente
    end
  end

  def draw_skill_detail
    (0..H87Item::Settings::SKILL_DETAILS.size - 1).each { |s|
      draw_skill_property(H87Item::Settings::ARMOR_DETAILS[i])
    }
  end

  def draw_skill_property(sym)
    case sym
    when :scope
      draw_scope
    when :occasion
      draw_occasion
    when :damage
      draw_damage
    when :absorb
      draw_absorb
    when :element
      draw_element_set
    when :state_plus
      draw_state_set
    when :state_minus
      draw_minus_state_set
    when :damage
      draw_base_damage
    when :atk_f
      draw_atk_f
    when :spi_f
      draw_spi_f
    when :def_f
      draw_def_f
    when :agi_f
      draw_agi_f
    when :mp_cost
      draw_mp_cost
    when :hp_cost
      draw_hp_cost
    when :anger_cost
      draw_anger_cost
    when :gold_cost
      draw_gold_cost
    when :item_price
      draw_item_cost
    when :recharge
      draw_recharge_req
    when :aggro
      draw_aggro_bonus
    when :sinergy
      draw_sinergy_adder
    when :tank_odd
      draw_tank_odd
    when :state_inf_bonus
      draw_state_inf_bonus
    when :state_inf_per
      draw_state_inflict_perc
    when :state_inf_dur
      draw_state_inf_durability
    else
      # niente
    end
  end

  #--------------------------------------------------------------------------
  # * Mostra il bersaglio
  #--------------------------------------------------------------------------
  def draw_scope
    return if item.occasion == 3
    return if item.scope == 0
    draw_detail(Vocab::ITEM_SCOPE, Vocab.scope(item.scope))
  end

  #--------------------------------------------------------------------------
  # * Mostra l'occasione
  #--------------------------------------------------------------------------
  def draw_occasion
    return if item.occasion == 3
    draw_detail(Vocab::ITEM_USE, Vocab.occasion(item.occasion))
  end

  #--------------------------------------------------------------------------
  # * Mostra il danno
  #--------------------------------------------------------------------------
  def draw_damage
    return if item.base_damage == 0
    param = item.damage_to_mp ? Vocab.mp_a : Vocab.hp_a
    if item.base_damage > 0
      draw_detail(sprintf(Vocab::ITEM_DAMAGE, param), item.base_damage)
    else
      draw_detail(sprintf(Vocab::ITEM_RECOVER, param), item.base_damage)
    end
  end

  #--------------------------------------------------------------------------
  # * mostra l'influenza dell'attacco
  #--------------------------------------------------------------------------
  def draw_atk_f
    return if item.atk_f == 0
    draw_detail(Vocab::SKILL_ATK_F, item.atk_f)
  end

  #--------------------------------------------------------------------------
  # * mostra l'influenza dello spirito
  #--------------------------------------------------------------------------
  def draw_spi_f
    return if item.spi_f == 0
    draw_detail(Vocab::SKILL_ATK_F, item.atk_f)
  end

  #--------------------------------------------------------------------------
  # * mostra l'influenza della difesa
  #--------------------------------------------------------------------------
  def draw_def_f
    return if item.def_f == 0
    draw_detail(Vocab::SKILL_DEF_F, item.def_f)
  end

  #--------------------------------------------------------------------------
  # * mostra l'influenza dell'agilità
  #--------------------------------------------------------------------------
  def draw_agi_f
    return if item.agi_f == 0
    draw_detail(Vocab::SKILL_AGI_F, item.agi_f)
  end

  #--------------------------------------------------------------------------
  # * mostra il costo PM
  #--------------------------------------------------------------------------
  def draw_mp_cost
    return if item.mp_cost == 0
    draw_detail(Vocab.skill_param_vocab(:mp_cost), item.mp_cost)
  end

  # * mostra il costo PV
  def draw_hp_cost
    return if item.hp_cost == 0
    draw_detail(Vocab.skill_param_vocab(:hp_cost), item.hp_cost)
  end

  #--------------------------------------------------------------------------
  # * mostra il costo furia
  #--------------------------------------------------------------------------
  def draw_anger_cost
    return if item.anger_cost == 0
    draw_detail(Vocab.skill_param_vocab(:anger_cost), item.anger_cost)
  end

  #--------------------------------------------------------------------------
  # * mostra il consumo oggetti
  #--------------------------------------------------------------------------
  def draw_item_cost
    return if item.consume_item == 0
    draw_detail(Vocab::ITEM_CONSUME, sprintf('x%d', item.consume_item_n),
                $data_items[item.consume_item].icon_index,
                auto_height, normal_color, :right)
  end

  #--------------------------------------------------------------------------
  # * mostra il consumo di oro
  #--------------------------------------------------------------------------
  def draw_gold_cost
    return if item.gold_cost == 0
    draw_detail(sprintf(Vocab::ITEM_COST, Vocab.currency_unit),
                item.gold_cost)
  end

  #--------------------------------------------------------------------------
  # * Mostra se assorbe danni
  #--------------------------------------------------------------------------
  def draw_absorb
    return unless item.absorb_damage
    draw_detail(Vocab::ITEM_ABSORB)
  end

  #--------------------------------------------------------------------------
  # * Disegna il set di elementi
  #--------------------------------------------------------------------------
  def draw_element_set
    return if item.element_set.empty?
    draw_detail(Vocab::ITEM_ELEMENT)
    icons = []
    item.element_set.each { |element|
      icon = element_icon(element)
      icons.push(icon) unless icon
    }
    draw_icon_set(icons)
  end

  #--------------------------------------------------------------------------
  # * Disegna il set di stati alterati
  #--------------------------------------------------------------------------
  def draw_state_set
    return if item.plus_state_set.empty?
    draw_detail(Vocab::ITEM_STATE_P)
    icons = []
    item.plus_state_set.each { |s| icons.push($data_states[s].icon_index) }
    draw_icon_set(icons)
  end

  #--------------------------------------------------------------------------
  # * Disegna il set di stati che rimuove
  #--------------------------------------------------------------------------
  def draw_minus_state_set
    return if item.minus_state_set.empty?
    draw_detail(Vocab::ITEM_STATE_M)
    icons = []
    item.minus_state_set.each { |s| icons.push($data_states[s].icon_index) }
    draw_icon_set(icons)
  end

  #--------------------------------------------------------------------------
  # * Disegna la cura HP
  #--------------------------------------------------------------------------
  def draw_hp_recover
    return if item.hp_recovery_rate == 0 && item.hp_recovery == 0
    param = sprintf(Vocab::ITEM_RECOVER, Vocab.hp_a)
    if item.hp_recovery == 0
      draw_detail(param, sprintf("%+d%%", item.hp_recovery_rate))
    elsif item.hp_recovery_rate == 0
      draw_detail(param, item.hp_recovery)
    else
      draw_detail(param, sprintf("%d %+d%%", item.hp_recovery, item.hp_recovery_rate))
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna la cura MP
  #--------------------------------------------------------------------------
  def draw_mp_recover
    return if item.mp_recovery_rate == 0 && item.mp_recovery == 0
    param = sprintf(Vocab::ITEM_RECOVER, Vocab.mp_a)
    if item.mp_recovery == 0
      draw_detail(param, sprintf("%+d%%", item.mp_recovery_rate))
    elsif item.mp_recovery_rate == 0
      draw_detail(param, item.mp_recovery)
    else
      draw_detail(param, sprintf("%d %+d%%", item.mp_recovery, item.mp_recovery_rate))
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna l'elemento
  # noinspection RubyResolve
  #--------------------------------------------------------------------------
  def element_icon(element)
    Y6::ICON[:element_icons][element]
  end

  #--------------------------------------------------------------------------
  # * Mostra vari parametri
  #--------------------------------------------------------------------------
  def draw_hit;
    draw_parameter(Vocab.hit, item.hit, true);
  end

  def draw_wht;
    draw_parameter(Vocab.hit, item.hit - 95, true);
  end

  def draw_cri;
    draw_parameter(Vocab.cri, item.cri, true);
  end

  def draw_eva;
    draw_parameter(Vocab.eva, item.eva, true);
  end

  def draw_atk;
    draw_parameter(Vocab.atk, item.atk);
  end

  def draw_spi;
    draw_parameter(Vocab.spi, item.spi);
  end

  def draw_def;
    draw_parameter(Vocab.def, item.def);
  end

  def draw_agi;
    draw_parameter(Vocab.agi, item.agi);
  end

  def draw_odds;
    draw_parameter(Vocab.odds, item.odds);
  end

  #--------------------------------------------------------------------------
  # * Mostra il tipo di arma
  #--------------------------------------------------------------------------
  def draw_weapon_kind
    item.w_types.each do |tipo|
      next if Vocab.wtype(tipo).nil?
      draw_detail(Vocab::EQUIP_KIND, Vocab.wtype(tipo))
    end
  end

  #--------------------------------------------------------------------------
  # * Mostra gli stati alterati che aggiunge l'arma
  #--------------------------------------------------------------------------
  def draw_atk_states
    return if item.state_set.empty?
    item.state_set.each { |state_id|
      state = $data_states[state_id]
      draw_detail(Vocab::WEAPON_STATE, state.name, state.icon_index)
    }
  end

  #--------------------------------------------------------------------------
  # * Mostra l'elemento dell'arma
  #--------------------------------------------------------------------------
  def draw_atk_element
    return if item.magic_elements.empty?
    item.magic_elements.each do |element|
      draw_detail(Vocab::ITEM_ELEMENT, element.name, element.icon_index)
    end
  end

  def draw_enemy_type_effectiveness
    return if item.monster_type_effectiveness.empty?
    item.monster_type_effectiveness.each do |element|
      draw_feature(sprintf(Vocab::ATTR_EFFECTIVENESS, element.name))
    end
  end

  def draw_attack_attributes
    return if item.damage_types.empty?
    item.damage_types.each do |element|
      draw_detail(Vocab::ATTACK_ATTRIBUTE, element.name, element.icon_index)
    end
  end

  #--------------------------------------------------------------------------
  # * Disegna i bonus dell'arma
  #--------------------------------------------------------------------------
  def draw_weapon_bonus
    draw_detail(Vocab::WEAPON_2H) if item.two_handed
  end

  #--------------------------------------------------------------------------
  # * Disegna il tipo di armatura
  #--------------------------------------------------------------------------
  def draw_armor_kind
    draw_detail(Vocab::EQUIP_KIND, Vocab.armor_kind(item.kind))
  end

  #--------------------------------------------------------------------------
  # * Disegna le immunità dell'equipaggiamento
  #--------------------------------------------------------------------------
  def draw_def_states
    return if item.state_set.empty?
    draw_detail(Vocab::ARMOR_STATE)
    icons = []
    item.state_set.each { |state_id|
      state = $data_states[state_id]
      icons.push(state.icon_index)
    }
    draw_icon_set(icons)
  end

  #--------------------------------------------------------------------------
  # * Disegna le difese elementali
  #--------------------------------------------------------------------------
  def draw_def_elements
    return if item.element_set.empty?
    draw_detail(Vocab::ARMOR_ELEMENT)
    icons = []
    item.element_set.each { |element|
      icons.push(element_icon(element))
    }
    draw_icon_set(icons)
  end

  #--------------------------------------------------------------------------
  # * Disegna i bonus dell'armatura
  #--------------------------------------------------------------------------
  def draw_armor_bonus
    draw_feature(Vocab::ARMOR_PREVENT_CRITICAL) if item.prevent_critical
    draw_feature(Vocab::ARMOR_HALF_MP_COST) if item.half_mp_cost
    draw_feature(Vocab::ARMOR_AUTO_HP_RECOVER) if item.auto_hp_recover
    draw_feature(Vocab::ARMOR_2EXP_GAIN) if item.double_exp_gain
  end

  #--------------------------------------------------------------------------
  # * Disegna i dettagli personalizzati
  #--------------------------------------------------------------------------
  def draw_item_custom_details
    item.custom_dets.each do |detail|
      draw_detail(detail[0], detail[1], detail[2])
    end
    item.custom_desc.each do |desc|
      draw_detail(desc)
    end
    item.features.each do |feature|
      draw_feature(feature)
    end
  end
end

#==============================================================================
# ** Window_ItemCategory
#------------------------------------------------------------------------------
# mostra le categorie degli oggetti
#==============================================================================
class Window_ItemCategory < Window_Category
  #--------------------------------------------------------------------------
  # * Metodo astratto per i dati
  #--------------------------------------------------------------------------
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
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x      : window x-coordinate
  #     y      : window y-coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
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

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    return if @category.nil?
    return if @data.nil?
    (0...@item_max).each(&method(:draw_item))
  end

  #--------------------------------------------------------------------------
  # * Ottiene i dati
  #--------------------------------------------------------------------------
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
      if item.is_a?(RPG::Item) and item.id == $game_party.last_item_id
        self.index = @data.size - 1
      end
    }
    #@data.push(nil) if include?(nil)
  end

  #--------------------------------------------------------------------------
  # * Aggiunge i metodi di x e y iniziali del viewport
  # @param [Viewpoer] viewport
  #--------------------------------------------------------------------------
  def viewport=(viewport)
    super(viewport)
    @view_x = viewport.rect.x
    @view_y = viewport.rect.y
  end

  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_info_window
    back if Input.trigger?(:B)
  end

  #--------------------------------------------------------------------------
  # * Alias per utilizzare tutta la larghezza
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = nil)
    width = contents_width if width.nil?
    if (item.is_a?(RPG::Weapon) or item.is_a?(RPG::Armor)) and @category != :all
      enabled = true
    end
    super(item, x, y, enabled, width)
  end
end

class Game_Party < Game_Unit
  alias inventory_item_number item_number unless $@
  # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
  # @param [Boolean] include_equips
  # @return [Integer]
  def item_number(item, include_equips = false)
    inventory_item_number(item) + include_equips ? members_item_number(item) : 0
  end

  # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
  # @return [Integer]
  def members_item_number(item)
    sum = 0
    members.each { |member| sum += member.equips.select { |equip| equip == item}.size }
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
  #--------------------------------------------------------------------------
  # * Carica il database
  #--------------------------------------------------------------------------
  def load_database
    h87item_load_database
    load_h87_items
  end

  #--------------------------------------------------------------------------
  # * Inizializza i parametri degli oggetti
  #--------------------------------------------------------------------------
  def load_h87_items
    $data_items.each { |item|
      next if item.nil?
      item.load_custom_details
    }
    $data_weapons.each { |weapon|
      next if weapon.nil?
      weapon.load_custom_details
    }
    $data_armors.each { |armor|
      next if armor.nil?
      armor.load_custom_details
    }
  end
end
