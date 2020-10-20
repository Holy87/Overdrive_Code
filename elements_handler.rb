# questa classe serve per gestire gli elementi ed attributi in modo corretto
# mi serve per gestire elementi, attributi e debolezze di tipo con relative icone
# Modifiche ad equip
# <amplify element x: y%> - uguale allo script di Yanfly, aumenta i danni dell'
# elemento x dell'y%. A differenza dello script di Yanfly, viene incrementato solo nelle skill
# magiche.
# <amplify heal: x%> aumenta le cure date dell'x%.
# I

module Element_Settings
  WEAPON_ATTRIBUTES = [1, 2, 3, 4]
  ELEMENTS = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 26]
  ENEMY_TYPES = [17, 18, 19, 20, 21, 22, 23, 24, 25]

  ICONS = {
      1 => 541, 2 => 539, 3 => 540, 4 => 542, 7 => 239,
      8 => 1099, 9 => 104, 10 => 105,
      11 => 106, 12 => 107, 13 => 108, 14 => 109,
      15 => 110, 16 => 111, 26 => 1278
  }

  # Tabella dei rate di danno per attributi arma, elementi e tipi nemici
  RATE_TABLE = {
      # RANK:             A    B    C    D   E  F
      :attributes => [0, 200, 150, 100, 50, 25, 0],
      :elements   => [0, 200, 150, 100, 50,  0, -100],
      :types      => [0, 200, 200,  0,   0,  0, 0]
  }

  MULTIPLE_REGEX = /\[(.+\/.+)\]/
  ELEMENT_AMPLIFY_REGEX = /<amplify[ _]element[ ]+(\d+)[ ]*:[ ]*([+\-]\d+)%>/i
  HEAL_AMPLIFY_REGEX = /<amplify[ _]heal[ ]*:[ ]*([+\-]\d+)%>/i
  ELEMENT_DEFENSE = /<element[ _]rate[ ]+(\d+)[ ]*:[ ]*([+\-]\d+)%>/i

  # icon index
  # @return [Integer]
  # @param [Integer] element_id
  def self.icon(element_id)
    ICONS[element_id] || 0
  end

  # attribute type
  def self.type(element_id)
    return 0 if WEAPON_ATTRIBUTES.include? element_id
    return 1 if ELEMENTS.include? element_id
    return 2 if ENEMY_TYPES.include? element_id
    nil
  end
end

module DataManager
  class << self
    alias elem_load_normal_database load_normal_database
    alias elem_load_battle_test_database load_battle_test_database
  end

  def self.load_normal_database
    elem_load_normal_database
    load_element_data
  end

  def self.load_battle_test_database
    elem_load_battle_test_database
    load_element_data
  end

  # @param [Array<DataElements>] collection
  def self.parse_element_data(collection)
    collection.compact.each { |obj| obj.init_element_modifiers }
  end

  def self.load_element_data
    parse_element_data $data_armors
    parse_element_data $data_weapons
    parse_element_data $data_states
    parse_element_data $data_enemies
  end
end

module DataElements
  attr_reader :element_amplify
  attr_reader :heal_amplify
  attr_reader :element_rate_set

  def init_element_modifiers
    @element_amplify = {}
    @heal_amplify = 0
    @element_rate_set = {}
    self.note.split(/[\r\n]+/).each { |row|
      case row
      when Element_Settings::ELEMENT_AMPLIFY_REGEX
        @element_amplify[$1.to_i] = $2.to_i
      when Element_Settings::HEAL_AMPLIFY_REGEX
        @heal_amplify = $1.to_i
      when Element_Settings::ELEMENT_DEFENSE
        @element_rate_set[$1.to_i] = $2.to_i
      else
        # type code here
      end
    }
  end

  # @param [Integer] element_id
  # @return [Float]
  def element_amplify_rate(element_id)
    return 0.0 if @element_amplify[element_id].nil?
    @element_amplify[element_id].to_f / 100.0
  end

  def element_defense_rate(element_id)
    return 0 if @element_rate_set[element_id].nil?
    @element_rate_set[element_id]
  end
end

module ItemElements
  # @return [Array<RPG::Element_Data>]
  def damage_types
    return [] unless $data_system
    $data_system.weapon_attributes.select {|attr| @element_set.include?(attr.id)}
  end

  # @return [Array<RPG::Element_Data>]
  def magic_elements
    return [] unless $data_system
    $data_system.magic_elements.select {|attr| @element_set.include?(attr.id)}
  end

  # @return [Array<RPG::Element_Data>]
  def monster_type_effectiveness
    return [] unless $data_system
    $data_system.enemy_types.select {|attr| @element_set.include?(attr.id)}
  end
end

class RPG::System
  # all the attribute/element data
  # @return [Array<RPG::Element_Data>]
  def elements_data
    @elements_data ||= init_elements_data
  end

  # @param [Integer] element_id
  # @return [RPG::Element_Data, nil]
  def element_by_id(element_id)
    elements_data.select { |e| e.id == element_id }.first
  end

  # initializes the elements data
  # @return [Array<RPG::Element_Data>]
  def init_elements_data
    @elements_data = []
    @elements.each_index do |ele_id|
      @elements_data.push(RPG::Element_Data.new(ele_id))
    end
    @elements_data
  end

  # gli attributi di danno definiti nel sistema
  # @return [Array<RPG::Element_Data>]
  def weapon_attributes
    elements_data.select {|ele| ele.weapon_attribute?}
  end

  # gli elementi di base definiti nel sistema
  # @return [Array<RPG::Element_Data>]
  def magic_elements
    elements_data.select {|ele| ele.element?}
  end

  # i tipi di nemici definiti nel sistema
  # @return [Array<RPG::Element_Data>]
  def enemy_types
    elements_data.select {|ele| ele.enemy_type?}
  end

  # ottiene l'icona dell'elemento
  # @param [Integer] attribute_id
  # @return [Integer]
  def attribute_icon(attribute_id)
    elements_data.select {|ele| ele.id == attribute_id}.first.icon_index
  end

  alias element_icon attribute_icon
end

class RPG::Element_Data
  # @return [Integer] element ID
  attr_reader :id
  # @return [Integer] the icon index
  attr_reader :icon_index
  # @return [String] the element name
  attr_reader :name
  # @return [Integer] the element type
  attr_reader :type

  def initialize(element_id)
    @id = element_id
    @icon_index = Element_Settings::icon element_id
    @name = $data_system.elements[element_id]
    @type = Element_Settings::type element_id
  end

  # restituisce la tabella dei rate
  # @return [Array<Integer>]
  def rate_table
    return Element_Settings::RATE_TABLE[:attributes] if weapon_attribute?
    return Element_Settings::RATE_TABLE[:types] if enemy_type?
    Element_Settings::RATE_TABLE[:elements]
  end

  # il rate minmo dell'elemento
  # @return [Integer, nil]
  def min_rate
    rate_table.last
  end

  # il rate massimo dell'elemento
  # @return [Integer, nil]
  def max_rate
    rate_table.first
  end

  # determina se è un tipo danno delle armi
  def weapon_attribute?
    @type == 0
  end

  # determina se è un tipo elementale
  def element?
    @type == 1
  end

  # determina se è un tipo di nemico
  def enemy_type?
    @type == 2
  end

  # nome al plurale
  # @return [String]
  def name
    if Element_Settings::MULTIPLE_REGEX.match(@name)
      str = $1
      @name.gsub(Element_Settings::MULTIPLE_REGEX, '')  + plural(str)
    else
      @name
    end
  end

  # nome al singolare
  # @return [String]
  def singular_name
    if Element_Settings::MULTIPLE_REGEX.match(@name)
      str = $1
      @name.gsub(Element_Settings::MULTIPLE_REGEX, '')  + singular(str)
    else
      @name
    end
  end

  # @return [String]
  def to_s
    sprintf('[%d] %s - Tipo %s', @id, @name, @type)
  end

  private

  # @param [String] str
  # @return [String, nil]
  def singular(str)
    str.split('/').first
  end

  # @param [String] str
  # @return [String, nil]
  def plural(str)
    str.split('/').last
  end
end

class RPG::Enemy
  include DataElements
  # restituisce i tipi a cui appartiene il nemico
  # @return [Array<RPG::Element_Data>]
  def enemy_types
    #noinspection RubyResolve
    $data_system.enemy_types.select { |type| self.element_ranks[type.id] < 3}
  end
end

class RPG::UsableItem
  include ItemElements
end

class RPG::Armor
  include DataElements
  include ItemElements
end

class RPG::Weapon
  include DataElements
  include ItemElements
end

class RPG::State
  include DataElements
end

class Game_Battler
  alias h87_elements_make_obj_damage_value make_obj_damage_value
  # @param [Integer] element_id
  # @return [String]
  def element_rank(element_id)
    'C'
  end

  def element_rate(element_id)
    element = $data_system.element_by_id element_id
    rank = element_rank(element_id)
    result = element.rate_table[rank] + features_sum(:element_defense_rate, element_id)
    [[result, element.min_rate].max, element.max_rate].min
    result /= 2 if states.any? { |state| state.element_set.include?(element_id) }
    result
  end

  # @param [Game_Actor, Game_Enemy] user
  # @param [RPG::UsableItem, RPG::Skill, RPG::Item] obj
  def make_obj_damage_value(user, obj)
    h87_elements_make_obj_damage_value(user, obj)
    @hp_damage *= max_amplifier(user, obj)
    @mp_damage *= max_amplifier(user, obj)
  end

  # @param [RPG::UsableItem] obj
  # @param [Game_Enemy, Game_Actor] user
  # @return [Float]
  def max_amplifier(user, obj)
    return 1.0 unless obj.is_a?(RPG::Skill)
    return user.heal_power_rate if obj.base_atk < 0
    obj.element_set.max_by{|ele_id| user.element_amplifier(ele_id)}
  end

  def heal_power_rate
    heal_power / 100.0 + 1
  end

  def heal_power
    features_sum :heal_amplify
  end

  def element_amplifier(element_id)
    1.0 + features_sum(:element_amplify_rate, element_id)
  end

end

class Game_Enemy < Game_Battler
  # @param [Integer] element_id
  # @return [String]
  def element_rank(element_id)
    #noinspection RubyResolve
    enemy.element_ranks[element_id]
  end
end

class Game_Actor < Game_Battler

  # @param [Integer] element_id
  # @return [String]
  def element_rank(element_id)
    #noinspection RubyResolve
    self.class.element_ranks[element_id]
  end

  def element_rate(element_id)
    result = super
    result /= 2 if armors.compact.any? { |eq| eq.element_set.include?(element_id) }
    result
  end
end