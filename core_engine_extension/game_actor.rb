#==============================================================================
# ** Game_Actor
#---------------------------------------------------------------------------
# Metodi specifici per l'eroe
#==============================================================================
class Game_Actor < Game_Battler
    unless $@
      alias :ex_attr_skills :skills
      alias :ex_attr_element_set :element_set
      alias :ex_attr_mp :mp
      alias :ex_attr_equippable? :equippable?
      alias :ex_attr_skills :skills
      alias :ex_attr_super_guard :super_guard
      alias :ex_attr_pharmacology :pharmacology
      alias :ex_attr_weapons :weapons
      alias :ex_attr_atk_animation_id :atk_animation_id
      alias :ex_attr_maxhp_limit :maxhp_limit
      alias :ex_attr_parameter_limit :parameter_limit
      alias :ex_attr_calc_hit :calc_hit
      alias :ex_attr_calc_eva :calc_eva
      alias :ex_attr_normal_states :states
    end
    # Inizializza i valori prima di una battaglia
    def init_for_battle
      super
      self.song_count = 0
      initialize_anger
    end
  
    def maxhp_limit
      apeiron? ? 99999 : ex_attr_maxhp_limit
    end
  
    def parameter_limit
      apeiron? ? 9999 : ex_attr_parameter_limit
    end
  
    # calcola la mira del colpo, aggiunge anche
    # il modificatore di mira dell'eroe
    # @param [Game_Battler] user
    # @param [RPG::UsableItem] obj
    # @return [Integer]
    def calc_hit(user, obj = nil)
      hit = ex_attr_calc_hit(user, obj)
      #noinspection RubyResolve
      if obj != nil and obj.is_a?(RPG::Skill) and obj.physical_attack
        hit += user.hit - 95
      end
      hit
    end
  
    # calcola l'evasione del bersaglio. Aggiunta una funzione
    # che diminuisce l'evasione se chi lo attacca ha una
    # mira superiore al 100%.
    # @param [Game_Battler] user
    # @param [RPG::UsableItem] obj
    # @return [Integer]
    def calc_eva(user, obj = nil)
      ex_attr_calc_eva(user,obj) - [user.hit-100,0].max
    end

    def base_maxhp
      actor.parameters[0, @level] + features_sum(:maxhp)
    end

    def base_maxmp
      actor.parameters[1, @level] + features_sum(:maxmp)
    end

    def base_atk
      actor.parameters[2, @level] + features_sum(:atk)
    end

    def base_def
      actor.parameters[3, @level] + features_sum(:def)
    end

    def base_spi
      actor.parameters[4, @level] + features_sum(:spi)
    end

    def base_agi
      actor.parameters[5, @level] + features_sum(:agi)
    end
  
    # HP massimi di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_maxhp
      actor.parameters[0, @level] + @maxhp_plus
    end
  
    # MP massimi di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_maxmp
      actor.parameters[1, @level] + @maxmp_plus
    end
  
    alias :native_mhp :native_maxhp
    alias :native_mmp :native_maxhp
  
    # attacco di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_atk
      actor.parameters[2, @level] + @atk_plus
    end
  
    # difesa di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_def
      actor.parameters[3, @level] + @def_plus
    end
  
    # spirito di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_spi
      actor.parameters[4, @level] + @spi_plus
    end
  
    # agilità di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_agi
      actor.parameters[5, @level] + @agi_plus
    end
  
    # furia massima di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_mag
      H87AttrSettings::DEFAULT_MAX_CHARGE
    end
  
    # critici di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_cri
      4
    end
  
    # evasione di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_eva
      5
    end
  
    # mira di base del personaggio (senza equip/status/passive)
    # @return [Fixnum]
    def native_hit
      95
    end

    # visualizza gli stati dell'eroe
    # @return [Array<RPG::State>]
    def states
      (ex_attr_normal_states + perpetual_states).compact.
        sort{|s1, s2| s2.priority <=> s1.priority}
    end
  
    # @return [Fixnum, NilClass]
    def atk_animation_id
      overwriter = features.select { |f| f.custom_attack_animation != nil}.first
      overwriter.nil? ? ex_attr_atk_animation_id : overwriter.custom_attack_animation
    end
  
    # @return [Array<RPG::State,RPG::Armor,RPG::Weapon>]
    def features
      super + equips.compact
    end
  
    # Restituisce se l'eroe usa la barra charge
    def charge_gauge?
      super or H87AttrSettings::CHARGE_GAUGE_CLASSES.include?(@class_id)
    end
  
    # determina se l'eroe ha 2 armi
    def has2w
      #equips.count { |equip| equip.is_a?(RPG::Weapon) } >= 2
      armi = 0
      equips.each { |equipment|
        armi += 1 if equipment.is_a?(RPG::Weapon)
      }
      armi >= 2
    end
  
    # determina se l'attacco è basato dallo spirito
    def attack_with_magic?
      super || self.weapons[0] != nil and self.weapons[0].magic_attack > 0
    end
    
    # @return [Array<RPG::Weapon>]
    def weapons
      disarmed? ? [] : ex_attr_weapons
    end
  
    # determina se il personaggio è disarmato
    def disarmed?
      @states.map{ |st_id| $data_states[st_id] }.
          select { |state| state.has?(:disarm)}.any?
    end
  
    # Restituisce il nuovo valore secondo il bonus del gruppo
    # value: valore iniziale
    # param: parametro (atk, def, spi, agi, eva, hit, cri)
    # @param [Integer] value
    # @param [Symbol] param
    # @return [Integer]
    # @deprecated non più usato
    def party_bonus(value, param = nil)
      value = super(value, param)
      return value unless $game_temp.in_battle
      if [:hit, :eva, :cri].include?(param)
        value + $game_party.party_bonus(param)
      else
        (value * (1.0 + $game_party.party_bonus(param))).to_i
      end
    end
  
    # @return [Array<RPG::Skill>]
    def assimilated_skills
      @assimilated_skills ||= []
      @assimilated_skills.compact.map { |skill_id| $data_skills[skill_id] }
    end
  
    def max_assimilable_skills
      assimilate_skill = skills.select { |skill| skill.assimilate? }.first
      return 0 if skill.nil?
      [1, assimilate_skill.max_assimilable]
    end

    # restituisce il numero di colpi disponibile prima che l'abilità
    # assimilata scompaia
    def assimilated_skill_rounds
      1 # al momento non sono previsti colpi aggiuntivi
    end
  
    # @param [RPG::Skill] skill
    def assimilated?(skill)
      @assimilated_skills.include?(skill.id)
    end
  
    # determina se l'abilità è assimilabile dall'eroe
    # @param [RPG::Skill] skill
    def assimilable?(skill)
      skill.assimilable? and !skills.include?(skill)
    end
  
    # determina se l'eroe ha una skill di assimilazione
    def can_assimilate?
      skills.select { |skill| skill.assimilate? }.any?
    end
  
    # @param [RPG::Skill] skill
    def assimilate(skill)
      @assimilated_skills ||= []
      if @assimilated_skills.size >= max_assimilable_skills
        skills_to_remove = @assimilated_skills.size + 1 - max_assimilable_skills
        @assimilated_skills.shift(skills_to_remove)
      end
      @assimilated_skills.push(skill.id)
    end
  
    def kill_recharge
      if hp_on_kill > 0
        @hp_damage = hp_on_kill * -1
        SceneManager.scene.force_damage_pop(self)
      end
  
      if mp_on_kill > 0 and mp_gauge?
        @mp_damage = mp_on_kill * -1
        SceneManager.scene.force_damage_pop(self)
      end
  
      if anger_kill > 0 and charge_gauge?
        self.anger += anger_kill
      end
    end
  
    # restituisce la skill con attacco custom sul giocatore.
    # se ci sono più attributi che hanno un attacco custom,
    # allora viene presa quella dell'attributo con priorità
    # più alta.
    # @return [RPG::Skill]
    def custom_attack_skill
      return nil unless has_custom_attack?
      feature = custom_attack_skill_features.sort { |a, b| b.priority <=> a.priority }.first
      $data_skills[feature.custom_attack_skill]
    end
  
    # determina se l'eroe ha un attacco personalizzato
    def has_custom_attack?
      custom_attack_skill_features.any?
    end
  
    # restituisce la skill con difesa custom sul giocatore.
    # se ci sono più attributi che hanno una difesa custom,
    # allora viene presa quella dell'attributo con priorità
    # più alta.
    # @return [RPG::Skill]
    def custom_guard_skill
      return nil unless has_custom_guard?
      feature = custom_guard_skill_features.sort { |a, b| b.priority <=> a.priority }.first
      $data_skills[feature.custom_guard_skill]
    end
  
    def has_custom_guard?
      custom_guard_skill_features.any?
    end
  
    # @return [String]
    def attack_command_name
      has_custom_attack? ? custom_attack_skill.name : Vocab::attack
    end
  
    # @return [String]
    def guard_command_name
      has_custom_guard? ? custom_guard_skill.name : Vocab::guard
    end
  
    # @param [RPG::Skill] skill
    def consume_assimilated_skill(skill)
      @assimilated_skills ||= []
      @assimilated_skills.delete(skill.id)
    end
  
    # @return [Object]
    def element_set
      (ex_attr_element_set + feature_array(:attack_elements)).uniq
    end
  
    # @return [Array<RPG::Skill]
    def skills
      ex_attr_skills + assimilated_skills
    end
  
    def super_guard
      ex_attr_super_guard or has_feature? :super_guard
    end
  
    def pharmacology
      ex_attr_pharmacology or has_feature? :pharmacology
    end
  
    # restituisce il bonus dello spirito all'attacco
    # @return [Integer]
    def spirit_attack
      attack_bonus = calc_spirit_attack
      attack_bonus > 0 ? (attack_bonus * spi).to_i : 0
    end
  
    # restituisce il bonus dello spirito alla difesa
    # @return [Integer]
    def spirit_defense
      defense_bonus = calc_spirit_defense
      defense_bonus > 0 ? (defense_bonus * spi).to_i : 0
    end
  
    # restituisce il bonus della velocità alla difesa
    # @return [Integer]
    def spirit_agi
      agi_bonus = calc_spirit_agi
      agi_bonus > 0 ? (agi_bonus * spi).to_i : 0
    end
  
    # restituisce il calcolatore di percentuale dello spirito sull'attacco
    def calc_spirit_attack
      features_sum(:spirit_attack)
    end
  
    # restituisce il calcolatore di percentuale dello spirito sulla difesa
    def calc_spirit_defense
      features_sum(:spirit_defense)
    end
  
    # restituisce il calcolatore di percentuale dello spirio sulla velocità
    def calc_spirit_agi
      features_sum(:spirit_agi)
    end
  
    # Restituisce il bonus regalo del gruppo
    # param: parametro
    def party_gift(param)
      $game_party.param_gift(param)
    end
  
    # Restituisce il bonus che dà il personaggio al gruppo
    # param: parametro
    def actor_party_bonus(param)
      return 0 if dead?
      states.compact.inject(0) {|sum, state| sum + (state.party_bonus[param] || 0)}
    end
  
    def apply_param_limiter(value)
      [[value, 0].max, parameter_limit].min
    end
  
    def apply_hp_limiter(value)
      [[value, 1].max, maxhp_limit].min
    end
  
    # Restituisce l'attacco dell'eroe. Riscritto completamente.
    def atk
      apply_param_limiter(super + party_gift(:atk) + spirit_attack)
    end
  
    # modifica del valore di difesa
    def def
      apply_param_limiter(super + party_gift(:def) + spirit_defense)
    end
  
    # modifica del valore spirito
    def spi
      apply_param_limiter(super + party_gift(:spi))
    end
  
    # modifica del valore agilità
    def agi
      apply_param_limiter(super + party_gift(:agi) + spirit_agi)
    end
  
    # modifica del valore d'evasione
    def eva
      [[super, 0].max, 100].min
    end
  
    # modifica del valore di mira
    def hit
      malus_hit = has2w ? CPanel::TWHIT : 0
      [super - malus_hit, 0].max
    end
  
    def cri
      [[super, 0].max, 100].min
    end
  
    # Restituisce il conto dei canti consecutivi
    def song_count
      @song_count = 0 if @song_count.nil?
      @song_count
    end
  
    # Modifica il conto dei canti
    def song_count=(value)
      @song_count = 0 if @song_count.nil?
      @song_count = value
    end
  
    # Restituisce true se ha il bonus pozioni
    def item_bonus
      features_sum(:item_bonus)
    end
  
    # Restituisce true se l'eroe possiede taumaturgia
    def taumaturgic?
      has_feature?(:taumaturgic)
    end
  
    # determina se il personaggio può superare il limite dei parametri
    def apeiron?
      has_feature? :apeiron
    end
  
    # Restituisce il bonus del salvataggio oggetto
    def save_item_bonus
      features_sum(:item_save)
    end
  
    # Restituisce true se l'eroe è in status difensore (assorbe danni)
    def defender?
      has_feature?(:defender)
    end
  
    # Restituisce true se l'eroe è un tipo virile
    def virile?
      has_feature?(:viril)
    end
  
    def show_atb?
      has_feature?(:show_atb)
    end
  
    # Restituisce true se l'eroe può scassinare porte
    def scassinatore?
      has_feature?(:scassinate)
    end
  
    # Definisce se è un meccanico
    def mechanic?
      has_feature?(:mechanic)
    end
  
    # Restituisce il bonus durata delle dominazioni dell'eroe
    def dom_bonus
      features_sum(:dom_bonus)
    end
  
    # Restituisce lo charm del personaggio
    def charm
      features_sum(:charm)
    end
  
    # Restituisce true se la dominazione ha lo status di ricarica
    def rech_bonus?
      has_feature?(:esper_recharger)
    end
  
    # Restituisce il bonus di ricarica (0.5: 50% di bonus, battaglie dimezz.)
    def fast_ready_bonus
      [100, features_sum(:fast_ready)].min / 100.0
    end
  
    # Restituisce true se la dominazione ha il bonus di salvataggio
    def save_domination?
      has_feature?(:save_domination)
    end
  
    # Restituisce true se il personaggio ha l'abilità per saltare lontano
    def can_jump_longer?
      has_feature?(:long_jump)
    end
  
    # Restituisce true se il personaggio ha l'abilità ritmo
    def has_rhytm?
      has_feature?(:rhytm)
    end
  
    # Restituisce il divisore di passi
    def step_divisor
      10 + features_sum(:anger_mantain)
    end
  
    # Restituisce il bonus probabilità alla sintesi
    def synth_probability_bonus
      features_sum(:synth_bonus)
    end
  
    # Restituisce gli HP guariti a fine battaglia
    def win_hp
      maxhp * features_sum(:hp_on_win)
    end
  
    # Restituisce gli MP guariti a fine battaglia
    def win_mp
      maxmp * features_sum(:mp_on_win)
    end
  
    # restituisce il rate di HP guadagnati su nemico sconfitto
    def hp_on_kill
      (maxhp * features_sum(:hp_on_kill)).to_i
    end
  
    # restituisce il rate di MP guadagnati su nemico sconfitto
    def mp_on_kill
      (maxmp * features_sum(:mp_on_kill)).to_i
    end

    # restituisce gli stati atuo-attivati dagli equipaggiamenti
    def perpetual_states
      feature_array(:perpetual_states, true).map { |state_id| $data_states[state_id] }.compact
    end
  
    # Restituisce i passi compiuti dall'eroe
    def steps
      @steps ||= 0
    end
  
    # Modifica il valore dei passi dell'eroe
    def steps=(new_value)
      @steps = new_value
    end
  
    # Riduce l'ira con i passi
    def reduce_anger
      self.steps += 1
      self.anger -= 1 if steps % step_divisor == 0 && self.anger > initial_anger
    end
  
    # Modifica il danno se c'è un difensore
    def apply_transfer_damage
      apply_defender_damage
      apply_summon_damage_reduction
    end
  
    # Modifica il danno se c'è un difensore
    def apply_defender_damage
      party_def = $game_party.defender
      if party_def != nil and !self.defender? and @hp_damage > 0
        old_dmg = @hp_damage
        @hp_damage *= $data_system.skill_protect_rate
        defender = $game_party.defender
        defender.hp -= defender.calc_defender_damage(old_dmg, @hp_damage)
      end
    end
  
    # ottiene il danno ricevuto dal difensore
    def calc_defender_damage(initial_damage, hp_damage)
      dmg = initial_damage - hp_damage
      if guarding?
        dmg /= (super_guard ? 4 : 2)
      end
      dmg
    end
  
    # Modifica il danno se c'è un difensore
    # noinspection RubyResolve
    def apply_summon_damage_reduction
      return unless $game_temp.esper_active
      return if is_esper?
      domination = nil
      $game_party.members.each { |member|
        if member.is_esper?
          domination = member
          break
        end
      }
      return unless domination
      old_dmg = @hp_damage
      @hp_damage -= (@hp_damage * H87AttrSettings::VLINK_RATE).to_i
      domination.hp -= (old_dmg * H87AttrSettings::VLINK_RATE).to_i
    end
  
    # Determina se l'oggetto può essere equipaggiato
    # @param [RPG::BaseItem] item
    # @return [Boolean]
    def equippable?(item)
      if item.is_a?(RPG::Armor)
        return false if two_swords_style and item.kind == 0
      end
      if item.is_a?(RPG::Weapon) or item.is_a?(RPG::Armor)
        return false if item.equip_level > self.level
        return true if permit_equips(item)
      end
      ex_attr_equippable?(item)
    end
  
    # Restituisce l'array dei potenziamenti
    # @param [RPG::BaseItem] item
    # @return [Boolean]
    def permit_equips(item)
      permit_plus = feature_array(:allow_equip_type).uniq
      item.w_types.each do |tipo|
        return true if permit_plus.include?(tipo)
      end
      false
    end
  
    # restituisce l'ammontare di bonus al parametro che conferisce al gruppo
    # rispetto al proprio parametro statico (senza moltiplicatori)
    def param_gift(param)
      multiplier = 0.0
      states.compact.inject(0.0) {|multiplier, state| multiplier + state.param_gift[param] }
      case param
      when :atk
        value = static_atk
      when :def
        value = static_def
      when :spi
        value = static_spi
      when :agi
        value = static_agi
      else
        value = 0
      end
      (value * multiplier).to_i
    end
  
    # Modifica l'agilità con il ritmo
    def rhytm_bonus
      song_count >= 2 ? (ex_attr_agi * 0.5).to_i : 0
    end
  
    # Restituisce gli stati che rimuove
    def custom_minus_state_set
      result = super
      # @param [RPG::Weapon] weapon
      weapons.compact.each { |weapon|
        result |= weapon == nil ? [] : weapon.minus_state_set
      }
      result
    end
  
    # Restituisce gli MP
    def mp
      mp_gauge? ? ex_attr_mp : 0
    end
  
    private
  
    # @return [Array<RPG::State or RPG::Armor or RPG::Weapon>]
    def custom_attack_skill_features
      #noinspection RubyYardReturnMatch
      features.select { |ft| ft.custom_attack_skill > 0 and skill_can_use?($data_skills[ft.custom_attack_skill]) }
    end
  
    # @return [Array<RPG::State or RPG::Armor or RPG::Weapon>]
    def custom_guard_skill_features
      #noinspection RubyYardReturnMatch
      features.select { |ft| ft.custom_guard_skill > 0 and skill_can_use?($data_skills[ft.custom_guard_skill]) }
    end
  end
  
  #game_actor