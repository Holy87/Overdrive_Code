# Esper System di Holy87
# Difficoltà utente: ★★★★
# Versione 1.0
#===============================================================================
# Gestisce le evocazioni di Overdrive.
# ATTENZIONE: Nel caso tu voglia usare questo script nel tuo gioco, sappi che
# hai bisogno dello script KGC Large Party.
# Istruzioni:
# Crea un eroe nel database, dai i suoi i parametri come un normale eroe. Se
# vuoi, mettigli "battaglia automatica" (consigliato).
# Imposta quindi, in Esper_List nello script, l'eroe creato in questo modo:
# ID_Eroe => [Variabile_Usata, attacco, t_ricarica, turni]
# ID_Eroe è l'ID dell'eroe che sarà esper
# Variabile_Usata è la variabile che tiene conto di quante battaglie dovrà
# aspettare il giocatore prima che sia di nuovo utilizzabile.
# attacca indica se l'esper può attaccare oppure usa solo le abilità. Serve
# solo se l'esper combatte con "Battaglia Automatica".
# turni è il numero di turni in cui l'esper sarà in campo, dopodichè scomparirà.
# Dopo creato l'esper, per creare il potere d'invocazione, hai bisogno di
# inserire l'ID della skill in Invocazioni, indicando il relativo ID dell'Esper.
# Questa funzione serve per fare in modo che il potere non possa essere utilizzato
# se l'esper non è ancora carico, o se non è possibile evocare esper.
# Impostando il potere, devi fare in modo che esso chiami un evento comune, e
# all'interno di quest'evento devi mettere un call script inserendo:
# Espers.evoca(id) dove id è l'ID dell'esper.
module Espers
  #===============================================================================
  # CONFIGURAZIONE
  #===============================================================================

  # Skill evocazioni
  # Questa lista associa l'ID della skill d'invocazione con l'ID dell'eroe
  # evocato. Serve per disattivare il potere quando l'esper deve ricaricarsi.
  Evocazioni = {484 => 18,
                480 => 17,#Nymeria
                481 => 21,#Thartaros
                482 => 20,#Kon
                483 => 19,#Miyu
                485 => 22,
                486 => 23,
                487 => 24,
                488 => 25,
                139 => 26, #spirito di luce
                489 => 27,#juggernaut
                359 => 28, #golem
                360 => 29, #homunculus

  }
  # Configurazioni
  Switch_Esp_On = 420 #switch che se attivato, disattiva le evocazioni.
  Variabile_Esper = 105 #Variabile usata per tenere in conto l'esper usato.

  # Lista e configurazione evocazioni
                #ID   var attacca? ricarica turni solo 1 a batt
  Esper_List = {18 => [106, true,    9,      14,   true],#Cerbero
                17 => [109, true,    7,      15,   true],#Nymeria 15
                19 => [107,false,   17,      10,   true],#Miyu
                20 => [108,false,   11,      15,   true],#Kon
                21 => [110, true,   12,      18,   true],#Thartaros
                22 => [111, true,   12,      12,   true],#Volcan
                23 => [112, true,    9,      19,   true],#Rakurai
                24 => [113, true,   10,      14,   true],#Ogard
                25 => [114, false,  10,      14,   true],#Gamakichi
                26 => [1  , true,   0,       10,  false],#spirito di luce
                27 => [115, true,   20,      16,   true],#juggernaut
                28 => [1  , true,    0,      10,  false],#golem
                29 => [1  , true,    0,      10,  false],#homunculus
  }

  #Il combattimento automatico di norma valuta quale delle tecniche può
  #causare più danno-cura, con un margine di valore casuale. Purtroppo però,
  #in questo modo il personaggio non userà mai potenziamenti e depotenziamenti.
  #Imposta l'ID del potere e il suo punteggio, per cambiare la priorità di un
  #potere. Punteggio più alto = più probabilità che il personaggio scelga quell'
  #abilità.
  Powers = {451 => 200,
            452 => 199,
            453 => 200,
            454 => 200,
            459 => 200,
            460 => 200,
            461 => 200,
            31  => 500,#
            714 => 300,
            552 => 300,
            #2   => 200,#sfuriata
            #95  => 150,#attacco improvviso
            #311=>1000,#è una skill di reinard, ma lo forzo ad usare la sinergia.
  }

  ESPER_UPS_INCREMENTS = {
      :mhp => 10,
      :mmp => 5,
      :atk => 1,
      :def => 1,
      :spi => 1,
      :agi => 1
  }

  ESPER_UPS_INITIAL_COST = 10 # PA
  ESPER_UPS_COST_INCREASE = 20 # %

  #===============================================================================
  # FINE CONFIGURAZIONE
  #===============================================================================
  def self.incrementa
    Esper_List.each_key do |id|
      esper = $game_actors[id]
      next if esper.nil?
      next unless esper.domination?
      esper.battle_add_recharge
    end
  end
end

#===============================================================================
# ** modulo Vocab (per le scritte)
#===============================================================================
module Vocab
  def self.rec_dom;"In ricarica... (%d/%d)";end
  def self.ready_dom;"Pronto";end
  def self.dominations;"Dominazioni";end
  def self.bon_dom;"Bonus";end
  def self.boost;"Turbo";end
  def self.milky;"Oggetti";end
  def self.elements;"Elementi";end
  def self.element_desc;"Visualizza le resistenze elementali.";end
  def self.new_boost;"%s ha sbloccato %s!";end
  def self.skill_desc;"Vedi e attiva/disattiva le abilità della dominazione.";end
  def self.milky_desc;"Usa le scorte di latte per ricaricare le dominazioni.";end
  def self.affinity_desc;"I parametri dell'evocatore daranno un bonus alla Dominazione|in proporzione alla loro affinità.";end
  def self.in_use_by;"In uso da";end
  def self.esper_duration;"Durata:";end
  def self.no_user;"nessuno";end
  def self.act_bonus;"Bonus";end
  def self.affinity;"Affinità";end
  def self.activate_skill;'Attiva/Disattiva abilità';end
  def self.bonus_desc;"Visualizza i potenziamenti attivati dal tempio delle|Dominazioni.";end
  def self.summon_number;"Evocato:";end
  def self.summon_times;"%d volte.";end
  def self.boost_desc;"Attivando i Turbo l'evocazione sarà più potente, ma resterà|per minor tempo in campo.";end
  def self.domination_ready;"%s è pronto a combattere.";end
  def self.power_up_incr;"Incrementa il parametro %s di %d punti";end
  def self.esper_ap_help;"PA di %s"; end
  def self.esper_ap_no_m;"Nessun proprietario"; end
end

#===============================================================================
# ** CONFIGURAZIONE DELLE DOMINAZIONI
#===============================================================================
module EsperConfig
  module_function #può essere integrato
  # Configurazione
  DomiActSw = 590 #switch che attiva il menu dominazioni
  BarL = 200 #lunghezzza della barra
  BarH = 3 #altezza della barra
  DURATION_LEVEL_BONUS = 0.15 #bonus di durata dominazione per ogni livello
  BOOST_APPRAISED_SE = 'PopUp' # suono del popp quando una turbo è appresa
  AFFINITY_ICON = 395

  SW_Dom = {
      #ID    SWITCH
      17 => 106,#Nymeria
      18 => 326,#Fuffi
      19 => 109,
      20 => 433,
      21 => 430,
      22 => 425,
      23 => 214,
      24 => 432,
      25 => 436,
      27 => 583, #juggernaut
  }

  # Descrizione delle evocazioni
  Ds_Dom = {
      17 => "Un gatto delle nevi molto bravo nell'uso delle magie del ghiaccio.",
      18 => "Un mastino infernale utile nel corpo a corpo.",
      19 => "Una fata che sosterrà i suoi amici con le sue magie curative.",
      20 => "Leoncino di peluche che potenzierà il gruppo con i suoi canti.",
      21 => "Una tartaruga corazzata che proteggerà gli alleati con il suo guscio.",
      22 => "Toro fiammeggiante e furioso che lancia attacchi devastanti.",
      23 => "Velocissimo con i suoi attacchi e magie del fulmine.",
      24 => "Lancia magie oscure e assorbe la vita dei nemici.",
      25 => "Indebolisce i nemici con i suoi numerosi stati alterati.",
      27 => "Un carro robotizzato che bersaglia i nemici con colpi a ripetizione.",
  }

  # Abilità e potenziamenti delle dominazioni
  BonusStates = {#abilità passive delle evocazioni
                 #ID    Descrizione
                 39 => "Max PV +20%",
                 40 => "Max PM +20%",
                 43 => "Attacco +20%",
                 44 => "Difesa +20%",
                 45 => "Spirito +20%",
                 46 => "Velocità +20%",
                 61 => "Odio +10%",
                 71 => "Acutezza +20%",
                 73 => "Evasione +4%",
                 74 => "Critici +4%",
                 91 => "Sinergia +15%",
                 239=> "Durata +20%",
  }

  # Oggetti magnetite associati alla dominazione
  Magnetite = {
      #ID magnetite con ID dominazione
      17 => 224,
      18 => 225,
      19 => 226,
      20 => 227,
      21 => 228,
      22 => 229,
      23 => 230,
      24 => 231,
      25 => 232,
      27 => 233
  }

  # Affinità della dominazione sull'eroe
  ACTOR_AFFINITY = {
    17 => {2 => 5, 6 => 3, 14 => 1},
    18 => {9 => 5, 15 => 3, 7 => 1},
    19 => {14 => 5, 6 => 3, 1 => 1},
    20 => {10 => 5, 7 => 3, 5 => 1},
    21 => {5 => 5, 8 => 3, 12 => 1},
    22 => {1 => 5, 2 => 3, 13 => 1},
    23 => {3 => 5, 12 => 3, 9 => 1},
    24 => {7 => 5, 10 => 3, 6 => 1},
    25 => {8 => 5, 14 => 3, 7 => 1},
    27 => {11 => 5, 1 => 3, 3 => 1},
  }

  AFFINITY_RATE = 0.06

  # Turbo sbloccabili
  Boosts = {
      #Nymeria: Antispirito, dif. freddo, att. freddo, spir+, autoenergia
      17 => {253 => 6, 275 => 12, 261 => 20, 245 => 35, 252 => 50},
      #Fuffi: Dif. terra, Cri+4, At. Terra, contrattacco
      18 => {278 => 6, 248 => 12, 264 => 23, 256 => 40},
      #miyu: odio-, fort, rigenera, cura
      19 => {250 => 7, 271 => 14, 251 => 25, 257=> 50},
      #kon: eva+, pm, mira, costo-
      20 => {247 => 6, 242 => 14, 268 => 28, 258 => 43},
      #thartaros: acqua++, odio+, acqua+, barriera
      21 => { 263 => 6, 249 => 14, 277 => 28, 254 => 43},
      #volc: dif. fuoco, forza, att. fuoco, grinta
      22 => {274 => 6, 243 => 12, 260 => 24, 266 => 40},
      #rakurai: dif t, vel, at t, ricarica rapida
      23 => {276 => 6,  246 => 10, 262 => 22, 267 => 40},
      #ogard: dif o, antigrav, pv+, divoratore
      24 => {281 => 10, 259 => 20, 241 => 35, 255 => 50},
      #bufos = dif+, salvezza, dur. sin
      25 => {244=> 5, 272 => 10, 269 => 20},
      #juggernaut
      27 => {},}

  # Mostra il numero predefinito di battaglie da ricaricare
  def time_recharge(domination_id)
    Espers::Esper_List[domination_id][2]
  end
  # Mostra quante battaglie si è ricaricato
  def recharged(domid)
    time_recharge(domid) + $game_variables[Espers::Esper_List[domid][0]]
  end
  # Restituisce true se la dominazione è stata sbloccata
  def domination_unlocked?(domination_id)
    $game_party.domination_unlocked?(domination_id)
    #$game_switches[SW_Dom[domination_id]]
  end
  # Restituisce true se il menu è stato sbloccato
  def self.menu_unlocked?
    $game_switches[DomiActSw]
  end

  # ottiene i valori di affinità con l'eroe a seconda della dominazione
  # @param [Integer] esper_id
  # @return [Array<Esper_Affinity>]
  def self.get_actor_affinities(esper_id)
    affinities_h = EsperConfig::ACTOR_AFFINITY[esper_id]
    return [] if affinities_h.nil?
    affinities = []
    affinities_h.each_pair {|actor_id, affinity| affinities.push(Esper_Affinity.new(actor_id, affinity)) }
    affinities
  end
end #esperconfig

#===============================================================================
# ** RPG::Item
#===============================================================================
class RPG::Item
  # Potenza del latte
  def milk_power
    @milk_power ||= get_milk_power
  end
  # inizializza la potenza del latte
  def get_milk_power
    self.note.split(/[\r\n]+/).each { |line|
      if line =~ /<milky[ ]+(\d+)>/
        return [[$1.to_i, 100].min, 0].max
      end
    }
    0
  end
  # è del latte?
  def is_milk?; milk_power > 0; end
end

#===============================================================================
# ** classe RPG::State
#===============================================================================
class RPG::State
  # restituisce il malus del turbo
  def boost_malus
    if @boost_malus.nil?
      self.note.split(/[\r\n]+/).each { |line|
        if line =~ /<boost malus:[ ]*(\d+)>/i
          @boost_malus = ($1.to_f/100)
        end
      }
    end
    @boost_malus
  end
  # restituisce il testo di descrizione del turbo
  def description; message1; end
end #RPG::State

class Window_MenuCommand < Window_Command
  alias :no_domination_commands :add_original_commands

  def add_original_commands
    no_domination_commands
    add_command(Vocab::dominations,   :dominations,   $game_system.domination_unlocked)
  end
end

#===============================================================================
# ** classe Game_System
#===============================================================================
class Game_System
  # determina se il menu Dominazioni nel menu è sbloccato
  def domination_unlocked; EsperConfig.menu_unlocked?; end
end

#===============================================================================
# ** classe Game_Temp
#===============================================================================
class Game_Temp
  # imposta se l'evocazione è attiva
  def esper_active=(new_value)
    @esper_active = new_value
  end

  # restituisce true se l'evocazione è in battaglia
  def esper_active
    @esper_active = false if @esper_active.nil?
    @esper_active
  end

  # restituisce true se è già stata usata un'evocazione in battaglia
  def esper_used
    @esper_used = false if @esper_used.nil?
    @esper_used
  end

  # imposta l'uso della dominazione
  def esper_used=(value)
    @esper_used = value
  end

  # restituisce i turni rimanenti all'evocazione
  def domination_energy
    @domination_energy = 0 if @domination_energy.nil?
    @domination_energy
  end

  # imposta i turni rimanenti all'evocazione
  def domination_energy=(value)
    @domination_energy = 0 if @domination_energy.nil?
    @domination_energy=value
  end

  # restituisce il numero di turni a disposizione della dominazione
  def domination_max_turns
    @domination_max_turns
  end

  # imposta i turni massimi della dominazione
  def domination_max_turns=(value)
    @domination_max_turns = value
  end

  # restituisce il rapporto di turni della dominazione
  def domination_turns_rate
    @domination_energy.to_f / @domination_max_turns.to_f
  end
end

#===============================================================================
# ** classe Game_Battler
#===============================================================================
class Game_Battler
  alias uso_skill skill_can_use?
  alias add_boost_states states unless $@

  # restituisce gli status attuali + bonus attivati
  def states
    all_states = add_boost_states
    all_states |= self.boost_states if self.actor?
    all_states
  end

  # ridefinisce se la skill può essere usata
  def skill_can_use?(skill)
    return false if esper_type(skill)
    uso_skill(skill)
  end

  # definisce il tipo di skill della dominazione
  def esper_type(skill)
    esper = $game_party.actual_esper
    return false if esper.nil?
    return false if skill.esper == 0
    return true if $game_temp.esper_active
    actor = $game_actors[skill.esper]
    return false unless actor.domination?
    return true unless actor.recharged?
    return true if $game_temp.esper_used
    false
  end
end

#===============================================================================
# ** classe Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  attr_reader :maxhp_plus
  attr_reader :maxmp_plus
  attr_reader :atk_plus
  attr_reader :def_plus
  attr_reader :agi_plus
  attr_reader :spi_plus

  include Espers
  alias :esp_ap :ap unless $@

  # determina se è un'evocazione
  def is_esper?; Esper_List.has_key?(@actor_id); end

  # determina se può attaccare
  def can_attack?
    return false unless is_esper?
    Esper_List[@actor_id][1]
  end

  # aggiunge il messaggio di nuovo turbo sbloccato per mostrarlo su mappa
  def push_message(stateid)
    state = $data_states[stateid]
    text = sprintf(Vocab.new_boost, self.name, state.name)
    tone = Tone.new(200,200,0,0)
    $game_map.stack_popup([state.icon_index, text], tone, EsperConfig::BOOST_APPRAISED_SE)
  end

  # restituisce i turbo sbloccati
  # @return [Array<RPG::State>]
  def dom_boosts
    $game_party.unlocked_boosts
  end

  # aggiunge un turbo sbloccato
  def add_boost(stateid)
    unless $game_party.unlocked_boosts.include?(stateid)
      $game_party.add_boost(stateid)
      push_message(stateid)
    end
  end

  # rimuove un turbo (al momento è inutile, vuoto)
  def remove_boost(stateid)
    self.dom_boosts.delete(stateid)
  end

  # restituisce true se... vabbè, lo sai.
  def has_boost?(stateid); $game_party.unlocked_boosts.include?(stateid); end

  # tempo di ricarica massimo della dominazione
  def recharge_max; @recharge_max ||= default_recharge; end

  # Tempo di ricarica predefinito
  def default_recharge; EsperConfig.time_recharge(self.id); end

  # imposta il tempo di ricarica
  def set_recharge_max(value, dead = false)
    @recharge_max = value
    @recharge_max *= 2 if dead && !save_domination?
    @recharge_max = (@recharge_max * (1 - fast_ready_bonus)).to_i
    @charge_state = 0
  end

  # restituisce lo stato di ricarica
  def recharge_status; @charge_state ||= recharge_max; end

  # restituisce lo stato di ricarica
  def charge_state; @charge_state ||= recharge_max; end

  # Imposta lo stato della ricarica
  def charge_state=(value)
    @charge_state ||= recharge_max
    @charge_state = value
  end

  # Restituisce la percentuale di ricarica (valore da 0 a 1)
  def charge_state_rate
    recharge_status.to_f / recharge_max.to_f
  end

  # Carica la dominazione di una battaglia
  def battle_add_recharge
    return if recharged?
    @charge_state = recharge_max if @charge_state.nil?
    @charge_state += 1
    if recharged?
      tone = Tone.from_color(Color::GREENYELLOW)
      $game_map.stack_popup([sprintf(Vocab.ready_dom, self.name)], tone)
    end
  end

  # restituisce true se la dominazione è pronta
  def recharged?; recharge_status >= recharge_max; end

  # rende subito disponibile la dominazione
  def recharge_domination(value = recharge_max)
    $game_variables[Espers::Esper_List[self.id][0]] = 0
    @charge_state += value
  end

  # ricarica la dominazione in percentuale
  def apply_domination_recharge(perc)
    value = recharge_max * perc / 100
    recharge_domination(value)
  end

  # restituisce i turbo attivati sulla dominazione
  def activated_boosts; @act_boosts ||= []; end

  # disattiva il turbo sulla dominazione
  def deactivate_boost(stateid)
    @act_boosts = [] if @act_boosts.nil?
    @act_boosts.delete(stateid)
  end

  # attiva il turbo alla dominazione
  def activate_boost(stateid)
    @act_boosts = [] if @act_boosts.nil?
    @act_boosts.push(stateid) unless @act_boosts.include?(stateid)
  end

  # restituisce true se la dominazione ha Grinta
  def rech_bonus?; boost_activated?(266); end

  # restituisce true se il turbo stateid è attivato sulla dominazione
  def boost_activated?(stateid); activated_boosts.include?(stateid); end# restituisce il malus causato dai turbo attivati
  def domination_duration_malus
    duration_malus = 1.0
    activated_boosts.each do |boostid|
      boost = $data_states[boostid]
      duration_malus += boost.boost_malus
    end
    duration_malus
  end# restituisce il proprietario dell'evocazione
  # @return [Game_Actor, nil]
  def esper_master
    return unless domination?
    $game_party.members.each {|member|
      next if member.nil?
      if member.equips.include?($data_armors[EsperConfig::Magnetite[self.id]])
        return member
      end
    }
    nil
  end

  # Se è un'evocazione, restituisce i PA dell'evocatore assegnato.
  def ap(cl_id = 0)
    if is_esper?
      esper_master ? esper_master.ap(cl_id) : 0
    else
      esp_ap=cl_id
    end
  end

  # restituisce il numero di volte che è stato evocato
  def summon_times; @summoned ||= 0; end

  # imposta il numero di volte che è stato evocato
  def summon_times=(value)
    @summoned = 0 if @summoned.nil?
    @summoned = value
    check_boosts
  end

  # aggiorna il livello dominazione con il party
  def adjust_level
    return unless domination?
    return if self.level >= $game_party.max_level
    change_level($game_party.max_level, false)
    requery_skills
  end

  # restituisce tutti i turbo che può apprendere la dominazione
  def boosts_to_learn; EsperConfig::Boosts[self.id]; end

  # imposta i turbo che ha appreso la dominazione
  def check_boosts
    return if boosts_to_learn == nil
    self.boosts_to_learn.each_key do |boost|
      if summon_times >= boosts_to_learn[boost] and !dom_boosts.include?(boost)
        add_boost(boost)
      end
    end
  end

  # restituisce i bonus set attivati
  def boost_states
    bonus_states = []
    activated_boosts.each {|state_id|
      state = $data_states[state_id]
      next if state == nil
      bonus_states.push(state)
    }
    bonus_states
  end

  # Ricalcola le skill apprese
  def requery_skills
    self.class.learnings.each {|learning|
      learn_skill(learning.skill_id) if learning.level <= @level
    }
  end

  # Restituisce i turni massimi della Dominazione
  def base_duration; Espers::Esper_List[self.id][3] if domination?; end

  # Restituisce i turni massimi della Dominazione calcolando il malus
  def duration
    begin
      return ((base_duration+duration_bonus)/domination_duration_malus).to_i
    rescue
      print $!.backtrace
    end
  end

  # Restituisce il bonus di durata per il livello della dominazione
  def duration_bonus; self.level * EsperConfig::DURATION_LEVEL_BONUS; end

  # Restituisce true se è una dominazione
  def domination?
    return false if Espers::Esper_List[self.id].nil?
    Espers::Esper_List[self.id][4]
  end

  # abilita o disabilita la skill
  # noinspection RubyResolve
  # @param [RPG::Skill] skill
  def toggle_skill(skill)
    return unless skills.include?(skill)
    if skill_hidden?(skill.id)
      remove_hidden_skill(skill.id)
    else
      add_hidden_skill(skill.id)
    end
  end

  # @param [Fixnum] summoner_id
  # @return [Fixnum]
  def summoner_affinity(summoner_id = esper_master.id)
    return 0 if summoner_id.nil?
    return 0 unless is_esper?
    Espers::ACTOR_AFFINITY[self.id][summoner_id] || 0
  end

  # abilita o disabilita il boost
  # @param [RPG::State] boost
  def toggle_boost(boost)
    if boost_activated?(boost.id)
      deactivate_boost(boost.id)
    else
      activate_boost(boost.id)
    end
  end

  # restituisce l'hash dei potenziamenti
  # @return [Hash]
  def esper_ups
    check_init_esper_ups
    @esper_ups
  end

  # potenzia il parametro
  # @param [Symbol] sym
  # @return [Hahs]
  def esper_up_param(sym)
    check_init_esper_ups
    if esper_can_up?(sym)
      @esper_ups[sym] += 1
      lose_jp(get_cost_esper_up(sym))
      true
    else
      false
    end
  end

  # ottiene il costo per potenziare il parametro
  def get_cost_esper_up(sym)
    ((esper_ups[sym] * ESPER_UPS_COST_INCREASE / 100.0 + 1) * ESPER_UPS_INITIAL_COST).to_i
  end

  # determina se l'esper ha i requisiti per potenziare il parametro
  def esper_can_up?(sym)
    self.jp >= get_cost_esper_up(sym)
  end

  # controlla se esiste l'hash dei potenziamenti
  def check_init_esper_ups
    return if @esper_ups
    @esper_ups = {}
    ESPER_UPS_INCREMENTS.each_key {|key| @esper_ups[key] = 0}
  end

  # imposta i bonus parametri
  def setup_esper_param_bonus
    @atk_plus = summoner_param_bonus(:native_atk)
    @def_plus = summoner_param_bonus(:native_def)
    @spi_plus = summoner_param_bonus(:native_spi)
    @agi_plus = summoner_param_bonus(:native_agi)
    @maxhp_plus = summoner_param_bonus(:native_maxhp)
    @maxmp_plus = summoner_param_bonus(:native_maxmp)
  end

  # determina il bonus parametro da affinità con l'evocatore
  def summoner_param_bonus(param)
    return 0 unless is_esper?
    summoner = esper_master
    return 0 if summoner.nil?
    (summoner.send(param) * summoner_affinity(summoner.id) * EsperConfig::AFFINITY_RATE).to_i
  end
end

#===============================================================================
# ** classe Game_Party
#===============================================================================
class Game_Party < Game_Unit
  attr_reader :actual_esper #evocazione attualmente in campo

  # imposta l'evocazione in campo
  def actual_esper=(actor)
    @actual_esper = actor
  end

  # restituisce i turbo sbloccati
  def unlocked_boosts; @unlocked_boosts ||= []; end

  # aggiunge un turbo sbloccato al gruppo
  def add_boost(boost)
    @unlocked_boosts = [] if @unlocked_boosts.nil?
    @unlocked_boosts.push(boost) unless @unlocked_boosts.include?(boost)
  end

  # Restituisce le dominazioni sbloccate
  # @return [Array<Game_Actor>]
  def unlocked_dominations
    @unlocked_espers ||= []
    @unlocked_espers.collect{|dom_id| $game_actors[dom_id]}.sort_by{|esp| esp.name}
  end

  # Sblocca una dominazione
  def unlock_domination(esper_id)
    @unlocked_espers ||= []
    return unless $game_actors[esper_id].domination?
    @unlocked_espers.push(esper_id) unless @unlocked_espers.include?(esper_id)
  end

  # Restituisce true se la dominazione è sbloccata
  #   esper_id: id dell'evocazione
  def domination_unlocked?(esper_id)
    unlocked_dominations.include?($game_actors[esper_id])
  end

  # restituisce i latticini :)
  # @return [Array<RPG::Item>]
  def milks
    items.select{ |item| item.is_a?(RPG::Item) and item.is_milk? }
  end
end #game_party

# noinspection RubyResolve
class Scene_Battle < Scene_Base
  # alias
  alias esper_start start unless $@
  alias modifica_vittoria process_victory unless $@
  alias execute_action_skill_evocation execute_action_skill unless $@
  alias termina_in_sicurezza terminate unless $@

  # Inizializzazione della battaglia
  def start
    esper_start
    $game_temp.esper_active = false
    $game_temp.esper_used = false
    $game_temp.domination_energy = 0
  end

  # Modifica del processo di vittoria
  def process_victory
    if $game_temp.esper_active
      remove_esper
      if $game_party.all_dead?
        $game_party.members.each {|member|
          member.remove_state(1)
        }
      end
    end
    modifica_vittoria
    Espers.incrementa
  end

  # Modifica della fine del turno
  alias fine_turno turn_end unless $@
  def turn_end(member = nil)
    fine_turno(member)
    if $game_temp.esper_active
      if $game_party.actual_esper.hp == 0
        remove_esper(true)
      elsif $game_temp.domination_energy < 0
        remove_esper
      end
      $game_temp.domination_energy -= 1
    end
  end

  # evoca l'esper in battaglia
  def summon_esper(esper_id)
    reset_battle_status
    esper = $game_actors[esper_id]
    #livello = $game_party.max_level#livello_esper
    setup_esper(esper)
    add_esper_in_battle(esper)
    $game_temp.domination_energy = esper.duration
    $game_temp.esper_used = true if esper.domination?
    $game_temp.domination_max_turns = esper.duration
    azzera_tutto
  end

  # aggiunge l'evocazione in battaglia
  # @param [Game_Actor] esper
  def add_esper_in_battle(esper)
    $game_party.actual_esper = esper #nuova aggiunta
    $game_party.add_guest(esper.id)
    $game_temp.esper_active = true
  end

  # @param [Game_Actor] esper
  def setup_esper(esper)
    esper.change_level($game_party.max_level, false)
    esper.setup_esper_param_bonus
    esper.recover_all
    esper.summon_times += 1
  end

  # rimuovi l'evocazione dalla battaglia
  # dead: se l'evocazione è morta
  # battle_end: se la battaglia è finita
  # noinspection RubyResolve
  def remove_esper(dead = false, battle_end = false)
    esper = $game_party.actual_esper
    return if esper.nil?
    unless battle_end
      reset_battle_status
      @command_members.delete(esper)
      @action_battlers.delete(esper)
    end
    $game_party.remove_guest(esper.id)
    esper.set_recharge_max(actor.default_recharge, dead)
    $game_temp.esper_active = false
    azzera_tutto unless battle_end
  end

  # prepara l'azzeramento della barra
  def reset_battle_status
    target_select_cleanup
    end_skill_selection
    end_target_selection
    reset_atb_actor rescue return
    azzera_tutto rescue nil
  end

  # azzera tutti i parametri ATB
  def azzera_tutto
    actor = $game_actors[7]
    if $game_party.members.include?(actor) and actor.has_state?(20)
      Logger.info("incluso")
      $scene.spriteset.set_action(true, actor.index, "Torna_Demone")
    end
    begin
      $game_temp.status_window_refresh = true
      $game_party.members.each {|member|
        force_action_cleanup(member)
      }
      target_select_cleanup
      $game_party.atb_customize
      end_skill_selection
      end_target_selection
    rescue
      Logger.info("ERRORE")
      return
    end
  end

  # esegue l'azione della skill
  def execute_action_skill
    execute_action_skill_evocation
    skill = @active_battler.action.skill
    summon_esper(skill.esper) if !skill.nil? && skill.esper > 0
  end

  # fine
  def terminate
    termina_in_sicurezza
    if $game_temp.esper_active
      remove_esper(false, true)
    end
  end
end

#===============================================================================
# ** Classe Game_BattleAction
# Per la modifica dell'IA dell'evocazione (e dei personaggi)
#===============================================================================
class Game_BattleAction
  alias nuovo_valore evaluate_attack unless $@
  alias nuovo_skill evaluate_skill unless $@

  # ridefinizione del metodo evaluate_attack
  # Vieta l'attacco se l'evocazione ha l'attacco disattivato
  def evaluate_attack
    nuovo_valore
    if $game_temp.esper_active
      esper = $game_party.actual_esper
      @value = -99999 unless esper.can_attack?
    end
  end

  # ridefinizione del metodo evaluate_skill
  # Permette l'utilizzo di altri poteri
  def evaluate_skill
    nuovo_skill
    if Espers::Powers.include?(skill.id) and battler.skill_can_use?(skill)
      @value += rand if @value == 0.0
      @value *= Espers::Powers[skill.id]/100.0
    end
  end
end

class Esper_Affinity
  attr_reader :actor_id
  attr_reader :affinity

  def initialize(actor_id, affinity)
    @actor_id = actor_id
    @affinity = affinity
  end

  # @return [Game_Actor]
  def actor
    $data_actors[@actor_id]
  end

  # @return [String]
  def to_s
    sprintf('Esper_affinity{actor_id:%d, affinity:%d}', @actor_id, @affinity)
  end
end