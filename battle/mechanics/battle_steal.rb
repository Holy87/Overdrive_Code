# STEAL SCRIPT
# Questo script permette alle abilità di rubare.

module StealSettings
  # icona che compare nel popup quando nulla viene rubato
  NO_STEAL_ICON = 0

  # icona che compare quando si ruba del denaro
  ROBBERY_ICON = 0

  # moltiplicatore probabilità di furto se il nemico è
  # addormentato
  SLEEP_MULTIPLIER = 3

  # se true, tutti i nemici su cui non metti il tag
  # di furto denaro, verrà applicato un calcolo
  # automatico. Altrimenti, se false, il nemico
  # non avrà oro da farsi rubare
  AUTO_ROBBERY_CALC = false

  # calcola l'ammontare di denaro da rubare dal nemico
  # per l'abilità di furto, nel caso non sia stato
  # specificato (se AUTO_ROBBERY_CALC è true)
  ROBBERY_DEFAULT_CALC = '@gold * 2'

  # la probabilità predefinita di rubare soldi (può essere
  # ampliata dagli oggetti e status)
  DEFAULT_ROBBERY_PROBABILITY = 30#%
end



module Vocab
  NOTHING_TO_STEAL_ENEMY = '%s non ha niente da rubare!'
  NOTHING_TO_STEAL_PARTY = 'Non hai nulla di buono!'
  FAILED_STEAL = '%s non riesce a rubare!'
  STEAL_SUCCESS_ACTOR = '%s ha rubato %s!'
  STEAL_SUCCESS_ENEMY = '%s ti ha rubato %s!'
  ROBBERY_NOTHING = '%s non ha soldi!'
end

module StealBonus
  def init_steal_data
    return if @steal_data_init
    @steal_data_init = true
    @steal_bonus = 0
    self.note.split(/[\n\r]+/).each do |line|
      case line
      when /<steal bonus:[ ]*([+\-]\d+)%>/i
        @steal_bonus = $1.to_f / 100
      else
        # type code here
      end
    end
  end

  def steal_bonus
    @steal_bonus
  end
end

class RPG::State
  include StealBonus
end

class RPG::Weapon
  include StealBonus

  # determina se l'oggetto può essere rubato dai
  # nemici
  def stealable?
    false
  end
end

class RPG::Armor
  include StealBonus

  # determina se l'oggetto può essere rubato dai
  # nemici
  def stealable?
    false
  end
end

class RPG::Item
  # determina se l'oggetto può essere rubato dai
  # nemici
  def stealable?
    return false if self.price <= 0
    return false if key_item?
    true
  end
end

class RPG::Enemy
  # @return [Array<RPG::Enemy::StealItem]
  attr_reader :steals
  attr_reader :steal_bonus

  def init_steal_data
    return if @steal_data_init
    @steal_data_init = true
    @steal_bonus = 0
    @steals = []
    @gold_steal = nil
    self.note.split(/[\n\r]+/).each do |line|
      # noinspection RegExpSingleCharAlternation
      case line
      when /<steal (item|armor|weapon) (\d+):[ ]*(\d+)%>/i
        @steals.push(StealItem.new($1.downcase.to_sym, $2.to_i, $3.to_i))
      when /<steal (i|a|w):(\d+) (\d+)%>/i
        # legacy
        type = {:i => :item, :w => :weapon, :a => :armor}[$1.downcase.to_sym]
        @steals.push(StealItem.new(type, $2.to_i, $3.to_i))
      when /<steal gold: [ ]*(\d+)>/i
        @gold_steal = $1.to_i
      when /<steal bonus:[ ]*([+\-]\d+)%>/i
        @steal_bonus = $1.to_f / 100
      else
        # type code here
      end
    end
  end

  # restituisce l'ammontare dell'oro che può essere
  # rubato
  def robbery_amount
    return @gold_steal if @gold_steal
    return 0 unless StealSettings::AUTO_ROBBERY_CALC
    eval(StealSettings::ROBBERY_DEFAULT_CALC)
  end

  class StealItem
    attr_reader :kind
    attr_reader :data_id
    attr_reader :probability

    def initialize(kind, data_id, probability)
      if kind.is_a?(Symbol)
        kind = {:item => 1, :weapon => 2, :armor => 3}[kind]
      end
      @probability = probability
      @data_id = data_id
      @kind = kind
    end

    # restituisce l'istanza dell'oggetto rubabile
    # @return [RPG::BaseItem]
    def item
      case @kind
      when 1; $data_items[@data_id]
      when 2; $data_weapons[@data_id]
      when 3; $data_armors[@data_id]
      else; nil
      end
    end
  end
end

class RPG::UsableItem

  # inizializza i dati del furto
  def init_steal_data
    return if @steal_data_init
    @steal_data_init = true
    @steal_skill = false
    @robbery_skill = false
    self.note.split(/[\n\r]+/).each do |line|
      case line
      when /<steal skill>/i
        @steal_skill = true
      when /<robbery skill>/i
        @robbery_skill = true
      else
        # type code here
      end
    end
  end

  # determina se è una skill in grado di rubare oggetti
  def steal?
    @steal_skill
  end

  # determina se è una skill in grado di rubare oro
  def robbery?
    @robbery_skill
  end
end

module DataManager
  class << self
    alias steal_normal_database load_normal_database
    alias steal_bt_database load_battle_test_database
  end

  def self.load_normal_database
    steal_normal_database
    $data_enemies.each { |enemy| enemy.init_steal_data if enemy }
    $data_armors.each { |armor| armor.init_steal_data if armor }
    $data_weapons.each { |weapon| weapon.init_steal_data if weapon }
    $data_skills.each { |skill| skill.init_steal_data if skill }
    $data_states.each { |state| state.init_steal_data if state }
  end
end

class Game_Battler
  alias steal_damage make_obj_damage_value unless $@

  # @param [Game_Battler] user
  # @param [RPG::UsableItem] obj
  def make_obj_damage_value(user, obj)
    steal_damage(user, obj)
    steal_action(user) if obj.steal?
    robbery_action(user) if obj.robbery?
  end

  # non implementato. Va nelle sottoclassi
  # @param [Game_Battler] target
  def steal_action(target)
    fail NotImplementedError
  end

  # non implementato. Va nelle sottoclassi
  # @param [Game_Battler] user
  def robbery_action(user)
    fail NotImplementedError
  end

  # probabilità di rubare (o farsi derubare, se è un nemico)
  # @return [Float]
  def steal_rate
    1.0 + features_sum(:steal_bonus)
  end
end

class Game_Actor < Game_Battler
  # azione per essere derubato dal nemico
  # @param [Game_Enemy] user
  def steal_action2(user)
    stolen_item = try_steal(user)
    if stolen_item
      add_drop stolen_item
      message = sprintf(Vocab::STEAL_SUCCESS_ENEMY, user.name, stolen_item.name)
      $scene.push_popup(message, stolen_item.icon_index)
    end
  end

  # @param [Game_Enemy] user
  # @return [RPG::BaseItem]
  # noinspection RubyUnusedLocalVariable
  def try_steal(user)
    items = $game_party.items.compact.select {|item| item.stealable?}
    return nil if items.empty?
    stolen_item = items.sample
    $game_party.lose_item(stolen_item, 1)
    stolen_item
  end
end

class Game_Enemy < Game_Battler
  alias h87_steal_setup initialize

  # inizializzazione
  def initialize(index, enemy_id)
    h87_steal_setup(index, enemy_id)
    @steal_items = enemy.steals.clone
    @robbery_done = enemy.robbery_amount == 0
  end

  # restituisce la lista degli oggetti ancora rubabili
  # @return [Array<RPG::Enemy::StealItem>]
  def steal_items
    @steal_items
  end

  # determina se il nemico non ha oggetti da rubare
  def no_steals?
    @steal_items.empty?
  end

  # azione di essere rubato dall'eroe
  # @param [Game_Actor] user
  def steal_action(user)
    if no_steals?
      message = sprintf(Vocab::NOTHING_TO_STEAL_ENEMY, self.name)
      $scene.push_popup(message, StealSettings::NO_STEAL_ICON)
    else
      item = try_steal(user)
      if item
        #noinspection RubyYardParamTypeMatch
        $game_party.gain_item(item, 1)
        message = sprintf(Vocab::STEAL_SUCCESS_ACTOR, user.name, item.name)
        $scene.push_popup(message, item.icon_index)
      else
        message = sprintf(Vocab::FAILED_STEAL, user.name)
        $scene.push_popup(message, StealSettings::NO_STEAL_ICON)
      end
    end
  end

  # prova ad essere rubato e restituisce
  # l'oggetto se ci riesce, altrimenti nil
  # @param [Game_Actor] user
  # @return [RPG::BaseItem]
  def try_steal(user)
    @steal_items.shuffle.each do |steal_item|
      probability = steal_item.probability * calculate_steal_prob(user)
      if probability > rand(100)
        @steal_items.delete steal_item
        return steal_item.item
      end
    end
    nil
  end

  # azione che fa subire il furto
  # @param [Game_Actor] user
  def robbery_action(user)
    if @robbery_done
      message = sprintf(Vocab::ROBBERY_NOTHING, self.name)
      $scene.push_popup(message, StealSettings::NO_STEAL_ICON)
      return
    end
    result = try_robbery(user)
    if result
      message = sprintf(Vocab::STEAL_SUCCESS_ACTOR, result)
      $scene.push_popup(message, StealSettings::ROBBERY_ICON)
      @robbery_done = true
      $game_party.gain_gold(result)
    else
      message = sprintf(Vocab::FAILED_STEAL, user.name)
      $scene.push_popup(message, StealSettings::NO_STEAL_ICON)
    end
  end

  # prova a rubare soldi e restituisce il valore o nil se fallisce
  # @param [Game_Actor] user
  def try_robbery(user)
    probability = StealSettings::DEFAULT_ROBBERY_PROBABILITY * calculate_steal_prob(user)
    if probability > rand(100)
      @robbery_done = true
      enemy.robbery_amount
    else
      nil
    end
  end

  # calcola le probabilità di default per rubare gli oggetti
  # aumenta se il bersaglio è incapacitato
  # @param [Game_Actor] user
  def calculate_steal_prob(user)
    # parriable? definito in RGSS2 come può schivare
    # noinspection RubyResolve
    sleep_mul = parriable? ? 1 : StealSettings::SLEEP_MULTIPLIER
    user.steal_rate * steal_rate * sleep_mul
  end
end