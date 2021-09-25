$imported = {} if $imported == nil
$imported["H87_EquipEnchant"] = true
#==============================================================================
# ** H87Enchant
#------------------------------------------------------------------------------
#  Modulo di impostazioni e supporto per gli incantamenti
#==============================================================================
module H87Enchant
  MaxEnchant = 10 # Massimo valore di incantamento per l'equipaggiamento
  # Qui puoi modificare l'incremento in percentuale dei valori per ogni
  #   incantamento dell'arma
  Weapon_Modifier = {
      :atk => 11, #Incremento dell'attacco
      :spi => 15, #Incremento dello spirito
      :def => 5, #difesa
      :agi => 7, #agilità
      :price => 15 #prezzo
  }
  # Stessa cosa, ma per l'armatura
  Armor_Modifier = {
      :atk => 5,
      :spi => 5,
      :def => 10,
      :agi => 7,
      :price => 15
  }
  Power_Up_Price = 0.2
  # Tag degli effetti di potenziamento per le modifiche alle armi.
  # mhp: Incremento HP massimi
  # mmp: Incremento MP massimi
  # atk: Incremento Attacco
  # def: Incremento Difesa
  # spi: Incremento Spirito
  # agi: Incremento Agilità
  # cri: Incremento Critici
  # hit: Incremento Mira
  # eva: Incremento Evasione
  # odd: Incremento Odio
  # ele: Aggiunge elemento
  # sta: Aggiunge status
  # stm: Aggiunge status da rimuovere
  # esc: Aumenta le probabilità di fuga
  # ela: Amplifica l'elemento
  # hea: Amplifica le cure
  # rec: Cambia il ricaricamento
  # chb: Cambia la velocità delle magie
  # atb: ATB iniziale
  # vmp: Aumenta il rateo vampiresco
  # mpr: Cambia il consumo MP
  # its: Cambia le probabilità di salvare l'oggetto
  # anm: Cambia l'ID dell'animazione
  # mst: Status alla magia
  # hst: Status alla cura
  # inc: Sinergia iniziale
  # snd: Durata sinergia
  # snb: Bonus sinergia
  # dmb: Durata evocazione
  # stl: Probabilità furti
  # ico: Cambia l'icona
  # lhm param1 param2 valore: valore+ per param1 sotto x%
  # lhp stesso ma in percentuale
  # sid: incremento durata stati
  # amp: recupera MP con l'attacco
  # ats: aumenta l'attacco in base allo spirito
  # ira: aumenta l'ira attaccando
  # sir: aumento ira iniziale
  # kir: aumento ira uccisione
  # pnt: fa ignorare la difesa del bersaglio
  # scn: abilità scanner
  # duk: contrattacca quando evade
  WEAPON_TAGS = {
      1 => ["Stordente", "sta 8", "Probabilità di stordire con l'attacco.", 971],
      2 => ["Velenoso", "sta 2", "Probabilità di avvelenare con l'attacco.", 965],
      3 => ["Accecante", "sta 3", "Probabilità di accecare con l'attacco.", 966],
      4 => ["Mutolente", "sta 4", "Probabilità di causare silenzio con l'attacco.", 967],
      5 => ["Caotico", "sta 5", "Probabilità di confondere con l'attacco.", 968],
      6 => ["Soporifero", "sta 6", "Probabilità di addormentare con l'attacco.", 969],
      7 => ["Paralizzante", "sta 7", "Probabilità di paralizzare con l'attacco.", 970],
      8 => ["Vitale", "mhp +10", "Aumenta i PV massimi del 10%.", 976],
      9 => ["Del Mana", "mmp +10", "Aumenta i PM massimi del 10%.", 977],
      10 => ["Grintoso", "atk +10", "Aumenta l'attacco del 10%.", 978],
      11 => ["Spiritoso", "spi +10", "Aumenta lo Spirito del 10%.", 980],
      12 => ["Protettivo", "def +10", "Aumenta la Difesa del 10%.", 979],
      13 => ["Critico", "cri +4", "Aumenta prob. Critici del 4%.", 982],
      14 => ["Preciso", "hit +6", "Aumenta la Mira del 6%.", 985],
      15 => ["Liscio", "eva +8", "Aumenta l'Evasione dell'8%.", 986],
      16 => ["Brutto", "odd +30", "Aumenta l'Odio del 30%.", 623],
      17 => ["Fiammante", "ele 9, ela 9 +10", "Attacca con l'Elemento Fuoco e ne amplifica i danni.", 944],
      18 => ["Gelante", "ele 10, ela 10 +10", "Attacca con l'Elemento Ghiaccio e ne amplifica i danni.", 945],
      19 => ["Fulminante", "ele 11, ela 11 +10", "Attacca con l'Elemento Tuono e ne amplifica i danni.", 946],
      20 => ["del Buio", "ele 16, ela 16 +10, anm 131", "Attacca con l'Elemento Oscuro e ne amplifica i danni.", 950],
      21 => ["Lucente", "ele 15, ela 15 +10", "Attacca con l'Elemento Sacro e ne amplifica i danni.", 949],
      22 => ["Collante", "sta 16", "Probabilità di causare Lentezza con l'attacco.", 995],
      23 => ["Mortale", "sta 1", "Probabilità di causare Morte con l'attacco.", 964],
      24 => ["Irruente", "sta 14", "Probabilità di causare AntiDifesa con l'attacco.", 993],
      25 => ["Indebolente", "sta 13, sta 15", "sta 15", "Probabilità di causare AntiForza e AntiSpirito con l'attacco.", 992],
      26 => ["Magico", "chb -15", "Tempo per lanciare gli incantesimi diminuito.", 985],
      27 => ["Anti-Uomo", "ele 17", "Danni maggiori contro gli umani.", 1068],
      28 => ["Fugace", "esc +20", "Aumenta le probabilità di fuggire dagli scontri.", 991],
      29 => ["Valoroso", "snb +15", "Caricamento Sinergia +15%.", 920],
      30 => ["Magifuoco", "ela 9 +40", "Aumenta la potenza delle magie di Fuoco.", 104],
      31 => ["Magifreddo", "ela 10 + 40", "Aumenta la potenza delle magie di Ghiaccio.", 105],
      32 => ["Magituono", "ela 11 +40", "Aumenta la potenza delle magie di Tuono.", 106],
      33 => ["Magiacqua", "ela 12 +40", "Aumenta la potenza delle magie d'Acqua.", 107],
      34 => ["Magigaia", "ela 13 +40", "Aumenta la potenza delle magie di Terra.", 108],
      35 => ["Magivento", "ela 14 +40", "Aumenta la potenza delle magie di Vento.", 109],
      36 => ["Efficiente", "mpr -15", "Riduce il costo delle abilità del 15%.", 1034],
      37 => ["Rabbioso", "atk +20, def -15", "Aumenta l'attacco, ma diminuisce la difesa.", 978],
      38 => ["Possente", "atk +23, agi -15", "Aumenta l'attacco, ma diminuisce la velocità.", 978],
      39 => ["Spirituale", "spi +30, mpr +20", "Aumenta lo Spirito e il consumo delle magie.", 980],
      40 => ["Prode", "atb +50", "Comincia l'incontro con ATB a metà o più.", 1223],
      41 => ["Prode+", "atb +100", "Comincia l'incontro con l'ATB piena.", 1223],
      42 => ["del Sangue", "lhp hp atk +50", "Attacco +50% quando i PV sono sotto il 25%.", 1225],
      43 => ["Chance", "lhp hp agi +30, lhp hp eva +10", "Velocità +30% e Evasione +10% a PV bassi.", 1225],
      44 => ["Stamina", "lhp mp spi +100", "Spirito +100% se i PM stanno per esaurirsi.", 1225],
      45 => ["Furfante", "stl +30", "Aumenta le probabilità di furto del 30%.", 991],
      46 => ["Assorbi", "ele 8 +30", "Aumenta le abilità di assorbimento del 30%.", 1098],
      47 => ["Parassita", "vmp +5", "Assorbe il 5% di tutti i danni inflitti", 1022],
      48 => ["Medico", "hea +30" "Potenza delle magie curative +50%.", 1021],
      49 => ["Resistenza", "lhp hp def +50", "Aumenta la Difesa del 50% quando i PV sono bassi.", 1225],
      50 => ["Animalista", "dmb +20", "Aumenta la durata delle evocazioni.", 1019],
      51 => ["Vita2", "mhp +15", "Aumenta i PV massimi del 15%.", 976],
      52 => ["Mana2", "mmp +15", "Aumenta i PM massimi del 15%.", 977],
      53 => ["Grinta2", "atk +15", "Aumenta l'attacco del 15%.", 978],
      54 => ["Spirito2", "spi +15", "Aumenta lo Spirito del 15%.", 979],
      55 => ["Protettivo2", "def +15", "Aumenta la Difesa del 15%.", 979],
      56 => ["Critico2", "cri +6", "Aumenta prob. Critici del 6%.", 980],
      57 => ["Mira2", "hit +9", "Aumenta la Mira del 9%.", 981],
      58 => ["Liscio2", "eva +12", "Aumenta l'Evasione del 12%.", 982],
      59 => ["Acutezza2", "chb -25", "Tempo per caricare le abilità diminuito.", 983],
      60 => ["Bagnante", "ele 13, ela 13 +10", "Attacca con l'elemento Acqua e ne amplifica i danni.", 1004],
      61 => ["Polveroso", "ele 14, ela 14 +10", "Attacca con l'elemento Terra e ne amplifica i danni.", 1005],
      62 => ["Ventoso", "ele 15, ela 15 +10", "Attacca con l'elemento Vento e ne amplifica i danni.", 1006],
      63 => ["Coalizione", "snd +30", "Aumenta la durata della Sinergia quando attiva.", 920],
      64 => ["Selvaggio", "ele 18,ele 19,ele 21,ele 22", "Danni aumentati contro animali, rettili e uccelli.", 1068],
      65 => ["Veloce", "agi +15", "Aumenta la Velocità del 15%.", 981],
      66 => ["Ustionante", "sta 130", "Possibilità di infliggere Combustione.", 952],
      67 => ["Gelante", "sta 131", "Possibilità di infliggere Congelamento.", 953],
      68 => ["Folgorante", "sta 132", "Possibilità di infliggere Shock.", 954],
      69 => ["Magiparalisi", "mst 7", "Possibilità di infliggere Paralisi con magie.", 970],
      70 => ["Corrodi", "sta 135", "Possibilità di infliggere Vento Avverso.", 957],
      # - ARPIONE -
      71 => ["Stordente", "sta 8, ico 753", "Probabilità di stordire con l'attacco.", 971],
      72 => ["Irruente", "sta 14, ico 753", "Probabilità di causare AntiDifesa con l'attacco.", 995],
      73 => ["Critico", "cri +4, ico 753", "Aumenta prob. Critici del 4%.", 982],
      # -----------
      74 => ["Furia", "lhp hp cri +15", "Aumenta la probabilità di attacchi critici vicino alla morte.", 1225],
      75 => ["Crisi", "sta 115", "Possibilità di infliggere Crisi con l'attacco.", 1038],
      76 => ["Pacifico", "odd -30", "Diminuisce la probabilità di venire colpiti.", 1108],
      77 => ["Magispirito", "hst 11", "Probabilità di attivare TurboSpirito con la magia.", 979],
      78 => ["Magiveleno", "mst 2", "Probabilità di infliggere Veleno con le magie.", 965],
      79 => ["Rapido", "agi +9", "Aumenta la Velocità del 9%.", 980],
      80 => ["Sinergia", "inc 10", "Leggera ricarica della Sinergia ad ogni turno.", 920],
      81 => ["Etereo", "ele 25", "Danni aumentati contro le creature magiche.", 1068],
      # - CLAYMORE -
      97 => ["Ifrit", "ele 9, ela 9 +20, ico 358, anm 8", "Attacca con l'Elemento Fuoco e ne amplifica i danni.", 104],
      98 => ["Shiva", "ele 10, ela 10 +20, ico 359, anm 9", "Attacca con l'Elemento Ghiaccio e ne amplifica i danni.", 105],
      99 => ["Ramuh", "ele 11, ela 11 +20, ico 360, anm 10", "Attacca con l'Elemento Tuono e ne amplifica i danni.", 106],
      # - ALTRI
      100 => ["Furioso", "ira +3", "Aumenta la Furia ottenuta dagli attacchi.", 1226],
      101 => ["Depressivo", "mst 287", "Probabilità di infliggere Depressione con le magie.", 303],
      102 => ["Iniziativa", "iri +15", "Cominci con più Furia a inizio battaglia.", 1226],
      103 => ["Aguzzo", "ref +8", "I nemici si danneggiano se ti colpiscono", 620],
      104 => ["Offesa", "pls +10", "Aumenta la probabilità di infliggere stati alterati.", 1108],
      105 => ["Longevità", "sid 2", "Aumenta la durata degli stati alterati che infliggi.", 1108],
      106 => ["Dirompente", "crd +2", "Aumenta la potenza dei danni critici di 2x", 980],
      107 => ["Esorcista", "ele 21, ele 15", "Aumenta i danni contro non morti.", 949],
      108 => ["Sentenza", "mst 1", "Probabilità di infliggere Morte con le magie.", 964],
      109 => ["Arcobaleno", "snd +50, ico 705", "Aumenta la durata della Sinergia quando attiva.", 920],
      110 => ["Shock", "sta 7, ico 706", "Probabilità di paralizzare con l'attacco.", 970],
      111 => ["Corrodente", "sta 87, ico 707", "Causa Acido sul nemico (-200PV per turno)", 1094],
      # - TRANSISTOR
      112 => ['Switch()', 'sta 5, pls +10', 'Causa Confusione con l\'attacco.', 968],
      113 => ['Purge()', 'ref +10', 'Danneggia i nemici che ti colpiscono', 620],
      114 => ['Tap()', 'mhp +50', 'Incrementa i PV massimi del 50%', 976],
      # - RIGEL
      116 => ['Aimbot', 'hit +10', 'Aumenta la Mira del 10%', 981],
      117 => ['Frag', 'sta 289', 'Trasforma un nemico in bomba che esplode alla morte.', 479],
      118 => ['Cheater', 'sid 2', 'Aumenta di 2 turni la durata degli stati inflitti', 1108],
      119 => ['Lag', 'sta 16', 'Rallenta i nemici con l\'attacco', 995],
      # - ARMA PER MAGHI (da vedere)
      120 => ['Efficace', 'mat 25', 'L\'attacco semplice fa il 25% in più di danni.', 142],
      121 => ['Recupero', 'amp 2', 'Fa guadagnare 2 PM ad ogni attacco', 1230],
      # - ARMA DA ARCANO (da vedere)
      122 => ['Introforza', 'ats 10', 'Aumenta l\'attacco del 10% dello Spirito', 795],

      # - Cubo magico
      126 => ['Kikorangi', 'amp 4', 'Aumenta il numero di PM guadagnati con l\'attacco.',1084],
      127 => ['Papura', 'sta 2', 'Può infliggere Veleno con l\'attacco.', 965],
      128 => ['Kakariki'],
      129 => ['Karaka'],

      # ULTRA - viene applicata dai drop random (?)
      130 => ['Ultra A', 'atk +15', 'Aumenta l\'attacco del 15%.',120],
      131 => ['Ultra D', 'def +15', 'Aumenta la difesa del 15%.',121],
      132 => ['Ultra S', 'spi +15', 'Aumenta lo spirito del 15%.',122],
      133 => ['Ultra V', 'agi +15', 'Aumenta la velocità del 15%.',123],

      135 => ['Iracondo', 'ira +5', 'Aumenta la Furia attaccando', 1250],
      136 => ['Mietitore', 'kir +15', 'Guadagno 15 punti Furia uccidendo un nemico', 1250],
      137 => ['Furioso', 'sir +10', 'Dona 10 punti Furia a inizio battaglia', 1250],

      150 => ['Penetrante', 'pnt', 'Ignora la difesa del bersaglio negli attacchi normali', 1052],
      151 => ['Veggente', 'scn', 'Permette di conoscere le debolezze del bersaglio', 815],
      152 => ['Opportunista', 'duk, eva +10', 'Aumenta l\'evasione. Contrattacca su schivata', 1071],

      # Abilità notte nera
      153 => ['Caricante', 'amp 4, ico 570', 'Ogni volta che si esegue un attacco normale, recupera 4 PM.'],
      154 => ['Energica', 'ela 7 +30 , ico 571', 'Potenzia i danni da Energia del 30%.'],
      155 => ['Energica', 'ela 7 +30 , ico 572', 'Potenzia i danni da Energia del 30%.'],






      # ------------
  }
  # Stringhe di guida
  ST1 = 'Seleziona una pergamena per l\'incantamento'
  ST2 = 'Scegli un equipaggiamento da incantare'
  STQ = 'Premi nuovamente OK per procedere con l\'incantamento'
  ST3 = 'Incantamento in corso, incrocia le dita...'
  ST4 = 'Congratulazioni, l\'incantamento ha avuto successo!'
  ST5 = 'Che peccato! L\'incantamento è svanito!'
  # Probabilità di successo dell'incantamento
  def self.e_s_prob(enchant_state)
    case enchant_state
    when 0..2 #valore dell'incantamento
      100 #probabilità
    when 3..5
      70
    when 6..9
      50
    when 10..14
      30
    else
      10
    end
  end

  # Ottiene il modificatore di incantamento dell'arma
  #     symbol: simbolo del parametro
  # @return [Float]
  def self.get_w_mod(symbol)
    return Weapon_Modifier[symbol] / 100.0
  end

  # Ottiene il modificatore d'incantamento dell'armatura
  #     symbol: simbolo del parametro
  # @return [Float]
  def self.get_a_mod(symbol)
    return Armor_Modifier[symbol] / 100.0
  end

  # Incanta l'arma (obsoleto, non viene usato)
  # @deprecated
  # @param [RPG::Weapon] weapon
  # @param [Integer] n
  def self.enchant_weapon(weapon, n = 1)
    enchanted_weapon = weapon.clone
    enchanted_weapon.enchant_state += n
    return enchanted_weapon
  end

  # Processo che aggiunge un determinato potenziamento all'equipaggiamento
  #     equip: equipaggiamento
  #     power_up_id: tipo di potenziamento
  # @param [RPG::Weapon] equip
  # @param [Power_Up] power_up
  def self.power_equip(equip, power_up)
    $game_party.lose_item(equip, 1)
    $game_party.lose_item(power_up.item, power_up.number)
    $game_party.lose_gold(power_up.required_gold(equip))
    new_equip = equip.clone
    new_equip.add_power_up(power_up.id)
    return new_equip
  end

  # Processo che rimuove i potenziamenti da un equipaggiamento
  # @param [RPG::Weapn] equip equipaggiamento
  # @return [RPG::Weapon]
  def self.remove_power_up_from_equip(equip)
    $game_party.lose_item(equip, 1)
    enchant_state = equip.enchant_state
    case equip
    when RPG::Weapon
      new_equip = $data_weapons[equip.real_id].clone
    when RPG::Armor
      new_equip = $data_armors[equip.real_id].clone
    else
      raise ArgumentError.new('Nessun equipaggiamento per ' + equip.to_s)
    end
    new_equip.enchant_state = enchant_state if enchant_state > 0
    $game_party.gain_item(new_equip, 1)
    return new_equip
  end

  # Processo che prova ad incantare l'equipaggiamento dalla scroll e l'oggetto
  #   e restituisce l'oggetto risultante (incantato o no)
  # @param [RPG::Item] enchant_scroll
  # @param [RPG::Weapon] equip
  def self.try_enchant(enchant_scroll, equip)
    $game_party.consume_item(enchant_scroll)
    $game_party.lose_item(equip, 1)
    prob = enchant_scroll.secure_enchant ? 100 : e_s_prob(equip.enchant_state)
    new_equip = equip.clone
    if rand(100) <= prob
      new_equip.enchant
    else
      new_equip.enchant_state = 0
    end
    return new_equip
  end

  # Ottiene l'arma dall'array delle armi anche con un ID fittizio
  # @param [Float] id
  # @return [RPG::Weapon]
  def self.weapon_from_id(id)
    if id.is_a?(Integer)
      return $data_weapons[id]
    else
      real_id = id.to_s.split(".")[0].to_i
      weapon = $data_weapons[real_id].dup
      weapon_modifier = id.to_s.split(".")[1]
      weapon.enchant_state = weapon_modifier[0..1].to_i
      weapon.power_up = weapon_modifier[2..3].to_i
      return weapon
    end
  end

  # Ottiene l'armatura dall'array delle armature anche con un ID fittizio
  # @param [Float] id
  # @return [RPG::Armor]
  def self.armor_from_id(id)
    if id.is_a?(Integer)
      return $data_armors[id]
    else
      real_id = id.to_s.split(".")[0].to_i
      armor = $data_armors[real_id].dup
      armor.enchant_state = id.to_s.split(".")[1].to_i
      return armor
    end
  end
end

#==============================================================================
# ** EquipEnchant
#------------------------------------------------------------------------------
#  Modulo incluso negli equipaggiamenti
#==============================================================================
module EquipEnchant
  # imposta le proprietà dell'incantamento
  def setup_enchant_property
    return if @enchant_propr_setted
    @enchant_state = 0
    @enchant_propr_setted = true
    @max_enchant = H87Enchant::MaxEnchant
    @power_up = 0
    @special_text = ""
    @power_ups = []
    @enchantable = true
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
      when /<unenchantable>/i
        @enchantable = false
      when /<max enchant[ ]*=[ ]*(\d+)>/i
        @max_enchant = [[$1.to_i, 0].max, 99].min
      when /<item (\d+)[ ]*x[ ]*(\d+)[ ]+augument[ ]+(\d+)>/i
        @power_ups.push([$1.to_i, $2.to_i, $3.to_i])
      else
        #niente
      end
    }
  end

  #-----------------------------------------------------------------------------
  # restituisce il testo speciale (se presente)
  #-----------------------------------------------------------------------------
  def special_text
    @special_text
  end

  # restituisce il nome dell'equip opportunamente modificato
  def name
    return @name if enchant_state == 0
    sprintf("+%d %s", enchant_state, @name)
  end

  # Sempre false, un equip non può essere una pergamena
  def enchant_scroll?
    false
  end

  # Imposta il tipo di power up all'equip
  #     power_id: ID del power_up (configurato nelle impostazioni)
  def power_up=(power_id)
    remove_power_up
    return if power_id == 0
    add_power_up(power_id)
  end

  # Restituisce il nuovo ID
  def id
    __id
  end

  def __id
    return @id unless customized?
    sprintf("%d.%02d%02d", self.real_id, self.enchant_state, @power_up).to_f
  end

  # Aggiunge il power up
  def add_power_up(power_up_id)
    power_up = Power_Up.new(power_up_id, H87Enchant::WEAPON_TAGS[power_up_id])
    @special_text = power_up.tag
    effects = power_up.effects
    effects.each { |effect|
      add_weapon_effect(effect)
    }
    @power_description = power_up.description
    @power_up = power_up_id
  end

  # Rimosso, non va
  def remove_power_up
  end

  # Aggiunge l'effetto del power up
  #     effect: effetto come array. Es [:atk,10]
  # @param [Array] effect
  def add_weapon_effect(effect)
    @stat_per = @stat_per.clone
    @element_set = @element_set.clone
    @state_set = @state_set.clone
    @minus_state_set = @minus_state_set.clone
    @element_amplify = @element_amplify.clone
    @magic_states_plus = @magic_states_plus.clone
    @heal_states_plus = @heal_states_plus.clone
    value = effect[1]
    id = effect[2] ? effect[2] : 0
    case effect[0]
    when :mhp
      @stat_per[:maxhp] += value
    when :mmp
      @stat_per[:maxmp] += value
    when :atk
      @stat_per[:atk] += value
    when :def
      @stat_per[:def] += value
    when :spi
      @stat_per[:spi] += value
    when :agi
      @stat_per[:agi] += value
    when :cri
      @cri += value
    when :hit
      @hit += value
    when :eva
      @eva += value
    when :odd
      @odds += value
    when :ele
      @element_set.push(value)
    when :sta
      @state_set.push(value)
    when :stm
      @minus_state_set.push(value)
    when :esc
      @escape_bonus += value
    when :ela
      @element_amplify[id] = value
    when :hea
      @heal_amplify = value
    when :rec
      @recharge_value = value
    when :chb
      @charge_bonus = value
    when :atb
      @atb_base = value
    when :vmp
      @vampire_rate += value
    when :mpr
      @mp_rate += value / 100.0
    when :its
      @item_save += value / 100.0
    when :anm
      @animation_id = value
    when :mst
      @magic_states_plus.push(value)
    when :hst
      @heal_states_plus.push(value)
    when :inc
      @incentive += value
    when :snd
      @sin_durab += value
    when :snb
      @sin_bonus += value / 100.0
    when :dmb
      @dom_bonus += value / 100.0
    when :stl
      @__steal_prob_plus += value
    when :ico
      @icon_index = value
    when :lhm
      setmhplow(effect)
    when :lhp
      setmhplowp(effect)
    when :ira
      @anger_bonus += value
    when :iri
      @anger_init += value
    when :ref
      @physical_reflect += value
    when :pls
      @state_inflict_perc += value
    when :sid
      @state_inflict_durability += value
    when :mat
      @magic_attack += value
    when :amp
      @mp_on_attack += value
    when :ats
      @spirit_attack += value.to_f / 100
    when :ira
      @anger_bonus += value.to_i
    when :sir
      @anger_init += value.to_i
    when :kir
      @anger_kill += value.to_i
    when :pnt
      @qualities.push(:avoid_defense)
    when :duk
      @qualities.push(:parry)
    else
      # niente
    end
  end

  # Aggiunge l'effetto a HP/MP bassi
  #   effect: effetto [pv/pm,parametro]
  # @param [Array] effect
  def setmhplow(effect)
    param1 = effect[1]
    param2 = effect[2]
    stat = effect[3].to_f / 100.0
    return unless [:hp, :mp].include?(param1)
    return unless [:atk, :def, :spi, :agi, :cri, :hit, :eva, :odd].include?(param2)
    @hmplow[param1] = {} if @hmplow[param1].nil?
    @hmplow[param1][param2] = stat
  end

  # Aggiunge l'effetto a HP/MP bassi in percentuale
  #   effect: effetto [pv/pm,parametro]
  # @param [Array] effect
  def setmhplowp(effect)
    param1 = effect[1]
    param2 = effect[2]
    stat = effect[3].to_f / 100.0
    return unless [:hp, :mp].include?(param1)
    return unless [:atk, :def, :spi, :agi].include?(param2)
    @hmplowp[param1] = {} if @hmplowp[param1].nil?
    @hmplowp[param1][param2] = stat
  end

  # Restituisce l'ID reale dell'equip
  def real_id
    @id
  end

  # Incanta l'equip aumentando l'incantamento di 1
  def enchant
    @enchant_state += 1
  end

  # Restituisce tutti i power up possibili
  # @return [Array<Equip_Abilities>]
  def power_ups
    @power_ups.map {|pup| Equip_Abilities.new(pup[0], pup[1], pup[2])}
  end

  # restituisce il tipo di potenziamento
  def power_up_id
    @power_up
  end

  # Restituisce true se è personalizzato
  def customized?
    @power_up ||= 0
    enchant_state > 0 || @power_up > 0
  end

  # Imposta il valore di incantamento
  #     value: valore
  def enchant_state=(value)
    @enchant_state = [[value, 0].max, H87Enchant::MaxEnchant].min
  end

  # Restituisce lo stato di incantamento
  def enchant_state
    @enchant_state || 0
  end

  # Restituisce true se può essere incantato
  def enchantable?
    return false unless @enchantable
    return false if @enchant_state >= H87Enchant::MaxEnchant
    true
  end

  # Restituisce true se è possibile potenziare l'arma
  def power_up_possible?
    return false if @power_up != 0
    return false if @power_ups.empty?
    true
  end

  # Restituisce true se l'equip è modificato
  def powered?
    @power_up > 0
  end
end

class RPG_Weapons < Array
  # @return [RPG::Weapon]
  def [](*args)
    return super(*args) unless args[0].is_a?(Float)
    return super(*args) if args.size > 1
    H87Enchant.weapon_from_id(args[0])
  end
end

class RPG_Armors < Array
  # @return [RPG::Armor]
  def [](*args)
    return super(*args) unless args[0].is_a?(Float)
    return super(*args) if args.size > 1
    H87Enchant.armor_from_id(args[0])
  end
end

#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
# Caricamento delle proprietà delle abilità speciali
#==============================================================================
class Scene_Title < Scene_Base
  # Aggiunge il caricamento del database
  alias h87_ench_load_db load_database unless $@

  def load_database
    h87_ench_load_db
    set_enchant_items
    set_enchantable_weapons
    set_enchantable_armors
    $data_weapons = RPG_Weapons.new($data_weapons)
    $data_armors = RPG_Armors.new($data_armors)
  end

  # Inizializza gli oggetti che incantano le armi
  def set_enchant_items
    $data_items.compact.each { |i| i.setup_enchant_property }
  end

  # Inizializza le armi modificabili
  def set_enchantable_weapons
    $data_weapons.compact.each { |w| w.setup_enchant_property }
  end

  # Inizializza le armature modificabili
  def set_enchantable_armors
    $data_armors.compact.each { |a| a.setup_enchant_property }
  end
end

#==============================================================================
# ** RPG::Item
#------------------------------------------------------------------------------
#  Aggiunta del metodo per compatibilità e enchant
#==============================================================================
class RPG::Item
  attr_reader :enchant_tier #grado dell'arma
  attr_reader :secure_enchant #valore se l'incantamento è sicuro
  # Un oggetto non può essere incantabile
  def enchantable?
    false
  end

  # E neanche modificato
  def customized?
    false
  end

  # E neanche potenziato
  def power_up_possible?
    false
  end

  # Restituisce lo stesso ID
  def real_id
    @id
  end

  def equal?(other)
    return false unless other.is_a?(RPG::Item)
    @id == other.id
  end

  # Inizializza le pergamene
  def setup_enchant_property
    return if @enchant_propr_setted
    @enchant_propr_setted = true
    @enchant_tier = 0
    @secure_enchant = false
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
      when /<enchant tier:[ ]*(\d+)>/i
        @enchant_tier = $1.to_i
      when /<secure enchant>/i
        @secure_enchant = true
      else
        # niente
      end
    }
  end

  # Restituisce true se è un oggetto che incanta l'equip
  def enchant_scroll?
    @enchant_tier > 0
  end

  # non può essere potenziato un item...
  def powered?
    false
  end
end

#==============================================================================
# ** RPG::Weapon
#------------------------------------------------------------------------------
#  Aggiunta dell'incantamento per le armi
#==============================================================================
class RPG::Weapon
  include EquipEnchant
  # Restituisce il modificatore dell'attributo
  def mod(symbol)
    H87Enchant.get_w_mod(symbol)
  end

  # @return [RPG::Weapon]
  def original
    $data_weapons[@id]
  end

  # Restituisce l'attacco
  def atk
    @atk + (@atk.abs * mod(:atk) * enchant_state).to_i
  end

  # Restituisce la difesa
  def spi
    @spi + (@spi.abs * mod(:spi) * enchant_state).to_i
  end

  # Restituisce lo spirito
  def def
    @def + (@def.abs * mod(:def) * enchant_state).to_i
  end

  # Restituisce l'agilità
  def agi
    @agi + (@agi.abs * mod(:agi) * enchant_state).to_i
  end

  # Restituisce il prezzo
  def price
    pup_price = customized? ? (@price * H87Enchant::Power_Up_Price).to_i : 0
    @price + (@price * mod(:price) * enchant_state).to_i + pup_price
  end

  def equal?(other)
    return false unless other.is_a?(RPG::Weapon)
    __id == other.id
  end

  # Restituisce la descrizione dell'arma
  def description
    if powered?
      @description + "|\\c[14]" + @power_description
    else
      if power_up_possible?
        extra = '|\\c[12]Potenziamenti possibili: ' + power_ups.map { |x| x.name } * ', '
      else
        extra = ''
      end
      @description + extra
    end
  end

end #rpg_weapon

#==============================================================================
# ** RPG::Armor
#------------------------------------------------------------------------------
#  Aggiunta dell'incantamento per le armature
#==============================================================================
class RPG::Armor
  include EquipEnchant
  # Restituisce il modificatore dell'attributo
  def mod(symbol)
    H87Enchant.get_a_mod(symbol)
  end

  # @return [RPG::Armor]
  def original
    $data_armors[@id]
  end

  # Restituisce l'attacco
  def atk
    @atk + (@atk.abs * mod(:atk) * enchant_state).to_i
  end

  # Restituisce la difesa
  def spi
    @spi + (@spi.abs * mod(:spi) * enchant_state).to_i
  end

  # Restituisce lo spirito
  def def
    @def + (@def.abs * mod(:def) * enchant_state).to_i
  end

  # Restituisce l'agilità
  def agi
    @agi + (@agi.abs * mod(:agi) * enchant_state).to_i
  end

  # Restituisce il prezzo
  def price
    @price + (@price * mod(:price) * enchant_state).to_i
  end

  def equal?(other)
    return false unless other.is_a?(RPG::Armor)
    __id == other.id
  end

  # Restituisce false
  def enchantable?
    false
  end
end #rpg_armor

#===============================================================================
# ** Equip_Abilities
#-------------------------------------------------------------------------------
# restituisce l'abilità dell'equipaggiamento
#===============================================================================
class Equip_Abilities
  # variabili d'istanza pubbliche
  # @return [RPG::Item] item
  # @return [Integer] number
  # @return [Power_Up] power_up
  attr_reader :item
  attr_reader :number
  attr_reader :power_up
  # inizializzazione
  # @param [RPG::Item] item
  # @param [Integer] number
  # @param [Symbol] pui
  def initialize(item, number, pui)
    @item = $data_items[item]
    @number = number
    @power_up = Power_Up.new(pui, H87Enchant::WEAPON_TAGS[pui])
  end

  # soddisfa i requisiti per essere applicato sull'equip?
  # @param [RPG::Weapon] equip
  def requirement_met?(equip)
    return false if $game_party.item_number(@item) < @number
    return false if $game_party.gold < required_gold(equip)
    true
  end

  # restituisce l'oro richiesto per il potenziamento
  # @param [RPG::Weapon] equip
  def required_gold(equip)
    equip.price / 4
  end

  # restituisce il nome del potenziamento
  def name
    @power_up.tag
  end

  # restituisce l'ID icona del potenziamento
  def icon
    @power_up.icon
  end

  # restituisce l'ID del potenziamento
  def id
    @power_up.id
  end

  # restituisce la descrizione del potenziamento
  def description
    @power_up.description
  end
end

#===============================================================================
# ** Power_Up
#-------------------------------------------------------------------------------
# Classe che contiene gli effetti del potenziamento
#===============================================================================
class Power_Up
  attr_reader :id
  attr_reader :tag #etichetta
  attr_reader :effects #effetti abbinati
  attr_reader :description #descrizione da aggiungere all'equip
  attr_reader :icon #icona
  # Inizializzazione
  #     power_up: array con le informazioni
  # @param [Integer] id
  # @param [Array] power_up
  def initialize(id, power_up)
    @id = id
    begin
      @tag = power_up[0]
    rescue
      print id
      return
    end
    @effects = make_effects(power_up[1])
    @description = power_up[2]
    @icon = power_up[3].nil? ? 0 : power_up[3]
  end

  # Imposta gli effetti del power up
  # @param [String] effects_string
  def make_effects(effects_string)
    effects = []
    effects_string.split(/[ ]*,[ ]*/).each do |effect|
      case effect
      when /(\w+)[ ]+(\d+)[ ]+([+\-]?\d+)/i
        effects.push([$1.to_sym, $3.to_i, $2.to_i])
      when /(\w+)[ ]+([+\-]?\d+)/i
        effects.push([$1.to_sym, $2.to_i])
      when /lhm[ ](\w+)[ ]+(\w+)[ ]+([+\-]?\d+)/i
        effects.push([:lhm, $1.to_sym, $2.to_sym, $3.to_i])
      when /lhp[ ](\w+)[ ]+(\w+)[ ]+([+\-]?\d+)/i
        effects.push([:lhp, $1.to_sym, $2.to_sym, $3.to_i])
      else
        raise ArgumentError.new('Errore per stringa' + effects_string.to_s)
      end
    end
    effects
  end
end #weapon_powerup

#==============================================================================
# ** Scene_Enchant
#------------------------------------------------------------------------------
#  Schermata per l'incantamento degli equipaggiamenti
#==============================================================================
class Scene_Enchant < Scene_MenuBase
  # Inizio
  def start
    super
    create_main_viewport
    create_picture_viewport
    create_help_window
    create_enchant_list_window
    create_equip_list_window
    create_enchant_state_window
    create_graphic
  end

  # Creazione del viewport per le finestre
  def create_main_viewport
    @viewport1 = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport1.z = 1
  end

  # Creazione del viewport per gli effetti
  def create_picture_viewport
    @viewport2 = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport2.z = 99
  end

  # Creazione della finestra d'aiuto
  def create_help_window
    super
    @help_window.viewport = @viewport1
  end

  # Creazione della lista delle scroll
  def create_enchant_list_window
    x = 0; y = @help_window.height
    w = Graphics.width / 2
    @enchant_list = Window_EnchantList.new(x, y, w, $game_temp.item_selected)
    @enchant_list.help_window = @help_window
    @enchant_list.active = false
    @enchant_list.set_handler(:ok, method(:scroll_selected))
    @enchant_list.set_handler(:cancel, method(:scroll_unselected))
    @enchant_list.viewport = @viewport1
  end

  # Creazione della lista degli equipaggiamenti
  def create_equip_list_window
    x = @enchant_list.width; y = @enchant_list.y
    w = Graphics.width - @enchant_list.width; h = @enchant_list.height
    @equip_window = Window_EquipEnchantList.new(x, y, w, h)
    @equip_window.help_window = @help_window
    @equip_window.active = true
    @enchant_list.equip_window = @equip_window
    @equip_window.set_item(@enchant_list.item)
    @equip_window.index = 0
    @equip_window.set_handler(:ok, method(:equip_selected))
    @equip_window.set_handler(:cancel, method(:equip_unselected))
    @equip_window.viewport = @viewport1
  end

  # Creazione della finestra dello stato
  def create_enchant_state_window
    @enchant_window = Window_EnchantState.new(0, 0, Graphics.width)
    @enchant_window.y = Graphics.height - @enchant_window.height
    @enchant_window.equip_window = @equip_window
    @enchant_window.scroll_window = @enchant_list
    @enchant_window.viewport = @viewport1
    @enchant_window.state = 1
  end

  # Crea la grafica dell'incantamento
  def create_graphic
    y = @enchant_list.bottom_corner
    h = Graphics.height - y - @enchant_window.height
    @graphic = GraphicUnifier.new(0, y, Graphics.width, h)
    @graphic.viewport = @viewport2
    @enchant_window.graphic = @graphic
    @enchant_window.scroll = @enchant_list.item
  end

  # Ok su finestra delle scroll attiva
  def scroll_selected
    item = @enchant_list.item
    if $game_party.item_number(item) == 0
      Sound.play_buzzer
      return
    end
    Sound.play_decision
    @enchant_window.scroll = item
    @enchant_window.state = 1
    @enchant_list.active = false
    @equip_window.active = true
    @equip_window.index = 0
  end

  # Ok su finestra equip attiva
  def equip_selected
    item = @equip_window.item
    if @equip_window.item.nil?
      Sound.play_buzzer
      return
    end
    @enchant_window.item = item
    Sound.play_ok
    @equip_window.active = false
    @enchant_window.state = 2
  end

  # Back su finestra delle scroll attiva
  def scroll_unselected
    return_scene
  end

  # Back su finestra equip attiva
  def equip_unselected
    Sound.play_cancel
    @equip_window.active = false
    @equip_window.index = -1
    @enchant_list.active = true
    @enchant_window.item = nil
    @enchant_window.scroll = nil
    @enchant_window.state = 0
    @enchant_window.scroll = nil
  end

  # Fine
  def terminate
    super
    @viewport1.dispose
    @viewport2.dispose
  end
end

#==============================================================================
# ** Window_EquipEnchantList
#------------------------------------------------------------------------------
#  Finestra degli equipaggiamenti
#==============================================================================
class Window_EquipEnchantList < Window_Selectable
  # Inizializzazione
  def initialize(x, y, width, height)
    make_item_list
    super(x, y, width, height)
    refresh
    self.index
  end

  # ottiene la lista delle armi incantabili
  def make_item_list
    @data = equips_for_enchant
  end

  # Ottiene il numero di elementi
  # @return [Integer]
  def item_max
    @data ? @data.size : 0
  end

  # Imposta la pergamena selezionata
  #     enchant_item: oggetto
  # @param [RPG::Item] enchant_item
  def set_enchant_item(enchant_item)
    return if @enchant_item == enchant_item
    @enchant_item = enchant_item
    make_item_list
    create_contents
    refresh
  end

  # Ottiene gli oggetti che possono incantare le armi
  def equips_for_enchant
    return [] if @enchant_item.nil?
    $game_party.items.select { |item|
      item.enchantable? && item.tier == @enchant_item.enchant_tier
    }
  end

  # Disegna l'oggetto
  #     index: indice dell'oggetto
  def draw_item(index)
    rect = item_rect(index)
    item = @data[index]
    change_color(normal_color, enable?(item))
    draw_item_name(item, rect.x, rect.y, rect.width)
    text = sprintf('x%d', item_number(item))
    draw_text(rect.x + 24, rect.y, rect.width - 24, line_height, text, 2)
  end

  # determina se l'oggetto è abilitato
  # @param [RPG::Weapon] item
  def enable?(item)
    ; item and item_number(item) > 0
  end

  # determina se l'oggetto selezionato è abilitato
  def current_item_enabled?
    enable?(@data[@index])
  end

  # Ottiene l'oggetto
  # @return [RPG::Weapon]
  def item
    @data[self.index]
  end

  # Ottiene il numero degli oggetti posseduti
  def item_number(selected_item = item)
    $game_party.item_number(selected_item)
  end

  # Imposta la pergamena
  #     scroll: oggetto
  # @param [RPG::Item] scroll
  def set_item(scroll)
    return if @enchant_item == scroll
    @enchant_item = scroll
    deep_refresh
    refresh
  end

  # ricalcola gli oggetti
  def deep_refresh
    make_item_list
    create_contents
    refresh
  end

  # Aggiornamento dell'help
  def update_help
    @help_window.set_text(item == nil ? '' : item.description)
  end
end

#==============================================================================
# ** Window_EnchantList
#------------------------------------------------------------------------------
#  Finestra delle pergamene
#==============================================================================
class Window_EnchantList < Window_Selectable
  # Inizializzazione
  #     x: posizione X
  #     y: posizione Y
  #     width: larghezza
  #     height: altezza
  #     item_id: ID pre-selezionato dell'oggetto
  def initialize(x, y, width, item_id)
    @first_item = item_id
    make_item_list
    super(x, y, width, fitting_height(7))
    refresh
    set_first
  end

  # Creazione degli oggetti
  def make_item_list
    @data = enchant_items
  end

  # Ottiene il numero di elementi
  # @return [Integer]
  def item_max
    @data ? @data.size : 0
  end

  # Ottiene gli oggetti che possono incantare le armi
  def enchant_items
    $game_party.items.select { |item| item.enchant_scroll? }
  end

  # Imposta l'index iniziale con l'oggetto selezionato dalla schermata prec
  def set_first
    return 0 if @first_item.nil?
    first = 0
    (0..item_max - 1).each { |i|
      first = i if @data[i].id == @first_item
    }
    @index = first
  end

  # determina se l'oggetto è abilitato
  def enable?(item)
    ; item and item_number(item) > 0
  end

  # determina se l'oggetto corrente è abilitato
  def current_item_enabled?
    enable?(@data[@index])
  end

  # Disegna l'oggetto
  #     index: indice dell'oggetto
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    item = @data[index]
    enabled = enable?(item)
    #draw_icon(item.icon_index, rect.x, rect.y, enabled)
    #contents.font.color.alpha = enabled ? 255 : translucent_alpha
    draw_item_name(item, rect.x, rect.y, enabled, contents_width)
    #draw_text(rect.x+24, rect.y, rect.width-24, WLH, item.name)
    text = sprintf('x%d', item_number(item))
    draw_text(rect.x + 24, rect.y, rect.width - 24, line_height, text, 2)
  end

  # Ottiene l'oggetto
  # @return [RPG::Item]
  def item
    @data[self.index]
  end

  # Ottiene il numero degli oggetti posseduti
  def item_number(selected_item = item)
    $game_party.item_number(selected_item)
  end

  # Imposta la finestra degli equipaggiamenti
  def equip_window=(window)
    @equip_window = window
  end

  # Aggiorna la finestra degli equipaggiamenti
  def update_equip_window
    return if @equip_window.nil?
    @equip_window.set_item(item)
  end

  # Update Help Text
  def update_help
    @help_window.set_text(item == nil ? '' : item.description)
    update_equip_window
  end
end

#==============================================================================
# ** Window_EnchantState
#------------------------------------------------------------------------------
#  Finestra dello stato dell'incantamento
#==============================================================================
class Window_EnchantState < Window_Base
  # @attr[GraphicUnifier] graphic
  attr_accessor :graphic
  # Inizializzazione
  def initialize(x, y, w)
    super(x, y, w, fitting_height(3))
    @state = 0
    @graphic = nil
    refresh
  end

  # Refresh
  def refresh
    self.contents.clear
    draw_status_text
    draw_conversion_text if @state >= 4
  end

  # Disegna il testo dello stato
  def draw_status_text
    draw_text(0, 0, contents_width, line_height, status_text, 1)
  end

  # dosegma oò testp do conversione
  def draw_conversion_text
    old = @item
    new = @graphic.product
    w = contents_width / 2
    h = line_height
    draw_item_name(new, 0, h)
    draw_param(Vocab.atk, 0, h * 2, w - 20, h, old.atk, new.atk)
    draw_param(Vocab.def, w, h * 2, w - 20, h, old.def, new.def)
    draw_param(Vocab.spi, 0, h * 3, w - 20, h, old.spi, new.spi)
    draw_param(Vocab.agi, w, h * 3, w - 20, h, old.agi, new.agi)
  end

  # disegna il parametro
  # @param [String] param_name
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Integer] old_param
  # @param [Integer] new_param
  def draw_param(param_name, x, y, width, height, old_param, new_param)
    change_color(system_color)
    draw_text(x, y, width, height, param_name)
    change_color(normal_color)
    xx = x - 30 + width / 2; ww = width / 2
    draw_text(xx, y, ww, line_height, old_param)
    draw_text(xx, y, ww, line_height, '>', 1)
    case old_param <=> new_param
    when -1
      change_color(power_up_color)
    when 0
      change_color(normal_color)
    when 1
      change_color(power_down_color)
    else
      change_color(normal_color)
    end
    draw_text(xx, y, ww, line_height, new_param, 2)
  end

  # Restituisce il testo appropriato
  # @return [String]
  def status_text
    case @state
    when 0
      H87Enchant::ST1
    when 1
      H87Enchant::ST2
    when 2
      H87Enchant::STQ
    when 3
      H87Enchant::ST3
    when 4
      H87Enchant::ST4
    when 5
      H87Enchant::ST5
    else
      ; 'ERRORE 01'
    end
  end

  # Imposta il viewport della grafica d'incantamento
  # @param [Viewport] vw
  def viewport2=(vw)
    @graphic.viewport = vw
  end

  # Imposta uno stato diverso
  # @param [Symbol] new_state
  def state=(new_state)
    @state = new_state
    refresh
  end

  # Come il superiore
  def set_state(new_state)
    @state = new_state
    refresh
  end

  # Restituisce l'oggetto assegnato
  # @return [RPG::Item]
  def item
    @item
  end

  # Aggiornamento
  def update
    super
    @graphic.update
    update_decision
    update_enchanting
    update_finish
  end

  # Aggiornamento della scelta
  def update_decision
    return if @state != 2
    if Input.trigger?(:C)
      set_state(3)
      @graphic.start_enchanting
    elsif Input.trigger?(:B)
      Sound.play_cancel
      set_state(1)
      @equip_window.active = true
      @item = nil
    end
  end

  # Aggiornamento dell'incantamento
  def update_enchanting
    return if @state != 3
    if @graphic.state == 3
      result = @graphic.product
      $game_party.gain_item(result, 1)
      if result.enchant_state > 0
        set_state(4)
      else
        set_state(5)
      end
    end
  end

  # Aggiornamento della fine
  def update_finish
    return if @state < 4
    if Input.trigger?(:C) || Input.trigger?(:B)
      Sound.play_ok
      set_state(0)
      @scroll_window.refresh
      @scroll_window.active = true
      @equip_window.deep_refresh
      @equip_window.index = -1
      @graphic.reset
    end
  end

  # Restituisce la pergamena selezionata
  # @return [RPG::Item]
  def scroll
    @scroll
  end

  # Imposta una pergamena
  # @param [RPG::Item] new_scroll
  def scroll=(new_scroll)
    @scroll = new_scroll
    @graphic.scroll = new_scroll
    refresh
  end

  # Eliminazione
  def dispose
    super
    @graphic.dispose
  end

  # Imposta l'equipaggiamento
  # @param [RPG::Item] new_item
  def item=(new_item)
    @item = new_item
    @graphic.equip = new_item
    refresh
  end

  # Imposta la finestra equip
  # @param [Window_EquipEnchantList] window
  def equip_window=(window)
    @equip_window = window
  end

  # Imposta la finestra scroll
  def scroll_window=(window)
    @scroll_window = window
  end
end #window_enchant

#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
# faccio funzionare le scroll di incantamento anche dal menu Oggetti
#==============================================================================
class Scene_Item < Scene_Base
  alias enchant_use_item_nontarget use_item_nontarget unless $@
  # Aggiunge l'uso dell'oggetto pergamena
  def use_item_nontarget
    if @item.enchant_scroll?
      process_enchant_scene
    else
      enchant_use_item_nontarget
    end
  end

  # Porta alla schermata d'incantamento
  def process_enchant_scene
    Sound.play_ok
    $game_temp.item_selected = @item.id
    SceneManager.call(Scene_Enchant)
  end
end #scene_item

#==============================================================================
# ** Game_Temp
#==============================================================================
class Game_Temp
  # Restituisce l'ID dell'oggetto selezionato precedentemente (e lo elimina)
  def item_selected
    item = @item_selected
    @item_selected = nil
    item
  end

  # Imposta l'ID dell'oggetto selezionato
  def item_selected=(value)
    @item_selected = value
  end
end #game_temp

#==============================================================================
# ** GraphicUnifier
#------------------------------------------------------------------------------
#  Oggetto che genera le animazioni
#==============================================================================
class GraphicUnifier
  # variabili d'istanza pubblici
  # @return [RPG::Item] scroll
  # @return [RPG::Weapon] equip
  # @return [RPG::Weapon] product
  attr_reader :x
  attr_reader :y
  attr_reader :scroll
  attr_reader :equip
  attr_reader :product
  # Inizializzazione
  # noinspection RubyInstanceVariableNamingConvention
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  def initialize(x, y, width, height)
    @state = 0
    @x = x
    @y = 0
    @spr_y = y
    @spr_h = height
    @width = width
    @height = Graphics.width
    create_background_sprite
    create_equip_icon
    create_scroll_icon
    create_product_icon
    reset
  end

  # crea lo sfondo del rettangolo
  def create_background_sprite
    @background = Sprite.new
    @background.bitmap = background_bitmap
    @background.opacity = 128
    @background.y = @spr_y
    @background.x = @x
  end

  # crea l'icona d'equipaggiamento
  def create_equip_icon
    @equip_icon = Sprite.new
    @equip_icon.y = cent_y
  end

  # crea l'icona della pergamena
  def create_scroll_icon
    @scroll_icon = Sprite.new
    @scroll_icon.y = cent_y
  end

  # crea l'icona del prodotto
  def create_product_icon
    @product_icon = Sprite.new
    @product_icon.x = cent_x
    @product_icon.y = cent_y
  end

  # aggiorna la posizione
  def update_position
    @scroll_icon.y = cent_y
    @equip_icon.y = cent_y
    @background.y = @spr_y
    @background.height = @spr_h
  end

  # crea la bitmap dello sfondo
  def background_bitmap
    bitmap = Bitmap.new(@width, @spr_h)
    bitmap.fill_rect(0, 0, bitmap.width, bitmap.height, Color::BLACK)
    bitmap
  end

  # Ottiene lo stato
  def state
    @state
  end

  # Imposta la pergamena
  def scroll=(item)
    change_icon(@scroll_icon, item)
    @scroll = item
  end

  # Imposta l'equipaggiamento
  def equip=(item)
    change_icon(@equip_icon, item)
    @equip = item
  end

  # Cambia la bitmap dello sprite
  #     icon: sprite
  #     item: oggetto da cui prelevare l'icona o nome immagine
  # @param [Integer] icon
  # @param [RPG::Item] item
  def change_icon(icon, item)
    if item.nil?
      icon.bitmap = nil
    else
      icon.bitmap = item.is_a?(String) ? Cache.picture(item) : get_icon(item)
      icon.zoom_x = 0
      icon.zoom_y = 0
      icon.ox = icon.width / 2
      icon.oy = icon.height / 2
    end
  end

  # Restituisce la coordinata X del centro
  def cent_x
    self.x + (@width / 2)
  end

  # Restituisce la coordinata Y del centro
  def cent_y
    @spr_y + (@spr_h / 2)
  end

  # Aggiornamento
  def update
    case state
    when 0
      update_classic
    when 1
      update_nearing
    when 2
      update_fusion
    when 3
      update_finish
    else
      # non fa niente
    end
    @equip_icon.update
    @scroll_icon.update
  end

  # Eliminazione
  def dispose
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Sprite) rescue next
    end
  end

  # Imposta il viewport degli sprite
  def viewport=(viewport)
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.viewport = viewport if ivar.is_a?(Sprite) rescue next
    end
  end

  # Aggiornamento quando non si incanta
  def update_classic
    @equip_icon.zoom_x += 0.2 if @equip_icon.zoom_x < 2.0
    @equip_icon.zoom_y += 0.2 if @equip_icon.zoom_y < 2.0
    @scroll_icon.zoom_x += 0.2 if @scroll_icon.zoom_x < 2.0
    @scroll_icon.zoom_y += 0.2 if @scroll_icon.zoom_y < 2.0
  end

  # Aggiornamento durante l'incantamento
  def update_nearing
    if @scroll_icon.zoom_x > 0
      if @scroll_icon.x < cent_x
        @scroll_icon.x += 2
        @equip_icon.x -= 2
      else
        @scroll_icon.zoom_x -= 0.5
        @scroll_icon.zoom_y -= 0.5
        @equip_icon.zoom_x -= 0.5
        @equip_icon.zoom_y -= 0.5
      end
    else
      start_fusion
    end
  end

  # Aggiornamento durante la fusione (non ha niente)
  def update_fusion
  end

  # Aggiornamento della fine
  def update_finish
    if @product_icon.zoom_x < 2.0
      @product_icon.zoom_x += 0.2
      @product_icon.zoom_y += 0.2
    end
    if @product.enchant_state > 0
      if @scroll_icon.zoom_x > 2
        @scroll_icon.zoom_x -= 0.1
        @scroll_icon.zoom_y -= 0.1
      end
      @scroll_icon.opacity += 10
      @equip_icon.opacity -= 10
      @equip_icon.zoom_x += 2
      @equip_icon.zoom_y += 2
      @scroll_icon.angle += 2
    end
    @product_icon.update
  end

  # Comincia la fusione
  def start_fusion
    @state = 2
    @product = H87Enchant.try_enchant(@scroll, @equip)
    @product_icon.zoom_x = 0; @product_icon.zoom_y = 0
    change_icon(@product_icon, @product)
    if @product.enchant_state > 0
      RPG::SE.new('Collapse3').play
      RPG::SE.new('Applause').play if @product.enchant_state > 5
      change_icon(@scroll_icon, 'SplendoreOk')
      @scroll_icon.opacity = 0
      @scroll_icon.zoom_x = 5
      @scroll_icon.zoom_y = 5
      change_icon(@equip_icon, 'CerchioMappa')
      @equip_icon.blend_type = 1
      @product_icon.flash(Color.new(255, 255, 255), 60)
    else
      RPG::SE.new("Crash").play
      @product_icon.flash(Color.new(255, 0, 0), 60)
      @scroll_icon.stop_sparks
      @equip_icon.stop_sparks
    end
    @state = 3
  end

  # Reimposta le immagini
  def reset
    @scroll_icon.stop_sparks
    @equip_icon.stop_sparks
    @scroll_icon.z = 99
    @equip_icon.z = 99
    @product_icon.z = 99
    @equip_icon.x = cent_x + 150
    @scroll_icon.x = cent_x - 150
    @scroll_icon.bitmap = nil
    @equip_icon.bitmap = nil
    @equip_icon.opacity = 255
    @product_icon.bitmap = nil
    @equip_icon.blend_type = 0
    @scroll_icon.angle = 0
    @state = 0
  end

  # Ottiene l'icona dell'arma e la restituisce come bitmap
  def get_icon(item)
    icon_index = item.icon_index
    icon = Bitmap.new(24, 24)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    icon.blt(x, y, bitmap, rect)
    icon
  end

  # Comincia l'incantamento
  def start_enchanting
    @scroll_icon.zoom_x = 2.0
    @scroll_icon.zoom_y = 2.0
    @equip_icon.zoom_x = 2.0
    @equip_icon.zoom_y = 2.0
    @scroll_icon.spark_active = true
    @equip_icon.spark_active = true
    return if @scroll.nil? || @equip.nil?
    RPG::SE.new('Magic2', 100, 50).play
    @state = 1
  end

  # riduce l'area, per debug
  def reduce
    @y += 1; @height -= 2
    update_position
  end
end #graphic

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  Modifica del metodo equippable?
#==============================================================================
class Game_Actor < Game_Battler
  # Alias del metodo equippable?
  alias h87_ench_equippable equippable? unless $@

  def equippable?(item)
    case item
    when RPG::Weapon
      return h87_ench_equippable($data_weapons[item.real_id])
    when RPG::Armor
      return h87_ench_equippable($data_armors[item.real_id])
    else
      return h87_ench_equippable(item)
    end
  end
end

class Game_Interpreter

  # chiama la schermata di incantamento armi
  def call_enchant
    $game_temp.next_scene = 'enchant'
  end
end

class Scene_Map < Scene_Base
  alias h87_enchant_update_scene_change update_scene_change unless $@

  def update_scene_change
    return if $game_player.moving?
    return call_enchant if $game_temp.next_scene == 'enchant'
    h87_enchant_update_scene_change
  end

  def call_enchant
    SceneManager.call(Scene_Enchant)
  end
end