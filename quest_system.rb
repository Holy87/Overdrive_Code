require 'rm_vx_data' if false
=begin
 Istruzioni
 Per i task
 Dividi un task su più righe (subtask) mettendoli in un ulteriore array
 Stampa nome e icona di un oggetto con \\I[ID oggetto]
 Imposta una condizione automatica di completamento con uno dei seguenti tag:
 <var x/max> completamento quando la variabile x raggiunge il valore max
 <item x/max> completamento quando hai un numero di oggetti x pari o superiore a max
 <switch x> attivazione quando lo switch x è attivo
 
=end

class H87Quest
  UNCOMPLETEDICON = 496
  COMPLETEDICON =   497
  #Switch per disattivazione popup
  POP_OPT_SW = 300

  VOC_LOCATION = 'Luogo'
  VOC_NPC      = 'Committente'
  VOC_TASKS    = 'Obiettivi'
  VOC_REWARDS  = 'Ricompense'
  VOC_ACTUAL   = 'Obiettivo attuale'
  VOC_COMPLETED= 'Missione completata'
  VOC_RECORD   = 'Missioni completate'
  VOC_CAT_ALL  = 'Tutte'
  VOC_CAT_ACT  = 'Attive'
  VOC_CAT_COM  = 'Completate'

  QUESTS = {
    #Dichiarazione d'Amore
    #====================================================================
    0 => {
    :name     => 'Dichiarazione d\'Amore',
    :variable => 164,
    :type     => :normal,
    :npc      => 'Ragazzo innamorato',
    :location => 'Baduelle',
    :decription => 'Questo giovane ragazzo innamorato vuole dichiararsi alla sua'+
                  'amata. Portale il messaggio a casa della madre antipatica!',
    :tasks => ['Parla con Rosanne, nella casa accanto il Pub',
              'Torna dal ragazzo innamorato per comunicargli la notizia.'],
    :rewards => ['<70 ap>','<70 exp>'] },
    
    #L'ammazzaslime
    #====================================================================
    1 => {
    :name     => 'Acchiappa Slime',
    :variable => 191,
    :type     => :normal,
    :npc      => 'Armaiolo',
    :location => 'Baduelle',
    :decription => 'L\'armaiolo vuole che gli dimostri il diritto ad acquistare armi uccidendo 5 Slime. Dimostragli che hai la stoffa degli eroi!',
    :tasks => [{:desc => 'Uccidi 5 Slime', :cond => '<var 137/5>'},
              'Torna dall\'armaiolo.'],
    :rewards => ['<10 ap>','<10 exp>','<1 item 4>'] },
    
    #Raccolta minerali di Huges
    #====================================================================
    2 => {
    :name     => 'La richiesta di Huges',
    :variable => 144,
    :type     => :normal,
    :npc      => 'Huges',
    :location => 'Baduelle',
    :decription => 'Huges il fabbro ti ha chiesto 3 pezzi d\'alluminio per completare la sua opera.',
    :tasks => [{:desc => 'Trova 3 pezzi d\'alluminio.',
                :cond => '<item 77/3>'},
              'Torna dall\'armaiolo.'],
    :rewards => ['<1 armor 31>','<1 armor 73>'] },
    
    #La raccolta degli ingredienti
    #====================================================================
    3 => {
    :name     => 'Lavoro nei campi',
    :variable => 145,
    :type     => :normal,
    :npc      => 'Billy',
    :location => 'Fattoria',
    :decription => ['Cerca gli ingredienti per Billy.',
                  'Uccidi i pipistrelli per le carote',
                  'Per le cipolle, i Tronchi.'],
     :tasks => [{:desc=>'Trova gli ingredienti richiesti.',
                 :subt=>[{:desc => 'Trova 8 \\I[41].',
                         :cond => '<item 41/8>'},
                        {:desc => 'Trova 4 \\I[42].',
                         :cond => '<item 42/4>'}]},
                 'Riporta gli ortaggi da Billy.'],
    :rewards => ['<100 exp>','<100 g>','<1 item 157>'] },
    
    #Salva James
    #====================================================================
    4 => {
    :name     => 'Salva James',
    :variable => 146,
    :type     => :normal,
    :npc      => 'Padre di James',
    :location => 'Sirenas',
    :decription => 'I genitori di James ti hanno chiesto di salvare loro figlio e il suo amico.',
    :tasks => ['Raggiungi la foresta di salici','Trova James!','Torna a casa di James e parla con suo padre.'],
    :rewards => ['<100 exp>','<100 g>','<1 armor 130>','<1 weapon 76>'] },
    
    #Legno
    #====================================================================
    5 => {
    :name     => 'Aggiusta il carro!',
    :variable => 190,
    :type     => :normal,
    :npc      => 'Cocchiere',
    :location => 'Sirenas',
    :decription => 'Un vecchio corriere ti ha chiesto di '+
                  'trovare del legno per riparare il suo '+
                  'carro da trasporto. Prova a cercarlo '+
                  'dai mostri-tronco nei paraggi.',
    :tasks => [{:desc => 'Trova 2 unità di \\I[64].',
                :cond => '<item 64/2>'},
              'Hai completato l\'obiettivo! Torna dal corriere.'],
    :rewards => ['<100 exp>','<200 g>','<10 ap>'] },
    
    #Il cornuto
    #====================================================================
    6 => {
    :name     => 'Cervo a primavera',
    :variable => 148,
    :type     => :normal,
    :npc      => 'Natisha',
    :location => 'Monferras',
    :decription => 'Una ragazza ti ha incaricato di '+
                  'portare una lettera al suo ex '+
                  'fidanzato a Baduelle.',
    :tasks => ['Porta la lettera a Kevin, a Baduelle (lo trovi in spiaggia).',
              'Hai dato la lettera a Kevin. Ora torna dalla ragazza'],
    :rewards => ['<500 exp>','<4000 g>','<100 ap>'] },
    
    #Risate a corte
    #====================================================================
    7 => {
    :name     => 'Risate a corte',
    :variable => 149,
    :type     => :normal,
    :npc      => 'Clown',
    :location => 'Monferras',
    :decription => 'Un clown molto simpatico ti ha chiesto di convincere il re ad assumerlo alla sua corte.',
    :tasks => ['Convinci il Re ad assumere un clown.',
              'Torna dal clown per dargli la bella notizia!'],
    :rewards => ['<150 exp>','<50 g>','<1 item 18>'] },

    #Ingredienti per la cena
    #====================================================================
    8 => {
    :name     => 'Gli ingredienti per la cena',
    :variable => 150,
    :type     => :normal,
    :npc      => 'Signora benestante',
    :location => 'Monferras',
    :description => 'Una gentil signora ti ha chiesto di trovare gli ingredienti per la cena.',
    :tasks => [{:desc => 'Trova gli ingredienti richiesti.',
                :subt => [
                  {:desc => 'Trova 10 \\I[57].', :cond => '<item 57/10>'},
                  {:desc => 'Trova 10 \\I[43].', :cond => '<item 43/10>'}
                ]},
                'Torna dalla signora a Monferras.'],
    :rewards  => ['<200 exp>','<50 g>','<1 weapon 22>','<1 armor 151>'] },
    
    #Il diario smarrito
    #====================================================================
    9 => {
    :name     => 'Il diario rubato',
    :variable => 151,
    :type     => :normal,
    :npc      => 'Maga Cadetta',
    :location => 'Pigwarts',
    :description => 'Hanno nascosto il diario segreto di questa povera maghetta. Ritrovaglielo!',
    :tasks => ['Trova il diario. È nascosto da qualche parte nell\'Accademia',
                'Riporta il diario alla sua legittima proprietaria'],
    :rewards  => ['<150 exp>','<150 g>','<1 item 29>'] },
    
    #Esperimento magico
    #====================================================================
    10 => {
    :name     => 'Formula per l\'esperimento',
    :variable => 152,
    :type     => :normal,
    :npc      => 'Maga ricercatrice',
    :location => 'Pigwarts',
    :description => 'Una maga ti ha chiesto di procuperarle '+
                    'degli ingredienti per il suo '+
                    'esperimento. Cerca gli ingredienti '+
                    'tra i mostri di Florea.',
    :tasks => [{:desc => 'Trova gli ingredienti richiesti.',
                :subt => [
                  {:desc => 'Trova 10 \\I[57].', :cond => '<item 57/10>'},
                  {:desc => 'Trova 10 \\I[54].', :cond => '<item 54/10>'},
                  {:desc => 'Trova 5 \\I[48].',  :cond => '<item 48/5>'}]},
                'Torna dalla maga per darle gli ingredienti.'],
    :rewards  => ['<100 exp>','<500 g>','<1 item 8>'] },
    
    #L'ago nel pagliaio
    #====================================================================
    13 => {
    :name     => 'Come un ago in un pagliaio!',
    :variable => 155,
    :type     => :normal,
    :npc      => '',
    :location => 'Pigwarts',
    :description => 'Hanno nascosto il diario segreto di questa povera maghetta. Ritrovaglielo!',
    :tasks => ['Trova il diario. È nascosto da qualche parte nell\'Accademia',
                'Riporta il diario alla sua legittima proprietaria'],
    :rewards  => ['<150 exp>','<150 g>','<1 item 29>'] },

    14 => {
        :name => 'La donna scomparsa',
        :variable => 156,
        :type => :normal,
        :npc => 'Marito disperato',
        :location => 'Faide-Eiba',
        :description => 'La moglie di questo gentil signore si è persa nelle Piramidi Gassose.',
        :tasks => ['Cerca la donna nelle Piramidi Gassosa',
                   'Ora che l\'hai tratta in salvo, torna dal marito.'],
        :rewards => ['<200 exp>', '<100 g>', '<1 armor 158>'] },

    15 => {
        :name => 'Il malato',
        :variable => 157,
        :type => :normal,
        :npc => 'Ragazza del villaggio',
        :location => 'Faide-Eiba',
        :description => 'Un misterioso ragazzo trovato nelle Piramidi è gravemente ' +
            'ferito ed ha bisogno di cure mediche. Il bosco ad Est del Deserto è ' +
            'ricco di funghi!',
        :tasks => [{:desc => 'Trova 10 \\I[46].', :cond => '<item 46/10>'},
                    'Porta subito i funghi dal malato!'],
        :rewards => ['<400 exp>', '???']
    },

    16 => {
        :name => 'Derattizzazione',
        :variable => 158,
        :type => :normal,
        :npc => 'Capitano della Nave',
        :location => 'Porto di Fasbury',
        :description => 'La nave del capitano è infestata dai topi, e lui ti ha chiesto' +
            ' di ripulirla al posto suo.',
        :tasks => ['Sali sulla nave e liberati dei topi.'],
        :rewards => ['<300 exp>', '<1 item 28>', '<1 item 10>']
    },

    17 => {

    }
  }


  #--------------------------------------------------------------------------
  # * Restituisce tutte le missioni
  # @return [Array<Quest>]
  #--------------------------------------------------------------------------
  def self.all_quests
    @quests ||= initialize_quests
    @quests
  end
  #--------------------------------------------------------------------------
  # * Inizializza tutte le missioni
  #--------------------------------------------------------------------------
  def self.initialize_quests
    quests = {}
    QUESTS.each_pair {|quest_id, quest_data|
      quest = Quest.new(quest_id, quest_data)
      quest.id = quest_id
      quest.name = quest_data[:name]
      quest.type = quest_data[:type]
      quest.variable_id = quest_data[:variable]
      quest.description = quest_data[:description]
      quest.npc = quest_data[:npc]
      quest.location = quest_data[:location]
      quest.create_rewards(quest_data[:rewards])
      get_tasks(quest, quest_data[:tasks])
      quests[quest_id] = quest
    }
    @quests = quests
  end
  #--------------------------------------------------------------------------
  # * Ottiene gli obiettivi della quest
  # @param [Quest] quest
  # @param [Array<Quest_Task>] tasks
  #--------------------------------------------------------------------------
  def self.get_tasks(quest, tasks)
    tasks.each do |task|
      add_son(quest, task)
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiunge un figlio ad una task
  #--------------------------------------------------------------------------
  def self.add_son(father, task)
    if task.is_a?(String)
      qtask = Quest_Task.new(task)
      qtask.father = father
    else
      add_task(father, task)
    end
  end  
  #--------------------------------------------------------------------------
  # * Aggiunge una task
  #--------------------------------------------------------------------------
  def self.add_task(father, task)
    qtask = Quest_Task.new(task[:desc])
    qtask.set_condition(task[:cond]) if task[:cond]
    qtask.tag = task[:tag] if task[:tag]
    qtask.father = father
    task[:subt].each {|subtask| add_task(qtask, subtask)} if task[:subt]
  end
end

module Vocab
  #--------------------------------------------------------------------------
  # * Stringa locazione quest
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_location; H87Quest::VOC_LOCATION; end
  #--------------------------------------------------------------------------
  # * Stringa nome NPC committente
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_npc; H87Quest::VOC_NPC; end
  #--------------------------------------------------------------------------
  # * Stringa obiettivi
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_tasks; H87Quest::VOC_TASKS; end
  #--------------------------------------------------------------------------
  # * Stringa ricompense
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_rewards; H87Quest::VOC_REWARDS; end
  #--------------------------------------------------------------------------
  # * Stringa obiettivo attuale della quest
  # @return [String]
  #--------------------------------------------------------------------------
  def self.actual_task; H87Quest::VOC_ACTUAL; end
  #--------------------------------------------------------------------------
  # * Stringa quest completata
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_completed; H87Quest::VOC_COMPLETED; end
  #--------------------------------------------------------------------------
  # * Stringa per categoria tutte le missioni
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_category_all; H87Quest::VOC_CAT_ALL; end
  #--------------------------------------------------------------------------
  # * Stringa per categoria missioni attive
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_category_active; H87Quest::VOC_CAT_ACT; end
  #--------------------------------------------------------------------------
  # * Stringa per categoria missioni completate
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_category_completed; H87Quest::VOC_CAT_COM; end
  #--------------------------------------------------------------------------
  # * Stringa record missioni completate
  # @return [String]
  #--------------------------------------------------------------------------
  def self.quest_record; H87Quest::VOC_RECORD; end
end

#==============================================================================
# ** Classe Quest
#------------------------------------------------------------------------------
#  Contiene le informazioni della missione
#==============================================================================
class Quest
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  # @attr[Integer] id
  # @attr[String] name
  # @attr[Symbol] type
  # @attr[Integer] variable_id
  # @attr[Array<Quest_Reward>] rewards
  # @attr[Integer] gold
  # @attr[Integer] exp
  # @attr[Integer] ap
  # @attr[String] description
  # @attr[Array<Quest_Task>] tasks
  # @attr[String] npc
  # @attr[String] location
  #--------------------------------------------------------------------------
  attr_accessor :id           #ID della quest
  attr_accessor :name         #Nome della quest
  attr_accessor :type         #Tipo della quest
  attr_accessor :variable_id  #ID Variabile di progresso
  attr_accessor :rewards      #Array delle ricompense
  attr_accessor :gold         #Ricompensa in oro
  attr_accessor :exp          #Ricompensa in esperienza
  attr_accessor :ap           #Ricompensa in PA
  attr_accessor :description  #Descrizione
  attr_accessor :tasks        #Obiettivi della missione
  attr_accessor :npc          #Nome dell'NPC
  attr_accessor :location     #Locazione dell'inizio della quest
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] quest_id
  # @param [String] quest_data
  #--------------------------------------------------------------------------
  def initialize(quest_id, quest_data)
    @id = quest_id
    @name = quest_data[:name]
    @type = quest_data[:type]
    @variable_id = quest_data[:variable]
    @description = quest_data[:description]
    @location = quest_data[:location]
    @rewards = []
    @npc = quest_data[:npc]
    create_tasks(quest_data[:tasks])
    create_rewards(quest_data[:rewards])
  end
  #--------------------------------------------------------------------------
  # * Restituisce se la quest è attiva o meno
  #--------------------------------------------------------------------------
  def active?; variable >= 0 && variable < @tasks.size; end
  #--------------------------------------------------------------------------
  # * Restituisce true se la quest è visibile
  #--------------------------------------------------------------------------
  def unlocked?; active? || completed?; end
  #--------------------------------------------------------------------------
  # * Restituisce true se la quest è completata
  #--------------------------------------------------------------------------
  def completed?; variable >= @tasks.size; end
  #--------------------------------------------------------------------------
  # * Determina se la quest sta aspettando una variabile
  #--------------------------------------------------------------------------
  def wait_for_variable?; !completed? && actual_task.wait_for_variable?; end
  #--------------------------------------------------------------------------
  # * Determina se la quest sta aspettando un oggetto
  #--------------------------------------------------------------------------
  def wait_for_item?; !completed? && actual_task.wait_for_item?; end
  #--------------------------------------------------------------------------
  # * Determina se la quest sta aspettando uno switch
  #--------------------------------------------------------------------------
  def wait_for_switch?; !completed? && actual_task.wait_for_switch?; end
  #--------------------------------------------------------------------------
  # * Restituisce gli oggetti richiesti dalla quest. Può dare errore se la
  #   quest è completata.
  # @return [Array<RPG::BaseItem>]
  #--------------------------------------------------------------------------
  def requested_items; actual_task.requested_items; end
  #--------------------------------------------------------------------------
  # * Restituisce le variabili richieste dalla quest. Può dare errore se la
  #   quest è completata.
  # @return [Array]
  #--------------------------------------------------------------------------
  def requested_variables; actual_task.requested_variables; end
  #--------------------------------------------------------------------------
  # * Restituisce gli switch richiesti dalla quest. Può dare errore se la
  #   quest è completata.
  # @return [Array]
  #--------------------------------------------------------------------------
  def requested_switches; actual_task.requested_switches; end
  #--------------------------------------------------------------------------
  # * Determina se la quest è più avanzata rispetto alla task
  # @param [Quest_Task] task
  #--------------------------------------------------------------------------
  def task_completed?(task)
    task_id = tasks.index(task)
    if task_id.nil?
      puts 'Errore: Stai cercando di verificare una task che non appartiene alla quest.'
      return false
    end
    variable > (task_id + 1)
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'ID icona della missione
  #--------------------------------------------------------------------------
  def icon_index
    completed? ? H87Quest::COMPLETEDICON : H87Quest::UNCOMPLETEDICON
  end
  #--------------------------------------------------------------------------
  # * Sblocca l'obiettivo
  #   sub_id: ID dell'obiettivo
  #--------------------------------------------------------------------------
  def unlock_sub(sub_id)
    return unless actual_task.is_a?(Array)
    if actual_task[sub_id].nil?
      print "Errore: si cerca di sbloccare il sotto-obiettivo #{sub_id}, ma non esiste."
    else
      actual_task[sub_id].completed = true
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Inizia la quest
  #--------------------------------------------------------------------------
  def start; $game_variables[@variable_id] = 1; end
  #--------------------------------------------------------------------------
  # * Avanza la quest al prossimo obiettivo
  #--------------------------------------------------------------------------
  def advance
    $game_variables[@variable_id] += 1
    show_popup if $scene.is_a?(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * Completa istantaneamente la quest
  #--------------------------------------------------------------------------
  def complete
    $game_variables[@variable_id] = tasks.size + 10
  end
  #--------------------------------------------------------------------------
  # * Restituisce il valore della variabile della quest
  #--------------------------------------------------------------------------
  def state; $game_variables[@variable_id]; end
  #--------------------------------------------------------------------------
  # * Restituisce l'obiettivo attualmente attivo
  # @return [Quest_Task]
  #--------------------------------------------------------------------------
  def actual_task
    return nil unless active?
    @tasks[state]
  end
  #--------------------------------------------------------------------------
  # * Avanza per chiamata dell'obiettivo
  #--------------------------------------------------------------------------
  def check_advance; advance; end
  #--------------------------------------------------------------------------
  # * Ottiene l'elenco delle ricompense
  # @param [Array<String>] rewards
  #--------------------------------------------------------------------------
  def create_rewards(rewards)
    @rewards = []
    return if rewards.nil?
    rewards.each do |reward|
      case reward
        when /<(\d+)[ ]+g>/i
          @gold += $1.to_i
        when /<(\d+)[ ]+exp>/i
          @exp += $1.to_i
        when /<(\d+)[ ]+ap>/i
          @ap += $1.to_i
        when /<(\d+)[ ]+item[ ]+(\d+)>/i
          @rewards.push(Quest_Reward.new(1, $2.to_i, $1.to_i))
        when /<(\d+)[ ]+weapon[ ]+(\d+)>/i
          @rewards.push(Quest_Reward.new(2, $2.to_i, $1.to_i))
        when /<(\d+)[ ]+armor[ ]+(\d+)>/i
          @rewards.push(Quest_Reward.new(3, $2.to_i, $1.to_i))
        else
          @rewards.push(Quest_Reward.new(0, reward))
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Ottiene l'elenco degli obiettivi della quest
  # @param [Array<String>] tasks_data
  #--------------------------------------------------------------------------
  def create_tasks(tasks_data)
    @tasks = []
    return if tasks_data.nil?
    tasks_data.each do |task|
      @tasks.push(Quest_Task.new(task))
    end
  end
end

#==============================================================================
# ** Classe Quest_Task
#------------------------------------------------------------------------------
#  Contiene le informazioni dell'obiettivo della missione
#==============================================================================
class Quest_Task
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  # @attr[String] description
  # @attr[String] tag
  # @attr[Array<Quest_Task>] subtasks
  # @attr[Quest_Task] father
  # @attr[Task_Condition] condition
  #--------------------------------------------------------------------------
  attr_accessor :description  #Descrizione dell'obiettivo
  attr_accessor :tag          #Etichetta della task (nel caso sblocco manuale)
  attr_accessor :subtasks     #Sotto-obiettivi da completare
  attr_accessor :father       #padre (per avanzamento, quest oppure obiettivo)
  attr_accessor :condition    #condizione dell'obiettivo
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Hash<String>] task_data
  # @param [Quest_Task] father
  #--------------------------------------------------------------------------
  def initialize(task_data, father = nil)
    @description = task_data[:desc]
    @tag = task_data[:tag]
    @father = father
    @completed = false
    @condition = Task_Condition.new(task_data[:cond])
  end
  #--------------------------------------------------------------------------
  # * Imposta la condizione dell'obiettivo
  #   condition_info: Informazioni sulla condizione in stringa
  # @param [String] condition_info
  #--------------------------------------------------------------------------
  def set_condition(condition_info)
    @condition = Task_Condition.new(condition_info)
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto dell'obiettivo
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def item; self.condition.item; end
  #--------------------------------------------------------------------------
  # * Restituisce lo stato dell'obiettivo
  # @return [Integer]
  #--------------------------------------------------------------------------
  def state; self.condition.state; end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'obiettivo è completato
  #--------------------------------------------------------------------------
  def completed?
    return true if @completed or father.completed?
    if father.is_a?(Quest)
      return true if father.task_completed?(self)
    end
    condition.completed?
  end
  #--------------------------------------------------------------------------
  # * Restituisce il numero di righe
  #--------------------------------------------------------------------------
  def size
    sum = 1
    subtasks.each{|subtask| sum += subtask.size}
    sum
  end
  #--------------------------------------------------------------------------
  # * Determina se la task sta aspettando un oggetto
  #--------------------------------------------------------------------------
  def wait_for_item?
    return false if completed?
    if self.subtasks != nil
      subtasks.each{|subtask|
        return true if subtask.wait_for_item?
      }
    end
    condition.item != nil
  end
  #--------------------------------------------------------------------------
  # * Determina se la task sta aspettando una variabile
  #--------------------------------------------------------------------------
  def wait_for_variable?
    return false if completed?
    if self.subtasks != nil
      subtasks.each{|subtask|
        return true if subtask.wait_for_variable?
      }
    end
    condition.item_type == 4
  end
  #--------------------------------------------------------------------------
  # * Determina se la task sta aspettando uno switch
  #--------------------------------------------------------------------------
  def wait_for_switch?
    return false if completed?
    if self.subtasks != nil
      subtasks.each{|subtask|
        return true if subtask.wait_for_switch?
      }
    end
    condition.item_type == 5
  end
  #--------------------------------------------------------------------------
  # * Restituisce gli oggetti richiesti dalla task e subtasks
  # @return [Array<RPG::BaseItem>]
  #--------------------------------------------------------------------------
  def requested_items
    items = []
    if subtasks
      subtasks.each{|subtask| items += subtask.requested_items}
    end
    items.push(condition.item) if condition.item != nil
    items
  end
  #--------------------------------------------------------------------------
  # * Restituisce le variabili richieste dalla task e subtasks
  # @return [Array<Integer>]
  #--------------------------------------------------------------------------
  def requested_variables
    items = []
    if subtasks
      subtasks.each{|subtask| items += subtask.requested_variables}
    end
    items.push(condition.item_id) if condition.item_type == 4
    items
  end
  #--------------------------------------------------------------------------
  # * Restituisce gli switch richiesti dalla task e subtasks
  # @return [Array<Integer>]
  #--------------------------------------------------------------------------
  def requested_switches
    items = []
    if subtasks
      subtasks.each{|subtask| items += subtask.requested_switches}
    end
    items.push(condition.item_id) if condition.item_type == 5
    items
  end
  #--------------------------------------------------------------------------
  # * Completa l'obiettivo all'istante
  #--------------------------------------------------------------------------
  def complete
    if @subtasks
      @subtasks.each { |task|
        task.complete
      }
    end
    return if @completed
    @completed = true
    $game_system.quest_tasks[@tag] = true if @tag != nil
    @father.check_advance
  end
  #--------------------------------------------------------------------------
  # * Avanza per chiamata del sotto-obiettivo
  #--------------------------------------------------------------------------
  def check_advance
    complete if all_tasks_completed?
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se tutti i sottoobiettivi sono completati
  #--------------------------------------------------------------------------
  def all_tasks_completed?
    return true unless @subtasks
    @subtasks.each { |task|
      return false unless task.completed?
    }
    true
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'icona checkbox della quest
  #--------------------------------------------------------------------------
  def check_icon
    completed? ? H87Quest::COMPLETEDICON : H87Quest::UNCOMPLETEDICON
  end
  #--------------------------------------------------------------------------
  # * Compatibilità per trattarli come quest
  #--------------------------------------------------------------------------
  def tasks; @subtasks; end
  def tasks=(sub); @subtasks = sub; end
end

#==============================================================================
# ** Classe Quest_Condition
#------------------------------------------------------------------------------
#  Contiene le informazioni sulle condizioni di completamento di una task
#==============================================================================
class Task_Condition
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  # @attr[Integer] item_type
  # @attr[Integer] max
  # @attr[Integer] item_id
  # @attr[Boolean] completed
  #--------------------------------------------------------------------------
  attr_accessor :item_type  #Tipo oggetto (per soddisfare l'obiettivo)
  attr_accessor :max        #Massimo numero di oggetti per soddisfare
  attr_accessor :item_id    #ID dell'oggetto (id oggetto o variabile)
  attr_accessor :completed  #Stato dell'obiettivo
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(con_string = nil)
    @item = nil
    @item_type = 0
    @max = 0
    return if con_string.nil?
    case con_string
      when /<item[ ]+(\d+)\/(\d+)/i
        @item_type = 1
        @item_id = $1.to_i
        @item_number = $2.to_i
      when /<weapon[ ]+(\d+)\/(\d+)/i
        @item_type = 2
        @item_id = $1.to_i
        @item_number = $2.to_i
      when /<armor[ ]+(\d+)\/(\d+)/i
        @item_type = 3
        @item_id = $1.to_i
        @item_number = $2.to_i
      when /<var[ ]+(\d+)\/(\d+)/i
        @item_type = 4
        @item_id = $1.to_i
        @item_number = $2.to_i
      when /<switch[ ]+(\d+)/i
        @item_type = 5
        @item_id = $1.to_i 
      else
        @item_tye = 0
        @item_id = 0
    end
    @completed = false
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto della condizione
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def item
    case @item_type
      when nil, 0
        return nil
      when 1
        return $data_items[@item]
      when 2
        return $data_weapons[@item]
      when 3
        return $data_armors[@item]
      else
        return nil
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce lo stato della condizione
  # @return [Integer]
  #--------------------------------------------------------------------------
  def state
    case @item_type
      when nil, 0
        return @completed
      when 1, 2, 3
        return $game_party.item_number(item)
      when 4
        return $game_variables[@item_id]
      when 5
        return $game_switches[@item_id]
      else
        return nil
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se la condizione è soddisfatta
  #--------------------------------------------------------------------------
  def completed?
    return true if @completed
      case @item_type
      when 0
        return @completed
      when 1, 2, 3, 4
        return state >= @max
      when 5
        return state
      else
        return false
    end
  end
end

#==============================================================================
# ** Classe Quest_Reward
#------------------------------------------------------------------------------
#  Contiene le informazioni sulla ricompensa della quest
#==============================================================================
class Quest_Reward
  attr_accessor :number #Numero di oggetti di ricompensa
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #   type:   Tipo oggetto (1: Item, 2: Arma, 3: Armatura, 0: Stringa)
  #   id:     ID dell'oggetto
  #   number: numero di oggetti
  # @param [Integer] type
  # @param [Integer] id
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def initialize(type, id, number = 0)
    @type = type
    @id = id
    @number = number
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se la ricompensa è un oggetto
  #--------------------------------------------------------------------------
  def is_item?; type > 0; end
  #--------------------------------------------------------------------------
  # * Restituisce true se la ricompensa è scritta come testo generico
  #--------------------------------------------------------------------------
  def is_string?; type == 0; end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto della ricompensa
  # @return [RPG::Item]
  #--------------------------------------------------------------------------
  def get_item
    case type
      when 1
        return $data_items[id]
      when 2
        return $data_weapons[id]
      when 3
        return $data_armors[id]
      else
        return nil
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce la stringa della ricompensa
  #--------------------------------------------------------------------------
  def get_string; id; end
end

class Game_Temp
  def quest_cache_variables
    @quest_cache_variables ||= quest_cache_variables_init
  end

  def quest_cache_switches
    @quest_cache_switches ||= quest_cache_switches_init
  end

  def quest_cache_switches_init

  end

  def quest_cache_variables_init

  end

end

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  Contiene le informazioni dello stato delle quest
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Restituisce tutte le missioni
  # @return[Array<Quest>]
  #--------------------------------------------------------------------------
  def quests; H87Quest.all_quests; end
  #--------------------------------------------------------------------------
  # * Restituisce le missioni sbloccate
  # @return[Array<Quest>]
  #--------------------------------------------------------------------------
  def unlocked_quests; quests.select{|quest| quest.unlocked?}; end
  #--------------------------------------------------------------------------
  # * Restituisce le missioni attive
  # @return[Array<Quest>]
  #--------------------------------------------------------------------------
  def active_quests
    quests.select{|quest| quest.unlocked? && !quest.completed?}
  end
  #--------------------------------------------------------------------------
  # * Restituisce le missioni completate
  # @return[Array<Quest>]
  #--------------------------------------------------------------------------
  def completed_quests; quests.select{|quest| quest.completed?}; end
  #--------------------------------------------------------------------------
  # * Restituisce il numero di missioni totali
  #--------------------------------------------------------------------------
  def quest_number; quests.size; end
  #--------------------------------------------------------------------------
  # * Restituisce il numero di missioni sbloccate
  #--------------------------------------------------------------------------
  def unlocked_quest_number; unlocked_quests.size; end
  #--------------------------------------------------------------------------
  # * Restituisce il numero di missioni completate
  #--------------------------------------------------------------------------
  def completed_quest_number; completed_quests.size; end
  #--------------------------------------------------------------------------
  # * Restituisce il numero di missioni attive (in corso)
  #--------------------------------------------------------------------------
  def active_quest_number; unlocked_quest_number - completed_quest_number; end
  #--------------------------------------------------------------------------
  # * Comincia una missione
  #   quest_id: ID della missione (numerico)
  #--------------------------------------------------------------------------
  def start_quest(quest_id); quests[quest_id].start; end
  #--------------------------------------------------------------------------
  # * Avanza una quest
  #   quest_id: ID della missione (numerico)
  #--------------------------------------------------------------------------
  def advance_quest(quest_id); quests[quest_id].advance; end
  #--------------------------------------------------------------------------
  # * Completa una missione
  #   quest_id: ID della missione (numerico)
  #--------------------------------------------------------------------------
  def complete_quest(quest_id); quests[quest_id].complete; end
  #--------------------------------------------------------------------------
  # * Restituisce i sottoobiettivi delle quest completati
  #--------------------------------------------------------------------------
  def quest_tasks
    @quest_tasks = [] unless @quest_tasks
    @quest_tasks
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'hash di queste da aggiornare {id => stato}
  # @return [Hash]
  #--------------------------------------------------------------------------
  def quests_to_update; @quests_to_update ||={}; end
  #--------------------------------------------------------------------------
  # * Aggiunge la quest a quelle che devono entrare nel popup
  # @param [Quest] quest
  #--------------------------------------------------------------------------
  def add_quest_update(quest)
    quests_to_update[quest.id] = quest.state
  end
  #--------------------------------------------------------------------------
  # * Rimuove la quest da quelle da aggiornare
  # @param [Quest] quest
  #--------------------------------------------------------------------------
  def remove_quest_update(quest); quests_to_update.delete(quest.id); end
  #--------------------------------------------------------------------------
  # * Rimuove tutte le quest da visualizzare nel popup
  #--------------------------------------------------------------------------
  def flush_quest_update; @quests_to_update = {}; end
  #--------------------------------------------------------------------------
  # * Puoi mostrare i popup delle missioni? (se il giocatore vuole)
  #--------------------------------------------------------------------------
  def can_show_mission_popup?; !$game_switches[H87Quest::POP_OPT_SW]; end
end

#==============================================================================
# ** Scene_Quest
#------------------------------------------------------------------------------
#  Schermata dell'elenco delle missioni
#==============================================================================
class Scene_Quest < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_quest_type_window
    create_quest_list_window
    create_quest_record_window
    create_quest_details_window
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei tipi di missioni
  #--------------------------------------------------------------------------
  def create_quest_type_window
    @category_window = Window_QuestType.new(0, 0)
    @category_window.set_handler(:cancel, method(:return_scene))
    @category_window.set_handler(:ok, method(:quest_selection))
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra della lista delle missioni
  #--------------------------------------------------------------------------
  def create_quest_list_window
    width = Graphics.width / 3
    y = @category_window.height
    height = Graphics.height - y
    @list_window = Window_QuestList.new(0, y, width, height)
    @category_window.item_window = @list_window
    @list_window.activate
    @list_window.set_handler(:cancel, method(:category_selection))
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei dettagli della missione
  #--------------------------------------------------------------------------
  def create_quest_details_window
    width = Graphics.width - @list_window.width
    x = @list_window.width
    y = @list_window.y
    height = @list_window.height - @record_window.height
    @quest_window = Window_QuestInfo.new(x, y, width, height)
    @list_window.quest_window = @quest_window
    @list_window.set_handler(:left, method(:switch_info))
    @list_window.set_handler(:right, method(:switch_info))
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra di conteggio missioni
  #--------------------------------------------------------------------------
  def create_quest_record_window
    x = @list_window.width
    @record_window = Window_QuestRecord.new(x, 0, Graphics.width - x)
    @record_window.y = Graphics.height - @record_window.height
  end
  #--------------------------------------------------------------------------
  # * Selezione della lista di quest
  #--------------------------------------------------------------------------
  def quest_selection; @list_window.activate; end
  #--------------------------------------------------------------------------
  # * Selezione della categoria di quest
  #--------------------------------------------------------------------------
  def category_selection; @category_window.activate; end
  #--------------------------------------------------------------------------
  # * Cambia le informazioni mostrate nella quest
  #--------------------------------------------------------------------------
  def switch_info; @quest_window.switch_mode; end
end

#==============================================================================
# ** Window_QuestType
#------------------------------------------------------------------------------
# Finestra che mostra i filtri per le missioni (tutte, completate, in corso)
#==============================================================================
class Window_QuestType < Window_HorzCommand
  # @attr[Window_QuestList] quest_window
  attr_reader :quest_window
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initiaize
    super(0, 0)
    @quest_window = nil
  end
  #--------------------------------------------------------------------------
  # * Larghezza della finestra
  #--------------------------------------------------------------------------
  def window_width; Graphics.width; end
  #--------------------------------------------------------------------------
  # * Numero di colonne
  #--------------------------------------------------------------------------
  def col_max; 3; end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    self.quest_window.category = current_symbol if @quest_window
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra dei comandi
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab.quest_category_active, :active)
    add_command(Vocab.quest_category_completed, :completed)
    add_command(Vocab.quest_category_all, :all)
  end
  #--------------------------------------------------------------------------
  # * Imposta la finestra delle quest
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    self.quest_window = item_window
    update
  end
end

#==============================================================================
# ** Window_QuestList
#------------------------------------------------------------------------------
# Finestra che mostra l'elenco delle missioni sbloccate
#==============================================================================
class Window_QuestList < Window_Selectable
  # @attr[Window_QuestInfo] quest_window
  attr_accessor :quest_window
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Imposta la categoria
  # @param [Symbol] category
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Numero di colonne massime
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # * Numero di oggetti
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 1; end
  #--------------------------------------------------------------------------
  # * La quest evidenziata
  # @return [Quest]
  #--------------------------------------------------------------------------
  def item; @data && index >= 0 ? @data[index] : nil; end
  #--------------------------------------------------------------------------
  # * L'oggetto è selezionabile?
  #--------------------------------------------------------------------------
  def current_item_enabled?; true; end
  #--------------------------------------------------------------------------
  # * Includere la quest nella lista?
  # @param [Quest] item
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
      when :all
        true
      when :active
        !item.completed?
      when :completed
        item.completed?
      else
        false
    end
  end
  #--------------------------------------------------------------------------
  # * Crea la lista degli oggetti
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_system.unlocked_quests.select {|item| include?(item) }
    @data.push(nil) if include?(nil)
  end
  #--------------------------------------------------------------------------
  # * Disegna la quest
  #--------------------------------------------------------------------------
  def draw_item(index)
    quest = @data[index]
    rect = item_rect(index)
    enabled = !quest.completed?
    change_color(normal_color, enabled)
    draw_icon(quest.icon_index, rect.x, rect.y, enabled)
    rect.x += 24; rect.width -= 24
    draw_text(rect, quest.name)
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la finestra delle info dell quest
  #--------------------------------------------------------------------------
  def update_help
    self.quest_window.set_quest(item)
  end
  #--------------------------------------------------------------------------
  # * Riaggiorna il contenuto della finestra
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end

#==============================================================================
# ** Window_QuestInfo
#------------------------------------------------------------------------------
# Finestra che mostra i dettagli della missione
#==============================================================================
class Window_QuestInfo < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Object] x
  # @param [Object] y
  # @param [Object] width
  # @param [Object] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    refresh
    @quest = nil
    @mode = :info
  end
  #--------------------------------------------------------------------------
  # * Restituisce la quest mostrata
  # @return [Quest]
  #--------------------------------------------------------------------------
  def quest; @quest; end
  #--------------------------------------------------------------------------
  # * Imposta una nuova quest
  # @param [Quest] new_quest
  #--------------------------------------------------------------------------
  def set_quest(new_quest)
    return if @quest == new_quest
    @quest = new_quest
    refresh
  end
  #--------------------------------------------------------------------------
  # * Cambia modalità
  #--------------------------------------------------------------------------
  def switch_mode
    @mode == :info ? @mode = :tasks : @mode = :info
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if quest.nil?
    draw_window_title
    draw_window_info
  end
  #--------------------------------------------------------------------------
  # * Disegna le informazioni nella finestra a seconda della modalità
  #--------------------------------------------------------------------------
  def draw_window_info
    if @mode == :info
      draw_quest_info(line_height)
    else
      draw_all_tasks(line_height)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna il titolo della quest
  #--------------------------------------------------------------------------
  def draw_window_title
    draw_bg_rect(0, 0)
    case @mode
      when :info
        title = quest.name
      when :tasks
        title = Vocab.quest_tasks
      else
        title = ' '
    end
    text = sprintf('< %s >', title)
    change_color(system_color)
    draw_text(0, 0, contents_width, line_height, text, 1)
    if $imported['H87-ControllerMapper']
      draw_key_icon(:LEFT, 0, 0)
      draw_key_icon(:RIGHT, contents_width - 24, 0)
    end
  end
  #--------------------------------------------------------------------------
  # * Mostra i dettagli principali della missione
  # @param [Integer] line
  #--------------------------------------------------------------------------
  def draw_quest_info(line)
    draw_quest_info(line)
    draw_quest_description(line + 3)
    draw_quest_task(line + 6)
    draw_rewards
  end
  #--------------------------------------------------------------------------
  # * Calcola l'altezza di un numero di righe
  #--------------------------------------------------------------------------
  def t_line(line); line * line_height; end
  #--------------------------------------------------------------------------
  # * Disegna i dettagli della missione
  #--------------------------------------------------------------------------
  def draw_quest_details(line)
    draw_quest_location(t_line(line))
    draw_quest_npc(t_line(line + 1))
  end
  #--------------------------------------------------------------------------
  # * Mostra lo stato della missione (completata o obiettivo attuale)
  #--------------------------------------------------------------------------
  def draw_quest_task(line)
    quest.completed? ? draw_completed_message(line) : draw_actual_task(line)
  end
  #--------------------------------------------------------------------------
  # * Disegna il luogo di inizio missione
  #--------------------------------------------------------------------------
  def draw_quest_location(y)
    change_color(system_color)
    draw_text(0, y, contents_width, line_height, Vocab.quest_location)
    change_color(normal_color)
    draw_text(0, y, contents_width, line_height, quest.location, 2)
  end
  #--------------------------------------------------------------------------
  # * Disegna il nome del committente
  #--------------------------------------------------------------------------
  def draw_quest_npc(y)
    change_color(system_color)
    draw_text(0, y, contents_width, line_height, Vocab.quest_npc)
    change_color(normal_color)
    draw_text(0, y, contents_width, line_height, quest.npc, 2)
  end
  #--------------------------------------------------------------------------
  # * Disegna la descrizione della quest e restituisce il numero di righe
  # @param [Integer] line
  # @return [Integer]
  #--------------------------------------------------------------------------
  def draw_quest_description(line)
    y = t_line(line)
    change_color(normal_color)
    draw_bg_srect(0, y, contents_width, t_line(3))
    draw_formatted_text(0, y, contents_width, quest.description,3)
  end
  #--------------------------------------------------------------------------
  # * Disegna il testo di missione completata
  #--------------------------------------------------------------------------
  def draw_completed_message(line)
    change_color(power_up_color)
    backg = power_up_color
    backg.alpha = 100
    rect = Rect.new(0, t_line(line), contents_width, line_height * 2)
    backg2 = backg.clone
    backg2.alpha = 0
    contents.gradient_fill_rect(rect, backg2, backg, true)
    draw_text(rect, Vocab.quest_completed, 1)
  end
  #--------------------------------------------------------------------------
  # * Disegna le ricompense
  #--------------------------------------------------------------------------
  def draw_rewards
    lines = (quest.rewards.size / 2.0).ceil + 1
    y = t_line(max_lines - lines)
    draw_base_rewards(y)
  end
  #--------------------------------------------------------------------------
  # * Disegna le ricompense base (exp, oro e PA)
  #--------------------------------------------------------------------------
  def draw_base_rewards(y)
    unit = contents_width / 3
    change_color(normal_color)
    if quest.exp > 0
      text = sprintf('%d %s', quest.exp, 'esp.')
      draw_text(0, y, unit, line_height, text, 1)
    end
    if quest.gold > 0
      text = sprintf('%d %s', quest.gold, Vocab.currency_unit)
      x = unit
      draw_text(x, y, unit, line_height, text, 1)
    end
    if quest.ap > 0
      text = sprintf('%d %s', quest.ap, 'PA')
      x = unit * 2
      draw_text(x, y, unit, line_height, text, 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna gli oggetti per ricompensa
  #--------------------------------------------------------------------------
  def draw_item_rewards(y)
    width = contents_width / 2
    index = 0
    quest.rewards.each{|reward|
      x = index % 2 == 0 ? 0 : width
      yy = y + (index / 2 + line_height)
      draw_reward(reward, x, yy, width)
    }
  end
  #--------------------------------------------------------------------------
  # * Disegna la ricompensa
  # @param [Quest_Reward] reward
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def draw_reward(reward, x, y, width)
    if reward.is_item?
      draw_item_reward(reward, x, y, width)
    elsif reward.is_string?
      draw_text_reward(reward, x, y, width)
    else
      draw_text(x, y, width, line_height, '???')
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto della ricompensa
  # @param [Quest_Reward] reward
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def draw_item_reward(reward, x, y, width)
    draw_item_name(reward.get_item, x, y, true, width)
    if reward.number > 1
      change_color(normal_color)
      text = sprintf('x%d', reward.number)
      draw_text(x, y, width, line_height, text, 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna il testo di una ricompensa generica
  # @param [Quest_Reward] reward
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def draw_text_reward(reward, x, y, width)
    change_color(normal_color)
    draw_text(x, y, width, line_height, reward.get_string)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'obiettivo attuale della missione
  # @param [Integer] line
  #--------------------------------------------------------------------------
  def draw_actual_task(line)
    change_color(system_color)
    y = t_line(line)
    draw_text(0, y, contents_width, line_height, Vocab.quest_tasks, 1)
    draw_task(quest.actual_task, 0, y + line_height)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto della ricompensa
  # @param [Quest_Task] task
  # @param [Integer] x
  # @param [Integer] y
  # @return [Integer]
  #--------------------------------------------------------------------------
  def draw_task(task, x, y)
    enabled = !task.completed?
    draw_icon(task.check_icon, x, y, enabled)
    x += 24; width = contents_width - 24
    change_color(normal_color, enabled)
    t_height = draw_formatted_text(x, y, width, task.description)
    y += t_height
    draw_task_state(task, y)
    task.subtasks.each do |ttask|
      y= draw_task(ttask, x, y)
    end
    y
  end
  #--------------------------------------------------------------------------
  # * Disegna lo stato dell'obiettivo
  # @param [Quest_Task] task
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_task_state(task, y)
    return if task.condition.item_type == 0 # senza condizione
    return if task.condition.item_type == 5 # uno switch
    width = 72
    x = contents_width - width
    max = task.condition.max
    value = [task.state, max].min
    rate = value.to_f / max
    text = sprintf('%d/%d', value, max)
    draw_gauge(x, y, width, rate, hp_gauge_color1, hp_gauge_color2)
    draw_text(x, y, width, line_height, text, 1)
  end
  #--------------------------------------------------------------------------
  # * Disegna tutti gli obiettivi della quest
  #--------------------------------------------------------------------------
  def draw_all_tasks(y)
    quest.tasks.each{|task| y = draw_task(task, 0, y)}; y
  end
end

#==============================================================================
# ** Window_QuestRecord
#------------------------------------------------------------------------------
# Finestra che mostra le missioni completate/missioni sbloccate
#==============================================================================
class Window_QuestRecord < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione della finestra
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aggiorna il contenuto della finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(system_color)
    draw_text(0, 0, contents_width, line_height, Vocab.quest_record)
    completed = $game_system.completed_quest_number
    unlocked = $game_system.unlocked_quest_number
    text = sprintf('%d/%d', completed, unlocked)
    change_color(normal_color)
    draw_text(0, 0, contents_width, line_height, text, 2)
  end
end

#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party < Game_Unit
  alias h87_q_gain_i gain_item unless $@
  #--------------------------------------------------------------------------
  # * Alias metodo gain_item
  # @param [RPG::BaseItem] item
  # @param [Integer] amount
  # @param [Bool] include_equip
  #--------------------------------------------------------------------------
  def gain_item(item, amount, include_equip = false)
    check_all_item_tasks(item) if amount > 0 && $game_system.can_show_mission_popup?
    h87_q_gain_i(item, amount, include_equip)
  end
  #--------------------------------------------------------------------------
  # * Controlla tra le quest attive quale necessita dell'oggetto
  # @param [RPG::BaseItem] item
  #--------------------------------------------------------------------------
  def check_all_item_tasks(item)
    $game_system.active_quests.each{|quest|
      if quest.wait_for_item? && quest.requested_items.include?(item)
        $game_system.add_quest_update(quest)
      end
    }
  end
end

#==============================================================================
# ** Game_Variables
#==============================================================================
class Game_Variables
  alias_method :h87_q_change, :[]= unless $@
  #--------------------------------------------------------------------------
  # * Alias del metodo
  #--------------------------------------------------------------------------
  def []=(variable_id, value)
    check_all_variable_tasks(variable_id) if $game_system.can_show_mission_popup?
    h87_q_change(variable_id, value)
  end
  #--------------------------------------------------------------------------
  # * Controlla tra le quest attive quale necessita della variabile
  # @param [Integer] variable_id
  #--------------------------------------------------------------------------
  def check_all_variable_tasks(variable_id)
    $game_system.active_quests.each{|quest|
      if quest.wait_for_variable? && quest.requested_variables.include?(variable_id)
        $game_system.add_quest_update(quest)
      end
    }
  end
end

#==============================================================================
# ** Game_Switches
#==============================================================================
class Game_Switches
  alias_method :h87_q_change, :[]= unless $@
  #--------------------------------------------------------------------------
  # * Alias del metodo
  #--------------------------------------------------------------------------
  def []=(switch_id, value)
    check_all_switch_tasks(switch_id) if $game_system.can_show_mission_popup?
    h87_q_change(switch_id, value)
  end
  #--------------------------------------------------------------------------
  # * Controlla tra le quest attive quale necessita dello switch
  # @param [Integer] switch_id
  #--------------------------------------------------------------------------
  def check_all_switch_tasks(switch_id)
    $game_system.active_quests.each{|quest|
      if quest.wait_for_switch? && quest.requested_switches.include?(switch_id)
        $game_system.add_quest_update(quest)
      end
    }
  end
end

class Window_MissionPopup < Window_Base
    def initialize(x, y, width, height)

    end
    #--------------------------------------------------------------------------
    # * Restituisce la missione
    # @return [Quest]
    #--------------------------------------------------------------------------
    def quest; @quest; end

    def set_quest(quest, old_state)
      @quest = quest
      @old_state = old_state
      recalc_dimensions
      refresh
    end

    def recalc_dimensions
      lines = quest.tasks[@old_state].size + 1

    end

    def padding; 2; end

    
end

#~     QUESTS[13] = ['Trovare un ago in un pagliaio',155,496,497,'']
#~     TASKS[13] = ['Trova un ago da cucito.','Riporta l'ago trovato dalla gentil signora']
#~     DESCRIPTIONS[13] = ['Vecchiaccia','Luogo: Carpia',
#~     '                                    ',
#~     'La signora ha bisogno dell'ago per',
#~     'cucire il maglione a suo figlio.']
#~     REWARDS[13] = ['','200ESP','2500§']
#~     
#~     #La donna scomparsa
#~     #====================================================================
#~     QUESTS[14] = ['La donna scomparsa',156,496,497,'']
#~     TASKS[14] = ['Cerca la donna nelle Piramidi Gassosa','Ora che l'hai tratta in salvo, torna dal marito.']
#~     DESCRIPTIONS[14] = ['Marito Disperato','Luogo: Faide-Eiba',
#~     '                                    ',
#~     'La moglie di questo gentil signore',
#~     'si è persa nelle Piramidi Gassose.']
#~     REWARDS[14] = ['','Piffero','200ESP','100§']
#~     
#~     #Il malato
#~     #====================================================================
#~     QUESTS[15] = ['Il malato',157,496,497,'']
#~     TASKS[15] = ['Trova 10 Funghi!','Hai raccolto 10 funghi, portali subito dal malato!']
#~     DESCRIPTIONS[15] = ['Ragazza','Luogo: Faide-Eiba',
#~     '                                    ',
#~     'Un misterioso ragazzo trovato nelle',
#~     'Piramidi è gravemente ferito ed ha',
#~     'bisogno di cure mediche.',
#~     'Il bosco ad Est del Deserto è',
#~     'ricco di funghi!']
#~     REWARDS[15] = ['','???','400ESP']
#~     
#~     #Derattizzazione
#~     #====================================================================
#~     QUESTS[16] = ['Derattizzazione',158,496,497,'']
#~     TASKS[16] = ['Sali sulla nave e liberati dei topi']
#~     DESCRIPTIONS[16] = ['Capitano della Nave','Luogo: Porto di Fasbury',
#~     '                                    ',
#~     'La nave del capitano è infestata dai,',
#~     'topi, e lui ti ha chiesto di',
#~     'ripulirla al posto suo.']
#~     REWARDS[16] = ['','Scanner','Integratore','300ESP']
#~     
#~     #Svendita al Negozio
#~     #====================================================================
#~     QUESTS[17] = ['Svendita al Negozio',159,496,497,'']
#~     TASKS[17] = ['Trova 20 Carote, 10 Pozioni Ottime, 15 Pelli d'Animale e 4 Antidoti.']
#~     DESCRIPTIONS[17] = ['Thomas','Luogo: Negozio di Balthazar',
#~     '                                    ',
#~     'Il negozio di Thomas è sull'orlo del',
#~     'fallimento. Procurati i materiali',
#~     'necessari per poter permettergli di',
#~     'tornare in affari!']
#~     REWARDS[17] = ['','2000§','500ESP','150PA']
#~     
#~     #Svendita al Negozio
#~     #====================================================================
#~     QUESTS[18] = ['Lavoro come minatore',160,496,497,'']
#~     TASKS[18] = ['Vai nelle miniere e trova 10 pezzi di Carbone.',
#~     'Te ne restano ancora 9',
#~     'Te ne restano 8',
#~     'Te ne restano 7',
#~     'Te ne restano 6',
#~     'Sei a metà! Te ne restano ancora 5',
#~     'Te ne restano 4',
#~     'Te ne restano soltanto 3!',
#~     'Te ne restano 2',
#~     'Ancora l'ultimo e abbiamo finito',
#~     'Perfetto! Ora torna da Marco!']
#~     DESCRIPTIONS[18] = ['Marco','Luogo: Farse Sotterranea',
#~     '                                    ',
#~     'A Farse c'è una carenza di materie',
#~     'prime per riscaldarsi, e ti hanno',
#~     'chiesto di procurarti 10 pepite di',
#~     'carbone dalla miniera.']
#~     REWARDS[18] = ['','2000§','1500ESP','250PA']

#~     #Il quadro rubato
#~     #====================================================================
#~     QUESTS[19] = ['Il quadro smarrito',161,496,497,'']
#~     TASKS[19] = [
#~     'Vai nel PUB e parla con Luca',
#~     'Prbabilmente, Gildo il mercante d'armi sa qualcosa sui malviventi...',
#~     'Trova il passaggio segreto in un giardino della città!',
#~     'Hai trovato il buco, scendi per entrare nelle fogne!',
#~     'Segui le fogne per trovare il covo dei ladri.',
#~     'Torna dal vecchio e consegnagli il quadro!']
#~     DESCRIPTIONS[19] = ['Intenditore d'arte','Luogo: Balthazar',
#~     '                                    ',
#~     'Un vecchio cultore d'arte di Balthazar',
#~     'aspetta un quadro di valore che non',
#~     'gli è mai arrivato. Cerca il quadro e',
#~     'lui ti ricompenserà adeguatamente!']
#~     REWARDS[19] = ['Bestiario','1000§','1300ESP','150PA']
#~     
#~     #Controllo del ponte
#~     #====================================================================
#~     QUESTS[20] = ['Controllo Edile',162,496,497,'']
#~     DESCRIPTIONS[20] = ['Soldato di Baltimora','Luogo: Sirenas',
#~     '                                    ',
#~     'Questo coraggioso soldato vuole',
#~     'solo tornare a casa, ma la via per',
#~     'la sua città è distrutta. Controlla',
#~     'per lui lo stato del ponte!']
#~     TASKS[20] = ['Dirigiti a Nord per il Ponte per Alessandria.',
#~     'Parla con il dirigente dei lavori per avere notizie.',
#~     'Torna dal soldato per dargli la pessima notizia.']
#~     REWARDS[20] = ['','200§','100ESP','50PA']
#~     
#~     #Ricerca in fuga!
#~     #====================================================================
#~     QUESTS[21] = ['Ricerca in fuga!',163,496,497,'']
#~     DESCRIPTIONS[21] = ['Mago','Luogo: Pigwarts',
#~     '                                    ',
#~     'L'esperimento di questo mago, è',
#~     'letteralmente fuggito! Trova tutti',
#~     'i fuochi fatui. Attento: se ti',
#~     'avvicini troppo, fuggiranno!']
#~     TASKS[21] = ['Trova i 5 Fuochi Fatui a Pigwarts.',
#~     'Torna dal mago e restituisci i fuochi!']
#~     REWARDS[21] = ['','Uovo Mistico','300ESP']
#~     
#~     #Anaconde
#~     #====================================================================
#~     QUESTS[22] = ['Rettili Striscianti',189, 496,497,'']
#~     DESCRIPTIONS[22] = ['Vecchio','Luogo: Faide-Eiba',
#~     '                                    ',
#~     'Le Anaconde si stanno moltiplicando,',
#~     'è ora di ridurre la popolazione delle',
#~     'Piramidi Gassose!.']
#~     TASKS[22] = ['Uccidi 5 Anaconde (\\V[136] sconfitte).',
#~     'Hai completato l'obiettivo! Torna dal vecchio.']
#~     REWARDS[22] = ['','Anello Boreale','400ESP','50PA']
#~     
#~     #Affari al negozio
#~     #====================================================================
#~     QUESTS[23] = ['In cerca d'affari',165, 496,497,'']
#~     DESCRIPTIONS[23] = ['Thomas','Luogo: Balthazar',
#~     '                                    ',
#~     'Thomas ti ha chiesto di incontrare',
#~     'un prestigioso mercante a Monferras',
#~     'per concludere un affare.']
#~     TASKS[23] = ['Parla con il mercante Elvis, a Monferras.',
#~     'Recupera 5 Pietre Runiche dai mostri nelle Rovine di Adele.',
#~     'Bravo! Ora consegna le Rune ad Elvis.',
#~     'Torna da Thomas con la notizia dell'affare.']
#~     REWARDS[23] = ['','300PA','2000§','1000ESP']
#~     
#~     #Affari al negozio
#~     #====================================================================
#~     QUESTS[24] = ['Esercitazione',166, 496,497,'']
#~     DESCRIPTIONS[24] = ['C. Maggiore','Luogo: Castello di Florea',
#~     '                                    ',
#~     'Il Caporal Maggiore del Castello di',
#~     'Florea ti ha chiesto di partecipare',
#~     'ad una delle sue esercitazioni.',
#~     'Raduna tutti i soldati volontari!']
#~     TASKS[24] = ['Parla con i soldati Smith all'Armeria, Ryan alle Prigioni e Harrison alla mensa.',
#~     'Ti restano da chiamare altri 2 soldati!',
#~     'Ti resta l'ultimo soldato!',
#~     'Torna dal Caporal Maggiore per cominciare la battaglia!']
#~     REWARDS[24] = ['','Bevanda dell'Eroe','150PA','200ESP']
#~     
#~     #Le Noci
#~     #====================================================================
#~     QUESTS[25] = ['Frutta Secca',167, 496,497,'']
#~     DESCRIPTIONS[25] = ['Sorella Bislacca','Luogo: Chiesa di Balthazar',
#~     '                                    ',
#~     'La Sorella Bislacca ha bisogno delle',
#~     'noci per preparare il pranzo di',
#~     'frutta secca di fine anno.',
#~     'Puoi raccoglierle dai Golem.']
#~     TASKS[25] = ['Raccogli 5 Noci.',
#~     'Torna dalla suora!']
#~     REWARDS[25] = ['','Bandana','300PA','1500ESP']
#~     
#~     #Il mostro nel bosco
#~     #====================================================================
#~     QUESTS[26] = ['Pericolo nel Bosco',168, 496,497,'']
#~     DESCRIPTIONS[26] = ['Casalinga','Luogo: Farse',
#~     '                                    ',
#~     'Nel bosco vicino Farse, si nas-',
#~     'conde un pericoloso mostro.',
#~     'Sarai tu il prode che libererà',
#~     'il villaggio dal pericolo?']
#~     TASKS[26] = ['Cerca il mostro nel Bosco.',
#~     'L'hai sconfitto! Ora torna a Farse per riscuotere la ricompensa.']
#~     REWARDS[26] = ['','Libro sull'Alchimia Vol.1','Etere','1500ESP']
#~     
#~     #Pagine smarrite
#~     #====================================================================
#~     QUESTS[27] = ['Libro Strappato',171, 496,497,'']
#~     DESCRIPTIONS[27] = ['Ragazza','Luogo: Adele',
#~     '                                    ',
#~     'Questa dolce fanciulla ha perso le',
#~     'pagine del suo libro nelle rovine di',
#~     'Adele. Trovale!']
#~     TASKS[27] = ['Cerca le pagine nelle Rovine di Adele',
#~     'Hai trovato tutte le pagine! Torna a portargliele.']
#~     REWARDS[27] = ['','Anello cromato','4000ESP','300PA']
#~     
#~     #I Briganti
#~     #====================================================================
#~     QUESTS[28] = ['Libera i Monti',169, 496,497,'']
#~     DESCRIPTIONS[28] = ['Guardia','Luogo: Monferras',
#~     '                                    ',
#~     'Un gruppo di briganti assale i viag-',
#~     'giatori che passano per i Monti',
#~     'Ciclamini. Stanali e sbarazzatene!']
#~     TASKS[28] = ['Cerca i briganti ai Monti Ciclamini',
#~     'Hai sconfitto i briganti! Segui le orme per trovare il loro covo.',
#~     'Sconfiggi il capo!','Hai liberato i monti, anche se il capo è scappato.']
#~     REWARDS[28] = ['','6000§','5000ESP','300PA']
#~     
#~     #I Corvi
#~     #====================================================================
#~     QUESTS[29] = ['Strade Sicure',172, 496,497,'']
#~     DESCRIPTIONS[29] = ['Guardia','Luogo: Adele',
#~     '                                    ',
#~     'C'è un sovraffollamento di pennuti',
#~     'nelle zone intorno ad Adele. Uccidi',
#~     '30 Corvi e torna dalla guardia.']
#~     TASKS[29] = ['Uccidi 30 corvi (\\v[125] su 30 sconfitti)',
#~     'Hai ucciso tutti i corvi! Torna dalla guardia per la ricompensa.']
#~     REWARDS[29] = ['','Orecchino della Pace','3000§','3000ESP','250PA']
#~     
#~     #Mamma perduta
#~     #====================================================================
#~     QUESTS[30] = ['Cercasi Mamma',173, 496,497,'']
#~     DESCRIPTIONS[30] = ['Sashimi','Luogo: Yugure',
#~     '                                    ',
#~     'Trova la madre della bambina. Prova',
#~     'a chiedere in giro, nel villaggio.']
#~     TASKS[30] = ['Trova la mamma di Sashimi in città',
#~     'La madre di Sashimi è scomparsa. Prova a cercarla fuori dal villaggio',
#~     'Hai trovato la donna sui monti e l'hai tratta in salvo. Torna al villaggio']
#~     REWARDS[30] = ['','Mithrilx3','1000§','4000ESP','300PA']
#~     
#~     #Il truffatore
#~     #====================================================================
#~     QUESTS[31] = ['Materie prime',170, 496,497,'']
#~     DESCRIPTIONS[31] = ['Samurai misterioso','Luogo: Yugure',
#~     '                                    ',
#~     'Un samurai ti ha chiesto di trovargli',
#~     'alcuni materiali per provare la tua',
#~     'forza.']
#~     TASKS[31] = ['Raccogli 15 Pelli d'Animale e 5 Radici d'Igromo.',
#~     'Perfetto, ora torna dal misterioso samurai!',
#~     'Trova un lingotto d'acciaio e portalo dal samurai!',
#~     'Porta il lingotto dal samurai.',
#~     'L'uomo è sparito senza darti la ricompensa! Trovalo!']
#~     REWARDS[31] = ['','????','1000§','2000ESP','500PA']
#~     
#~     #Il truffatore
#~     #====================================================================
#~     QUESTS[32] = ['Il Talismano',174, 496,497,'']
#~     DESCRIPTIONS[32] = ['Mago viandante','Luogo: Yugure',
#~     '                                    ',
#~     'Un mago donnaiolo ti ha chiesto di',
#~     'ritirare un oggetto al tempio di',
#~     'Yugure e di consegnarglielo.']
#~     TASKS[32] = ['Ritira un oggetto al Tempio di Yugure.',
#~     'Trova e porta 5 cristalli di Lyrium per completare l'opera!',
#~     'Porta il Lyrium al Tempio di Yugure.',
#~     'Torna dal mago a riportargli l'oggetto.']
#~     REWARDS[32] = ['','1000§','3000ESP','600PA']
#~     
#~     #Vulcano Kaji
#~     #====================================================================
#~     QUESTS[33] = ['Pericolo al vulcano',175, 496,497,'']
#~     DESCRIPTIONS[33] = ['Donna di Yugure','Luogo: Monte Kumo',
#~     '                                    ',
#~     'Una donna molto misteriosa, ti ha',
#~     'chiesto di uccidere l'adepto del',
#~     'fuoco che si trova sulla superficie',
#~     'del Vulcano Kaji.']
#~     TASKS[33] = ['Dirigiti al vulcano Kaji e trova il mostro.',
#~     'Hai sconfitto la creatura, torna dalla donna a Yugure!']
#~     REWARDS[33] = ['','Libro sull'Alchimia Vol.2','2000§','2000ESP','500PA']
#~     
#~     #Cavalluccio
#~     #====================================================================
#~     QUESTS[34] = ['Cavallo selvaggio',176, 496,497,'']
#~     DESCRIPTIONS[34] = ['Baffo','Luogo: Balthazar',
#~     '                                    ',
#~     'Un corriere ti ha chiesto di trovare',
#~     'il suo prezioso cavallo smarrito.',
#~     'Se lo troverai, potrà portarti',
#~     'ovunque desideri.']
#~     TASKS[34] = ['Cerca il cavallo nel bosco.',
#~     'Hai ritrovato il cavallo, torna a Balthazar!']
#~     REWARDS[34] = ['','2000§','1000ESP','400PA']
#~     
#~     #Medaglione
#~     #====================================================================
#~     QUESTS[35] = ['Il Medaglione',177, 496,497,'']
#~     DESCRIPTIONS[35] = ['Tu','Luogo: Nevandra',
#~     '                                    ',
#~     'Hai trovato un misterioso medaglione',
#~     'all'interno di una dimensione sco-',
#~     'nosciuta. Indaga sulla sua natura,',
#~     'e cerca di capire come funziona!']
#~     TASKS[35] = ['Incontra il vecchio Jarvas, a Ovest di Nevandra.',
#~     'La serva ti ha chiesto di portarle un Nucleo Dimensionale.',
#~     'Porta il Nucleo Dimensionale dalla serva di Jarvas.']
#~     REWARDS[35] = ['','???','4000ESP','300PA']
#~     
#~     #Contadino
#~     #====================================================================
#~     QUESTS[36] = ['Fornitura',178, 496,497,'']
#~     DESCRIPTIONS[36] = ['Contadino','Luogo: Nevandra',
#~     '                                    ',
#~     'Un contadino ti ha chiesto di procu-',
#~     'rargli delle forniture di verdura da',
#~     'poter vendere al castello.',
#~     'Trovale e portagliele!']
#~     TASKS[36] = ['Raccogli 15 Carote, 13 Cipolle, 10 Patate e 7 Arance',
#~     'Porta la merce al contadino di Nevandra!']
#~     REWARDS[36] = ['','4000§','5000ESP','300PA']
#~     
#~     #Ammazzayeti
#~     #====================================================================
#~     QUESTS[37] = ['Stagione della caccia',179, 496,497,'']
#~     DESCRIPTIONS[37] = ['Soldato','Luogo: Nevandra',
#~     '                                    ',
#~     'Il capitano delle guardie ti ha chi-',
#~     'esto di dare la caccia a Yeti e',
#~     'Licantropi che si aggirano intorno',
#~     'alla città.']
#~     TASKS[37] = ['Elimina 10 Yeti (\\V[132]) e 20 Licantropi (\\V[133]).',
#~     'Torna dalla guardia per completare la missione.']
#~     REWARDS[37] = ['','3000§','4000ESP','500PA']
#~     
#~     #Morto a Nevandra
#~     #====================================================================
#~     QUESTS[38] = ['Frammento di Lacrima',180,496,497,'']
#~     DESCRIPTIONS[38] = ['???','Luogo: Nevandra',
#~     '                                    ',
#~     'Hai trovato il cadavere di un soldato',
#~     'in un angolo di Nevandra, scopri chi',
#~     'è stato e perchè lo abbia fatto,']
#~     TASKS[38] = ['Chiedi informazioni alla magicheria di Nevandra',
#~     'Cerca il sospettato alla locanda.',
#~     'Vai al porto e scova il sospetto.',
#~     'L'hai trovato, è ora di sistemarlo!']
#~     REWARDS[38] = ['','3000ESP','Anello di Pigwarts']
#~     
#~     #Regina di Nevandra
#~     #====================================================================
#~     QUESTS[39] = ['La Regina di Nevandra',183, 496,497,'']
#~     DESCRIPTIONS[39] = ['Capitano','Luogo: Nevandra (Dogana)',
#~     '                                    ',
#~     'La regina ha chiuso tutte le vie di',
#~     'comunicazione con l'esterno del paese',
#~     'e si è chiusa nel castello. Fai luce',
#~     'su questo mistero!']
#~     TASKS[39] = ['Incontrati con Talos alla locanda, di giorno.',
#~     'Talos ti aspetta di notte fuori la locanda.',
#~     'Forza l'entrata segreta al castello!',
#~     'È il momento di entrare.',
#~     'Sei riuscito a intrufolarti!',
#~     'Cerca un modo per arrivare dalla regina.',
#~     'Vai dal comandante per prendere la chiave della mensa.',
#~     'Entra nella mensa e cerca della carne, di qualsiasi tipo.',
#~     'Insegui quel cane!',
#~     'Ben fatto, ora parla con il maggiordomo.',
#~     'Finalmente puoi andare dalla regina',
#~     'Insegui e cattura la regina!',
#~     'È il momento di affrontare la (falsa?) regina!']
#~     REWARDS[39] = ['','5000ESP','500PA','Nettare degli dei']
#~     
#~     #Carillon
#~     #====================================================================
#~     QUESTS[40] = ['Il carillon',184, 496,497,'']
#~     DESCRIPTIONS[40] = ['Cittadino','Luogo: Porto di Northur',
#~     '                                    ',
#~     'Questo brav'uomo ha perso il suo',
#~     'gingillo di famiglia. Riportaglielo',
#~     'se ti capita di ritrovarlo.']
#~     TASKS[40] = ['Trova un carillon.',
#~     'Porta il carillon al legittimo proprietario.']
#~     REWARDS[40] = ['','4000ESP','500PA','???']
#~     
#~     #Ladri
#~     #====================================================================
#~     QUESTS[41] = ['Pulizie notturne',185, 496,497,'']
#~     DESCRIPTIONS[41] = ['Guardia','Luogo: Castello di Nevandra',
#~     '                                    ',
#~     'Per la sicurezza della città, sei',
#~     'stato assoldato per sconfiggere i',
#~     'gruppi di ladre che si aggirano in',
#~     'città durante la notte.']
#~     TASKS[41] = ['Trova e sconfiggi tutti i ladri (\\V[134] su 5).',
#~     'Torna dalla guardia per riscuotere la ricompensa.']
#~     REWARDS[41] = ['','2000ESP','8000§','Bracciale purpureo']
#~     
#~     #Ronin
#~     #====================================================================
#~     QUESTS[42] = ['Ronin',186, 496,497,'']
#~     DESCRIPTIONS[42] = ['Samurai','Luogo: Nevandra',
#~     '                                    ',
#~     'Un ronin pericoloso si aggira tra le',
#~     'zone di Nevandra. Trovalo e catturalo']
#~     TASKS[42] = ['Scova il ronin fuggiasco.']
#~     REWARDS[42] = ['','Variabile']
#~     
#~     #Adepto dei ghiacci
#~     #====================================================================
#~     QUESTS[43] = ['Più freddo del freddo',188, 496,497,'']
#~     DESCRIPTIONS[43] = ['Maga di corte','Luogo: Nevandra',
#~     '                                    ',
#~     'La maga ti ha promesso un libro molto',
#~     'utile per le tue avventure, in cambio',
#~     'della dipartita con un feroce mostro.',
#~     'Trovalo e sconfiggilo!']
#~     TASKS[43] = ['Trova l'Adepto del ghiaccio e sconfiggilo.',
#~     'Hai sconfitto il mostro! Torna dalla maga!']
#~     REWARDS[43] = ['','Libro sull'Alchimia Vol.3','3000§','3000ESP','500PA']
#~     
#~     #Ricerca con rilevatore
#~     #====================================================================
#~     QUESTS[44] = ['La perla più preziosa',192, 496,497,'']
#~     DESCRIPTIONS[44] = ['Mercante','Luogo: Sirenas',
#~     '                                    ',
#~     'Il mercante ha perso la sua perla',
#~     'Preziosa. Usa il Rilevatore a Sirenas',
#~     'per trovare l'oggetto smarrito.']
#~     TASKS[44] = ['Usa il Rilevatore a Sirenas e trova la posizione della perla.',
#~     'Trova l'anello della ragazza, così da farti dare la perla.',
#~     'Trova l'ocarina del vecchio per farti dare l'anello della ragazza.',
#~     'Ben fatto! Ora porta l'ocarina dal vecchio.',
#~     'Restituisci l'anello alla ragazza per farti dare in cambio la perla.',
#~     'Ora riporta la perla dal legittimo proprietario per completare la missione!']
#~     REWARDS[44] = ['','Anello di legno','5000§','5000ESP']
#~     
#~     #Gigadrago #confrat.
#~     #====================================================================
#~     QUESTS[45] = ['Il Gigadrago (CC)',193, 496,497,'']
#~     DESCRIPTIONS[45] = ['Confraternita','dei Cacciatori',
#~     '                                    ',
#~     'Per entrare a far parte del gruppo,',
#~     'dovrai uccidere un feroce e pericoloso',
#~     'Gigadrago.']
#~     TASKS[45] = ['Vai alla foresta di Elmore e cerca il Gigadrago.',
#~     'Hai sconfitto il Gigadrago! (o quasi). Torna da Hammer.']
#~     REWARDS[45] = ['','N/A']
#~     
#~     #Formaggio
#~     #====================================================================
#~     QUESTS[46] = ['Scorte di formaggio',194, 496,497,'']
#~     DESCRIPTIONS[46] = ['Madre premurosa','Luogo: Nevandra',
#~     '                                    ',
#~     'Una madre premurosa ti ha chiesto di,',
#~     'portare del formaggio al figlio che è',
#~     'di guardia alla dogana di Elmore/Nevandra.']
#~     TASKS[46] = ['Vai alla dogana di Elmore/Nevandra e parla con la guardia vicino al fuoco.',
#~     'Ottimo, ora torna dalla signora!']
#~     REWARDS[46] = ['','Oggetto a caso','1000ESP','2000§']
#~     
#~     #Namfex #confrat.
#~     #====================================================================
#~     QUESTS[47] = ['Pianta Namfex (CC)',195, 496,497,'']
#~     DESCRIPTIONS[47] = ['Confraternita','dei Cacciatori',
#~     '                                    ',
#~     'Per compiere la missione, ti basta,',
#~     'uccidere la feroce pianta Namfex, che',
#~     'si trova nella Selva di Salici.']
#~     TASKS[47] = ['Vai alla Selva di Salici (Sirenas), trova la pianta Namfex e uccidila.',]
#~     REWARDS[47] = ['','N/A']
#~     
#~     #Lullaby #confrat.
#~     #====================================================================
#~     QUESTS[48] = ['Lullaby (CC)',196, 496,497,'']
#~     DESCRIPTIONS[48] = ['Confraternita','dei Cacciatori',
#~     '                                    ',
#~     'Uccidi il mostro Lullaby che si trova,',
#~     'nelle miniere di Elmore, vicino Farse.']
#~     TASKS[48] = ['Trova e uccidi Lullaby.',]
#~     REWARDS[48] = ['','N/A']