module StatusAffinitySettings
  STATE_RANKS = {
    # ID          A      B      C      D      E      F
      130 => [   40,    20,    10,     5,     1,     0], # combustione
      131 => [   40,    20,    10,     5,     1,     0], # congelam.
      132 => [   40,    20,    10,     5,     1,     0], # shock.
      133 => [  100,   100,   100,     0,     0,     0], # congelam.
  }
end

class Game_Battler
  alias h87_st_aff_execute_damage execute_damage

  # determina il bonus/malus applicato allo status da equipaggiamenti
  # e status. Da NON confondere con la probabilità dello stato.
  def state_rate(state_id)
    features_sum :state_defense_rate, state_id
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
    if StatusAffinitySettings::STATE_RANKS.keys.include? state_id
      probability = custom_rank(state_id)
    else
      probability = default_rank(state_id)
    end
    return probability if probability <= 0
    return probability if probability >= 100
    [[100, probability + state_rate(state_id)].min, 0].max
  end
end

class Game_Actor < Game_Battler
  alias default_rank state_probability unless $@

  def state_probability(state_id)
    dynamic_state_probability(state_id)
  end

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

  def state_probability(state_id)
    dynamic_state_probability(state_id)
  end
end