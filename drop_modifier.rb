require 'rm_vx_data'

module DROP_MOD_SETTINGS

end

module DROP_MOD_CORE
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  REGEXP_EXP_BONUS = /<bonus exp:[ ]*([+\-]\d+)[%％]>/i
  REGEXP_GOLD_BONUS = /<bonus oro:[ ]*([+\-]\d+)[%％]>/i
  REGEXP_DROP_BONUS = /<bonus drop:[ ]*([+\-]\d+)[%％]>/i
  REGEXP_JP_BONUS = /<bonus jp:[ ]*([+\-]\d+)[%％]>/i
end

module Drop_Common
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  attr_reader :exp_bonus
  attr_reader :drop_bonus
  attr_reader :gold_bonus
  attr_reader :jp_bonus
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def drop_attr_init
    return if @drop_attr_initialized
    @drop_attr_initialized = true
    @exp_bonus = 0
    @drop_bonus = 0
    @gold_bonus = 0
    @jp_bonus = 0
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
        when DROP_MOD_CORE::REGEXP_DROP_BONUS
          @drop_bonus = $1.to_i
        when DROP_MOD_CORE::REGEXP_EXP_BONUS
          @exp_bonus = $1.to_i
        when DROP_MOD_CORE::REGEXP_GOLD_BONUS
          @gold_bonus = $1.to_i
        when DROP_MOD_CORE::REGEXP_JP_BONUS
          @jp_bonus = $1.to_i
        else
          # niente
      end
    }
  end
end

class RPG::State; include Drop_Common; end
class RPG::Weapon; include Drop_Common; end
class RPG::Armor; include Drop_Common; end

class Game_Battler
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def drop_bonus; features_sum('drop_bonus'); end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def exp_bonus; features_sum('exp_bonus'); end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def gold_bonus; features_sum('exp_bonus'); end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def jp_bonus; features_sum('jp_bonus'); end
end

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def drop_bonus
    bonus = 0
    members.each{|member| bonus += member.drop_bonus}
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def gold_bonus
    bonus = 0
    members.each {|member| bonus += member.gold_bonus}
  end
end

class Game_Troop < Game_Unit
  alias h87_drop_gold_total gold_total unless $@
  alias h87_drop_make_drop make_drop_items unless $@
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def gold_multiplier
    $game_party.gold_bonus / 100.0 + 1
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def gold_total
    (h87_drop_gold_total * gold_multiplier).to_i
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def make_drop_items
    drop_items = []
    dead_members.each {|enemy|
      drop_rate = calc_drop_rate(enemy)
      [enemy.drop_item1, enemy.drop_item2].each{|di|
        next if di.kind == 0
        next if rand((di.denominator / drop_rate).to_i) != 0
        if di.kind == 1
          drop_items.push($data_items[di.item_id])
        elsif di.kind == 2
          drop_items.push($data_weapons[di.weapon_id])
        elsif di.kind == 3
          drop_items.push($data_armors[di.armor_id])
        end
      }
    }
  end
  #--------------------------------------------------------------------------
  # *
  # @param [Game_Enemy] enemy
  #--------------------------------------------------------------------------
  def calc_drop_rate(enemy)
    rate = 1.0
    rate += $game_party.drop_bonus
    rate += enemy.drop_bonus
    [0.01, rate].max # per evitare che restituisca 0
  end
end