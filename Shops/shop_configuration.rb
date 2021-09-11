#==============================================================================
# * Impostazioni dei negozi
#==============================================================================
module ShopsSettings

  # Impostazioni sugli sconti
  DISCOUNTS = true
  # tipi di sconti, definiti in questo modo:
  # %SCONTO => %PROBAB. Esempio
  # 10 => 8: 8% di probabilità di applicare uno sconto del 10%
  DISCOUNT_TYPES = {10 => 8, 15 => 4, 20 => 2, 30 => 1}

  # Punti fedeltà
  # è un valore nascosto che aumenta acquistando o vendendo in quel negozio.
  # viene calcolato in proporzione al costo del bene venduto o acquistato.
  # più è alto il livello fedeltà, più è possibile che il negozio applichi
  # degli sconti.
  # punti fedeltà richiesti per passare al livello fedeltà successivo.
  # il valore non si azzera salendo di livello, quindi bisogna impostare
  # i livelli sommando anche i punti precedenti.
  FIDELITY_LEVELS = {1 => 100, 2 => 250, 3 => 475, 4 => 800}
  # bonus (in percentuale) di probabilità di applicare gli sconti a
  # seconda di ogni livello. Il valore è moltiplicato per il tipo sconto
  FIDELITY_BONUS = {1 => 0, 2 => 5, 3 => 10, 4 => 20, 5 => 40}
  # Valore fedeltà in proporzione al costo di acquisto. Indica quanti punti
  # fedeltà acquisisci vendendo o comprando dal negozio. Ad esempio, con un
  # fidelity rate di 0.05, acquistando una pozione da 100§ acquisisci 5 punti
  # fedeltà. Vendendola (per 50§) acquisisci 2.5 punti fedeltà.
  FIDELITY_DEFAULT_RATE = 0.03

  # permette che il negozio rivenda gli articoli che hai venduto loro
  RESELLS = true
  # permette al giocatore di riacquistare allo stesso prezzo ciò che
  # ha appena venduto al negozio per sbaglio
  REBUY = true

  # fare un aggiornamento del negozio alla prima visita? Questo aggiunge
  # un piccolo fattore random la prima volta che visiti un negozio.
  UPDATE_ON_STARTUP = true

  # simbolo dell'infinito
  ENDLESS = '' # c'è ma non si vede!
  TRADE_REFLOW_RATE = 5

  DEFAULT_SUPPLY_RATE = 8
  DEFAULT_WASTE_RATE = 7

  ARROW_ICON = 777


  PARAMS_WIDTH = 48 # larghezza dei parametri sul confronto equip
  WEAPON_COMPARE = [:atk, :spi, :hit, :cri, :mhp, :mmp, :odds, :agi, :def, :eva, :res]
  SHIELD_COMPARE = [:def, :eva, :res, :mhp, :mmp, :agi, :spi, :atk, :odds, :hit, :cri]
  HELMET_COMPARE = [:def, :eva, :res, :mhp, :mmp, :agi, :spi, :atk, :odds, :hit, :cri]
  ARMOR__COMPARE = [:def, :eva, :res, :mhp, :mmp, :agi, :spi, :atk, :odds, :hit, :cri]
  ACCESS_COMPARE = [:mhp, :mmp, :agi, :spi, :def, :res, :odds, :hit, :cri, :eva, :atk]

  SHOP_REBUY = 'Riprendi'
  ITEM_SELECT = 'Seleziona'
  CHANGE_VIEW = 'Cambia vista'
  SOLD_OUT = 'Esaurito'
  BUY_ALL = 'Compra tutto'
  SELL_ALL = 'Vendi tutto'
  REBUY_ALL = 'Riprendi tutto'
  TOTAL = 'Importo totale:'
  IN_SALE = 'In sconto del %d%%'
  ALREADY_EQUIPPED = 'Equipaggiato'
  LEVEL_TOO_LOW = 'Livello basso!'
  HELP_BUY = 'Vedi l\'assortimento in negozio e compra gli articoli.'
  HELP_SELL = 'Vendi al negozio ciò che non ti serve.|Otterrai una frazione del costo originale.'
  HELP_REBUY = 'Hai venduto un oggetto per sbaglio? Riprendilo!|(solo per poco tempo)'
  HELP_CANCEL = 'Arrivederci!'

  # CONFIGURAZIONE DEL TEMPO
  # In questa sezione si definisce il tempo di aggiornamento dei negozi.
  # I negozi aggiornano l'assortimento a seconda del tempo di gioco e
  # nel caso lo deciderò, delle battaglie affrontate.
  # Determina ogni quanti minuti di gioco viene aggiornato l'assortimento
  # dei negozi.
  SUPPLY_UPDATE_TIMING = 10 # minuti
  # Determina le mappe che aggiornano più velocemente (in metà tempo)
  # l'assortimento dei negozi
  FAST_UPDATE_MAPS = [1] # la mappa del mondo
  # Determina le mappe che NON aggiornano i negozi quando ci sei dentro
  # Ad esempio mappe che contengono già un negozio e il giocatore è
  # ancora lì dentro. Vengono contate anche TUTTE le sottomappe, così
  # non è necessario inserire gli ID di tutte le case presenti in una
  # città.
  HOLD_UPDATE_MAPS = [87, 89]

  # definizione dei negozi
  # ISTRUZIONI
  # Inserire nell'hash un nuovo negozio con un simbolo identificativo ed i
  # seguenti parametri:
  # name: nome del negozio
  # can_sell: puoi vendere al negozio
  # can_buy: il negozio può vendere
  # goods: beni iniziali del negozio (quelli che ha la prima volta che ci vai)
  # random_goods: beni che possono comparire a caso dopo un po'
  # sia i goods che random goods sono degli array di hash. I goods possono
  # avere i seguenti parametri:
  # id: ID dell'oggetto type: tipo (1: item, 2: arma, 3: armatura)
  # max: (facoltativo) numero di oggetti massimi posseduti dal negozio. Se
  # questo parametro è mancante, gli oggetti sono infiniti.
  # price: (facoltativo) se presente, il prezzo dell'articolo viene
  # sostituito da quello definito dal parametro.
  # sell_locked: (facoltativo) se true, impedisce agli articoli di scomparire
  # nel tempo perché acquistati da qualcun altro. Non si applica agli articoli
  # infiniti.
  # deny_sales: (facoltativo) se true, l'articolo non può essere messo in saldo
  # repl_rate: modifica la probabilità di far comparire l'oggetto (solo nei
  # random goods). Valore da 0 a 100
  # In alternativa, puoi definire l'oggetto da vendere così:
  # set: 'TIPOIDxQUANTITA'
  # TIPO è il tipo dell'oggetto (i: item, w: arma, a: armatura), poi l'ID e
  # facoltativamente anche la quantità massima.
  # esempio: 'i10x5' -> il negozio vende 5 item con ID 10
  # esempio: 'w1' -> l'oggetto vende l'arma con ID 1 (illimitate)
  # La differenza tra goods e random_goods è l'elenco degli oggetti disponibili
  # la prima volta che si visita il negozio. Gli oggetti limitati NON torneranno.
  # Nell'elenco random_goods invece potrebbero comparire casualmente dopo un po'.
  # Inoltre, max_quantity assume due significati diversi: nei goods indica il
  # numero iniziale di quell'oggetto, in random_goods il numero massimo oltre
  # il quale l'oggetto non viene rifornito (cioè, se il negozio ha già 5 pozioni
  # che è il numero massimo, non può aumentare ulteriormente)
  # handles: è il tipo di merce che tratta il commerciante. Serve per gestire gli
  # oggetti che vende il giocatore. Ad esempio, se vendi una pozione in un negozio
  # di oggetti vari, questa viene aggiunta all'assortimento. Se vendi una spada,
  # scompare poiché il negozio non gestisce armi. Esempio:
  # :handles => [:weapons, :armors, :items]
  # Se il parametro non viene gestito, viene rilevato automaticamente dal tipo di
  # merce iniziale di cui dispone il negozio.
  # fidelity_rate: determina un calcolo punti fedeltà diverso da quello predefinito.
  # Ad esempio :fidelity_rate => 0.3
  # applica punti fedeltà pari al 30% del prezzo del bene
  SHOPS = {
      :bad_items => {
          :name => 'Emporio del sig. Corrado',
          :goods => [
              {:set => 'i1'},
              {:set => 'i5x20'},
              {:set => 'i6'},
              {:set => 'i107x1', :sell_locked => true},
              {:set => 'i153x1', :sell_locked => true},
              {:set => 'i251x1', :sell_locked => true, :price => 100}
          ],
          :random_goods => [
              {:set => 'i5x10'},
              {:set => 'i107x1', :sell_locked => true, :repl_rate => 200},
              {:set => 'i153x1', :sell_locked => true, :repl_rate => 200},
              {:set => 'i21x1'},
              {:set => 'i22x2'},
          ], :fidelity_rate => 0.05
      },
      :bad_equips => {
          :name => 'Equipaggiamenti di Baduelle',
          :goods => [
              {:set => 'w6x5'}, {:set => 'w127x8'}, {:set => 'w21x2'},
              {:set => 'w100x1'}, {:set => 'w70x2'},
              {:set => 'a2x3'}, {:set => 'a22x15'}, {:set => 'a62x2'},
              {:set => 'a63x2'}
          ],
          :random_goods => [
              {:set => 'w6x5'}, {:set => 'w127x8'}, {:set => 'w21x2'},
              {:set => 'w100x1'}, {:set => 'w70x2'},
              {:set => 'a2x3'}, {:set => 'a22x15'}, {:set => 'a62x2'},
              {:set => 'a63x2'}
          ],
          :fidelity_rate => 0.2
      },
      :sir_arm => {
          :name => 'Negozio di protezioni di Sirenas',
          :goods => [
              {:set => 'a2x5'}, {:set => 'a3x2'}, {:set => 'a22x20'},
              {:set => 'a24x10'}, {:set => 'a62x2'}, {:set => 'a63x4'},
              {:set => 'a64x2'},
          ],
          :random_goods => [
              {:set => 'a2x10'}, {:set => 'a3x8'}, {:set => 'a22x20'},
              {:set => 'a24x20'}, {:set => 'a62x8'}, {:set => 'a63x8'},
              {:set => 'a64x10'},
          ]
      },
      :sir_weap => {
          :name => 'Negozio d\'armi di Sirenas',
          :goods => [
              {:set => 'w6x10'}, {:set => 'w7x1'},
              {:set => 'w127x8'}, {:set => 'w21x2'},
              {:set => 'w50x1'}, {:set => 'w100x1'}, {:set => 'w71x1'},
              {:set => 'w150x1'}
          ],
          :random_goods => [
              {:set => 'w6x80'}, {:set => 'w7x25'},
              {:set => 'w127x90'}, {:set => 'w21x30'},
              {:set => 'w50x30'}, {:set => 'w100x30'}, {:set => 'w71x30'},
              {:set => 'w150x30'}, {:set => 'w78x1', :repl_rate => 0.2}
          ]
      },
      :sir_items => {
          :name => 'Merceria del piccolo Tommy',
          :goods => [
              {:set => 'i1'},
              {:set => 'i5'},
              {:set => 'i6'}, {:set => 'i7x10'},
              {:set => 'i107x1', :sell_locked => true},
              {:set => 'i153x1', :sell_locked => true},
              {:set => 'i21x1'},
              {:set => 'i260x1', :sell_locked => true, :price => 250}
          ],
          :random_goods => [
              {:set => 'i7x15'},
              {:set => 'i107x1', :sell_locked => true, :repl_rate => 200},
              {:set => 'i153x1', :sell_locked => true, :repl_rate => 200},
              {:set => 'i21x1'},
              {:set => 'i22x2'},
              {:set => 'i46x2'},
              {:set => 'i50x1'},
              {:set => 'i9x1', :repl_rate => 0.1},
          ]
      },
      :sir_mag => {
          :name => 'Emporio della maga Gertrude',
          :goods => [
              {:set => 'i4x1'},
              {:set => 'i21x5'},
              {:set => 'w100x3'},
              {:set => 'w102x1'},
              {:set => 'a62x3'},
          ],
          :random_goods => [
              {:set => 'i4x1', :repl_rate => 0.4},
              {:set => 'i21x20'},
              {:set => 'w100x5'},
              {:set => 'w102x3'},
              {:set => 'a62x3'},
              {:set => 'i45x2'},
              {:set => 'i10x1', :repl_rate => 0.06},
              {:set => 'i138x1', :repl_rate => 0.03},
              {:set => 'i29x1', :repl_rate => 0.08},
              {:set => 'a121x1', :repl_rate => 0.1},
              {:set => 'a122x1', :repl_rate => 0.1},
              {:set => 'a124x1', :repl_rate => 0.2},
          ]
      },
      :monferr_items => {
          :name => 'Negozio di oggetti di Monferras',
          :goods => [
              {:set => 'i1'},
              {:set => 'i5'},
              {:set => 'i6'},
              {:set => 'i7x10'},
              {:set => 'i15x3'},
              {:set => 'i50x1', :sell_locked => true},
              {:set => 'i150x1', :sell_locked => true},
              {:set => 'i153x1', :sell_locked => true},
              {:set => 'i11x1', :sell_locked => true},
              {:set => 'i186x1'},
              {:set => 'i261x1', :sell_locked => true, :price => 500}
          ],
          :random_goods => [
              {:set => 'i50x1', :sell_locked => true, :repl_rate => 100},
              {:set => 'i150x1', :sell_locked => true, :repl_rate => 100},
              {:set => 'i153x1', :sell_locked => true, :repl_rate => 100},
              {:set => 'i20x1', :repl_rate => 0.1},
              {:set => 'i21x3'},
              {:set => 'i7x20'},
              {:set => 'i15x10'},
              {:set => 'i22x3'},
              {:set => 'i26x5'},
              {:set => 'i27x2'},
              {:set => 'i186x1', :repl_rate => 0.2},
          ]
      },
      :monferr_weapons => {
          :name => 'Negozio Armi di Monferras',
          :goods => [
              {:set => 'w30x6'},
              {:set => 'w22x5'},
              {:set => 'w10x2'},
              {:set => 'w51x2'},
              {:set => 'w76x4'},
              {:set => 'w102x5'},
              {:set => 'w132x4'},
              {:set => 'w151x1'},
              {:set => 'i22x3'},
              {:set => 'i23x1'}
          ],
          :random_goods => [
              {:set => 'w30x8'},
              {:set => 'w22x6'},
              {:set => 'w39x3'},
              {:set => 'w33x1'},
              {:set => 'w10x2'},
              {:set => 'w51x2'},
              {:set => 'w72x1', :repl_rate => 0.05},
              {:set => 'w76x2'},
              {:set => 'w102x5'},
              {:set => 'w132x4'},
              {:set => 'w151x2'},
              {:set => 'i22x5'},
              {:set => 'i23x2'},
              {:set => 'a301x1', :repl_rate => 20}
          ],
          :handles => [:weapons, :armors]
      },
      :monferr_armors => {
          :name => 'Negozio Armature di Monferras',
          :goods => [
              {:set => 'a4x13'},
              {:set => 'a24x8'},
              {:set => 'a25x5'},
              {:set => 'a64x4'},
              {:set => 'a67x5'},
              {:set => 'a242x3'}, # guanti semplici, non servono più forse
          ],
          :random_goods => [
              {:set => 'a4x25'},
              {:set => 'a5x2'},
              {:set => 'a24x16'},
              {:set => 'a25x10'},
              {:set => 'a64x8'},
              {:set => 'a67x10'},
              {:set => 'a123x1'},
              {:set => 'a129x1'},
              {:set => 'a130x2'},
          ],
          :handles => [:weapons, :armors]
      },
      :monferr_scaprs => {
          :name => 'Ciro, il venditore ambulante',
          :buy_discount => 5,
          :sale_bonus => 0.1,
          :goods => [
              {:set => 'w6x8'},
              {:set => 'w127x10'},
              {:set => 'w50x5'},
              {:set => 'w72x15'},
              {:set => 'w100x13'},
              {:set => 'w150x5'},
              {:set => 'a3x10'},
              {:set => 'a62x7'},
              {:set => 'a63x5'},
          ],
          :random_goods => [
              {:set => 'w6x25'},
              {:set => 'w127x25'},
              {:set => 'w50x25'},
              {:set => 'w72x25'},
              {:set => 'w100x25'},
              {:set => 'w150x25'},
              {:set => 'a3x25'},
              {:set => 'a62x25'},
              {:set => 'a63x25'},
              {:set => 'a310x1', :repl_rate => 5},
              {:set => 'a311x1', :repl_rate => 5},
          ]
      },
      :monferr_fruit => {
          :name => 'Gennaro, il fruttivendolo ambulante',
          :buy_discount => -5,
          :goods => [
              {:set => 'i41x10'},
              {:set => 'i41x7'},
              {:set => 'i42x5'},
              {:set => 'i48x2'},
          ],
          :random_goods => [
              {:set => 'i41x10'},
              {:set => 'i41x8'},
              {:set => 'i42x6'},
              {:set => 'i48x2'},
              {:set => 'a301x1', :repl_rate => 20}
          ]
      },
      :monferr_merchant => {
          :name => 'Pasquale, il mercante di strada',
          :goods => [
              {:set => 'i1x12'},
              {:set => 'i5x8'},
              {:set => 'i6x15'},
              {:set => 'i7x3'},
              {:set => 'a154x2'},
              {:set => 'a155x2'},
              {:set => 'a156x2'},
          ],
          :random_goods => [
              {:set => 'i1x50'},
              {:set => 'i4x2', :repl_rate => 0.3},
              {:set => 'i5x35'},
              {:set => 'i6x20'},
              {:set => 'i7x10'},
              {:set => 'i8x1', :repl_rate => 0.05},
              {:set => 'i9x1', :repl_rate => 0.05},
              {:set => 'i10x1', :repl_rate => 0.05},
              {:set => 'i11x1', :repl_rate => 0.05},
              {:set => 'i12x1', :repl_rate => 0.05},
              {:set => 'i13x1', :repl_rate => 0.05},
              {:set => 'i14x1', :repl_rate => 0.05},
              {:set => 'i20x1', :repl_rate => 0.05},
              {:set => 'i29x1', :repl_rate => 0.05},
              {:set => 'a154x5', :repl_rate => 0.1},
              {:set => 'a155x5', :repl_rate => 0.1},
              {:set => 'a156x5', :repl_rate => 0.1},
              {:set => 'a158x5', :repl_rate => 0.1},
              {:set => 'a134x5', :repl_rate => 0.1},
          ]
      },
      :florea_weap => {
          :name => 'Armeria di Florea',
          :goods => [
              {:set => 'w30x5'},
              {:set => 'w51x5'},
              {:set => 'w76x5'},
              {:set => 'a3x5'},
              {:set => 'a25x5'},
              {:set => 'a67x5'},
              {:set => 'a67x5'},
              {:set => 'a123x1'},
              {:set => 'a134x1'},
              {:set => 'a143x1'},
              {:set => 'a144x1'},
              {:set => 'a145x1'},
              {:set => 'a154x5'}
          ],
          :random_goods => [
              {:set => 'w33x5'},
              {:set => 'w10x5'},
              {:set => 'w128x5'},
              {:set => 'w76x5'},
              {:set => 'a3x5'},
              {:set => 'a25x5'},
              {:set => 'a67x5'},
              {:set => 'a67x5'},
              {:set => 'a123x1'},
              {:set => 'a134x1'},
              {:set => 'a143x1'},
              {:set => 'a144x1'},
              {:set => 'a145x1'},
              {:set => 'a154x5'},
              {:set => 'a301x1', :repl_rate => 25}
          ]
      },
      :pigwarts_magic => {
          :name => 'Negozio di magia di Pigwarts',
          :goods => [
              {:set => 'w100x15'},
              {:set => 'w102x1'},
              {:set => 'a30x15'},
              {:set => 'a199x3'},
              {:set => 'a200x1'},
              {:set => 'a261x5'},
          ],
          :random_goods => [
              {:set => 'w100x20'},
              {:set => 'w102x4'},
              {:set => 'w105x1', :repl_rate => 0.05},
              {:set => 'a30x20'},
              {:set => 'a199x5'},
              {:set => 'a200x5'},
              {:set => 'a201x1', :repl_rate => 0.05},
              {:set => 'a261x10'},
              {:set => 'a262x1', :repl_rate => 0.05},
          ]
      },
      :pigwarts_acc => {
          :name => 'Negozio di accessori di Pigwarts',
          :goods => [
              {:set => 'a130x3'},
              {:set => 'a131x2'},
              {:set => 'a133x5'},
              {:set => 'a136x2'},
              {:set => 'a143x1'},
              {:set => 'a145x2'},
              {:set => 'a148x1'},
              {:set => 'a155x5'},
          ],
          :random_goods => [
              {:set => 'a130x5', :repl_rate => 0.1},
              {:set => 'a131x5', :repl_rate => 0.1},
              {:set => 'a133x5', :repl_rate => 0.1},
              {:set => 'a136x5', :repl_rate => 0.1},
              {:set => 'a143x5', :repl_rate => 0.1},
              {:set => 'a144x5', :repl_rate => 0.1},
              {:set => 'a145x5', :repl_rate => 0.1},
              {:set => 'a148x5', :repl_rate => 0.1},
              {:set => 'a151x2', :repl_rate => 0.1},
              {:set => 'a121x1'},
              {:set => 'a122x1'},
              {:set => 'a155x5'},
          ]
      },
      :pigwarts_items => {
          :name => 'Negozio di souvenir di Pigwarts',
          :goods => [
              {:set => 'i4x2'},
              {:set => 'i31x10'},
              {:set => 'i33x10'},
              {:set => 'i35x10'},
              {:set => 'i32x3'},
              {:set => 'i34x3'},
              {:set => 'i36x3'},
              {:set => 'i86x1', :price => 200},
          ],
          :random_goods => [
              {:set => 'i4x3', :repl_rate => 0.6},
              {:set => 'i31x20'},
              {:set => 'i33x20'},
              {:set => 'i35x20'},
              {:set => 'i32x10'},
              {:set => 'i34x10'},
              {:set => 'i36x10'},
              {:set => 'i86x2', :repl_rate => 0.1},
              {:set => 'i45x5', :repl_rate => 0.5},
              {:set => 'i47x5', :repl_rate => 0.5},
              {:set => 'i49x2', :repl_rate => 0.3},
          ]
      },
      :carpia_items => {
          :name => 'Negozio di oggetti di Carpia',
          :buy_discount => 5,
          :goods => [
              {:set => 'i1'},
              {:set => 'i5'},
              {:set => 'i6'},
              {:set => 'i7x12'},
              {:set => 'i15x8'},
              {:set => 'i16x3'},
              {:set => 'i107x1', :sell_locked => true},
              {:set => 'i153x1', :sell_locked => true},
              {:set => 'i11x1', :sell_locked => true},
              {:set => 'i186x1'},
              {:set => 'i28x1'},
          ],
          :random_goods => [
              {:set => 'i107x1', :sell_locked => true, :repl_rate => 100},
              {:set => 'i153x1', :sell_locked => true, :repl_rate => 100},
              {:set => 'i20x1', :repl_rate => 0.1},
              {:set => 'i21x3'},
              {:set => 'i16x6'},
              {:set => 'i7x20'},
              {:set => 'i15x13'},
              {:set => 'i22x3'},
              {:set => 'i2x3', :repl_rate => 0.3},
              {:set => 'i25x2', :repl_rate => 0.2},
              {:set => 'i4x3', :repl_rate => 0.4},
              {:set => 'i26x5'},
              {:set => 'i27x2'},
              {:set => 'i186x1', :repl_rate => 0.5},
              {:set => 'i28x1', :repl_rate => 0.5},
          ]
      },
      :carpia_equips => {
          :name => 'Negozio di equipaggiamenti di Carpia',
          :buy_discount => 5,
          :goods => [
              {:set => 'w22x4'},
              {:set => 'w128x6'},
              {:set => 'w52x3'},
              {:set => 'w72x5'},
              {:set => 'w105x3'},
              {:set => 'a4x10'},
              {:set => 'a25x8'},
              {:set => 'a67x5'},
              {:set => 'a242x3'},
          ],
          :random_goods => [
              {:set => 'w22x20'},
              {:set => 'w128x20'},
              {:set => 'w52x20'},
              {:set => 'w72x10'},
              {:set => 'w105x20'},
              {:set => 'a4x20'},
              {:set => 'a25x20'},
              {:set => 'a67x20'},
              {:set => 'a242x20'},
              {:set => 'a301x1', :repl_rate => 30}
          ]
      },
      :faide_merchant_fruit => {
          :name => 'Giuseppe Verde, mercante ortofrutticolo',
          :replenishment_rate => 5,
          :goods => [
              {:set => 'i41x10', :price => 25},
              {:set => 'i42x10', :price => 32},
              {:set => 'i43x10', :price => 45},
              {:set => 'i46x1', :price => 50},
              {:set => 'i48x10', :price => 60},
              {:set => 'i51x2', :price => 500},
              {:set => 'i91x1', :price => 150},
              {:set => 'i28x1'},
          ],
          :random_goods => [
              {:set => 'i41x15', },
              {:set => 'i42x16', },
              {:set => 'i43x15', },
              {:set => 'i46x2', },
              {:set => 'i48x15', },
              {:set => 'i51x3', },
              {:set => 'i91x2', },
              {:set => 'i28x2', },
          ]
      },
      :faide_merchant_yugure => {
          :name => 'Shinji-san, il mercante da Yugure',
          :buy_discount => -0.1,
          :goods => [
              {:set => 'a261x3'},
              {:set => 'a262x1'},
              {:set => 'a136x5'},
              {:set => 'a131x7'},
              {:set => 'i47x7'},
              {:set => 'i49x1'},
              {:set => 'i52x3'},
              {:set => 'i56x5'},
              {:set => 'i57x7'},
              {:set => 'i66x3'},
          ],
          :random_goods => [
              {:set => 'a261x6', :repl_rate => 0.5},
              {:set => 'a262x1', :repl_rate => 0.5},
              {:set => 'a271x1', :repl_rate => 0.02, :sell_locked => true},
              {:set => 'a136x10', :repl_rate => 0.5},
              {:set => 'a125x3', :repl_rate => 0.5},
              {:set => 'a131x15', :repl_rate => 0.5},
              {:set => 'a134x5', :repl_rate => 0.5},
              {:set => 'i47x5'},
              {:set => 'i49x2'},
              {:set => 'i52x3'},
              {:set => 'i56x4'},
              {:set => 'i57x5'},
              {:set => 'i66x3'},
              {:set => 'a310x1', :repl_rate => 8},
              {:set => 'a311x1', :repl_rate => 8},
          ]
      },
      :faide_merchant_adele => {
          :name => 'Ugo, il mercante da Adele',
          :buy_discount => -0.2,
          :goods => [
              {:set => 'i49x2'},
              {:set => 'i50x1'},
              {:set => 'i53x10'},
              {:set => 'i54x15'},
              {:set => 'i56x3'},
              {:set => 'i59x3'},
              {:set => 'i66x2'},
              {:set => 'i67x5'},

          ],
          :random_goods => [
              {:set => 'i49x5'},
              {:set => 'i50x3'},
              {:set => 'i53x20'},
              {:set => 'i54x15'},
              {:set => 'i55x7'},
              {:set => 'i56x3'},
              {:set => 'i59x3'},
              {:set => 'i65x5'},
              {:set => 'i66x5'},
              {:set => 'i67x7'},
              {:set => 'i61x3'},
              {:set => 'i62x3'},
              {:set => 'i63x3'},

          ]
      },
      :faide_merchant_priest => {
          :name => 'Padre Orazio, mercante vagabondo',
          :supply_rate => 50,
          :goods => [
              {:set => 'w10x15'},
              {:set => 'w30x15'},
              {:set => 'w7x25'},
              {:set => 'w22x25'},
              {:set => 'w50x25'},
              {:set => 'w71x25'},
              {:set => 'w102x25'},
              {:set => 'w151x25'},
          ],
          :random_goods => [
              {:set => 'w10x15'},
              {:set => 'w30x15'},
              {:set => 'w7x25'},
              {:set => 'w22x25'},
              {:set => 'w50x25'},
              {:set => 'w71x25'},
              {:set => 'w102x25'},
              {:set => 'w151x25'},
              {:set => 'a312x1', :repl_rate => 5},
              {:set => 'a313x1', :repl_rate => 5},
          ]
      },
      :faide_weapons => {
          :name => 'Armeria di Sebastiano',
          :goods => [
              {:set => 'w10x30'},
              {:set => 'w23x30'},
              {:set => 'w52x30'},
              {:set => 'w155x30'},
          ],
          :random_goods => [
              {:set => 'w10x30'},
              {:set => 'w23x30'},
              {:set => 'w52x30'},
              {:set => 'w155x30'},
              {:set => 'a301x1', :repl_rate => 40},
          ],
          :replenishment_rate => 5
      },
      :faide_armors => {
          :name => 'Scuderia di Giorgio',
          :goods => [
              {:set => 'a4x30'},
              {:set => 'a5x10'},
              {:set => 'a6x1'},
              {:set => 'a24x20'},
              {:set => 'a26x1'},
              {:set => 'a64x20'},
              {:set => 'a66x10'},
              {:set => 'a67x20'},
              {:set => 'a243x10'},
          ],
          :random_goods => [
              {:set => 'a4x30'},
              {:set => 'a5x10'},
              {:set => 'a6x1'},
              {:set => 'a24x20'},
              {:set => 'a26x1'},
              {:set => 'a64x20'},
              {:set => 'a66x10'},
              {:set => 'a67x20'},
              {:set => 'a243x10'},
          ],
          :replenishment_rate => 5
      },
      :faide_items => {
          :name => 'Negozio di oggetti di nonna Assunta',
          :replenishment_rate => 5,
          :goods => [
              {:set => 'i1'},
              {:set => 'i5'},
              {:set => 'i6'},
              {:set => 'i7x25'},
              {:set => 'i15x16'},
              {:set => 'i16x8'},
              {:set => 'i38x1'},
              {:set => 'i26x2'},
              {:set => 'i107x1', :sell_locked => true},
              {:set => 'i153x1', :sell_locked => true},
              {:set => 'i11x1', :sell_locked => true},
              {:set => 'i186x2'},
              {:set => 'i252x1', :sell_locked => true, :price => 2000},
              {:set => 'i253x1', :sell_locked => true, :price => 1000},
          ],
          :random_goods => [
              {:set => 'i107x1', :sell_locked => true, :repl_rate => 100},
              {:set => 'i153x1', :sell_locked => true, :repl_rate => 100},
              {:set => 'i20x1', :repl_rate => 0.1},
              {:set => 'i21x5'},
              {:set => 'i2x2'},
              {:set => 'i16x8'},
              {:set => 'i7x30'},
              {:set => 'i15x30'},
              {:set => 'i22x5'},
              {:set => 'i23x5'},
              {:set => 'i26x5'},
              {:set => 'i29x1', :repl_rate => 0.2},
              {:set => 'i31x3', :repl_rate => 0.9},
              {:set => 'i2x3', :repl_rate => 0.5},
              {:set => 'i25x2', :repl_rate => 0.8},
              {:set => 'i4x3', :repl_rate => 0.6},
              {:set => 'i26x5'},
              {:set => 'i27x2'},
              {:set => 'i38x2'},
              {:set => 'i186x3', :repl_rate => 0.9},
              {:set => 'i25x2', :repl_rate => 0.3},
              {:set => 'i13x1', :repl_rate => 0.3}
          ]
      },
      :faide_magic => {
          :name => 'Negozio magico di Sabrina',
          :goods => [
              {:set => 'i31x20'},
              {:set => 'i33x20'},
              {:set => 'i35x20'},
              {:set => 'i86x3'},
              {:set => 'w105x7'},
              {:set => 'w106x3'},
              {:set => 'a65x5'},
              {:set => 'a199x6'},
              {:set => 'a201x3'},
          ],
          :random_goods => [
              {:set => 'i31x20'},
              {:set => 'i33x20'},
              {:set => 'i35x20'},
              {:set => 'i32x5'},
              {:set => 'i34x5'},
              {:set => 'i36x5'},
              {:set => 'i45x5'},
              {:set => 'i47x5'},
              {:set => 'i72x1'},
              {:set => 'i86x3'},
              {:set => 'w105x10'},
              {:set => 'w106x5'},
              {:set => 'a65x10'},
              {:set => 'a199x10'},
              {:set => 'a201x10'},
          ]
      },
      :farse_items => {
          :name => 'Negozio di oggetti di Leopoldo',
          :replenishment_rate => 4,
          :sell_bonus => 50,
          :buy_discount => -30,
          :goods => [
              {:set => 'i1x20'},
              {:set => 'i5x15'},
              {:set => 'i6x25'},
              {:set => 'i7x4'},
              {:set => 'i15x1'},
              {:set => 'i16x2'},
              {:set => 'i254x1', :sell_locked => true, :price => 2000},
          ],
          :random_goods => [
              {:set => 'i1x30'},
              {:set => 'i5x30'},
              {:set => 'i6x30'},
              {:set => 'i7x20'},
              {:set => 'i15x20'},
              {:set => 'i16x20'},
              {:set => 'i10x2', :repl_rate => 0.5},
              {:set => 'i11x2', :repl_rate => 0.5},
              {:set => 'i38x3'},
              {:set => 'i28x2', :repl_rate => 0.6},
              {:set => 'i26x5'},
              {:set => 'i70x5'},
              {:set => 'i59x7'},
              {:set => 'i58x10'},
              {:set => 'i54x15'},
          ]
      },
      :farse_weapons => {
          :name => 'Giulio, il coraggioso imprenditore',
          :replenishment_rate => 5,
          :depletion_rate => 3,
          :buy_discount => -30,
          :goods => [
              {:set => 'w22x5'},
              {:set => 'w10x4'},
              {:set => 'w128x5'},
              {:set => 'a5x2'},
              {:set => 'a37x1'},
              {:set => 'a65x2'},
              {:set => 'a66x1'},
              {:set => 'a67x2'},
              {:set => 'a243x2'},
          ],
          :random_goods => [
              {:set => 'w22x10'},
              {:set => 'w10x8'},
              {:set => 'w128x10'},
              {:set => 'a5x4'},
              {:set => 'a37x2'},
              {:set => 'a65x4'},
              {:set => 'a66x2'},
              {:set => 'a67x4'},
              {:set => 'a243x4'},
              {:set => 'a310x1', :repl_rate => 7},
              {:set => 'a311x1', :repl_rate => 7},
          ]
      },
      :balthazar_scrolls => {
          :name => 'Pergamene & Pozioni di Margot',
          :goods => [
              {:set => 'i31x10'},
              {:set => 'i33x10'},
              {:set => 'i35x10'},
              {:set => 'i32x5'},
              {:set => 'i34x5'},
              {:set => 'i36x5'},
              {:set => 'i38x3'},
              {:set => 'i186x2'},
              {:set => 'i1'},
              {:set => 'i2x5'},
              {:set => 'i4x2'},
              {:set => 'i21x5'},
          ],
          :random_goods => [
              {:set => 'i31x20'},
              {:set => 'i33x20'},
              {:set => 'i35x20'},
              {:set => 'i32x10'},
              {:set => 'i34x10'},
              {:set => 'i36x10'},
              {:set => 'i38x10'},
              {:set => 'i186x5'},
              {:set => 'i187x2', :repl_rate => 0.5},
              {:set => 'i4x5', :repl_rate => 0.1},
              {:set => 'i2x20'},
              {:set => 'i8x1', :repl_rate => 0.01},
              {:set => 'i19x1', :repl_rate => 0.01},
              {:set => 'i21x10'},
          ]
      },
      :balthazar_potions => {
          :name => 'Gli intrugli di Genoveffa',
          :replenishment_rate => 3,
          :goods => [
              {:set => 'i6x22'},
              {:set => 'i7x6'},
              {:set => 'i5x8'},
              {:set => 'i21x10'},
              {:set => 'i22x8'},
              {:set => 'i30x7'},
              {:set => 'i23x5'},
              {:set => 'i45x3'},
              {:set => 'i47x8'},
              {:set => 'i53x10'},
              {:set => 'i54x7'},
              {:set => 'i58x6'},
              {:set => 'i160x1'}
          ],
          :random_goods => [
              {:set => 'i6x30'},
              {:set => 'i7x10'},
              {:set => 'i5x12'},
              {:set => 'i21x20'},
              {:set => 'i22x16'},
              {:set => 'i30x14'},
              {:set => 'i23x10'},
              {:set => 'i45x8'},
              {:set => 'i47x20'},
              {:set => 'i53x20'},
              {:set => 'i54x15'},
              {:set => 'i55x15'},
              {:set => 'i57x24'},
              {:set => 'i58x12'},
              {:set => 'i60x5'},
              {:set => 'i65x6'},
              {:set => 'i160x5'}
          ]
      },
      :balthazar_magic => {
          :name => 'La bottega magica di Waldorf',
          :goods => [
              {:set => 'w105x3'},
              {:set => 'w106x2'},
              {:set => 'w107x1'},
              {:set => 'a76x2'},
              {:set => 'a39x2'},
              {:set => 'a201x3'},
              {:set => 'a202x1'},
              {:set => 'a261x3'},
              {:set => 'a262x1'},
          ],
          :random_goods => [
              {:set => 'w105x10'},
              {:set => 'w106x10'},
              {:set => 'w107x5'},
              {:set => 'a76x5'},
              {:set => 'a39x5'},
              {:set => 'a201x5'},
              {:set => 'a202x3'},
              {:set => 'a261x5'},
              {:set => 'a262x3'},
              {:set => 'a203x1', :repl_rate => 0.3},
              {:set => 'a204x1', :repl_rate => 0.3},
              {:set => 'a205x1', :repl_rate => 0.3},
              {:set => 'a206x1', :repl_rate => 0.3},
          ]
      },
      :balthazar_jewels => {
          :name => 'Gioielleria di Balthazar',
          :replenishment_rate => 5,
          :depletion_rate => 5,
          :goods => [
              {:set => 'a124x2'},
              {:set => 'a126x1'},
              {:set => 'a129x5'},
              {:set => 'a131x6'},
              {:set => 'a133x8'},
              {:set => 'a134x2'},
              {:set => 'a136x5'},
              {:set => 'a143x10'},
              {:set => 'a144x10'},
              {:set => 'a157x7'},
              {:set => 'a147x3'},
          ],
          :random_goods => [
              {:set => 'a121x10'},
              {:set => 'a122x10'},
              {:set => 'a123x10'},
              {:set => 'a124x10'},
              {:set => 'a126x10'},
              {:set => 'a129x10'},
              {:set => 'a131x10'},
              {:set => 'a133x15'},
              {:set => 'a134x10'},
              {:set => 'a136x10'},
              {:set => 'a143x20'},
              {:set => 'a144x20'},
              {:set => 'a157x15'},
              {:set => 'a147x10'},
              {:set => 'a159x1'},
              {:set => 'a160x1'},
              {:set => 'a161x1'},
              {:set => 'a162x1'},
          ]
      },
      :balthazar_grocery_quest => {
          :name => 'La bottega di Thomas',
          :goods => [
              {:set => 'i1x7'}
          ]
      },
      :balthazar_item => {
          :name => 'La bancarella di Biagio',
          :goods => [
              {:set => 'i1x35'},
              {:set => 'i2x12'},
              {:set => 'i4x2'},
              {:set => 'i5x15'},
              {:set => 'i6x20'},
              {:set => 'i7x7'},
              {:set => 'i15x3'},
              {:set => 'i16x2'},
              {:set => 'i50x2'},
              {:set => 'i52x3'},
          ],
          :random_goods => [
              {:set => 'i1x60'},
              {:set => 'i2x20'},
              {:set => 'i4x4'},
              {:set => 'i5x30'},
              {:set => 'i6x40'},
              {:set => 'i7x20'},
              {:set => 'i15x10'},
              {:set => 'i16x10'},
              {:set => 'i50x5'},
              {:set => 'i52x5'},
              {:set => 'i18x1'},
              {:set => 'i25x2'},
              {:set => 'i26x10'},
          ]
      },
      :balthazar_weapons => {
          :name => 'L\'onesto venditore di armi Gildo',
          :goods => [
              {:set => 'w7x15'},
              {:set => 'w9x10'},
              {:set => 'w10x2'},
              {:set => 'w22x15'},
              {:set => 'w23x1'},
              {:set => 'w33x1'},
              {:set => 'w39x10'},
              {:set => 'w40x1'},
              {:set => 'w51x5'},
              {:set => 'w53x2'},
              {:set => 'w72x3'},
              {:set => 'w75x2'},
              {:set => 'w105x10'},
              {:set => 'w106x5'},
              {:set => 'w107x2'},
              {:set => 'w128x10'},
              {:set => 'w129x5'},
              {:set => 'w153x5'},
              {:set => 'w155x1'},
          ],
          :random_goods => [
              {:set => 'w7x30'},
              {:set => 'w9x20'},
              {:set => 'w10x5'},
              {:set => 'w22x30'},
              {:set => 'w23x3'},
              {:set => 'w33x3'},
              {:set => 'w39x20'},
              {:set => 'w40x3'},
              {:set => 'w51x10'},
              {:set => 'w53x4'},
              {:set => 'w72x5'},
              {:set => 'w75x4'},
              {:set => 'w105x20'},
              {:set => 'w106x10'},
              {:set => 'w107x5'},
              {:set => 'w128x20'},
              {:set => 'w129x10'},
              {:set => 'w153x10'},
              {:set => 'w155x5'},
              {:set => 'w11x1', :sell_locked => true, :repl_rate => 0.2},
              {:set => 'w12x1', :sell_locked => true, :repl_rate => 0.2},
              {:set => 'w13x1', :sell_locked => true, :repl_rate => 0.2},
              {:set => 'w135x1', :sell_locked => true, :repl_rate => 0.4},
              {:set => 'w136x1', :sell_locked => true, :repl_rate => 0.4},
              {:set => 'w137x1', :sell_locked => true, :repl_rate => 0.4},
              {:set => 'a306x1', :repl_rate => 10},
              {:set => 'a307x1', :repl_rate => 10},
              {:set => 'a308x1', :repl_rate => 10},
              {:set => 'a309x1', :repl_rate => 10},
              {:set => 'a310x1', :repl_rate => 10},
              {:set => 'a311x1', :repl_rate => 10},
              {:set => 'a312x1', :repl_rate => 3},
              {:set => 'a313x1', :repl_rate => 3},
              {:set => 'a301x1'},
              {:set => 'a302x1', :repl_rate => 20},
          ]
      },
      :balthazar_boutique => {
          :name => 'La bottega della moda di Balthazar',
          :goods => [
              {:set => 'a25x5'},
              {:set => 'a29x2'},
              {:set => 'a30x1'},
              {:set => 'a63x4'},
              {:set => 'a67x4'},
              {:set => 'a69x2'},
          ],
          :random_goods => [
              {:set => 'a25x10'},
              {:set => 'a29x5'},
              {:set => 'a30x5'},
              {:set => 'a63x10'},
              {:set => 'a67x10'},
              {:set => 'a69x5'},
              {:set => 'a32x1', :sell_locked => true, :repl_rate => 0.5},
          ]
      },
      :balthazar_souvenirs => {
          :name => 'Bancarella dei souvenir di Balthazar',
          :can_sell => false,
          :goods => [
              {:set => 'i38x15'},
              {:set => 'i107x1', :sell_locked => false},
              {:set => 'i108x1', :sell_locked => false},
              {:set => 'i150x1', :sell_locked => false},
              {:set => 'i153x1', :sell_locked => false},
              {:set => 'i160x2'},
              {:set => 'i142x2'},
              {:set => 'i255x1', :sell_locked => true, :price => 1000},
              {:set => 'i256x1', :sell_locked => true, :price => 3000},
          ],
          :random_goods => [
              {:set => 'i38x15'},
              {:set => 'i107x1'},
              {:set => 'i108x1'},
              {:set => 'i150x1'},
              {:set => 'i153x1'},
              {:set => 'i160x5'},
              {:set => 'i28x1'},
              {:set => 'i109x1'},
              {:set => 'i29x1'},
              {:set => 'i142x5'},
          ]
      },
      :balthazar_vegetables => {
          :name => 'Fruttivendolo di Balthazar',
          :can_sell => false,
          :buy_discount => 500,
          :goods => [
              {:set => 'i21x25'},
              {:set => 'i41x15'},
              {:set => 'i43x10'},
              {:set => 'i48x6'},
              {:set => 'i46x4'},
          ],
          :random_goods => [
              {:set => 'i41x50'},
              {:set => 'i21x30'},
              {:set => 'i43x20'},
              {:set => 'i48x12'},
              {:set => 'i46x8'},
          ]
      },
      :balthazar_items_accessories => {
          :name => 'Anastasia, l\'aiutante di Thomas',
          :goods => [
              {:set => 'i170x1'},
              {:set => 'i173x1'},
              {:set => 'i174x1'},
              {:set => 'i176x1'},
              {:set => 'i180x1'},
              {:set => 'i185x1'},
          ],
          :random_goods => [
              {:set => 'i170x1'},
              {:set => 'i173x1'},
              {:set => 'i174x1'},
              {:set => 'i176x1'},
              {:set => 'i180x1'},
              {:set => 'i185x1'},
          ]

      },
      :yugure_shop => {
          :name => 'Drogheria di Yugure',
          :goods => [
              {:set => 'i1'},
              {:set => 'i2x40'},
              {:set => 'i4x3'},
              {:set => 'i5'},
              {:set => 'i7x25'},
              {:set => 'i16x7'},
              {:set => 'i21x15'},
              {:set => 'i22x20'},
              {:set => 'i23x15'},
              {:set => 'i28x10'},
              {:set => 'i38x10'},
              {:set => 'i107x1'},
              {:set => 'i116x20'},
              {:set => 'i153x1'},
          ],
          :random_goods => [
              {:set => 'i2x60'},
              {:set => 'i4x8'},
              {:set => 'i7x40'},
              {:set => 'i8x1', :repl_rate => 0.01},
              {:set => 'i15x4'},
              {:set => 'i16x10'},
              {:set => 'i19x1', :repl_rate => 0.02},
              {:set => 'i20x1', :repl_rate => 0.03},
              {:set => 'i21x25'},
              {:set => 'i22x30'},
              {:set => 'i23x25'},
              {:set => 'i26x20'},
              {:set => 'i28x15'},
              {:set => 'i29x2', :repl_rate => 0.1},
              {:set => 'i38x15'},
              {:set => 'i107x1', :repl_rate => 0.5},
              {:set => 'i116x40'},
              {:set => 'i153x1', :repl_rate => 0.5},
          ]
      },
      :yugure_weapons => {
          :name => 'Negozio d\'armi di Yugure',
          :goods => [
              {:set => 'w14x1'},
              {:set => 'w24x1'},
              {:set => 'w41x1'},
              {:set => 'w54x1'},
              {:set => 'w74x1'},
              {:set => 'w110x1'},
              {:set => 'w130x1'},
              {:set => 'w156x1'},
          ],
          :random_goods => [
              {:set => 'w14x2'},
              {:set => 'w24x2'},
              {:set => 'w41x2'},
              {:set => 'w54x2'},
              {:set => 'w74x2'},
              {:set => 'w110x2'},
              {:set => 'w130x2'},
              {:set => 'w156x2'},
              {:set => 'a302x1'},
              {:set => 'a303x1', :repl_rate => 50},
              {:set => 'a308x1', :repl_rate => 10},
              {:set => 'a309x1', :repl_rate => 10},
          ]
      },
      :yugure_armors => {
          :name => 'Negozio di protezioni di Yugure',
          :goods => [
              {:set => 'a9x1'},
              {:set => 'a40x1'},
              {:set => 'a41x1'},
              {:set => 'a42x1'},
              {:set => 'a81x1'},
              {:set => 'a82x1'},
              {:set => 'a83x1'},
              {:set => 'a245x1'},
              {:set => 'a254x1'},
          ],
          :random_goods => [
              {:set => 'a9x2'},
              {:set => 'a40x2'},
              {:set => 'a41x2'},
              {:set => 'a42x2'},
              {:set => 'a81x2'},
              {:set => 'a82x2'},
              {:set => 'a83x2'},
              {:set => 'a245x2'},
          ]
      },
      :nevandra_armors => {
          :name => 'Negozio d\'armi di Nevandra',
          :goods => [
              {:set => 'a6x3'},
              {:set => 'a29x3'},
              {:set => 'a31x1'},
              {:set => 'a75x2'},
              {:set => 'a77x2'},
              {:set => 'a244x2'},
          ],
          :random_goods => [
              {:set => 'a6x6'},
              {:set => 'a29x6'},
              {:set => 'a31x3'},
              {:set => 'a75x5'},
              {:set => 'a77x5'},
              {:set => 'a244x5'},
              {:set => 'a10x1'},
              {:set => 'a11x1'},
              {:set => 'a11x1'},
              {:set => 'a43x1'},
              {:set => 'a44x1'},
              {:set => 'a47x1'},
              {:set => 'a48x1'},
              {:set => 'a84x1'},
              {:set => 'a85x1'},
              {:set => 'a88x1'},
              {:set => 'a89x1'},
              {:set => 'a246x1'},
          ]
      },
      :nevandra_weapons => {
          :name => 'Negozio di armi di Nevandra',
          :goods => [
              {:set => 'w10x3'},
              {:set => 'w23x2'},
              {:set => 'w33x4'},
              {:set => 'w34x2'},
              {:set => 'w53x2'},
              {:set => 'w73x2'},
              {:set => 'w129x4'},
              {:set => 'w131x2'},
              {:set => 'w134x1', :sell_locked => true},
              {:set => 'w155x3'},
              {:set => 'w156x2'},
              {:set => 'w156x2'},

              {:set => 'i21x10'},
              {:set => 'i21x10'},
              {:set => 'i22x10'},
              {:set => 'i23x7'},
          ],
          :random_goods => [
              {:set => 'w10x8'},
              {:set => 'w23x5'},
              {:set => 'w33x10'},
              {:set => 'w34x5'},
              {:set => 'w53x5'},
              {:set => 'w73x5'},
              {:set => 'w129x10'},
              {:set => 'w131x5'},
              {:set => 'w155x12'},
              {:set => 'w156x5'},
              {:set => 'w156x5'},
              {:set => 'w16x1'},
              {:set => 'w26x1'},
              {:set => 'w35x1'},
              {:set => 'w42x1'},
              {:set => 'w55x1'},
              {:set => 'w75x1'},
              {:set => 'w133x1'},
              {:set => 'w157x1'},

              {:set => 'i21x20'},
              {:set => 'i21x20'},
              {:set => 'i22x20'},
              {:set => 'i23x15'},
              {:set => 'a303x2'},
              {:set => 'a304x2', :repl_rate => 40},
              {:set => 'a306x1', :repl_rate => 30},
              {:set => 'a307x1', :repl_rate => 30},
          ]
      },
      :nevandra_magic => {
          :name => 'Magicheria di Nevandra',
          :goods => [
              {:set => 'w107x3'},
              {:set => 'a30x3'},
              {:set => 'a76x3'},
              {:set => 'a202x3'},
              {:set => 'a209x2'},
              {:set => 'a263x3'},
              {:set => 'a264x2'},
          ],
          :random_goods => [
              {:set => 'w107x6'},
              {:set => 'w112x1'},
              {:set => 'a30x6'},
              {:set => 'a45x1'},
              {:set => 'a46x1'},
              {:set => 'a76x6'},
              {:set => 'a86x1'},
              {:set => 'a87x1'},
              {:set => 'a202x6'},
              {:set => 'a203x2'},
              {:set => 'a204x2'},
              {:set => 'a205x2'},
              {:set => 'a206x2'},
              {:set => 'a207x2'},
              {:set => 'a208x2'},
              {:set => 'a209x4'},
              {:set => 'a263x6'},
              {:set => 'a264x4'},
              {:set => 'a265x1'},
          ]
      },
      :nevandra_access => {
          :name => 'Gadget magici di Nevandra',
          :goods => [
              {:set => 'a121x1'},
              {:set => 'a122x1'},
              {:set => 'a123x1'},
              {:set => 'a124x1'},
              {:set => 'a125x1'},
              {:set => 'a126x1'},
              {:set => 'a128x2'},
              {:set => 'a129x1'},
              {:set => 'a139x1'},
              {:set => 'a152x1'},
              {:set => 'a159x1'},
              {:set => 'a160x1'},
              {:set => 'a161x1'},
              {:set => 'a162x1'},
              {:set => 'a163x1'},
              {:set => 'a164x1'},
          ],
          :random_goods => [
              {:set => 'a121x3'},
              {:set => 'a122x3'},
              {:set => 'a123x3'},
              {:set => 'a124x3'},
              {:set => 'a125x3'},
              {:set => 'a126x3'},
              {:set => 'a128x3'},
              {:set => 'a129x3'},
              {:set => 'a139x3'},
              {:set => 'a152x3'},
              {:set => 'a159x3'},
              {:set => 'a160x3'},
              {:set => 'a161x3'},
              {:set => 'a162x3'},
              {:set => 'a163x3'},
              {:set => 'a164x3'},
              {:set => 'a166x1', :repl_rate => 0.5},
              {:set => 'a166x1', :repl_rate => 0.5},
              {:set => 'a172x1', :repl_rate => 0.5},
              {:set => 'a175x1'},
              {:set => 'a177x1'},
              {:set => 'a178x1', :repl_rate => 0.5},
          ]
      },
      :nevandra_items => {
          :name => 'Bottega di Nevandra',
          :goods => [
              {:set => 'i1'},
              {:set => 'i2'},
              {:set => 'i3x1'},
              {:set => 'i4x2'},
              {:set => 'i5'},
              {:set => 'i6'},
              {:set => 'i7x20'},
              {:set => 'i51x1'},
              {:set => 'i65x6'},
              {:set => 'i66x3'},
              {:set => 'i80x2'},
              {:set => 'i91x6'},
              {:set => 'i28x2'},
              {:set => 'i7x10'},
              {:set => 'i15x5'},
              {:set => 'i16x5'},
              {:set => 'i25x1'},
              {:set => 'i26x3'},
              {:set => 'i27x4'},
              {:set => 'i30x6'},
              {:set => 'i116x20'},
          ],
          :random_goods => [
              {:set => 'i3x1', :repl_rate => 0.5},
              {:set => 'i4x2'},
              {:set => 'i15x10'},
              {:set => 'i16x10'},
              {:set => 'i17x1', :repl_rate => 0.01},
              {:set => 'i18x1', :repl_rate => 0.1},
              {:set => 'i19x1', :repl_rate => 0.1},
              {:set => 'i20x1', :repl_rate => 0.1},
              {:set => 'i25x1', :repl_rate => 0.5},
              {:set => 'i26x5'},
              {:set => 'i27x8'},
              {:set => 'i29x2', :repl_rate => 0.3},
              {:set => 'i30x6'},
              {:set => 'i116x30'},
              {:set => 'i7x10'},
              {:set => 'i51x3'},
              {:set => 'i65x5'},
              {:set => 'i66x5'},
              {:set => 'i80x4'},
              {:set => 'i91x8'},
              {:set => 'i8x1', :repl_rate => 0.25},
              {:set => 'i9x1', :repl_rate => 0.25},
              {:set => 'i10x1', :repl_rate => 0.25},
              {:set => 'i11x1', :repl_rate => 0.25},
              {:set => 'i12x1', :repl_rate => 0.25},
              {:set => 'i13x1', :repl_rate => 0.25},
              {:set => 'i14x1', :repl_rate => 0.25},
              {:set => 'i28x6'},
          ]
      }
  }
end