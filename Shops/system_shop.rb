module DataManager
  class << self
    alias h87_shop_load_normal_database load_normal_database
    alias h87_shop_extract_save_contents extract_save_contents
    alias h87_shop_make_save_contents make_save_contents
    alias h87_shop_cmo create_game_objects
  end

  def self.create_game_objects
    h87_shop_cmo
    $game_shops = Game_Shops.new
  end

  def self.make_save_contents
    contents = h87_shop_make_save_contents
    contents[:shop] = $game_shops
    contents
  end

  # estrae i dati di gioco dal salvataggio
  # @param [Hash] contents
  def self.extract_save_contents(contents)
    h87_shop_extract_save_contents(contents)
    $game_shops = contents[:shop] || Game_Shops.new
  end

  def self.load_normal_database
    h87_shop_load_normal_database
    $data_shops = Shop_Core.init_shops
    $data_states.compact.each { |state| state.init_shop_stats }
    $data_armors.compact.each { |armor| armor.init_shop_stats }
    $data_weapons.compact.each { |weapon| weapon.init_shop_stats }
  end
end

#==============================================================================
# * Vocaboli custom del negozio
#==============================================================================
module Vocab
  def self.shop_rebuy
    ShopsSettings::SHOP_REBUY
  end

  def self.key_buy
    ShopBuy
  end

  def self.key_sell
    ShopSell
  end

  def self.key_rebuy
    ShopsSettings::SHOP_REBUY
  end

  def self.key_a_buy
    ShopsSettings::BUY_ALL
  end

  def self.key_a_sell
    ShopsSettings::SELL_ALL
  end

  def self.key_a_rebuy
    ShopsSettings::REBUY_ALL
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

  # già equipaggiato
  def self.already_equipped
    ShopsSettings::ALREADY_EQUIPPED
  end

  # livello troppo basso
  def self.level_too_low
    ShopsSettings::LEVEL_TOO_LOW
  end

  # tutto esaurito
  def self.sold_out
    ShopsSettings::SOLD_OUT
  end

  # @param [Symbol] action
  # @return [Hash{Symbol->String}]
  def self.shop_action(action)
    {:buy => ShopBuy, :sell => ShopSell, :rebuy => shop_rebuy}[action]
  end
end

#==============================================================================
# Inclusione degli shop stat negli oggetti
#==============================================================================
class RPG::State
  include Shop_Stats
end
class RPG::Armor
  include Shop_Stats
end
class RPG::Weapon
  include Shop_Stats
end

#==============================================================================
# * Game_Temp
#==============================================================================
class Game_Temp
  # negozio aperto (quando viene chiamata la schermata del negozio)
  # @return [Game_Shop] custom_shop
  attr_accessor :custom_shop

end

#==============================================================================
# * Game_Party
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

  # restituisce gli oggetti che possono essere venduti
  # @return [Array<RPG::Item>]
  def sellable_items
    all_items.select { |item| item.traddable? }
  end
end


#==============================================================================
# * Game_Actor
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
# * Game_Interpreter
#==============================================================================
class Game_Interpreter
  # vai alla nuova schermata del negozio
  def open_shop(shop_id)
    $game_temp.custom_shop = $game_shops[shop_id]
    SceneManager.call(Scene_NewShop)
  end

  # aggiorna lo stato di tutti i negozi.
  # puoi inserire come parametro il numero di aggiornamenti
  # da effettuare simultaneamente
  def update_shops(refresh_times = 1)
    refresh_times.times { $game_shops.advance_shops(true) }
  end
end

#==============================================================================
# * Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  alias h87_shop_refresh_update update unless $@
  # aggiornamento
  def update
    h87_shop_refresh_update
    $game_shops.update_shop_status
  end
end

#==============================================================================
# * Cache
#==============================================================================
module Cache
  # informazioni mappe
  # @return [Array<RPG::MapInfo>]
  def self.map_info
    @map_info ||= load_data('Data/MapInfos.rvdata')
  end
end

#==============================================================================
# * Game_Map
#==============================================================================
class Game_Map
  alias h87_shops_setup setup unless $@
  # determina se in questa mappa non scorre il tempo
  def timeless_map?
    @timeless_map ||= child_of_no_update_maps?
  end

  # determina se è una mappa dove il tempo scorre più veloce
  def fast_update_map?
    ShopsSettings::FAST_UPDATE_MAPS.include? @map_id
  end

  # determina se è figlio delle mappe senza tempo
  def child_of_no_update_maps?
    ShopsSettings::HOLD_UPDATE_MAPS.include?(@map_id)
    ShopsSettings::HOLD_UPDATE_MAPS.each { |lock_id| return true if child_of?(lock_id, @map_id) }
    false
  end

  # determina se è figlio di una mappa
  def child_of?(search_id, map_id)
    return false if Cache.map_info[map_id].nil?
    parent_id = Cache.map_info[map_id].parent_id
    return false if parent_id.nil?
    return true if parent_id == search_id
    child_of?(search_id, parent_id)
  end

  def setup(map_id)
    h87_shops_setup(map_id)
    @timeless_map = child_of_no_update_maps?
  end
end