#==============================================================================
# *----
#
#==============================================================================
module ShopsSettings

  # impostazioni generiche
  DISCOUNTS = true
  # tipi di sconti, definiti in questo modo:
  # %SCONTO => %PROBAB. Esempio
  # 10 => 8: 8% di probabilità di applicare uno sconto del 10%
  DISCOUNT_TYPES = {10 => 8, 15 => 6, 20 => 4, 25 => 2}
  RESELLS = true
  # numero di battaglie necessario ad aggiornare gli shop
  BATTLES_TO_UPDATE = 3
  # simbolo dell'infinito
  ENDLESS = '∞'
  TRADE_REFLOW_RATE = 5

  DEFAULT_SUPPLY_RATE = 10
  DEFAULT_WASTE_RATE = 8

  PARAMS_WIDTH = 48 # larghezza dei parametri sul confronto equip
  WEAPON_COMPARE = [:atk, :spi, :hit, :cri, :mhp, :mmp, :odds, :agi, :def, :eva, :res]
  SHIELD_COMPARE = [:def, :eva, :res, :mhp, :mmp, :agi, :spi, :atk, :odds, :hit, :cri]
  HELMET_COMPARE = [:def, :eva, :res, :mhp, :mmp, :agi, :spi, :atk, :odds, :hit, :cri]
  ARMOR__COMPARE = [:def, :eva, :res, :mhp, :mmp, :agi, :spi, :atk, :odds, :hit, :cri]
  ACCESS_COMPARE = [:mhp, :mmp, :agi, :spi, :def, :res, :odds, :hit, :cri, :eva, :atk]

  SHOP_REBUY = 'Ricompra'
  ITEM_SELECT = 'Seleziona'
  ITEM_BUY = 'Compra'
  ITEM_SELL = 'Vendi'
  CHANGE_VIEW = 'Cambia vista'
  BUY_ALL = 'Compra tutto'
  SELL_ALL = 'Vendi tutto'
  TOTAL = 'Totale:'
  IN_SALE = 'In sconto del %d%%'
  ALREADY_EQUIPPED = 'Equipaggiato'
  LEVEL_TOO_LOW = 'Livello basso!'

  # definizione dei negozi
  # ISTRUZIONI
  # Inserire nell'hash un nuovo negozio con un simbolo identificativo ed i
  # seguenti parametri:
  # name: nome del negozio
  # goods: beni iniziali del negozio (quelli che ha la prima volta che ci vai)
  # random_goods: beni che possono comparire a caso dopo un po'
  # sia i goods che random goods sono degli array di hash. I goods possono
  # avere i seguenti parametri:
  # id: ID dell'oggetto type: tipo (1: item, 2: arma, 3: armatura)
  # max: (facoltativo) numero di oggetti massimi posseduti dal negozio. Se
  # questo parametro è mancante, gli oggetti sono infiniti.
  # sell_price: (facoltativo) se presente, il prezzo dell'articolo viene
  # sostituito da quello definito dal parametro.
  # sell_locked: (facoltativo) se true, impedisce agli articoli di scomparire
  # nel tempo perché acquistati da qualcun altro. Non si applica agli articoli
  # infiniti.
  # deny_sales: (facoltativo) se true, l'articolo non può essere messo in saldo
  # repl_rate: modifica la probabilità di far comparire l'oggetto (solo nei
  # random goods). Valore da 0 a 100
  # In alternativa, puoi definire l'oggetto da vendere così:
  # set: 'TIPOIDxQUANTITA'
  # TIPO è il tipo dell'oggetto (i: item, w: arma, a: armatura), poi l'ID e
  # facoltativamente anche la quantità massima.
  # esempio: 'i10x5' -> il negozio vende 5 item con ID 10
  # esempio: 'w1' -> l'oggetto vende l'arma con ID 1 (illimitate)
  # La differenza tra goods e random_goods è l'elenco degli oggetti disponibili
  # la prima volta che si visita il negozio. Gli oggetti limitati NON torneranno.
  # Nell'elenco random_goods invece potrebbero comparire casualmente dopo un po'.
  # Inoltre, max_quantity assume due significati diversi: nei goods indica il
  # numero iniziale di quell'oggetto, in random_goods il numero massimo oltre
  # il quale l'oggetto non viene rifornito (cioè, se il negozio ha già 5 pozioni
  # che è il numero massimo, non può aumentare ulteriormente)
  SHOPS = {
      :bad_items => {
          :name => 'Emporio di Baduelle',
          :goods => [
              {:set => 'i1'},
              {:set => 'i5x20'},
              {:set => 'i6'},
              {:set => 'i107x1', :sell_locked => false},
              {:set => 'i153x1', :sell_locked => false},
          ],
          :random_goods => [
              {:set => 'i5x10'},
              {:set => 'i107x1', :sell_locked => false, :repl_rate => 200},
              {:set => 'i153x1', :sell_locked => false, :repl_rate => 200},
              {:set => 'i21x1'},
              {:set => 'i22x2'},
          ]
      },
      :bad_equips => {
          :name => 'Equipaggiamenti di Baduelle',
          :goods => [
              {:set => 'w6x5'}, {:set => 'w21x8'}, {:set => 'w27x2'},
              {:set => 'w50x1'}, {:set => 'w100x1'}, {:set => 'w70x2'},
              {:set => 'a2x3'}, {:set => 'a22x15'}, {:set => 'a62x2'},
              {:set => 'a63x2'}
          ],
          :random_goods => [
              {:set => 'w6x5'}, {:set => 'w21x8'}, {:set => 'w27x2'},
              {:set => 'w50x1'}, {:set => 'w100x1'}, {:set => 'w70x2'},
              {:set => 'a2x3'}, {:set => 'a22x15'}, {:set => 'a62x2'},
              {:set => 'a63x2'}
          ]
      },
      :sir_arm => {
          :name => 'Negozio di protezioni di Sirenas',
          :goods => [
              {:set => 'a2x5'}, {:set => 'a3x2'}, {:set => 'a22x20'},
              {:set => 'a23x10'}, {:set => 'a62x2'}, {:set => 'a63x4'},
              {:set => 'a64x2'},
          ],
          :random_goods => [
              {:set => 'a2x10'}, {:set => 'a3x8'}, {:set => 'a22x20'},
              {:set => 'a23x20'}, {:set => 'a62x8'}, {:set => 'a63x8'},
              {:set => 'a64x10'},
          ]
      },
      :sir_weap => {
          :goods => [
              {:set => 'w6x10'}, {:set => 'w7x1'},
              {:set => 'w21x8'}, {:set => 'w27x2'},
              {:set => 'w50x1'}, {:set => 'w100x1'}, {:set => 'w71x1'},
              {:set => 'w150x1'}
          ],
          :random_goods => [
              {:set => 'w6x80'}, {:set => 'w7x25'},
              {:set => 'w21x90'}, {:set => 'w27x30'},
              {:set => 'w50x30'}, {:set => 'w100x30'}, {:set => 'w71x30'},
              {:set => 'w150x30'}, {:set => 'w78x1', :repl_rate => 20}
          ]
      },
      :sir_items => {
          :name => 'Negozio di oggetti di Sirenas',
          :goods => [
              {:set => 'i1'},
              {:set => 'i5'},
              {:set => 'i6'}, {:set => 'i7x10'},
              {:set => 'i107x1', :sell_locked => false},
              {:set => 'i153x1', :sell_locked => false},
              {:set => 'i21x1'}
          ],
          :random_goods => [
              {:set => 'i7x15'},
              {:set => 'i107x1', :sell_locked => false, :repl_rate => 200},
              {:set => 'i153x1', :sell_locked => false, :repl_rate => 200},
              {:set => 'i21x1'},
              {:set => 'i22x2'},
          ]
      },
      :sir_mag => {
          :name => 'Emporio magico di Sirenas',
          :goods => [
              {:set => 'i4x1'},
              {:set => 'i21x5'},
              {:set => 'w100x3'},
              {:set => 'w102x1'},
              {:set => 'a62x3'},
          ],
          :random_goods => [
              {:set => 'i4x1', :repl_rate => 50},
              {:set => 'i21x20'},
              {:set => 'w100x30'},
              {:set => 'w102x10'},
              {:set => 'a62x3'},
              {:set => 'i45x2'},
              {:set => 'i10x1', :repl_rate => 10},
              {:set => 'i138x1', :repl_rate => 10},
              {:set => 'i29x1', :repl_rate => 30},
              {:set => 'a121x1'},
              {:set => 'a122x1'},
              {:set => 'a124x1', :repl_rate => 50},
          ]
      }
  }
end

module DataManager
  class << self
    alias h87_shop_load_normal_database load_normal_database
  end

  def self.load_normal_database
    h87_shop_load_normal_database
    $data_shops = Shop_Core.init_shops
  end
end

#==============================================================================
# ** Shop_Stat
# modulo integrato in equip e status per modificare sconti e vendite
#==============================================================================
module Shop_Stats
  DISCOUNT_REGEXP = /<sconti negozio:[ ]*([+\-]\d+)([%％])>/i
  BONUS_REGEXP = /<bonus vendite:[ ]*([+\-]\d+)([%％])/i
  attr_reader :buy_discount
  attr_reader :sell_bonus

  # inizializza le statistiche
  def init_shop_stats
    return if @shop_stats_init
    @shop_stats_init = true
    @buy_discount = 0
    @sell_bonus = 0
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when DISCOUNT_REGEXP
        @buy_discount = $1.to_f / 100.0
      when BONUS_REGEXP
        @sell_bonus = $1.to_f / 100.0
      else
        # niente
      end
    }
  end
end

#==============================================================================
# *----
#
#==============================================================================
module Shop_Core
  ITEM_REGEXP = /([iwa])(\d+)(x(\d+))?/i

  # determina se "riacquista è disponibile"
  def self.rebuy_active?
    false
  end

  def self.init_shops
    ShopsSettings::SHOPS.collect {|shop_info| RPG::Shop.new(shop_info)}
  end
end

module Vocab
  def self.shop_rebuy
    ShopsSettings::SHOP_REBUY
  end

  def self.key_buy
    ShopsSettings::ITEM_BUY
  end

  def self.key_sell
    ShopsSettings::ITEM_SELL
  end

  def self.key_a_buy
    ShopsSettings::BUY_ALL
  end

  def self.key_a_sell
    ShopsSettings::SELL_ALL
  end

  def self.key_change_view
    ShopsSettings::CHANGE_VIEW
  end

  def self.shop_select
    ShopsSettings::ITEM_SELECT
  end

  def self.shop_total
    ShopsSettings::TOTAL
  end

  def self.in_sale
    ShopsSettings::IN_SALE
  end

  def self.already_equipped
    ShopsSettings::ALREADY_EQUIPPED
  end

  def self.level_too_low
    ShopsSettings::LEVEL_TOO_LOW
  end
end

#==============================================================================
# Inclusione degli shop stat negli oggetti
#==============================================================================
class RPG::Status
  include Shop_Stats
end
class RPG::Armor
  include Shop_Stats
end
class RPG::Weapon
  include Shop_Stats
end

#==============================================================================
# ** sho----
# È una classe che contiene le informazioni statiche (definite nei settaggi)
# dei negozi Game_Shop.
#==============================================================================
class RPG::Shop

  # Variabili d'istanza pubbliche
  # @return [String] name
  attr_reader :name #nome del negozio
  # @return [Array<RPG::Good_Details>] initial_goods
  attr_reader :initial_goods #oggetti iniziali del negozio
  # @return [Array<RPG::Good_Details>] random_goods
  attr_reader :random_goods #oggetti che possono apparire nel negozio
  attr_reader :permit_sell #permetti il comando vendi
  attr_reader :permit_buy #permetti il comando compra
  attr_reader :permit_sales #permetti di mettere dei saldi
  attr_reader :sales_rate_bonus #bonus probabilità saldi
  attr_reader :sell_bonus #bonus guadagno vendita
  attr_reader :buy_discount #sconto su acquisti
  attr_reader :supply_rate #prob di rifornimento
  attr_reader :waste_rate #prob di scaricamento
  # @return [Array<Hash>] denied_sales
  attr_reader :denied_sales #oggetti che hanno gli sconti vietati
  # @return [Array<Hash>] custom_prices
  attr_reader :custom_prices #prezzi personalizzati degli oggetti
  # @return [Array<Hash>] spawn_rates
  attr_reader :spawn_rates #probabilità di comparsa
  # @return [Array<Hash>] denied_sells
  attr_reader :denied_sells #gli oggetti che non possono scomparire dal negozio
  # @return [Array<RPG::Shop_Good>]
  #

  # inizializzazione
  # @param [Hash] hash_info
  def initialize(hash_info)
    @name = hash_info[:name] ||= ''
    @permit_sell = hash_info[:can_sell] ||= true
    @permit_buy = hash_info[:can_buy] ||= true
    @permit_sales = hash_info[:sales] ||= ShopsSettings::DISCOUNTS
    @sell_bonus = hash_info[:sell_bonus] / 100.0 ||= 0
    @sales_rate_bonus = hash_info[:sale_bonus] ||= 0
    @buy_discount = hash_info[:buy_discount] ||= 0
    @denied_sales = [{}, {}, {}]
    @custom_prices = [{}, {}, {}]
    @spawn_rates = [{}, {}, {}]
    @denied_sells = [{}, {}, {}]
    @rebuy_goods = []
    @initial_goods = process_goods(hash_info[:goods]) ||= []
    @random_goods = process_goods(hash_info[:random_goods]) ||= []
    @supply_rate = hash_info[:supply_rate] ||= ShopsSettings::DEFAULT_SUPPLY_RATE
    @waste_rate = hash_info[:waste_rate] ||= ShopsSettings::DEFAULT_WASTE_RATE
  end

  # processa l'hash degli oggetti
  # @param [Array<Hash>] goods_hash
  # @return [Array<RPG::Good_Details>]
  def process_goods(goods_hash)
    ret = []
    goods_hash.each { |good_detail| ret.push(process_good(good_detail)) }
    ret
  end

  # gets the item type
  # @param [RPG::BaseItem] item
  def item_type(item)
    case item.class
    when RPG::Item
      1
    when RPG::Weapon
      2
    when RPG::Armor
      3
    else
      0
    end
  end

  # processa la descrizione
  # @param [Hash] good_detail
  def process_good(good_detail)
    good = RPG::Good_Details.new(good_detail)
    @custom_prices[good.item_type - 1][good.item_id] = good.sell_price if good.sell_price
    @denied_sales[good.item_type - 1][good.item_id] = good.deny_sales if good.deny_sales
    @denied_sells[good.item_type - 1][good.item_id] = good.sell_locked if good.sell_locked
    @spawn_rates[good.item_type - 1][good.item_id] = good.repl_rate
    good
  end
end

#==============================================================================
# ** Good_Detail----
# rappresenta i dettagli dei beni da inserire nel negozio. Sono definiti nelle
# impostazioni e sono immutabili durante la partita. Vengono utilizzati in
# Game_Shop e come inizializzatori di RPG::Shop_Good.
#==============================================================================
class RPG::Good_Details
  attr_reader :item_type # tipo oggetto
  attr_reader :item_id # ID oggetto
  attr_reader :max_quantity # quantità oggetto MASSIMA
  attr_reader :repl_rate # rarità oggetto (quanto spesso viene messo)
  attr_reader :sell_price # prezzo di vendita
  attr_reader :sell_locked # blocca la rivendita
  attr_reader :deny_sales # blocca saldi per quest'oggetto

  # inizializzazione
  # @param [Hash] hash_info
  def initialize(hash_info)
    if hash_info[:set] and hash_info[:set] =~ Shop_Core::ITEM_REGEXP
      @item_type = get_item_type($1)
      @item_id = $2.to_i
      @max_quantity = $3 != nil ? $4.to_i : -1
    else
      @item_type = hash_info[:type]
      @item_id = hash_info[:id]
      @max_quantity = hash_info[:quantity] || hash_info[:max] ||= -1
    end
    @repl_rate = hash_info[:repl_rate] / 100.0 ||= 1.0
    @sell_price = hash_info[:price] ||= item.price
    @sell_locked = hash_info[:sell_locked] ||= false
    @deny_sales = hash_info[:no_sales] ||= false
  end

  # restituisce l'oggetto reale del database
  # @return [RPG::Item]
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

  # determina se è un oggetto con quantità illimitate
  def unlimited?
    self.quantity == -1
  end

  # restituisce il numero del tipo oggetto dalla stringa
  # noinspection RubyStringKeysInHashInspection
  def get_item_type(char)
     {'i' => 1, 'w' => 2, 'a' => 3}[char]
  end
end

#==============================================================================
# ** RPG::Shop_Good
# rappresenta un bene posseduto da Game_Shop. Contiene item, quantità e sconti.
#==============================================================================
class RPG::Shop_Good
  attr_reader :item_type # tipo oggetto
  attr_reader :item_id # id oggetto
  attr_accessor :quantity # quantità degli oggetti
  attr_accessor :sale_value # valore di saldi

  # inizializza l'oggetto posseduto dal negozio.
  # @param [RPG::Good_Details] details
  # @param [Integer] quantity
  def initialize(details, quantity)
    @quantity = quantity
    @item_id = details.item_id
    @item_type = details.item_type
    @sale_value = 0
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

  # determina se l'oggetto è in offerta
  def in_sale?
    @sale_value > 0
  end

  # restituisce il costo dell'oggetto
  def cost
    item.price
  end
end

#==============================================================================
# ** Game_Shop
# rappresenta il negozio fisico memorizzato nel salvataggio.
#==============================================================================
class Game_Shop

  # Variabili d'istanza pubbliche
  attr_reader :shop_id

  # inizializzazione
  # @param [Symbol] shop_id
  def initialize(shop_id)
    @shop_id = shop_id
    @goods = db_shop.initial_goods
    @discounts = [{}, {}, {}]
    @denied_sales = [{}, {}, {}]
    @custom_prices = [{}, {}, {}]
    @spawn_rates = [{}, {}, {}]
    @denied_sells = [{}, {}, {}]
    @custom_goods = []
    @rebuy_goods = []
  end

  # restituisce le impostazioni del negozio configurate
  # @return [RPG::Shop]
  def db_shop
    $game_temp.custom_shops[@shop_id]
  end

  # restituisce il nome del negozio
  def name
    db_shop.name
  end

  # determina se il giocatore può vendergli oggetti
  def permit_sell?
    db_shop.permit_sell
  end

  # determina se il giocatore può comprare oggeti
  def permit_buy?
    db_shop.permit_buy
  end

  # determina se il negozio offre saldi
  def has_discounts?
    db_shop.permit_sales
  end

  # restituisce i beni del negozio
  # @return [Array<RPG::Shop_Good>]
  def goods
    @goods
  end

  # ottiene lo sconto sull'acquisto di beni
  def buy_discount
    db_shop.buy_discount
  end

  # ottiene il bonus sulla vendita di beni
  def sell_bonus
    db_shop.sell_bonus
  end

  # restituisce la probabilità di far sparire i beni dal negozio quando
  #   lontano per un certo periodo di tempo
  def waste_rate
    db_shop.waste_rate
  end

  # restituisce la probabilità di far rifornire il negozio quando lontano
  #   per un certo periodo di tempo
  def supply_rate
    db_shop.supply_rate
  end

  # restituisce il costo dell'oggetto.
  # @param [RPG::Shop_Good] good
  # @param [Boolean] include_sale
  def good_cost(good, include_sale = false)
    discount = 1.0
    discount -= $game_party.shop_discount
    discount -= buy_discount
    discount -= good_discount(good) if include_sale
    (good_price(good) * discount).to_i
  end

  # ottiene il costo dell'oggetto
  # @param [RPG::Item] item
  # @param [Boolean] include_sale
  def item_cost(item, include_sale = false)
    good_cost(find_good(item), include_sale)
  end

  # definisce il prezzo di rivendita dell'oggetto
  # @param [RPG::Item] item
  def item_sell_cost(item)
    bonus = 1.0
    bonus += sell_bonus
    bonus += $game_party.sell_bonus
    (item.selling_price * bonus).to_i
  end

  # determina lo sconto in percentuale dell'oggetto
  # @param [RPG::Shop_Good] good
  def good_discount(good)
    sale = @discounts[good.item_type - 1][good.item_id]
    sale ? sale / 100.0 : 0.0
  end

  # restituisce il prezzo dell'item
  # @param [RPG::Shop_Good] good
  def good_price(good)
    if @custom_prices[good.item_type - 1][good.item_id] != nil
      return @custom_prices[good.item_type - 1][good.item_id]
    end
    if db_shop.custom_prices[good.item_type - 1][good.item_id] != nil
      return db_shop.custom_prices[good.item_type - 1][good.item_id]
    end
    good.item.price
  end

  # restituisce il prezzo dell'item
  # @param [RPG::Item] item
  def item_price(item)
     good_price(find_good(item))
  end

  # restituisce il numero di oggetti posseduti dal negozio
  # @param [RPG::Item] item
  def item_number(item)
    goods.each { |good| return good.quantity if item == good.item }
  end

  # @param [RPG::Shop_Good] good
  def sale_rate(good)

  end

  # restituisce l'array degli sconti
  # @return [Array<Hash>]
  def sales
    @discounts
  end

  # aggiorna l'inventario del negozio
  def update_shop(update_sales = true)
    sell_random_goods
    add_random_goods
    add_trade_flow_goods
    apply_random_sales if update_sales
  end

  # aggiunge scorte a caso nel negozio
  def add_random_goods
    rgoods = db_shop.random_goods + @custom_goods
    rgoods.each { |item| valuate_good_adding(item) }
  end

  # rimuove scorte a caso nel negozio
  def sell_random_goods
    goods.each { |item| valuate_good_selling(item) }
  end

  # aggiungi oggetti random dal riciclo di oggetti rari
  def add_trade_flow_goods
    trade_items = $game_system.get_random_trade_items(supply_rate)
    trade_items.each { |ary|
      good = RPG::Good_Details.new({:type => ary[1], :id => ary[0]})
      add_good(good)
    }
  end

  # aggiunge saldi a caso tra gli articoli
  def apply_random_sales
    @discounts = [{}, {}, {}]
    return unless has_discounts?
    goods.each { |good|
      next if deny_sale?(good)
      id = good.item.id
      type = good.item_type - 1
      @discounts[type][id] = generate_random_sale
    }
  end

  # determina se l'oggetto non può essere scontato
  # @param [RPG::Shop_Good] good
  # @return [Boolean] true: non scontare, false: puoi scontare
  def deny_sale?(good)
    if @denied_sales[good.item_type - 1][good.item_id] != nil
      return @denied_sales[good.item_type - 1][good.item_id]
    end
    if db_shop.denied_sales[good.item_type - 1][good.item_id] != nil
      return db_shop.denied_sales[good.item_type - 1][good.item_id]
    end
    false
  end

  # assegna a caso dei saldi.
  def generate_random_sale
    s_types = ShopsSettings::DISCOUNT_TYPES
    sales = [0]
    s_types.each_with_index { |value, key|
      sales.push(key) if value >= rand(100)
    }
    sales[rand(sales.size)]
  end

  # determina tramite un calcolo casuale quali oggetti rimuovere dal
  # negozio, per simulare gente che acquista ed esaurisce le scorte.
  # @param [RPG::Shop_Good] good
  def valuate_good_selling(good)
    return if good.unlimited?
    return if sell_denied?(good)
    (0..good.quantity - 1).each {
      if rand(100) < waste_rate
        remove_good(good)
        if good.rare?
          $game_system.trade_flow_add(good.item)
        end
      end
    }
  end

  # determina se la rivendita dell'oggetto dal negozio è permessa
  # @param [RPG::Shop_Good] good
  def sell_denied?(good)
    if @denied_sells[good.item_type - 1][good.item_id] != nil
      return @denied_sells[good.item_type - 1][good.item_id]
    end
    if db_shop.denied_sells[good.item_type - 1][good.item_id] != nil
      return db_shop.denied_sells[good.item_type - 1][good.item_id]
    end
    false
  end

  # determina tramite un calcolo casuale quali oggetti aggiungere dalla
  # lista degli oggetti random, per simulare i rifornimenti di scorte.
  # @param [RPG::Good_Details] good
  def valuate_good_adding(good)
    i_num = item_number(good.item)
    return if i_num >= good.quantity
    (0..[good.quantity - 1, good.quantity - i_num - 1].min).each {
      add_good(good) if rand(100) < supply_rate * good.repl_rate
    }
  end

  # rimuove un bene dal negozio. Se il bene è illimitato, non fa nulla a
  # meno che non si definisca :all come numero, così li rimuoverà tutti.
  # @param [RPG::Shop_Good] good
  # @param [Integer] item_number
  def remove_good(good, item_number = 1)
    return false if good.nil?
    return false if good.unlimited? and item_number != :all
    good.quantity -= item_number
    @goods.delete(good) if good.quantity <= 0
    true
  end

  # *
  # @param [RPG::Good_Details] good
  def add_good(good)
    in_good = find_good(good.item)
    if in_good
      return if in_good.unlimited?
      in_good.quantity = [in_good.quantity + good.quantity, 99].min
    else
      @goods.push(RPG::Shop_Good.new(good, good.quantity))
      @custom_prices[good.item_type - 1][good.item_id] = good.sell_price if good.sell_price
      @denied_sales[good.item_type - 1][good.item_id] = good.deny_sales if good.deny_sales
      @denied_sells[good.item_type - 1][good.item_id] = good.sell_locked if good.sell_locked
      @spawn_rates[good.item_type - 1][good.item_id] = good.repl_rate
    end
  end

  # trova la merce
  # @param [RPG::Item] item
  # @return [RPG::Shop_Good]
  def find_good(item)
    goods.each { |good| return good if good.item == item }
  end

  # aggiunge un oggetto al negozio
  # @param [RPG::Item] item
  # @param [Integer] item_number      # :unlimited se illimitato
  # @param [Integer] price
  # @param [Integer] can_disappear
  def add_item(item, item_number = 1, price = nil, can_disappear = false)
    item_number = -1 if item_number == :unlimited
    hash = {:type => item_type_id(item), :id => item.id,
            :quantity => item_number, :price => price,
            :sell_locked => can_disappear}
    add_good(RPG::Good_Details.new(hash))
  end

  # restituisce il tipo dell'oggetto come intero
  # 1: item, 2: arma, 3: armatura
  # @param [RPG::Item] item
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
  def add_random_good(good_detail)
    @custom_goods.push(process_good(good_detail))
  end

  # azzera tutti i beni personalizzati che possono comparire
  def clear_random_goods
    @custom_goods = []
  end

  # processa la descrizione
  # @param [Hash] good_detail
  def process_good(good_detail)
    good = RPG::Good_Details.new(good_detail)
    @custom_prices[good.item_type - 1][good.item_id] = good.sell_price if good.sell_price
    @denied_sales[good.item_type - 1][good.item_id] = good.deny_sales if good.deny_sales
    @denied_sells[good.item_type - 1][good.item_id] = good.sell_locked if good.sell_locked
    @spawn_rates[good.item_type - 1][good.item_id] = good.repl_rate
    good
  end
end

#==============================================================================
# *----
#
#==============================================================================
class Game_Temp
  # @return [Game_Shop] custom_shop
  attr_accessor :custom_shop
  # *
  # @return [Hash<RPG::Shop>]
  def custom_shops
    @custom_shops ||= init_custom_shops
  end

  # *
  # @return [Hash<RPG::Shop>]
  def init_custom_shops
    # TODO: creare inizializzatore
  end
end

#==============================================================================
# *----
#
#==============================================================================
class Game_System
  # *
  # @return [Array<Array>]
  def trade_flow
    @trade_flow ||= []
  end

  # *
  # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
  def trade_flow_add(item, number = 1)
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

  # *
  # @return [Array<Array>]
  def get_random_trade_items(bonus_rate = 0)
    rate = ShopsSettings::TRADE_REFLOW_RATE + bonus_rate
    items = []
    trade_flow.each { |ary|
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
# *----
#
#==============================================================================
class Game_Party

  # Restituisce lo sconto degli acquisti in negozio
  def shop_discount
    discount = 0.0
    members.each { |member| discount += member.buy_discount }
    discount
  end

  # Restituisce il bonus di vendita dei negozi
  def sell_bonus
    bonus = 0.0
    members.each { |member| bonus += member.sell_bonus }
    bonus
  end

  # 

end

#==============================================================================
# *----
#
#==============================================================================
class Chart

  # inizializzazione
  def initialize
    clear
  end

  # aggiunge un oggetto al carrello
  # @param [RPG::Item] item
  # @param [Integer] cost
  # @param [Integer] quantity
  def add_item(item, cost, quantity)
    if include?(item)
      item_select(item).item_number += quantity
    else
      items.push(Chart_Item.new(item, quantity, cost))
    end
  end

  # rimuove un oggetto dal carrello. Se quantity è :all, elimina tutti
  # @param [RPG::Item] item
  # @param [Integer] quantity
  def remove_item(item, quantity = :all)
    return unless include?(item)
    if quantity == :all
      items.delete_at(find_index(item))
    else
      chart_item = item_select(item)
      if chart_item.item_number <= quantity
        remove_item(item, :all)
      else
        chart_item.item_number -= quantity
      end
    end
  end

  # restituisce gli oggetti
  # @return [Array<Chart_Item>]
  def items
    items
  end

  # seleziona un oggetto dal carrello
  # @param [RPG::Item] item
  # @return [Chart_Item]
  def item_select(item)
    items.each { |chart_item| return chart_item if chart_item.item == item }
  end

  # restituisce l'indice nel carrello
  def find_index(item)
    (0..items.size - 1).each { |index| return index if item == items[index].item }
  end

  # determina se l'oggetto è incluso nel carrello
  # @param [RPG::Item] item
  def include?(item)
     item_select(item) != nil
  end

  # ottiene il totale del carrello
  def total_amount
    total = 0
    items.each { |chart_item|
      total += (chart_item.cost * chart_item.item_number)
    }
    total
  end

  # azzera il carrello
  def clear
    @items = []
  end
end

#==============================================================================
# *----
#
#==============================================================================
class Chart_Item

  # Variabili d'istanza pubbliche
  # @return [RPG::Item] item
  attr_accessor :item
  attr_accessor :item_number
  attr_accessor :cost

  # inizializzazione
  # @param [RPG::Item] item
  # @param [Integer] item_number
  # @param [Integer] cost
  def initialize(item, item_number, cost)
    @item = item
    @item_number = item_number
    @cost = cost
  end
end

#==============================================================================
# *----
#
#==============================================================================
class Game_Actor < Game_Battler

  # ottiene l'ammontare dello sconto quando si comprano oggetti
  def buy_discount
    features_sum(:buy_discount)
  end

  # ottiene l'ammontare del guadagno bonus quando si vendono gli oggetti
  def sell_bonus
    features_sum(:sell_bonus)
  end
end

#==============================================================================
# *----
#
#==============================================================================
class Window_ShopInfo < Window_Base

  # inizializzazione
  # @param [Game_Shop] shop
  def initialize(shop)
    super(0, 0, Graphics.width, fitting_height(1))
    @shop = shop
    refresh
  end

  # refresh
  def refresh
    contents.clear
    change_color(normal_color)
    draw_text(0, 0, contents_width, line_height, @shop.name)
  end
end

#==============================================================================
# *----
#
#==============================================================================
class Window_ShopCommand < Window_Command
  # *
  # @param [Game_Shop] shop
  def initialize(shop)
    @shop = shop
    super(0, 0)
    refresh
    update_placement
    self.openness = 0
  end

  # *
  def window_width
    160
  end

  # *
  def make_command_list
    add_command(Vocab::ShopBuy, :buy) if @shop.permit_buy?
    add_command(Vocab::ShopSell, :sell) if @shop.permit_sell?
    add_command(Vocab.shop_rebuy, :rebuy) if Shop_Core.rebuy_active?
    add_command(Vocab::ShopCancel, :cancel)
  end

  # *
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end
end

#==============================================================================
# * Window_ShopBuyN
# Nuova finestra d'acquisto dei beni
#==============================================================================
class Window_ShopBuyN < Window_Selectable
  # inizializzazione
  def initialize(x, y, width, height)
    make_item_list
    super
    refresh
    @index = 0
  end

  # ottiene la lista degli oggetti da vendere
  def make_item_list
    @shop = $game_temp.custom_shop
    @data = @shop.goods
  end

  # Ottiene il numero di elementi
  # @return [Integer]
  def item_max
    @data ? @data.size : 0
  end

  # 
  # @return [RPG::Shop_Good]
  def good
    @data[@index]
  end

  # *
  # @return [RPG::Item]
  def item
    good.item
  end

  # *
  def draw_item(index)
    good = @data[index]
    item = good.item
    rect = item_rect(index)
    rect.width -= 4
    enabled = enable?(index)
    draw_item_name(item, rect.x, rect.y, enabled, 150)
    draw_price(good, rect, enabled)
    draw_quantity(good, rect, enabled)
  end

  # mostra il prezzo dell'articolo
  # @param [RPG::Shop_Good] good
  # @param [Rect] rect
  # @param [Boolean] enabled
  def draw_price(good, rect, enabled)
    x = rect.x + 150
    width = rect.width - x
    change_color(power_up_color, enabled) if good.in_sale?
    text = sprintf('%d%s', @shop.item_cost(good), Vocab.currency_unit)
    draw_text(x, rect.y, width, line_height, text)
    x2 = x + text_size(text).width + 1
    old_size = contents.font.size
    contents.font.size = 15
    text2 = sprintf('-%d%%', good.sale_value)
    draw_text(x2, rect.y, rect.width - x2, line_height, text2)
    contents.font.size = old_size
  end

  # *
  # @param [RPG::Shop_Good] good
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

  # determina se l'oggetto è attivo e cliccabile
  def enable?(index)
    good = @data[index]
    item = good.item
    return false if $game_party.item_number(item) >= $game_party.max_item_number(item)
    $game_party.gold >= @shop.good_cost(good, true)
  end

  # determina se l'oggetto selezionato dal cursore è cliccabile
  def current_item_enabled?
    enable?(@index)
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
    @help_window.set_item(item.item) if @help_window
    info_window.set_item(item.item) if info_window
  end
end

#==============================================================================
# *----
#
#==============================================================================
class Window_ShopKeys < Window_Base

  # Inizializzazione
  def initialize(x, y, width)
    super(x, y, width, fitting_height(1))
    @mode = :select
    refresh
  end

  # refresh
  def refresh
    contents.clear
    change_color(normal_color)
    case @mode
    when :select
      refresh_select
    when :buy
      refresh_buy
    when :sell
      refresh_sell
    else
       #nulla
    end
  end

  # refresh della selezione degli oggetti
  def refresh_select
    draw_commands(:C, Vocab.shop_select, :X, Vocab.key_change_view)
  end

  # refresh della selezione della quantità da comprare
  def refresh_buy
    draw_commands(:C, Vocab.key_buy, :A, Vocab.key_a_buy)
  end

  # refresh della selezione della quantità da vendere
  def refresh_sell
    draw_commands(:C, Vocab.key_sell, :A, Vocab.key_a_sell)
  end

  # imposta la modalità e fa il refresh della finestra
  # mode può essere :select, :buy o :sell
  def set_mode(mode)
    return if @mode == mode
    @mode = mode
    refresh
  end

  # disegna i comandi con il testo descrittivo
  # @param [Symbol] com1
  # @param [String] help1
  # @param [Symbol] com2
  # @param [String] help2
  def draw_commands(com1, help1, com2, help2)
    width = contents_width / 2
    draw_key_icon(com1, 0, 0)
    draw_text(24, 0, width - 24, line_height, help1)
    draw_key_icon(com2, width, 0)
    draw_text(width + 24, 0, width - 24, line_height, help2)
  end
end

#==============================================================================
# Window_ShopNumberN
# nuova finestra per l'acquisto
#==============================================================================
class Window_ShopNumberN < Window_Base
  # object initialization
  def initialize
    super(0, 0, 250, fitting_height(3))
    @quantity = 1
    @item = nil
    @mode = :buy
    cursor_rect.set(cursor_x, 0, contents_width - cursor_x, line_height)
  end

  # refresh
  def refresh
    contents.clear
    draw_item_name(item, 0, 0, true, cursor_x)
    draw_item_number(cursor_x, 0, contents_width - cursor_x)
    draw_item_cost
  end

  # draws the item number
  def draw_item_number(x, y, width)
    l_e = can_min?
    r_e = can_add?
    draw_arrow(:left, x, y, l_e)
    arrow_x = x + width - arrow_rect(:right).width
    draw_arrow(:right, arrow_x, y, r_e)
    xx = x + arrow_rect(:left).width
    max = @mode == :buy ? max_buyable : max_sellable
    text = sprintf('%d/%d', @quantity, max)
    text_w = width - xx - arrow_rect(:right).width
    draw_text(xx, text_w, y, line_height, text, 1)
  end

  # disegna il costo dell'oggetto
  def draw_item_cost
    cost = @mode == :buy ? shop.item_cost(item) : shop.item_sell_cost(item)
    change_color(system_color)
    draw_text(line_rect(1), Vocab::shop_total)
    text = sprintf('%d %s', cost, Vocab::currency_unit)
    change_color(normal_color)
    draw_text(line_rect(1), text, 2)
  end

  def draw_next_possessed
    desc_width = contents_width / 2
    rect = line_rect(2)
    rect.width = desc_width
    change_color system_color
    draw_text rect, Vocab::Possession
    change_color normal_color

  end

  # *
  def cursor_x
    160
  end

  # determina la quantità massima acquistabile di un bene
  # @param [RPG::Item, RPG::Weapon, RPG::Armor] item
  # @return [Integer]
  def max_buyable
    max_shop = shop.item_number(item) >= 0 ? shop.item_number(item) : 99
    [$game_party.max_item_number(item) - $game_party.item_number(item),
     max_shop, $game_party.gold / shop.item_cost(item)].min
  end

  # determina la quantità massima che un bene può essere venduto
  def max_sellable
    $game_party.item_number(item)
  end

  # determina se può diminuire il numero di oggetti
  def can_min?
    @quantity > 1
  end

  # determina se può aumentare il numero di oggetti
  def can_add?
    @quantity < (@mode == :buy ? max_buyable : max_sellable)
  end

  # imposta l'ogetto della finestra
  # @param [RPG::Item] new_item
  def set_item(new_item)
    @item = new_item
    @quantity = 1
    refresh
  end

  # 
  # @return [RPG::Item]
  def item
    @item
  end

  # returns the current shop
  # @return [Game_Shop]
  def shop
    $game_temp.custom_shop
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

  # restituisce il negozio corrente
  # @return [Game_Shop]
  def shop
    @shop
  end

  def refresh
    contents.clear
    return if @good.nil?
    draw_item_possession(@good)
    line = draw_item_sale(@good)
    draw_equip_info(@good, line + 1)
  end

  # @param [RPG::Shop_Good] good
  def draw_item_possession(good)
    change_color system_color
    draw_text(line_rect(0), Vocab::Possession)
    change_color normal_color
    draw_text line_rect(0), $game_party.item_number(good.item), 2
  end

  # draws the current sale (if it is in sale)
  # @param [RPG::Shop_Good] good
  # @return [Integer]
  def draw_item_sale(good)
    return 0 unless shop.good_in_sale?(good)
    change_color crisis_color
    draw_text(line_rect(1), sprintf(Vocab.on_sale, shop.sale_rate(good)), 1)
    1
  end

  # mostra i membri del gruppo che possono equipaggiare
  # l'oggetto ed i relativi cambi di parametri
  # @param [RPG::Shop_Good] good
  # @param [Integer] line
  def draw_equip_info(good, line)
    return if good.item_type < 2
    $game_party.members.each do |member|
      draw_actor_params(member, good.item, line)
    end
  end

  # disegna i parametri che cambiano con l'equip
  # @param [Game_Actor] actor
  # @param [RPG::Armor,RPG::Weapon] item
  # @param [Integer] line
  # noinspection RubyArgCount
  # noinspection RubyYardParamTypeMatch
  def draw_actor_params(actor, item, line)
    return line unless actor.equippable? item
    rect = line_rect(line)
    draw_actor_little_face(actor, rect.x, rect.y)
    rect.x += 32
    rect.width -= 32
    if actor.level < item.equip_level
      change_color power_down_color
      draw_text rect, Vocab.level_too_low
    elsif actor.equips.collect { |equip| equip.id }.include? item.id
      change_color normal_color
      draw_text rect, Vocab.already_equipped
    else
      cloned = clone_actor actor
      cloned.change_equip(item.kind, item, true)
      draw_stat_differences(actor, cloned, rect, item)
    end
    line + 1
  end

  # disegna le differenze in statistiche dell'equipaggiamento
  # @param [Game_Actor] actor
  # @param [Game_Actor] clone
  # @param [Rect] rect
  # @param [RPG::Weapon, RPG::Armor] item
  def draw_stat_differences(actor, clone, rect, item)
    max_diff = rect.width / ShopsSettings::PARAMS_WIDTH
    compare_values = get_compare_values item
    y = rect.y
    index = 0
    width = ShopsSettings::PARAMS_WIDTH
    compare_values.each do |val|
      x = rect.x + index * width
      index += draw_param_comparation(val, actor, clone, x, y)
      break if index >= max_diff
    end
  end

  # ottiene l'elenco dei parametri da confrontare
  # @param [RPG::Armor, RPG::Weapon] item
  # @return [Array<Symbol>]
  def get_compare_values(item)
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
    draw_text(x, y, ShopsSettings::PARAMS_WIDTH, line_rect, sprintf('%+d', clone_param - actor_param), 2)
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

class Scene_NewShop < Scene_MenuBase
end

class Game_Interpreter

  # vai alla nuova schermata del negozio
  def load_shop(shop_id)
    $game_temp.custom_shop = shop_id
    SceneManager.call(Scene_NewShop)
  end
end