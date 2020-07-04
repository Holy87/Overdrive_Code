$imported = {} if $imported == nil
$imported["H87_VariableStats"] = true
# ==============================================================================
#  ** PARAMETRI VARIABILI di Holy87
#  -----------------------------------------------------------------------------
#  Descrizione:
#  Questo script permette ai parametri di eroi e nemici di aumentare o diminuire
#  sotto determinate condizioni (HP/MP/Furia bassi)
#
#  Utilizzo:
#  Inserire nelle note di equip/nemici/status tag con questo pattern:
#  <hp min atk: +30>  -> aumenta l'attacco di 30 quando gli HP sono bassi
#  <mp min spi: +50%> -> aumenta lo Spirito del 50% quando gli MP sono bassi
#  -----------------------------------------------------------------------------

module VariableStatsConfig
  #-----------------------------------------------------------------------------
  # * Configura qual è la percentuale al di sotto del quale si attiva il bonus
  #-----------------------------------------------------------------------------
  HP_CRISIS_RATE = 25 # % di hp sotto il quale si attiva il bonus
  MP_CRISIS_RATE = 20 # % di mp sotto il quale si attiva il bonus
  FU_CRISIS_RATE = 20 # % di furia sotto il quale si attiva il bonus
end

module VariableStats
  HMPLOW = /<(.*)[ ]min[ ](.*):[ ]*([+\-]\d+)>/i
  HMPLOWP= /<(.*)[ ]min[ ](.*):[ ]*([+\-]\d+)([%％])>/i
  #-----------------------------------------------------------------------------
  # * Caricamento delle informazioni
  #-----------------------------------------------------------------------------
  def load_variable_stats
    return if @var_stat_loaded
    @var_stat_loaded = true
    @hmplow = {}
    @hmplowp = {}
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
      when HMPLOW
        param1 = $1.downcase.to_sym
        param2 = $2.downcase.to_sym
        stat = $3.to_i
        next unless [:hp,:mp,:fu].include?(param1)
        next unless [:atk,:def,:spi,:agi,:cri,:hit,:eva,:odd].include?(param2)
        @hmplow[param1] = {} if @hmplow[param1].nil?
        @hmplow[param1][param2] = stat
      when HMPLOWP
        param1 = $1.downcase.to_sym
        param2 = $2.downcase.to_sym
        stat = $3.to_f/100.0
        next unless [:hp,:mp,:fu].include?(param1)
        next unless [:atk,:def,:spi,:agi].include?(param2)
        @hmplowp[param1] = {} if @hmplowp[param1].nil?
        @hmplowp[param1][param2] = stat
      else
        # type code here
      end
    }
  end
  #-----------------------------------------------------------------------------
  # * Restituisce il bonus del parametro richiesto
  #    param1: attivazione critica (hp o mp)
  #    param2: parametro bonus
  #-----------------------------------------------------------------------------
  def crisis_param(param1, param2)
    return 0 if @hmplow[param1].nil?
    return 0 if @hmplow[param1][param2].nil?
    @hmplow[param1][param2]
  end
  #-----------------------------------------------------------------------------
  # * Restituisce il bonus moltiplicatore del parametro richiesto
  #    param1: attivazione critica (hp o mp)
  #    param2: parametro bonus
  #-----------------------------------------------------------------------------
  def crisis_param_perc(param1, param2)
    return 0 if @hmplowp[param1].nil?
    return 0 if @hmplowp[param1][param2].nil?
    @hmplowp[param1][param2]
  end

end

class RPG::Weapon
  #-----------------------------------------------------------------------------
  # * Inclusione della funzione dello script
  #-----------------------------------------------------------------------------
  include VariableStats
end

class RPG::Armor
  #-----------------------------------------------------------------------------
  # * Inclusione della funzione dello script
  #-----------------------------------------------------------------------------
  include VariableStats
end

class RPG::State
  #-----------------------------------------------------------------------------
  # * Inclusione della funzione dello script
  #-----------------------------------------------------------------------------
  include VariableStats
end

class RPG::Enemy
  #-----------------------------------------------------------------------------
  # * Inclusione della funzione dello script
  #-----------------------------------------------------------------------------
  include VariableStats
end

class Game_Battler
  unless $@
    alias v_s_atk atk
    alias v_s_def def
    alias v_s_spi spi
    alias v_s_agi agi
  end

  # Restituisce true se gli HP sono inferiori alla soglia  critica
  def in_hp_crisis?
    rate = VariableStatsConfig::HP_CRISIS_RATE
    (self.hp.to_f/self.maxhp)< rate.to_f/100
  end

  # Restituisce true se gli MP sono inferiori alla soglia critica
  def at_mp_limit?
    rate = VariableStatsConfig::MP_CRISIS_RATE
    (self.mp.to_f/self.maxmp) < rate.to_f/100
  end

  def at_fury_limit?
    return false unless charge_gauge?
    rate = VariableStatsConfig::FU_CRISIS_RATE
    (self.anger.to_f/self.max_anger) < rate.to_f/100
  end
  #-----------------------------------------------------------------------------
  # * Parametro di modifica dell'attacco
  #-----------------------------------------------------------------------------
  def atk
    param_adder(v_s_atk,:atk)
  end
  #-----------------------------------------------------------------------------
  # * Parametro di modifica della difesa
  #-----------------------------------------------------------------------------
  def def
    param_adder(v_s_def,:def)
  end
  #-----------------------------------------------------------------------------
  # * Modifica dello spirito
  #-----------------------------------------------------------------------------
  def spi
    param_adder(v_s_spi,:spi)
  end
  #-----------------------------------------------------------------------------
  # * Modifica della velocità
  #-----------------------------------------------------------------------------
  def agi
    param_adder(v_s_agi,:agi)
  end
  #-----------------------------------------------------------------------------
  # * Processo che modifica il parametro
  #    value: valore iniziale del parametro
  #    param: parametro da vedere (atk, def, spi, agi, cri, eva, hit, odd)
  #-----------------------------------------------------------------------------
  def param_adder(value, param)
    return value unless $game_temp.in_battle
    adder = 0
    mult = 1.0
    if in_hp_crisis?
      adder += get_crisis_param(:hp, param)
      mult += get_crisis_param_perc(:hp, param)
    end
    if at_mp_limit?
      adder += get_crisis_param(:mp, param)
      mult += get_crisis_param_perc(:mp, param)
    end
    if at_fury_limit?
      adder += get_crisis_param(:fu, param)
      mult += get_crisis_param_perc(:fu, param)
    end
    value += adder
    (value.to_f*mult).to_i
  end

  # Ottiene il bonus parametro
  #    param1: hp o mp
  #    param2: parametro da vedere (atk, def, spi, agi, cri, eva, hit, odd)
  def get_crisis_param(param1, param2)
    0
  end

  # Ottiene il bonus parametro in percentuale
  #    param1: hp o mp
  #    param2: parametro da vedere (atk, def, spi, agi, cri, eva, hit, odd)
  def get_crisis_param_perc(param1, param2)
    0
  end
end

class Game_Actor < Game_Battler
  unless $@
    alias v_s_cri cri
    alias v_s_hit hit
    alias v_s_eva eva
    alias v_s_odd odds
  end
  #-----------------------------------------------------------------------------
  # * Restituisce la percentuale di critici modificata
  #-----------------------------------------------------------------------------
  def cri
    param_adder(v_s_cri,:cri)
  end
  #-----------------------------------------------------------------------------
  # * Restituisce la percentuale di mira
  #-----------------------------------------------------------------------------
  def hit
    param_adder(v_s_hit,:hit)
  end
  #-----------------------------------------------------------------------------
  # * Restituisce la percentuale di evasione modificata
  #-----------------------------------------------------------------------------
  def eva
    param_adder(v_s_eva,:eva)
  end
  #-----------------------------------------------------------------------------
  # * Restituisce il valore d'odio modificato
  #-----------------------------------------------------------------------------
  def odds
    param_adder(v_s_odd, :odd)
  end

  # gets the crisis param
  def get_crisis_param(param1, param2)
    adder = states.inject(0) { |sum, state| sum + state.crisis_param(param1, param2) }
    equips.compact.inject(adder) { |sum, equip| sum + equip.crisis_param(param1, param2) }
  end

  def get_crisis_param_perc(param1, param2)
    multiplier = states.inject(0.0) { |sum, state| sum + state.crisis_param_perc(param1, param2) }
    equips.compact.inject(multiplier) { |sum, equip| sum + equip.crisis_param_perc(param1, param2) }
  end
end

class Scene_Title < Scene_Base
  #-----------------------------------------------------------------------------
  # * Caricamento del database
  #-----------------------------------------------------------------------------
  alias v_s_load_database load_database unless $@
  def load_database
    v_s_load_database
    load_crisis_bonus
  end
  #-----------------------------------------------------------------------------
  # * Caricamento del database per test battaglia
  #-----------------------------------------------------------------------------
  alias v_s_load_bt_database load_bt_database unless $@
  def load_bt_database
    v_s_load_bt_database
    load_crisis_bonus
  end
  #-----------------------------------------------------------------------------
  # * Modifica del database per includere le informazioni sui bonus
  #-----------------------------------------------------------------------------
  def load_crisis_bonus
    for weapon in $data_weapons
      next if weapon.nil?
      weapon.load_variable_stats
    end
    for armor in $data_armors
      next if armor.nil?
      armor.load_variable_stats
    end
    for state in $data_states
      next if state.nil?
      state.load_variable_stats
    end
    for enemy in $data_enemies
      next if enemy.nil?
      enemy.load_variable_stats
    end
  end
end