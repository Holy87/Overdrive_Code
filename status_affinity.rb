module StatusAffinitySettings
  STATE_RANKS = {
    # ID          A      B      C      D      E      F
      130 => [   40,    20,    10,     5,     1,     0], # combustione
      131 => [   40,    20,    10,     5,     1,     0], # congelam.
      132 => [   40,    20,    10,     5,     1,     0], # shock.
      133 => [  100,   100,     0,     0,     0,     0], # congelam.
  }

  # immunità personalizzate con condizione
  # ID => condizione
  CUSTOM_IMMUNITIES = {
    # immune a disarmo se è già disarmato
    119 => Proc.new{ |battler| battler.actor? and battler.unarmed? }
  }

  def self.default_state_rank(state_id)
    custom_ranks = STATE_RANKS[state_id]
    return 30 if custom_ranks.nil?
    custom_ranks[2]
  end
end

class Game_Battler
  alias h87_st_aff_execute_damage execute_damage

  # determina il bonus/malus applicato allo status da equipaggiamenti
  # e status. Da NON confondere con la probabilità dello stato.
  def state_rate(state_id)
    #noinspection RubyResolve
    return 100 if $data_states[state_id].nonresistance
    features_sum :state_defense_rate, state_id
  end

  def state_probability(state_id)
    dynamic_state_probability(state_id)
  end

  def state_rank(state_id)
    0 # definito nelle sottoclssi
  end

  def custom_rank(state_id)
    StatusAffinitySettings::STATE_RANKS[state_id][state_rank(state_id)]
  end

  # calcola la probabilità dello status. Se il rank di default
  # è 0 o 100, restituisce il valore senza applicare bonus/malus.
  # @param [Fixnum] state_id
  def dynamic_state_probability(state_id)
    return 0 if immunity_by_condition? state_id
    if StatusAffinitySettings::STATE_RANKS.keys.include? state_id
      probability = custom_rank(state_id)
    else
      probability = default_rank(state_id)
    end
    return probability if probability <= 0
    return probability if probability >= 100
    [[100, probability + state_rate(state_id) + state_rate(:all)].min, 0].max
  end

  def immunity_by_condition?(state_id)
    return false unless StatusAffinitySettings::CUSTOM_IMMUNITIES.keys.include?(state_id)
    StatusAffinitySettings::CUSTOM_IMMUNITIES[state_id].call(self)
  end
end

class Game_Actor < Game_Battler
  alias default_rank state_probability unless $@

  def state_rank(state_id)
    #noinspection RubyResolve
    self.class.state_ranks[state_id]
  end
end

class Game_Enemy < Game_Battler
  alias default_rank state_probability unless $@

  def state_rank(state_id)
    #noinspection RubyResolve
    enemy.state_ranks[state_id]
  end
end