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
#  ● <svanisce con attacco> lo stato viene rimosso con un attacco
#  ● <disarma> l'eroe è disarmato.
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
#  ● <mp heal: x%> cura MP sull'x% del danno inflitto.
#  ● <switchable> l'abilità o l'oggetto può essere lanciato su nemici o alleati
#  ● <autostate x: y%> y% di probabilità di attivare lo status x sull'utilizzatore
#  ● <only for actor> per le skill usate dai nemici, va indirizzata solo agli eroi
#  ● <only for domination> per le skill dei nemici, solo per le evocazioni
#  ● <target all> colpisce tutti i nemici ed alleati sul campo.
#  ● <target states: x, y...> colpisce tutti i nemici che hanno gli stati x, y ecc...
#  ● <ricarica skills> reimposta la ricarica di tutte le abilità
#==============================================================================

module H87AttrSettings
    DEFAULT_MAX_CHARGE = 100
    DEFAULT_ANGER_INCR = 10
    DAMAGE_REFLECT_ANIM_ID = 440
    VAMPIRE_ANIM_ID = 439
    CHARGE_GAUGE_CLASSES = [2, 6, 11, 12, 16]
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
  
    # Fortuna di base (per tutti)
    # La fortuna è un nuovo parametro che influisce su Mira, Critico, evitare critici,
    # Evasione, prob. di causare o resistere
    # agli stati alterati
    BASE_LUCK = 5
  
    BOMB_SKILL = 549 #skill chiamata quando bombifica viene attivato
  end