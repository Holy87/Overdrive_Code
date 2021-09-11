#==============================================================================
# ** Shop_Good
# rappresenta un bene posseduto da Game_Shop. Contiene item, quantità e sconti.
#==============================================================================
class Shop_Article
  # tipo articolo [1: item, 2: weapon, 3: armor]
  # @return [Integer]
  attr_reader :item_type
  # ID oggetto
  attr_reader :item_id 
  # quantità dell'articolo disponibile
  attr_reader :quantity
  # se true, non può andare in saldo
  attr_accessor :sales_off
  # ammontare dei saldi (in percentuale)
  # @return [Float]
  attr_accessor :sale_value # valore di saldi
  # prezzo dell'articolo (modificato)
  attr_writer :price
  # frequenza di rifornimento merce
  attr_accessor :replenishment_rate
  # frequenza di esaurimento merce
  attr_accessor :deplenishment_rate

  # inizializza l'oggetto posseduto dal negozio.
  # @param [RPG::Shop_Article] details
  # @param [Integer] quantity
  def initialize(details, quantity = nil)
    @quantity = quantity || details.max_quantity
    @item_id = details.item_id
    @item_type = details.item_type
    @sale_value = 0
    @sales_off = details.deny_sales || false
    @sell_locked = details.sell_locked || false
    @replenishment_rate = details.repl_rate
    @rpg_article = details
  end

  # restituisce l'oggetto
  # @return [RPG::Item,RPG::Weapon,RPG::Armor]
  def item
    case @item_type
    when 1
      $data_items[@item_id]
    when 2
      $data_weapons[@item_id]
    when 3
      $data_armors[@item_id]
    else
      nil
    end
  end

  # @return [RPG::Shop_Article]
  def base_article
    @rpg_article
  end

  # imposta la quantità dell'articolo assicurandosi
  # di essere tra 0 e 99 e non sia illimitato
  # @param [Integer] value
  def quantity=(value)
    return if unlimited?
    @quantity = [[0, value].max, 99].min
  end

  # imposta la quantità dell'articolo, anche se
  # è illimitato.
  # @param [Integer,Hash] value
  def set_quantity(value)
    if value == :unlimited
      @quantity = -1
    else
      @quantity = value
    end
  end

  # determina se l'oggetto può essere acquistato un numero infinito di
  #   volte.
  def unlimited?
    self.quantity == -1
  end

  # imposta uno sconto
  def set_sale(value)
    @sale_value = value
  end

  # rimuove lo sconto
  def remove_sale
    @sale_value = 0
  end

  # determina se è un oggetto che non può essere cancellato dal gioco.
  def rare?
    item.rarity > 1 or item.powered?
  end

  def deny_sales?
    @sales_off
  end

  # determina se l'oggetto è in offerta
  def in_sale?
    @sale_value > 0
  end

  # determina se l'articolo può sparire dall'assortimento
  # @return [Boolean]
  def sell_locked?
    @sell_locked
  end

  # restituisce il costo dell'articolo non scontato
  # @return [Integer]
  def original_price
    @price || item.price
  end

  # restituisce il prezzo tenendo conto di eventuali
  # sconti
  def price
    (original_price * (1 - discount_rate)).to_i
  end

  # @return [Float]
  def discount_rate
    @sale_value / 100.0
  end

  # @return [String]
  def to_s
    sprintf('Shop_Good ID:%d,type:%d', @item_id, @item_type)
  end
end

#==============================================================================
# ** Game_RebuyData
# rappresenta il singolo articolo di una lista di oggetti che il giocatore ha
# appena venduto al negoziante, e che può riacquistare.
#==============================================================================
class Game_RebuyData
  attr_reader :item_id
  attr_reader :item_type
  attr_reader :number

  def initialize(item_id, item_type, number)
    @number = number
    @item_id = item_id
    @item_type = item_type
  end

  def number=(value)
    @number = [[0, value].max, 99].min
  end

  # restituisce l'oggetto
  # @return [RPG::Item,RPG::Weapon,RPG::Armor]
  def item
    case @item_type
    when 1
      $data_items[@item_id]
    when 2
      $data_weapons[@item_id]
    when 3
      $data_armors[@item_id]
    else
      nil
    end
  end
end

#==============================================================================
# ** Game_Shops
# contiene le istanze di Game_Shop. Nel caso un negozio non sia mai stato
# visitato, lo crea al momento da RPG::Shop e lo aggiunge all'array. Questa
# classe viene dumpata nel file di salvataggio.
#==============================================================================
class Game_Shops
  # inizializzazione
  def initialize
    @data = {}
    @timing = initial_timing
  end

  def initial_timing
    ShopsSettings::SUPPLY_UPDATE_TIMING * 3600
  end

  def update_shop_status
    return if in_no_update_map?
    @timing -= in_fast_update_map? ? 2 : 1
    if @timing <= 0
      advance_shops(true)
    end
  end

  def in_fast_update_map?
    $game_map.timeless_map?
  end

  def in_no_update_map?
    $game_map.fast_update_map?
  end

  # ottiene il negozio
  # @param [Symbol] shop_id
  # @return [Game_Shop]
  def [](shop_id)
    if @data[shop_id] == nil and $data_shops[shop_id] != nil
      @data[shop_id] = Game_Shop.new(shop_id)
    end
    @data[shop_id]
  end

  # avanza temporalmente tutti i negozi simulando rifornimenti ed
  # acquisti.
  # @param [Boolean] include_sales
  def advance_shops(include_sales = false)
    @timing = initial_timing
    @data.each_value{ |shop| shop.update_shop(include_sales) }
  end

  # restituisce il flusso di oggetti speciali che sono stati
  # venduti ai negozi (equip rari/leggendari, equip potenziati
  # e incantati...)
  # @return [Array<Array>]
  def trade_flow
    @trade_flow ||= []
  end

  # aggiunge l'oggetto al flusso di compravendita
  # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
  def add_on_trade_flow(item, number = 1)
    @trade_flow ||= []
    case item
    when RPG::Item
      type = 1
    when RPG::Weapon
      type = 2
    when RPG::Armor
      type = 3
    else
      type = 0
    end
    ary = [item.id, type, number]
    @trade_flow.add(ary) # unless @trade_flow.include?(ary)
  end

  # ottiene oggetti a caso dal trade flow come array di info
  # ([item_id, item_type, number])
  # salta le categorie non gestite dal negozio
  # @return [Array<Array>]
  # @param [Array<Symbol>] categories
  def generate_random_trade_items(bonus_rate = 0, categories = [])
    rate = ShopsSettings::TRADE_REFLOW_RATE + bonus_rate
    items = []
    trade_flow.each { |ary|
      next if ary[1] == 1 and !categories.include?(:items)
      next if ary[1] == 2 and !categories.include?(:weapons)
      next if ary[1] == 3 and !categories.include?(:armors)
      if rand(100) <= rate
        arx = [ary[0], ary[1], 1]
        items.push(arx)
        ary[2] -= 1
        trade_flow.delete(ary) if ary[2] <= 0
      end
    }
    items
  end
end

#==============================================================================
# ** Game_Shop
# rappresenta il negozio fisico memorizzato nel salvataggio.
#==============================================================================
class Game_Shop

  # Variabili d'istanza pubbliche
  attr_reader :shop_id
  # @return [Array<Game_RebuyData>]
  attr_reader :rebuy_articles
  # @return [Float]
  attr_accessor :fidelity_points

  # inizializzazione
  # @param [Symbol] shop_id
  def initialize(shop_id)
    @shop_id = shop_id
    create_starting_articles
    @denied_sales = [{}, {}, {}]
    @spawn_rates = [{}, {}, {}]
    @denied_sells = [{}, {}, {}]
    @custom_articles = []
    @rebuy_articles = []
    @buy_discount = nil
    @fidelity_points = 0
    update_shop if ShopsSettings::UPDATE_ON_STARTUP
    apply_random_sales if has_discounts?
  end

  # @return [Array<Shop_Article>]
  def create_starting_articles
    rpg_articles = rpg_shop.initial_articles
    @articles = rpg_articles.map { |article| Shop_Article.new(article) }
  end

  # restituisce le impostazioni del negozio configurate
  # @return [RPG::Shop]
  def rpg_shop
    $data_shops[@shop_id]
  end

  # restituisce il nome del negozio
  def name
    rpg_shop.name
  end

  # restituisce il rapporto tra il prezzo articolo
  # ed i punti fedeltà ottenuti
  def fidelity_rate
    rpg_shop.fidelity_rate
  end

  # il livello di fedeltà del negozio
  def fidelity_level
    points = ShopsSettings::FIDELITY_LEVELS
    points.keys.sort.reverse.each do |key|
      return key + 1 if points[key] <= @fidelity_points
    end
    1
  end

  # determina il bonus agli sconti a seconda del
  # livello di fedeltà del negozio
  def fidelity_level_bonus
    ShopsSettings::FIDELITY_BONUS[fidelity_level] || 0
  end

  # applica punti fedeltà sull'acquisto di un bene
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @param [Boolean] sell se true, è per la vendita
  # @param [Integer] item_number
  def apply_fidelity(item, item_number = 1, sell = false)
    multiplier = fidelity_rate * item_number
    points = sell ? item_sell_price(item) : item_price(item)
    @fidelity_points += points * multiplier
  end

  # rimuove gli articoli che non rispettano più le condizioni (tipo, già presente un oggetto dello stesso tipo)
  def remove_forbidden_articles
    articles.each { |article| deplenish_article(article, :all) unless article.base_article.conditions_met? }
  end

  # determina se il giocatore può vendergli oggetti
  def permit_sell?
    rpg_shop.permit_sell
  end

  # determina se il giocatore può comprare oggeti
  def permit_buy?
    rpg_shop.permit_buy
  end

  # determina se il negozio offre saldi
  def has_discounts?
    rpg_shop.permit_sales
  end

  # restituisce i beni del negozio
  # @return [Array<Shop_Article>]
  def articles
    @articles
  end

  def sellable_articles
    articles.select { |article| article.quantity > 0 || article.unlimited?}
  end

  # ottiene lo sconto sull'acquisto di beni
  def buy_discount
    @buy_discount || rpg_shop.buy_discount
  end

  # imposta uno sconto personalizzato per il negozio
  def buy_discount=(new_discount)
    @buy_discount = new_discount
  end

  # ottiene il bonus sulla vendita di beni
  def sell_bonus
    rpg_shop.sell_bonus
  end

  # restituisce la probabilità di far sparire i beni dal negozio quando
  #   lontano per un certo periodo di tempo
  def depletion_rate
    rpg_shop.depletion_rate
  end

  # restituisce la probabilità di far rifornire il negozio quando lontano
  #   per un certo periodo di tempo
  # @return [Integer,Float]
  def supply_rate
    rpg_shop.supply_rate
  end

  def sales_rate_bonus
    rpg_shop.sales_rate_bonus
  end

  # le categorie gestite dal negozio
  # @return [Array<Symbol>]
  def categories
    rpg_shop.handled_categories
  end

  def handle_items?
    categories.include? :items
  end

  def handle_weapons?
    categories.include? :weapons
  end

  def handle_armors?
    categories.include? :armors
  end

  # restituisce il costo del bene.
  # @param [Shop_Article] article
  # @param [Boolean] include_sale
  def article_price(article, include_sale = false)
    discount = 1.0
    discount -= $game_party.shop_discount
    discount -= buy_discount
    discount -= article.discount_rate if include_sale
    (article.original_price * discount).to_i
  end

  # ottiene il costo dell'oggetto
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @param [Boolean] include_sale
  def item_price(item, include_sale = false)
    article_price(article_from_item(item), include_sale)
  end

  # definisce il prezzo di rivendita dell'oggetto
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def item_sell_price(item)
    bonus = 1.0
    bonus += sell_bonus
    bonus += $game_party.sell_bonus
    (item.selling_price * bonus).to_i
  end

  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def item_discount(item)
    article = article_from_item(item)
    article ? article.sale_value : 0
  end

  # determina se l'oggetto è in saldo
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def item_in_sale?(item)
    item_discount(item) > 0
  end

  # restituisce il bene dall'oggetto
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @return [Shop_Article]
  def article_from_item(item)
    articles.select{ |article| article.item.equal?(item) }.first
  end

  # restituisce il numero di oggetti posseduti dal negozio
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @return [Integer]
  def item_number(item)
    article = article_from_item(item)
    article ? article.quantity : 0
  end

  # determina se l'oggetto è senza scorte
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def sold_out?(item)
    item_number(item) == 0
  end

  # @param [Shop_Article] article
  def sale_rate(article)
    article.sale_value
  end

  # aggiorna l'inventario del negozio
  def update_shop(update_sales = true)
    deplenish_articles
    replenish_articles
    add_trade_flow_articles
    flush_rebuy_items
    apply_random_sales if update_sales
  end

  # aggiunge scorte a caso nel negozio
  def replenish_articles
    rarticles = rpg_shop.random_articles + @custom_articles
    rarticles.each { |rpg_article| valuate_add_article(rpg_article) }
  end

  # rimuove scorte a caso nel negozio
  def deplenish_articles
    articles.each { |article| valuate_sell_article(article) }
  end

  # aggiungi oggetti random dal riciclo di oggetti rari
  def add_trade_flow_articles
    trade_items = $game_shops.generate_random_trade_items(supply_rate, categories)
    trade_items.each { |ary|
      article = RPG::Shop_Article.new({:type => ary[1], :id => ary[0]})
      add_article(article)
    }
  end

  # aggiunge saldi a caso tra gli articoli
  def apply_random_sales
    return unless has_discounts?
    articles.select { |a| !a.deny_sales?}.each { |a| a.set_sale(generate_random_sale)}
  end

  # assegna a caso dei saldi.
  # @return [Integer]
  def generate_random_sale
    s_types = ShopsSettings::DISCOUNT_TYPES
    sales = [0]
    bonus = fidelity_level_bonus / 100.0 + 1
    bonus += sales_rate_bonus
    s_types.each_pair { |key, value|
      sales.push(key) if value * bonus >= rand(100)
    }
    sales.max
  end

  # determina tramite un calcolo casuale quali oggetti rimuovere dal
  # negozio, per simulare gente che acquista ed esaurisce le scorte.
  # @param [Shop_Article] article
  def valuate_sell_article(article)
    return if article.unlimited?
    return if article.sell_locked?
    (0..article.quantity - 1).each {
      if rand(100) < depletion_rate
        deplenish_article(article)
        if article.rare?
          $game_shops.add_on_trade_flow(article.item)
        end
      end
    }
  end

  # determina se la rivendita dell'oggetto dal negozio è permessa
  # @param [Shop_Article] article
  def sell_denied?(article)
    if @denied_sells[article.item_type - 1][article.item_id] != nil
      return @denied_sells[article.item_type - 1][article.item_id]
    end
    if rpg_shop.denied_sells[article.item_type - 1][article.item_id] != nil
      return rpg_shop.denied_sells[article.item_type - 1][article.item_id]
    end
    false
  end

  # determina tramite un calcolo casuale quali oggetti aggiungere dalla
  # lista degli oggetti random, per simulare i rifornimenti di scorte.
  # non rifornisce oltre la soglia max_quantity dell'articolo
  # @param [RPG::Shop_Article] article
  def valuate_add_article(article)
    return unless article.conditions_met?
    i_num = item_number(article.item)
    return if i_num >= article.max_quantity
    max_n = article.max_quantity - i_num
    max_n.times do
      add_article(article, 1) if rand(100) < supply_rate * article.repl_rate
    end
  end

  # consuma un oggetto. Non fa nulla se è illimitato.
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @param [Integer] number
  def deplenish_item(item, number = 1)
    article = article_from_item item
    deplenish_article article, number
  end

  # rimuove un bene dal negozio. Se il bene è illimitato, non fa nulla a
  # meno che non si definisca :all come numero, così li rimuoverà tutti.
  # @param [Shop_Article] article
  # @param [Integer, Symbol] item_number numero da rimuovere. :all se tutti
  def deplenish_article(article, item_number = 1)
    return false if article.nil?
    return false if article.unlimited? and item_number != :all
    if item_number == :all
      article.set_quantity 0
    else
      article.quantity -= item_number
    end
  end

  # aggiunge i dati di un articolo RPG al negozio. Aumenta solo
  # la quantità se presente.
  # @param [RPG::Shop_Article] article
  def add_article(article, quantity = nil)
    in_article = article_from_item(article.item)
    if in_article
      return if in_article.unlimited?
      in_article.quantity = [in_article.quantity + (quantity || article.quantity), 99].min
      in_article.price = article.price if article.price
      in_article.replenishment_rate = article.repl_rate if article.repl_rate
    else
      @articles.push(Shop_Article.new(article))
    end
  end

  # aggiunge un oggetto al negozio.
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @param [Integer] item_number :unlimited se illimitato
  # @param [Integer] price
  # @param [Boolean] can_disappear
  def add_item(item, item_number = 1, price = nil, can_disappear = false)
    add_article(rpg_article_from item, item_number, price, can_disappear)
  end

  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @return [Game_RebuyData]
  def rebuy_article(item)
    @rebuy_articles.select { |a| a.item == item}.first
  end

  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @param [Integer] quantity
  def add_rebuy_item(item, quantity)
    data = Game_RebuyData.new(item.id, item_type_id(item), quantity)
    return transfer_to_shop(data) unless Shop_Core::rebuy_active?
    present = @rebuy_articles.select { |a| a.item == item}.first
    if present
      present.number += quantity
    else
      @rebuy_articles.push(data)
    end
  end

  def regain_rebuy_item(item, quantity)
    present = @rebuy_articles.select { |a| a.item == item}.first
    return unless present
    present.number -= quantity
    @rebuy_articles.delete(present) if present.number == 0
  end

  def flush_rebuy_items
    return if @rebuy_articles.empty?
    @rebuy_articles.each { |article| transfer_to_shop article }
    @rebuy_articles.clear
  end

  # @param [Game_RebuyData] data
  def transfer_to_shop(data)
    apply_fidelity(data.item, data.number, true)
    return unless ShopsSettings::RESELLS
    return add_item(data.item, data.number) if data.item_type == 1 and handle_items?
    return add_item(data.item, data.number) if data.item_type == 2 and handle_weapons?
    return add_item(data.item, data.number) if data.item_type == 3 and handle_armors?
    if data.item.rarity > 1 and data.item.powered?
      $game_shops.add_on_trade_flow(data.item, data.number)
    end
  end

  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @param [Integer] item_number
  # @param [Integer] price
  # @param [Boolean] can_disappear
  def rpg_article_from(item, item_number = 1, price = nil, can_disappear = false)
    item_number = -1 if item_number == :unlimited
    hash = {:type => item_type_id(item), :id => item.id,
            :quantity => item_number, :price => price,
            :sell_locked => can_disappear}
    RPG::Shop_Article.new(hash)
  end

  # restituisce il tipo dell'oggetto come intero
  # 1: item, 2: arma, 3: armatura
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  def item_type_id(item)
    case item
    when RPG::Item
      return 1
    when RPG::Weapon
      return 2
    when RPG::Armor
      return 3
    else
      return 0
    end
  end

  # aggiunge un bene agli oggetti che possono comparire casualmente nel
  # negozio. Va inserito l'hash dell'oggetto come nella configurazione
  # del negozio
  # @param [Hash] data
  def add_random_article(data)
    rpg_article = RPG::Shop_Article.new(data)
    shop_article = Shop_Article.new(rpg_article)
    @custom_articles.push(shop_article)
  end

  # azzera tutti i beni personalizzati che possono comparire
  def clear_random_articles
    @custom_articles = []
  end
end