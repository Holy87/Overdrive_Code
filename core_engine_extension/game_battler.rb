#==============================================================================
# ** Game_Battler
#---------------------------------------------------------------------------
# Vari metodi per il combattente
#==============================================================================
# noinspection RubyUnusedLocalVariable
class Game_Battler
    unless $@
      alias :h87attr_att_eff :attack_effect
      alias :h87attr_skill_effect :skill_effect
      alias :h87attr_plus_state_set :plus_state_set
      alias :h87attr_minus_state_set :minus_state_set
      alias :make_attack_damage_value_ht :make_attack_damage_value
      alias :make_obj_damage_value_ht :make_obj_damage_value
      #noinspection RubyResolve
      alias :make_obj_absorb_effect_ht :make_obj_absorb_effect
      alias :h87attr_execute_damage :execute_damage
      alias :h87attr_item_effect :item_effect
      alias :run_cdf2 :run_cdf
      alias :tau_mp_cost :calc_mp_cost
      alias :h87attr_item_test :item_test
      alias :h87_attr_state_prob :state_probability
      alias :h87status_as :add_state
      alias :h87status_rs :remove_state
      alias :h87hp :hp
      alias :h87attr_hp :hp=
      alias :h87attr_apply_state_changes :apply_state_changes
      alias :h87attr_element_set :element_set
      alias :h87attr_slip_damage_effect :slip_damage_effect
      alias :h87attr_skill_can_use :skill_can_use?
    end
  
    # @return [Integer] ammontare dell'ultimo attacco ricevuto
    attr_accessor :last_damage
    # @return [Integer] ammontare di tutti i danni ricevuti fino ad ora
    attr_accessor :cumuled_damage
    # @return [Integer] la skill bloccata
    attr_accessor :blocked_skill
    # @return [Integer] l'ultima skill usata (per bloccarla)
    attr_reader :last_skill_used
  
    # il valore del parametro Attacco senza moltiplicatori
    def static_atk
      base_atk + @atk_plus
    end
  
    def static_def
      base_def + @def_plus
    end
  
    def static_spi
      base_spi + @spi_plus
    end
  
    def static_agi
      base_agi + @agi_plus
    end
  
    def static_maxhp
      base_maxhp + @maxhp_plus
    end
  
    def static_maxmp
      base_maxmp + @maxmp_plus
    end
  
    def native_atk
      static_atk
    end
  
    def native_spi
      static_spi
    end
  
    def native_def
      static_def
    end
  
    def native_agi
      basic_agi
    end
  
    def native_hit
      95
    end
  
    def native_eva
      5
    end
  
    def native_cri
      4
    end
  
    def native_cri_dmg
      3.0
    end
  
    # @param [Integer] value
    # @param [Symbol] param
    # @return [Integer]
    def apply_multiplier(value, param)
      multiplier = features_sum(:stat_bonus, param)
      (value * (multiplier.to_f / 100 + 1)).to_i
    end
    
    def maxhp
      apply_multiplier(static_maxhp, :maxhp)
    end
  
    def maxmp
      apply_multiplier(static_maxmp, :maxmp)
    end
  
    # Restituisce l'attacco dell'eroe. Riscritto completamente.
    def atk
      apply_multiplier(static_atk, :atk)
    end
  
    # modifica del valore di difesa
    def def
      apply_multiplier(static_def, :def)
    end
  
    # modifica del valore spirito
    def spi
      apply_multiplier(static_spi, :spi)
    end
  
    # modifica del valore agilità
    def agi
      apply_multiplier(static_agi, :spi)
    end
  
    # modifica del valore critico
    def cri
      native_cri + features_sum(:cri)
    end
  
    def hit
      native_hit + features_sum(:hit)
    end
  
    def eva
      native_eva + features_sum(:eva)
    end
  
    # Restituisce il danno critico
    def cri_dmg
      native_cri_dmg + features_sum(:critical_damage)
    end
  
    # Attributi statici (modificati poi nelle sottoclassi)
  
    #taumaturgico?
    def taumaturgic?
      false
    end
  
    # usa la furia?
    def charge_gauge?
      has_feature? :use_anger
    end
  
    def mp_gauge?
      mmp > 0
    end
  
    #ha due armi?
    def has2w
      false
    end
  
    #bombificato?
    def bombified?
      false
    end
  
    # imposta l'ID dell'ultima abilità usata
    # @param [Integer] skill_id
    # @return [Integer]
    def set_last_skill_used(skill_id)
      @last_skill_used = skill_id
    end
  
    # Inizializza le variabili ad inizio battaglia
    def init_for_battle
      check_last_chance
      @attack_action_executed = false
      self.last_damage = 0
      self.cumuled_damage = 0
    end
  
    # Restituisce le feature
    # @return [Array<RPG::State>]
    def features
      states
    end
  
    # @return [Array<Integer>]
    def state_ids
      @states
    end
  
    # Restituisce la somma di un attributo delle caratteristiche
    # @param [Symbol] feature_name
    # @param [Object] param
    def features_sum(feature_name, param = nil)
      return features_sum_with_param(feature_name, param) if param
      features.inject(0) { |s, ft| s + ft.send(feature_name) }
    end
  
    def features_sum_with_param(feature_name, param)
      features.compact.inject(0.0) { |s, ft| s + ft.send(feature_name, param) }
    end
  
    # Restituisce un valore da un array
    # @param [Symbol] feature_name
    # @return [Array]
    def feature_array(feature_name)
      features.inject([]) { |ary, ft| ary + ft.send(feature_name) }
    end
  
    # Restituisce true se tra le caratteristiche ce n'è una con un attributo
    def has_feature?(feature_name)
      features.select{ |ft| return true if ft.has?(feature_name) }.any?
    end
  
    # Restituisce l'incremento in battaglia di un determinato parametro
    # @param [String] param
    # @return [Integer, Float]
    def increased_param(param)
      @increased_params = {} if @increased_params.nil?
      return 0 if @increased_params[param].nil?
      @increased_params[param]
    end
  
    def state_guard
      has_feature? :state_guard
    end
  
    # Incrementa un parametro
    # @param [String] param
    # @param [Integer, Float] value
    # @param [Boolean] overbuff se può aumentare oltre il limite
    def param_incr(param, value, overbuff = false)
      @increased_params = {} if @increased_params.nil?
      @increased_params[param] = 0 if @increased_params[param].nil?
      @increased_params[param] += value
    end
  
    # Resetta i parametri (dopo la fine della battaglia)
    def reset_params
      @increased_params = {}
    end
  
    # @return [Float]
    def heal_rate
      #noinspection RubyYardReturnMatch
      [1.0 + (features_sum(:heal_rate) / 100.0), 0.0].max
    end
  
    # @return [Hash{Fixnum->Fixnum}]
    def custom_slip_damages
      @slip_damages ||= {}
    end
  
    # @param [RPG::State] state
    def apply_custom_slip_damage(state)
      return if state.slip_damage_per <= 0
      @slip_damages ||= {}
      damage = (@hp_damage * state.slip_damage_per).to_i
      if @slip_damages[state.id].nil? || @slip_damages[state.id] < damage
        @slip_damages[state.id] = damage
      end
    end
  
    def remove_slip_damage(state_id)
      @slip_damages ||= {}
      @slip_damages.delete(state_id)
    end
  
    # fortuna
    def luck
      H87AttrSettings::BASE_LUCK + features_sum(:luck)
    end
  
    # Restituisce il bonus consumo PM
    def mp_cost_rate
      [1.0 + features_sum(:mp_cost_rate), 0].max
    end
  
    # Restituisce il rateo del danno
    def damage_rate
      1.0 + features_sum(:damage_rate)
    end
  
    # Restituisce la percentuale di protezione della barriera
    def barrier_rate
      [0.0 + features_sum(:barrier_rate), 1].min
    end
  
    # Restituisce il rapporto di consumo HP/MP della barriera
    def barrier_consume_rate
      base = H87AttrSettings::BARRIER_MP_CONSUME
      [base + features_sum(:barrier_save), 0.01].max
    end
  
    # Restituisce il rateo del danno magico
    def magic_damage_rate
      1.0 + features_sum(:magic_dmg)
    end
  
    # Restituisce la difesa magica
    def magic_def
      [1.0 + features_sum(:magic_def), 0].max
    end
  
    # Restituisce il rateo del riflesso danno fisico
    def physical_reflect
      features_sum(:physical_reflect)
    end
  
    # restituisce la quanità di MP che ricarica attaccando
    def mp_on_attack
      features_sum(:mp_on_attack)
    end
  
    # restituisce il rateo vampiro
    def vampire_rate
      features_sum(:vampire_rate)
    end
  
    # Bonus iniziale per infliggere status
    def state_inf_bon
      features_sum(:state_inf_bon)
    end
  
    # Bonus iniziale per infliggere status (in percentuale)
    def state_inf_per
      features_sum(:state_inf_per)
    end
  
    # Bonus iniziale per durata status (in percentuale)
    def state_inf_dur
      features_sum(:state_inf_dur)
    end
  
    # Modificatore della durata del buff
    def buff_modificator
      features_sum(:buff_durability)
    end
  
    # Modificatore della durata dei debuff
    def debuff_modificator
      features_sum(:debuff_durability)
    end
  
    # Modificatore della probabilità di resistere agli status (perc)
    def state_probability_perc
      features_sum(:state_inflict_perc)
    end
  
    # Modificatore della probabilità di resistere agli status
    def state_probability_adder
      features_sum(:state_def_bonus)
    end
  
    # Restituisce il bonus mastery riferito ad un parametro
    def mastery(param)
      0
    end
  
    # Restituisce il bonus drop. Viene sovrascritto da Game_Enemy
    def spoil_bonus
      1.0
    end
  
    # Modificatore del costo di un tipo di abilità
    def cost_type(type)
      features_sum(:cost_skill, type)
    end
  
    # Restituisce gli stati che rimuove
    def minus_state_set
      h87attr_minus_state_set + custom_minus_state_set
    end
  
    # Restituisce gli stati che aggiunge
    def plus_state_set
      h87attr_plus_state_set + custom_plus_state_set
    end
  
    # Restituisce true se il battler ha ultima chance
    def has_last_chance?
      has_feature?(:last_chance)
    end
  
    # Restituisce true se il battler attacca a distanza
    def ranged_attack?
      has_feature?(:ranged)
    end
  
    # Ha uno stato di zombie?
    def zombie?
      has_feature?(:zombie_state)
    end
  
    def rune?
      has_feature?(:rune)
    end
  
    def can_parry?
      has_feature? :parry
    end
  
    # questa condizione viene utilizzata nel DMG Formula di Yanfly.
    def avoid_defense?
      has_feature? :avoid_defense
    end
  
    def protected?
      false
    end
  
    def protector?
      false
    end
  
    # Restituisce il danno critico (per mostrare con percentuale)
    def crd
      (cri_dmg * 100).to_i
    end
  
    # Restituisce il bonus percentuale per infliggere stati alterati
    def stpw
      (state_inf_per * 100).to_i
    end
  
    # Restituisce la percentuale di influenza dello Spirito sull'attacco
    # fisico.
    def attack_magic_rate
      features_sum(:magic_attack)
    end
  
    def hp_on_guard?
      hp_on_guard_rate > 0
    end
  
    def mp_on_guard?
      mp_on_guard_rate > 0
    end
  
    def fu_on_guard?
      fu_on_guard_rate > 0
    end
  
    # il rateo di cura HP quando ci si difende
    def hp_on_guard_rate
      features_sum :hp_on_guard
    end
  
    # il rateo di cura MP quando ci si difende
    def mp_on_guard_rate
      features_sum :mp_on_guard
    end
  
    # il rateo di cura Furia quando ci si difende
    def fu_on_guard_rate
      features_sum :fu_on_guard
    end
  
    def hp_on_guard_value
      (mhp * hp_on_guard_rate).to_i
    end
  
    def mp_on_guard_value
      (mmp * mp_on_guard_rate).to_i
    end
  
    def fu_on_guard_value
      (max_anger * fu_on_guard_rate).to_i
    end
  
    # determina se l'attacco è basato dallo spirito
    def attack_with_magic?
      false
    end
  
    # Restituisce la rabbia accumulata
    def anger
      @anger = 0 if @anger.nil?; @anger
    end
  
    # Imposta l'ira
    def anger=(value)
      return unless charge_gauge?
      @anger = [[0, value].max, max_anger].min
    end
  
    # Restituisce il rate dell'ira
    def anger_rate
      anger.to_f / max_anger
    end
  
    # Restituisce l'ira massima
    def max_anger
      H87AttrSettings::DEFAULT_MAX_CHARGE + max_anger_bonus
    end
  
    # Restituisce il valore d'incremento dell'ira
    def anger_incr
      H87AttrSettings::DEFAULT_ANGER_INCR + anger_bonus
    end
  
    # Restituisce il bonus dell'ira massima
    def max_anger_bonus
      features_sum(:max_anger_bonus)
    end
  
    # Restituisce il bonus d'ira
    def anger_bonus
      features_sum(:anger_bonus)
    end
  
    # Ira iniziale
    def initial_anger
      rand(10) + initial_anger_bonus
    end
  
    # Restituisce il bonus di ira iniziale
    def initial_anger_bonus
      features_sum(:anger_init)
    end
  
    # Inizializza la barra Ira
    def initialize_anger
      self.anger = [self.anger, initial_anger].max if charge_gauge?
    end
  
    # Restituisce true se ha un'abilità o un equip che gli ricarica l'ira
    def anger_on_damage
      features_sum :anger_damage
    end
  
    # Restituisce l'ammontare di ira ricevuta per uccidere un nemico
    def anger_kill
      features_sum(:anger_kill)
    end
  
    # Restituisce la furia che si accumula ad ogni turno
    def anger_turn
      features_sum(:anger_turn)
    end
  
    def last_skill_blocked?
      has_feature? :block_last_skill
    end
  
    def boss_type?
      false
    end
  
    def evaded?
      @evaded
    end
  
    def missed?
      @missed
    end
  
    def damage_avoided?
      evaded? or missed?
    end
  
    # Nuova formula
    def run_cdf(user, obj, formula)
      @ignore_mpd = false
      run_cdf2(user, obj, formula)
    end
  
    # @return [Array<RPG::Skill>]
    def assimilable_skills
      []
    end
  
    def assimilated?(skill)
      false
    end
  
    # restituisce gli stati aggiunti nel turno
    # ho preferito riscriverlo per ottimizzare quello di default
    # @return [Array<RPG::State>]
    def added_states
      #noinspection RubyResolve
      @added_states.map{|state_id| $data_states[state_id]}
    end
  
    # restituisce gli stati rimossi nel turno
    # ho preferito riscriverlo per ottimizzare quello di default
    # @return [Array<RPG::State>]
    def removed_states
      #noinspection RubyResolve
      @removed_states.map{|state_id| $data_states[state_is]}
    end
  
    # Effetto attacco
    # @param [Game_Battler] attacker
    def attack_effect(attacker)
      @bomb = bombified?
      h87attr_att_eff(attacker)
      if damage_avoided? and can_parry? and !attacker.ranged_attack?
        attacker.make_attack_damage_value(self)
        SceneManager.scene.force_damage_pop(attacker, self.animation_id)
      end
      remove_vanish_attack_states(attacker)
    end
  
    # @param [Game_Battler] attacker
    def remove_vanish_attack_states(attacker)
      attacker.states.select { |state| state.vanish_on_attack? }.each { |state| attacker.remove_state(state.id) }
    end
  
    # Effetto skill
    # @param [Game_Battler] user
    # @param [RPG::Skill] skill
    def skill_effect(user, skill)
      @bomb = bombified?
      h87attr_skill_effect(user, skill)
      remove_vanish_attack_states(user) if skill.for_opponent? and damaged?
    end
  
    def custom_slip_damage_sum
      @slip_damages ||= {}
      @slip_damages.values.inject(0) { |i, d| i + d }
    end
  
    # Aggiungo controlli all'attacco
    # @param [Game_Battler] attacker
    def make_attack_damage_value(attacker)
      if attacker.attack_with_magic?
        make_magic_damage_value(attacker)
      else
        make_attack_damage_value_ht(attacker)
      end
      @hp_damage = (@hp_damage * CPanel::TSWRate).to_i if attacker.has2w
      change_damage_rate
      apply_barrier_protection if @hp_damage > 0
      apply_mp_on_attack(attacker)
    end
  
    # calcolo il danno in base allo spirito
    # @param [Game_Battler] attacker
    def make_magic_damage_value(attacker)
      damage = (attacker.spi * attacker.attack_magic_rate * 2).to_i
      damage -= self.def
      if $imported["CustomElementAffinity"]
        # noinspection RubyArgCount
        damage *= elements_max_rate(attacker.element_set, attacker)
      else
        damage *= elements_max_rate(attacker.element_set)
      end
      damage /= 100
  
      damage = apply_variance(damage, 20)
      damage = apply_guard(damage)
      damage = apply_magical_rate(attacker, damage, nil)
      @hp_damage = damage
    end
  
    # applica la cura MP quando si causa danno
    # @param [Game_Battler] user Chi usa l'oggetto o l'abilità
    # @param [RPG::UsableItem] obj Potere o oggetto (Se è nil è un attacco normale)
    def apply_auto_mp_heal(user, obj)
      return if obj.mp_heal_per == 0
      return if @hp_damage <= 0
      user.mp_damage -= (obj.mp_heal_per * @hp_damage ).to_i
      @absorbed = true
    end
  
    # Aggiunta di controlli a una skill
    # I risultati sono assegnati a @hp_damage o @mp_damage.
    # @param [Game_Battler] user Chi usa l'oggetto o l'abilità
    # @param [RPG::UsableItem] obj Potere o oggetto (Se è nil è un attacco normale)
    def make_obj_damage_value(user, obj)
      @skill_state_inflict = obj
      @user_state_inflict = user
      make_obj_damage_value_ht(user, obj)
      @hp_damage = apply_magical_rate(user, @hp_damage, obj)
      change_damage_rate
      @mp_damage = apply_magical_rate(user, @mp_damage, obj)
      apply_zombie_modificator(obj)
      apply_rune
      apply_magic_damage_multiplier(obj)
      apply_heal_rate
    end
  
    def make_obj_absorb_effect(user, obj)
      make_obj_absorb_effect_ht(user, obj)
      apply_auto_mp_heal(user, obj)
    end
  
    # @param [RPG::UsableItem] obj
    def apply_zombie_modificator(obj)
      if @hp_damage < 0 and obj.base_damage < 0 and zombie?
        @hp_damage *= -1
      end
    end
  
    def apply_rune
      if rune? && @hp_damage != 0 #se è in rune, assorbi i danni
        @mp_damage = @hp_damage.abs / -200
        @hp_damage = 0
      end
    end
  
    # @param [RPG::UsableItem] obj
    def apply_magic_damage_multiplier(obj)
      if obj.mp_damage_per > 0 and @hp_damage > 0
        @mp_damage = (@hp_damage * obj.mp_damage_per).to_i
      end
    end
  
    def apply_heal_rate
      if @hp_damage < 0
        @hp_damage = (@hp_damage * heal_rate).to_i
      end
      if @mp_damage < 0
        @mp_damage = (@mp_damage * heal_rate).to_i
      end
    end
  
    # processo di esecuzione del danno
    # @param [Game_Battler] user
    def execute_damage(user, no_action = false)
      obj = no_action ? nil : user.action.action_object
      ranged = obj.nil? ? user.ranged_attack? : obj.ranged?
      if obj
        recharge_all if obj.skill_recharge?
        $game_party.tank.gain_aggro(obj.tank_odd) if obj.tank_odd > 0
        apply_debuff_change(user) if obj.debuff_pass
        user.cumuled_damage = 0 if obj.reset_damage
        apply_assimilate_effect(user, obj)
      end
      if damaged?
        apply_barrier_protection
        apply_transfer_damage
        @last_damage = @hp_damage
        self.cumuled_damage += @hp_damage
        damage_states(obj)
        hit_states(user, obj)
        magic_states(user, obj)
        apply_anger_change(user, obj)
        unless ranged && user == self
          apply_physical_reflect(user)
          apply_counter_states(user)
          apply_vampire(user)
        end
      end
      h87attr_execute_damage(user)
      remove_barriers if self.mp <= 0
  
      @skill_state_inflict = nil
      @user_state_inflict = nil
    end
  
    # applica gli stati negativi propri sul nemico
    # @param [Game_Battler] user
    def apply_debuff_change(user)
      user.states.each do |state|
        if Stati::Negativi.include?(state.id) and !self.states.include?(state)
          if self.state_probability(state.id) > 0
            self.add_state(state.id)
            user.remove_state(state.id)
          end
        end
      end
    end
  
    # @param [Game_Actor] user
    # @param [RPG::Skill] skill
    def apply_assimilate_effect(user, skill)
      return unless skill.is_a?(RPG::Skill)
      return unless skill.assimilate?
      return unless $game_temp.in_battle
      skills = assimilable_skills.select { |skill| user.assimilable?(skill) }
      if skills.any?
        chosen_skill = skills.sample
        text = sprintf(H87AttrSettings::ASSIMILATED_MESSAGE, user.name,
                       chosen_skill.name, self.name)
        $scene.push_popup(text, chosen_skill.icon_index)
        user.assimilate(chosen_skill)
      else
        $scene.push_popup(H87AttrSettings::CANNOT_ASSIMILATE)
      end
    end
  
    # applica i cambiamenti di stato
    # @param [RPG::Skill] obj
    def apply_state_changes(obj)
      h87attr_apply_state_changes(obj)
      return unless $game_temp.in_battle
      return unless obj
      return if obj.is_a?(Game_Battler)
      return unless obj.buff_steal
      user = $scene.active_battler
      apply_buff_steal(obj, user)
      set_custom_slip_damage_states
    end
  
    def set_custom_slip_damage_states
      added_states.each { |state| apply_custom_slip_damage(state) }
    end
  
    # applica il furto di stati. Non funziona con status che hanno priorità 0 o 10.
    # @param [RPG::UsableItem] obj
    # @param [Game_Battler] user
    def apply_buff_steal(obj, user)
      self.states.each do |state|
        if state.priority > 1 and state.priority < 10 and !user.states.include?(state)
          user.add_state(state.id)
          self.remove_state(state.id)
        end
      end
    end
  
    # applica l'aumento di Furia
    # @param [Game_Battler] user
    # @param [RPG::UsableItem] obj
    def apply_anger_change(user, obj = nil)
      return unless user.charge_gauge?
      if obj.nil?
        incr = user.anger_incr
        incr /= 2 if user.has2w
      else
        incr = obj.anger_rate
      end
      user.anger += incr
      self.anger += anger_on_damage
    end
  
    # applica il riflesso del danno fisico
    # @param [Game_Battler] user
    def apply_physical_reflect(user)
      return if physical_reflect <= 0
      damage_val = apply_variance(((@hp_damage + @mp_damage) * physical_reflect).to_i, 10)
      user.hp_damage += damage_val
      $scene.force_damage_pop(user, H87AttrSettings::DAMAGE_REFLECT_ANIM_ID)
    end
  
    # applica l'assorbimento di PV a tutto il gruppo
    # @param [Game_Battler] user
    # @param [RPG::UsableItem] obj
    def apply_party_absorb(user, obj)
      return unless obj.absorb_damage_party
      #noinspection RubyResolve
      return if obj.spi_f == 0
      check_party_absorb_heal(user, obj)
    end
  
    # applica il risucchio PV se ha vamp_rate > 0
    # @param [Game_Battler] user
    def apply_vampire(user)
      return if user.vampire_rate <= 0
      hp_dmg = (@hp_damage * (user.vampire_rate + 1)).to_i
      mp_dmg = (@mp_damage * (user.vampire_rate + 1)).to_i
      user.hp_damage -= hp_dmg
      user.mp_damage -= mp_dmg
      $scene.force_damage_pop(user, H87AttrSettings::VAMPIRE_ANIM_ID)
    end
  
    # @param [Game_Battler] user
    def apply_mp_on_attack(user)
      return if @hp_damage <= 0
      return if user.mp_on_attack <= 0
      user.mp_damage -= user.mp_on_attack
      $scene.force_damage_pop(user)
    end
  
    # applica la protezione della barriera
    def apply_barrier_protection
      return unless barrier_rate > 0
      protection = @hp_damage * barrier_rate
      @hp_damage = (@hp_damage - protection).to_i
      @mp_damage += [(protection * barrier_consume_rate).to_i, 1].max
    end
  
    # determina se si può utilizzare l'abilità
    # @param [RPG::Skill] skill
    def skill_can_use?(skill)
      return false unless h87attr_skill_can_use(skill)
      return false if skill.can_tau? && !taumaturgic? && !$game_temp.in_battle
      return false if charge_gauge? && calc_anger_cost(skill) > self.anger
      return false if last_skill_blocked? && skill.id == @last_skill_blocked
      false if $game_party.req_menu_witch(skill)
      if enemy?
        if skill.only_for_domination?
          return false if $game_party.members.select { |member| member.domination? }.empty?
        end
        if skill.only_for_actor?
          return false if $game_party.members.select { |member| !member.domination? and member.alive? }.empty?
        end
      end
      true
    end
  
    # Restituisce il costo ira dell'abilità
    # @param [RPG::Skill] skill
    # @return [Integer]
    def calc_anger_cost(skill)
      return 0 unless charge_gauge?
      cost = skill.anger_cost
      cost /= 2 if half_mp_cost
      (cost * self.mp_cost_rate).to_i
    end
  
    # distrugge le barriere
    # noinspection RubyArgCount
    def remove_barriers
      found = false
      @states.each { |state_id|
        state = $data_states[state_id]
        if state.barrier_rate > 0
          found = true
          remove_state(state_id)
        end
      }
      RPG::SE.new(H87AttrSettings::BARRIER_BREAK_SE).play if found
      found
    end
  
    # Controlla e attiva gli status che si attivano con l'attacco
    def activate_hit_states
      hit_states = get_hit_states_array
      hit_states.each do |hit|
        add_state(hit[0]) if hit[1] > rand
      end
    end
  
    # Controlla e attiva gli status che si attivano con il danno
    def activate_damage_states
      damage_states = get_damage_states_array
      damage_states.each do |damage|
        add_state(damage[0]) if damage[1] > rand
      end
    end
  
    # Ottiene l'array degli status attivabili con l'attacco
    def get_hit_states_array
      array = []
      self.states.each { |state|
        array.push([state.status_hit, state.status_hit_prob]) if state.status_hit > 0
        array.push([state.id, 100]) if state.viral?
      }
      if actor?
        equips.each { |equip|
          next if equip.nil?
          array.push([equip.status_hit, equip.status_hit_prob]) if equip.status_hit > 0
        }
      end
      array
    end
  
    # Ottiene l'array degli status attivabili con il danno
    def get_damage_states_array
      array = []
      self.states.each { |state|
        array.push([state.status_dmg, state.status_dmg_prob]) if state.status_dmg > 0
        array.push([state.id, 100]) if state.viral?
      }
      equips.each { |equip|
        next if equip.nil?
        array.push([equip.status_dmg, equip.status_dmg_prob]) if equip.status_dmg > 0
      }
      array
    end
  
    # Restituisce true se viene danneggiato
    # noinspection RubyResolve
    def damaged?
      (@hp_damage > 0 || @mp_damage > 0) && !@missed
    end
  
    # applica gli stati del danno
    # @param [Game_Battler] attacker
    def apply_counter_states(attacker)
      counter_states.each { |state_id|
        state = RPG::States[state_id]
        next if attacker.states.include?(state)
        if rand(100) < state_probability(state_id)
          attacker.add_state(state_id)
        end
      }
    end
  
    # applica le cure bonus su comando Difendi
    def apply_guard_bonus
      if hp_on_guard?
        @hp_damage = hp_on_guard_value * -1
        a_id = H87AttrSettings::GUARD_HP_HEAL_ANIMATION_ID
        $scene.force_damage_pop(self, a_id)
      end
      if mp_on_guard?
        @mp_damage = mp_on_guard_value * -1
        a_id = H87AttrSettings::GUARD_MP_HEAL_ANIMATION_ID
        $scene.force_damage_pop(self, a_id)
      end
      if fu_on_guard?
        self.anger += fu_on_guard_value
      end
    end
  
    # Modifica il danno con attacco critico
    # @param [Integer] damage
    # @return [Integer]
    def critical_damage(damage)
      (self.cri_dmg * damage).to_i
    end
  
    # Imposta il modificatore del danno
    def change_damage_rate
      return if @hp_damage <= 0
      return if damage_rate == 1
      @hp_damage = [(@hp_damage * damage_rate).to_i, 0].max
    end
  
    # Restituisce il moltiplicatore del costo dell'abilità a seconda del tipo
    def cost_types(skill)
      sum = 0.0
      skill.sk_types.each { |type| sum += cost_type(type) }
      sum
    end
  
    # Triplo consumo se taumaturgica
    def calc_mp_cost(skill)
      return 0 if charge_gauge?
      if skill.can_tau? && !$game_temp.in_battle && taumaturgic?
        mp_cost = tau_mp_cost(skill) * 3
      else
        mp_cost = tau_mp_cost(skill)
      end
      mp_cost = (mp_cost.to_f * (mp_cost_rate + cost_types(skill))).to_i
    end
  
    # Restituisce gli stati d'attacco rimossi dagli status
    def custom_minus_state_set
      states = []
      self.states.each { |state|
        next if state.nil?
        states |= state.attack_minus_states
      }
      states
    end
  
    # Restituisce gli stati d'attacco aggiunti dagli status
    def custom_plus_state_set
      states = []
      self.states.each { |state|
        next if state.nil?
        states |= state.attack_plus_states
      }
      states
    end
  
    # restituisce l'array dei controstati
    # @return [Array]
    def counter_states
      feature_array :counter_states
    end
  
    # Aggiunta effetto cura Ira
    def item_effect(user, item)
      h87attr_item_effect(user, item)
      unless self.skipped
        if charge_gauge? and item.anger_rate > 0
          self.anger += item.anger_rate
        end
      end
    end
  
    # Item test per oggetti che caricano l'ira
    def item_test(user, item)
      if charge_gauge?
        return false if dead?
        return true if item.anger_rate > 0 and self.anger < max_anger
        return false if item.parameter_type == 2
      end
      h87attr_item_test(user, item)
    end
  
    # Restituisce la cura di gruppo di un assorbimento vampirico
    def check_party_absorb_heal(user, obj)
      if user.actor?
        party = $game_party
        sprites = $scene.spriteset.actor_sprites
      else
        party = $game_troop
        sprites = $scene.spriteset.enemy_sprites
      end
      members = party.members.select { |member| !member.dead? }
      return if members.size == 0
      heal = [self.hp, @hp_damage].min / members.size
      members.each { |member|
        member.hp += heal
        sprites[member.index].damage_pop(heal)
        member.animation_id = 441
      }
    end
  
    # Restituisce il bonus gruppo al parametro
    # @param [Integer] value
    # @param [String] param
    # @return [Integer]
    def party_bonus(value, param = nil)
      value
    end
  
    # Applica il rateo del danno magico
    # @param [Game_Battler] user
    # @param [Integer] damage
    # @param [RPG::UsableItem,RPG::Skill,RPG::Item] skill
    def apply_magical_rate(user, damage, skill)
      return damage unless damage > 0
      return damage unless skill != nil and skill.spi_f <= 0
      (damage * (1.0 + (user.magic_damage_rate - self.magic_def).to_f)).to_i
    end
  
    # Resistenza del personaggio alla magia
    def res
      (magic_def * 100).to_i - 100
    end
  
    # Moltiplicatore di danno delle magie
    def mdmg
      (magic_damage_rate * 100).to_i - 100
    end
  
    def offensive_magic_states
      feature_array :offensive_magic_states
    end
  
    def heal_magic_states
      feature_array :heal_magic_states
    end
  
    # Alias del metodo probabilità status
    def state_probability(state_id)
      value = h87_attr_state_prob(state_id)
      state = $data_states[state_id]
      value += apply_linked_element @skill_state_inflict, state
      value /= 2 if guard? and state_guard and !state.nonresistance
      return value if value == 0 or value >= 100
      apply_state_bm(value, @user_state_inflict, @skill_state_inflict, state)
    end
  
    # aggiungi uno stato
    # @param [Integer] state_id
    # @param [RPG::Item, RPG::Skill] skill
    def add_state(state_id, skill = nil)
      state = $data_states[state_id]
      return if state == nil # I dati sono invalidi?
      #da rgss2
      #noinspection RubyResolve
      return if state_ignore?(state_id) # È uno stato da ignorare?
      h87status_as(state_id)
      check_block_skill_message(state)
      check_durability_bonus(state, skill)
    end
  
    def remove_state(state_id)
      h87status_rs(state_id)
      remove_slip_damage(state_id)
      remove_skill_lock(state_id)
    end
  
    def remove_skill_lock(state_id)
      state = $data_states[state_id]
      return unless state.has? :block_last_skill
      @last_skill_blocked = nil
    end
  
    def slip_damage_effect
      h87attr_slip_damage_effect
      @hp_damage /= H87_Settings::BOSS_SLIP_DIVISOR if boss_type?
      @hp_damage += apply_variance(custom_slip_damage_sum, 10)
    end
  
    # assegna l'ID della skill bloccata a seconda dell'ultima
    # abilità usata e mostra il messaggio di skill bloccata
    # @param [RPG::State] state
    def check_block_skill_message(state)
      return unless state.has? :block_last_skill
      return if @last_skill_used.nil?
      return if @last_skill_used == 0
      @last_skill_blocked = @last_skill_used
      message = '%s non può più usare %s!'
      skill = $data_skills[@last_skill_used]
      message = sprintf(message, self.name, skill.name)
      SceneManager.scene.push_popup(message, state.icon_index)
    end
  
    # Controlla il bonus durata
    # @param [RPG::State] state
    # @param [RPG::Item, RPG::Skill] skill
    def check_durability_bonus(state, skill)
      return unless state.auto_release_prob > 0 and state.hold_turn >= 0
      return if state.fixed_duration?
      return unless $game_temp.in_battle
      user = $scene.active_battler
      turns = (state_duration(user, skill, state) + @state_turns[state.id]).to_i
      @state_turns[state.id] = turns
    end
  
    # Controlla il bonus durata (in turni)
    # @param [Game_Battler] user
    # @param [RPG::Item, RPG::Skill] skill
    # @param [RPG::State] state
    def state_duration(user, skill, state)
      modificator = 0
      modificator += user.state_inf_dur if user != nil
      modificator += buff_modificator if state.buff?
      modificator += debuff_modificator if state.debuff?
      modificator += skill.state_inf_dur if skill
      modificator
    end
  
    # Applicazione del bonus malus
    # @param [Integer] value
    # @param [Game_Battler] user
    # @param [RPG::Skill] skill
    # @param [RPG::State] state
    def apply_state_bm(value, user, skill, state)
      return value if skill.ignore_bonus || state.ignore_bonus
      bonus = state_prob_mult(skill, user, state) + 1.0
      adder = state_prob_adder(skill, user, state)
      #if skill.atk_f > 0 #se è una skill fisica
      # bonus += (user.atk.to_f + adder) / self.def*1.5
      #end
      #if skill.spi_f > 0 #se è una skill magica
      # bonus += (user.spi.to_f + adder) / self.def*(self.magic_def) + (magic_damage_rate-1)/2
      #end
      (value * bonus.to_f).to_i
    end
  
    # @param [RPG::Skill] skill
    # @param [RPG::State] state
    def apply_linked_element(skill, state)
      return 0 unless state.linked_to_element?
      element_rate(state.linked_element) - 100
    end
  
    # Restituisce il moltiplicatore di probabilità di infliggere lo status
    # @param [Game_Battler] user
    # @param [RPG::Skill] skill
    # @param [RPG::State] state
    def state_prob_mult(skill, user, state)
      bonus = skill.state_inf_per
      bonus += user.state_inf_per
      bonus += state.state_inf_per
    end
  
    # Restituisce la probabilità aggiuntiva di infliggere lo status
    # @param [Game_Battler] user
    # @param [RPG::Skill] skill
    # @param [RPG::State] state
    def state_prob_adder(skill, user, state)
      bonus = skill.state_inf_bon
      bonus += user.state_inf_bon
      bonus += state.state_inf_bon
    end
  
    # Controlla gli stati attivabili tramite danno e aumenta la barra se è una
    # dominazione ed è dotata di bonus.
    def damage_states(obj = nil)
      if obj.nil? || obj.base_damage > 0
        if actor?
          activate_damage_states
          increase_charge if self.rech_bonus?
        end
      end
    end
  
    # Controlla gli stati attivabili tramite attacco
    def hit_states(user, obj = nil)
      return unless user.actor?
      user.activate_hit_states if obj.nil? || obj.base_damage > 0
    end
  
    # procede con gli status applicati dalle magie
    # @param [Game_Battler] user
    # @param [RPG::Item, RPG::Skill] obj
    def magic_states(user, obj)
      return if obj.nil?
      return if user.nil?
      if @hp_damage > 0 or @mp_damage > 0
        user.offensive_magic_states.each { |s| valuate_magic_states(s, obj) }
      end
      if @mp_damage < 0 or @hp_damage < 0
        user.heal_magic_states.each { |s| valuate_magic_states(s, obj) }
      end
    end
  
    # @param [Integer] state_id
    # @param [RPG::Item, RPG::Skill] skill
    def valuate_magic_states(state_id, skill)
      return if state_probability(state_id) <= 0
      return if states.include?(state_id)
      add_state(state_id, skill) if rand(100) < state_probability(state_id) / 2
    end
  
    # Restituisce il danno accumulato
    def cumuled_damage
      @cumuled_damage = 0 if @cumuled_damage.nil?
      @cumuled_damage
    end
  
    # Incrementa la durata della dominazione
    # noinspection RubyResolve
    def increase_charge
      $game_temp.domination_energy += CPanel::CHARGEDOMATTACK
    end
  
    # Restituisce gli status virali
    def viral_states
      self.states.compact.select { |state| state.viral? }
    end
  
    # Restituisce lo status virale
    def infected
      viral_state = viral_states.first
      viral_state ? viral_state.id : 0
    end
  
    # Attiva lo stato di protezione ultima chance
    def check_last_chance
      @last_chance_on = has_last_chance?
    end
  
    # Restituisce true se l'eroe ha ultima chance attiva
    def last_chance?
      @last_chance_on
    end
  
    # Alias del metodo hp= per controllo ultima chance
    def hp=(hp)
      alive = self.hp > 0
      h87attr_hp(hp.to_i)
      if self.hp == 0 && alive && last_chance?
        h87attr_hp(1)
        @last_chance_on = false
        remove_state(1)
      end
    end
  
    # Ricarica tutte le abilità
    def recharge_all
      flush_turn_skills
    end
  
    # ricalcola il danno trasferito su un difensore
    def apply_transfer_damage
    end
  end