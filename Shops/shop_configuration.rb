#==============================================================================
# * Impostazioni dei negozi
#==============================================================================
module ShopsSettings

  # Impostazioni sugli sconti
  DISCOUNTS = true
  # tipi di sconti, definiti in questo modo:
  # %SCONTO => %PROBAB. Esempio
  # 10 => 8: 8% di probabilità di applicare uno sconto del 10%
  DISCOUNT_TYPES = {10 => 15, 15 => 8, 20 => 4, 25 => 2, 50 => 1}

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
  # ha appena venduto al negozio, per sbaglio
  REBUY = true

  # simbolo dell'infinito
  ENDLESS = '' # c'è ma non si vede!
  TRADE_REFLOW_RATE = 5

  DEFAULT_SUPPLY_RATE = 10
  DEFAULT_WASTE_RATE = 8

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
  HOLD_UPDATE_MAPS = [87,89]

  # definizione dei negozi
  # ISTRUZIONI
  # Inserire nell'hash un nuovo negozio con un simbolo identificativo ed i
  # seguenti parametri:
  # name: nome del negozio
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
          :name => 'Emporio di Baduelle',
          :goods => [
              {:set => 'i1'},
              {:set => 'i5x20'},
              {:set => 'i6'},
              {:set => 'i107x1', :sell_locked => true},
              {:set => 'i153x1', :sell_locked => true},
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
              {:set => 'w6x5'}, {:set => 'w21x8'}, {:set => 'w27x2'},
              {:set => 'w50x1'}, {:set => 'w100x1'}, {:set => 'w70x2'},
              {:set => 'a2x3'}, {:set => 'a22x15'}, {:set => 'a62x2'},
              {:set => 'a63x2'}
          ],
          :random_goods => [
              {:set => 'w6x5'}, {:set => 'w21x8'}, {:set => 'w27x2'},
              {:set => 'w50x1'}, {:set => 'w100x1'}, {:set => 'w70x2'},
              {:set => 'a2x3'}, {:set => 'a22x15'}, {:set => 'a62x2'},
              {:set => 'a63x2'}
          ],
          :fidelity_rate => 0.2
      },
      :sir_arm => {
          :name => 'Negozio di protezioni di Sirenas',
          :goods => [
              {:set => 'a2x5'}, {:set => 'a3x2'}, {:set => 'a22x20'},
              {:set => 'a23x10'}, {:set => 'a62x2'}, {:set => 'a63x4'},
              {:set => 'a64x2'},
          ],
          :random_goods => [
              {:set => 'a2x10'}, {:set => 'a3x8'}, {:set => 'a22x20'},
              {:set => 'a23x20'}, {:set => 'a62x8'}, {:set => 'a63x8'},
              {:set => 'a64x10'},
          ]
      },
      :sir_weap => {
          :goods => [
              {:set => 'w6x10'}, {:set => 'w7x1'},
              {:set => 'w21x8'}, {:set => 'w27x2'},
              {:set => 'w50x1'}, {:set => 'w100x1'}, {:set => 'w71x1'},
              {:set => 'w150x1'}
          ],
          :random_goods => [
              {:set => 'w6x80'}, {:set => 'w7x25'},
              {:set => 'w21x90'}, {:set => 'w27x30'},
              {:set => 'w50x30'}, {:set => 'w100x30'}, {:set => 'w71x30'},
              {:set => 'w150x30'}, {:set => 'w78x1', :repl_rate => 20}
          ]
      },
      :sir_items => {
          :name => 'Negozio di oggetti di Sirenas',
          :goods => [
              {:set => 'i1'},
              {:set => 'i5'},
              {:set => 'i6'}, {:set => 'i7x10'},
              {:set => 'i107x1', :sell_locked => true},
              {:set => 'i153x1', :sell_locked => true},
              {:set => 'i21x1'}
          ],
          :random_goods => [
              {:set => 'i7x15'},
              {:set => 'i107x1', :sell_locked => true, :repl_rate => 200},
              {:set => 'i153x1', :sell_locked => true, :repl_rate => 200},
              {:set => 'i21x1'},
              {:set => 'i22x2'},
          ]
      },
      :sir_mag => {
          :name => 'Emporio magico di Sirenas',
          :goods => [
              {:set => 'i4x1'},
              {:set => 'i21x5'},
              {:set => 'w100x3'},
              {:set => 'w102x1'},
              {:set => 'a62x3'},
          ],
          :random_goods => [
              {:set => 'i4x1', :repl_rate => 40},
              {:set => 'i21x20'},
              {:set => 'w100x5'},
              {:set => 'w102x3'},
              {:set => 'a62x3'},
              {:set => 'i45x2'},
              {:set => 'i10x1', :repl_rate => 6},
              {:set => 'i138x1', :repl_rate => 3},
              {:set => 'i29x1', :repl_rate => 8},
              {:set => 'a121x1', :repl_rate => 10},
              {:set => 'a122x1', :repl_rate => 10},
              {:set => 'a124x1', :repl_rate => 20},
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
              {:set => 'i186x1'}
          ],
          :random_goods => [
              {:set => 'i50x1', :sell_locked => true, :repl_rate => 100},
              {:set => 'i150x1', :sell_locked => true,:repl_rate => 100},
              {:set => 'i153x1', :sell_locked => true,:repl_rate => 100},
              {:set => 'i20x1', :repl_rate => 10},
              {:set => 'i21x3'},
              {:set => 'i7x20'},
              {:set => 'i15x10'},
              {:set => 'i22x3'},
              {:set => 'i26x5'},
              {:set => 'i27x2'},
              {:set => 'i186x1', :repl_rate => 20},
          ]
      },
      :monferr_weapons => {
          :name => 'Negozio Armi di Monferras',
          :goods => [
              {:set => 'w8x6'},
              {:set => 'w9x5'},
              {:set => 'w19x2'},
              {:set => 'w51x2'},
              {:set => 'w76x4'},
              {:set => 'w102x5'},
              {:set => 'w132x4'},
              {:set => 'w151x1'},
              {:set => 'i22x3'},
              {:set => 'i23x1'}
          ],
          :random_goods => [
              {:set => 'w8x8'},
              {:set => 'w9x6'},
              {:set => 'w10x3'},
              {:set => 'w12x1'},
              {:set => 'w19x2'},
              {:set => 'w51x2'},
              {:set => 'w72x1', :repl_rate => 5},
              {:set => 'w76x2'},
              {:set => 'w102x5'},
              {:set => 'w132x4'},
              {:set => 'w151x2'},
              {:set => 'i22x5'},
              {:set => 'i23x2'}
          ],
          :handles => [:weapons, :armors]
      },
      :monferr_armors => {
          :name => 'Negozio Armature di Monferras',
          :goods => [
              {:set => 'a4x13'},
              {:set => 'a23x8'},
              {:set => 'a30x5'},
              {:set => 'a64x4'},
              {:set => 'a72x5'},
              {:set => 'a242x3'}, # guanti semplici, non servono più forse
          ],
          :random_goods => [
              {:set => 'a4x25'},
              {:set => 'a5x2'},
              {:set => 'a23x16'},
              {:set => 'a30x10'},
              {:set => 'a64x8'},
              {:set => 'a72x10'},
              {:set => 'a123x1'},
              {:set => 'a129x1'},
              {:set => 'a130x2'},
          ],
          :handles => [:weapons, :armors]
      },
      :florea_weap => {
          :name => 'Armeria di Florea',
          :goods => [
              {:set => 'w8x5'},
              {:set => 'w51x5'},
              {:set => 'w76x5'},
              {:set => 'a3x5'},
              {:set => 'a32x5'},
              {:set => 'a75x5'},
              {:set => 'a75x5'},
              {:set => 'a123x1'},
              {:set => 'a134x1'},
              {:set => 'a143x1'},
              {:set => 'a144x1'},
              {:set => 'a145x1'},
              {:set => 'a154x5'}
          ],
          :random_goods => [
              {:set => 'w12x5'},
              {:set => 'w19x5'},
              {:set => 'w22x5'},
              {:set => 'w76x5'},
              {:set => 'a3x5'},
              {:set => 'a32x5'},
              {:set => 'a75x5'},
              {:set => 'a75x5'},
              {:set => 'a123x1'},
              {:set => 'a134x1'},
              {:set => 'a143x1'},
              {:set => 'a144x1'},
              {:set => 'a145x1'},
              {:set => 'a154x5'}
          ]
      }
  }
end