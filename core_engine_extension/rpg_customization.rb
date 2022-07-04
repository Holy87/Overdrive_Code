module RPG
  #==============================================================================
  # ** RPG::EquippableItem
  #---------------------------------------------------------------------------
  # Inserisce gli attributi appropiati agli oggetti equipaggiabili
  #==============================================================================
  class Weapon < BaseItem
    include ExtraAttr

    def cri
      @cri + (@critical_bonus ? 4 : 0)
    end

    def hit
      @hit - 95
    end

    # determina se l'arma cambia il tipo di supporto
    def changes_support_type?
      @use_support != nil
    end

    def has_placeholder?
      false
    end

    def is_placeholder?
      false
    end

    def priority
      4
    end

    def ranged?
      quality?(:ranged)
    end
  end

  #equippableitem

  #==============================================================================
  # ** RPG::Armor
  #---------------------------------------------------------------------------
  # Inserisce gli attributi appropiati agli oggetti equipaggiabili
  #==============================================================================
  class Armor < BaseItem
    # in equip overhaul
    attr_reader :hit
    attr_reader :cri

    include ExtraAttr

    def another_support_type?
      @kind == 0 and @support_type != nil
    end

    def has_placeholder?
      false
    end

    def is_placeholder?
      @is_placeholder
    end

    def priority
      3
    end
  end

  #equippableitem

  #==============================================================================
  # ** RPG::State
  #---------------------------------------------------------------------------
  # Inserisce gli attributi appropiati per gli stati alterati
  #==============================================================================
  class State
    attr_reader :description
    attr_reader :slip_damage_per

    include ExtraAttr
    # True se lo status è un buff
    def buff?
      @buff_type == :buff
    end

    # True se lo status è un debuff
    def debuff?
      @buff_type == :debuff
    end

    def linked_to_element?
      @linked_element > 0
    end

    # @return [String]
    def description
      @description
    end

    def viral?
      quality? :viral
    end

    def bombify?
      quality? :bombify
    end

    # @return [Hash]
    def stat_per
      stats = {}
      [:atk, :spi, :def, :agi, :maxhp, :maxmp, :hit, :eva, :cri, :odds].each do |stat|
        stats[stat] = stat_bonus(stat)
      end
      stats
    end

    def stat_bonus(param)
      if super(param) == 0 and [:atk, :spi, :def, :agi].include?(param)
        case param
        when :atk
          return @atk_rate - 100
        when :spi
          return @spi_rate - 100
        when :def
          return @def_rate - 100
        when :agi
          return @agi_rate - 100
        else
          return 0
        end
      end
      super(param)
    end
  end

  #state

  #==============================================================================
  # ** RPG::Enemy
  #---------------------------------------------------------------------------
  # Inserisce gli attributi appropiati per i nemici
  #==============================================================================
  class Enemy
    attr_reader :description
    attr_reader :attack_attr
    attr_reader :use_anger
    attr_reader :boss_type
    attr_reader :unprotected
    include ExtraAttr

    # restituisce l'attributo principale al danno
    # @return [RPG::Element_Data, nil]
    def attack_attribute
      return nil if @attack_attr.nil?
      $data_system.weapon_attributes.select { |attr| attr.id == attack_attr }.first
    end

    # determina se è un protettore
    def protector?
      @protector
    end

    def force_show_atb?
      quality?(:show_atb)
    end

    def priority
      0
    end

    # @return [TrueClass, FalseClass]
    def boss_type
      quality?(:boss_type)
    end
  end

  #==============================================================================
  # ** RPG::UsableItem
  #---------------------------------------------------------------------------
  # Imposta gli attributi per le abilità
  #==============================================================================
  class UsableItem
    include MultiAttributable
    attr_reader :esper #esper evocato
    attr_reader :spirit_stone #spirit_stone
    attr_reader :absorb_damage_party #assorbi danno e dona al gruppo
    attr_reader :anger_cost #costo ira
    attr_reader :anger_rate #carica ira
    attr_reader :tank_odd #aggro al tank
    attr_reader :state_inf_bon #bonus probabilità infliggi status
    attr_reader :state_inf_per #bonus probabilità infliggi status perc.
    attr_reader :state_inf_dur #bonus durata status
    attr_reader :ignore_bonus #ignora bonus
    attr_reader :sk_types #tipo di abilità (per costo)
    attr_reader :range_type #distanza [0: meele, 1: ranged]
    attr_reader :buff_steal #flag per rubare i buff
    attr_reader :debuff_pass #flag per trasferire i debuff al bersaglio
    attr_reader :reset_damage
    attr_reader :mp_damage_per #percentuale di danni MP con i danni HP
    attr_reader :mp_heal_per # percentuale di auto-cura MP con i danni HP
    attr_reader :required_menu_switch
    # @return [Autostate_Skill]
    attr_reader :autostate
    attr_reader :cri
    attr_reader :custom_damage_formula
    attr_reader :critical_condition
    attr_reader :transfer_aggro
    attr_reader :clear_anger
    attr_reader :knockback_rate
    # eredita i bonus di attacco normale sui danni della skill
    attr_reader :inherit_normal_atk_bonus

    # @return [Array]
    attr_reader :target_states

    RANGE_TYPE_MEELE = 0
    RANGE_TYPE_RANGED = 1

    # Inizializza il livello della classe dell'oggetto
    def load_extra_attr
      return if @cache_caricata_attr
      @cache_caricata_attr = true
      @esper = 0
      @absorb_damage_party = false
      @anger_cost = 0
      @spirit_stone = false
      @ok_with_taumaturgic = false
      @anger_rate = 0
      @tank_odd = 0
      @stat_increment = {}
      @state_inf_bon = 0
      @state_inf_per = 0.0
      @state_inf_dur = 0
      @range_type = nil
      @ignore_bonus = false
      @clear_anger = false
      @sk_types = []
      @troop_id = 0
      @recharge_skills = false
      @placeholder_id = 0
      @buff_steal = false
      @debuff_pass = false
      @reset_damage = false
      @assimilate = false
      @assimilable = false
      @switchable = false
      @mp_damage_per = 0
      @mp_heal_per = 0
      @required_menu_switch = 0
      @force_on = nil
      @autostate = nil
      @target_states = nil
      @damage_stats = {:spi_f => @spi_f, :atk_f => @atk_f}
      @critical = true
      @custom_damage_formula = nil
      @custom_formula_description = nil
      @critical_condition = nil
      @transfer_aggro = false
      @toggle_type = false
      @knockback_rate = 0
      @cri = 0
      @assimilate_data = {}
      @inherit_normal_atk_bonus = false
      reading_help = false
      self.note.split(/[\r\n]+/).each { |row|
        if reading_help
          if row =~ ExtraAttr::HELP_END
            reading_help = false
          else
            @description += row
          end
          next
        end
        next if load_battle_params(row)
        case row
        when ExtraAttr::EVOCATION
          @esper = $1.to_i
        when ExtraAttr::TAUMATURG
          @ok_with_taumaturgic = true
        when ExtraAttr::SPIRITOL
          @spirit_stone = true
        when ExtraAttr::PARTY_ABS
          @absorb_damage_party = true
        when ExtraAttr::ANGER_COST
          @anger_cost = $1.to_i
        when ExtraAttr::ANGER_RATE
          @anger_rate = $1.to_i
        when ExtraAttr::TANK_ODDS
          @tank_odd += $1.to_i
        when ExtraAttr::STATE_BON
          @state_inf_bon = $1.to_i
        when ExtraAttr::ST_BON_PER
          @state_inf_per += $1.to_f / 100.0
        when ExtraAttr::ST_BON_IGN
          @ignore_bonus = true
        when ExtraAttr::ST_INF_DUR
          @state_inf_dur = $1.to_i
        when ExtraAttr::SK_TYPE_CS
          @sk_types.push($1)
        when ExtraAttr::MONSTER_T
          @troop_id = $1.to_i
        when ExtraAttr::STAT_INCR
          @stat_increment[$1] = $2.to_i
        when ExtraAttr::REC_SKILLS
          @recharge_skills = true
        when ExtraAttr::MEELE
          @range_type = RANGE_TYPE_MEELE
        when ExtraAttr::RANGED
          @range_type = RANGE_TYPE_RANGED
        when ExtraAttr::PLACEHOLDER_ID
          @placeholder_id = $1.to_i
        when ExtraAttr::BUFF_STEAL
          @buff_steal = true
        when ExtraAttr::DEBUFF_PASS
          @debuff_pass = true
        when ExtraAttr::RESET_DAMAGE
          @reset_damage = true
        when ExtraAttr::ASSIMILABLE
          @assimilable = true
        when ExtraAttr::ASSIMILATE
          @assimilate = true
        when ExtraAttr::MAX_ASSIMILABLE
          @assimilate_data[:max] = $1.to_i
        when ExtraAttr::ASSIMILATE_ROUNDS
          @assimilate_data[:rounds] = $1.to_i
        when ExtraAttr::SKILL_MP_DAMAGE_PER
          @mp_damage_per = $1.to_f / 100.0
        when ExtraAttr::SWITCHABLE
          @switchable = true
        when ExtraAttr::MENU_SWITCH
          @required_menu_switch = $1.to_i
        when ExtraAttr::HELP_STRT
          reading_help = true
        when ExtraAttr::AUTOSTATE_SKILL
          @autostate = Autostate_Skill.new($1.to_i, $2.to_i)
        when ExtraAttr::FORCE_ON_TARGET
          @force_on = $1.to_sym
        when ExtraAttr::SKILL_MP_HEAL_PER
          @mp_heal_per = $1.to_f / 100.0
        when ExtraAttr::HIT_ALL
          @scope = 12 # tutti
        when ExtraAttr::HIT_WITH_STATES
          @scope = 13 # tutti i nemici che hanno determinati status
          @target_states = $1.split(/,[ ]*/).map { |id| id.to_i }
        when ExtraAttr::HIT_OTHERS
          @scope = 14
        when ExtraAttr::CANNOT_CRITICAL
          @critical = false
        when ExtraAttr::CRI_RATE
          @cri = $1.to_i
        when ExtraAttr::CUSTOM_FORMULA
          @custom_damage_formula = $1
        when ExtraAttr::CUSTOM_F_DESC
          @custom_formula_description = $1
        when ExtraAttr::CRI_CONDITION
          @critical_condition = $1
        when ExtraAttr::ODD_TRANSFER
          @transfer_aggro = true
        when ExtraAttr::CLEAR_ANGER
          @clear_anger = true
        when ExtraAttr::TOGGLE_TYPE
          @toggle_type = true
        when ExtraAttr::KNOCKBACK
          @knockback_rate = $1.to_f / 100.0
        when ExtraAttr::INHERIT_NORMAL_ATK
          @inherit_normal_atk_bonus = true
        else
          nil
        end
      }
    end

    # determina se ha la qualità
    # @param [Symbol] quality_sym
    def has?(quality_sym)
      if self.class.method_defined?(quality_sym)
        feature = self.send(quality_sym)
        if feature.is_a?(Numeric)
          feature > 0
        else
          feature
        end
      else
        false
      end
    end

    def real_name
      @name
    end

    def effect_same_name?
      return unless plus_state_set.size == 1
      $data_states[plus_state_set.first].real_name == real_name
    end

    # restituisce una statistica di danno
    def damage_stat(stat)
      return @atk_f if stat == :atk_f
      return @spi_f if stat == :spi_f
      @damage_stats[stat] || 0
    end

    # restituisce tutti i calcolatori danno dell'abilità
    # @return [Array<Symbol>]
    def involved_damage_stats
      @damage_stats.keys
    end

    # restituisce tutti i sommatori danno
    # @return [Array<Symbol>]
    def summation_damage_stats
      involved_damage_stats.select { |stat| !H87AttrSettings::MULTIPLIERS.include?(stat) }
    end

    # restituisce tutti i moltiplicatori danno
    # @return [Array<Symbol>]
    def multiplication_damage_stats
      involved_damage_stats.select { |stat| H87AttrSettings::MULTIPLIERS.include?(stat) }
    end

    # carica i parametri custom della formula come agi_f e def_f
    def load_battle_params(row)
      H87AttrSettings::FORMULA_CALC_PARAMS.each do |param|
        if row =~ /<#{param}:?[ ]*(\d+)>/i
          set_battle_param(param, $1.to_i)
          return true
        end
      end
      false
    end

    def set_battle_param(param, value)
      @damage_stats[param] = value
      @atk_f = value if param == :atk_f
      @spi_f = value if param == :spi_f
    end

    # restituice la descrizione della formula del danno
    # @return [String]
    def printable_damage_formula
      return @custom_formula_description if @custom_formula_description != nil
      return '' if @base_damage == 0
      damage = @base_damage.abs
      components = []
      components.push(damage.to_s) if damage > 1 # sempre vero
      summation_damage_stats.each do |param|
        value = damage_stat(param)
        next if value <= 0
        next if param == :spi_f and value == 1
        if H87AttrSettings::PARAMS_DMG_MULTIPLIERS[param]
          value *= H87AttrSettings::PARAMS_DMG_MULTIPLIERS[param]
        end
        components.push(sprintf('%d%% %s', value, Vocab.param_abbrev(param)))
      end
      total = components.join(' + ')
      components = []
      multiplication_damage_stats.each do |param|
        value = damage_stat(param)
        next if value <= 0
        if H87AttrSettings::PARAMS_DMG_MULTIPLIERS[param]
          value *= H87AttrSettings::PARAMS_DMG_MULTIPLIERS[param]
        end
        components.push(sprintf('%g%% %s', value, Vocab.param_abbrev(param)))
      end
      return total if components.empty?
      (['('+total+')'] + components).join(' x ')
    end

    # ottiene il tempo di carica dell'abilità dopo
    # selezionato il comando nella battaglia.
    # Si tratta di un attributo per l'ATB.
    #noinspection RubyResolve
    def charge_time
      return 0 if charge.nil?
      return 0 if charge[1].nil?
      charge[1]
    end

    unless $@
      alias h87ff_for_all? for_all?
      alias h87ff_for_enemy? for_opponent?
      alias h87ff_for_ally? for_friend?
    end

    def for_all?
      h87ff_for_all? or [12, 13].include? @scope
    end

    def for_opponent?
      h87ff_for_enemy? or [12, 13].include? @scope
    end

    def for_friend?
      h87ff_for_ally? or [12,14].include?(@scope)
    end

    def for_all_in_field?
      @scope == 12
    end

    def for_opponents_with_state?
      @scope == 13
    end

    def for_other_friends?
      @scope == 13
    end

    # Restituisce se la skill può essere usata dalla taumaturgia
    def can_tau?
      @ok_with_taumaturgic
    end

    def toggle_type?
      @toggle_type and @plus_state_set.size == 1
    end

    # determina se può causare danni critici
    def can_critical?
      return false unless @critical
      return true if physical?
      H87AttrSettings::CRITICAL_MAGIC
    end

    # @return [TrueClass, FalseClass]
    def critical_condition?
      @critical_condition != nil
    end

    # @return [TrueClass, FalseClass]
    def custom_formula?
      @custom_damage_formula != nil
    end

    # Restituisce true se la skill ha un certo tipo
    def type?(type)
      @sk_types.include?(type)
    end

    # Restituisce l'incremento di un determinato parametro
    # @param [String] stat
    # @return [Integer]
    def param_increment(stat)
      return 0 if @stat_increment[stat].nil?
      @stat_increment[stat]
    end

    # Determina se l'oggetto incrementa un parametro
    def increases_param?
      @stat_increment.size > 0
    end

    # Determina se l'oggetto ricarica tutte le skill
    def skill_recharge?
      @recharge_skills
    end

    # Da definire nelle sottoclassi
    def meele?
      !ranged?
    end

    def ranged?
      return false if @scope == 0
      return false if for_user?
      return false unless battle_ok?
      true
    end

    def only_for_domination?
      @force_on == :domination
    end

    def only_for_actor?
      @force_on == :actor
    end

    def heal?
      @base_damage < 0
    end

    def damaging?
      @base_damage > 0
    end

    def no_damage?
      @base_damage == 0
    end

    def hidden_troop?
      false
    end
  end

  #usable item

  #==============================================================================
  # ** RPG::Skill
  #---------------------------------------------------------------------------
  # Classe che contiene le informazioni sulle abilità
  #==============================================================================
  class Skill < UsableItem
    # Riscrittura di menu_ok?
    def menu_ok?
      can_tau? ? true : super
    end

    # determina se è una skill ravvicinata
    def meele?
      return self.range_type == RANGE_TYPE_MEELE if self.range_type != nil
      return false if (self.element_set & H87AttrSettings::RANGED_ELEMENTS).size > 0
      @atk_f > 0
    end

    # determina se è una skill a distanza
    def ranged?
      !meele?
    end

    def assimilable?
      @assimilable
    end

    def assimilate?
      @assimilate
    end

    def max_assimilable
      @assimilate_data[:max]
    end

    def assimilated_skill_rounds
      @assimilate_data[:rounds]
    end

    # Restituisce il nome dell'abilità
    #def name
    # return @name unless @japanese_name
    # return @name unless japanese_active?
    # return @japanese_name
    #end
  end

  #==============================================================================
  # ** RPG::Item
  #---------------------------------------------------------------------------
  # Classe che contiene le informazioni sugli oggetti
  #==============================================================================
  class Item < UsableItem
    attr_reader :troop_id #ID dei mostri
    attr_reader :placeholder_id # nome dell'oggetto placeholder

    # determina se l'oggetto ha un placeholder
    def has_placeholder?
      @placeholder_id > 0
    end

    # determina se è un equipaggiamento placeholder (inesistente)
    def is_placeholder?
      false
    end

    # determina se è assimilazione (sempre falso per gli oggetti)
    def assimilate?
      false
    end

    def hidden_troop?
      @troop_id > 0
    end
  end

  class System
    # determina il rateo di danno quando si equipaggiano due spade
    def two_swords_damage_rate
      CPanel::TSWRate
    end

    # rateo di danno quando nel party
    # c'è qualcuno con Altruismo
    def skill_protect_rate
      CPanel::PROTECTRATE
    end
  end
end