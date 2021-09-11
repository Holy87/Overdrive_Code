#===============================================================================
# ** Impostazioni script
#===============================================================================
module H87EquipPowerUp
  REQUIRETITLE = "Oggetti richiesti"
  PUPICON = 518 # icona di default del powerup (non funziona più)
  SUCCESSSOUND = "Item3" # suono del power up
  SUCCESSTEXT = "Hai aggiunto l'abilità %s su %s!"
  SKILLREMOVED = "Rimuovi l'abilità $s da $s.|L'operazione non può essere annullata."
  DISENCHANT_PRICE_DIVISOR = 8 # divisore del prezzo reale per costo disincantamento
  DISENCHANT_REQ = 'Oro richiesto:'
end

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# stringhe generiche
#===============================================================================
module Vocab
  def self.pow_required_item; H87EquipPowerUp::REQUIRETITLE; end
  def self.item_powered; H87EquipPowerUp::SUCCESSTEXT; end
  def self.item_depower; H87EquipPowerUp::SKILLREMOVED; end
  def self.disenchant_gold; H87EquipPowerUp::DISENCHANT_REQ; end
end

#===============================================================================
# ** RPG::Weapon
#===============================================================================
class RPG::Weapon
  #--------------------------------------------------------------------------
  # * restituisce il prezzo per disincantare l'oggetto
  # @return [Integer]
  #--------------------------------------------------------------------------
  def disenchant_price
    self.price / H87EquipPowerUp::DISENCHANT_PRICE_DIVISOR
  end
end

#===============================================================================
# ** Scene_EquipEnhancer
#-------------------------------------------------------------------------------
# la schermata di potenziamento dell'arma
#===============================================================================
class Scene_EquipEnhancer < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_requirement_window
    create_power_list_window
    create_equip_window
    create_popup_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra della lista equip
  #--------------------------------------------------------------------------
  def create_equip_window
    x = 0
    y = @help_window.height
    w = Graphics.width/2
    h = Graphics.height - y
    @equip_window = Window_PEquipList.new(x, y, w, h)
    @equip_window.power_window = @power_list_window
    @equip_window.help_window = @help_window
    @equip_window.set_handler(:ok, method(:power_selection))
    @equip_window.set_handler(:cancel, method(:return_scene))
    @equip_window.index=0
    @equip_window.active = true
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei requisiti
  #--------------------------------------------------------------------------
  def create_requirement_window
    x = Graphics.width/2
    y = Graphics.height - 104
    w = Graphics.width - x
    h = 104
    @requirement_window = Window_PowerRequirement.new(x, y, w, h)
  end
  #--------------------------------------------------------------------------
  # * crea la finestra della lista dei potenziamenti
  #--------------------------------------------------------------------------
  def create_power_list_window
    x = Graphics.width/2
    y = @help_window.height
    w = Graphics.width - x
    h = Graphics.height - y - @requirement_window.height
    @power_list_window = Window_PowerList.new(x, y, w, h)
    @power_list_window.requirement_window = @requirement_window
    @power_list_window.help_window = @help_window
    @power_list_window.set_handler(:ok, method(:power_up))
    @power_list_window.set_handler(:cancel, method(:cancel_selection))
    @power_list_window.active = false
    @power_list_window.index = -1
  end
  #--------------------------------------------------------------------------
  # * crea la finestra popup
  #--------------------------------------------------------------------------
  def create_popup_window
    @popup_window = Window_PopUp.new
    @popup_window.set_handler(:ok, method(:done))
    @popup_window.set_handler(:cancel, method(:done))
  end
  #--------------------------------------------------------------------------
  # * crea la finestra di selezione potere
  #--------------------------------------------------------------------------
  def power_selection
    @equip_window.active = false
    @power_list_window.active = true
    @power_list_window.index = 0
  end
  #--------------------------------------------------------------------------
  # * processo di annullamento selezione
  #--------------------------------------------------------------------------
  def cancel_selection
    @equip_window.active = true
    @power_list_window.active = false
    @power_list_window.index = -1
    @requirement_window.set_power_up(nil, nil)
  end
  #--------------------------------------------------------------------------
  # * potenzia l'arma
  #--------------------------------------------------------------------------
  def power_up
    equip = @equip_window.item
    power = @power_list_window.item
    equip_power_up(equip, power)
  end
  #--------------------------------------------------------------------------
  # * processo di potenziamento
  #--------------------------------------------------------------------------
  def equip_power_up(equip, power)
    @power_list_window.active = false
    @power_list_window.index = -1
    @requirement_window.set_power_up(nil, nil)
    $game_party.gain_item(H87Enchant.power_equip(equip, power), 1)
    @power_list_window.refresh
    @equip_window.redraw_current_item
    @requirement_window.refresh
    RPG::SE.new(H87EquipPowerUp::SUCCESSSOUND).play
    text = sprintf(H87EquipPowerUp::SUCCESSTEXT, power.name, equip.name)
    @popup_window.open(text)
  end
  #--------------------------------------------------------------------------
  # * fine del potenziamento
  #--------------------------------------------------------------------------
  def done
    @popup_window.close
    @equip_window.active = true
  end
end

#===============================================================================
# ** Window_PEquipList
#-------------------------------------------------------------------------------
# contiene la finestra degli equipaggiamenti potenziabili
#===============================================================================
class Window_PEquipList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    make_item_list
    super(x, y, w, h)
    refresh
  end
  #--------------------------------------------------------------------------
  # * imposta la finestra dei potenziamenti
  #--------------------------------------------------------------------------
  def power_window=(window)
    @power_window = window
  end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    @power_window.set_equip(item)
    @help_window.set_text(item == nil ? "" : item.description)
  end
  #--------------------------------------------------------------------------
  # * crea la finestra degli oggetti
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.items.select{|item| next if item.nil?; item.power_up_possible?}
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect(index)
    number = $game_party.item_number(item)
    enabled = enable?(item)
    rect.width -= 4
    draw_item_name(item, rect.x, rect.y, enabled)
    draw_text(rect, sprintf("x%2d", number), 2)
  end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto corrente è selezionabile
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(item)
  end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto è abilitato
  # @param [RPG::Weapon] item
  #--------------------------------------------------------------------------
  def enable?(item)
    return false if item.nil?
    return false if $game_party.item_number(item) == 0
    return false unless item.power_up_possible?
    true
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto
  # @return [RPG::Weapon]
  #--------------------------------------------------------------------------
  def item; @data[self.index]; end
end

#===============================================================================
# ** Window_PowerRequirement
#-------------------------------------------------------------------------------
# mostra i requisiti per potenziare l'arma
#===============================================================================
class Window_PowerRequirement < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    super
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @equip.nil? or @power_up.nil?
    draw_window_title
    draw_pup_requirements
  end
  #--------------------------------------------------------------------------
  # * restituisce il power up da validare
  # @return [Power_Up]
  #--------------------------------------------------------------------------
  def ability; @power_up; end
  #--------------------------------------------------------------------------
  # * imposta un nuovo power up ed un nuovo equip
  # @param [Power_Up] new_power_up
  # @param [RPG::Weapon] equip
  #--------------------------------------------------------------------------
  def set_power_up(new_power_up, equip)
    return if ability.id == new_power_up.id and @power_up == equip
    @power_up = new_power_up
    @equip = equip
    refresh
  end
  #--------------------------------------------------------------------------
  # * disegna il titolo della finestra
  #--------------------------------------------------------------------------
  def draw_window_title
    draw_bg_srect(0, 0, contents_width, line_height)
    draw_text(0,0,contents_width, line_height, Vocab.pow_required_item)
  end
  #--------------------------------------------------------------------------
  # * disegna i requisiti del potenziamento
  #--------------------------------------------------------------------------
  def draw_pup_requirements
    draw_required_item
    draw_required_gold
  end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto richiesto
  #--------------------------------------------------------------------------
  def draw_required_item
    item = ability.item
    number = $game_party.item_number(item)
    enabled = number >= ability.number
    draw_item_name(item, 0, line_height, enabled)
    change_color(normal_color, enabled)
    draw_text(line_rect(1), sprintf("x%d/%d",ability.number, number), 2)
  end
  #--------------------------------------------------------------------------
  # * disegna l'oro richiesto
  #--------------------------------------------------------------------------
  def draw_required_gold
    enabled = $game_party.gold >= ability.required_gold(@equip)
    change_color(normal_color, enabled)
    draw_text(line_rect(2), Vocab.gold)
    text = sprintf("%d / %d",ability.required_gold(@equip), $game_party.gold)
    draw_text(line_rect(2), text, 2)
  end
end

#===============================================================================
# ** Window_PowerList
#-------------------------------------------------------------------------------
# finestra che mostra la lista dei potenziamenti disponibili
#===============================================================================
class Window_PowerList < Window_Selectable
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    make_item_list
    super
    refresh
  end
  #--------------------------------------------------------------------------
  # * determina se il potenziamento selezionato è abilitato
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(power_up)
  end
  #--------------------------------------------------------------------------
  # * determina se il potenziamento è cliccabile
  # @param [Power_Up] power_up
  #--------------------------------------------------------------------------
  def enable?(power_up)
    power_up.requirement_met?(equip)
  end
  #--------------------------------------------------------------------------
  # * restituisce l'equipaggiamento da potenziare
  # @return [RPG::Weapon]
  #--------------------------------------------------------------------------
  def equip; @equip; end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra d'aiuto e quella dei requisiti
  #--------------------------------------------------------------------------
  def update_help
    return if @data.nil?
    @help_window.set_item(power_up) if @help_window
    update_req_window
  end
  #--------------------------------------------------------------------------
  # * imposta la finestra dei requisiti
  # @param [Window_PowerRequirement] window
  #--------------------------------------------------------------------------
  def requirement_window=(window)
    @requirement_window = window
  end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra dei requisiti
  #--------------------------------------------------------------------------
  def update_req_window
    return if @requirement_window.nil?
    @requirement_window.set_power_up(power_up, equip)
  end
  #--------------------------------------------------------------------------
  # * restituisce il power up
  # @return [Power_Up]
  #--------------------------------------------------------------------------
  def power_up; @data[self.index]; end
  #--------------------------------------------------------------------------
  # * restituisce sempre il power up (è un alias)
  # @return [Power_Up]
  #--------------------------------------------------------------------------
  def item; power_up; end
  #--------------------------------------------------------------------------
  # * crea i dati
  #--------------------------------------------------------------------------
  def make_item_list
    @data = equip.nil? ? [] : equip.power_ups
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * imposta il pezzo d'equipaggiamento e refresha la lista
  # @param [RPG::Weapon] new_equip
  #--------------------------------------------------------------------------
  def set_equip(new_equip)
    return if new_equip == @equip
    @equip = new_equip
    make_item_list
    create_contents
    refresh
  end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto (potenziamento)
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    power = @data[index]
    enabled = enable?(power)
    draw_icon(power.icon, rect.x, rect.y, enabled)
    change_color(normal_color, enabled)
    rect.x += 24; rect.width -= 24
    draw_text(rect, power.name)
  end
end

#===============================================================================
# ** Scene_EquipDisenchant
#-------------------------------------------------------------------------------
# schermata per rimuovere le abilità speciali delle armi
#===============================================================================
class Scene_EquipDisenchant < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_item_list_window
    create_gold_window
    create_details_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra della lista degli equip
  #--------------------------------------------------------------------------
  def create_item_list_window
    @list_window = Window_DisenchantList.new(@help_window.height)
    @list_window.help_window = @help_window
    @list_window.set_handler(:ok, method(:disenchant_command))
    @list_window.set_handler(:cancel, method(:return_scene))
    @list_window.activate
  end
  #--------------------------------------------------------------------------
  # * disincanta l'oggetto evidenziato dal cursore.
  #--------------------------------------------------------------------------
  def disenchant_command
    RPG::SE.new("Magic3").play
    H87Enchant.remove_power_up_from_equip(@list_window.item)
    $game_party.lose_gold(@list_window.item.disenchant_price)
    @list_window.refresh
    @list_window.activate
    @gold_window.refresh
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dell'oro richiesto
  #--------------------------------------------------------------------------
  def create_gold_window
    x = @list_window.width
    y = @list_window.y
    width = Graphics.width - x
    @gold_window = Window_DisenchantRequirements.new(x, y, width)
    @list_window.gold_window = @gold_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei dettagli
  #--------------------------------------------------------------------------
  def create_details_window
    x = @gold_window.x
    y = @gold_window.bottom_corner
    width = @gold_window.width
    height = Graphics.height - y
    @details_window = Window_ItemInfo.new(x, y, width, height)
    @list_window.details_window = @details_window
  end
end

#===============================================================================
# ** Window_DisenchantList
#-------------------------------------------------------------------------------
# finestra che mostra gli equip disincantabili
#===============================================================================
class Window_DisenchantList < Window_Selectable
  #--------------------------------------------------------------------------
  # * dichiarazione delle finestre pubbliche
  # @return [Window_ItemInfo] details_window
  # @return [Window_DisenchantRequirements] gold_window
  #--------------------------------------------------------------------------
  attr_accessor :details_window
  attr_accessor :gold_window
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize(y, details_window = nil, gold_window = nil)
    @details_window = details_window
    @gold_window = gold_window
    make_item_list
    super(0, y, Graphics.width/2, Graphics.height - y)
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(item == nil ? "" : item.description)
    @details_window.set_item(item) if @details_window
    @gold_window.set_equip(item) if @gold_window
  end
  #--------------------------------------------------------------------------
  # * crea la lista degli oggetti
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.items.select{|item| next if item.nil?; item.powered?}
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect(index)
    number = $game_party.item_number(item)
    enabled = enable?(item)
    rect.width -= 4
    draw_item_name(item, rect.x, rect.y, enabled, contents_width)
    draw_text(rect, sprintf("x%2d", number), 2)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?; enable?(item); end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto è abilitato
  # @param [RPG::Weapon] item
  #--------------------------------------------------------------------------
  def enable?(item)
    return false if $game_party.item_number(item) == 0
    return false unless item.powered?
    return false if item.disenchant_price > $game_party.gold
    true
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto selezionato
  # @return [RPG::Weapon]
  #--------------------------------------------------------------------------
  def item; @data[self.index]; end
end

#===============================================================================
# ** Window_DisenchantRequirements
#-------------------------------------------------------------------------------
# finestra che mostra i requisiti per rimuovere l'incantamento dall'arma.
# al momento è richiesto solo l'oro, quindi mostra solo quello
#===============================================================================
class Window_DisenchantRequirements < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, fitting_height(2))
    @equip = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if equip.nil?
    price = equip.disenchant_price
    change_color(system_color)
    draw_text(line_rect, Vocab.disenchant_gold)
    if price > $game_party.gold
      change_color(knockout_color, false)
    else
      change_color(normal_color)
    end
    text = sprintf('%d/%d %s', price, $game_party.gold, Vocab.currency_unit)
    rect = line_rect(1)
    draw_icon($data_system.gold_icon, rect.x, rect.y)
    rect.x += 24
    rect.y -= 24
    draw_text(rect, text, 2)
  end
  #--------------------------------------------------------------------------
  # * restituisce l'equipaggiamento
  # @return [RPG::Weapon]
  #--------------------------------------------------------------------------
  def equip; @equip; end
  #--------------------------------------------------------------------------
  # * imposta l'equipaggiamento
  # @param [RPG::Weapon] new_equip
  #--------------------------------------------------------------------------
  def set_equip(new_equip)
    return if @equip == new_equip
    @equip = new_equip
    refresh
  end
end

class Game_Interpreter
  # procedura di chiamata miglioramento delle armi
  def open_equip_enhancer
    $game_temp.next_scene = :equip_enhancer
  end

  # apre la finestra di rimozione incantamenti
  def open_equip_disenchant
    $game_temp.next_scene = :equip_disenchant
  end
end

class Scene_Map < Scene_Base
  alias h87_equip_en_update_scene_change update_scene_change unless $@

  def update_scene_change
    return if $game_player.moving?
    return call_equip_enhancer if $game_temp.next_scene == :equip_enhancer
    return call_equip_disenchant if $game_temp.next_scene == :equip_disenchant
    h87_equip_en_update_scene_change
  end

  def call_equip_enhancer
    SceneManager.call(Scene_EquipEnhancer)
  end

  def call_equip_disenchant
    SceneManager.call(Scene_EquipDisenchant)
  end
end