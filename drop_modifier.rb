# Modificatore di DROP/ORO/EXP/PA
# Questo script modifica drop, oro, esperienza e punti abilità tramite
# equipaggiamenti e stati alterati.
# Richiede lo script degli attributi aggiuntivi.
#===============================================================================
# Modificatore drop di Holy87
# Difficoltà utente: ★★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script modifica drop, oro, esperienza e punti abilità tramite
# equipaggiamenti e stati alterati.
# Richiede lo script degli attributi aggiuntivi.
# Si possono aggiungere drop ai nemici con questi tag:
# ● <drop item 13: 50%> (oltre a item, anche armor e weapon)
#   aggiunge l'oggetto con ID 13 ai drop, 50% di probabilità.
# ● <drop weapon 15: 1/5>
#   si possono usare anche i denominatori come nel metodo classico:
#   in questo caso l'arma 15 avrà 1 possibilità su 5 di essere
#   droppata dal nemico.
#   per aggiungere oro ai drop di fine battaglia
# ● <exp rate: +x%>
#   aggiunto a status e equipaggiamenti, aumenta l'esperienza ottenuta
#   sull'eroe del x%.
# ● <gold rate: +x%>
#   aggiunto a status ed equipaggiamenti, aumenta l'oro ottenuto al
#   gruppo del x%.
# ● <drop rate: +x%>
#   aggiunto a status ed equipaggiamenti, aumenta la probabilità di
#   drop di tutti i nemici del x%. Vale anche se il nemico è affetto
#   da uno status che ha quel tag.
# ● <jp rate: +x%>
#   aggiunto a status ed equipaggiamenti, aumenta i JP ottenuti dai
#   nemici

#===============================================================================
#===============================================================================
# ** IMPOSTAZIONI DEI DROP
#===============================================================================
module Drop_Modifier_Settings
  # ** ONLINE **
  # Vuoi poter modificare il drop rate via internet?
  USE_ONLINE_FEATURES = false
  # Determina l'URL della chiamata per ottenere i dati su drop, exp, oro e JP
  ONLINE_DATA_ENDPOINT = HTTP.domain + '/metrics.php'
  # Configura le chiavi json dell'enpoint
  DATA_BUCKETS = {
      :exp_rate => 'exp_rate',
      :gold_rate => 'gold_rate',
      :drop_rate => 'drop_rate',
      :jp_rate => 'jp_rate'
  }

  # Valori di default dei parametri di gioco (nel caso non sia attivo o non sia
  # disponibile l'online)
  DROP_RATE = 1.0   # rate dei drop
  GOLD_RATE = 1.0   # moltiplicatore oro
  EXP_RATE = 1.0    # moltiplicatore exp
  JP_RATE = 1.0     # moltiplicatore JP
end

#===============================================================================
# ** Drop_Modifier_Core
#===============================================================================
module Drop_Modifier_Core
  #--------------------------------------------------------------------------
  # * espressioni regolari per i tag
  #--------------------------------------------------------------------------
  REGEXP_EXP_BONUS = /<exp rate:[ ]*([+\-]\d+)[%％]>/i
  REGEXP_GOLD_BONUS = /<gold rate:[ ]*([+\-]\d+)[%％]>/i
  REGEXP_JP_BONUS = /<jp rate:[ ]*([+\-]\d+)[%％]>/i
  REGEXP_DROP_BONUS = /<drop rate:[ ]*([+\-]\d+)[%％]>/i
  REGEXP_ITEM_DROP = /<drop (item|armor|weapon)[ ]+(\d+):[ ]*(.+)>/i
  # per le configurazioni precedenti con KGC::ItemDrop
  # noinspection RegExpSingleCharAlternation
  LEGACY_ITEM_DROP = /<drop (i|a|w):(\d+) (\d+)%>/i
end

#===============================================================================
# ** modulo Game_Metrics
# ------------------------------------------------------------------------------
# Il modulo raccoglie parametri che possono influire sul gameplay
#===============================================================================
module Game_Metrics
  include Drop_Modifier_Settings

  # restituisce il moltiplicatore exp
  def self.exp_rate
    data[:exp]
  end

  # restituisce il moltiplicatore prob. drop
  def self.drop_rate
    data[:drop]
  end

  # restituisce il moltiplicatore oro
  def self.gold_rate
    data[:gold]
  end

  def self.jp_rate
    data[:jp]
  end

  # restituisce l'hash di tutti i moltiplicatori
  def self.data
    @metrics ||= refresh_metrics
  end

  # @return [Hash]
  def self.refresh_metrics
    @metrics = {
        :exp => DROP_RATE,
        :gold => GOLD_RATE,
        :drop => DROP_RATE,
        :jp => JP_RATE
    }

    return @metrics unless USE_ONLINE_FEATURES

    server_data = await_response ONLINE_DATA_ENDPOINT
    server_data = JSON.decode(server_data)
    data_buckets = DATA_BUCKETS

    @metrics[:exp] = server_data[data_buckets[:exp_rate]] || @metrics[:exp]
    @metrics[:gold] = server_data[data_buckets[:gold_rate]] || @metrics[:gold]
    @metrics[:drop] = server_data[data_buckets[:drop_rate]] || @metrics[:drop]
    @metrics[:jp] = server_data[data_buckets[:jp_rate]] || @metrics[:jp]
    @metrics
  end
end

#===============================================================================
# ** Drop_Common
#===============================================================================
module Drop_Common
  attr_reader :exp_bonus
  attr_reader :drop_bonus
  attr_reader :gold_bonus
  attr_reader :jp_bonus

  # inizializzazione dei parametri
  def drop_attr_init
    return if @drop_attr_initialized
    @drop_attr_initialized = true
    @exp_bonus = 0
    @drop_bonus = 0
    @gold_bonus = 0
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
      when Drop_Modifier_Core::REGEXP_DROP_BONUS
        @drop_bonus = $1.to_f / 100
      when Drop_Modifier_Core::REGEXP_EXP_BONUS
        @exp_bonus = $1.to_f / 100
      when Drop_Modifier_Core::REGEXP_GOLD_BONUS
        @gold_bonus = $1.to_f / 100
      when Drop_Modifier_Core::REGEXP_JP_BONUS
        @jp_bonus = $1.to_f / 100
      else
        # niente
      end
    }
  end
end

#===============================================================================
# ** RPG::State
#===============================================================================
class RPG::State;
  include Drop_Common;
end

#===============================================================================
# ** RPG::Weapon
#===============================================================================
class RPG::Weapon;
  include Drop_Common;
end

#===============================================================================
# ** RPG::Armor
#===============================================================================
class RPG::Armor;
  include Drop_Common;
end

#===============================================================================
# ** RPG::Enemy::DropItem
#===============================================================================
class RPG::Enemy::DropItem
  # restituisce la probabilità di drop in percentuale dell'oggetto
  def drop_percentage
    100.0 / denominator
  end

  # modifica il denominatore tenendo conto del rate dei drop
  def denominator
    @denominator / $game_system.drop_rate
  end

  # restituisce l'istanza dell'oggetto del drop
  # @return [RPG::Item,RPG::Weapon,RPG::Armor]
  def item
    case @kind
    when 1
      $data_items[data_id]
    when 2
      $data_weapons[data_id]
    when 3
      $data_armors[data_id]
    else
      nil
    end
  end
end

#===============================================================================
# ** RPG::Enemy
#===============================================================================
class RPG::Enemy
  include Drop_Common
  # @return [Array<RPG::Enemy::DropItem>]
  attr_accessor :drop_items

  # intializes the extra drop items data
  def init_custom_drop_items
    return if @init_custom_drop_items
    @init_custom_drop_items = true
    @drop_items = []
    self.note.split(/[\r\n]+/).each { |line|
      if line =~ Drop_Modifier_Core::REGEXP_ITEM_DROP
        @drop_items.push(make_custom_drop_item($1.to_sym, $2.to_i, $3))
      end
      if line =~ Drop_Modifier_Core::LEGACY_ITEM_DROP
        type = {:i => :item, :w => :weapon, :a => :armor}[$1.downcase.to_sym]
        @drop_items.push(make_custom_drop_item(type, $2.to_i, $3 + '%'))
      end
    }
  end

  # the enemy gold
  def gold
    (@gold * $game_system.gold_rate).to_i
  end

  # the enemy exp
  def exp
    (@exp * $game_system.exp_rate).to_i
  end

  alias normal_jp_earn jp unless $@
  def jp
    (normal_jp_earn * $game_system.jp_rate).to_i
  end

  # creates a custom drop item
  # @param [Symbol] item_type
  # @param [Integer] item_id
  # @param [String] enumerator_str
  # @return [RPG::DropItem]
  def make_custom_drop_item(item_type, item_id, enumerator_str)
    drop_item = RPG::Enemy::DropItem.new
    drop_item.kind = {:item => 1, :weapon => 2, :armor => 3}[item_type]
    drop_item.data_id = item_id
    case enumerator_str
    when /1\/(\d+)/i
      drop_item.denominator = $1.to_i
    when /(\d+)[%％]/i
      drop_item.denominator = 100.0 / [[$1.to_i,1].max,100].min
    else
      # errore
    end
    drop_item
  end

  # gets the drop items array
  # @return [Array<RPG::Enemy::DropItem]
  # noinspection RubyResolve
  def drop_items
    ([@drop_item1, @drop_item2] + (@drop_items ||= [])).compact.select {|drop_item| drop_item.kind > 0}
  end
end

#===============================================================================
# ** modulo DataManager
#===============================================================================
module DataManager
  class << self
    alias h87_drop_load_normal_database load_normal_database
    alias h87_drop_load_battle_test_database load_battle_test_database
  end

  # load the normal database
  def self.load_normal_database
    h87_drop_load_normal_database
    load_drop_data
  end

  # load database for battle test
  def self.load_battle_test_database
    h87_drop_load_battle_test_database
    load_drop_data
  end

  # load the extra drop data
  def self.load_drop_data
    $data_enemies.each do |enemy| 
      next if enemy.nil?
      enemy.init_custom_drop_items
      enemy.drop_attr_init
    end
    $data_weapons.each{ |w| w.drop_attr_init if w}
    $data_armors.each{ |a| a.drop_attr_init if a}
    $data_states.each{ |s| s.drop_attr_init if s}
  end
end

#===============================================================================
# ** Game_System
#===============================================================================
class Game_System
  # the drop rate
  # @return [Float]
  def drop_rate
    Game_Metrics.drop_rate
  end

  # the gold rate
  # @return [Float]
  def gold_rate
    Game_Metrics.gold_rate
  end

  # the exp rate
  # @return [Float]
  def exp_rate
    Game_Metrics.exp_rate
  end

  # the jp rate
  # @return [Float]
  def exp_rate
    Game_Metrics.jp_rate
  end
end

#===============================================================================
# ** Game_Battler
#===============================================================================
class Game_Battler
  # the drop bonus
  def drop_bonus
    features_sum :drop_bonus
  end

  # the experience bonus
  def exp_bonus
    features_sum :exp_bonus
  end

  # the gold bonus
  def gold_bonus
    features_sum :gold_bonus
  end

  # the jp bonus
  def jp_bonus
    features_sum :jp_bonus
  end
end

#===============================================================================
# ** Game_Enemy
#===============================================================================
class Game_Enemy < Game_Battler
  alias h87_drop_init initialize unless $@
  alias h87_drop_make_drop make_drop_items unless $@
  alias h87_drops_drop_item_rate drop_item_rate unless $@

  # enemy initialization
  def initialize(index, enemy_id)
    h87_drop_init(index, enemy_id)
    @added_drops = []
  end

  # adds a drop item
  def add_drop_item(item_id, item_type, denominator = 1)
    drop_item = RPG::Enemy::DropItem.new
    drop_item.kind = item_type
    drop_item.data_id = item_id
    drop_item.denominator = denominator

    @added_drops.push(drop_item)
  end

  # aggiunge l'oggetto ai drop
  # @param [RPG::BaseItem] item
  def add_drop(item)
    case item
    when RPG::Item
      add_drop_item(item.id, 1)
    when RPG::Weapon
      add_drop_item(item.id, 2)
    when RPG::Armor
      add_drop_item(item.id, 3)
    else
      # type code here
    end
  end

  # Create Array of Dropped Items
  # @return [Array<RPG::BaseItem>]
  def make_drop_items
    @added_drops.inject(h87_drop_make_drop) do |r, di|
      if di.kind > 0 && rand * di.denominator < drop_item_rate
        r.push(item_object(di.kind, di.data_id))
      else
        r
      end
    end
  end

  # Get Multiplier for Dropped Item Acquisition Probability
  def drop_item_rate
    rate = h87_drops_drop_item_rate
    rate *= $game_party.drop_bonus
    rate *= (self.drop_bonus + 1.0)
    [0.01, rate].max # per evitare che restituisca 0
  end
end

#===============================================================================
# ** Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  alias h87_drop_gain_exp gain_exp unless $@
  alias h87_drop_earn_jp earn_jp unless $@

  # fa ottenere l'esperienza all'eroe
  # @param [Boolean] show
  # @param [Integer] exp
  def gain_exp(exp, show)
    h87_drop_gain_exp((exp * exp_bonus).to_i, show)
  end

  def earn_jp(amount = 0)
    h87_drop_earn_jp((amount * jp_bonus).to_i)
  end
end

#===============================================================================
# ** Game_Party
#===============================================================================
class Game_Party < Game_Unit
  # gets the drop bonus of all party members
  def drop_bonus
    members.inject(1.0) do |bonus, member|
      bonus + member.drop_bonus
    end
  end

  # gets the --------- bonus of all party members
  def gold_bonus
    members.inject(1.0) do |bonus, member|
      bonus + member.gold_bonus
    end
  end
end

#===============================================================================
# ** Game_Troop
#===============================================================================
class Game_Troop < Game_Unit
  alias h87_drop_gold_rate gold_rate unless $@
  alias h87_drop_total_gold gold_total unless $@

  # restituisce il totale dell'oro ottenuto dalla battaglia
  # @return [Integer]
  def gold_total
    h87_drop_total_gold.to_i
  end

  # restituisce il moltiplicatore oro dei nemici
  def gold_rate
    h87_drop_gold_rate * $game_party.gold_bonus
  end
end