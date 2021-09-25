#==============================================================================
# ** ExtraAttr
#---------------------------------------------------------------------------
# Contiene le stringhe per gli attributi
#==============================================================================
module ExtraAttr

  PARAM_BONUS_ADD = /<(maxhp|maxmp|mhp|mmp|odds|atk|spi|agi|def|cri|hit|eva):[ ]*([+\-]\d+)>/i
  PARAM_BONUS_PER = /<(atk|def|spi|agi|maxhp|maxmp|mhp|mmp|cri|hit|eva|odds):[ ]*([+\-]\d+)%>/i
  DOM_BONUS = /<(?:BONUS_EVOCAZIONE|bonus evocazione):[ ]*(\d+)([%％])>/i
  VIRIL = /<(?:VIRILE|virile)>/i
  ARTIFICIS = /<(?:ARTIFICIERE|artificiere)>/i
  SCASSINATE = /<(?:SCASSINATORE|scassinatore)>/i
  CHARM = /<carisma:[ ]*([+\-]\d+)>/i
  DEFENDER = /<difensore>/i
  STATE_DMG = /<danno[ _]stato[ ]*(\d+):[ ]*(\d+)([%％])>/i
  STATE_HIT = /<attacco[ _]stato[ ]*(\d+):[ ]*(\d+)([%％])>/i
  EVOCATION = /<evoca:[ ]*(\d+)>/i #TODO: spostarlo in espers core
  ESPER_REC = /<ricarica[ _]esper>/i #TODO: spostarlo in espers core
  ITEM_SAVE = /<salva[ _]oggetto:[ ]*(\d+)([%％])>/i
  FAST_READY = /<bonus ricarica:[ ]*(\d+)([%％])>/i
  SAVE_DOMI = /<salva dominazione:[ ]*(\d+)>/i
  TAUMATURG = /<taumaturgia>/i
  ITEM_BON = /<oggetto[ _]bonus:[ ]*(\d+)([%％])>/i
  ATB_BONUS = /<bonus[ _]atb>/i
  ATB_SONG = /<atb[ _]canzone>/i
  SHOW_ATB = /<show[ _]atb>/i
  LONG_JUMP = /<salto[ _]lungo>/i
  VAMPIRE_A = /<vampiro[ ]+(\d+)%>/i
  RHYTM = /<ritmo>/i
  PARTY_BON = /<bonus[ _]party[ ](.*)>:[ ]*(\d+)([%％])>/i
  MP_RATE = /<costo[ _]mp:[ ]*([+\-]\d+)([%％])>/i
  HELP_STRT = /<help>/i
  HELP_END = /<\/help>/i
  FAST_HELP = /<h\+(.+)>/mi
  VLINK = /<vlink>/i
  APEIRON = /<apeiron>/i
  SET_SKILL = /<skills:[ ]*(\d+(?:\s*,\s*\d+)*)>/i
  VIRAL = /<virale>/i
  HEAL_RATE = /<cura:[ ]*([+\-]\d+)[%％]>/i
  BOMBER = /<bombifica>/i
  SPIRITOL = /<spirit stone>/i
  REM_STATE = /<rimuovi stato:[ ]+(\d+)>/i
  PHI_DAMG = /<danno fisico:[ ]*([+\-]\d+)([%％])>/i
  MAG_RATE = /<rate magico:[ ]*([+\-]\d+)([%％])>/i
  MAG_DAMG = /<danno magico:[ ]*([+\-]\d+)([%％])>/i
  MAG_DEFR = /<difesa magica:[ ]*([+\-]\d+)([%％])>/i
  PAR_GIFT = /<dona (.+):[ ]*(\d+)([%％])>/i
  COUNTER_ST = /<controstato:[ ]*(\d+)>/i
  PHIS_REF = /<rifletti fis:[ ]*(\d+)([%％])>/i
  PARTY_ABS = /<assorbi gruppo>/i
  ANGER_AMM = /<ira:[ ]*([+\-]\d+)>/i
  ANGER_MAX = /<ira max:[ ]*([+\-]\d+)>/i
  ANGER_COST = /<costo ira:[ ]*(\d+)>/i
  ANGER_INIT = /<ira iniziale:[ ]*(\d+)>/i
  ANGER_RATE = /<incremento ira:[ ]*([+\-]\d+)>/i
  ANGER_MANT = /<mantieni ira:[ ]*([+\-]\d+)>/i
  ANGER_TURN = /<ira turno:[ ]*([+\-]\d+)>/i
  ANGER_DAMG = /<ira su danno:[ ]*(\d+)>/i
  ANGER_KILL = /<ira kill:[ ]*(\d+)>/i
  MAX_NUMBER = /<num massimo:[ ]*(\d+)>/i
  TANK_ODDS = /<odio tank:[ ]*([+\-]\d+)>/i
  ATK_P_STA = /<status attacco:[ ]*(\d+)>/i
  ATK_M_STA = /<status rimosso:[ ]*(\d+)>/i
  SPI_ATK = /<spirattacco:[ ]*([+\-]\d+)([%％])>/i
  SPI_DEF = /<spiridifesa:[ ]*([+\-]\d+)([%％])>/i
  SPI_AGI = /<spirivelocit[aà]:[ ]*([+\-]\d+)([%％])>/i
  WIN_HP = /<pv vittoria:[ ]*(\d+)([%％])>/i
  WIN_MP = /<pm vittoria:[ ]*(\d+)([%％])>/i
  CRI_DEF = /<difesa critici:[ ]*(\d+)([%％])>/i
  DMG_MOD = /<modificatore danno:[ ]*(\d+)([%％])>/i
  TR_BUFF = /<buff>/i
  TR_DEBUFF = /<debuff>/i
  STAT_INCR = /<incrementa[ ]*(.+):[ ]*([+\-]\d+)>/i
  BUFF_BONUS = /<durata buff:[ ]*([+\-]\d+)>/i
  DEBF_MALUS = /<durata debuff:[ ]*([+\-]\d+)>/i
  STATE_BON = /<bonus stati:[ ]*([+\-]\d+)>/i
  ST_BON_PER = /<bonus stati:[ ]*([+\-]\d+)%>/i
  ST_BON_IGN = /<ignora bonus stati>/i
  ST_INF_DUR = /<durata stati inflitti:[ ]*([+\-]\d+)>/i
  FIXED_DUR = /<durata fissa>/i
  SK_COST_TP = /<costo[ ]*(.):[ ]*([+\-]\d+)%>/i
  SK_TYPE_CS = /<sk_type:[ ]*(.)>/i
  MASTERY = /<mastery (.+):[ ]*([+\-]\d+)%[ ]*(.+)>/i
  MONSTER_T = /<troop:[ ]*(\d+)>/i
  TRADE_LOCK = /<blocca scambi>/i
  MECHANIC = /<meccanica>/i
  GUARD_TEXT = /<nome guardia:[ ]*(.+)>/i
  ATTACK_TEXT = /<nome attacca:[ ]*(.+)>/i
  LAST_CHANCE = /<ultima chance>/i
  JAPANESE_NM = /<jappo:[ ]*(.+)>/i
  ALLOW_EQUIP = /<permetti equip[ ]+(.+)>/i
  SYNTH_BONUS = /<synth bonus:[ ]*([+\-]\d+)[%％]>/i
  REC_SKILLS = /<ricarica skills>/i
  EQIP_LEVEL = /<livello:[ ]+(\d+)>/i
  CRIT_DMG = /<danno critico:[ ]*([+\-]\d+)([%％])>/i
  SET_BONUS = /<set bonus>/i
  SPOIL = /<spoil:[ ]*([+\-]\d+)([%％])>/i
  MEELE = /<meele>/i
  RANGED = /<ranged>/i
  ZOMBIE = /<zombie>/i
  BARRIER_RATE = /<barriera:[ ]*(\d+)([%％])>/i
  BARRIER_OPTIM = /<consumo barriera:[ ]*([+\-]\d+)([%％])>/i
  MAGIC_ATTACK = /<attacco magico:[ ]*(\d+)([%％])>/i
  SUPPORT_TYPE = /<tipo supporto:[ ]*(.+)>/i
  CHANGE_SUPPORT = /<usa supporto:[ ]*(.+)>/i
  PLACEHOLDER_ID = /<placeholder:[ ]*(\d+)>/i
  PLACEHOLDER = /<placeholder>/i
  HP_ON_GUARD = /<([+\-]\d+)% hp difesa>/i
  MP_ON_GUARD = /<([+\-]\d+)% mp difesa>/i
  FU_ON_GUARD = /<([+\-]\d+)% furia difesa>/i
  BUFF_STEAL = /<ruba buff>/i
  ATTACK_ATTR = /<tipo attacco:[ ]*(\d+)>/i
  DEBUFF_PASS = /<trasferisci debuff>/i
  RESET_DAMAGE = /<reset cumuled damage>/i
  BLOCK_LAST_SKILL = /<blocca ultima skill>/i
  RUNE_STATE = /<rune>/i
  MP_ON_ATTACK = /<(\d+) mp attacco>/i
  AUTOSCAN = /<autoscan>/i
  ASSIMILATE = /<assimilate>/i
  ASSIMILABLE = /<assimilable>/i
  MAX_ASSIMILABLE = /<max assimilate: ([+\-]\d+)>/i
  ASSIMILATE_ROUNDS = /<assimilate rounds: ([+\-]\d+)>/i
  SKILL_MP_DAMAGE_PER = /<mp damage:[ ]*(\d+)([%％])>/i
  SKILL_MP_HEAL_PER = /<mp heal:[ ]*(\d+)([%％])>/i
  SLIP_DAMAGE_PER = /<slip (\d+)([%％]) damage>/i
  USE_ANGER = /<usa furia>/i
  BOSS_TYPE = /<boss type>/i
  SWITCHABLE = /<switchable>/i
  AVOID_SELF = /<avoid self>/i
  PROTECTOR = /<protector>/i
  UNPROTECTED = /<unprotected>/i
  OFF_MAGIC_STATE = /<status magie off:[ ]*(\d+)>/i
  HEA_MAGIC_STATE = /<status magie cur:[ ]*(\d+)>/i
  MENU_SWITCH = /^<menu switch:[ ]*(\d+)>$/i
  SUPER_GUARD = /<super guard>/
  PHARMACOLOGY = /<pharmacology>/
  STATE_GUARD = /<state guard>/
  PARRY = /<parry>/
  HP_ON_KILL = /<hp kill:[ ]*(\d+)([%％])>/i
  MP_ON_KILL = /<mp kill:[ ]*(\d+)([%％])>/i
  LINKED_ELEMENT = /<linked[ _]element:[ ]*(\d+)>/i
  STATE_DEFENSE = /<state[ _]rate[ ]+(\d+):[ ]*([\+\-]\d+)%>/i
  AUTOSTATE_SKILL = /<autostate[ ]+(\d+):[ ]*(\d+)%>/i
  FORCE_ON_TARGET = /<force on[ ]+(actor|domination)>/i
  VANISH_ON_ATTACK = /<svanisce con attacco>/i
  CUSTOM_ATTACK = /<custom attack skill:[ ]*(\d+)>/i
  CUSTOM_DEFENSE = /<custom guard skill:[ ]*(\d+)>/i
  LEVEL_MULTIPLIER = /<level burst:[ ]*([\d.]+)x>/i
  DISARM = /<disarma>/i
  ATTACK_ELEMENT_EN = /<attack[ _]element:[ ]*(\d+)>/i
  ATTACK_ELEMENT_IT = /<elemento[ _]attacco:[ ]*(\d+)>/i
  ATTACK_ANIMATION = /<attack[ _]animation:[ ]*(\d+)>/i
  AVOID_DEFENSE = /<avoid[ _]defense>/i
  HIT_ALL = /<target[ _]all>/i
  HIT_WITH_STATES = /<target[ _]states:[ ]*(.+)>/i
  # Variabili di istanza pubbliche
  attr_reader :hit
  attr_reader :cri
  attr_reader :eva
  attr_reader :def
  attr_reader :atk
  attr_reader :spi
  attr_reader :agi
  attr_reader :maxhp
  attr_reader :maxmp
  attr_reader :odds
  attr_reader :dom_bonus # bonus dominazioni
  attr_reader :charm # charm
  attr_reader :status_hit #stato attivato ad attacco
  attr_reader :status_hit_prob #prob. attivazione stato
  attr_reader :status_dmg #stato attivato a danno
  attr_reader :status_dmg_prob #prob. attivazione stato
  attr_reader :item_save #prob. di non consumare l'oggetto
  attr_reader :fast_ready #bonus ricarica esper, solo per dominazioni
  attr_reader :save_domination #solo per dominazioni, nessun malus su morte
  attr_reader :item_bonus #bonus cura oggetti
  attr_reader :atb_bonus
  attr_reader :atb_song #passiva che velocizza se è una canzone
  attr_reader :mp_cost_rate #costo PM delle abilità
  # @attr[Hash<Integer>] bonus parametri al gruppo (vedere poi)
  attr_reader :party_bonus
  attr_reader :vlink #link vitale (prende % di danni dagli ally)
  attr_reader :viral #status virale (si contagia)
  attr_reader :minus_state_set #non usato (forse)
  # @attr[Array<Integer>] stati aggiunti all'attacco
  attr_reader :attack_plus_states
  # @attr[Array<Integer>] stati rimossi all'attacco
  attr_reader :attack_minus_states
  attr_reader :vampire_rate #% di danni assorbiti con qualsiasi danno
  attr_reader :skill_set #non è più usato
  attr_reader :bombifica #skill che trasforma nemici in bombe
  attr_reader :phisic_dmg #danno fisico (% bonus di danno inflitto)
  attr_reader :magic_def #difesa magica (% di danno subìto)
  attr_reader :magic_dmg #attacco magico (% bonus di danno inflitto)
  attr_reader :heal_rate # rate di cura HP, MP e Furia
  # @return[Hash<Integer>] % di dono dei propri parametri agli alleati
  attr_reader :param_gift
  attr_reader :physical_reflect #% di danni fisici riflessi al nemico
  attr_reader :anger_bonus #incremento furia acquisita attaccando
  attr_reader :max_anger_bonus #incremento furia massima
  attr_reader :anger_init #furia iniziale
  attr_reader :anger_damage #furia acquisita dopo aver subito un colpo
  attr_reader :anger_mantain #mantenimento furia dopo un combattimento
  attr_reader :anger_kill #furia caricata dopo un'uccisione
  attr_reader :anger_turn #furia che si carica ad ogni turno
  attr_reader :max_number #numero massimo di oggetti trasportabili
  attr_reader :spirit_attack #% di spirito che incrementa l'attacco
  attr_reader :spirit_defense #% di spirito che incrementa la difesa
  attr_reader :spirit_agi #% di spirito che incrementa la velocità
  attr_reader :hp_on_win #% di pv curati alla vittoria
  attr_reader :mp_on_win #% di pm curati dopo una vittoria
  attr_reader :masteries #bonus maestria per equipaggiamento
  attr_reader :state_inf_bon #bonus per difendersi da status
  attr_reader :state_inf_per #bonus in percentuale dello status
  attr_reader :ignore_bonus #ignora bonus
  attr_reader :buff_durability #durata buff
  attr_reader :debuff_durability #durata debuff
  attr_reader :state_inf_dur #addizionatore turni di status inflitto
  attr_reader :skill_type_cost #modificatore costo per un tipo di skill
  attr_reader :trade_lock #l'equipaggiamento non è scambiabile
  attr_reader :guard_text #testo guardia
  attr_reader :attack_text #testo attacca
  attr_reader :last_chance #ultima chance
  attr_reader :critical_defense #difesa colpi critici
  attr_reader :damage_rate #rateo di danno ricevuto
  attr_reader :japanese_name #nome giapponese
  attr_reader :allow_equip_type #permette un tipo di equipaggiamento
  attr_reader :synth_bonus #bonus sintesi
  attr_reader :equip_level #livello equipaggiamento
  attr_reader :critical_damage #modificatore danno critico
  attr_reader :spoil_bonus #bonus drop del nemico (da status)
  attr_reader :ranged #tipo distanza
  attr_reader :counter_states #array ID stati che infligge con la difesa
  attr_reader :barrier_rate #rateo di assorbimento barriera
  attr_reader :barrier_save #rateo di risparmio PM della barriera
  attr_reader :zombie_state #è uno status zombie, quindi non cura
  attr_reader :magic_attack #se è > 0, l'attacco usa lo Spirito.
  attr_reader :use_support #determina il tipo di supporto da cambiare
  attr_reader :support_type #cambia lo scudo in un altro tipo di supporto
  attr_reader :is_placeholder #è un placeholder (per supporti speciali)
  attr_reader :hp_on_guard #rateo di cura HP con comando Difendi
  attr_reader :mp_on_guard #rateo di cura MP con comando Difendi
  attr_reader :fu_on_guard #rateo di carica Furia con Difendi
  attr_reader :attack_attr #attributo d'attacco (per i nemici anche)
  attr_reader :block_last_skill # attributo per gli status che bloccano l'ultima skill
  attr_reader :rune # flag assorbi tutte le magie
  attr_reader :mp_on_attack # guadagna MP attaccando
  attr_reader :autoscan # auto scan
  attr_reader :max_assimilable # numro massimo di abilità assimilabili insieme
  attr_reader :assimilate_rounds # numero di colpi disponibili per l'abilità assimilata
  attr_reader :protector # flag protettore (per i nemici o status)
  attr_reader :super_guard # flag superguardia
  attr_reader :pharmacology # flag doppio effetto item
  attr_reader :state_guard
  attr_reader :hp_on_kill # hp guadagnati su uccisione
  attr_reader :mp_on_kill # mp guadagnati su uccisione
  attr_reader :linked_element # elemento linkato. Funziona solo per la probabilità degli status
  attr_reader :custom_attack_skill # cambia l'attacco in una abilità separata
  attr_reader :custom_guard_skill # cambia la Difesa in un'abilità separata
  attr_reader :custom_level_multiplier
  attr_reader :attack_elements
  attr_reader :custom_attack_animation
  # @return [Array<Symbol>] le qualità specifiche (on-off)
  attr_reader :qualities
  # @return [Array<Integer>]
  attr_reader :offensive_magic_states
  # @return [Array<Integer>]
  attr_reader :heal_magic_states
  # @return [Hash]
  attr_reader :state_rate_set
  # @return [Hash]
  attr_reader :stat_per
  # Carica gli attributi aggiuntivi dell'oggetto dal tag delle note
  # noinspection RubyScope
  def load_extra_attr
    return if @attributi_caricati
    @attributi_caricati = true
    @qualities = []
    @description = '' if @description.nil?
    @description = @passive_description if @passive_description
    @equip_level = default_level
    @dom_bonus = 0
    @charm = 0
    @counter_states = []
    @minus_state_set = []
    @param_gift = {:atk => 0, :def => 0, :spi => 0, :agi => 0}
    @status_hit = 0
    @status_hit_prob = 0
    @status_dmg = 0
    @status_dmg_prob = 0
    @fast_ready = 0
    @vampire_rate = 0
    @item_save = 0
    @anger_bonus = 0
    @anger_mantain = 0
    @max_anger_bonus = 0
    @item_bonus = 0
    @physical_reflect = 0
    @anger_init = 0
    @magic_def = 0.0
    @phisic_dmg = 0.0
    @magic_dmg = 0.0
    @mp_on_attack = 0
    @heal_rate = 0
    @atb_bonus = 0
    @atb_song = 0
    @skill_set = []
    @mp_cost_rate = 0.0
    @anger_kill = 0
    @party_bonus = {}
    @anger_turn = 0
    @anger_damage = 0
    @max_number = 99
    @attack_plus_states = []
    @attack_minus_states = []
    @spirit_attack = 0
    @spirit_defense = 0
    @spirit_agi = 0
    @hp_on_win = 0.0
    @mp_on_win = 0.0
    @buff_type = :none
    @state_inf_bon = 0
    @state_inf_per = 0.0
    @state_inf_dur = 0
    @buff_durability = 0
    @debuff_durability = 0
    @stat_increment = {}
    @skill_type_cost = {}
    @masteries = {}
    @critical_defense = 0
    @damage_rate = 0.0
    @synth_bonus = 0
    @critical_damage = 0.0
    @spoil_bonus = 0.0
    @allow_equip_type = []
    reading_help = false
    @barrier_rate = 0
    @barrier_save = 0
    @magic_attack = 0
    @support_type = nil
    @use_support = nil
    @hp_on_guard = 0
    @mp_on_guard = 0
    @fu_on_guard = 0
    @attack_attr = nil
    @max_assimilable = 0
    @slip_damage_per = 0
    @offensive_magic_states = []
    @heal_magic_states = []
    @hp_on_kill = 0
    @mp_on_kill = 0
    @linked_element = 0
    @state_rate_set = {}
    @custom_attack_skill = 0
    @custom_guard_skill = 0
    @custom_level_multiplier = 0
    @attack_elements = []
    @custom_attack_animation = nil
    @maxhp = 0 if @maxhp.nil?; @maxmp = 0 if @maxmp.nil?; @cri = 0; @odds = 0
    @hit = 0 if @hit == nil; @eva = 0 if @eva == nil
    @atk = 0 if @atk.nil?; @def = 0 if @def.nil?
    @spi = 0 if @spi.nil?; @agi = 0 if @agi.nil?
    @stat_per ={ :atk => 0, :def => 0, :spi => 0, :maxhp => 0, :maxmp => 0,
                 :agi => 0, :hit => 0, :eva => 0, :cri => 0, :odds => 0}
    self.note.split(/[\r\n]+/).each { |row|
      if reading_help
        if row =~ HELP_END
          reading_help = false
        else
          @description += row
        end
        next
      end
      case row
      when FAST_HELP
        @description += $1
      when DOM_BONUS
        @dom_bonus = $1.to_f / 100
      when VIRIL
        @qualities.push(:viril)
      when ARTIFICIS
        @qualities.push(:artificis)
      when SCASSINATE
        @qualities.push(:scassinate)
      when CHARM
        @charm = $1.to_i
      when DEFENDER
        @qualities.push(:defender)
      when STATE_DMG
        @status_dmg = $1.to_i
        @status_dmg_prob = $2.to_f / 100
      when STATE_HIT
        @status_hit = $1.to_i
        @status_hit_prob = $2.to_f / 100
      when ESPER_REC
        @qualities.push(:esper_recharger)
      when ITEM_SAVE
        @item_save = $1.to_f / 100
      when FAST_READY
        @fast_ready = $1.to_i
      when SAVE_DOMI
        @qualities.push(:save_domination)
      when TAUMATURG
        @qualities.push(:taumaturgic)
      when ITEM_BON
        @item_bonus = $1.to_f / 100
      when ATB_BONUS
        @atb_bonus = $1.to_i
      when ATB_SONG
        @atb_song = $1.to_i
      when LONG_JUMP
        @qualities.push(:long_jump)
      when RHYTM
        @qualities.push(:rhytm)
      when MP_RATE
        @mp_cost_rate = $1.to_f / 100.0
      when HELP_STRT
        reading_help = true
      when VLINK
        @qualities.push(:vlink)
      when VIRAL
        @qualities.push(:viral)
      when VAMPIRE_A
        @vampire_rate += $1.to_i
      when REM_STATE
        @minus_state_set.push($1.to_i)
      when SET_SKILL
        $1.scan(/\d+/).each { |num|
          @skill_set.push(num.to_i) if num.to_i > 0 }
      when PARTY_BON
        param = $1.to_sym
        if [:atk, :def, :spi, :agi, :cri, :eva, :hit].include?(param)
          @party_bonus[param] = $2.to_f / 100.0
        end
      when BOMBER
        @qualities.push(:bombify)
      when PHI_DAMG
        @phisic_dmg += $1.to_f / 100.0
      when MAG_RATE
        @magic_def -= $1.to_f / 100.0
      when MAG_DEFR
        @magic_def += $1.to_f / 100.0
      when MAG_DAMG
        @magic_dmg += $1.to_f / 100.0
      when PAR_GIFT
        @param_gift[$1] = $2.to_f / 100.0
      when PHIS_REF
        @physical_reflect = $1.to_f / 100.0
      when ANGER_AMM
        @anger_bonus = $1.to_i
      when ANGER_MAX
        @max_anger_bonus = $1.to_i
      when ANGER_INIT
        @anger_init = $1.to_i
      when ANGER_DAMG
        @anger_damage = $1.to_i
      when ANGER_MANT
        @anger_mantain = $1.to_i
      when ANGER_KILL
        @anger_kill += $1.to_i
      when ANGER_TURN
        @anger_turn += $1.to_i
      when MAX_NUMBER
        @max_number = $1.to_i
      when ATK_P_STA
        @attack_plus_states.push($1.to_i)
      when ATK_M_STA
        @attack_minus_states.push($1.to_i)
      when SPI_ATK
        @spirit_attack += $1.to_f / 100.0
      when SPI_DEF
        @spirit_defense += $1.to_f / 100.0
      when SPI_AGI
        @spirit_agi += $1.to_f / 100.0
      when WIN_HP
        @hp_on_win += $1.to_f / 100.0
      when WIN_MP
        @mp_on_win += $1.to_f / 100.0
      when TR_BUFF
        @buff_type = :buff
      when TR_DEBUFF
        @buff_type = :debuff
      when BUFF_BONUS
        @buff_durability += $1.to_i
      when DEBF_MALUS
        @debuff_durability += $1.to_i
      when ST_INF_DUR
        @state_inf_dur += $1.to_i
      when STATE_BON
        @state_inf_bon += $1.to_i
      when ST_BON_PER
        @state_inf_per += $1.to_f / 100.0
      when ST_BON_IGN
        @qualities.push(:ignore_bonus)
      when SK_COST_TP
        @skill_type_cost[$1] = $2 / 100.0
      when TRADE_LOCK
        @qualities.push(:trade_lock)
      when MASTERY
        e_type = $1
        value = $2.to_i
        @mastery[$3.to_sym] = MasteryInfo.new(e_type, value)
      when GUARD_TEXT
        @guard_text = $1
      when ATTACK_TEXT
        @attack_text = $1
      when CRI_DEF
        @critical_defense = $1.to_i
      when DMG_MOD
        @damage_rate = $1.to_f / 100.0
      when JAPANESE_NM
        @japanese_name = $1
      when ALLOW_EQUIP
        @allow_equip_type.push($1)
      when SYNTH_BONUS
        @synth_bonus += $1.to_i
      when EQIP_LEVEL
        @equip_level = $1.to_i
      when CRIT_DMG
        @critical_damage = $1.to_f / 100
      when SET_BONUS
        @qualities.push(:set_bonus)
      when LAST_CHANCE
        @qualities.push(:last_chance)
      when MECHANIC
        @qualities.push(:mechanic)
      when SPOIL
        @spoil_bonus = $1.to_f / 100
      when RANGED
        @qualities.push(:ranged)
      when ZOMBIE
        @qualities.push(:zombie_state)
      when COUNTER_ST
        @counter_states.push($1.to_i)
      when BARRIER_RATE
        @barrier_rate = $1.to_f / 100.0
      when BARRIER_OPTIM
        @barrier_save = $1.to_f / 100.0
      when MAGIC_ATTACK
        @magic_attack = $1.to_f / 100.0
      when CHANGE_SUPPORT
        @use_support = $1.to_sym
      when SUPPORT_TYPE
        @support_type = $1.to_sym
      when PLACEHOLDER
        @qualities.push(:placeholder)
      when FU_ON_GUARD
        @fu_on_guard = $1.to_f / 100
      when HP_ON_GUARD
        @hp_on_guard = $1.to_f / 100
      when MP_ON_GUARD
        @mp_on_guard = $1.to_f / 100
      when ATTACK_ATTR
        @attack_attr = $1.to_i
      when BLOCK_LAST_SKILL
        @qualities.push(:block_last_skill)
      when RUNE_STATE
        @rune = true
      when FIXED_DUR
        @qualities.push(:fixed_duration)
      when MP_ON_ATTACK
        @mp_on_attack = $1.to_i
      when AUTOSCAN
        @qualities.push(:autoscan)
      when MAX_ASSIMILABLE
        @max_assimilable = $1.to_i
      when USE_ANGER
        @qualities.push(:use_anger)
      when SLIP_DAMAGE_PER
        @slip_damage_per = $1.to_f / 100.0
      when BOSS_TYPE
        @qualities.push(:boss_type)
      when PROTECTOR
        @qualities.push(:protector)
      when UNPROTECTED
        @qualities.push(:unprotected)
      when OFF_MAGIC_STATE
        @offensive_magic_states.push $1.to_i
      when HEA_MAGIC_STATE
        @heal_magic_states.push $1.to_i
      when SUPER_GUARD
        @qualities.push :super_guard
      when PHARMACOLOGY
        @qualities.push :pharmacology
      when STATE_GUARD
        @qualities.push :state_guard
      when PARRY
        @qualities.push :parry
      when HP_ON_KILL
        @hp_on_kill = $1.to_f / 100.0
      when MP_ON_KILL
        @mp_on_kill = $1.to_f / 100.0
      when LINKED_ELEMENT
        @linked_element = $1.to_i
      when STATE_DEFENSE
        @state_rate_set[$1.to_i] = $2.to_i
      when VANISH_ON_ATTACK
        @qualities.push(:vanish_on_attack)
      when CUSTOM_ATTACK
        @custom_attack_skill = $1.to_i
      when CUSTOM_DEFENSE
        @custom_guard_skill = $1.to_i
      when LEVEL_MULTIPLIER
        @custom_level_multiplier = $1.to_f - 1
      when DISARM
        @qualities.push(:disarm)
      when HEAL_RATE
        @heal_rate = $1.to_i
      when SHOW_ATB
        @qualities.push(:show_atb)
      when ATTACK_ELEMENT_EN, ATTACK_ELEMENT_IT
        @attack_elements.push($1.to_i)
      when ATTACK_ANIMATION
        @custom_attack_animation = $1.to_i
      when AVOID_DEFENSE
        @qualities.push(:avoid_defense)
      when PARAM_BONUS_ADD
        set_param_add($1.downcase.to_sym, $2.to_i)
      when PARAM_BONUS_PER
        set_param_per($1.downcase.to_sym, $2.to_i)
      when APEIRON
        @qualities.push(:apeiron)
      else
        #nothing
      end
    }
  end

  # calcola il livello richiesto
  def default_level
    return 0 unless (self.is_a?(RPG::Weapon) or self.is_a?(RPG::Armor))
    carica_cache_personale_class unless @tier
    (@tier - 1) * 10 + 5
  end

  # restituisce il moltiplicatore costo di una certa abilità
  def cost_skill(value)
    return 0 if @skill_type_cost[value].nil?
    @skill_type_cost[value]
  end

  # maestria
  def mastery(param, e_type)
    return 0 if @mastery[param].nil?
    return 0 if @mastery[param].e_type != e_type
    @mastery[param].value
  end

  # Restituisce true se è scambiabile tra giocatori
  def traddable?
    return false if self.price == 0
    return false if @trade_lock
    true
  end

  # Determina se l'equipaggiamento non si può disequipaggiare
  def equip_locked?
    false
  end

  def state_defense_rate(state_id)
    @state_rate_set[state_id] || 0
  end

  # @return [Hash]
  def state_rate_per
    @state_rate_set
  end

  def stat_bonus(param)
    @stat_per[param] || 0
  end

  def vanish_on_attack?
    has? :vanish_on_attack
  end

  # determina se ha la qualità
  # @param [Symbol] quality_sym
  def has?(quality_sym)
    @qualities.include? quality_sym
  end

  # determina se lo stato è un bonus set
  def set_bonus_state?
    has? :set_bonus
  end

  def fixed_duration?
    has? :fixed_duration
  end

  private

  # @param [Symbol] stat
  # @param [Integer] value
  def set_param_add(stat, value)
    case stat
    when :mhp, :maxhp
      @maxhp = value
    when :mmp, :maxmp
      @maxmp = value
    when :hit
      if self.is_a?(RPG::State)
        @hit = value
      else
        @hit += value
      end
    else
      eval("@#{stat.to_s} = #{value}")
    end
  end

  def set_param_per(stat, value)
    stat = :maxhp if [:mhp, :maxhp].include?(stat)
    stat = :maxmp if [:mmp, :maxmp].include?(stat)
    return set_param_add(stat, value) if [:agi, :hit, :cri].include?(stat)
    @stat_per[stat] = value
  end
end

#==============================================================================
# ** MasteryInfo
#---------------------------------------------------------------------------
# Classe che contiene le informazioni sulla mastery
#==============================================================================
class MasteryInfo
  attr_reader :e_type #tipo equip
  attr_reader :value #valore
  # Inizializzazione
  def initialize(e_type, value)
    @e_type = e_type
    @value = value
  end
end

class Autostate_Skill
  # @return [Integer]
  attr_reader :state_id
  # @return [Float]
  attr_reader :state_rate

  def initialize(state_id, probability)
    @state_id = state_id
    @state_rate = probability / 100.0
  end
end

module DataManager
  class << self
    alias attr_load_normal_database load_normal_database
    alias attr_load_battle_test_database load_battle_test_database
  end

  def self.load_normal_database
    attr_load_normal_database
    check_extra_attributes
  end

  def self.load_battle_test_database
    attr_load_battle_test_database
    check_extra_attributes
  end

  # Carica i dati degli oggetti
  # collection: collezione di oggetti
  def self.parse_bm_data(collection)
    collection.each { |obj| next if obj.nil?; obj.load_extra_attr }
  end

  # Carica gli attributi extra
  def self.check_extra_attributes
    parse_bm_data($data_skills)
    parse_bm_data($data_items)
    parse_bm_data($data_weapons)
    parse_bm_data($data_armors)
    parse_bm_data($data_states)
    parse_bm_data($data_enemies)
  end
end