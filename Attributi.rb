  # ==============================================================================
  #  ** ATTRIBUTI AGGIUNTIVI di Holy87
  #  -----------------------------------------------------------------------------
  #  Descrizione:
  #  Questo script i serve per aggiungere effetti speciali ad armi, skill e stati.
  #  BARRA FURIA: Gli eroi che non hanno MP avranno la barra Furia.
  #  -----------------------------------------------------------------------------
  #  Codici:
  # ▼ EVOCAZIONI
  #  ● <evoca: x> evoca l'eroe x
  #  ● <bonus evocazione: +x%> aumenta la durata delle evocazioni del x percento
  #  ● <ricarica esper> solo per le evocazioni, l'evocazione dura più a lungo
  #  quando subisce danni
  #  ● <vlink> sullo status usato come boost della dominazione: prende il 25% dei
  #  danni dell'evocatore
  #  ● <bonus ricarica: x%> la ricarica della dominazione impiega -x% battaglie
  #  ● <salva dominazione> se muore la dominazione non si dovrà aspettare il doppio
  #  delle battaglie
  # ▼ UTILITY ESPLORAZIONE
  #  ● <virile> ha virilità (sposta i blocchi più velocemente)
  #  ● <artificiere> disattiva le trappole
  #  ● <scassinatore> scassina le serrature
  #  ● <carisma: +x%> sconto sugli oggetti del x%
  #  ● <salto lungo> se un eroe con questo tag è nel gruppo, si può saltare più
  #  lontano.
  #  ● <oggetto bonus: x%> x% di probabilità di creare un oggetto bonus nelle
  #  trasmutazioni
  # ▼ SINERGIA
  #  ● <incentivo: +x> comincia la barra sinergia con x quantità piena (1000 max)
  #  ● <durata sinergia: +x%> incrementa la durata della sinergia del x%
  #  ● <bonus sinergia: x%> la sinergia si carica più velocemente del x%
  #  ● <sinergia: x> l'abilità carica x sinergia invece del valore di default
  # ▼ FURIA
  #  ● <ira: +/-x> aumenta o diminuisce l'ira che si ottiene attaccando
  #  ● <ira max: +/-x> aumenta o diminuisce l'ira massima
  #  ● <ira iniziale: +/-x> aumenta o diminuisce l'ira iniziale
  #  ● <incremento ira: +/-x> l'abilità incrementa l'ira di x
  #  ● <danno ira> l'ira aumenta anche se si viene colpiti
  #  ● <ira kill: x> Aumenta l'ira di x quando uccidi un nemico
  #  ● <mantieni ira: +/-x> l'ira si scarica di meno camminando
  #  ● <ira turno: +/-x> Aggiunge o rimuove Ira ad ogni turno.
  #  ● <usa furia> APPLICABILE SUL NEMICO: utilizza la Furia
  # ▼ QUALITÀ
  #  ● <difensore> chi ha questo status subisce il 20% dei danni di un alleato
  #  ● <super guard> danni ridotti a 1/4 quando ci si difende
  #  ● <pharmacology> raddoppia l'effetto di oggetti
  #  ● <immortality> è immortale
  #  ● <parry> quando si evita l'attacco, attacca il nemico
  #  ● <vlink> l'evocazione con questo status prende il 15% dei danni degli alleati
  #  ● <salva oggetto: x%> x% di probabilità di non consumare l'oggetto
  #  ● <taumaturgia> le skill con questo tag possono essere usate anche dal menu
  #  se l'eroe ha uno stato con questo tag
  #  ● <ritmo> quando si canta consecutivamente 3 canzoni o più, la velocità
  #  viene incrementata del 50%. Scompare se si fanno altre azioni
  #  (la skill deve avere il tag <tipo: Canto>)
  #  ● <ultima chance> per una volta nella battaglia, se subisce un colpo mortale
  #  l'eroe resta con 1PV invece di morire.
  #  ● <boss type> applicabile su un nemico, lo identifica come boss. Ci sono alcune
  #    variazioni per i boss, come la carica della Sinergia più lunga, gli status
  #    come Veleno che durano un numero limitato di turni e tolgono meno HP.
  #  ● <zombie> è un non morto! Le magie di guarigione gli causano danni.
  #  ● <protector> è un protettore. I nemici che non sono protettori non possono essere
  #    bersagliati da attacchi e abilità ravvicinate se prima non vengono uccisi tutti
  #    i protettori sul campo.
  #  ● <autoscan> su equip e stati: mostra ulteriori informazioni puntando i nemici
  # ▼ PARAMETRI
  #  ● <attacco magico: x%> l'attacco diventa una magia con il x% dello spirito. Tieni
  #  conto che nel caso degli eroi solo se l'arma principale ha attacco magico, usa
  #  quello. Per status ed altri equipaggiamenti, non viene applicato.
  #  ● <dona x: y%> dona il parametro x dell'y%, solo status
  #  ● <pv vittoria: x%> cura il X% di pv alla vittoria
  #  ● <pm vittoria: x%> cura il X% di pm alla vittoria
  #  ● <rifletti fis: x%> riflette x% di danno fisico
  #  ● <controstato: x> aggiunge status x al nemico quando vieni colpito da un attacco
  #  ● <mastery x: +y% z> il parametro z aumenta dell'y% quando possiede l'equip di
  #  tipo x
  #  ● <vampiro x%>: assorbe il x% dei danni curandosi
  #  ● <danno stato x: y%> y% di probabilità di attivare lo stato x quando si
  #  subisce un danno
  #  ● <attacco stato x: y%> y% di probabilità di attivare lo stato x quando si
  #  attacca il nemico
  #  ● <bonus party x: +y%> il parametro x del gruppo aumenta del y% se l'eroe con
  #  questo tag è presente in battaglia. x: atk, def, spi, agi, cri, eva, hit
  #  ● <costo mp: +/-x%> il costo delle abilità viene modificato del x%
  #  ● <costo x: +/-y%>  il costo dell'abilità di tipo x viene modificato del x%>
  #  ● <rate magico: +/-x%> aumenta o diminuisce il danno magico ricevuto
  #  ● <difesa magica: +/-x%> l'inverso del rate magico
  #  ● <danno magico: +/-x%> Danno magico inflitto
  #  ● <danno fisico: +/-x%> Danno fisico inflitto
  #  ● <difesa critici: +/-x%> aumenta o diminuisce le probabilità di subire
  #    danni critici dell'x% (NON FUNZIONA)
  #  ● <mod danno: +/-x%> aumenta o diminuisce il danno ricevuto in percentuale.
  #  ● <cura: +/-x%> aumenta o diminuisce la quantità di cure subite
  #  ● <danno critico: +/-x%> aumenta o diminuisce il danno degli attacchi critici
  #  ● <incrementa x: +/-y> aumenta il parametro x di y per la durata della battaglia
  #  ● <nome guardia: x> cambia il nome del comando Difendi
  #  ● <nome attacca: x> cambia il nome del comando Attacca
  #  ● <rune> tutte le magie che danneggiano/curano HP si trasformano in cura MP
  #  ● <barriera: x%> il x% dei danni viene assorbito da una barriera (consuma PM)
  #  ● <consumo barriera: +/-x%> il consumo MP della barriera aumenta o diminuisce dell'x%
  #  ● <spirattacco: x%> aggiunge all'attacco il x% del proprio spirito
  #  ● <spiridifesa: x%> aggiunge alla difesa il x% del proprio spirito
  #  ● <spirivelocità: x%> aggiunge alla difesa il x% del proprio spirito
  #  ● <x% hp difesa> gli HP vengono curati del x% quando ci si difende
  #  ● <x% mp difesa> uguale ma con gli MP
  #  ● <x% furia difesa> uguale ma con la Furia
  #  ● <x mp attacco> guadagna x MP colpendo i nemici con l'attacco
  #  ● <max assimilate: +x> aumenta le abilità assimilabili di x
  #  ● <assimilate rounds: +x> aumenta il numero di utilizzi delle abilità assimilate
  #  ● <hp kill: x%> ricarica gli HP del x% quando un nemico viene sconfitto
  #  ● <mp kill: x%> ricarica gli MP del x% quando un nemico viene sconfitto
  #  ▼ STATUS
  #  ● <status attacco: x> aggiunge lo status X all'attacco
  #  ● <status rimosso: x> rimuove lo status X all'attacco
  #  ● <status magie off: x> può applicare lo status X alla magia se causa danni, com probabilità dimezzate
  #  ● <status magie cur: x> può applicare lo status X alla magia se cura
  #  ● <buff> o <debuff> per impostare uno status positivo o negativo.
  #  ● <slip x% damage> danno progressivo del x% dei danni che ha causato
  #  ● l'abilità utilizzata per applicare lo status
  #  ● <bonus stati: +/-x> aumenta la potenza di riuscita dello status di x
  #  ● <bonus stati: +/-x%> aumenta la potenza di riuscita dello status del x%
  #  ● <durata stati inflitti: +/-x> aumenta la durata degli status che l'eroe infligge al bersaglio
  #  ● <durata fissa> non viene influenzato da bonus/malus durata stati
  #    infligge ad alleati o nemici (in turni).
  #  ● <durata buff: +/-x> modifica la durata dei buff acquisiti (in turni)
  #  ● <durata debuff: +/-x> modifica la durata dei debuff acquisiti (in turni)
  #  ● <blocca ultima skill> applicato allo status, blocca l'ultima skill usata
  #  ● <virale> lo status è virale e viene trasmesso.
  #  ▼ POTERI E OGGETTI
  #  ● <h+x> l'help aggiunge x
  #  ● <ranged> l'arma/skill è a distanza
  #  ● <spirit stone> l'oggetto è una spirit stone
  #  ● <rimuovi stato: x> rimuove lo stato x, ma non funziona ancora
  #  ● <bombifica> status che fa esplodere il nemico alla morte
  #  ● <odio tank: +/-x> aumenta o diminuisce l'odio del tank.
  #     Il tank in gruppo è Francesco, se assente è Luisa, altrimenti Maria Rosaria.
  #     Infine Michele.
  #  ● <sk_type: x> assegna il tipo di abilità (per il costo)
  #  ● <troop: x> l'oggetto è un gruppo di mostri in uno scrigno.
  #  ● <jappo: x> ha un nome giapponese. Per le skill di Ryusei.
  #  ● <ranged> l'oggetto o l'abilità è a distanza
  #  ● <ruba buff> l'abilità ruba tutti gli status (positivi e negativi)
  #  ● <reset cumuled damage> azzera il danno accumulato
  #  ● <assimilate> è un'abilità che può assimilare le altre abilità
  #  ● <mp damage: x%> dannegia anche i PM del x% del danno PV
  #  ● <switchable> l'abilità o l'oggetto può essere lanciato su nemici o alleati
  #==============================================================================

  module H87AttrSettings
    DEFAULT_MAX_CHARGE = 100
    DEFAULT_ANGER_INCR = 10
    DAMAGE_REFLECT_ANIM_ID = 440
    VAMPIRE_ANIM_ID = 439
    TANKS = [21, 1, 13, 7] #i tank in ordine di priorità
    HEALERS = [6, 19, 11, 1, 6, 15, 7] #i guaritori in ordine di priorità
    NUKERS = [2, 13, 10, 7]
    RANGED_ELEMENTS = [] # prima erano 5 e 6
    VLINK_RATE = 0.15
    GUARD_HP_HEAL_ANIMATION_ID = 324
    GUARD_MP_HEAL_ANIMATION_ID = 469
    BOSS_SLIP_DIVISOR = 10 # divisore danni da veleno se è un boss
    BARRIER_MP_CONSUME = 0.2 # percentuale di consumo della barriera ai danni
    # esempio: 0.2 consuma il 20% degli MP in rapporto agli HP
    # quindi se assorbe un danno di 100, consuma 20MP

    # suno quando la barriera si distrugge
    BARRIER_BREAK_SE = 'Break'

    PARAMS_CAN_ZERO = [:cri, :eva, :hit]

    ASSIMILATED_MESSAGE = '%s ha ottenuto %s da %s!'
    CANNOT_ASSIMILATE = 'Nessuna abilità assimilabile!'
    ASSIMILATE_ICON = 562
  end

  #==============================================================================
  # ** ExtraAttr
  #---------------------------------------------------------------------------
  # Contiene le stringhe per gli attributi
  #==============================================================================
  module ExtraAttr

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
    LONG_JUMP = /<salto[ _]lungo>/i
    VAMPIRE_A = /<vampiro[ ]+(\d+)%>/i
    RHYTM = /<ritmo>/i
    PARTY_BON = /<bonus[ _]party[ ](.*)>:[ ]*(\d+)([%％])>/i
    MP_RATE = /<costo[ _]mp:[ ]*([+\-]\d+)([%％])>/i
    HELP_STRT = /<help>/i
    HELP_END = /<\/help>/i
    VLINK = /<vlink>/i
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
    ANGER_DAMG = /<danno ira>/i
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
    STATE_GUARD =/<state guard>/
    PARRY = /<parry>/
    HP_ON_KILL = /<hp kill:[ ]*(\d+)([%％])>/i
    MP_ON_KILL = /<mp kill:[ ]*(\d+)([%％])>/i
    LINKED_ELEMENT = /<linked[ _]element:[ ]*(\d+)>/i
    STATE_DEFENSE = /<state[ _]rate[ ]+(\d+):[ ]*([\+\-]\d+)%>/i
    # Variabili di istanza pubblici
    attr_reader :dom_bonus # bonus dominazioni
    attr_reader :viril # stato virile
    attr_reader :artificis # stato artificiere
    attr_reader :scassinate # stato scassinatore
    attr_reader :charm # charm
    attr_reader :defender #applica stato difensore
    attr_reader :status_hit #stato attivato ad attacco
    attr_reader :status_hit_prob #prob. attivazione stato
    attr_reader :status_dmg #stato attivato a danno
    attr_reader :status_dmg_prob #prob. attivazione stato
    attr_reader :esper_recharger #per esper, ricarica su danno
    attr_reader :item_save #prob. di non consumare l'oggetto
    attr_reader :fast_ready #bonus ricarica esper, solo per dominazioni
    attr_reader :save_domination #solo per dominazioni, nessun malus su morte
    attr_reader :taumaturgic #taumaturgia
    attr_reader :item_bonus #bonus cura oggetti
    attr_reader :atb_bonus
    attr_reader :atb_song #passiva che velocizza se è una canzone
    attr_reader :long_jump #status salto lungo
    attr_reader :mechanic #meccanico
    attr_reader :rhytm #status ritmo
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
    attr_reader :set_bonus #se lo stato è attivato da un set equip
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
    attr_reader :fixed_duration # flag per durata fissa stati alterati
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
    attr_reader :parry # flag per contrattacco su schivata
    attr_reader :linked_element # elemento linkato. Funziona solo per la probabilità degli status
    # @return [Array<Integer>]
    attr_reader :offensive_magic_states
    # @return [Array<Integer>]
    attr_reader :heal_magic_states
    # @return [Hash]
    attr_reader :state_rate_set
    # Carica gli attributi aggiuntivi dell'oggetto dal tag delle note
    # noinspection RubyScope
    def load_extra_attr
      return if @attributi_caricati
      @description = '' if @description.nil?
      @description = @passive_description if @passive_description
      @equip_level = default_level
      @attributi_caricati = true
      @dom_bonus = 0
      @viril = false
      @artificis = false
      @scassinate = false
      @charm = 0
      @counter_states = []
      @set_bonus = false
      @minus_state_set = []
      @param_gift = {:atk => 0, :def => 0, :spi => 0, :agi => 0}
      @status_hit = 0
      @bombifica = false
      @status_hit_prob = 0
      @status_dmg = 0
      @status_dmg_prob = 0
      @fast_ready = 0
      @anger_damage = false
      @esper_recharger = false
      @defender = false
      @vampire_rate = 0
      @autoscan = false
      @item_save = 0
      @anger_bonus = 0
      @anger_mantain = 0
      @max_anger_bonus = 0
      @save_domination = false
      @taumaturgic = false
      @mechanic = false
      @item_bonus = 0
      @physical_reflect = 0
      @anger_init = 0
      @magic_def = 0.0
      @phisic_dmg = 0.0
      @magic_dmg = 0.0
      @mp_on_attack = 0
      @atb_bonus = 0
      @atb_song = 0
      @skill_set = []
      @rhytm = false
      @long_jump = false
      @mp_cost_rate = 0.0
      @anger_kill = 0
      @vlink = false
      @viral = false
      @party_bonus = {}
      @anger_turn = 0
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
      @last_chance = false
      @ignore_bonus = false
      @stat_increment = {}
      @skill_type_cost = {}
      @masteries = {}
      @trade_lock = false
      @critical_defense = 0
      @damage_rate = 0.0
      @synth_bonus = 0
      @critical_damage = 0.0
      @spoil_bonus = 0.0
      @ranged = false
      @zombie_state = false
      @allow_equip_type = []
      reading_help = false
      @barrier_rate = 0
      @barrier_save = 0
      @magic_attack = 0
      @support_type = nil
      @use_support = nil
      @is_placeholder = false
      @hp_on_guard = 0
      @mp_on_guard = 0
      @block_last_skill = false
      @fu_on_guard = 0
      @attack_attr = nil
      @rune = false
      @fixed_duration = false
      @max_assimilable = 0
      @slip_damage_per = 0
      @protector = false
      @unprotected = false
      @boss_type = false
      @offensive_magic_states = []
      @heal_magic_states = []
      @pharmacology = false
      @super_guard = false
      @state_guard = false
      @parry = false
      @hp_on_kill = 0
      @mp_on_kill = 0
      @linked_element = 0
      @state_rate_set = {}
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
        when DOM_BONUS
          @dom_bonus = $1.to_f / 100
        when VIRIL
          @viril = true
        when ARTIFICIS
          @artificis = true
        when SCASSINATE
          @scassinate = true
        when CHARM
          @charm = $1.to_i
        when DEFENDER
          @defender = true
        when STATE_DMG
          @status_dmg = $1.to_i
          @status_dmg_prob = $2.to_f / 100
        when STATE_HIT
          @status_hit = $1.to_i
          @status_hit_prob = $2.to_f / 100
        when ESPER_REC
          @esper_recharger = true
        when ITEM_SAVE
          @item_save = $1.to_f / 100
        when FAST_READY
          @fast_ready = $1.to_i
        when SAVE_DOMI
          @save_domination = true
        when TAUMATURG
          @taumaturgic = true
        when ITEM_BON
          @item_bonus = $1.to_f / 100
        when ATB_BONUS
          @atb_bonus = $1.to_i
        when ATB_SONG
          @atb_song = $1.to_i
        when LONG_JUMP
          @long_jump = true
        when RHYTM
          @rhytm = true
        when MP_RATE
          @mp_cost_rate = $1.to_f / 100.0
        when HELP_STRT
          reading_help = true
        when VLINK
          @vlink = true
        when VIRAL
          @viral = true
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
          @bombifica = true
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
          @anger_damage = true
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
          @ignore_bonus = true
        when SK_COST_TP
          @skill_type_cost[$1] = $2 / 100.0
        when TRADE_LOCK
          @trade_lock = true
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
          @set_bonus = true
        when LAST_CHANCE
          @last_chance = true
        when MECHANIC
          @mechanic = true
        when SPOIL
          @spoil_bonus = $1.to_f / 100
        when RANGED
          @ranged = true
        when ZOMBIE
          @zombie_state = true
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
          @is_placeholder = true
        when FU_ON_GUARD
          @fu_on_guard = $1.to_f / 100
        when HP_ON_GUARD
          @hp_on_guard = $1.to_f / 100
        when MP_ON_GUARD
          @mp_on_guard = $1.to_f / 100
        when ATTACK_ATTR
          @attack_attr = $1.to_i
        when BLOCK_LAST_SKILL
          @block_last_skill = true
        when RUNE_STATE
          @rune = true
        when FIXED_DUR
          @fixed_duration = true
        when MP_ON_ATTACK
          @mp_on_attack = $1.to_i
        when AUTOSCAN
          @autoscan = true
        when MAX_ASSIMILABLE
          @max_assimilable = $1.to_i
        when USE_ANGER
          @use_anger = true
        when SLIP_DAMAGE_PER
          @slip_damage_per = $1.to_f / 100.0
        when BOSS_TYPE
          @boss_type = true
        when PROTECTOR
          @protector = true
        when UNPROTECTED
          @unprotected = true
        when OFF_MAGIC_STATE
          @offensive_magic_states.push $1.to_i
        when HEA_MAGIC_STATE
          @heal_magic_states.push $1.to_i
        when SUPER_GUARD
          @super_guard = true
        when PHARMACOLOGY
          @pharmacology = true
        when STATE_GUARD
          @state_guard = true
        when PARRY
          @parry = true
        when HP_ON_KILL
          @hp_on_kill = $1.to_f / 100.0
        when MP_ON_KILL
          @mp_on_kill = $1.to_f / 100.0
        when LINKED_ELEMENT
          @linked_element = $1.to_i
        when STATE_DEFENSE
          @state_rate_set[$1.to_i] = $2.to_i
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
  end

  module RPG
    #==============================================================================
    # ** RPG::EquippableItem
    #---------------------------------------------------------------------------
    # Inserisce gli attributi appropiati agli oggetti equipaggiabili
    #==============================================================================
    class Weapon < BaseItem
      include ExtraAttr
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
    end #equippableitem

    #==============================================================================
    # ** RPG::Armor
    #---------------------------------------------------------------------------
    # Inserisce gli attributi appropiati agli oggetti equipaggiabili
    #==============================================================================
    class Armor < BaseItem
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
    end #equippableitem

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
        return @passive_description unless @passive_description.empty?
        @description
      end
    end #state

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
      # @return [RPG::Element_Data]
      def attack_attribute
        return nil if @attack_attr.nil?
        $data_system.weapon_attributes.select { |attr| attr.id == attack_attr }.first
      end

      # determina se è un protettore
      def protector?
        @protector
      end
    end

    #==============================================================================
    # ** RPG::UsableItem
    #---------------------------------------------------------------------------
    # Imposta gli attributi per le abilità
    #==============================================================================
    class UsableItem
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
      attr_reader :required_menu_switch
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
        @max_number = 99
        @tank_odd = 0
        @stat_increment = {}
        @state_inf_bon = 0
        @state_inf_per = 0.0
        @state_inf_dur = 0
        @range_type = nil
        @ignore_bonus = false
        @sk_types = []
        @troop_id = 0
        @trade_lock = false
        @recharge_skills = false
        @placeholder_id = 0
        @buff_steal = false
        @debuff_pass = false
        @reset_damage = false
        @assimilate = false
        @assimilable = false
        @switchable = false
        @mp_damage_per = 0
        @required_menu_switch = 0
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
          when ExtraAttr::MAX_NUMBER
            @max_number = $1.to_i
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
          when ExtraAttr::TRADE_LOCK
            @trade_lock = true
          when ExtraAttr::STAT_INCR
            @stat_increment[$1] = $2.to_i
          when ExtraAttr::REC_SKILLS
            @recharge_skills = true
          when ExtraAttr::MEELE
            @range_type = 0
          when ExtraAttr::RANGED
            @range_type = 1
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
          when ExtraAttr::SKILL_MP_DAMAGE_PER
            @mp_damage_per = $1.to_f / 100.0
          when ExtraAttr::SWITCHABLE
            @switchable = true
          when ExtraAttr::MENU_SWITCH
            @required_menu_switch = $1.to_i
          when ExtraAttr::HELP_STRT
            reading_help = true
          else
            nil
          end
        }
      end

      # Restituisce se la skill può essere usata dalla taumaturgia
      def can_tau?
        @ok_with_taumaturgic
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
        false
      end

      def ranged?
        true
      end
    end #usable item

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
        return self.range_type == 0 if self.range_type != nil
        return false if (self.element_set & H87AttrSettings::RANGED_ELEMENTS).size > 0
        self.atk_f > 0
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
      attr_reader :max_number #numero massimo
      attr_reader :troop_id #ID dei mostri
      attr_reader :trade_lock #non permette lo scambio tra giocatori
      attr_reader :placeholder_id # nome dell'oggetto placeholder

      # Restituisce true se è scambiabile tra giocatori
      def traddable?
        return false if self.key_item #non traddabile se è una chiave
        return false if self.price == 0 #non traddabile se il prezzo è 0
        # noinspection RubyResolve
        return false if @trade_lock #non traddabile se bloccato da tag
        true #traddabile
      end

      # metodo alias sellable
      alias sellable? traddable? unless $@

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

  #==============================================================================
  # ** Game_Battler
  #---------------------------------------------------------------------------
  # Vari metodi per il combattente
  #==============================================================================
  # noinspection RubyUnusedLocalVariable
  class Game_Battler
    unless $@
      alias h87attr_att_eff attack_effect
      alias h87attr_skill_effect skill_effect
      alias h87attr_plus_state_set plus_state_set
      alias h87attr_minus_state_set minus_state_set
      alias make_attack_damage_value_ht make_attack_damage_value
      alias make_obj_damage_value_ht make_obj_damage_value
      alias h87attr_execute_damage execute_damage
      alias h87attr_item_effect item_effect
      alias run_cdf2 run_cdf
      alias tau_mp_cost calc_mp_cost
      alias h87attr_item_test item_test
      alias h87_attr_state_prob state_probability
      alias h87status_as add_state
      alias h87status_rs remove_state
      alias h87hp hp
      alias h87attr_hp hp=
      alias h87attr_apply_state_changes apply_state_changes
      alias h87attr_element_set element_set
      alias h87attr_slip_damage_effect slip_damage_effect
      alias h87attr_skill_can_use skill_can_use?
    end

    # @return [Integer] ammontare dell'ultimo attacco ricevuto
    attr_accessor :last_damage
    # @return [Integer] ammontare di tutti i danni ricevuti fino ad ora
    attr_accessor :cumuled_damage
    # @return [Integer] l'ultima skill usata (per bloccarla)
    attr_reader :last_skill_used

    # Attributi statici (modificati poi nelle sottoclassi)


    #taumaturgico?
    def taumaturgic?
      false
    end

    # usa la furia?
    def charge_gauge?
      false
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
      return if last_skill_blocked?
      @last_skill_used = skill_id
    end

    # Inizializza le variabili ad inizio battaglia
    def init_for_battle
      check_last_chance
      self.last_damage = 0
      self.cumuled_damage = 0
    end

    # Restituisce le feature
    # @return [Array<RPG::State>]
    def features
      states
    end

    # Restituisce la somma di un attributo delle caratteristiche
    # @param [Symbol] feature_name
    # @param [Object] param
    def features_sum(feature_name, param = nil)
      return features_sum_with_param(feature_name, param) if param
      features.inject(0) {|s, ft| s + ft.send(feature_name)}
    end

    def features_sum_with_param(feature_name, param)
      features.compact.inject(0.0) {|s, ft| s + ft.send(feature_name, param)}
    end

    # Restituisce un valore da un array
    # @param [Symbol] feature_name
    # @return [Array]
    def feature_array(feature_name)
      features.inject([]) {|ary, ft| ary + ft.send(feature_name)}
    end

    # Restituisce true se tra le caratteristiche ce n'è una con un attributo
    def has_feature?(feature_name)
      features.each { |ft| return true if ft.send(feature_name) }
      false
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

    # modifica del valore critico
    def cri
      party_bonus(ex_attr_cri, :cri)
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

    def protected?
      false
    end

    def protector?
      false
    end

    # Restituisce il danno critico
    def cri_dmg
      3.0 + features_sum(:critical_damage)
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
    def anger_on_damage?
      has_feature?(:anger_damage)
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

    # Effetto attacco
    # @param [Game_Battler] attacker
    def attack_effect(attacker)
      @bomb = bombified?
      h87attr_att_eff(attacker)
      if @evaded and can_parry? and !attacker.ranged_attack?
        attacker.make_attack_damage_value(self)
        SceneManager.scene.force_damage_pop(attacker, self.animation_id)
      end
    end

    # Effetto skill
    # @param [Game_Battler] user
    # @param [RPG::Skill] skill
    def skill_effect(user, skill)
      @bomb = bombified?
      h87attr_skill_effect(user, skill)
    end

    def custom_slip_damage_sum
      @slip_damages ||= {}
      @slip_damages.values.inject(0){|i, d| i + d}
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
      if @hp_damage < 0 and obj.base_damage < 0 and zombie?
        @hp_damage *= -1
      end
      if rune? && @hp_damage != 0 #se è in rune, assorbi i danni
        @mp_damage = @hp_damage.abs / -200
        @hp_damage = 0
      end
      if obj.mp_damage_per > 0 and @hp_damage > 0
        @mp_damage = (@hp_damage * obj.mp_damage_per).to_i
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
      skills = assimilable_skills.select {|skill| user.assimilable?(skill)}
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
      self.anger += anger_incr if anger_on_damage?
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
      return false if last_skill_blocked? && skill.id == @last_skill_used
      false if $game_party.req_menu_witch(skill)
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
        array.push([state.id, 100]) if state.viral
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
        array.push([state.id, 100]) if state.viral
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
      if hp_on_guard_rate > 0
        heal = (mhp * hp_on_guard_rate).to_i
        @hp_damage = heal * -1
        a_id = H87AttrSettings::GUARD_HP_HEAL_ANIMATION_ID
        $scene.force_damage_pop(self, a_id)
      end
      if mp_on_guard_rate > 0
        heal = (mmp * mp_on_guard_rate).to_i
        @mp_damage = heal * -1
        a_id = H87AttrSettings::GUARD_MP_HEAL_ANIMATION_ID
        $scene.force_damage_pop(self, a_id)
      end
      if fu_on_guard_rate > 0
        heal = (max_anger * fu_on_guard_rate).to_i
        self.anger += heal
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
      return if state_ignore?(state_id) # È uno stato da ignorare?
      h87status_as(state_id)
      check_block_skill_message(state)
      apply_custom_slip_damage(state)
      check_durability_bonus(state, skill)
    end

    def remove_state(state_id)
      h87status_rs(state_id)
      remove_slip_damage(state_id)
    end

    def slip_damage_effect
      h87attr_slip_damage_effect
      @hp_damage /= H87_Settings::BOSS_SLIP_DIVISOR if boss_type?
      @hp_damage += apply_variance(custom_slip_damage_sum, 10)
    end

    # @param [RPG::State] state
    def check_block_skill_message(state)
      return unless state.block_last_skill
      return if @last_skill_used.nil?
      return if @last_skill_used == 0
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
      return if state.fixed_duration
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
        user.offensive_magic_states.each{|s| valuate_magic_states(s, obj)}
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
      self.states.compact.select { |state| state.viral }
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
  end #game_battler

  #==============================================================================
  # ** Game_Actor
  #---------------------------------------------------------------------------
  # Metodi specifici per l'eroe
  #==============================================================================
  class Game_Actor < Game_Battler
    unless $@
      alias ex_attr_skills skills
      alias ex_attr_mp mp
      alias ex_attr_maxmp maxmp
      alias ex_attr_equippable? equippable?
      alias ex_attr_atk atk
      alias ex_attr_def def
      alias ex_attr_spi spi
      alias ex_attr_agi agi
      alias ex_attr_eva eva
      alias ex_attr_hit hit
      alias ex_attr_cri cri
      alias ex_attr_skills skills
      alias ex_attr_super_guard super_guard
      alias ex_attr_pharmacology pharmacology
    end
    # Inizializza i valori prima di una battaglia
    def init_for_battle
      super
      self.song_count = 0
      initialize_anger
    end

    # @return [Array<RPG::State,RPG::Armor,RPG::Weapon>]
    def features
      super + equips.compact
    end

    # Restituisce se l'eroe usa la barra charge
    def charge_gauge?
      super || actor.parameters[1, 1] == 0
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

    # Restituisce il nuovo valore secondo il bonus del gruppo
    # value: valore iniziale
    # param: parametro (atk, def, spi, agi, eva, hit, cri)
    # @param [Integer] value
    # @param [Symbol] param
    # @return [Integer]
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
      @assimilated_skills.compact.map {|skill_id| $data_skills[skill_id]}
    end

    def max_assimilable_skills
      2 + features_sum(:max_assimilable)
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
      skills.select {|skill| skill.assimilate?}.any?
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

      if mp_on_kill > 0 and !charge_gauge?
        @mp_damage = mp_on_kill * -1
        SceneManager.scene.force_damage_pop(self)
      end

      if anger_kill > 0 and charge_gauge?
        self.anger += anger_kill
      end
    end

    # @param [RPG::Skill] skill
    def consume_assimilated_skill(skill)
      @assimilated_skills ||= []
      @assimilated_skills.delete(skill.id)
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
      return 0 if param_gift(param) > 0
      $game_party.param_gift(param)
    end

    # Restituisce il bonus che dà il personaggio al gruppo
    # param: parametro
    def actor_party_bonus(param)
      bonus = 0
      self.states.each { |state|
        if state.party_bonus[param] != nil
          bonus += state.party_bonus[param]
        end
      }
      bonus
    end

    # modifica del valore d'attacco
    def atk
      party_bonus(ex_attr_atk, :atk) + party_gift(:atk) + spirit_attack
    end

    # modifica del valore di difesa
    def def
      party_bonus(ex_attr_def, :def) + party_gift(:def) + spirit_defense
    end

    # modifica del valore spirito
    def spi
      party_bonus(ex_attr_spi, :spi) + party_gift(:spi)
    end

    # modifica del valore agilità
    def agi
      party_bonus(ex_attr_agi, :agi) + party_gift(:agi) + rhytm_bonus + spirit_agi
    end

    # modifica del valore d'evasione
    def eva
      party_bonus(ex_attr_eva, :eva)
    end

    # modifica del valore di mira
    def hit
      malus_hit = has2w ? CPanel::TWHIT : 0
      ex_attr_hit - malus_hit
      #party_bonus(ex_attr_hit, :hit) - malus_hit
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

    # Restituisce il bonus drop. Viene sovrascritto da Game_Enemy
    def spoil_bonus
      1.0
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

    # Restituisce i passi compiuti dall'eroe
    def steps
      @steps = 0 if @steps.nil?; @steps
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
      riduci_danno_difensore
      riduci_danno_evocazione
    end

    # Modifica il danno se c'è un difensore
    def riduci_danno_difensore
      party_def = $game_party.defender
      if party_def != nil and !self.defender? and @hp_damage > 0
        old_dmg = @hp_damage
        @hp_damage *= CPanel::PROTECTRATE
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
    def riduci_danno_evocazione
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

    # Restituisce il valore aggiunto della propria difesa al gruppo
    def param_gift(param)
      multiplier = 0.0
      states.each { |state|
        next if state.nil?
        multiplier += state.param_gift[param]
      }
      case param
      when :atk
        value = self.ex_attr_atk
      when :def
        value = self.ex_attr_def
      when :spi
        value = self.ex_attr_spi
      when :agi
        value = self.ex_attr_agi
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
      charge_gauge? ? 0 : ex_attr_mp
    end

    # Restituisce gli MP massimi
    def maxmp
      charge_gauge? ? 0 : ex_attr_maxmp
    end
  end #game_actor

  #==============================================================================
  # ** Game_Enemy
  #---------------------------------------------------------------------------
  # Metodo per il contagio delle unità
  #==============================================================================
  class Game_Enemy < Game_Battler
    alias h87attr_perform_collapse perform_collapse unless $@
    alias h87attr_initialize initialize unless $@

    def initialize(index, enemy_id)
      h87attr_initialize(index, enemy_id)
      self.anger = max_anger
    end

    # @return [Array<RPG::State,RPG::Enemy>]
    def features
      super + [enemy]
    end

    # Morte
    def perform_collapse
      recharge_actors
      if $game_temp.in_battle and dead? and @bomb
        @bomb = false
        @hp = 1 # per non farlo morire prima dell'animazione
        bombific_explode
      else
        h87attr_perform_collapse
      end
    end

    def recharge_actors
      $game_party.members.each { |member| member.kill_recharge }
    end

    # determina se il nemico è un boss
    def boss_type?
      enemy.boss_type
    end

    # determina se il nemico è protetto da un altro alleato
    def protected?
      return false if protector?
      return false if enemy.unprotected
      return false unless exist?
      #noinspection RubyResolve
      $game_troop.existing_members.select{ |member| member.protector? }.any?
    end

    # determia se il nemico è un protettore
    def protector?
      has_feature? :protector
    end

    # determina se l'attacco è basato dallo spirito
    def attack_with_magic?
      super || attack_magic_rate > 0
    end

    # Restituisce true se il battler è affetto da bombificazione
    def bombified?
      self.states.select { |state| state.bombifica }.any?
    end

    # Esplode.
    def bombific_explode
      SceneManager.scene.bomb_explode(self)
    end

    # Bonus drop a fine battaglia
    def spoil_bonus
      features_sum(:spoil_bonus)
    end

    # restituisce il set di elementi sull'attacco
    # @return [Array<Integer>]
    def element_set
      super + [enemy.attack_attr].compact
    end

    # @return [Array<RPG::Skill>]
    # @param [Game_Actor] actor
    def assimilable_skills(actor = nil)
      sks = skills.select {|skill| skill.assimilable?}
      if actor
        sks = sks.select {|skill| actor.assimilable?(skill)}
      end
      sks
    end

    def charge_gauge?
      enemy.use_anger
    end
  end

  #==============================================================================
  # ** Game_Unit
  #---------------------------------------------------------------------------
  # Metodo per il contagio delle unità
  #==============================================================================
  class Game_Unit

    # Controlla e diffonde il contagio tra i membri
    def check_plague
      members.each { |member|
        inf = member.infected
        if inf > 0
          expand_plague(inf)
          break
        end
      }
    end

    # restituisce i membri bersagliabili
    # @return [Array<Game_Battler>]
    def targettable_members
      members
    end

    # Espande il contagio
    # inf: id dello stato virale
    def expand_plague(inf)
      sane = []
      members.each { |member|
        sane.push(member) if member.infected == 0
      }
      if sane.size > 0
        battler = sane[rand(sane.size)]
        battler.apply_state_changes(FakeStObj.new(inf))
      end
    end
  end

  #==============================================================================
  # ** FakeStObj
  #---------------------------------------------------------------------------
  # Classe che serve come rimpiazzo delle skill per applicare gli status.
  #==============================================================================
  class FakeStObj
    # @attr[Array<Integer>] plus_state_set
    # @attr[Array<Integer>] minut_state_set
    attr_reader :plus_state_set
    attr_reader :minus_state_set
    # @param [Integer] state_id
    def initialize(state_id)
      @plus_state_set = [state_id]
      @minus_state_set = []
    end
  end

  class Game_Troop < Game_Unit
    # restituisce i membri del gruppo che sono bersagliabili
    # @return [Array<Game_Enemy>]
    def targettable_members
      return members unless $game_temp.is_meele_skill
      members.select { |member| !member.protected? }
    end

    # @return [Game_Enemy]
    def smooth_target(index)
      return super(index) unless $game_temp.is_meele_skill
      return smooth_target(index + 1) if members[index].protected?
      super(index)
    end

    # @return [Game_Enemy]
    def random_target
      return super unless $game_temp.is_meele_skill
      #noinspection RubyResolve
      existing_members.select { |member| !member.protected? }.sample
    end
  end

  #==============================================================================
  # ** Game_Party
  #---------------------------------------------------------------------------
  # Metodi d'informazione per il gruppo
  #==============================================================================
  class Game_Party < Game_Unit
    alias h87attr_item_number item_number unless $@
    alias h87attr_gain_item gain_item unless $@
    alias h87attr_item_can_use item_can_use? unless $@

    # Restituisce il difensore del gruppo o nil (colui che prende danno al
    # posto degli alleati)
    # @return [Game_Actor]
    def defender
      battle_members.select { |member| member.defender?}.first
    end

    # @param [RPG::Item, RPG::Armor, RPG::Weapon] item
    def item_number(item)
      return 0 if item.nil?
      if item.is_placeholder?
        items_with_placeholder = all_items.select { |i| i.has_placeholder? }
        items_with_placeholder.each do |p_item|
          return h87attr_item_number(p_item) if p_item.placeholder_id == item.id
        end
        0
      else
        h87attr_item_number(item)
      end
    end

    # @param [RPG::Item] item
    def item_can_use?(item)
      return false unless h87attr_item_can_use item
      return false if req_menu_witch(item)
      true
    end

    # determina se l'oggetto è utilizzabile dal menu
    # solo nella condizione che il suo switch sia ON
    # @param [RPG::Skill,RPG::Item] obj
    def req_menu_witch(obj)
      return false if obj.nil?
      return false if $game_temp.in_battle
      return false if obj.required_menu_switch.nil?
      return false if obj.required_menu_switch == 0
      !$game_switches[obj.required_menu_switch]
    end

    # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
    # @param [Integer] n
    # @param [FalseClass] include_equip
    def gain_item(item, n = 1, include_equip = false)
      return if item.nil?
      return if item.is_placeholder?
      h87attr_gain_item(item, n, include_equip)
    end

    # Restituisce il tank del gruppo
    # @return [Game_Actor]
    def tank
      (0..H87AttrSettings::TANKS.size - 1).each { |actor_id|
        return $game_actors[i] if battle_members.include?($game_actors[actor_id])
      }
      nil
    end

    # Restituisce il bonus parametro del gruppo
    # param: parametro (atk, def, spi, agi, cri, hit, eva)
    def party_bonus(param)
      members.inject(0) { |bonus, member| bonus + member.actor_party_bonus(param) }
    end

    # Restituisce il parametro aggiunto da un membro del gruppo
    # param: parametro (atk, def, spi, agi)
    def param_gift(param)
      return 0 unless $game_temp.in_battle
      members.inject(0) { |bonus, member| bonus + member.param_gift(param) }
    end

    # Non fa consumare l'oggetto con la giusta probabilità
    alias force_consume_item consume_item unless $@
    # @param [RPG::Item] item
    def consume_item(item)
      return force_consume_item(item) unless $game_temp.in_battle
      force_consume_item(item) if save_prob <= rand
    end

    # Alias del metodo per incrementare passi per scalare l'ira
    alias h87attr_increase_steps increase_steps unless $@

    def increase_steps
      h87attr_increase_steps
      # Non riduce più la furia.
      #members.each { |member|
      # member.reduce_anger if member.charge_gauge?
      #}
    end

    # Restituisce la probabilità di salvare l'oggetto
    def save_prob
      return 0 unless $game_temp.in_battle
      $game_temp.active_battler.save_item_bonus
    end

    # Restituisce true se un membro del gruppo ha scassinatore
    def ha_scassinatore?
      members.select { |member| member.scassinatore? }.any?
    end

    # Restituisce true se un membro del gruppo ha virilità
    def ha_virile?
      members.select { |member| member.virile? }.any?
    end

    # Restituisce il bonus di durata delle dominazioni
    # @return [Float]
    def domination_bonus
      members.inject(1.0) { |bonus, member| bonus + member.dom_bonus }
    end

    # Restituisce lo charm totale dei membri del gruppo
    # @return [Integer]
    def total_charm
      member.inject(0) { |charm, member| charm + member.charm }
    end

    # Restituisce true se almeno un giocatore può saltare lontano
    def has_long_jump?
      members.each { |member|
        return true if member.can_jump_longer?
      }
      false
    end

    # Restituisce true se almeno un giocatore è un meccanico
    def has_mechanic?
      members.each { |member|
        return true if member.mechanic?
      }
      false
    end

    def placeholder_armors
      all_items.select { |item| item.has_placeholder? }.collect { |item| $data_armors[item.placeholder_id] }
    end
  end #game_party

  class Game_Temp
    # @return[Game_Battler] active_battler
    attr_accessor :active_battler
    attr_accessor :is_meele_skill

  end

  #==============================================================================
  # ** Scene_Battle
  #---------------------------------------------------------------------------
  # Cambiamento dei metodi in Scene_Battle
  #==============================================================================
  class Scene_Battle < Scene_Base
    unless $@
      alias start_attr start
      alias execute_action_item_sav execute_action_item
      alias terminate_attr terminate
      alias h87attr_eas execute_action_skill
      alias consume_item_skill_attr consume_item_skill
      alias h87attr_process_victory process_victory
      alias execute_action_attr execute_action
      alias h87_attragg_turn_end turn_end
    end
    # Inizio
    def start
      start_attr
      $game_party.members.each { |member|
        member.init_for_battle
      }
      $game_troop.members.each { |enemy|
        enemy.init_for_battle
      }
    end

    # Alias esecuzione azione oggetto
    def execute_action_item
      $game_temp.active_battler = @active_battler if @active_battler.actor?
      execute_action_item_sav
    end

    # Consuma l'oggetto con l'abilità speciale
    # @param [Object] item_id
    # @param [Object] item_number
    # noinspection RubyNilAnalysis
    def consume_item_skill(item_id, item_number)
      return if @active_battler.save_item_bonus >= rand
      consume_item_skill_attr(item_id, item_number)
    end

    # Esecuzione dell'azione
    def execute_action
      execute_action_attr
      ab = @active_battler
      update_actor_song(ab.action.kind == 1) if !ab.nil? && ab.actor?
    end

    # Aggiorna il conteggio delle canzoni
    # noinspection RubyResolve,RubyNilAnalysis
    def update_actor_song(skill_type)
      return unless @active_battler.has_rhytm?
      if !skill_type || @active_battler.action.skill.skill_type == 'Canto'
        @active_battler.song_count = 0
      else
        @active_battler.song_count += 1
      end
    end

    # Alias di fine scena
    def terminate
      terminate_attr
      $game_party.members.each { |member|
        member.song_count = 0
      }
    end

    # esecuzione della skill del battler
    def execute_action_skill
      h87attr_eas
      ab = @active_battler
      # @param [Game_Battler] ab
      return if ab.nil?
      skill = ab.action.skill
      return if skill.nil?
      ab.set_last_skill_used skill.id
      ab.anger -= ab.calc_anger_cost(skill) if ab.charge_gauge?
      if ab.assimilated?(skill)
        ab.consume_assimilated_skill(skill)
      end
    end

    # Esplosione di un nemico colpito da Bombifica
    def bomb_explode(battler)
      $game_troop.members.each { |member|
        next if member.dead?
        skill = $data_skills[CPanel::BOMB_SKILL]
        member.skill_effect(battler, skill)
        if member == battler
          member.animation_id = skill.animation_id
        else
          damage = member.hp_damage
          member.animation_id = 82
          @spriteset.enemy_sprites[member.index].damage_pop(damage)
          @spriteset.enemy_sprites[member.index].start_action(member.damage_hit)
        end
      }
    end

    # forza l'apparizione del danno sul battler
    # @param [Game_Battler] battler su cui mostrare il danno
    # @param [Integer] animation_id animazione da mostrare
    # @param [Integer] damage danno in caso non è definito un hp_damage
    def force_damage_pop(battler, animation_id = 0, damage = nil)
      sprite = battler_sprite(battler)
      if damage.nil?
        damage = battler.hp_damage != 0 ? battler.hp_damage : battler.mp_damage
      else
        battler.hp_damage = damage
      end
      battler.double_damage = battler.hp_damage != 0 && battler.mp_damage != 0
      sprite.damage_pop(damage)
      if animation_id > 0
        battler.animation_id = animation_id
        battler.animation_mirror = !battler.actor?
      end
      battler.execute_damage(battler, true)
    end

    # Alias di fine turno
    def turn_end(param = nil)
      # noinspection RubyArgCount
      h87_attragg_turn_end(param)
      infect_plague
      charge_anger
    end

    # restituisce lo sprite del battler
    # @param [Game_Battler] battler
    # @return [Sprite_Battler]
    def battler_sprite(battler)
      if battler.actor?
        index = $game_party.members.index(battler)
        sprite = @spriteset.actor_sprites[index]
      else
        index = $game_troop.members.index(battler)
        sprite = @spriteset.enemy_sprites[index]
      end
      sprite
    end

    # Processo di vittoria
    def process_victory
      h87attr_process_victory
      $game_party.battle_members.each { |member|
        next if member.dead?
        member.hp_damage -= member.win_hp
        member.mp_damage -= member.win_mp
        force_damage_pop(member)
      }
    end

    # Epidemia alla fine del turno
    def infect_plague
      $game_troop.check_plague
      $game_party.check_plague
    end

    # Carica la furia dei membri
    def charge_anger
      $game_party.battle_members.each { |member|
        next if member.nil?
        next if member.dead?
        next unless member.charge_gauge?
        member.anger += member.anger_turn
      }
    end
  end

  class Window_Skill < Window_Selectable
    alias h87attr_draw_mpc draw_mp_cost unless $@
    alias h87attr_draw_item draw_item unless $@
    # alias del metodo draw_mp_cost per mostrare la furia se l'eroe usa la skill
    # noinspection RubyUnusedLocalVariable
    # @param [RPG::Skill] skill abilità in oggetto
    # @param [Rect] rect
    # @param [Game_Actor] actor eroe che possiede l'abilità
    # @param [true, false] enabled se abilitato o diasabilitato
    # @return [Integer] la nuova larghezza sottratta
    def draw_mp_cost(skill, rect, actor, enabled)
      if actor.charge_gauge?
        draw_anger_cost(skill, rect, actor, enabled)
      else
        h87attr_draw_mpc(skill, rect, actor, enabled)
      end
    end

    # @param [RPG::Skill] skill abilità in oggetto
    # @param [Rect] rect rettangolo
    # @param [Game_Actor] actor eroe che possiede l'abilità
    # @param [true, false] enabled se abilitato o diasabilitato
    # @return [Integer] la nuova larghezza sottratta
    def draw_anger_cost(skill, rect, actor, enabled)
      return width if actor.calc_anger_cost(skill) == 0
      change_color anger_color, enabled
      cost = sprintf('%d%s', actor.calc_anger_cost(skill), Vocab.anger)
      draw_text(rect, cost, 2)
      rect.width -= text_size(cost).width + H87_SKILL_COSTS::SPACING
    end

    def draw_item(index)
      h87attr_draw_item(index)
      skill = @data[index]
      rect = item_rect(index)
      if @actor.assimilated?(skill)
        draw_icon(H87AttrSettings::ASSIMILATE_ICON, rect.x, rect.y)
      end
    end
  end

  module Vocab
    # Vocabolo Furia
    def self.anger
      'FU'
    end

    # Vocabolo Furia (abbreviato)
    def self.fu_a
      anger
    end
  end

  class Window_Base < Window
    alias h87attr_draw_actor_mp draw_actor_mp
    # Colore della Furia
    # @return [Color]
    def anger_color
      text_color(3)
    end

    # Colore sfondo 1 della Furia
    # @return [Color]
    def anger_gauge_color1
      text_color(3)
    end

    # Colore sfondo 2 della Furia
    # @return [Color]
    def anger_gauge_color2
      text_color(11)
    end

    # Alias del metodo draw_actor_mp. Disegna Furia se il personaggio ne è
    # dotato.
    # @param [Game_Battler] actor
    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] width
    def draw_actor_mp(actor, x, y, width = 120)
      if actor.charge_gauge?
        draw_actor_anger(actor, x, y, width)
      else
        h87attr_draw_actor_mp(actor, x, y, width)
      end
    end

    # Disegna la furia dell'eroe
    # @param [Game_Battler] actor
    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] width
    def draw_actor_anger(actor, x, y, width = 120)
      draw_actor_anger_gauge(actor, x, y, width)
      contents.font.color = system_color
      contents.draw_text(x + 2, y, 30, line_height, Vocab::fu_a)
      contents.font.color = normal_color
      #last_font_size = contents.font.size
      text = sprintf('%2d/%2d', actor.anger, actor.max_anger)
      if width - 33 < contents.text_size(text).width
        contents.draw_text(x + 32, y, width - 33, line_height, actor.anger.group, 1)
      else
        contents.draw_text(x + 32, y, width - 33, line_height, text, 1)
      end
    end

    # Disegna la furia dell'eroe
    # @param [Game_Battler] actor
    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] width
    def draw_actor_anger_gauge(actor, x, y, width = 120)
      actor.anger = [actor.anger, actor.max_anger].min
      gc0 = gauge_back_color
      gc1 = anger_gauge_color1
      gc2 = anger_gauge_color2
      gh = Y6::SETTING::GAUGE_HEIGHT
      gh += 2 if Y6::SETTING::OUTLINE
      gy = y + line_height - 8 - (gh - 6)
      contents.fill_rect(x, gy, width, gh, gc0)
      gy += 1 if Y6::SETTING::OUTLINE
      gh -= 2 if Y6::SETTING::OUTLINE
      width -= 2 if Y6::SETTING::OUTLINE
      max_anger = [[actor.max_anger, 1].max, 999].min
      gbw = width * actor.anger / max_anger
      x += 1 if Y6::SETTING::OUTLINE
      contents.gradient_fill_rect(x, gy, gbw, gh, gc1, gc2)
    end
  end

  class Game_BattleAction
    alias set_normal_guard set_guard unless $@
    alias h87attr_make_attack_targets make_attack_targets unless $@
    alias h87attr_make_obj_targets make_obj_targets unless $@

    # imposta il comando di guardia
    def set_guard
      set_normal_guard
      @battler.apply_guard_bonus
    end

    def make_attack_targets
      $game_temp.is_meele_skill = meele_and_actor?
      targets = h87attr_make_attack_targets
      $game_temp.is_meele_skill = nil
      targets
    end

    def make_obj_targets(obj)
      $game_temp.is_meele_skill = meele_and_actor?
      targets = h87attr_make_obj_targets(obj)
      $game_temp.is_meele_skill = nil
      targets
    end

    # restituisce l'oggetto dell'azione
    # @return [RPG::Skill,RPG::Item]
    def action_object
      skill || item
    end

    # determina se è una skill a distanza
    def ranged?
      return battler.ranged_attack? if attack?
      return skill.ranged? if skill?
      true
    end

    def meele_and_actor?
      battler.actor? && !ranged?
    end
  end

  class Spriteset_Battle
    # @return [Array<Sprite_Enemy>]
    attr_reader :enemy_sprites
    # @return [Array<Sprite_Actor>]
    attr_reader :actor_sprites

    # restituisce lo sprite del battler
    # @param [Game_Battler] battler
    # @param [Integer] index
    # @return [Sprite_Battler]
    def battler_sprite(battler, index)
      sprites = battler.actor? ? @actor_sprites : @enemy_sprites
      sprites[index]
    end
  end