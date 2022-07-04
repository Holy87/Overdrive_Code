class Window_ItemInfo < Window_DataInfo
  # METODI PERSONALIZZATI PER SPECIFICI ATTRIBUTI

  # Mostra il bersaglio
  def draw_scope
    return if item.occasion == 3
    return if item.scope == 0
    color = item.for_all_in_field? ? crisis_color : normal_color
    draw_detail(Vocab::ITEM_SCOPE, Vocab.scope(item.scope), 0, line_height, color)
  end

  # Mostra l'occasione
  def draw_occasion
    return if item.occasion == 3
    draw_detail(Vocab::ITEM_USE, Vocab.occasion(item.occasion))
  end

  def draw_esper
    return if item.esper == 0
    accessory = $data_armors.compact.select { |equip| equip.skill_adding.include?(item.id) }.first
    icon_index = accessory.nil? ? 0 : accessory.icon_index
    esper = $game_actors[item.esper]
    draw_detail(Vocab.attribute(:esper), esper.name, icon_index)
    if esper.recharged?
      draw_feature(Vocab.ready_dom)
    else
      rate = esper.charge_state_rate
      text = sprintf('%d/%d', esper.recharge_status, esper.recharge_max)
      draw_param_gauge(Vocab.rec_dom, rate, text)
    end
  end

  # mostra il costo PM
  def draw_mp_cost
    values = []
    values.push(item.mp_cost) if item.mp_cost > 0
    values.push(sprintf('%d%%', item.mp_cost_per)) if item.mp_cost_per > 0
    return if values.empty?
    draw_detail(Vocab.attribute(:mp_cost), values.join('+'))
  end

  # mostra il costo PV
  def draw_hp_cost
    values = []
    values.push(item.hp_cost) if item.hp_cost > 0
    values.push(sprintf('%d%%', item.hp_cost_per)) if item.hp_cost_per > 0
    return if values.empty?
    draw_detail(Vocab.attribute(:hp_cost), values.join('+'))
  end

  # mostra il costo furia
  def draw_anger_cost
    return if item.anger_cost == 0
    draw_detail(Vocab.attribute(:anger_cost), item.anger_cost)
  end

  # mostra il consumo oggetti
  def draw_item_cost
    return if item.consume_item == 0
    if item.multiply_per_target
      number_text = 'xN°bers.'
    else
      number_text = sprintf('x%d', item.consume_item_n)
    end
    draw_detail(Vocab::ITEM_CONSUME, number_text,
                $data_items[item.consume_item].icon_index,
                line_height, normal_color, :right)
  end

  # mostra il consumo di oro
  def draw_gold_cost
    return if item.gold_cost == 0
    draw_detail(sprintf(Vocab::ITEM_COST, Vocab.currency_unit),
                item.gold_cost)
  end

  # Disegna il set di stati alterati
  def draw_plus_state_set
    return if item.plus_state_set.empty?
    return if item.is_a?(RPG::UsableItem) and item.effect_same_name?
    if item.plus_state_set.size > H87Item::Settings::MAX_SINGLE_ITEMS
      icons = item.plus_state_set.map { |i| $data_states[i] }.
        select { |state| state.icon_index > 0 }.
        map { |state| state.icon_index }
      draw_param_with_icons(Vocab.causes, icons)
    else
      item.plus_state_set.each do |state_id|
        state = $data_states[state_id]
        next if state.icon_index == 0
        draw_detail(Vocab.causes, state.name, state.icon_index)
      end
    end
  end

  # Disegna il set di stati che rimuove
  def draw_minus_state_set
    return if item.minus_state_set.empty?
    if item.minus_state_set.size > H87Item::Settings::MAX_SINGLE_ITEMS
      icons = item.minus_state_set.map { |i| $data_states[i].icon_index }
      draw_param_with_icons(Vocab.removes, icons)
    else
      item.minus_state_set.each do |state_id|
        state = $data_states[state_id]
        draw_detail(Vocab.removes, state.name, state.icon_index)
      end
    end
  end

  def draw_state_defense_rate(state_id, rate)
    return draw_state_rate_all(rate) if state_id == :all
    state = $data_states[state_id]
    param = sprintf('%s %s', Vocab.resistance_a, state.name)
    color = rate > 0 ? power_down_color : power_up_color
    value = sprintf('%d%%', (rate * -1))
    draw_detail(param, value, state.icon_index, line_height, color, :left)
  end

  # Disegna la cura HP
  #noinspection RubyResolve
  def draw_hp_recover
    return if item.hp_recovery_rate == 0 && item.hp_recovery == 0
    param = sprintf(Vocab::ITEM_RECOVER, Vocab.hp_a)
    if item.hp_recovery == 0
      draw_detail(param, sprintf("%+d%%", item.hp_recovery_rate))
    elsif item.hp_recovery_rate == 0
      draw_detail(param, item.hp_recovery)
    else
      draw_detail(param, sprintf("%d %+d%%", item.hp_recovery, item.hp_recovery_rate))
    end
  end

  # Disegna la cura MP
  #noinspection RubyResolve
  def draw_mp_recover
    return if item.mp_recovery_rate == 0 && item.mp_recovery == 0
    param = sprintf(Vocab::ITEM_RECOVER, Vocab.mp_a)
    if item.mp_recovery == 0
      draw_detail(param, sprintf("%+d%%", item.mp_recovery_rate))
    elsif item.mp_recovery_rate == 0
      draw_detail(param, item.mp_recovery)
    else
      draw_detail(param, sprintf("%d %+d%%", item.mp_recovery, item.mp_recovery_rate))
    end
  end

  # Disegna la rarità dell'oggetto
  def draw_rarity
    draw_feature(Vocab.rarity(item.rarity), rarity_color(item.rarity)) if item.not_common?
  end

  # Mostra il tipo di arma
  def draw_weapon_kind
    item.w_types.each do |tipo|
      next if Vocab.wtype(tipo).nil?
      draw_detail(Vocab::EQUIP_KIND, Vocab.wtype(tipo))
    end
  end

  # Mostra gli stati alterati che aggiunge l'arma
  def draw_atk_states
    return if item.state_set.empty?
    item.state_set.each { |state_id|
      state = $data_states[state_id]
      draw_detail(Vocab::WEAPON_STATE, state.name, state.icon_index)
    }
  end

  def draw_elements
    draw_attack_attributes
    draw_magic_elements
  end

  # Mostra l'elemento dell'arma
  def draw_magic_elements
    return if item.magic_elements.empty?
    item.magic_elements.each do |element|
      color = element.color ? normal_color.merge_with(element.color) : normal_color
      draw_detail(Vocab.element, element.name, element.icon_index, line_height, color, :right)
    end
  end

  def draw_type_effectiveness
    return if item.monster_type_effectiveness.empty?
    item.monster_type_effectiveness.each do |element|
      draw_feature(sprintf(Vocab::ATTR_EFFECTIVENESS, element.name))
    end
  end

  def draw_attack_attributes
    return if item.damage_types.empty?
    item.damage_types.each do |element|
      draw_detail(Vocab::ATTACK_ATTRIBUTE, element.name, element.icon_index)
    end
  end

  # Disegna il tipo di armatura
  def draw_armor_kind
    draw_detail(Vocab::EQUIP_KIND, Vocab.armor_kind(item.kind))
  end

  # Disegna le immunità dell'equipaggiamento
  def draw_protected_states
    return if item.state_set.empty?
    #noinspection RubyResolve
    title = (item.is_a?(RPG::State) and item.offset_by_opposite) ? Vocab.removes : Vocab.immune
    if item.state_set.size > H87Item::Settings::MAX_SINGLE_ITEMS
      state_icons = item.state_set.map { |state_id| $data_states[state_id].icon_index }
      draw_param_with_icons(title, state_icons)
    else
      item.state_set.each do |state_id|
        state = $data_states[state_id]
        draw_detail(title, state.name, state.icon_index, line_height, normal_color)
      end
    end
  end

  # Disegna le difese elementali e attributi
  def draw_halved_elements
    return if item.element_set.empty?
    draw_element_protections
    draw_attribute_protections
  end

  # protezione dagli elementi
  def draw_element_protections
    elements = $data_system.magic_elements.select { |ele| item.element_set.include? ele.id }
    return if elements.empty?
    if elements.size == 1
      element = elements.first
      color = element.color ? normal_color.merge_with(element.color) : normal_color
      draw_detail(Vocab::ARMOR_ELEMENT, element.name, element.icon_index, line_height, color)
    else
      draw_detail(Vocab::ARMOR_ELEMENT)
      draw_icon_set(elements.collect { |ele| ele.icon_index })
    end
  end

  # protezione dagli attributi
  def draw_attribute_protections
    attributes = $data_system.weapon_attributes.select { |a| item.element_set.include? a.id }
    return if attributes.empty?
    if attributes.size == 1
      attr = attributes.first
      draw_detail(Vocab::ARMOR_ATTRIBUTE, attr.name, attr.icon_index)
    else
      draw_detail(Vocab::ARMOR_ATTRIBUTE)
      draw_icon_set(attributes.collect { |attr| attr.icon_index })
    end
  end

  def draw_restrictions
    return if item.restriction == 0
    draw_feature Vocab.state_restriction(item.restriction), knockout_color
  end

  def draw_skill_requirements
    draw_required_equips
    draw_required_stats
    draw_required_states
  end

  def draw_required_equips
    return if item.required_eq.empty?
    equip = Settings::WEAPON_REQUIREMENTS[item.required_eq]
    return if equip.nil?
    draw_feature(sprintf('Richiede %s', equip), crisis_color)
  end

  def draw_required_stats
    {
      :hp_req_min => 'Richiede :hp_a sopra il %d%%',
      :hp_req_max => 'Richiede :hp_a sotto il %d%%',
      :mp_req_min => 'Richiede :mp_a sopra il %d%%',
      :mp_req_max => 'Richiede :mp_a sotto il %d%%',
    }.each_pair do |param, description|
      value = item.send(param)
      next if value <= 0
      text = sprintf(description, value)
      draw_feature(text, crisis_color)
    end
  end

  def draw_required_states
    item.required_status.each do |state_id|
      text = sprintf('Richiede %s attivo', $data_states[state_id])
      draw_feature(text, crisis_color)
    end
  end

  def draw_formula
    return if item.base_damage == 0
    return if item.scope == 0
    if item.heal?
      text = item.damage_to_mp ? Vocab.heal_mp_power : Vocab.heal_power
    else
      text = item.damage_to_mp ? Vocab.damage_mp_power : Vocab.damage_power
    end
    draw_detail(text, item.printable_damage_formula)
  end

  def draw_summon
    return if item.esper == 0
    draw_feature(sprintf(Vocab::attribute(:esper), $game_actors[item.esper].name))
  end

  # Disegna i dettagli personalizzati
  def draw_item_custom_details
    item.custom_dets.each do |detail|
      draw_detail(detail[0], detail[1], detail[2])
    end
    item.custom_desc.each do |desc|
      draw_detail(desc)
    end
    item.features.each do |feature|
      draw_feature(feature)
    end
  end

  # Disegna il livello richiesto
  def draw_required_level
    return if item.equip_level <= 1
    return if actor && actor.level >= item.equip_level
    color = actor.nil? ? normal_color : power_down_color
    text = sprintf('Richiede il livello %d', item.equip_level)
    draw_feature(text, color)
  end

  # Disegna l'incremento (in percentuale) delle statistiche
  def draw_stat_bonuses
    item.stat_per.each_key do |stat|
      draw_stat_increment(stat)
    end
  end

  def draw_autostate
    return if item.autostate.nil?
    state = $data_states[item.autostate.state_id]
    rate = item.autostate.state_rate
    if rate >= 0
      title = 'Attiva'
    else
      title = sprintf('%d%% prob. di attivare', rate * 100)
    end
    draw_detail(title, state.name, state.icon_index)
    draw_sub_state_properties(state)
  end

  # Disegna gli stati che vengono attivati con l'equipaggiamento
  def draw_perpetual_states
    item.perpetual_states.each { |autostate|
      state = $data_states[autostate]
      next if state.nil?
      draw_detail('Auto attiva', state.name, state.icon_index)
    }
    if item.perpetual_states.size == 1
      state = $data_states[item.perpetual_states.first]
      draw_sub_state_properties(state)
    end
  end

  # Disegna le difese elementali
  def draw_element_rates
    item.element_rate_set.each_pair do |element, rate|
      draw_element_rate(element, rate)
    end
  end

  # Disegna il rateo degli stati
  def draw_state_rates
    item.state_rate_per.each_pair { |state_id, rate| draw_state_defense_rate(state_id, rate) }
  end

  # Disegna gli amplificatori elementali
  def draw_element_amplifiers
    item.element_amplify.each_pair do |element, rate|
      draw_element_amplify(element, rate)
    end
  end

  # mostra il rank oggetto con un numero di stelle
  def draw_item_class
    return if item.tier == 0
    icon = 568 # icona stella
    text = 'Classe'
    y = @line
    change_color system_color
    draw_text(0, y, contents_width, line_height, text)
    item.tier.times { |i| draw_icon(icon, contents_width - (i + 1) * 24, y) }
    @line += 24
  end

  # Disegna gli stati elementali che causa l'arma con le magie
  def draw_magic_states_plus
    return if item.magic_states_plus.empty?
    item.magic_states_plus.each { |stateid|
      state = $data_states[stateid]
      text = sprintf('%s%% con magie att.', StateRateSettings::OFF_MAGICRATE)
      draw_detail(text, state.name, state.icon_index)
    }
  end

  # Disegna gli stati aggiunti con magie curative
  def draw_heal_states_plus
    return if item.heal_states_plus.empty?
    item.heal_states_plus.each { |stateid|
      state = $data_states[stateid]
      text = sprintf('%s%% con magie cura', StateRateSettings::DEF_MAGICRATE)
      draw_detail(text, state.name, state.icon_index)
    }
  end

  # METODI DI SUPPORTO

  # Disegna l'incremento percentuale di un parametro
  # @param [Symbol] stat
  def draw_stat_increment(stat)
    return if item.stat_per[stat] == 0
    return if item.stat_per[stat].nil?
    draw_parameter(Vocab.param(stat), item.stat_per[stat], true)
  end

  # Disegna la quantità di difesa elementale
  # @param [Integer] element
  # @param [Integer] rate
  def draw_element_rate(element, rate)
    icon = Icon.element(element)
    return if icon.nil?
    text = sprintf('Difesa %s', Vocab.element(element))
    draw_parameter(text, rate * -1, true, icon)
  end

  def draw_state_rate_all(rate)
    draw_parameter('Res. a tutti gli stati', rate * -1, true)
  end

  # Disegna l'elemento amplificato
  # @param [Integer] element
  # @param [Integer] rate
  def draw_element_amplify(element, rate)
    icon = Icon.element(element)
    return if icon.nil?
    text = sprintf('Pot. %s', Vocab.element(element))
    draw_parameter(text, rate, true, icon)
  end

  #noinspection RubyResolve
  def draw_param_growth
    return if item.parameter_type == 0
    parameter = [nil, :mhp, :mmp, :atk, :def, :spi, :agi][item.parameter_type]
    text = sprintf(Vocab.growth, Vocab.param(parameter), item.parameter_points)
    draw_feature(text, rarity_color(2))
  end

  # se l'abilità o oggetto ha un solo stato aggiunto,
  # mostra il dettaglio dello stato cambiando l'ragomento
  # della finestra
  def draw_state_properties
    return unless item.single_state?
    state = $data_states[item.plus_state_set.first]
    draw_sub_state_properties(state)
  end

  # @param [RPG::State] state
  def draw_sub_state_properties(state)
    return if state.icon_index == 0
    return if state.has? :hide_state_info
    if item.is_a?(RPG::Skill) and item.real_name == state.real_name
      text = 'Effetti:'
    else
      text = sprintf('Proprietà di %s:', state.name)
    end
    draw_param_title(text)
    @original_item = @item
    @item = state
    draw_item_data
    @item = @original_item
    @original_item = nil
  end

  def draw_state_inf_dur
    return if item.is_a?(RPG::UsableItem) and item.single_state?
    fetch_discrete_parameter(:state_inf_dur)
  end

  def draw_state_inf_bonus
    return if item.single_state?
    fetch_discrete_parameter(:state_inf_per)
  end

  def draw_duration
    return if item.passive?
    #noinspection RubyResolve
    return if item.hold_turn == 0 or item.auto_release_prob == 0
    if original_item # se sto disegnando lo stato come sottoproprietà
      if [RPG::Weapon, RPG::Armor].include?(@original_item.class) and # se è un equip
        original_item.perpetual_states.include?(item.id) # se è uno stato auto-attivato
        return # non mostrare la durata
      end
    end
    value = item.hold_turn
    if original_item.is_a?(RPG::UsableItem) and original_item.state_inf_dur > 0
      value += original_item.state_inf_dur
    end
    text = value > 1 ? sprintf(Vocab::STATE_DURATION_TURNS, value) : Vocab::STATE_DURATION_TURN
    draw_detail(Vocab::STATE_DURATION, text)
  end

  def draw_resistances
    return if item.passive?
    #noinspection RubyResolve
    return if item.nonresistance
    value = StatusAffinitySettings.default_state_rank(item.id)
    if original_item.is_a?(RPG::UsableItem) and original_item.state_inf_per > 0
      value = (value * (original_item.state_inf_per + 1)).to_i
    end
    draw_detail(Vocab::STATE_RESISTANCE, sprintf('%d%%', value))
  end

  def draw_skill_extensions
    if item.extension.include?('IGNOREREFLECT') and (!item.for_user? && !item.scope == 0)
      draw_feature('Non può essere riflesso', rarity_color(2))
    end
  end

  def draw_state_extensions
    return if item.extension.empty?
    color = text_color(30)
    bg_color = text_color(31)
    if item.extensions_sym.include? :autolife
      draw_feature('Torna in vita da solo', color, bg_color)
    end
    if [:physreflect, :magreflext].all? { |sym| item.extensions_sym.include? sym }
      draw_feature('Riflette tutti i danni', color, bg_color)
    elsif item.extensions_sym.include? :physreflect
      draw_feature('Riflette danni fisici', bg_color)
    elsif item.extensions_sym.include? :magreflext
      draw_feature('Riflette le magie', bg_color)
    end
    if [:magnull, :phynull].all? { |sym| item.extensions_sym.include? sym }
      draw_feature('Immune a tutti i danni', color, bg_color)
    elsif item.extensions_sym.include? :magnull
      draw_feature('Immune alle magie', bg_color)
    elsif item.extensions_sym.include? :phynull
      draw_feature('Immune ai danni fisici', bg_color)
    end
  end

  def draw_low_hpmp_bonus
    return if item.crisis_params_per.nil?
    item.crisis_params_per.each_key do |param|
      param_name = Vocab.param((param.to_s + '_a').to_sym)
      percentage = VariableStatsConfig::CRISIS_RATES[param]
      text = sprintf('Quando %s sotto il %d%%', param_name, percentage)
      values = []
      item.crisis_params_per[param].each_pair do |stat, value|
        values.push({ :text => sprintf('%s %+d%%', Vocab.param(stat), value * 100), :icon => Icon.param(stat) })
      end
      draw_param_list(values, text)
    end
  end

  def draw_battle_triggers
    item.all_battle_triggers.values.flatten.each { |trigger| draw_battle_trigger(trigger) }
  end

  # @param [RPG::Battle_Trigger] trigger
  def draw_battle_trigger(trigger)
    strings = Vocab.battle_trigger(trigger.type)
    text = [strings[0], sprintf(strings[1], $data_states[trigger.value].name, trigger.rate)]
    draw_multiline_feature(text, power_up_color)
  end

  def draw_set_bonus
    return if item.set_bonus == 0
    draw_set_components item.set_bonus
    if item.has_variant_set? and actor and actor.has_state?(item.set_bonus + 1)
      draw_set_bonus_details(item.set_bonus + 1, true)
    else
      draw_set_bonus_details item.set_bonus
    end
  end

  def draw_set_components(set_bonus)
    equips = SETS::Armors[set_bonus]
    list = equips.map { |e_id| generate_equip_set_item e_id }
    if item.has_variant_set?
      equip_id = item.facultative_set_equip_id
      hash = generate_equip_set_item(equip_id)
      hash[:text] = hash[:text] + (' (opz.)')
      list.push hash
    end
    draw_param_list(list, sprintf('Set %s', $data_states[set_bonus].name))
  end

  # @param [Integer] equip_id
  # @return [Hash{Symbol->Unknown}]
  def generate_equip_set_item(equip_id)
    equip = $data_armors[equip_id]
    if actor
      enabled = actor.armors.compact.map { |armor| armor.real_id }.include?(equip.real_id)
      icon = Icon.check(enabled)
    else
      enabled = true
      icon = equip.icon_index
    end
    color = equip.rarity > 0 ? rarity_color(equip.rarity) : normal_color
    { :icon => icon, :text => equip.name, :enabled => enabled, :color => color }
  end

  def draw_set_bonus_details(set_bonus, complete = false)
    text = complete ? 'Bonus set completo:' : 'Bonus set:'
    draw_param_title(text)
    @original_item = @item
    @item = $data_states[set_bonus]
    draw_item_data
    @item = @original_item
    @original_item = nil
  end

  def draw_weapon_power_ups
    return unless item.is_a?(RPG::Weapon)
    return if item.powered?
    return if item.power_ups.empty?
    list = item.power_ups.map { |power_up| {:icon => power_up.icon, :text => power_up.name} }
    draw_param_list(list, 'Potenziamenti possibili')
  end

  def draw_attack_elements
    return if item.attack_elements.empty?
    item.attack_elements.each do |element_id|
      element = $data_system.element_by_id(element_id)
      color = normal_color.merge_with(element.color)
      draw_detail('Infonde elemento', element.name, element.icon_index, line_height, color)
    end
  end

  def draw_slip_damages
    if item.slip_damage
      item.slip_extension.each {|extension| draw_slip_extension(extension) }
    elsif item.slip_damage_per > 0
      draw_multiline_feature(['Perde PV ad ogni turno',
                              sprintf('%d%% dei danni subiti', item.slip_damage_per * 100)],
                             power_down_color)
    end
  end

  # @param [Array] extension
  def draw_slip_extension(extension)
    param = extension[0].to_sym
    value = extension[1]
    value_per = extension[2]
    return if value == 0 and value_per == 0
    type = value + value_per > 0 ? :damage : :heal
    hdmg = {:damage => 'Perde', :heal => 'Cura'}[type]
    color = {:damage => power_down_color, :heal => power_up_color}[type]
    values = []
    if value != 0
      param_abbrev = (param.to_s + '_a').to_sym
      values.push(sprintf('%d%s', value.abs, Vocab.param(param_abbrev)))
    end
    if value_per != 0
      values.push(sprintf('%d%% %s', value_per.abs, Vocab.param(param)))
    end
    text = sprintf('%s ', hdmg) + values.join(' + ')
    draw_multiline_feature([text, 'ad ogni turno'], color)
  end

  def draw_skill_hit
    if item.magical?
      return if item.hit >= 100
      text = 'Prob. di fallimento'
      value = sprintf('%d%%', 100 - item.hit)
      draw_detail(text, value, 0, line_height, crisis_color)
    else
      return if item.hit == 95
      draw_parameter(Vocab.hit, item.hit - 95, true, Icon.param(:hit))
    end
  end
end