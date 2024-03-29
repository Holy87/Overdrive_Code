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
# * Shop_Core
# modulo per la gestione generale dei negozi
#==============================================================================
module Shop_Core
  ITEM_REGEXP = /([iwac])(\d+)(x(\d+))?/i

  # determina se "riacquista è disponibile"
  def self.rebuy_active?
    ShopsSettings::REBUY
  end

  # @return [Hash{Symbol->RPG::Shop}]
  def self.init_shops
    data = {}
    ShopsSettings::SHOPS.each_pair do |key, hash|
      data[key] = RPG::Shop.new(key, hash)
    end
    data
  end

  # @return [Hash{Symbol->RPG::Currency}]
  def self.init_currencies
    data = {}
    ShopsSettings::CUSTOM_CURRENCIES.each do |hash|
      data[hash[:key]] = RPG::Currency.new(hash)
    end
    data
  end

  # @return [Hash{Integer->RPG::Currency}]
  def self.init_fake_items
    data = {}
    ShopsSettings::FAKE_ITEMS.each_pair do |key, hash|
      data[key] = RPG::Fake_Item.new(hash)
    end
    data
  end
end