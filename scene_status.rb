#==============================================================================
# ** StatusSettings
#------------------------------------------------------------------------------
# Impostazioni della finestra degli status
#==============================================================================
module StatusSettings

  # Parametri mostrati nella finestra "Caratteristiche". Dev'essere messo in
  # un array a parte perché gli hash non vengono ordinati in Ruby 1.8 🤔
  DISPLAYED_STATS = [
      :mhp, :mmp, :mag, :atk, :def, :spi, :agi, :cri, :hit, :eva,
      :cri_dmg, :odds, :res, :mdmg, :mp_cost_rate,
      :buff_modificator, :debuff_modificator,
      :state_inf_per, :state_inf_dur, :vampire_rate,
      :physical_reflect, :heal_rate,
      :anger_incr, :initial_anger,
      :anger_kill, :anger_turn,
      :win_hp, :win_mp, :sinergic_increase, :sin_duration_bonus,
      :hp_on_guard_value, :mp_on_guard_value, :fu_on_guard_value
  ]

  # L'elenco delle difese agli stati alterati mostrabili
  DSTATES = [1, 2, 3, 4, 5, 6, 7, 8, 79, 94]


  STATS = {
      :mhp => {:text => 'PV massimi',
               :description => 'Punti vita massimi. Rappresentano la vita dell\'eroe ed i danni che|può subire prima di andare KO.'},
      :mmp => {:text => 'PM massimi', :condition => :mp_gauge?,
               :description => 'Punti mana massimi. Rappresentano l\'energia|a disposizione per utilizzare le magie e abilità.'},
      :atk => {:text => 'Attacco',
               :description => 'La potenza d\'attacco. Influisce sul danno del comando Attacca e le|abilità, e la probabilità di infliggere stati alterati con queste'},
      :def => {:text => 'Difesa',
               :description => 'La resistenza ai danni. Maggiore è la difesa, meno|danni subirai e meno probabilità avrai di subire effetti negativi.'},
      :spi => {:text => 'Spirito',
               :description => 'La forza spirituale. Maggiore è il tuo spirito, più danni infliggerai con|le magie e più probabilità avrai di infliggere stati alterati.'},
      :agi => {:text => 'Velocità',
               :description => 'La velocità d\'azione.|Influenza la velocità di caricamento della barra ATB.'},
      :cri => {:text => 'Critici',
               :description => 'La probabilità di causare danni critici.|I danni critici fanno più male dei danni normali.',
               :format => '%d%%', :default => 4},
      :hit => {:text => 'Mira', :default => 95,
               :description => 'Rappresenta la probabilità di mandare a segno un colpo.|Oltre il 100%, riduce l\'evasione dell\'avversario.',
               :format => '%d%%'},
      :eva => {:text => 'Evasione',
               :description => 'Rappresenta la probabilità di schivare gli attacchi e le abilità fisiche.',
               :format => '%d%%', :default => 5},
      :cri_dmg => {:text => 'Danno critico',
                   :description => 'Rappresenta il moltiplicatore di danno quando effettui colpi critici.',
                   :format => '%gx', :default => 3},
      :odds => {:text => 'Aggro', :default => 20,
                :description => 'Rappresenta l\'odio iniziale quando comincia la battaglia.'},
      :res => {:text => 'Resistenza',
               :description => 'Determina la resistenza alle magie. 100% di resistenza ti rende|immune.',
               :format => '%+d%%',
               :default => 0},
      :mdmg => {:text => 'Molt. magico',
                :description => 'Determina il moltiplicatore dei danni delle magie.',
                :format => '%+d%%',
                :default => 0},
      :mp_cost_rate => {:text => 'Costo abilità',
                        :description => 'Rappresenta il rateo di quanti PM, Furia o PV che consumi|utilizzando le abilità.',
                        :format => '%gx',
                        :formula => '((x-1)*100).to_i + 1',
                        :default => 1,
                        :reverse => true},
      :state_inf_per => {:text => 'Bonus stati',
                         :description => 'Bonus per la probabilità di infliggere stati negativi ai nemici.',
                         :format => '%+d%%',
                         :default => 0},
      :normal_attack_bonus => {:text => 'Danno att. normale',
                               :description => 'Rappresenta il danno causato con l\'attacco normale.',
                               :format => '%d%%', :default => 100, :formula => 'x*100'},
      :state_inf_dur => {
          :text => 'Bonus durata stati',
          :description => 'Bonus durata in turni per gli stati che causa ad|alleati e nemici.',
          :format => '%+d',
          :default => 0},
      :buff_modificator => {:text => 'Bonus durata buff',
                            :description => 'Bonus durata turni per stati positivi attivati.',
                            :format => '%+d',
                            :default => 0},
      :debuff_modificator => {:text => 'Difesa durata debuff',
                              :description => 'Bonus che diminuisce la durata in turni degli stati|negativi subiti.',
                              :format => '%+d',
                              :default => 0,
                              :reverse => true},
      :vampire_rate => {:text => 'Assorbimento danni',
                        :description => 'Rappresenta la cura che ottieni sui danni che infliggi con attacchi|ravvicinati (spade, lance, pugnali...).',
                        :format => '%d%%',
                        :default => 0,
                        :formula => '(x*100).to_i'},
      :physical_reflect => {:text => 'Contrattacco fisico',
                            :description => 'Rappresenta la percentuale di danni che viene respinta al nemico|quando vieni colpito da un attacco fisico ravvicinato.',
                            :format => '%d%%',
                            :formula => '(x*100).to_i'},
      :anger_incr => {:text => 'Carica Furia', :condition => :charge_gauge?, :default => 10,
                      :description => 'Rappresenta la Furia che ottieni ad ogni attacco.'},
      :anger_kill => {:text => 'Furia su uccisione', :condition => :charge_gauge?,
                      :description => 'La Furia che ottieni mettendo KO un nemico.'},
      :initial_anger => {:text => 'Furia iniziale', :condition => :charge_gauge?,
                         :description => 'La Furia minima che possiederai ad inizio battaglia.'},
      :anger_turn => {:text => 'Incremento Furia', :condition => :charge_gauge?,
                      :description => 'La Furia che otterrai automaticamente ad ogni turno.'},
      :win_hp => {:text => 'Cura su Vittoria',
                  :description => 'I PV che recupererai vincendo le battaglie.'},
      :win_mp => {:text => 'Ricarica su Vittoria', :default => 0, :condition => :mp_gauge?,
                  :description => 'I PM che recupererai vincendo le battaglie.'},
      :mag => {:text => 'Furia Massima', :default => 100, :condition => :charge_gauge?,
               :description => 'Rappresenta La Furia massima che può accumulare.|Questa serve per utilizzare le abilità e si carica attaccando.'},
      :sinergic_increase => {:text => 'Incr. Sinergia', :default => H87_SINERGIC::DEFAULT_INCREASE,
                             :description => 'Rappresenta l\'incremento della Sinergia|quando si esegue una azione come attaccare o curare.'},
      :sin_duration_bonus => {:text => 'Durata Sinergia', :default => 0, :format => '%+g%%', :formula => 'x*100',
                              :description => 'Allunga la durata della Sinergia quando attiva,|in percentuale'},
      :heal_rate => {:text => 'Capacità Guarigione', :default => 100, :format => '%d%%', :formula => '(x*100).to_i',
                     :description => "Determina quanti PV e PM vengono ripristinati|in proporzione alle cure ricevute da abilità ed oggetti."},
      :hp_on_guard_value => {:text => "PV curati con Difendi", :condition => :hp_on_guard?,
                      :description => "Questo parametro si riferisce a quanti PV verranno curati quando utilizzi il comando Difendi."},
      :mp_on_guard_value => {:text => "PM caricati con Difendi", :condition => :mp_on_guard?,
                      :description => "Questo parametro si riferisce a quanti PM verranno caricati quando utilizzi il comando Difendi."},
      :fu_on_guard_value => {:text => "Furia con Difendi", :condition => :fu_on_guard?,
                      :description => "Questo parametro si riferisce a quanta Furia otterrai quando utilizzi il comando Difendi."},


  }

  DISPLAYER_CAPABILITIES = [
    {:capability => :charge_gauge?, :text => 'Uso della Furia', :description => '\n[0] può padroneggiare la sua Furia, usandola come energia per determinate|abilità fisiche. Inoltre può caricare la Furia attaccando.'},
    {:capability => :ranged_attack?, :text => 'Attacchi a distanza', :description => 'Gli attacchi di \n[0] possono colpire i nemici nelle retrovie.'},
    {:capability => :has_last_chance?, :text => 'Ultima Chance', :description => 'Solo una volta a battaglia, se \n[0] riceve un colpo fatale resta con 1PV invece di morire.'},
    {:capability => :pharmacology, :text => 'Farmacista', :description => 'Gli oggetti utilizzati da \n[0] curano il doppio.'},
    {:capability => :can_parry?, :text => 'Contrattacco schivata', :description => 'Se \n[0] evita un attacco fisico, il nemico subisce un contrattacco.'},
    {:capability => :avoid_defense?, :text => 'Penetrazione', :description => 'Gli attacchi normali di \n[0] oltrepassano le difese del bersaglio.'},
    {:capability => :super_guard, :text => 'Superdifesa', :description => 'Quando \n[0] usa il comando Difendi, subisce 1/4 di danni.'},
    {:capability => :apeiron?, :text => 'Apeiron', :description => 'I PV massimi di \n[0] possono superare i 9999 e i restanti parametri i 999.'},
    {:capability => :virile?, :text => 'Virile', :description => 'Quando \n[0] è nel gruppo, gli oggetti spinti si spostano al doppio della velocità.'},
    {:capability => :show_atb?, :text => 'Mostra ATB nemici', :description => 'Se \n[0] è nel gruppo, riesci a vedere la barra di caricamento dei nemici.'},
    {:capability => :scassinatore?, :text => 'Scassinatore', :description => 'Se \n[0] è nel gruppo, puoi scassinare serrature bloccate.'},
    {:capability => :mechanic?, :text => 'Meccanico', :description => 'Se \n[0] è nel gruppo, puoi riparare cose rotte.'},
    {:capability => :can_jump_longer?, :text => 'Salto lungo', :description => 'Se \n[0] è nel gruppo, puoi saltare un blocco in più.'},
    {:capability => :two_swords_style, :text => 'Due armi', :description => '\n[0] può equipaggiare ed usare due armi.'},
    {:capability => :autoscan?, :text => 'Saggezza', :description => 'Se \n[0] è nel gruppo, puoi conoscere i punti deboli dei nemici quando li selezioni.'},
    {:capability => :state_guard, :text => 'Difesa Zen', :description => 'Mentre \n[0] si difede, dimezza le probabilità di essere afflitto da stati negativi.'}
  ]

  # se true, mostra la differenza dal parametro a quello base,
  # se false, mostra il parametro base (senza equip, come mamma l'ha fatto)
  DRAW_PARAM_DIFFERENCE = false
  # File bitmap dei ruoli (in Graphics\System)
  ROLES_IMG = 'Roles'
  # Comandi dello status
  COMMANDS = [:review, :params, :role, :states]
  # Vocaboli dei comandi
  COMMAND_VOCABS = {
      :review => 'Generale',
      :params => 'Caratteristiche',
      :role => 'Ruolo',
      :states => 'Condizioni',
      :stats => 'Statistiche',
  }
  # Testo mostrato nei parametri quando c'è un bonus danni
  ELEMENT_AMPLIFIER_VOCAB = "Bonus danni da %s"
  ELEMENT_AMPLIFIER_HELP = "\\n[0] causa il %d%% danni in più con l'elemento %s."
  # Colori dei ruoli (non utilizzati)
  ROLE_COLORS = {
      :damg => Color.new(234, 71, 2),
      :heal => Color.new(79, 234, 2),
      :tank => Color.new(2, 165, 234),
      :nuke => Color.new(234, 2, 161),
      :buff => Color.new(2, 210, 234),
      :ctrl => Color.new(234, 229, 2)
  }
  # Nomi dei ruoli (non utilizzati)
  ROLE_NAMES = {
      :damg => 'Attaccante',
      :heal => 'Guaritore',
      :tank => 'Difensore',
      :nuke => 'Incantatore',
      :buff => 'Supporto',
      :ctrl => 'Controllo'
  }
  # Elenco delle classi dei personaggi, per caricare il file del ruolo
  ACTOR_CLASSES = {
      1 => :templar,
      2 => :mage,
      3 => :swordsman,
      4 => :battlemaster,
      5 => :archer,
      6 => :healer,
      7 => :vampire,
      8 => :gambler,
      9 => :warrior,
      10 => :arcanist,
      12 => :rogue,
      11 => :alchemist,
      15 => :bard,
      13 => :elementalist,
      14 => :avenger,
      16 => :knight
  } # non rimuovere la parentesi!
  # Ordine dei ruoli nella bitmap (ma non serve più!)
  ROLE_TAG_ORDER = {
      :damg => 0,
      :heal => 1,
      :tank => 2,
      :nuke => 3,
      :buff => 4,
      :ctrl => 5
  } # non rimuovere la parentesi!

  SHOWED_PARAMS = [:maxhp, :maxmp, :atk, :def, :spi, :agi, :hit, :cri, :eva]
  # Elenco dei parametri con i loro valori massimi (per le barre)
  MAX_PARAMS = {
      :maxhp => 9999,
      :maxmp => 9999,
      :mag => 200,
      :atk => 999,
      :def => 999,
      :spi => 999,
      :agi => 999,
      :hit => 120,
      :cri => 15,
      :eva => 15
  } # non rimuovere la parentesi!
  # Imposta i valori minimi dei parametri (per le barre)
  MIN_PARAMS = {
      :hit => 85,
      :cri => 0,
      :eva => 0
  } # non rimuovere la parentesi!
  # Le statistiche da mostrare
  PERFORMANCE = [:title, :kills, :deaths, :assists, nil, :phys_dmg, :magic_dmg,
                 :dmg_dealt, nil, :phys_dmgt, :magic_dmgt, :dmg_taken, nil, :heal_total,
                 :heal_taken]
  # Restituisce il valore massimo per un determinato parametro
  def self.max_param(param)
    MAX_PARAMS[param]
  end

  # Restituisce il valore minimo per un determinato parametro
  def self.min_param(param)
    MIN_PARAMS[param].nil? ? 1 : MIN_PARAMS[param]
  end

  def self.smooth_speed
    2
  end
end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
# Vocaboli personalizzati
#==============================================================================
module Vocab
  # Restituisce il nome del comando
  # @return [String]
  def self.status_cmd(symbol)
    StatusSettings::COMMAND_VOCABS[symbol]
  end

  # Restituisce il nome del parametro
  # @return [String]
  def self.status_param(symbol)
    return symbol if StatusSettings::STATS[symbol].nil?
    StatusSettings::STATS[symbol][:text]
  end

  # Consiglio della finestra d'aiuto
  # @return [String]
  def self.help_tip
    'Seleziona per dettagli'
  end

  # Consiglio della finestra d'aiuto
  # @return [String]
  def self.preferred_params
    'Parametri principali:'
  end

  # Cambia equip
  # @return [String]
  def self.change_equip_status
    ' All\'equip.'
  end

  # Vai alle abilità
  # @return [String]
  def self.skill_status
    ' Alle abilità'
  end

  # Cambia l'eroe
  # @return [String]
  def self.hero_change_status
    ' Cambia eroe'
  end

  # Tipo di feature
  # @return [String]
  def self.state_type(symbol)
    {:con => 'Stato', :set => 'Bonus Set', :pas => 'Qualità'}[symbol]
  end
end

#==============================================================================
# ** ParseError
#------------------------------------------------------------------------------
# Eccezione generata dall'errore di lettura
#==============================================================================
class ParseError < Exception

end

#==============================================================================
# ** Status_Param
#------------------------------------------------------------------------------
# Parametro del personaggio
#==============================================================================
class Status_Param
  # @attr[String] name
  # @attr[String] description
  # @attr[String] format
  attr_reader :name
  attr_reader :description
  attr_reader :format
  attr_reader :condition
  # risultato dei colori
  COLORS = {-1 => :neg, 0 => :neu, 1 => :pos}
  # Inizializzazione
  # @param [Hash{Symbol->String}] hash
  def initialize(hash)
    @name = hash[:text] # ? hash[:text] : 'errore'
    @description = hash[:description] ? hash[:description] : ''
    @format = hash[:format] ? hash[:format] : '%d'
    @default = hash[:default]
    @reverse = hash[:reverse]
    @formula = hash[:formula]
    @condition = hash[:condition]
  end

  # Restituisce il valore formattato
  # @param [String] value
  def to_s(value)
    x = value
    x = eval(@formula) if @formula != nil
    @format ? sprintf(@format, x) : value.to_s
  end

  # determina se il parametro è invariato
  # rispetto allo standard
  # @param [Fixnum, Float] value
  # @return [TrueClass, FalseClass]
  def as_default?(value)
    x = value
    x = eval(@formula) if @formula != nil
    x == default_value
  end

  # @return [Fixnum]
  def default_value
    @default || 0
  end

  # Restituisce il simbolo rappresentante negativo, neutro o positivo
  # @param [Number] value
  # @return [Symbol]
  def proper_color(value)
    return COLORS[0] if @default.nil?
    x = value
    x = eval(@formula) if @formula != nil
    compare = x <=> @default
    compare *= -1 if @reverse
    COLORS[compare]
  end

  # Restituisce l'elenco dei Status_Param come hash
  # @return [Hash<Status_Param>]
  def self.get_params(displayed_stats)
    list = {}
    params = displayed_stats
    (0..params.size - 1).each { |i|
      stat = displayed_stats[i]
      next if StatusSettings::STATS[stat].nil?
      list[stat] = Status_Param.new(StatusSettings::STATS[stat])
    }
    list
  end
end

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
# Aggiunta dei ruoli
#==============================================================================
class Game_System
  # Restituisce l'array dei ruoli
  # @return [Array<Actor_Role>]
  def actor_roles
    ActorRoles.roles
  end

  # Restituisce un determinato ruolo
  # @param [Symbol] symbol
  # @return [Actor_Role, nil]
  def actor_role(symbol)
    actor_roles.compact.select { |x| x.name == symbol.to_s }.first
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
# Definisce il metodo del proprio ruolo
#==============================================================================
class Game_Actor < Game_Battler
  # Restituisce il ruolo dell'eroe
  # @return [Actor_Role]
  def role
    tag = StatusSettings::ACTOR_CLASSES[self.id]
    role = $game_system.actor_role(tag)
    role = Actor_Role.new(tag, tag, 'no ' + tag.to_s, [0, 0]) if role.nil?
    role
  end

  # Restituisce l'esperienza necessaria per salire al livello attuale
  # noinspection RubyResolve
  def now_exp
    @exp - @exp_list[@level];
  end

  # Restituisce l'esperienza necessaria per salire al prossimo livello
  # noinspection RubyResolve
  def next_exp
    @exp_list[@level + 1] > 0 ? @exp_list[@level + 1] - @exp_list[@level] : 0
  end

  # @param [Symbol] param
  # @return [TrueClass, FalseClass]
  def has_native_param?(param)
    Game_Actor.method_defined?(native_param_sym(param))
  end
  
  # @param [Symbol] param
  # @return [Symbol]
  def native_param_sym(param)
    sprintf('native_%s', param).to_sym
  end
  
  # @param [Fixnum] param
  def base_difference(param)
    return 0 unless has_native_param?(param)
    send(param) - send(native_param_sym(param))
  end
end

#==============================================================================
# ** ActorRoles
#------------------------------------------------------------------------------
# Carica e restituisce un array di ruoli
#==============================================================================
module ActorRoles
  # Crea e restituisce l'array dei ruoli
  # @return [Array<Actor_Role>]
  def self.roles
    @roles = load_roles unless @roles
    @roles
  end

  # Carica i ruoli
  # @return [Array<Actor_Role>]
  def self.load_roles
    roles = []
    path = 'Data/Roles'
    Dir.foreach(path) { |x|
      next if x == '.' or x == '..'
      file = path + '/' + x
      next if File.directory?(file)
      roles.push(role_from_file(file))
    }
    roles
  end

  # Carica il ruolo da un file di testo
  # @param [String] file
  # @return [Actor_Role]
  def self.role_from_file(file)
    return nil unless File.extname(file) =~ /\.xml/i
    text = text_from_file(file)
    begin
      role = parse_role(text, File.basename(file, '.*'))
    rescue ParseError
      role = Actor_Role.new(File.basename(file, '.*'), file, 'parse error: ' + text, [:atk, :atk])
    end
    role
  end

  # Restituisce il testo da un file
  # @param [String] file
  # @return [String]
  def self.text_from_file(file)
    text = ''
    File.open(file, 'r') do |f|
      f.each_line { |line| text += line.to_s }
    end
    text
  end

  # Prende un testo e restituisce la classe Actor_Role istanziata
  # @param [String] text
  # @param [Symbol] name
  # @return [Actor_Role]
  # @raise [ParseError]
  def self.parse_role(text, name)
    raise ParseError unless text =~ /[.]*<title>(.+)<\/title>[.]*/mi
    title = $1
    raise ParseError unless text =~ /[.]*<descr>(.+)<\/descr>[.]*/mi
    descr = $1
    raise ParseError unless text =~ /[.]*<param>(.+)<\/param>[.]*/mi
    param = $1
    Actor_Role.new(name, title, descr, param.split(/,[ ]*/))
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
# Aggiunta di alcuni metodi
#==============================================================================
class Window_Base < Window
  # Disegna il tag del ruolo, ma al momento non è usato.
  # @param [Symbol] role
  # @param [Integer] x
  # @param [Integer] y
  # @deprecated
  def draw_role_tag(role, x, y)
    bitmap = Cache.system(StatusSettings::ROLES_IMG)
    by = StatusSettings::ROLE_TAG_ORDER[role] * 24
    rect = Rect.new(0, by, bitmap.width, 24)
    contents.blt(x, y, bitmap, rect)
  end

  # Disegna l'esperienza (con barra) dell'eroe
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_exp(actor, x, y, width = 120)
    rate = actor.now_exp.to_f / actor.next_exp.to_f
    draw_gauge(x, y, width, rate, power_up_color, power_up_color)
    #draw_gauge_b(x, y, width, 3, actor.now_exp, actor.next_exp, power_up_color, power_up_color)
    change_color(system_color)
    draw_text(x, y, width, line_height, Vocab.exp)
    change_color(normal_color)
    text = sprintf('%d%%', rate * 100)
    draw_text(x, y, width, line_height, text, 2)
  end

  # Disegna i PA appresi dall'eroe
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_ap(actor, x, y, width = 120)
    #draw_icon(SkillSettings::AP_ICON, x + width - 24, y)
    change_color(system_color)
    draw_text(x, y, width - 24, line_height, Vocab.ap)
    change_color(normal_color)
    draw_text(x, y, width - 24, line_height, actor.ap, 2)
  end
end

#==============================================================================
# ** Actor_Role
#------------------------------------------------------------------------------
# Mostra il ruolo dell'eroe
#==============================================================================
class Actor_Role
  # @attr[String] title
  # @attr[String] name
  # @attr[String] description
  # @attr[Array<String>] params
  attr_reader :title # Titolo
  attr_reader :name # Nome
  attr_reader :description # Descrizione
  attr_reader :params # Parametri
  # Inizializzazione
  # @param [String] name
  # @param [String] title
  # @param [String] description
  def initialize(name, title, description, params)
    @name = name
    @title = title
    @params = params
    @description = description
  end

  # Restituisce l'etichetta del ruolo
  # @return [Bitmap]
  # @deprecated
  def role_tag
    Cache.system(StatusSettings::ROLES_IMG)
  end
end

#==============================================================================
# ** Window_ActorInfo
#------------------------------------------------------------------------------
# Informazioni base dell'eroe
#==============================================================================
class Window_ActorInfo < Window_Base
  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Game_Actor] actor
  def initialize(x, y, width, actor)
    super(x, y, width, fitting_height(4))
    @actor = actor
    refresh
  end

  # Aggiorna la finestra
  def refresh
    contents.clear
    draw_actor_basic_info(0, 0)
    draw_actor_status
  end

  # Disegna le informazioni di base
  def draw_actor_basic_info(x, y)
    draw_actor_face(actor, x, y)
    x += 100
    draw_actor_name(actor, x, 0)
    draw_actor_class(actor, x, y + line_height)
    draw_actor_level(actor, x, y + line_height * 2)
    draw_actor_state(actor, x, y + line_height * 3)
  end

  # Disegna lo stato dell'eroe
  def draw_actor_status
    x = 104 + 120
    draw_actor_hp(actor, x, 0, contents_width - x)
    draw_actor_mp(actor, x, line_height, contents_width - x)
    draw_actor_exp(actor, x, line_height * 2, contents_width - x)
    draw_actor_ap(actor, x, line_height * 3, (contents_width - x) / 2)
  end
end

#==============================================================================
# ** Window_InfoSelection
#------------------------------------------------------------------------------
# Finestra dei comandi del menu status
#==============================================================================
class Window_InfoSelection < Window_Command
  # Crea la lista dei comandi
  def make_command_list
    commands = StatusSettings::COMMANDS
    (0..commands.size - 1).each { |i|
      command = commands[i]
      add_command(Vocab.status_cmd(command), command)
    }
  end

  # Ridefinizione del metodo select per aggiornare la schermata
  def update_cursor
    super; check_cursor_handler;
  end

  # Restituisce il comando evidenziato
  # @return [Symbol]
  def item
    @list[@index][:symbol];
  end
end

#==============================================================================
# ** Window_ActorStatus
#------------------------------------------------------------------------------
# Mostra le informazioni principali sull'eroe (volto, nome, classe ecc...)
#==============================================================================
class Window_ActorStatus < Window_Base
  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Game_Actor] actor
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @actor = actor
    refresh
  end

  # Aggiorna la finestra
  def refresh
    contents.clear
    draw_actor_params(0, 0)
    draw_exp_information(contents_width / 2, 0)
    draw_equipments(contents_width / 2, line_height * 2)
    write_state_rate
    write_element_rate
  end

  # Disegna le resistenze elementali
  # noinspection RubyResolve
  def draw_actor_params(x, row, width = 180)
    params = StatusSettings::SHOWED_PARAMS
    (0..params.size - 1).each { |i| draw_param(x, i + row, params[i], width) }
  end

  # Disegna uno specifico parametro
  # @param [Integer] x
  # @param [Integer] row
  # @param [Symbol] param
  # @param [Integer] width
  def draw_param(x, row, param, width = (contents_width / 2))
    if actor.charge_gauge? and param == :maxmp
      param = :mag
    end
    param_value = actor.send param
    y = row * line_height
    change_color normal_color
    draw_param_gauge(x, y, width, param_value, param)
    draw_param_icon(x, y, param)
    draw_param_name(x + 24, y, param, width - 24)
    draw_param_value(x + 24, y, param, width - 24)
    if StatusSettings::DRAW_PARAM_DIFFERENCE
      draw_param_base_difference(width + 25, y, param, 120)
    else
      draw_native_param(width + 25, y, param, 120)
    end
  end

  # Disegna la barra del parametro
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] value
  # @param [Symbol] stat
  def draw_param_gauge(x, y, width, value, stat)
    height = 3
    color = param_color(stat)
    max = StatusSettings.max_param(stat)
    min = StatusSettings.min_param(stat)
    contents.fill_rect(x + 24, y + 20, width, height, darken_color(color))
    value = [[min, value].max, max].min
    rate = (value - min).to_f / (max - min).to_f * width
    rate = width if rate > width
    contents.fill_rect(x + 24, y + 20, rate.to_i, height, color)
  end

  # Disegna l'icona del parametro
  # @param [Integer] x
  # @param [Integer] y
  # @param [Symbol] param
  def draw_param_icon(x, y, param)
    icon = EquipSettings::ICONS[param]
    draw_icon(icon, x, y)
  end

  # Mostra il nome del parametro
  # @param [Integer] x
  # @param [Integer] y
  # @param [Symbol] param
  # @param [Integer] width
  def draw_param_name(x, y, param, width)
    change_color(system_color)
    draw_text(x, y, width, line_height, Vocab.param(param))
  end

  # Disegna il valore del parametro
  # @param [Integer] x
  # @param [Integer] y
  # @param [Symbol] param
  # @param [Integer] width
  def draw_param_value(x, y, param, width)
    value = actor.send param
    change_color(normal_color)
    draw_text(x + 24, y, width, line_height, value, 2)
  end

  def draw_param_base_difference(x, y, param, width)
    value = actor.base_difference(param)
    return if value == 0
    change_color(value > 0 ? power_up_color : power_down_color)
    text = sprintf('(%+d)', value)
    draw_text(x, y, width, line_height, text)
  end

  def draw_native_param(x, y, param, width)
    return unless actor.has_native_param? param
    value = actor.send(actor.native_param_sym(param))
    return if actor.send(param) == value
    change_color(normal_color, false)
    text = sprintf('(%d)', value)
    draw_text(x, y, width, line_height, text)
  end

  # Un colore più scuro
  # @param [Color] color
  # @return [Color]
  def darken_color(color)
    Color.new(color.red / 2, color.green / 2, color.blue / 2)
  end

  # Disegna la difesa elementale
  # noinspection RubyResolve
  def write_element_rate
    y = contents_height - line_height
    x = 4
    last_font_size = contents.font.size
    contents.font.size = 15
    (7..16).each { |i|
      #contents.fill_rect(x + 1, y + 1, 58, line_height - 2, Color.new(0, 0, 0, 50))
      icon = $data_system.attribute_icon(i)
      draw_icon(icon, x, y)
      value = actor.element_rate(i) - 100
      if value == 0
        change_color(normal_color)
      elsif value < 0
        change_color(power_up_color)
      else
        change_color(power_down_color)
      end
      draw_text(x + 24, y, 36, line_height, sprintf('%+d%', value))
      x += 60
    }
    contents.font.size = last_font_size
  end

  # Disegna la difesa agli status
  def write_state_rate
    y = contents_height - line_height * 2
    x = 4
    last_font_size = contents.font.size
    contents.font.size = 15
    (0..StatusSettings::DSTATES.size - 1).each { |i|
      #contents.fill_rect(x + 1, y + 1, 58, line_height - 2, Color.new(0, 0, 0, 50))
      state = $data_states[StatusSettings::DSTATES[i]]
      draw_icon(state.icon_index, x, y)
      value = actor.state_probability(state.id) # - 60
      if value == 60
        change_color(normal_color)
      elsif value < 60
        change_color(power_up_color)
      else
        change_color(power_down_color)
      end
      draw_text(x + 24, y, 36, line_height, sprintf('%d%', value))
      x += 60
    }
    contents.font.size = last_font_size
  end

  # Disegna le informazioni sull'esperienza
  # draw_exp_information
  # @param [Integer] x
  # @param [Integer] y
  def draw_exp_information(x, y)
    width = contents_width / 2
    change_color(system_color)
    s1 = actor.exp_s
    s2 = actor.next_rest_exp_s
    ry = line_height - 2
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    #draw_underline(line, width)
    #draw_underline(line + 1, width)
    contents.fill_rect(x, ry, width, 2, Color.new(0, 0, 0, 100))
    contents.fill_rect(x, ry + line_height, width, 2, Color.new(0, 0, 0, 100))
    draw_text(x, y, width, line_height, Vocab::ExpTotal)
    draw_text(x, y + line_height, width, line_height, s_next)
    change_color(normal_color)
    draw_text(x, y, width, line_height, s1, 2)
    draw_text(x, y + line_height, width, line_height, s2, 2)
  end

  # Disegna gli equipaggiamenti
  # noinspection RubyResolve
  # @param [Integer] dx
  # @param [Integer] dy
  def draw_equipments(dx, dy)
    change_color(system_color)
    dw = contents_width - dx
    #draw_text(dx, dy, dw, line_height, Y6::STATUS::EQUIPMENT)
    #draw_change_command(dx, dy, dw)
    i = 0
    actor.equips.each do |equip|
      next if equip == nil
      draw_bg_rect(dx, dy + (line_height * (i)), dw)
      draw_item_name(equip, dx, dy + line_height * (i))
      i += 1
    end
  end

  # Restituisce il colore del parametro
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_change_command(x, y, width)
    change_color(normal_color)
    text = ': ' + Vocab.change_equip_status
    wx = x + width - text_size(text).width
    draw_key_icon(:X, wx - 26, y)
    draw_text(wx, y, width, line_height, text)
  end

  # Restituisce il colore del parametro
  # @param [Symbol] stat
  # @return [Color]
  def param_color(stat)
    case stat
    when :maxhp
      Color::DEEPSKYBLUE
    when :maxmp
      Color::DEEPPINK
    when :max_anger, :mag
      Color::DARKGREEN
    when :atk
      Color::RED
    when :def
      Color::DARKSEAGREEN
    when :spi
      Color::MEDIUMORCHID
    when :agi
      Color::GOLD
    when :hit, :eva, :cri, :odds
      Color::LIGHTGRAY
    else
      Color::GRAY
    end
  end

  # Disegna l'esperienza dell'eroe
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_exp_info(x, y, width = contents_width / 2)
    s1 = actor.exp_s
    s2 = actor.next_rest_exp_s
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    change_color(system_color)
    draw_text(x, y + line_height * 0, width, line_height, Vocab::ExpTotal)
    draw_text(x, y + line_height * 2, width, line_height, s_next)
    change_color(normal_color)
    draw_text(x, y + line_height * 1, width, line_height, s1, 2)
    draw_text(x, y + line_height * 3, width, line_height, s2, 2)
  end
end

#==============================================================================
# ** Window_ActorParams
#------------------------------------------------------------------------------
# Mostra tutti i parametri dell'eroe
#==============================================================================
class Window_ActorParams < Window_Selectable
  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Game_Actor] actor
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    set_actor(actor)
    refresh
    deactivate
  end

  # Restituisce il numero massimo di colonne
  # @return [Integer]
  def col_max
    2;
  end

  # La lista dei parametri
  def make_item_list
    if @actor.nil?
      @data = []
      return
    end
    @data = StatusSettings::DISPLAYED_STATS.select {|x| StatusSettings::STATS[x][:condition].nil? or @actor.send(StatusSettings::STATS[x][:condition]) }
    @data.concat(amplified_elements_data.keys)
  end

  # Ottiene il numero di elementi
  # @return [Integer]
  def item_max
    @data ? @data.size : 1
  end

  # Restituisce l'oggetto selezionato dal cursore
  # @return [Status_Param, nil]
  def item(i = index)
    @data && i >= 0 ? @status_params[@data[i]] : nil
  end

  # Aggiornamento della finestra
  def refresh
    return if actor.nil?
    contents.clear
    draw_all_items
  end

  # Aggiorna la lista dei parametri
  def update_status_params
    @status_params = Status_Param.get_params(@data)
    amplified_elements_data.each_pair do |key, data|
      @status_params[key] = Status_Param.new(data)
    end
  end

  # Imposta l'eroe
  def set_actor(new_actor)
    return if @actor == new_actor
    @actor = new_actor
    make_item_list
    update_status_params
    create_contents
    refresh
  end

  # Disattiva la finestra
  def deactivate
    super
    self.index = -1
  end

  # Processo di attivazione
  def activate
    super
    self.index = 0
  end

  # Disegna l'oggetto
  # @param [Integer] index
  def draw_item(index)
    item = item(index)
    if item
      rect = item_rect_for_text(index)
      param = get_param(@data[index])
      enabled = !item.as_default?(param)
      change_color(system_color, enabled)
      draw_text(rect, item.name)
      change_color(param_color(item.proper_color(param)), enabled)
      draw_text(rect, item.to_s(param), 2)
    end
  end

  # Processo di attivazione
  # @param [Symbol] key
  # @return [Color]
  def param_color(key)
    {:neg => power_down_color,
     :neu => normal_color,
     :pos => power_up_color}[key]
  end

  # Restituisce il parametro
  def get_param(symbol)
    if symbol.to_s =~ /element_(\d+)_amp/
      actor.element_amplifier $1.to_i
    else
      actor.send symbol
    end
  end

  # Aggiorna la finestra d'aiuto
  def update_help
    return if @help_window.nil?
    return if item.nil?
    @help_window.set_text(item.description)
  end

  # @return [Hash]
  def amplified_elements_data
    amplified_data = {}
    amplified_elements.each do |element|
      key = ('element_' + element.id.to_s + '_amp').to_sym
      data = {:text => sprintf(StatusSettings::ELEMENT_AMPLIFIER_VOCAB, element.name),
              :description => sprintf(StatusSettings::ELEMENT_AMPLIFIER_HELP, (actor.element_amplifier(element.id)*100-100), element.name),
              :default => 0, :format => '%+d%%', :formula => 'x*100-100' }
      amplified_data[key] = data
    end
    amplified_data
  end

  # @return [Array<RPG::Element_Data>]
  def amplified_elements
    $data_system.magic_elements.select { |element| actor.element_amplifier(element.id) != 1.0 }
  end
end

#==============================================================================
# ** Window_ActorRole
#------------------------------------------------------------------------------
# Mostra il ruolo della classe dell'eroe
#==============================================================================
class Window_ActorRole < Window_Base
  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Game_Actor] actor
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @actor = actor
    refresh
  end

  # Aggiorna i dati
  def refresh
    contents.clear
    change_color(normal_color)
    draw_class_title
    draw_underline(0)
    draw_class_description
    draw_main_params
  end

  # Scrive il titolo della classe
  def draw_class_title
    if actor.role.nil?
      draw_text(0, 0, contents_width, line_height, 'NO')
      return
    end
    draw_text(0, 0, contents_width, line_height, actor.role.title)
  end

  # Scrive la descrizione della classe
  def draw_class_description
    return if actor.role.nil?
    draw_formatted_text(0, line_height, contents_width, actor.role.description)
  end

  # Scrive i parametri principali
  def draw_main_params
    return if actor.role.nil?
    y = contents_height - line_height
    change_color(system_color)
    draw_text(0, y, contents_width, line_height, Vocab.preferred_params)
    change_color(power_up_color)
    x = text_size(Vocab.preferred_params + ' ').width
    param1 = Vocab.param(actor.role.params[0].to_sym)
    param2 = Vocab.param(actor.role.params[1].to_sym)
    text = sprintf('%s / %s', param1, param2)
    draw_text(x, y, contents_width - x, line_height, text)
  end
end

#==============================================================================
# ** Window_Actor_StatusStats
#------------------------------------------------------------------------------
# Mostra le statistiche dell'eroe nella schermata dello status
#==============================================================================
class Window_Actor_StatusStats < Window_Selectable
  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Game_Actor] actor
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @actor = actor
    refresh
    deactivate
  end

  # Ottiene il numero di elementi
  # @return [Integer]
  def item_max
    @data ? @data.size : 1
  end

  # Ottiene la lista di oggetti
  def make_item_list
    @data = StatusSettings::PERFORMANCE;
  end

  # Disattiva la finestra
  def deactivate
    super
    self.index = -1
  end

  # Aggiorna la finestra
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end

  # Processo di attivazione
  def activate
    super
    self.index = 0
  end

  # Aggiorna la finestra d'aiuto
  def update_help
    super
    return if data(index).nil?
    text = Y6::PERFORMANCE::PERFORM_HELP[@data[self.index]]
    text = Y6::PERFORMANCE::PERFORM_HELP[:title] if self.index < 0
    @help_window.set_text(text)
  end

  # Restituisce
  def data(index)
    ; @data[index];
  end

  # Disegna un oggetto
  # @param [Integer] index
  def draw_item(index)
    rect = item_rect_for_text(index)
    draw_performance(rect, index)
  end

  # Disegna la rispettiva performance
  # @param [Rect] rect
  # @param [Integer] index
  def draw_performance(rect, index)
    return if data(index).nil?
    text = Y6::PERFORMANCE::PERFORM_VOCAB[@data[index]]
    @actor.clear_battle_performance_stats
    #value = eval("@actor.performance[:#{@data[index].to_s}]")
    value = @actor.performance[@data[index].to_s.to_sym]
    return if value.nil?
    icon = $imported['Y6-Iconview'] ? Icon.performance(@data[index]) : 0
    draw_icon(icon, rect.x + 24, rect.y)
    change_color(system_color)
    dx = icon > 0 ? 48 : 24
    dw = contents.width / 2 - dx
    draw_text(dx, rect.y, dw, line_height, text, 0)
    change_color(normal_color)
    dx = contents.width / 2
    contents.draw_text(dx, rect.y, dw, line_height, value.group, 2)
  end
end

#==============================================================================
# ** Window_ActorConditions
#------------------------------------------------------------------------------
# Finestra che mostra le condizioni dell'eroe
#==============================================================================
class Window_ActorConditions < Window_Selectable
  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Game_Actor] actor
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @actor = actor
    refresh
    deactivate
  end

  # Imposta l'eroe della finestra
  # @param [Game_Actor] new_actor
  def set_actor(new_actor)
    return if new_actor == @actor
    @actor = new_actor
    refresh
  end

  # Restituisce l'eroe
  # @return [Game_Actor]
  def actor
    @actor
  end

  # Disattiva la finestra
  def deactivate
    super
    self.index = -1
  end

  # Processo di attivazione
  def activate
    super
    self.index = 0
  end

  # Ottiene la lista degli oggetti
  def make_item_list
    @data = actor.states.select { |x| x.icon_index > 0 && x.description != '' }
    @data.sort! { |x, y| y.priority <=> x.priority }
  end

  # Ottiene il numero di elementi
  # @return [Integer]
  def item_max
    @data ? @data.size : 1
  end

  # Restituisce l'oggetto
  # @return [RPG::State]
  def item
    @data[@index]
  end

  # Restituisce l'oggetto ad un determinato indice
  # @return [RPG::State]
  def data(index)
    @data[index]
  end

  # Aggiorna la finestra
  def refresh
    make_item_list
    create_contents
    return if @data.nil?
    draw_all_items
  end

  # Disegna un oggetto
  # @param [Integer] index
  def draw_item(index)
    item = data(index)
    rect = item_rect_for_text(index)
    draw_bg_rect(rect.x, rect.y) if item.priority > 0
    draw_icon(item.icon_index, rect.x, rect.y)
    change_color(normal_color)
    change_color(power_up_color) if item.buff?
    change_color(power_down_color) if item.debuff?
    draw_text(rect.x + 24, rect.y, rect.width - 24, line_height, item.name)
    str = '[%s]'
    if item.priority > 0
      text = sprintf(str, Vocab.state_type(:con))
    elsif item.set_bonus_state?
      text = sprintf(str, Vocab.state_type(:set))
    else
      text = sprintf(str, Vocab.state_type(:pas))
    end
    draw_text(rect.x, rect.y, rect.width, line_height, text, 2)
  end

  # Aggiornamento della finestra d'aiuto
  def update_help
    return if @help_window.nil?
    return if item.nil?
    @help_window.set_text(item.description)
  end
end

#==============================================================================
# ** Window_StateHelp
#------------------------------------------------------------------------------
# Mostra i comandi per andare ad altre schermate
#==============================================================================
class Window_StateHelp < Window_Base
  # inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  def initialize(x, y)
    super(x, y, window_width, fitting_height(1))
    refresh
  end

  # Larghezza della finestra
  def window_width
    Graphics.width;
  end

  # Refresh
  def refresh
    contents.clear
    width = contents_width / 3
    draw_equip_help(0, 0, width)
    draw_skill_help(width, 0, width)
    draw_actor_help(width * 2, 0, width)
  end

  # Disegna il comando equip
  def draw_equip_help(x, y, width)
    draw_key_icon(:X, x, y)
    draw_text(x + 24, y, width - 24, line_height, Vocab.change_equip_status)
  end

  # Disegna il comando skill
  def draw_skill_help(x, y, width)
    draw_key_icon(:A, x, y)
    draw_text(x + 24, y, width - 24, line_height, Vocab.skill_status)
  end

  # Disegna il comando eroi
  def draw_actor_help(x, y, width)
    draw_key_icon(:LEFT, x, y)
    draw_key_icon(:RIGHT, x + 24, y)
    draw_text(x + 48, y, width - 48, line_height, Vocab.hero_change_status)
  end
end

#==============================================================================
# ** Scene_NewStatus
#------------------------------------------------------------------------------
# Nuova schermata dello status riprogettata
#==============================================================================
# noinspection ALL
class Scene_NewStatus < Scene_MenuBase
  # Inizio
  def start
    super
    create_command_window
    create_actor_window
    create_help_window
    create_command_help_window
    create_overview_window
    create_stats_window
    create_role_window
    create_params_window
    create_states_window
    hide_all_windows
    update_vista
  end

  # Crea la finestra dei comandi
  def create_command_window
    @command_window = Window_InfoSelection.new(0, 0)
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:left, method(:prev_actor))
    @command_window.set_handler(:right, method(:next_actor))
    @command_window.set_handler(:params, method(:show_params))
    @command_window.set_handler(:stats, method(:show_stats))
    @command_window.set_handler(:states, method(:show_states))
    @command_window.set_handler(:cursor_move, method(:update_vista_smooth))
    @command_window.set_handler(:function, method(:on_equip_call))
    @command_window.set_handler(:shift, method(:on_skill_call))
  end

  # Restituisce l'eroe attuale
  # @return [Game_Actor]
  def actor
    @actor;
  end

  # Crea la finestra dell'eroe
  def create_actor_window
    x = @command_window.rx
    width = Graphics.width - x
    @actor_window = Window_ActorInfo.new(x, 0, width, actor)
    @command_window.height = @actor_window.height
  end

  # Creazione della finestra d'aiuto
  def create_help_window
    super
    @help_window.set_text(Vocab.help_tip)
    @help_window.y = @actor_window.by
  end

  # Crea la finestra che mostra opzioni aggiuntive
  def create_command_help_window
    @c_help_window = Window_StateHelp.new(0, 0)
    @c_help_window.y = Graphics.height - @c_help_window.height
    @c_help_window.z = 999
  end

  # Crea la finestra dell'elenco dei parametri
  def create_params_window
    y = @help_window.by
    width = Graphics.width
    height = Graphics.height - y
    @params_window = Window_ActorParams.new(0, y, width, height, actor)
    @params_window.set_handler(:cancel, method(:command_reselect))
    @params_window.help_window = @help_window
  end

  # Crea la finestra delle info generali
  def create_overview_window
    y = @command_window.by
    w = Graphics.width
    h = Graphics.height - y - @c_help_window.height
    @overview_window = Window_ActorStatus.new(0, y, w, h, actor)
  end

  # Crea la finestra del ruolo
  def create_role_window
    y = @command_window.by
    w = Graphics.width
    h = Graphics.height - y
    @role_window = Window_ActorRole.new(0, y, w, h, actor)
  end

  # Crea la finestra delle statistiche
  def create_stats_window
    y = @help_window.by
    w = Graphics.width
    h = Graphics.height - y
    @stats_window = Window_Actor_StatusStats.new(0, y, w, h, actor)
    @stats_window.set_handler(:cancel, method(:command_reselect))
    @stats_window.help_window = @help_window
  end

  # Crea la finestra degli stati
  def create_states_window
    y = @help_window.by
    w = Graphics.width
    h = Graphics.height - y
    @states_window = Window_ActorConditions.new(0, y, w, h, actor)
    @states_window.set_handler(:cancel, method(:command_reselect))
    @states_window.help_window = @help_window
  end

  # Attiva la finestra delle statistiche
  def show_stats
    @stats_window.activate;
  end

  # Attiva la inestra dei parametri
  def show_params
    @params_window.activate
  end

  # Attiva la inestra degli status
  def show_states
    @states_window.activate
  end

  # Disattiva le finestre attiva e ripassa alla finestra dei comandi
  def command_reselect
    @params_window.deactivate
    @stats_window.deactivate
    @states_window.deactivate
    @command_window.activate
    @help_window.set_text(Vocab.help_tip)
  end

  # Aggiorna la visibilità delle finestre informative
  def update_vista
    hide_all_windows
    case @command_window.item
    when :review
      @overview_window.visible = true
      @c_help_window.visible = true
    when :params
      @help_window.visible = true
      @params_window.visible = true
    when :role
      @role_window.visible = true
    when :stats
      @help_window.visible = true
      @stats_window.visible = true
    when :states
      @help_window.visible = true
      @states_window.visible = true
    else
      @overview_window.visible = true
    end
  end

  # Aggiorna la visibilità delle finestre informative
  def update_vista_smooth
    hide_all_windows_smooth
    update_vista
    case @command_window.item
    when :review
      @c_help_window.open
      @overview_window.smooth_move(0, @actor_window.by, smooth_speed)
    when :params
      @help_window.open
      @params_window.smooth_move(0, @help_window.by, smooth_speed)
    when :role
      @role_window.smooth_move(0, @actor_window.by, smooth_speed)
    when :stats
      @help_window.open
      @stats_window.smooth_move(0, @help_window.by, smooth_speed)
    when :states
      @help_window.open
      @states_window.smooth_move(0, @help_window.by, smooth_speed)
    else
      @overview_window.smooth_move(0, @actor_window.by, smooth_speed)
    end
  end

  # Nasconde tutte le finestre informative
  def hide_all_windows
    @help_window.visible = false
    @c_help_window.visible = false
    @overview_window.visible = false
    @role_window.visible = false
    @params_window.visible = false
    @states_window.visible = false
    @stats_window.visible = false
  end

  # Nasconde tutte le finestre informative con un movimento fluido
  def hide_all_windows_smooth
    y = Graphics.height
    @help_window.close
    @c_help_window.close
    @overview_window.smooth_move(0, y, smooth_speed)
    @role_window.smooth_move(0, y, smooth_speed)
    @params_window.smooth_move(0, y, smooth_speed)
    @states_window.smooth_move(0, y, smooth_speed)
    @stats_window.smooth_move(0, y, smooth_speed)
  end

  # Eroe successivo
  def next_actor
    clone_actor_window
    super
    @old_window.smooth_move(@old_window.x, 0 - @old_window.height, 1, method(:erase_window))
    @actor_window.x = Graphics.width
    @actor_window.smooth_move(@command_window.rx, 0, 1)
  end

  # Eroe precedente
  def prev_actor
    clone_actor_window
    super
    y = @old_window.y
    @old_window.smooth_move(Graphics.width, y, 1, method(:erase_window))
    @actor_window.y = 0 - @actor_window.by
    @actor_window.smooth_move(@command_window.rx, 0, 1)
  end

  # Crea una finestra eroe clone
  def clone_actor_window
    x = @actor_window.x
    y = @actor_window.y
    width = @actor_window.width
    erase_window
    @old_window = Window_ActorInfo.new(x, y, width, actor)
  end

  # Cancella una finestra
  def erase_window
    return if @old_window.nil?
    @old_window.visible = false
    @old_window.dispose
    @old_window = nil
  end

  # Evento al cambio di eroe
  def on_actor_change
    super
    @actor_window.set_actor(actor)
    @params_window.set_actor(actor)
    @role_window.set_actor(actor)
    @overview_window.set_actor(actor)
    @stats_window.set_actor(actor)
    @states_window.set_actor(actor)
    Graphics.wait(5)
  end

  # Evento alla chiamata equip
  def on_equip_call
    Sound.play_ok
    SceneManager.call(Scene_NewEquip)
  end

  # Evento alla chiamata skills
  def on_skill_call
    Sound.play_ok
    SceneManager.call(Scene_NewSkill)
  end

  # Velocità di movimento
  # @return [Integer]
  def smooth_speed
    StatusSettings.smooth_speed
  end
end