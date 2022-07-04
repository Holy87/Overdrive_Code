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
#  ● <apeiron> limite HP Max da 9999 a 99999, gli altri parametri da 999 a 9999
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
#  ● <show atb> su nemico, equip e stati: mostra l'ATB in battaglia
# ▼ PARAMETRI
#  ● <attack element: x> o <elemento attacco: x> aggiunge l'elemento x all'attacco di base
#  ● <attacco magico: x%> l'attacco diventa una magia con il x% dello spirito. Tieni
#  conto che nel caso degli eroi solo se l'arma principale ha attacco magico, usa
#  quello. Per status ed altri equipaggiamenti, non viene applicato.
#  ● <dona x: y%> dona il parametro x dell'y%, solo status - DISATTIVATO
#  ● <pv vittoria: x%> cura il X% di pv alla vittoria
#  ● <pm vittoria: x%> cura il X% di pm alla vittoria
#  ● <rifletti fis: x%> riflette x% di danno fisico
#  ● <controstato: x> aggiunge status x al nemico quando vieni colpito da un attacco
#  ● <level burst: zx> moltiplica il livello del nemico per il valore z. È solo
#    visuale per modificare il colore del nome nemico quando sono affetti da modificatori
#    di potenza come i mostri usciti dagli scrigni
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
#  ● <custom attack skill: x> cambia il comando Attacca nell'abilità X
#  ● <custom guard skill: x> cambia il comando Difendi nell'abilità X
#     * le abilità sono visibili solo se le condizioni per attivarle sono garantite
#  ● <attack animation: x> cambia l'animazione dell'attacco normale (sovrascrive quello dell'arma)
#  ▼ STATUS
#  ● <status attacco: x> aggiunge lo status X all'attacco
#  ● <status rimosso: x> rimuove lo status X all'attacco
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
#  ● <svanisce con attacco> lo stato viene rimosso con un attacco
#  ● <disarma> l'eroe è disarmato.
#  ● <attack damage: +x%> aumenta il danno dell'attacco normale dell'X%
#  ● <perpetual state: x> solo per equip, imposta uno status perennemente attivo
#  ▼ POTERI E OGGETTI
#  ● <fh+x> l'help aggiunge x
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
#  ● <mp heal: x%> cura MP sull'x% del danno inflitto.
#  ● <switchable> l'abilità o l'oggetto può essere lanciato su nemici o alleati
#  ● <autostate x: y%> y% di probabilità di attivare lo status x sull'utilizzatore
#  ● <only for actor> per le skill usate dai nemici, va indirizzata solo agli eroi
#  ● <only for domination> per le skill dei nemici, solo per le evocazioni
#  ● <target all> colpisce tutti i nemici ed alleati sul campo.
#  ● <target states: x, y...> colpisce tutti i nemici che hanno gli stati x, y ecc...
#  ● <target other allies> l'abilità può colpire solo altri alleati escluso sé stesso
#  ● <ricarica skills> reimposta la ricarica di tutte le abilità
#  ● <transfer aggro> passa tutta l'aggro accumulata su un altro personaggio
#  ● <clear anger> porta a 0 la Furia dell'utilizzatore
#  ● <no critical> non può avere attacchi critici
#  ● <crtcon: COND> condizione per un danno critico (codice valutato)
#  ● <formula: FORM> formula personalizzata dell'abilità (codice valutato)
#  ● <fdesc: FORM> descrizione della formula nella finestra delle info abilità
#==============================================================================

module H87AttrSettings
  DEFAULT_MAX_CHARGE = 100
  DEFAULT_ANGER_INCR = 10
  DAMAGE_REFLECT_ANIM_ID = 440
  KNOCKBACK_ANIM_ID = 531
  VAMPIRE_ANIM_ID = 439
  CHARGE_GAUGE_CLASSES = [2, 6, 11, 12]
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

  # permettere alle magie di causare danno critico?
  CRITICAL_MAGIC = true
  # suno quando la barriera si distrugge
  BARRIER_BREAK_SE = 'Break'
  # parametri che possono raggiungere lo zero
  PARAMS_CAN_ZERO = [:cri, :eva, :hit]

  # Abilità che verrà usata come calcolo del danno dell'attacco
  DEFAULT_ATTACK_SKILL = 1
  MAGIC_ATTACK_SKILL = 2

  # Funzione dell'abilità Assimila
  ASSIMILATED_MESSAGE = '%s ha ottenuto %s da %s!'
  CANNOT_ASSIMILATE = 'Nessuna abilità assimilabile!'
  ASSIMILATE_ICON = 562

  # Fortuna di base (per tutti)
  # La fortuna è un nuovo parametro che influisce su Mira, Critico, evitare critici,
  # Evasione, prob. di causare o resistere
  # agli stati alterati. Per ora non funziona
  BASE_LUCK = 5

  BOMB_SKILL = 549 #skill chiamata quando bombifica viene attivato

  # Revamp delle formule danno per skill ed oggetti
  FORMULA_CALC_PARAMS = [:atk_f, :spi_f, :def_f, :agi_f, :mhp_f, :mmp_f, :hp_lo, :hp_hi, :mp_lo, :mp_hi,
                         :odds_f, :anger_f, :atk_e, :spi_e, :def_e, :agi_e, :hp_lo_e, :mp_lo_e, :hp_hi_e, :mp_hi_e,
                         :last_dmg, :cum_dmg, :debuff_e]

  # Moltiplicatori parametri. Ad esempio una skill magica fa spi_f*2 - dif, una fisica fa atk_f*4 - dif*2.
  # ----
  # moltiplicatore parametro sul danno. Se non definito, è 1.
  PARAMS_DMG_MULTIPLIERS = {
    :atk_f => 4, :spi_f => 2, :agi_f => 1, :def_f => 2, :debuff_e => 0.1, :anger_f => 0.01
  }

  # moltiplicatore difesa su danno. Se non definito, è 0 (ignora)
  PARAMS_DMG_DEFENSE_MUL = {
    :atk_f => 2, :spi_f => 1, :def_f => 1
  }

  MULTIPLIERS = [:debuff_e, :anger_f]

  # definisce il modo in cui i parametri del danno vengono calcolati
  PARAMS_CALCULATORS = {
    :atk_f => 'user.atk', :spi_f => 'user.spi', :def_f => 'user.def', :agi_f => 'user.agi',
    :mhp_f => 'user.mhp', :mmp_f => 'user.mmp', :hp_lo => 'user.mhp - user.hp',
    :mp_lo => 'user.mmp - user.mp', :hp_hi => 'user.hp', :mp_hi => 'user.mp',
    :odds_f => 'user.odds', :anger_f => 'user.anger', :atk_e => 'self.atk', ':spi_e' => 'self.spi',
    :def_e => 'self.def', :agi_e => 'self.agi', :hp_lo_e => 'self.mhp - self.hp',
    :mp_lo_e => 'self.mmp - self.mp', :hp_e => 'self.hp', :mp_e => 'self.mp',
    :last_dmg => 'user.last_damage', :cum_dmg => 'user.cumuled_damage',
    :mhp_e => 'self.mhp', :mmp_e => 'self.mmp', :debuff_e => 'self.debuff_number'
  }

  # Vocaboli per i parametri
  MAX_ABBREV = 'MAX %s'
  LOW_ABBREW = '%s MANC.'
  TARGET = '%s BERS'
end

module Vocab

  def self.max_a
    H87AttrSettings::MAX_ABBREV
  end

  def self.low_a
    H87AttrSettings::LOW_ABBREW
  end

  def self.target_a
    H87AttrSettings::TARGET
  end

  # restituisce il nome abbreviato del parametro
  def self.param_abbrev(param_sym)
    param = param_sym.to_s.gsub('_f','').to_sym
    case param
    when :atk, :spi, :def, :agi, :odds
      self.param(param)[0..2].upcase
    when :hp, :hp_hi
      self.hp_a
    when :mp, :mp_hi
      self.mp_a
    when :mhp
      sprintf(self.max_a, self.hp_a)
    when :mmp
      sprintf(self.max_a, self.mp_a)
    when :anger
      self.anger
    when :hp_lo
      sprintf(self.low_a, self.hp_a)
    when :mp_lo
      sprintf(self.low_a, self.mp_a)
    when :cum_dmg
      'TOT DMG'
    when :last_dmg
      'ULT DMG'
    when :atk_e, :spi_e, :agi_e, :def_e, :hp_e, :mp_e, :hp_lo_e, :mp_lo_e, :hp_hi_e, :mp_hi_e, :mhp_e, :mmp_e, :debuff_e
      sprintf(self.target_a, param_abbrev(param.to_s.gsub('_e','').to_sym))
    when :debuff
      'N°DBF'
    else
      self.param(param)
    end
  end
end