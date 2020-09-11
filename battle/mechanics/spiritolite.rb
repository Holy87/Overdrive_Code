module H87_SPIRIT_STONE
  # Probabilità di successo di base, cioè con HP del nemico pieni
  # e livello del nemico simile a quello del gruppo.
  BASE_SUCCESS_RATE = 0.2

  EXCLUDED_SOUL_TYPES = [17]

  ELE_RANKS_TYPES = {
      17 => :human, 18 => :bug, 19 => :beast, 20 => :dragon, 21 => :undead,
      22 => :bird, 23 => :rectile, 24 => :plant, 25 => :magic
  }

  ITEMS = {
      :bug => :green, :plant => :green,
      :beast => :yellow, :bird => :yellow,
      :rectile => :red, :dragon => :red,
      :undead => :blue, :magic => :blue
  }

  LEVEL = {
      :green => [174,175,176],
      :yellow => [177,178,179],
      :red => [180,181,182],
      :blue => [183,184,185]
  }

  ALREADY_USED_VOCAB = 'Hai già assorbito l\'anima di %s!'
  UNABSORBIBLE_VOCAB = 'Non puoi assorbire l\'anima di %s.'
  ABSORB_SUCCESS_VOCAB = 'Hai assorbito l\'anima di %s!'
  ABSORB_FAILED_VOCAB = 'Non sei riuscito ad assorbire l\'anima di %s.'
  ABSORB_FAILED_ICON = 0
  ABSORB_SUCCESS_ICON = 0

  def self.proper_item(type, level)
    item_type = ITEMS[type]
    return if item_type.nil?
    item_id = LEVEL[item_type][index_level(level)]
    return $data_items[item_id]
  end

  def self.index_level(level)
    case level
    when 1..25
      return 0
    when 26..50
      return 1
    when 51..99
      return 2
    else
      0
    end
  end

end

class Game_Enemy < Game_Battler
  alias h87spiritol_init initialize unless $@

  # inizializzazione del nemico nel troop
  # @param [Integer] index
  # @param [Integer] enemy_id
  def initialize(index, enemy_id)
    h87spiritol_init(index, enemy_id)
    @spirit_stone_used = false
  end

  # restituisce i tipi del nemico assorbibili
  # @return [Array<RPG::Element_Data>]
  def enemy_type_souls
    excluded = H87_SPIRIT_STONE::EXCLUDED_SOUL_TYPES
    enemy.enemy_types.select { |t| !excluded.include?(t.id) }
  end

  private

  # processo di assorbimento dell'anima
  # @param [Game_Actor] user
  # @param [RPG::UsableItem] obj
  def absorb_soul_process(user, obj)
    return spirit_stone_used_message if @spirit_stone_used
    return no_souls_message if enemy_type_souls.empty?
    if calc_soul_absorb_rate(user, obj) > rand
      soul_absorb_action(obj)
    else
      soul_absorb_failed
    end
  end

  # manda il popup di spirit_stone già usata
  def spirit_stone_used_message
    text = sprintf(H87_SPIRIT_STONE::ALREADY_USED_VOCAB, name)
    $scene.push_popup(text, H87_SPIRIT_STONE::ABSORB_FAILED_ICON)
  end

  # manda il popup di spirit_stone non possibile
  def no_souls_message
    text = sprintf(H87_SPIRIT_STONE::UNABSORBIBLE_VOCAB, name)
    $scene.push_popup(text, H87_SPIRIT_STONE::ABSORB_FAILED_ICON)
  end

  # manda il popup di assorbimento spirit_stone riuscito
  # @param [RPG::BaseItem] obj
  def soul_absorb_action(obj)
    type = enemy_type_souls.sample.id
    add_drop(get_spirit_stone(type))
    text = sprintf(H87_SPIRIT_STONE::ABSORB_SUCCESS_VOCAB, name)
    $scene.push_popup(text, obj.icon_index)
  end

  # manda il popup di assorbimento spirit_stone fallito
  def soul_absorb_failed
    text = sprintf(H87_SPIRIT_STONE::ABSORB_FAILED_VOCAB, name)
    $scene.push_popup(text, H87_SPIRIT_STONE::ABSORB_FAILED_ICON)
  end

  # ottiene la probabilità di riuscita della spirit_stone
  # @param [Game_Actor] user
  # @param [RPG::UsableItem] obj
  # @return [Float]
  def calc_soul_absorb_rate(user, obj)
    rate = H87_SPIRIT_STONE::BASE_SUCCESS_RATE
    rate *= user.level.to_f / enemy.level.to_f
    rate *= (2 - hp_rate)
    rate.to_f
  end

  # genera l'oggetto della spirit_stone a seconda del tipo
  # e del livello ottenuto
  # @param [Integer] type
  # @return [RPG::Item]
  def get_spirit_stone(type)
    H87_SPIRIT_STONE.proper_item(type, enemy.level)
  end
end

class Game_Battler
  alias h87spiritol_obj_damage make_obj_damage_value unless $@

  # make object damage value
  # @param [Game_Battler] user
  # @param [RPG::UsableItem] obj
  def make_obj_damage_value(user, obj)
    h87spiritol_obj_damage(user, obj)
    try_absorb_soul(user, obj)
  end

  # @param [Game_Battler] user
  # @param [RPG::UsableItem] obj
  def try_absorb_soul(user, obj)
    return if actor?
    return unless obj.spirit_stone
    absorb_soul_process(user, obj)
  end
end
