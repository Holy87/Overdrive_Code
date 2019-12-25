# questa classe serve per gestire gli elementi ed attributi in modo corretto
# mi serve per gestire elementi, attributi e debolezze di tipo con relative icone

module Element_Settings
  WEAPON_ATTRIBUTES = [1, 2, 3, 4]
  ELEMENTS = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
  ENEMY_TYPES = [17, 18, 19, 20, 21, 22, 23, 24, 25]

  ICONS = {
      1 => 541, 2 => 539, 3 => 540, 4 => 542, 6 => 239,
      7 => 1098, 8 => 1099, 9 => 104, 10 => 105,
      11 => 106, 12 => 107, 13 => 108, 14 => 109,
      15 => 110, 16 => 111
  }

  MULTIPLE_REGEX = /\[(.+\/.+)\]/

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
  # @return [String]
  def singular(str)
    str.split('/').first
  end

  # @param [String] str
  # @return [String]
  def plural(str)
    str.split('/').last
  end
end

class RPG::Enemy
  # restituisce i tipi a cui appartiene il nemico
  # @return [Array<RPG::Element_Data>]
  def enemy_types
    $data_system.enemy_types.select { |type| self.element_ranks[type.id] < 3}
  end
end

class RPG::UsableItem
  include ItemElements
end

class RPG::Armor
  include ItemElements
end

class RPG::Weapon
  include ItemElements
end