class Window_ItemInfo < Window_DataInfo
  #--------------------------------------------------------------------------
  # * Mostra i dettagli da script
  #--------------------------------------------------------------------------
  def draw_script_detail
    if item.is_a?(RPG::Weapon) or item.is_a?(RPG::Armor)
      #draw_item_class
      draw_rarity
      draw_required_level
      draw_perc_increment
      draw_element_rates
      draw_mp_rate
      draw_state_rates
      draw_element_amplifiers
      draw_heal_rate
      draw_atb_charge
      draw_atb_start
      draw_magic_states_plus
      draw_heal_states_plus
      draw_self_heal_rate
      draw_sinergy_bonuses
      draw_summon_bonuses
      draw_drop_prob
      draw_steal_prob
      draw_exp_bonus
      draw_gold_bonus
      draw_autoscan
      draw_parry
      draw_super_guard
      draw_pharmacology
      draw_show_atb
      draw_avoid_defense
      draw_healing_magic_states
      draw_offensive_magic_states
      draw_hp_on_guard
      draw_mp_on_guard
    end
    draw_autostates
    if item.is_a?(RPG::Armor) && item.id == 174
      draw_feature('Visualizza ATB dei nemici')
    end
  end
  #--------------------------------------------------------------------------
  # * Imposta un eroe
  #--------------------------------------------------------------------------
  def set_actor(new_actor)
    return if @actor == new_actor
    @actor = new_actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Disegna la rarità dell'oggetto
  #--------------------------------------------------------------------------
  def draw_rarity
    draw_feature(Vocab.rarity(item.rarity), rarity_color(item.rarity)) if item.not_common?
  end
  #--------------------------------------------------------------------------
  # * Disegna il livello richiesto
  #--------------------------------------------------------------------------
  def draw_required_level
    return if item.equip_level <= 1
    if @actor && item.equip_level > @actor.level
      color = power_down_color
    else
      color = normal_color
    end
    text = sprintf('Richiede il livello %d', item.equip_level)
    draw_feature(text, color)
  end

  def draw_parry
    return unless item.has? :parry
    draw_feature('Contrattacco su schivata')
  end

  def draw_offensive_magic_states
    return if item.offensive_magic_states.empty?
    item.offensive_magic_states.each do |state_id|
      draw_feature(sprintf('Può causare %s con la magia', $data_states[state_id]))
    end
  end

  def draw_healing_magic_states
    return if item.heal_magic_states.empty?
    item.heal_magic_states.each do |state_id|
      draw_feature(sprintf('Può causare %s con la magia', $data_states[state_id]))
    end
  end

  def draw_super_guard
    return unless item.has? :super_guard
    draw_feature('1/4 danni su Difendi')
  end

  def draw_pharmacology
    return unless item.has? :pharmacology
    draw_feature('Effetto pozioni doppio')
  end

  def draw_show_atb
    return unless item.has? :show_atb
    draw_feature('Mostra ATB nemici')
  end

  def draw_avoid_defense
    return unless item.has? :avoid_defense
    draw_feature('Ignora difesa bers.')
  end

  def draw_hp_on_guard
    return if item.hp_on_guard == 0
    draw_detail('PV su Difendi', sprintf('%d%%',item.hp_on_guard * 100))
  end

  def draw_mp_on_guard
    return if item.mp_on_guard == 0
    draw_detail('PM su Difendi', sprintf('%d%%', item.mp_on_guard * 100))
  end




  #--------------------------------------------------------------------------
  # * Disegna l'incremento (in percentuale) delle statistiche
  #--------------------------------------------------------------------------
  def draw_perc_increment
    item.stat_per.each_key do |stat|
      draw_stat_increment(stat)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna l'incremento percentuale di un parametro
  # @param [symbol] stat
  #--------------------------------------------------------------------------
  def draw_stat_increment(stat)
    return if item.stat_per[stat] == 0
    return if item.stat_per[stat].nil?
    draw_parameter(Vocab.param(stat), item.stat_per[stat], true)
  end
  #--------------------------------------------------------------------------
  # * Disegna gli stati che vengono attivati con l'equipaggiamento
  #--------------------------------------------------------------------------
  def draw_autostates
    item.autostates.each { |autostate|
      state = $data_states[autostate]
      next if state.nil?
      draw_detail('Auto attiva', state.name, state.icon_index)
    }
  end
  #--------------------------------------------------------------------------
  # * Disegna le difese elementali
  #--------------------------------------------------------------------------
  def draw_element_rates
    item.element_rate_set.each_pair do |element, rate|
      draw_element_rate(element, rate)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna la quantità di difesa elementale
  # @param [Integer] element
  # @param [Integer] rate
  #--------------------------------------------------------------------------
  def draw_element_rate(element, rate)
    icon = element_icon(element)
    return if icon.nil?
    text = sprintf('Difesa %s', Vocab.element(element))
    draw_parameter(text, rate*-1, true, icon)
  end
  #--------------------------------------------------------------------------
  # * Disegna il rateo degli stati
  #--------------------------------------------------------------------------
  def draw_state_rates
    item.state_rate_per.each_pair { |state_id, rate| draw_state_rate(state_id, rate) }
  end
  #--------------------------------------------------------------------------
  # * Disegna la resistenza agli stati
  # @param [Integer] state_id
  # @param [Integer] rate
  #--------------------------------------------------------------------------
  def draw_state_rate(state_id, rate)
    state = $data_states[state_id]
    return if state.nil?
    text = sprintf('Res. %s', state.name)
    draw_parameter(text, rate*-1, true, state.icon_index)
  end
  #--------------------------------------------------------------------------
  # * Disegna gli amplificatori elementali
  #--------------------------------------------------------------------------
  def draw_element_amplifiers
    item.element_amplify.each_pair do |element, rate|
      draw_element_amplify(element, rate)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna l'elemento amplificato
  # @param [Integer] element
  # @param [Integer] rate
  #--------------------------------------------------------------------------
  def draw_element_amplify(element, rate)
    icon = element_icon(element)
    return if icon.nil?
    text = sprintf('Pot. %s', Vocab.element(element))
    draw_parameter(text, rate, true, icon)
  end

  # mostra il rank oggetto con un numero di stelle
  def draw_item_class
    return if item.tier == 0
    icon = 568 # icona stella
    text = 'Classe'
    y = @line
    change_color system_color
    draw_text(0, y, contents_width, line_height, text)
    item.tier.times{|i| draw_icon(icon, contents_width - (i+1) * 24, y)}
    @line += 24
  end
  #--------------------------------------------------------------------------
  # * Disegna il rateo di danno non elementale. Non serve, perché non ce ne sono.
  #--------------------------------------------------------------------------
  def draw_noelement_rate
  end
  #--------------------------------------------------------------------------
  # * Disegna la potenza delle cure
  #--------------------------------------------------------------------------
  def draw_heal_rate
    return if item.heal_amplify == 0
    draw_parameter('Pot. cure', item.heal_amplify, true, 229)
  end

  def draw_self_heal_rate
    return if item.heal_rate == 0
    draw_parameter('Bonus cure', item.heal_rate, true, 229)
  end
  #--------------------------------------------------------------------------
  # * Disegna il bonus di caricamento ATB delle abilità
  #--------------------------------------------------------------------------
  def draw_atb_charge
    return if item.charge_bonus == 0
    draw_parameter('Vel. caricamento',item.charge_bonus*-1, true, 810)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'incentivo all'ATB iniziale
  #--------------------------------------------------------------------------
  def draw_atb_start
    return if item.atb_base == 0
    draw_feature(sprintf('ATB iniziale %d%%', item.atb_base))
  end
  #--------------------------------------------------------------------------
  # * Disegna gli stati elementali che causa l'arma con le magie
  #--------------------------------------------------------------------------
  def draw_magic_states_plus
    return if item.magic_states_plus.empty?
    item.magic_states_plus.each { |stateid|
      state = $data_states[stateid]
      text = sprintf('%s%% con magie att.', StateRateSettings::OFF_MAGICRATE)
      draw_detail(text, state.name, state.icon_index)
    }
  end
  #--------------------------------------------------------------------------
  # * Disegna gli stati aggiunti con magie curative
  #--------------------------------------------------------------------------
  def draw_heal_states_plus
    return if item.heal_states_plus.empty?
    item.heal_states_plus.each { |stateid|
      state = $data_states[stateid]
      text = sprintf('%s%% con magie cura', StateRateSettings::DEF_MAGICRATE)
      draw_detail(text, state.name, state.icon_index)
    }
  end
  #--------------------------------------------------------------------------
  # * Disegna i bonus alla sinergia
  #--------------------------------------------------------------------------
  def draw_sinergy_bonuses
    draw_parameter('Sinergia iniziale', item.incentive) if item.incentive != 0
    draw_parameter('Durata Sinergia', item.sin_durab, true) if item.sin_durab != 0
    draw_parameter('Sinergia', item.sin_bonus*100) if item.sin_bonus != 0
    if item.sin_on_kill
      draw_parameter('Sinergia uccisione', item.sin_on_kill) if item.sin_on_kill > 0
    end
    if item.sin_defense > 0
      text = 'Aumenta la Sinergia di %s quando vieni colpito mentre ti difendi'
      draw_long_feature(sprintf(text, item.sin_defense)) #TODO: Trovare il metodo o aggiungerlo
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna i bonus alle evocazioni
  #--------------------------------------------------------------------------
  def draw_summon_bonuses
    return if item.dom_bonus == 0
    draw_parameter('Durata evocazioni', item.dom_bonus*100)
  end
  #--------------------------------------------------------------------------
  # * Disegna bonus alle probabilità di furto
  #--------------------------------------------------------------------------
  def draw_steal_prob
    return if item.steal_bonus == 0
    draw_parameter('Prob. furto', item.steal_prob_plus * 100, true)
  end

  def draw_drop_prob
    return if item.drop_bonus == 0
    draw_parameter('Drop oggetti', item.drop_bonus * 100, true)
  end

  def draw_gold_bonus
    return if item.gold_bonus == 0
    draw_parameter('Drop oro', item.gold_bonus * 100, true)
  end

  def draw_exp_bonus
    return if item.exp_bonus == 0
    draw_parameter('Esperienza', item.exp_bonus * 100, true)
  end

  def draw_autoscan
    return unless item.has? :autoscan
    draw_feature 'Scansiona i nemici'
  end
  #--------------------------------------------------------------------------
  # * Disegna il bonus ai consumi PM
  #--------------------------------------------------------------------------
  def draw_mp_rate
    return if item.mp_cost_rate == 0
    draw_parameter('Costo abilità', item.mp_cost_rate * 100, true, 0, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_anger_init
    return if item.anger_init == 0
    draw_parameter('Furia iniziale', item.anger_init)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_anger_kill
    return if item.anger_kill == 0
    draw_parameter('Furia a uccisione', item.anger_kill)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_anger_turn
    return if item.anger_turn == 0
    draw_parameter('Ira per turno', item.anger_turn)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_anger_damage
    return if item.anger_damage == 0
    draw_parameter('Ira ad attacco', item.anger_damage)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_magic_def
    return if item.magic_def == 0
    draw_parameter('Difesa magica', item.magic_def*100, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_magic_dmg
    return if item.magic_dmg == 0
    draw_parameter('Danno magico', item.magic_dmg*100, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_spirit_atk
    return if item.spirit_attack == 0
    txt = 'Bonus attacco sul %d% dello Spirito'
    draw_feature(sprintf(txt, item.spirit_attack))
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_hp_on_win
    return if item.hp_on_win == 0
    draw_parameter('Cura PV vittoria', item.hp_on_win*100, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_mp_on_win
    return if item.hp_on_win == 0
    draw_parameter('Cura PM vittoria', item.mp_on_win*100, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_buff_durability
    return if item.buff_durability == 0
    draw_parameter('Durata buff', item.buff_durability*100, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_debuff_durability
    return if item.debuff_durability == 0
    draw_parameter('Durata debuff', item.debuff_durability*100, true, 0, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_state_inf_durability
    return if item.state_inf_dur == 0
    draw_parameter('Turni stati inflitti', item.state_inf_dur)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_state_inflict_perc
    return if item.state_inf_per == 0
    draw_parameter('Prob. infliggi stati', item.state_inf_per, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_state_def_bonus
    return if item.state_inf_bon == 0
    draw_parameter('Resistenza stati', item.state_inf_bon, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_last_chance
    return unless item.last_chance
    draw_feature('Previene i colpi di grazia')
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_equip_level
    return if equip_level < 1
    ''
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_critical_damage
    return if item.critical_damage == 0
    draw_parameter('Danno critico', item.critical_damage)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_synth_bonus
    return if item.synth_bonus == 0
    draw_parameter('Bonus prob. sintesi', item.synth_bonus, true)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_status_hit
    return if item.status_hit == 0
    state = $data_states[item.status_hit]
    txt = sprintf('%s con attacco', state.name)
    draw_parameter(txt, item.status_hit_prob, 100, state.icon_index)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_status_dmg
    return if item.status_hit == 0
    state = $data_states[item.status_dmg]
    txt = sprintf('%s con danno', state.name)
    draw_parameter(txt, item.status_dmg_prob, 100, state.icon_index)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
end