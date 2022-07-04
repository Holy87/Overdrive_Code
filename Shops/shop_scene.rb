class Scene_NewShop < Scene_MenuBase
  # restituisce la coordinata x dove si dividono finestra
  # degli oggetti e finestra delle info
  def split_width
    Graphics.width / 2 + 100
  end

  def create_shop_description_window
    @shop_window = Window_ShopInfo.new(shop)
    @shop_window.y = @help_window.height
  end

  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @shop_window.y
  end

  def create_shop_command_window
    @command_window = Window_ShopCommandN.new
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:buy, method(:command_buy))
    @command_window.set_handler(:sell, method(:command_sell))
    @command_window.set_handler(:rebuy, method(:command_rebuy))
    @command_window.help_window = @help_window
  end

  def create_good_list_window
    @goods_window = create_items_window Window_ShopBuyN
  end

  def create_sell_window
    @sell_window = create_items_window Window_ShopSellN
  end

  def create_rebuy_window
    @rebuy_window = create_items_window Window_ShopRebuy
  end

  # @param [Class] class_name
  # @return [Window_ShopItems]
  def create_items_window(class_name)
    x = 0
    y = @shop_window.bottom_corner
    width = split_width
    height = Graphics.height - @keys_window.height - y
    window = class_name.new(x, y, width, height)
    window.set_handler(:ok, method(:choose_item))
    window.set_handler(:cancel, method(:back))
    window.set_handler(:function, method(:switch_view))
    window.viewport = @shop_viewport
    window.active = false
    window
  end

  def create_keys_window
    width = split_width
    @keys_window = Window_ShopKeys.new(0, 0, width)
    @keys_window.y = Graphics.height
    @keys_window.viewport = @shop_viewport
    @keys_window.visible = false
  end

  def create_item_info_window
    x = Graphics.width
    y = @goods_window.y
    w = Graphics.width - split_width
    h = Graphics.height - y
    @info_window = Window_ItemInfo.new(x, y ,w, h)
    @info_window.viewport = @shop_viewport
    set_info_window @info_window
    @goods_window.info_window = @info_window
    @sell_window.info_window = @info_window
  end

  def create_equip_info_window
    x = Graphics.width
    y = @goods_window.y
    width = Graphics.width - split_width
    height = Graphics.height - y
    @equip_window = Window_ShopStatusN.new(x, y, width, height, shop)
    @equip_window.viewport = @shop_viewport
    @equip_window.visible = false
  end

  def create_shop_number_window
    @shop_number_window = Window_ShopNumberN.new
    @shop_number_window.set_handler(:ok, method(:item_number_confirmation))
    @shop_number_window.set_handler(:cancel, method(:return_to_item_selection))
  end

  def command_buy
    show_list_window :buy
  end

  def command_sell
    show_list_window :sell
  end

  def command_rebuy
    show_list_window :rebuy
  end

  def switch_view
    Sound.play_cursor
    @info = current_view == :general ? :equip : :general
    hide_info_windows
    show_info_windows
  end

  def back
    @shop_window.set_action :nothing
    item_list_windows.each { |w| w.smooth_move(0 - w.width, w.y) }
    @command_window.activate
    @command_window.open
    hide_info_windows
    @action = :nothing
  end

  # processo di selezione ok per l'oggetto evidenziato
  def choose_item
    @shop_viewport.color = Color::BLACK.deopacize(200)
    @shop_number_window.set_data(current_item, current_action)
    @shop_number_window.activate
    @shop_number_window.open
  end

  def return_to_item_selection
    @shop_number_window.close
    current_window.activate
    @shop_viewport.color = Color::BLACK.deopacize(0)
  end

  def item_number_confirmation
    Sound.play_shop
    return_to_item_selection
    send current_action
    item_list_windows.each { |w| w.refresh }
    @gold_window.refresh
  end

  def buy
    n = @shop_number_window.quantity
    if current_item.is_a? RPG::Fake_Item
      n.times { current_item.process_buy }
    else
      $game_party.gain_item(current_item, n)
    end
    article = shop.article_from_item current_item
    if article.custom_currency?
      $game_party.lose_currency(article.currency_key, shop.item_price(current_item, true) * n)
    else
      $game_party.lose_gold(shop.item_price(current_item, true) * n)
    end
    shop.apply_fidelity(current_item, n)
    shop.deplenish_item(current_item, n)
  end

  def sell
    n = @shop_number_window.quantity
    $game_party.lose_item(current_item, n)
    $game_party.gain_gold(shop.item_sell_price(current_item) * n)
    shop.add_rebuy_item(current_item, n)
    @command_window.refresh
  end

  def rebuy
    n = @shop_number_window.quantity
    $game_party.lose_gold(shop.item_sell_price(current_item) * n)
    $game_party.gain_item(current_item, n)
    shop.regain_rebuy_item(current_item, n)
    @command_window.refresh
  end

  # determina l'oggetto selezionato dal giocatore, indipendentemente
  # dalla finestra attiva
  # @return [RPG::Item, RPG::Weapon, RPG::Armor]
  def current_item
    current_window.item
  end

  # restituisce la finestra attiva corrente
  # @return [Window_ShopSellN, Window_ShopBuyN]
  def current_window
    case current_action
    when :buy
      @goods_window
    when :sell
      @sell_window
    when :rebuy
      @rebuy_window
    else
      nil
    end
  end

  # @return [Window_ItemInfo, Window_ShopStatusN]
  def current_info
    @info == :general ? @info_window : @equip_window
  end

  # ottiene la lista delle finestre Window_ShopItems (acquisto, vendita ecc..)
  # @return [Array<Window_ShopItems>]
  def item_list_windows
    instance_variables.map{ |v|instance_variable_get v}.select{|w|w.is_a?(Window_ShopItems) }
  end

  # crea il viewport che contiene le finestre che verranno rese scure
  # quando il giocatore seleziona l'oggetto da acquistare o vendere
  def create_shop_viewports
    @shop_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @item_number_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @item_number_viewport.z = @shop_viewport.z + 1
  end

  # @param [Symbol] mode
  def show_list_window(mode)
    @command_window.close
    @action = mode
    #@keys_window.set_mode mode
    @shop_window.set_action mode
    window = current_window
    window.smooth_move(0, window.y)
    window.activate
    window.index = 0
    window.visible = true
    show_info_windows
  end

  # fa tornare nello schermo le finestre di informazioni oggetti e comandi
  def show_info_windows
    window = current_info
    window.smooth_move(split_width, window.y)
    window.visible = true
    set_info_window window
    @keys_window.smooth_move(0, Graphics.height - @keys_window.height)
    @keys_window.visible = true
  end

  # fa uscire dallo schermo le informazioni di oggetti e comandi
  def hide_info_windows
    @info_window.smooth_move(Graphics.width, @info_window.y)
    @equip_window.smooth_move(Graphics.width, @equip_window.y)
    @keys_window.smooth_move(0, Graphics.height)
  end

  def set_info_window(info_window)
    item_list_windows.each { |w| w.info_window = info_window }
  end

  def start
    super
    @shop = $game_temp.custom_shop
    @action = :nothing
    @info = :general
    shop.remove_forbidden_articles
    create_help_window
    create_shop_description_window
    create_gold_window
    create_shop_viewports
    create_shop_command_window
    create_keys_window
    create_good_list_window
    create_sell_window
    create_rebuy_window
    create_item_info_window
    create_equip_info_window
    create_shop_number_window
    item_list_windows.each { |w| w.help_window = @help_window }
    back
  end

  # @return [Game_Shop]
  def shop
    @shop
  end

  # ottiene l'azione corrente (compra, vendi, ricompri, nulla)
  # @return [Symbol]
  def current_action
    @action
  end

  def current_view
    @info
  end

  def terminate
    super
    @shop_viewport.dispose
    @item_number_viewport.dispose
  end
end