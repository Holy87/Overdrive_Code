#==============================================================================
# * Window_ShopInfo
# finestra delle informazioni del negozio
#==============================================================================
class Window_ShopInfo < Window_Base
  # inizializzazione
  # @param [Game_Shop] shop
  def initialize(shop)
    super(0, 0, Graphics.width - 160, fitting_height(1))
    @shop = shop
    @action = :nothing
    refresh
  end

  # refresh
  def refresh
    contents.clear
    change_color(normal_color)
    draw_text(0, 0, contents_width, line_height, shop.name)
    draw_action
  end

  def draw_action
    return if @action.nil?
    return if @action == :nothing
    change_color(crisis_color)
    text = ' // ' + Vocab.shop_action(@action)
    x = text_size(shop.name).width + 5
    width = contents_width - x
    draw_text(x, 0, width, line_height, text)
  end

  # @return [Game_Shop]
  def shop
    @shop
  end

  # @param [Symbol] new_action
  def set_action(new_action)
    return if @action == new_action
    @action = new_action
    refresh
  end
end

#==============================================================================
# * Window_ShopCommand
# finestra dei comandi del negozio
#==============================================================================
class Window_ShopCommandN < Window_Command
  # inizializzazione
  def initialize
    @shop = $game_temp.custom_shop
    super(0, 0)
    refresh
    update_placement
    self.openness = 0
    deactivate
  end

  # larghezza della finestra
  def window_width
    160
  end

  # crea la lista dei comandi
  def make_command_list
    add_command(Vocab::ShopBuy, :buy) if @shop.permit_buy?
    add_command(Vocab::ShopSell, :sell) if @shop.permit_sell?
    add_command(Vocab.shop_rebuy, :rebuy, rebuy?) if Shop_Core.rebuy_active?
    add_command(Vocab::ShopCancel, :cancel)
  end

  def rebuy?
    @shop.rebuy_articles.size > 0
  end

  # centra la finestra
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end

  # aggiorna l'aiuto al cambio di cursore
  def update_help
    super
    @help_window.set_text(help_data) if @help_window
  end

  # @return [String]
  def help_data
    case current_symbol
    when :buy
      ShopsSettings::HELP_BUY
    when :sell
      ShopsSettings::HELP_SELL
    when :rebuy
      ShopsSettings::HELP_REBUY
    when :cancel
      ShopsSettings::HELP_CANCEL
    else
      ''
    end
  end
end

#==============================================================================
# * Window_ShopItems
# Superclasse delle finestre liste dei beni
#==============================================================================
class Window_ShopItems < Window_Selectable
  def initialize(x, y, width, height)
    @shop = $game_temp.custom_shop
    make_item_list
    super
    @item_number_width = text_size('x100').width
    refresh
    self.index = 0
    self.visible = false
    self.active = false
  end

  # Ottiene il numero di elementi
  # @return [Integer]
  def item_max
    @data ? @data.size : 0
  end

  # restituisce il negozio corrente
  # @return [Game_Shop]
  def shop
    @shop
  end

  # restituisce l'oggetto corrente
  # @return [RPG::Item,RPG::Weapon,RPG::Armor]
  def item
    # restituito dalla sottoclasse
  end

  # determina se l'oggetto selezionato dal cursore è cliccabile
  def current_item_enabled?
    enable?(@data[@index])
  end

  def enable?(item)
    item != nil
  end

  # imposta la finestra dei dettagli oggetto
  def info_window=(window)
    @info_window = window
  end

  # restituisce la finestra dei dettagli oggetto
  # @return [Window_ItemInfo]
  def info_window
    @info_window
  end

  # aggiorna l'aiuto al cambio di cursore
  def update_help
    super
    @help_window.set_item(item) if @help_window
    info_window.set_item(item) if @info_window
  end

  def process_handling
    super
    return unless open? && active
    process_function if handle?(:function) && Input.trigger?(:X)
  end

  def process_function
    Input.update
    call_handler(:function)
  end
end

#==============================================================================
# * Window_ShopBuyN
# Nuova finestra d'acquisto dei beni
#==============================================================================
class Window_ShopBuyN < Window_ShopItems
  # determina se l'oggetto è attivo e cliccabile
  # @param [Shop_Article] article
  def enable?(article)
    item = article.item
    return false if shop.sold_out? item
    return false if shop.item_number(item) == 0
    return false if $game_party.item_number(item) >= $game_party.max_item_number(item)
    if article.custom_currency?
      $game_party.currency_gained(article.currency_key) >= @shop.article_price(article, true)
    else
      $game_party.gold >= @shop.article_price(article, true)
    end
  end

  # disegna la quantità dell'oggetto
  # @param [Shop_Article] good
  # @param [Rect] rect
  # @param [Boolean] enabled
  def draw_quantity(good, rect, enabled)
    if good.unlimited?
      text = ShopsSettings::ENDLESS
    else
      text = sprintf('x%d', good.quantity)
    end
    change_color(normal_color, enabled)
    draw_text(rect, text, 2)
  end

  # ottiene la lista degli oggetti da vendere
  def make_item_list
    @data = shop.sellable_articles.clone
  end

  # mostra il prezzo dell'articolo
  # @param [Shop_Article] good
  # @param [Rect] rect
  # @param [Boolean] enabled
  def draw_price(good, rect, enabled)
    width = rect.width - @item_number_width
    change_color(power_up_color, enabled) if good.in_sale?
    if good.custom_currency?
      currency = $data_currencies[good.currency_key]
      text =  @shop.article_price(good, true)
      draw_text(rect.x, rect.y, width - 24, line_height, text, 2)
      draw_icon(currency.icon_index, rect.x + rect.width - 24, rect.y, enabled)
    else
      text = sprintf('%d %s', @shop.article_price(good, true), Vocab::currency_unit)
      draw_text(rect.x, rect.y, width, line_height, text, 2)
    end
    x2 = text_size(good.item.name).width + 24
    if good.sale_value != 0
      contents.font.size -= 7
      text2 = sprintf('-%d%%', good.sale_value)
      draw_text(x2, rect.y, rect.width - x2, line_height, text2)
      contents.font.size += 7
    end
  end

  def draw_sold_out(rect)
    change_color knockout_color, false
    draw_text(rect, Vocab.sold_out, 2)
  end

  # restituisce il bene
  # @return [Shop_Article]
  def selected_good
    @data[@index]
  end

  # restituisce l'oggetto corrente
  # @return [RPG::Item,RPG::Weapon,RPG::Armor]
  def item
    return nil if selected_good.nil?
    selected_good.item
  end

  # disegna l'oggetto
  def draw_item(index)
    good = @data[index]
    return if good.nil?
    item = good.item
    rect = item_rect_for_text(index)
    enabled = enable?(good)
    draw_item_name(item, rect.x, rect.y, enabled, 200)
    if shop.sold_out? item
      draw_sold_out(rect)
    else
      draw_price(good, rect, enabled)
      draw_quantity(good, rect, enabled)
    end
  end

end

class Window_ShopSellN < Window_ShopItems

  def make_item_list
    @data = $game_party.sellable_items
  end

  def refresh
    make_item_list
    super
  end

  # @return [RPG::Item, RPG::Weapon, RPG::Armor]
  def item
    @data[@index]
  end

  # @param [Integer] index
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect_for_text(index)
    enabled = enable?(index)
    draw_item_name(item, rect.x, rect.y, enabled, 200)
    draw_item_number rect, item
    draw_item_price rect, item
  end

  # @param [Rect] rect
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def draw_item_price(rect, item)
    text = sprintf('%d %s', shop.item_sell_price(item), Vocab.currency_unit)
    rect.width -= @item_number_width
    draw_text rect, text, 2
  end

  # @param [Rect] rect
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def draw_item_number(rect, item)
    number = $game_party.item_number item
    text = sprintf('x%d', number)
    draw_text rect, text, 2
  end
end


class Window_ShopRebuy < Window_ShopItems
  def make_item_list
    @data = shop.rebuy_articles
  end

  # @param [Game_RebuyData] article
  def enable?(article)
    article.number > 0
  end

  # @return [Game_RebuyData]
  def current_article
    @data[@index]
  end

  def item
    return nil if current_article.nil?
    current_article.item
  end

  # @param [Integer] index
  #noinspection DuplicatedCode
  def draw_item(index)
    article = @data[index]
    return if article.nil?
    rect = item_rect_for_text(index)
    enabled = enable?(article)
    item = article.item
    draw_item_name(item, rect.x, rect.y, enabled, 200)
    draw_item_number rect, article.number
    draw_item_price rect, item
  end

  # @param [Rect] rect
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def draw_item_price(rect, item)
    text = sprintf('%d %s', shop.item_sell_price(item), Vocab.currency_unit)
    rect.width -= @item_number_width
    draw_text rect, text, 2
  end

  # @param [Rect] rect
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def draw_item_number(rect, number)
    text = sprintf('x%d', number)
    draw_text rect, text, 2
  end
end

#==============================================================================
# * Window_ShopKeys
# finestra che mostra gli aiuti tasti nello shop
#==============================================================================
class Window_ShopKeys < Window_KeyHelp

  # Inizializzazione
  def initialize(x, y, width)
    super(2, x, y, width)
    set_command 0, Key_Command_Container.new([:C], Vocab.shop_select)
    set_command 1, Key_Command_Container.new([:X], Vocab.key_change_view)
  end
end

#==============================================================================
# Window_ShopNumberN
# nuova finestra per l'acquisto
#==============================================================================
class Window_ShopNumberN < Window_Base
  attr_reader :quantity
  # object initialization
  def initialize
    super(0, 0, 400, fitting_height(6))
    @quantity = 1
    @item = nil
    @mode = :buy
    cursor_rect.set(cursor_x, 0, contents_width - cursor_x, line_height)
    update_placement
    @handler = {}
    self.openness = 0
  end

  # aggiorna la disposizione della finestra
  def update_placement
    self.x = (Graphics.width - self.width) / 2
    self.y = (Graphics.height - self.height) / 2
  end

  # refresh
  def refresh
    contents.clear
    return if item.nil?
    draw_item_name(item, 0, 0, true, cursor_x)
    draw_item_number(cursor_x, 0, contents_width - cursor_x)
    draw_next_possessed(1)
    draw_item_cost(2)
    draw_separator(3)
    draw_selection_help(4)
  end

  # disegna un separatore
  def draw_separator(line_number)
    rect = line_rect(line_number)
    rect.y += 1
    rect.height = 1
    self.contents.fill_rect(rect.x, rect.y, rect.width, rect.height, gauge_back_color)
  end

  # draws the item number
  def draw_item_number(x, y, width)
    draw_arrow(:left, x, y, can_sub?)
    arrow_x = x + width - arrow_rect(:right).width
    draw_arrow(:right, arrow_x, y, can_add?)
    xx = x + arrow_rect(:left).width
    text = sprintf('%d/%d', @quantity, max)
    text_w = width - arrow_rect(:left).width - arrow_rect(:right).width
    draw_text(xx, y, text_w, line_height, text, 1)
  end

  # disegna il costo dell'oggetto
  def draw_item_cost(line)
    cost = @mode == :buy ? shop.item_price(item, true) : shop.item_sell_price(item)
    cost *= @quantity
    change_color(system_color)
    draw_text(line_rect(line), Vocab::shop_total)
    change_color(normal_color)
    article = shop.article_from_item(item)
    if article.custom_currency?
      currency = $data_currencies[article.currency_key]
      text = sprintf("%dx", cost)
      x = 24 + text_width(currency.name) + text_width(text)
      draw_text(x, line_rect(line).y, contents_width, line_height)
      draw_icon(currency.icon_index, x + text_width(text), line_rect(line).y)
      draw_text(line_rect(line), currency.name, 2)
    else
      text = sprintf('%d %s', cost, Vocab::currency_unit)
      draw_text(line_rect(line), text, 2)
    end
  end

  def draw_next_possessed(line)
    desc_width = contents_width - cursor_x
    rect = line_rect(line)
    rect.width = desc_width
    change_color system_color
    draw_text rect, Vocab::Possession
    change_color normal_color
    rect.x += contents_width - desc_width
    draw_text rect, $game_party.item_number(item)
    draw_icon(ShopsSettings::ARROW_ICON, rect.x + rect.width / 2 - 12, rect.y)
    possessed = $game_party.item_number(item)
    total = @mode == :sell ? possessed - @quantity : possessed + @quantity
    draw_text rect, total, 2
  end

  def draw_selection_help(line)
    rect = line_rect(line)
    rect.width -= 24
    rect.x += 24
    draw_key_icon(:C, 0, rect.y)
    change_color normal_color
    draw_text rect, action_vocab
    rect.y += line_height
    draw_key_icon(:X, 0, rect.y)
    draw_text rect, function_vocab
  end

  def action_vocab
    case @mode
    when :buy
      Vocab.key_buy
    when :sell
      Vocab.key_sell
    when :rebuy
      Vocab.key_rebuy
    else
      ''
    end
  end

  def function_vocab
    case @mode
    when :buy
      Vocab.key_a_buy
    when :sell
      Vocab.key_a_sell
    when :rebuy
      Vocab.key_a_rebuy
    else
      ''
    end
  end

  # coordinata X del cursore
  def cursor_x
    contents_width - 100
  end

  # determina la quantità massima acquistabile di un bene
  # @return [Integer]
  def max_buyable
    max_shop = shop.item_number(item) >= 0 ? shop.item_number(item) : 99
    [$game_party.max_item_number(item) - $game_party.item_number(item),
     max_shop, $game_party.gold / shop.item_price(item, true)].min
  end

  def max_rebuyable
    article = shop.rebuy_article(item)
    [article.number, $game_party.gold / article.number,
     ($game_party.max_item_number(item) - $game_party.item_number(item)),
    ].min
  end

  # determina la quantità massima che un bene può essere venduto
  def max_sellable
    $game_party.item_number(item)
  end

  # determina se può diminuire il numero di oggetti
  def can_sub?
    @quantity > 1
  end

  # determina se può aumentare il numero di oggetti
  def can_add?
    @quantity < max
  end

  # imposta l'ogetto della finestra
  # @param [RPG::Item] new_item
  def set_item(new_item)
    @item = new_item
    @quantity = 1
    refresh
  end

  # imposta oggetto e modalità ed aggiorna la grafica
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] new_item
  # @param [Symbol] new_mode
  def set_data(new_item, new_mode)
    @quantity = 1
    @mode = new_mode
    @item = new_item
    refresh
  end

  # @return [RPG::Item]
  def item
    @item
  end

  # returns the current shop
  # @return [Game_Shop]
  def shop
    $game_temp.custom_shop
  end

  def update_arrows
    return if item.nil?
    reduce if Input.repeat?(:LEFT) and can_sub?
    add if Input.repeat?(:RIGHT) and can_add?
  end

  # aggiornamento
  def update
    super
    return unless open?
    update_arrows
    process_handling
  end

  # riduce di 1 unità
  def reduce
    @quantity -= 1
    Sound.play_cursor
    Input.update
    refresh
  end

  # aggiunge di 1 unità
  def add
    @quantity += 1
    Sound.play_cursor
    Input.update
    refresh
  end

  # aggiorna l'handler per Ok e Esc
  # noinspection RubyUnnecessaryReturnStatement
  def process_handling
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_function if ok_enabled?        && Input.trigger?(:X)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
  end

  # ottiene lo stato di attivazione dell'Ok
  def ok_enabled?; handle?(:ok); end

  # ottiene lo stato di attivazione di Esc
  def cancel_enabled?; handle?(:cancel); end

  # processo che viene eseguito quando è premuto Ok
  def process_ok
    Sound.play_shop
    Input.update
    call_ok_handler
  end

  def process_function
    @quantity = max
    Input.update
    process_ok
  end

  def max
    case @mode
    when :sell
      max_sellable
    when :buy
      max_buyable
    when :rebuy
      max_rebuyable
    else
      0
    end
  end

  # chiama l'handler di Ok
  def call_ok_handler
    call_handler(:ok)
  end

  # processo che viene eseguito quando è premuto Esc
  def process_cancel
    Sound.play_cancel
    Input.update
    close
    call_cancel_handler
  end
  #--------------------------------------------------------------------------
  # * chiama l'handler di annullamento
  #--------------------------------------------------------------------------
  def call_cancel_handler; call_handler(:cancel); end
  #--------------------------------------------------------------------------
  # * imposta un handler
  #--------------------------------------------------------------------------
  def set_handler(symbol, method)
    @handler[symbol] = method
  end
  #--------------------------------------------------------------------------
  # * controlla l'esistenza di un handler
  #--------------------------------------------------------------------------
  def handle?(symbol); @handler.include?(symbol); end
  #--------------------------------------------------------------------------
  # * chiama un handler
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    @handler[symbol].call if handle?(symbol)
  end
end

class Window_ShopStatusN < Window_Base

  # @param[Game_Shop] shop
  def initialize(x, y, width, height, shop)
    super(x, y, width, height)
    @item = nil
    @shop = shop
    refresh
  end

  def set_item(new_item)
    return if @item.equal?(new_item)
    @item = new_item
    refresh
  end

  # restituisce il negozio corrente
  # @return [Game_Shop]
  def shop
    @shop
  end

  # @return [RPG::Item,RPG::Armor,RPG::Weapon]
  def item
    @item
  end

  def refresh
    contents.clear
    return if item.nil?
    draw_item_possession
    line = draw_item_sale
    draw_equip_info(line + 1)
  end

  def draw_item_possession
    change_color system_color
    draw_text(line_rect(0), Vocab::Possession)
    change_color normal_color
    draw_text line_rect(0), $game_party.item_number(item), 2
  end

  # draws the current sale (if it is in sale)
  # @return [Integer]
  def draw_item_sale
    return 0 unless shop.item_in_sale?(item)
    change_color crisis_color
    draw_text(line_rect(1), sprintf(Vocab.in_sale, shop.item_discount(item)), 1)
    1
  end

  # mostra i membri del gruppo che possono equipaggiare
  # l'oggetto ed i relativi cambi di parametri
  # @param [Integer] line
  def draw_equip_info(line)
    return if item.is_a?(RPG::Item)
    $game_party.all_members.each do |member|
      line = draw_actor_params(member, line)
    end
    line
  end

  # disegna i parametri che cambiano con l'equip
  # @param [Game_Actor] actor
  # @param [Integer] line
  def draw_actor_params(actor, line)
    return line unless actor.equippable? item
    rect = line_rect(line)
    draw_actor_little_face(actor, rect.x, rect.y)
    rect.x += 32
    rect.width -= 32
    if actor.level < item.equip_level
      change_color power_down_color
      draw_text rect, Vocab.level_too_low
    elsif actor.equips.collect { |equip| equip.id }.include? item.id
      change_color pending_color
      draw_text rect, Vocab.already_equipped
    else
      cloned = clone_actor actor
      kind = item.is_a?(RPG::Weapon) ? 0 : item.kind + 1
      #noinspection RubyYardParamTypeMatch
      cloned.change_equip(kind, item, true)
      draw_stat_differences(actor, cloned, rect)
    end
    line + 1
  end

  # disegna le differenze in statistiche dell'equipaggiamento
  # @param [Game_Actor] actor
  # @param [Game_Actor] clone_actor
  # @param [Rect] rect
  def draw_stat_differences(actor, clone_actor, rect)
    max_diff = rect.width / ShopsSettings::PARAMS_WIDTH
    compared_values = compare_values
    y = rect.y
    index = 0
    width = ShopsSettings::PARAMS_WIDTH
    contents.font.size -= 2
    compared_values.each do |val|
      x = rect.x + index * width
      index += draw_param_comparation(val, actor, clone_actor, x, y)
      break if index >= max_diff
    end
    contents.font.size += 2
  end

  # ottiene l'elenco dei parametri da confrontare
  # @return [Array<Symbol>]
  def compare_values
    if item.is_a? RPG::Weapon
      ShopsSettings::WEAPON_COMPARE
    else
      [ShopsSettings::SHIELD_COMPARE,
       ShopsSettings::HELMET_COMPARE,
       ShopsSettings::ARMOR__COMPARE,
       ShopsSettings::ACCESS_COMPARE
      ][item.kind]
    end
  end

  # disegna il parametro da comparare
  # @param [Symbol] param
  # @param [Game_Actor] actor
  # @param [Game_Actor] clone
  # @param [Integer] x
  # @param [Integer] y
  def draw_param_comparation(param, actor, clone, x, y)
    actor_param = actor.send(param)
    clone_param = clone.send(param)
    return 0 if actor_param == clone_param
    draw_icon param_icon(param), x, y
    change_color(actor_param < clone_param ? power_up_color : power_down_color)
    draw_text(x, y, ShopsSettings::PARAMS_WIDTH, line_height, sprintf('%+d', clone_param - actor_param), 2)
    1
  end

  # Restituisce un clone scollegato dell'eroe (per evitare bug)
  # @return [Game_Actor]
  # @param [Game_Actor] actor
  # noinspection RubyResolve
  def clone_actor(actor)
    Marshal.load(Marshal.dump(actor))
  end

  # Restituisce l'icona del parametro
  # @param [Symbol] param
  # @return [Integer]
  def param_icon(param)
    EquipSettings::ICONS[param]
  end
end