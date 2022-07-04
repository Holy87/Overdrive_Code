#==============================================================================
# ** Shop
# È una classe che contiene le informazioni statiche (definite nei settaggi)
# dei negozi Game_Shop.
#==============================================================================
class RPG::Shop

  # ID del negozio
  # @return [Symbol]
  attr_reader :id
  # nome del negozio
  # @return [String]
  attr_reader :name
  # oggetti iniziali del negozio
  # @return [Array<RPG::Shop_Article>]
  attr_reader :initial_articles
  # oggetti che possono apparire nel negozio
  # @return [Array<RPG::Shop_Article>]
  attr_reader :random_articles
  attr_reader :permit_sell #permetti il comando vendi
  attr_reader :permit_buy #permetti il comando compra
  attr_reader :permit_sales #permetti di mettere dei saldi
  attr_reader :sales_rate_bonus #bonus probabilità saldi
  attr_reader :sell_bonus #bonus guadagno vendita
  attr_reader :buy_discount #sconto su acquisti
  attr_reader :supply_rate #prob di rifornimento
  attr_reader :depletion_rate #prob di scaricamento
  # oggetti che hanno gli sconti vietati
  # @return [Array<Hash>] denied_sales
  attr_reader :denied_sales
  # prezzi personalizzati degli oggetti
  # @return [Array<Hash>] custom_prices
  attr_reader :custom_prices
  # probabilità di comparsa
  # @return [Array<Hash>] spawn_rates
  attr_reader :spawn_rates
  # gli oggetti che non possono scomparire dal negozio
  # @return [Array<Hash>] denied_sells
  attr_reader :denied_sells
  # @return [Array<Symbol>]
  attr_reader :handled_categories
  # calcolo punti fedeltà
  # @return [Float]
  attr_reader :fidelity_rate

  # inizializzazione
  # @param [Symbol] id
  # @param [Hash] hash_info
  def initialize(id, hash_info)
    @id = id
    @name = hash_info[:name] || ''
    @permit_sell = hash_info[:can_sell] != nil ? hash_info[:can_sell] : true
    @permit_buy = hash_info[:can_buy] != nil ? hash_info[:can_buy] : true
    @permit_sales = hash_info[:sales] != nil ? hash_info[:sales] : ShopsSettings::DISCOUNTS
    @sell_bonus = hash_info[:sell_bonus] ? (hash_info[:sell_bonus] / 100.0) : 0
    @sales_rate_bonus = hash_info[:sale_bonus] || 0
    @buy_discount = hash_info[:buy_discount] ? (hash_info[:buy_discount] / 100.0) : 0
    @initial_articles = process_articles(hash_info[:goods]) || []
    @random_articles = process_articles(hash_info[:random_goods]) || []
    @fidelity_rate = hash_info[:fidelity_rate] || ShopsSettings::FIDELITY_DEFAULT_RATE
    @supply_rate = hash_info[:supply_rate] || ShopsSettings::DEFAULT_SUPPLY_RATE
    @depletion_rate = hash_info[:depletion_rate] || ShopsSettings::DEFAULT_WASTE_RATE
    @handled_categories = hash_info[:handles] || construct_categories
  end

  # processa l'hash degli oggetti
  # @param [Array<Hash>] articles_hash
  # @return [Array<RPG::Shop_Article>]
  def process_articles(articles_hash)
    return [] if articles_hash.nil?
    articles_hash.collect { |article_detail| RPG::Shop_Article.new(article_detail) }
  end

  # determina le categorie di articoli del negozio a seconda
  # degli articoli iniziali in assortimento
  def construct_categories
    categories = []
    categories.push(:items) if @initial_articles.select { |a| a.item_type == 1}.any?
    categories.push(:weapons) if @initial_articles.select { |a| a.item_type == 2}.any?
    categories.push(:armors) if @initial_articles.select { |a| a.item_type == 3}.any?
    categories
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
    when RPG::Fake_Item
      1
    else
      0
    end
  end
end

#==============================================================================
# ** Good_Detail----
# rappresenta i dettagli dei beni da inserire nel negozio. Sono definiti nelle
# impostazioni e sono immutabili durante la partita. Vengono utilizzati in
# Game_Shop e come inizializzatori di Shop_Good.
#==============================================================================
class RPG::Shop_Article
  attr_reader :item_type # tipo oggetto
  attr_reader :item_id # ID oggetto
  # quantità oggetto MASSIMA
  # in realtà è un po' nebuloso. Nel caso di oggetti iniziali dello
  # shop identifica la quantità iniziale, quella massima solo nei random
  attr_reader :max_quantity
  attr_reader :repl_rate # rarità oggetto (quanto spesso viene messo)
  attr_reader :price # prezzo di vendita
  attr_reader :sell_locked # blocca la rivendita
  attr_reader :deny_sales # blocca saldi per quest'oggetto
  attr_reader :custom_currency # ID valuta personalizzata

  # inizializzazione
  # @param [Hash] hash_info
  def initialize(hash_info)
    if hash_info[:set] != nil and hash_info[:set] =~ Shop_Core::ITEM_REGEXP
      @item_type = item_type_from_char($1)
      @item_id = $2.to_i
      @max_quantity = $3 != nil ? $4.to_i : -1
    else
      @item_type = hash_info[:type]
      @item_id = hash_info[:id]
      @max_quantity = hash_info[:quantity] || hash_info[:max] || -1
    end
    @repl_rate = hash_info[:repl_rate] ? (hash_info[:repl_rate] / 100.0) : 1.0
    @price = hash_info[:price].nil? ? item.price : hash_info[:price]
    @sell_locked = hash_info[:sell_locked].nil? ? false : hash_info[:sell_locked]
    @deny_sales = hash_info[:no_sales].nil? ? false : hash_info[:no_sales]
    @required_sw = hash_info[:switch]
    @required_var = hash_info[:variable]
    @required_var_value = hash_info[:variable_val] || 1
    @required_noitem = hash_info[:if_not_item]
    @custom_currency = hash_info[:currency]
  end

  # restituisce l'oggetto reale del database
  # @return [RPG::Item, RPG::Weapon, RPG::Armor, RPG::FakeItem]
  def item
    case @item_type
    when 1
      $data_items[@item_id]
    when 2
      $data_weapons[@item_id]
    when 3
      $data_armors[@item_id]
    when 4
      $data_fake_items[@item_id]
    else
      nil
    end
  end

  def custom_currency?
    @custom_currency != nil
  end

  # determina se è un oggetto con quantità illimitate
  def unlimited?
    quantity == -1
  end

  # restituisce il numero del tipo oggetto dalla stringa
  # noinspection RubyStringKeysInHashInspection
  def item_type_from_char(char)
    {'i' => 1, 'w' => 2, 'a' => 3, 'c' => 4}[char]
  end

  # alias attributo max_quantity
  # @return [Integer]
  def quantity
    @max_quantity
  end

  def conditions_met?
    variable_condition_met? and switch_condition_met? and no_item_met?
  end

  # la condizione è soddisfatta se la variabile richiesta ha un valore maggiore o uguale di quello richiesto
  def variable_condition_met?
    return true if @required_var.nil?
    $game_variables[@required_var] >= @required_var_value
  end

  # la condizione è soddisfatta se lo switch richiesto è true
  def switch_condition_met?
    return true if @required_sw.nil?
    $game_switches[@required_sw]
  end

  # la condizione è soddisfatta se il party non possiede già un oggetto dello
  # stesso tipo
  def no_item_met?
    return true if @required_noitem.nil?
    !$game_party.has_item?($data_items[@required_noitem])
  end
end

class RPG::Fake_Item < RPG::BaseItem
  attr_reader :switch_id
  attr_reader :variable_id
  attr_reader :script
  attr_reader :price
  def initialize(data)
    @icon_index = data[:icon]
    @id = data[:id]
    @name = data[:name]
    @description = data[:description]
    @price = data[:price]
    @switch_id = data[:switch_id]
    @variable_id = data[:variable_id]
    @script = data[:script]
  end

  def for_switch?
    @switch_id != nil
  end

  def for_variable?
    @variable_id != nil
  end

  def execute_script?
    @script != nil
  end

  def process_buy
    return process_switch if for_switch?
    return process_variable if for_variable?
    return process_script if execute_script?
    nil
  end

  private

  def process_switch
    $game_switches[@switch_id] = true
  end

  def process_script
    eval @script
  end

  def process_variable
    $game_variables[@variable_id] += 1
  end
end

class RPG::Currency
  # @return [String]
  attr_reader :name
  # @return [Integer]
  attr_reader :icon_index
  # @return [Integer]
  attr_reader :id
  # @return [Integer]
  attr_reader :object_id

  # @param [Hash] currency_data
  def initialize(currency_data)
    @type = currency_data[:type]
    @id = currency_data[:key]
    @object_id = currency_data[:id]
    @price = currency_data[:price]
    @name = item? ? $data_items[@object_id].name : currency_data[:name]
    @icon_index = item? ? $data_items[@object_id].icon_index : currency_data[:icon]
  end

  def selling_price
    @price
  end

  def item?
    @type == :item
  end

  def variable?
    @type == :variable
  end
end