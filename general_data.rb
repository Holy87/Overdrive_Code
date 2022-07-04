module Settings
  # Icone varie
  SWITCH_ON_ICON = 448
  SWITCH_OFF_ICON = 449
  NEW_ADVICE_ICON = 512
  UNCHECKED_ICON = 496
  CHECKED_ICON = 497
  GOLD_ICON = 147

  # Vocaboli vari
  BACK = 'Indietro'
  ENABLE = 'Attiva'
  DISABLE = 'Disabilita'
  SELECT = 'Seleziona'
  SWITCH_ACTOR = 'Cambia Eroe'

  CAUSES_STATE = 'Causa'
  REMOVES_STATE = 'Rimuove'
  DAMAGE_POWER = 'Danni'
  HEAL_POWER = 'Cura'
  DAMAGE_POWER_MP = 'Danni %s'
  HEAL_POWER_MP = 'Cura %s'
  TURNS = 'Turni'
  RESISTANCE_ABBREV = 'Res.'
  ELEMENT_VOCAB = 'Elemento'
  INFLICTS = 'Infligge'
  GROWTH = 'Incrementa %s di %d'
  IMMUNE = 'Immunità'
  YES_VOCAB = 'Sì'
  OK_VOCAB = 'Ok'
  NO_VOCAB = 'No'
  REQUIREMENTS = 'Requisiti'


  SCENE_NAMES = {
    'Scene_Menu' => 'Menu Principale',
    'Scene_NewSkill' => 'Abilità',
    'Scene_NewEquip' => 'Status',
    'Scene_Item' => 'Inventario',
    'Scene_Map' => 'Chiudi'
  }

  PARAM_ICONS = {
    :heal_amplify => 229,
    :heal_rate => 229,
    :charge_bonus => 810,
    :charge_time => 810,
    :recharge => 811,
    :gold_bonus => 298,
    :exp_bonus => 36,
    :ap_bonus => 28,
    :sin_bonus => 580,
    :incentive => 580,
    :sin_durab => 580,
    :sin_on_kill => 580,
    :sin_on_eva => 580,
    :sin_on_guard => 580,
    :sin_on_heal => 580,
    :sin_on_weak => 580,
    :sin_on_state => 580,
    :sin_on_cri => 580,
    :hp  => 1008,
    :mp  => 1009,
    :atk => 1010,
    :def => 1011,
    :spi => 1012,
    :agi => 1013,
    :cri => 1014,
    :hit => 1015,
    :eva => 1016,
    :odd => 1249,
    :ang => 1250,
    :res => 1251,
    :anger_bonus => 1226
  }

  PARAM_VOCABS = {
    :plus_state_set => 'Condizioni inflitte',
    :minut_state_set => 'Condizioni rimosse',
    :mp_cost => 'Costo :mp_a',
    :hp_cost => 'Costo :hp_a',
    :anger_cost => 'Costo :fu_a',
    :element_set => 'Elementi',
    :aggro_set => 'Incremento Odio',
    :grudge_set => 'Incremento Odio',
    :total_aggro => 'Odio',
    :state_inf_dur => 'Bonus Durata Stati',
    :anger_rate => 'Incremento :anger',
    :tank_odd => 'Odio sul Tank',
    :heal => 'Cura base',
    :esper => 'Evoca',
    :recharge => 'Ricarica ATB',
    :selling_price => 'Prezzo vendita',
    :damage_rate => 'Danno ricevuto',
    # status
    :hp_on_guard => ':hp_a su :guard',
    :mp_on_guard => ':mp_a su :guard',
    :heal_amplify => 'Pot. cure',
    :atk_rate => 'Bonus :atk.',
    :spi_rate => 'Bonus :def',
    :def_rate => 'Bonus :spi',
    :agi_rate => 'Bonus :agi',
    :heal_rate => 'Bonus cure ricev.',
    :dom_bonus => 'Durata evocazioni',
    :incentive => 'Sinergia per turno',
    :sin_durab => 'Durata Sinergia',
    :sin_bonus => 'Sinergia',
    :sin_on_kill => 'Sinergia uccisione',
    :sin_on_guard => 'Sin. se colpito su :guard',
    :sin_on_start => 'Sinergia iniziale',
    :sin_on_eva => 'Sinergia su :eva',
    :sin_on_heal => 'Sin. su Cura',
    :sin_on_state => 'Sin. infliggendo Stati',
    :atb_base => 'ATB iniziale',
    :steal_bonus => 'Prob. Furto',
    :drop_bonus => 'Drop oggetti',
    :gold_bonus => 'Oro dai nemici',
    :exp_bonus => ':exp',
    :ap_bonus => 'Bonus :ap',
    :mp_cost_rate => 'Costo abilità',
    :anger_init => ':anger iniziale',
    :anger_kill => ':anger a uccisione',
    :anger_turn => ':anger per turno',
    :max_anger => ':anger max',
    :anger_bonus => ':anger su attacco',
    :anger_damage => ':anger su danno subito',
    :magic_def => ':def magica',
    :magic_dmg => 'Danno magico',
    :physical_dmg => 'Danno fisico',
    :hp_on_win => ':hp_a vincendo',
    :mp_on_win => ':mp_a vincendo',
    :buff_durability => 'Durata buff',
    :debuff_durability => 'Durata debuff',
    :state_inf_per => 'Prob. inf. stati',
    :charge_bonus => 'Vel. caricamento',
    :critical_damage => 'Danno critico',
    :synth_bonus => 'Bonus prob. sintesi',
    :charge_time => 'Tempo di carica',
    :normal_attack_bonus => 'Danni attacco normale',
    :normal_attack_plus => 'Danni attacco normale',
    :buy_discount => 'Sconto negozio',
    :sell_bonus => 'Bonus rivendita',
    :escape_bonus => 'Bonus. fuga',
    :max_assimilable_skills => 'N°Max assimilabili',
    :hp_on_kill => ':hp_a su uccisione',
    :mp_on_kill => ':mp_a su uccisione',
    :knockback_rate => 'Contraccolpo',
  }

  FEATURES = {
    :absorb_damage_party => 'Assorbimento su Gruppo',
    :recharge_skills => 'Ricarica le abilità',
    :buff_steal => 'Ruba i potenziamenti',
    :debuff_pass => 'Passa le condizioni al bersaglio',
    :switchable => 'Bersaglio libero',
    :assimilate => 'Copia le abilità',
    :ranged? => 'Lunga distanza',
    :ignore_defense => 'Ignora :def bers.',
    :absorb_damage => 'Assorbe il danno',
    :critical_condition => 'Critico su condizione',
    :special_skill => 'USA IN SINERGIA',
    :hidden_troop? => 'Trappola di mostri',
    # status
    :parry => 'Contrattacco su schivata',
    :pharmacology => 'Effetto pozioni doppio',
    :show_atb => 'Mostra ATB nemici',
    :super_guard => '1/4 danni su :guard',
    :autoscan => 'Scansiona i nemici',
    :last_chance => 'Previene i colpi mortali',
    :double_exp_gain => 'Raddoppia l\'esperienza acquisita',
    :release_by_damage => 'Svanisce se colpito',
    :bombify => 'Esplode alla morte',
    :rune => 'Assorbe magie in :mp_a',
    :zombie => 'Le cure ti danneggiano',
    # solo armi
    :two_handed => 'Richiede due mani',
    :dual_attack => 'Doppio attacco',
    # solo armature
    :half_mp_cost => 'Dimezza il costo delle abilità',
    :prevent_critical => 'Previene colpi critici',
    :auto_hp_recover => 'Ripristina :hp con il tempo',
    :reduce_hit_ratio => 'Riduce la :hit ad 1/4',
    :transfer_aggro => 'Passa :aggro a qualcun altro',
    :apeiron => 'Limitatore parametri rimosso',
    :steal_skill => 'Può rubare oggetti',
    :robbery_skill => 'Può rubare denaro',
  }

  VARIABLE_FEATURES = {
    :atb_base => 'ATB iniziale %d%%',
    :spirit_attack => 'Bonus :atk sul %d%% dello :spi',
    :spirit_defense => 'Bonus :def sul %d%% dello :spi',
    :spirit_agi => 'Bonus :agi sul %d%% dello :spi',
    :sin_on_weak => '%+d%% Sinergia sfruttando debolezze',
    :sin_on_cri => '%+d%% Sinergia su danni critici',
    :mp_damage_per => '%d%% del danno ai :mp_a'
  }

  WEAPON_REQUIREMENTS = {
    ['bianca'] => "un'arma da mischia",
    ['spada'] => 'una spada',
    ['due mani'] => "un'arma a due mani",
    %w[spada due_mani] => 'uno spadone',
    ['spada' 'due mani'] => 'uno spadone',
    %w[bianca bianca] => 'due armi da mischia',
    ['scudo'] => 'uno scudo',
    ['daga'] => 'un pugnale',
    %w[spada scudo] => 'spada e scudo',
    %w[bianca scudo] => 'arma e scudo',
    %w[spada spada] => 'due spade',
    %w[daga daga] => 'due pugnali',
    ['lancia'] => 'una lancia',
    ['blunt'] => 'mazza o ascia',
    ['fucile'] => "un'arma da fuoco",
    ['arco'] => 'un arco',
    ['flauto'] => 'uno strumento musicale'
  }

  PARAM_FORMAT = { :hit => '%d%%', :cri => '%d%%', :state_duration => '%d turni',
                   :atk => '%+d', :def => '%+d', :spi => '%+d', :agi => '%+d', :maxhp => '%+d',
                   :maxmp => '%+d',
                   :turn_delay => '%d turni', :battle_delay => '%d batt.', :damage_delay => '%d PV',
                   :step_delay => '%d passi', :hp_on_guard => { :format => '%d%%', :formula => 'val*100' },
                   :mp_on_guard => { :format => '%d%%', :formula => 'val*100' }, :heal_rate => '%d%%',
                   :anger_damage => '%+d', :charge_bonus => { :formula => 'val*-1' },
                   :heal_amplify => '%+d%%', :atb_base => '%d%%', :sin_durab => '%+d%%',
                   :sin_bonus => { :format => '%+d%%', :formula => 'val*100' },
                   :dom_bonus => { :format => '%+d%%', :formula => 'val*100' },
                   :steal_bonus => { :format => '%+d%%', :formula => 'val*100' },
                   :drop_bonus => { :format => '%+d%%', :formula => 'val*100' },
                   :gold_bonus => { :format => '%+d%%', :formula => 'val*100' },
                   :exp_bonus => { :format => '%+d%%', :formula => 'val*100' },
                   :ap_bonus => { :format => '%+d%%', :formula => 'val*100' },
                   :buff_durability => '%+d', :charge_time => {:format => '%d%% ATB', :rev => true},
                   :debuff_durability => { :format => '%+d', :rev => true },
                   :state_inf_per => { :format => '%+d%%', :formula => 'val*100' },
                   :magic_dmg => { :format => '%+d%%', :formula => 'val*100' },
                   :physical_dmg => { :format => '%+d%%', :formula => 'val*100' },
                   :mp_cost_rate => { :format => '%+d%%', :formula => 'val*100', :rev => true },
                   :magic_def => { :format => '%+d%%', :formula => 'val*100' },
                   :critical_damage => '%+gx',
                   :spirit_attack => { :format => '%d%%', :formula => 'val*100'},
                   :spirit_agi => { :format => '%d%%', :formula => 'val*100'},
                   :spirit_defense => { :format => '%d%%', :formula => 'val*100'},
                   :hp_on_win => { :format => '%+d%%', :formula => 'val*100'},
                   :mp_on_win => { :format => '%+d%%', :formula => 'val*100'},
                   :hp_on_kill => { :format => '%+d%%', :formula => 'val*100'},
                   :mp_on_kill => { :format => '%+d%%', :formula => 'val*100'},
                   :recharge => '%+d%%',
                   :normal_attack_bonus => { :format => '%+d%%', :formula => 'val*100'},
                   :normal_attack_plus => { :format => '%+d'},
                   :buy_discount => { :format => '%+d%%', :formula => 'val*100'},
                   :sell_bonus => { :format => '%+d%%', :formula => 'val*100'},
                   :sin_on_heal => {:format => '%+d%%', :formula => 'val*100'},
                   :sin_on_weak => {:formula => 'val*100'},
                   :sin_on_cri => {:formula => 'val*100'},
                   :sin_on_state => {:format => '%+d%%', :formula => 'val*100' },
                   :damage_rate => {:format => '%+d%%', :formula => 'val*100', :rev => true },
                   :knockback_rate => {:format => '%d%% danno inf.', :formula => 'val * 100', :rev => true},


  }

  # colori delle feature. Il primo colore è quello in primo piano,
  # il secondo dello sfondo. Se simbolo -> metodo, se numero -> codice
  # colore altrimenti oggetto colore
  FEATURE_COLORS = {
    :apeiron => [:crisis_color, :knockout_color],
    :autoscan => [31, :anger_color],
    :reduce_hit_ratio => [:knockout_color],
    :release_by_damage => [:crisis_color],
    :bombify => [:knockout_color],
    :special_skill => [:knockout_color, :crisis_color],
    :rune => [31],
    :zombie => [:knockout_color]
  }

  SWITCH_SE = 'Switch1'
  BREAK_SE = 'Break'
  SORT_SE = 'Decision2'
end

module Sound
  def self.play_switch
    RPG::SE.new(Settings::SWITCH_SE).play
  end

  def self.play_break
    RPG::SE.new(Settings::BREAK_SE).play
  end

  def self.play_sort

  end
end

module Icon
  def self.on_switch
    Settings::SWITCH_ON_ICON
  end

  def self.off_switch
    Settings::SWITCH_OFF_ICON
  end

  def self.new_advice
    Settings::NEW_ADVICE_ICON
  end

  # ottiene l'icona dell'elemento
  def self.element(element_id)
    return 0 if $data_system.nil?
    $data_system.attribute_icon(element_id)
  end

  # restituisce l'icona del parametro (se definita), altrimenti 0
  # @param [Symbol] param
  # @return [Fixnum]
  def self.param(param)
    Settings::PARAM_ICONS[param] || 0
  end

  def self.checked
    Settings::CHECKED_ICON
  end

  def self.unchecked
    Settings::UNCHECKED_ICON
  end

  def self.check(value)
    value ? checked : unchecked
  end

  def self.gold
    Settings::GOLD_ICON
  end
end

module Vocab
  class << self
    # noinspection RubyResolve
    alias int_param param
  end

  # @return [String]
  def self.prev_scene_name
    scene = SceneManager.prev_scene
    return '' if scene.nil?
    scene_name(scene)
  end

  # @param [Scene_Base, Scene_MenuBase] scene
  # @return [String]
  def self.scene_name(scene)
    Settings::SCENE_NAMES[scene.class.to_s] || scene.class.to_s
  end

  def self.turns
    Settings::TURNS
  end

  # @return [String]
  def self.back
    Settings::BACK
  end

  def self.enable
    Settings::ENABLE
  end

  def self.disable
    Settings::DISABLE
  end

  def self.select
    Settings::SELECT
  end

  def self.switch_actor
    Settings::SWITCH_ACTOR
  end

  def self.causes
    Settings::CAUSES_STATE
  end

  def self.removes
    Settings::REMOVES_STATE
  end

  def self.growth
    Settings::GROWTH
  end

  def self.immune
    Settings::IMMUNE
  end

  def self.ok
    Settings::OK_VOCAB
  end

  def self.yes
    Settings::YES_VOCAB
  end

  def self.no
    Settings::NO_VOCAB
  end

  def self.requirements
    Settings::REQUIREMENTS
  end

  # Restituisce l'elemento dall'ID
  # @param [Integer, nil] element_id se nil, restituisce "Elemento"
  # @return [String]
  def self.element(element_id = nil)
    return Settings::ELEMENT_VOCAB if element_id.nil?
    return $data_system.elements[element_id]
  end

  # Restituisce i vocaboli dei rispettivi parametri
  # @return [String]
  def self.hit
    'Mira'
  end

  def self.eva
    'Evasione'
  end

  def self.cri
    'Prob. Critici'
  end

  def self.mag
    'Furia Max'
  end

  # Vocabolo Furia
  def self.anger
    'Furia'
  end

  # Vocabolo Furia (abbreviato)
  def self.fu_a
    'FU'
  end

  def self.resistance_a
    Settings::RESISTANCE_ABBREV
  end

  def self.damage_power
    Settings::DAMAGE_POWER
  end

  def self.damage_mp_power
    sprintf(Settings::DAMAGE_POWER_MP, mp_a)
  end

  def self.heal_power
    Settings::HEAL_POWER
  end

  def self.heal_mp_power
    sprintf(Settings::HEAL_POWER_MP, mp_a)
  end

  def self.attribute(attribute)
    if Settings::PARAM_VOCABS.include?(attribute)
      convert_innested_params(Settings::PARAM_VOCABS[attribute])
    else
      param(attribute) || attribute.to_s
    end
  end

  # @param [Symbol] param
  # @param [Object] value
  # @return [String]
  def self.formatted_param(param, value)
    if SkillSettings::PARAM_FORMAT[param]
      sprintf(convert_innested_params(SkillSettings::PARAM_FORMAT[param]), value)
    else
      param.to_s
    end
  end

  # Restituisce un determinato parametro
  # @param [Symbol] symbol
  # @return [String]
  def self.param(symbol)
    case symbol
    when :atk
      return atk
    when :def
      return self.def
    when :spi
      return spi
    when :agi
      return agi
    when :cri
      return cri
    when :eva
      return eva
    when :hit
      return hit
    when :odds, :odd
      return odds
    when :hp, :mhp, :max_hp, :hp, :maxhp
      return hp
    when :mp, :max_mp, :mmp, :maxmp
      return mp
    when :max_anger, :mag
      return mag
    when :last_dmg
      return 'Ultimo Danno'
    when :cum_dmg
      return 'Danno totale subito'
    when :debuff
      return 'Depotenziamenti'
    else
      if symbol.is_a?(Fixnum)
        int_param(symbol)
      else
        Vocab.respond_to?(symbol) ? Vocab.send(symbol) : symbol.to_s
      end
    end
  end

  # mostra la traduzione della feature
  # @param [Symbol] feature_sym
  # @param [String, Fixnum, Float] value
  # @return [String]
  def self.feature(feature_sym, val = nil)
    if val.nil?
      convert_innested_params(Settings::FEATURES[feature_sym]) || ''
    elsif Settings::VARIABLE_FEATURES[feature_sym] != nil
      sprintf(convert_innested_params(Settings::VARIABLE_FEATURES[feature_sym]), val)
    else
      ''
    end
  end

  # @param [String] str
  def self.convert_innested_params(str)
    str.gsub(/:([\w|_]+)/) {param($1.to_sym)}
  end
end

module SceneManager
  # restituisce la schermata precedente
  # @return [Scene_Base, Scene_MenuBase]
  def self.prev_scene
    @stack[-1]
  end
end

class Parameter_Value
  # @return[Symbol]
  attr_reader :param
  # @return[String]
  attr_reader :param_name
  attr_reader :icon_index
  # @param [Symbol] param
  def initialize(param)
    @param_name = Vocab.attribute(param)
    @format = nil
    @reverse = false
    @formula = nil
    @icon_index = Settings::PARAM_ICONS[param] || 0
    param_format = Settings::PARAM_FORMAT[param]
    if param_format != nil and param_format.is_a?(Hash)
      @reverse = param_format[:rev] == true
      @formula = param_format[:formula]
      @format = param_format[:format]
    elsif param_format != nil and param_format.is_a?(String)
      @format = param_format
    end
  end

  # @return [String]
  def parse_val(value)
    @format.nil? ? value.to_s : sprintf(@format, value)
  end

  def calc_val(val)
    @formula.nil? ? val : eval(@formula)
  end

  def reverse?
    @reverse
  end
end