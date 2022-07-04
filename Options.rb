=begin
 ==============================================================================
  ■ Opzioni di gioco di Holy87
      versione 1.2.2
      Difficoltà utente: ★★
      Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
      lo script nei propri progetti, sia amatoriali che commerciali. Vietata
      l'attribuzione impropria.

      Changelog
      v1.2.2 -> risoluzione di bug critici e miglioramenti vari
      v1.2.1 -> risoluzione di bug critici e miglioramenti vari
      v1.2.0 -> possibilità di impostare un valore minimo per le variabili
                possibilità di visualizzare il valore anziché percentuale
                  nelle barre
                possibilità di impostare un colore RGB piuttosto che uno della
                  windowskin per le barre
                possibilità di incrementare e decrementare più velocemente le
                  barre tenendo premuto SHIFT o premento L e R
                possibilità di forzare la non-inizializzazione di una opzione
                correzioni bugfix generali
      v1.1.3 -> correzione bug incremento barra
      v1.1.2 -> correzione bug entrata nel menu
      v1.1.1 -> correzione di bug
 ==============================================================================
    Questo script aggiunge il menu opzioni di gioco per configurare opzioni
    del maker o degli script installati (se lo supportano). Dai al giocatore
    le opzioni che gli spettano!
 ==============================================================================
  ■ Compatibilità
    Scene_Title -> alias create_command_window
    Scene_Menu -> alias create_command_window
    DataManager -> alias load_normal_database
 ==============================================================================
  ■ Installazione e istruzioni
    Installare questo script sotto Materials e prima del Main.
    RICHIEDE IL MODULO DI SUPPORTO UNIVERSALE DI HOLY87.

  ■ Istruzioni per l'utilizzatore per creare opzioni di gioco

      Si possono aggiungere facilmente le opzioni aggiungendole nell'array
      ELEMENTS (più in basso). È possibile aggiungere opzioni che cambiano
      switch, variabili, barre ed altri elementi. Vediamo come.

    ● Per aggiungere separatori
      {:type => :separator, :text => "Questo è un separatore}
      Il separatore serve a tenere più organizzato il menu delle opzioni,
      separando le categorie di opzioni. Importante impostare il tipo come
      separatore, mentre l'attributo :text mostra il titolo della sezione.

    ● Per aggiungere switch
      {:type => :switch, :text => "Nome opzione", :sw => 10, :on => "Acceso",
       :off => "Spento", :help => "Attiva l'opzione"}
      Con questo comando si configura l'opzione di uno switch. Il parametro
      :sw indica l'ID della switch del gioco da impostare ON o OFF. I parametri
      :on e :off sono il testo mostrato nelle opzioni.
      Puoi anche aggiungere il valore :default => true se vuoi che lo switch
      sia attivo all'inizio del gioco.

    ● Per aggiungere variabili
      {:type => :variable, :text => "Nome opzione", :var => 2, :max => 5,
       :help => "Cambia il valore dell'opzione"}
      Questo comando invece configura un'opzione tramite variabile di gioco.
      Con :var indica l'ID della variabile di gioco, :max il valore massimo che
      può raggiungere l'opzione nella variabile. In questo caso l'opzione della
      variabile 2 può avere come valori 0, 1, 2, 3, 4 e 5.
      Puoi anche aggiungere :min => x se vuoi impostare un valore minimo che
      non sia zero (anche minore di zero) dove x è il valore minimo.
      Verranno mostrati in fila e il giocatore potrà scegliere il valore.
      Puoi anche personalizzare i nomi dei valori, ad esempio

      {:type => :variable, :text => "Difficoltà", :var => 5,
       :help => "Regola la difficoltà di gioco.",
       :values => ["Facile", "Normale", "Difficile, "Estremo"] }
      Ci sono troppe opzioni da mostrare in un solo rigo? Nessun problema!
      Aggiungi il parametro :open_popup => true per mostrare la selezione
      dell'opzione in un popup, per avere più opzioni insieme senza che stiano
      troppo strette.
      Anche con le variabili, puoi impostare il valore :default => x per
      un valore predefinito all'inizio del gioco.
      :max non serve, dato che i valori vengono definiti.

    ● Per aggiungere delle barre
      Un altro modo per controllare le variabili è quello di usare le barre.
      Viene mostrata una barra che si riempie o si svuota a preferenza dell'utente.
      La configurazione è simile alle variabili, solo che si deve anche decidere
      il colore della barra. Esempio:
      {:type => :bar, :text => "Volume", :var => 5, :max => 100, :color => 5,
       :help => "Regola il volume del gioco."}
      Il colore si riferisce al numero del colore del testo della windowskin
      (ad esempio, 0 per il colore del testo)
      Le barre hanno anche il vantaggio di poter essere accoppiate ad uno
      switch, nel caso si prema Invio l'opzione può essere disattivata (ad
      esempio, rendendo muto l'audio). Basta aggiungere l'attributo :sw come
      negli switch.
      se non vuoi mostrare il valore come percentuale, usa :show_perc => false.
      Al posto del colore del tema, puoi anche impostare un colore ben definito
      come :color => Color.new(R, G, B) dove R, G e B sono i valori del colore.

  ■ Opzioni avanzate per gli smanettoni

      IMPOSTARE DELLE OPZIONI GLOBALI (CHE NON DIPENDONO DAL SALVATAGGIO)
      Se imposti l'ID di una switch o una variabile non come numero, ma come
      stringa o un simbolo, l'opzione viene vista come globale e verrà salvata
      in $game_settings.

      ABILITARE O DISABILITARE LE OPZIONI
      Puoi abilitare o disabilitare delle opzioni in due modi.
      ● $game_system.option_enable(tag, true/false) abilita o disabilita
        un'opzione di gioco. Il parametro tag è il nome dell'opzione definito
        nella configurazione dell'opzione (:tag => "nome tag")
      ● usando :condition => "condizione" nella configurazione dell'opzione.
        Ad esempio, :condition => "$game_switches[55] == true" abiliterà l'opzione
        solo se lo switch 55 è attivato.

      VOCI AVANZATE PER LE OPZIONI PER ESEGUIRE CODICE RUBY
      Impostando il tipo come :advanced, viene eseguito del codice preconfigurato
      quando il giocatore preme invio su di esso. Esempio:
      {:type => :advanced, method => :change_scene}
      class Option
        def change_scene
          SceneManager.call(Mia_Scena)
        end
      end

      FORZARE LA NON INIZIALIZZAZIONE DELLE VARIABILI
      Se non vuoi che un'opzione venga automaticamente inizializzata a 0,
      imposta il parametro :not_initialize => true

      Se vuoi assegnare anche un valore visualizzato come nelle altre opzioni,
      devi fare l'alias del metodo draw_advanced in Window_GameOptions.

      Se imposti il valore :method => :nome_metodo in una barra, switch o
      variabile, viene eseguito il metodo nome_metodo prima di impostare il
      valore. Puoi mettere :var o :sw a 0 se non vuoi usare una variabile o uno
      switch.
      Il metodo in questo caso deve ricevere un PARAMETRO IN INGRESSO dato dal
      valore inserito.

      Se imposti il valore :val_mt => nome_metodo, il valore che viene mostrato
      nelle opzioni viene preso dal metodo impostato come nome_metodo, sempre
      definito nella classe Option.

  ■ Istruzioni per gli scripter

      È molto utile per chi fa script aggiungere delle opzioni ai propri script
      direttamente in questo menu opzioni, invece che crearlo a parte.
      Per gli scripter, le opzioni vengono divise in 8 categorie:
      - Generiche, nella stessa categoria di quelle definite dall'utente
      - Aspetto, come temi e sfondi
      - Audio, per musica e suoni
      - Gioco, per opzioni di gioco come la velocità battaglia e la difficoltà
      - Grafica, come la risoluzione e gli effetti speciali
      - Comandi, per i controlli di gioco
      - Sistema, per configurazioni tecniche
      - Internet, per l'aspetto online.
      Le categorie avranno il separatore dedicato già inserito (a parte quelle
      generiche, ove puoi crearne una tu se il tuo script non ricade in una
      delle categorie prefissate).
      Per aggiungere le opzioni in queste categorie, per ogni opzione devi
      passare l'hash (configurato come da istruzioni precedenti) nei rispettivi
      metodi:
      H87Options.push_system_option(hash)
      H87Options.push_generic_option(hash)
      H87Options.push_game_option(hash)
      H87Options.push_graphic_option(hash)
      H87Options.push_sound_option(hash)
      H87Options.push_appearance_option(hash)
      H87Options.push_keys_option(hash)
      H87Options.push_internet_option(hash)

    ● Finestre di popup personalizzate
      Puoi creare finestre di popup personalizzate alla selezione di un'opzione
      creando una sottoclasse di Window_OptionPopup (vedi in basso), e impostando
      l'attributo all'opzione :popup => "NomeClasse".
 ==============================================================================
=end
$imported = {} if $imported == nil
$imported['H87_Options'] = 1.2
#==============================================================================
# ** CONFIGURAZIONE
#------------------------------------------------------------------------------
#  Configura i testi e le opzioni
#==============================================================================
module H87Options
  # Vocaboli
  #Comando Opzioni
  OPTION_COMMAND = "Opzioni"
  #Valore della barra disattivata
  OFF_BAR = "OFF"
  #Opzioni ordinate per categoria
  SYSTEM_OPTIONS = "Sistema"
  GAME_OPTIONS = "Gioco"
  SOUND_OPTIONS = "Audio"
  APPEARANCE_OPTIONS = "Aspetto"
  GRAPHIC_OPTIONS = "Grafica"
  INTERNET_OPTIONS = "Internet"
  KEYS_OPTIONS = "Comandi"
  USER_OPTIONS = "Generale"
  # Suono al cambio di switch
  TOGGLE_SOUND = "Switch2"
  # Mostra il menu opzioni nel titolo? Alla schermata del titolo vengono
  #   mostrate solo le opzioni GLOBALI (vedi nelle istruzioni per smanettoni)
  SHOW_ON_TITLE = false
  # Mostra le opzioni nella schermata del Menu?
  SHOW_ON_MENU = true
  # Configura qui le varie opzioni. Vedi gli esempi per capire come
  #   creare le opzioni.
  ELEMENTS = [
      #normale switch
      {:type => :switch, #tipo switch
       :text => "Interruttore", #nome dell'opzione
       :help => "Questa è una prova dell'interruttore.", #mostrato nella descr.
       :sw => 3, #ID della switch
       :on => "ON", #testo ON
       :off => "OFF", #testo OFF
       :default => true, #valore predefinito (facoltativo)
      },
      #separatore
      {:type => :separator, #tipo separatore
       :text => "Separatore", #testo mostrato
      },
      #variabile
      {:type => :variable, #tipo variabile
       :text => "Sveglia", #testo mostrato
       :help => "Imposta l'ora della sveglia", #descrizione
       :var => 110, #ID della variabile
       :max => 11, #valore massimo
       :default => 6, #valore predefinito
      },
      #altra variabile
      {:type => :variable, #tipo variabile
       :text => "Animale", #testo mostrato
       :help => "Imposta il tuo animale preferito", #descrizione
       :var => 111, #variabile
       :values => %w[Cane Gatto Elefante], #valori 0, 1 e 2
      },
      #altra variabile, tanti valori quindi mostro un popup
      {:type => :variable, #tipo variabile
       :text => "Mese", #testo mostrato
       :help => "Imposta il mese del gioco", #descrizione
       :var => 112, #variabile
       :open_popup => true, #troppi valori, usa un popup
       :values => %w[Gennaio Febbraio Marzo Aprile Maggio Giugno Luglio Agosto Settembre Ottobre Novembre Dicembre], # i mesi dell'anno
      },
      #Variabile mostrata come barra
      {:type => :bar, #tipo barra
       :text => "Riempimento", #testo mostrato
       :sw => 5, #switch ON/OFF
       :var => 113, #ID della variabile
       :color => 10, #colore della variabile (10 è rosso nella skin default)
       :max => 50, #valore massimo
       :perc => false,
       :min => -50,
      },
      #Altra barra
      {:type => :bar, #tipo barra
       :text => "Prodezza", #testo mostrato
       :var => 14, #ID della variabile
       :color => 4, #colore della variabile (4 è celeste)
       :max => 100, #valore massimo
       :default => 44,
       :condition => "$game_switches[5] == false", #l'opzione è disponibile solo
      }, #se lo switch 5 è false (in pratica se disattivi la barra precedente)
      #Opzione avanzata
      {:type => :advanced, #opzione speciale
       :method => :apri_nome, #metodo alla pressione, vedi sotto per la definiz.
       :text => "Cambia nome eroe", #testo mostrato
       :condition => "$TEST", #attivo solo se è un test di gioco
       :help => "Cambia il nome eroe durante il gioco.",
      },
  ] #NON CANCELLARE QUESTA PARENTESI!

  # Configurazione per Menu Titolo personalizzato
  TITLE_ICON = "Icona" #icona del comando
  TITLE_BALOON = "Fumetto" #immagine del fumetto
end

class Option
  #qui vanno definiti gli eventuali metodi da aggiungere

  #esempio precedente
  def apri_nome
    SceneManager.call(Scene_Name)
    SceneManager.scene.prepare($game_party.members[0].id, 10)
  end
end

#==============================================================================
# ** FINE CONFIGURAZIONE
#------------------------------------------------------------------------------
#                 - ATTENZIONE: NON MODIFICARE OLTRE! -
#==============================================================================


#==============================================================================
# ** Modulo H87Options
#------------------------------------------------------------------------------
#  Modulo di gestione delle opzioni
#==============================================================================
module H87Options
  # Restituisce le opzioni di gioco
  def self.game_options
    return @game.nil? ? [] : @game
  end

  # Restituisce le opzioni definite dall'utente
  def self.user_options
    return ELEMENTS + generic_options
  end

  # Restituisce le opzioni generali
  def self.generic_options
    return @generic.nil? ? [] : @generic
  end

  # Restituisce le opzioni grafiche
  def self.graphic_options
    return @graphic.nil? ? [] : @graphic
  end

  # Restituisce le opzioni di sistema
  def self.system_options
    return @system.nil? ? [] : @system
  end

  # Restituisce le opzioni audio
  def self.sound_options
    return @sound.nil? ? [] : @sound
  end

  # Restituisce le opzioni dei comandi
  def self.keys_options
    return @keys.nil? ? [] : @keys
  end

  # Restituisce le opzioni internet
  def self.internet_options
    return @internet.nil? ? [] : @internet
  end

  # Restituisce le opzioni d'aspetto
  def self.appearance_options
    return @appearance.nil? ? [] : @appearance
  end

  # Restituisce tutte le opzioni
  def self.all_options
    return user_options + game_options + appearance_options + graphic_options +
        sound_options + keys_options + system_options + internet_options
  end

  # Aggiunge le opzioni di sistema
  def self.push_system_option(hash)
    if @system.nil?
      @system = [{:type => :separator, :text => SYSTEM_OPTIONS}]
    end
    @system.push(hash)
  end

  # Aggiunge le opzioni dei comandi
  def self.push_keys_option(hash)
    if @keys.nil?
      @keys = [{:type => :separator, :text => KEYS_OPTIONS}]
    end
    @keys.push(hash)
  end

  # Aggiunge le opzioni generiche
  def self.push_generic_option(hash)
    @generic = [] if @generic.nil?
    @generic.push(hash)
  end

  # Aggiunge le opzioni d'aspetto
  def self.push_appearance_option(hash)
    if @appearance.nil?
      @appearance = [{:type => :separator, :text => APPEARANCE_OPTIONS}]
    end
    @appearance.push(hash)
  end

  # Aggiunge le opzioni di gioco
  def self.push_game_option(hash)
    if @game.nil?
      @game = [{:type => :separator, :text => GAME_OPTIONS}]
    end
    @game.push(hash)
  end

  # Aggiunge le opzioni audio
  def self.push_sound_option(hash)
    if @sound.nil?
      @sound = [{:type => :separator, :text => SOUND_OPTIONS}]
    end
    @sound.push(hash)
  end

  # Aggiunge le opzioni grafiche
  def self.push_graphic_option(hash)
    if @graphic.nil?
      @graphic = [{:type => :separator, :text => GRAPHIC_OPTIONS}]
    end
    @graphic.push(hash)
  end

  # Aggiunge le opzioni internet
  def self.push_internet_option(hash)
    if @internet.nil?
      @internet = [{:type => :separator, :text => INTERNET_OPTIONS}]
    end
    @internet.push(hash)
  end

  # Restituisce la lista delle opzioni
  def self.option_list
    options = []
    all_options.each { |option|
      opt = Option.new(option)
      next if opt.for_game? and $game_temp.nil? || $game_temp.in_game == false
      options.push(opt)
    }
    return options
  end
end

#==============================================================================
# ** classe Scene_Menu
#------------------------------------------------------------------------------
#  Aggiunta del comando Opzioni
#==============================================================================
class Scene_Menu < Scene_MenuBase
  alias h87options_create_command_window create_command_window unless $@
  # Finestra comandi
  def create_command_window
    h87options_create_command_window
    @command_window.set_handler(:options, method(:command_options))
  end

  # Vai alle opzioni
  def command_options
    $game_temp.in_game = true
    SceneManager.call(Scene_Options)
  end
end

#==============================================================================
# ** Classe Window_MenuCommand
#------------------------------------------------------------------------------
#  Aggiunta del comando Opzioni
#==============================================================================
class Window_MenuCommand < Window_Command
  alias h87options_aoc add_original_commands unless $@
  # Aggiunta del comando
  def add_original_commands
    h87options_aoc
    if H87Options::SHOW_ON_MENU
      add_command(H87Options::OPTION_COMMAND, :options, true)
    end
  end
end

#==============================================================================
# ** classe Scene_Title
#------------------------------------------------------------------------------
#  Aggiunta del comando per andare alle opzioni
#==============================================================================
class Scene_Title < Scene_Base
  alias h87options_create_command_window create_command_window unless $@
  # Aggiunta dell'evento
  def create_command_window
    h87options_create_command_window
    @command_window.set_handler(:options, method(:command_options))
  end

  # Comando per le opzioni
  def command_options
    $game_temp.in_game = false
    SceneManager.call(Scene_Options)
  end

  # Aggiunta del comando del menu titolo personalizzato
  if $imported["H87_TitleMenu"]
    alias h87options_ccp crea_contenuti_personalizzati

    def crea_contenuti_personalizzati
      h87options_ccp
      if H87Options::SHOW_ON_TITLE
        add_cursor(:options, "command_options", H87Options::TITLE_ICON, H87Options::TITLE_BALOON)
      end
    end
  end
end

#==============================================================================
# ** Classe Window_TitleCommand
#------------------------------------------------------------------------------
#  Aggiunta del comando Opzioni
#==============================================================================
class Window_TitleCommand < Window_Command
  alias h87options_aoc make_command_list unless $@
  # Aggiunta del comando
  def make_command_list
    h87options_aoc
    if H87Options::SHOW_ON_TITLE
      add_command(H87Options::OPTION_COMMAND, :options, true)
    end
  end
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  Modifica del caricamento iniziale
#==============================================================================
module DataManager
  class << self
    alias h87options_cgo create_game_objects
  end

  # Alias caricamento DB
  def self.create_game_objects
    h87options_cgo
    initialize_options
  end

  # Inizializza le variabili globali
  def self.initialize_options
    for option in H87Options.option_list
      next if $game_settings[option.id] != nil
      next if option.value != nil
      option.value = option.default if option.default != nil
      option.set_switch(true) if option.type == :bar
    end
  end
end

#==============================================================================
# ** Classe Option
#------------------------------------------------------------------------------
#  Contiene le impostazioni della singola opzione di gioco
#==============================================================================
class Option
  # Variabili d'istanza pubblici
  attr_reader :type #tipo
  attr_reader :description #descrizione
  attr_reader :name #nome
  attr_reader :values #elenco valori
  attr_reader :max #massimo della variabile
  attr_reader :min #minimo della variabile
  attr_reader :default #valore predefinito
  attr_reader :value_method #metodo che restituisce il valore
  attr_reader :bar_color #colore della barra
  attr_reader :tag #etichetta (per salvataggio in game_settings)
  attr_reader :id #identificatore (per trovarlo altrove)
  # Inizializzazione
  def initialize(hash)
    @type = hash[:type]
    @description = hash[:help]
    @name = hash[:text]
    @for_game = hash[:in_game]
    @tag = hash[:tag]
    @default = hash[:default]
    @id = hash[:id]
    @min = 0
    # noinspection RubyCaseWithoutElseBlockInspection
    case @type
    when :switch;
      init_switch(hash)
    when :variable;
      init_variable(hash)
    when :separator;
      init_separator(hash)
    when :advanced;
      init_advanced(hash)
    when :bar;
      init_bar(hash)
    end
    @method = hash[:method]
    @value_method = hash[:val_mt] unless hash[:val_mt].nil?
    @special_draw = hash[:special] unless hash[:special].nil?
    @enabled_condition = hash[:condition] unless hash[:condition].nil?
  end

  # Inizializza gli attributi dello switch
  def init_switch(hash)
    @default = false if @default.nil? && !hash[:not_initialize]
    @switch = hash[:sw]
    @values = [hash[:off], hash[:on]]
  end

  # Inizializza gli attributi della variabile
  def init_variable(hash)
    @distance = hash[:distance].nil? ? 1 : hash[:distance]
    @variable = hash[:var]
    @need_popup = hash[:open_popup]
    @popup = eval(hash[:popup]) if hash[:popup]
    @default = 0 if @default.nil? && !hash[:not_initialize]
    if hash[:values].nil?
      @values = []
      @max = hash[:max]
      @min = hash[:min] if hash[:min]
      (@min..@max).each { |i|
        @values.push(i)
      }
    else
      @values = hash[:values]
      @max = @values.size - 1
    end
  end

  # Restituisce il valore minimo
  def min
    @min || 0;
  end

  # Inizializza gli attributi del separatore
  def init_separator(hash) end

  # Inizializza gli attributi dell'oggetto avanzato
  def init_advanced(hash)
    @popup = eval(hash[:popup]) if hash[:popup]
  end

  # Inizializza gli attributi della barra
  def init_bar(hash)
    @max = hash[:max]
    @min = hash[:min] if hash[:min]
    @perc = hash[:perc] == false ? false : true
    @variable = hash[:var]
    @default = 0 if @default.nil? && !hash[:not_initialize]
    @switch = hash[:sw] if hash[:sw] != nil
    @distance = hash[:distance].nil? ? 1 : hash[:distance]
    @bar_color = 1
    @bar_color = hash[:color] if hash[:color]
  end

  # Restituisce il valore dell'opzione
  def value
    return method(@value_method).call if @value_method != nil
    case @type
    when :switch
      return switch
    when :variable, :bar
      return variable
    else
      0
    end
  end

  # Imposta il valore dell'opzione
  def value=(new_value)
    case @type
    when :switch
      set_switch(new_value)
    when :variable, :bar
      set_variable(new_value)
    end
    method(@method).call(new_value) if @method
  end

  # Cambia lo stato della switch
  def toggle
    set_switch(!self.switch) if @switch
    method(@method).call(self.switch) if @method
  end

  # Incrementa il valore dell'opzione
  def increment(fast = false)
    if @type == :switch
      toggle
    else
      set_switch(true)
      self.value += calc_distance(fast)
      if @type == :variable
        self.value = self.min if self.value > @max
      else
        #barra
        self.value = @max if self.value > @max
      end
    end
  end

  # Decrementa il valore dell'opzione
  def decrement(fast = false)
    if @type == :switch
      toggle
    else
      set_switch(true)
      self.value -= calc_distance(fast)
      if @type == :variable
        self.value = @max if self.value < self.min
      else
        #barra
        self.value = self.min if self.value < self.min
      end
    end
  end

  # Restituisce l'incremento o decremento
  def calc_distance(fast)
    return @distance unless @type == :bar
    return @distance unless fast
    @distance * 10
  end

  # Restituisce la classe della finestra di popup
  def popup
    return @popup if @popup
    return Generic_PopupWindow if @need_popup
    nil
  end

  # Restituisce l'ID dello switch o variabile assegnato
  def id
    return @variable if @variable != nil
    return @switch if @switch != nil
    @tag
  end

  # Restituisce lo stato della switch
  def switch
    return true if @switch.nil?
    return true if @switch == 0
    if @switch.is_a?(Integer)
      $game_switches[@switch]
    else
      $game_settings[@switch]
    end
  end

  # Imposta lo stato della switch
  def set_switch(value)
    return if @switch.nil?
    return if @switch == 0
    if @switch.is_a?(Integer)
      $game_switches[@switch] = value
    else
      $game_settings[@switch] = value
    end
  end

  # Restituisce lo stato della variabile
  def variable
    return 0 if @variable == 0
    if @variable.is_a?(Integer)
      $game_variables[@variable]
    else
      $game_settings[@variable]
    end
  end

  # Imposta lo stato della variabile
  def set_variable(value)
    return if @variable == 0
    if @variable.is_a?(Integer)
      $game_variables[@variable] = value
    else
      $game_settings[@variable] = value
    end
  end

  # Restituisce true se l'opzione ha una switch
  def toggable?
    @switch != nil
  end

  # Restituisce le condizioni di abilitazione dell'opzione
  def enabled?
    if $game_system != nil && self.tag != nil &&
        $game_system.enabling_options[self.tag] == false
      return false
    end
    return true if @enabled_condition.nil?
    eval(@enabled_condition)
  end

  # Restituisce true se mostra la percentuale (la barra)
  def show_perc?
    @perc
  end

  # Restituisce true se è un separatore
  def separator?
    @type == :separator
  end

  # Restituisce true se è un'opzione disponibile solo nella partita
  #   (ossia, non visibile nella schermata del titolo)
  def for_game?
    return true if @variable.is_a?(Integer)
    return true if @switch.is_a?(Integer)
    return true if @for_game
    false
  end

  # Restituisce true se l'opzione apre un popup
  def open_popup?
    self.popup != nil
  end

  # Restituisce true se l'opzione è disponibile e configurabile
  def value_active?(value_index)
    if @type == :switch
      value_index == 1 && value ? true : false
    elsif @type == :variable
      value == value_index * @distance
    else
      true
    end
  end

  # Restituisce true se l'opzione è attiva
  def is_on?
    self.switch
  end

  # Restituisc true se l'opzione può essere decrementata
  def can_decrement?
    return false if @type == :advanced
    return false if @type == :bar && self.value <= self.min
    return false if @need_popup
    return false unless [:variable, :switch, :bar].include?(@type)
    true
  end

  # Restituisce true se l'opzione può essere incrementata
  def can_increment?
    return false if @type == :advanced
    return false if @type == :bar && self.value >= self.max
    return false if @need_popup
    return false unless [:variable, :switch, :bar].include?(@type)
    true
  end

  # Esegue il metodo personalizzato dell'opzione
  def execute_method
    return unless @method
    method(@method).call
  end
end

#==============================================================================
# ** Scene_Options
#------------------------------------------------------------------------------
#  Schermata delle opzioni
#==============================================================================
class Scene_Options < Scene_MenuBase
  # Inizio
  def start
    super
    create_help_window
    create_option_window
    create_popup_windows
  end

  # Aggiornamento
  def update
    super
    update_popups
  end

  # Fine
  def terminate
    super
    dispose_popups
  end

  # Aggiorna le finestre di popup
  def update_popups
    @popups.each_value { |p| p.update }
  end

  # Elimina le finestre di popup
  def dispose_popups
    @popups.each_value { |p| p.dispose }
  end

  # Creazione della finestra d'aiuto
  def create_help_window
    @help_window = Window_Help.new
  end

  # Creazione della finestra delle opzioni
  def create_option_window
    @option_window = Window_GameOptions.new(@help_window.y + @help_window.height)
    @option_window.help_window = @help_window
    @option_window.set_handler(:cancel, method(:return_scene))
    @option_window.activate
  end

  # Crea le finestre di popup
  def create_popup_windows
    @popups = {}
    opt = H87Options.option_list
    y = @help_window.height
    for i in 0..opt.size - 1
      if opt[i].popup
        popup = opt[i].popup.new(y, opt[i])
        popup.visible = false
        popup.set_handler(:cancel, method(:close_popup))
        popup.set_handler(:ok, method(:item_selected))
        @popups[i] = popup
      end
    end
  end

  # Restituisce la finestra di popup attualmente aperta
  def popup
    @popups[@popup_index]
  end

  # Mostra la finestra di popup
  #   index: indice dell'opzione
  def show_popup(index)
    @last_frame = Graphics.frame_count
    @popup_index = index
    x = Graphics.width - popup.width
    y = @help_window.height
    popup.x = Graphics.width
    popup.visible = true
    if $imported["H87_SmoothMovements"]
      @option_window.smooth_move(0 - popup.width, y)
      popup.smooth_move(x, y)
    else
      @option_window.x = 0 - popup.width
      popup.x = x
    end
    popup.activate
  end

  # Viene eseguito quando l'utente seleziona un'opzione dal popup
  def item_selected
    if @last_frame < Graphics.frame_count
      @option_window.item.value = popup.selected_value
      @option_window.refresh
      @help_window.refresh
      close_popup
    else
      popup.activate
    end
  end

  # Chiude la finestra di popup
  def close_popup
    popup.deactivate
    x = Graphics.width
    y = @help_window.height
    if $imported["H87_SmoothMovements"]
      @option_window.smooth_move(0, y)
      popup.smooth_move(x, y)
    else
      @option_window.x = 0
      popup.x = x
    end
    @option_window.activate
    @popup_index = nil
  end
end

#==============================================================================
# ** Window_GameOptions
#------------------------------------------------------------------------------
#  Finestra che contiene l'elenco delle opzioni
#==============================================================================
class Window_GameOptions < Window_Selectable
  # Inizializzazione
  #   y: coordinata Y iniziale
  def initialize(y)
    super(0, y, Graphics.width, Graphics.height - y)
    @data = []
    make_option_list
    create_contents
    refresh
    self.index = 0
    cursor_down if item && item.separator?
  end

  # draw_item
  #   index: indice dell
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect_for_text(index)
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_state(rect, item)
    end
  end

  # Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    change_color(normal_color, enabled)
    draw_text(x, y, width, line_height, item.name) unless item.separator?
  end

  # Mostra lo stato dell'opzione a seconda del tipo
  def draw_item_state(rect, item)
    case item.type
    when :separator
      draw_separator(rect, item)
    when :switch
      draw_switch(rect, item)
    when :variable
      draw_variable(rect, item)
    when :bar
      draw_bar(rect, item)
    when :advanced
      draw_advanced(rect, item)
    else
      # do nothing
    end
  end

  # Disegna il separatore
  def draw_separator(rect, item)
    color = gauge_back_color
    color.alpha = 128
    contents.fill_rect(rect.x, rect.y + 2, rect.width, rect.height - 4, color)
    draw_text(rect.x, rect.y, rect.width, line_height, item.name, 1)
  end

  # Move Cursor Down
  def cursor_down(wrap = false)
    super
    super if item.separator?
  end

  # Move Cursor Up
  def cursor_up(wrap = false)
    super
    if item.separator?
      self.index == 0 && !wrap ? cursor_down : super
    end
  end

  # Disegna lo switch
  def draw_switch(rect, item)
    x = get_state_x(rect)
    width = get_state_width(x, rect, item)
    change_color(normal_color, enable?(item) && !item.value)
    contents.draw_text(x, rect.y, width, line_height, item.values[0], 1)
    x += width
    change_color(normal_color, enable?(item) && item.value)
    contents.draw_text(x, rect.y, width, line_height, item.values[1], 1)
  end

  # Disegna la variabile
  def draw_variable(rect, item)
    if item.open_popup?
      draw_popup_variable(rect, item)
    else
      draw_values_variable(rect, item)
    end
  end

  # Disegna la variabile se apre un popup
  def draw_popup_variable(rect, item)
    x = get_state_x(rect)
    width = rect.width - x
    change_color(normal_color, enable?(item))
    draw_text(x, rect.y, width, line_height, item.values[item.value], 1)
  end

  # Disegna i valori della variabile
  def draw_values_variable(rect, item)
    x = get_state_x(rect)
    width = get_state_width(x, rect, item)
    for i in 0..item.max
      next if item.values[i].nil?
      change_color(normal_color, enable?(item) && item.value_active?(i))
      draw_text(x + (width * i), rect.y, width, line_height, item.values[i], 1)
    end
  end

  # Disegna la barra
  def draw_bar(rect, item)
    x = get_state_x(rect)
    width = rect.width - x
    if item.bar_color.is_a?(Color)
      color = item.bar_color
    else
      color = text_color(item.bar_color)
    end
    color.alpha = enable?(item) ? 255 : 128
    contents.fill_rect(x, rect.y + 5, width, line_height - 10, color)
    contents.clear_rect(x + 1, rect.y + 6, width - 2, line_height - 12)
    rate = (item.value - item.min) / (item.max.to_f - item.min.to_f)
    contents.fill_rect(x, rect.y + 5, width * rate, line_height - 10, color)
    if item.is_on?
      change_color(normal_color, enable?(item))
      if item.show_perc?
        text = sprintf("%2d%%", rate * 100)
      else
        text = item.value.to_i
      end
    else
      change_color(power_down_color, enable?(item))
      text = H87Options::OFF_BAR
    end
    draw_text(x, rect.y, width, line_height, text, 1)
  end

  # Disegna il valore del metodo avanzato
  def draw_advanced(rect, item) end

  # Update Help Text
  def update_help
    @help_window.set_item(item)
  end

  # Creazione della lista delle opzioni
  def make_option_list
    @data = H87Options.option_list
  end

  # Get Number of Items
  def item_max
    @data ? @data.size : 0
  end

  # Display in Enabled State?
  def enable?(item)
    item.enabled?
  end

  # Restituisce l'opzione selezionata
  def item
    @data[index]
  end

  # Restituisce la coordinata X dove disegnare lo stato
  def get_state_x(rect)
    rect.x + rect.width / 2
  end

  # Restituisce la larghezza del valore in caso di più valori
  def get_state_width(x, rect, item)
    (rect.width - x) / item.values.size
  end

  # Esecuzione dell'azione di selezione (INVIO)
  def action
    case item.type
    when :switch, :bar
      toggle_item
    when :advanced
      process_method
    when :variable
      open_popup
    else
      process_custom_method
    end
  end

  # Esegui un metodo personalizzato
  def process_custom_method
    # da implementare per eventuali estensioni
  end

  # Cambia lo stato della switch dell'opzione
  def toggle_item
    return unless item.toggable?
    item.toggle
    RPG::SE.new(H87Options::TOGGLE_SOUND).play
    refresh
    activate
  end

  # Chiama il metodo
  def process_method
    item.execute_method
    open_popup
  end

  # Apre il popup
  def open_popup
    return unless item.popup
    Sound.play_ok
    SceneManager.scene.show_popup(self.index)
    deactivate
  end

  # Aggiornamento
  def update
    return if disposed?
    super
    update_other_commands
  end

  # Aggiorna gli altri comandi
  def update_other_commands
    return unless active && cursor_movable?
    shift_left if Input.repeat?(:LEFT)
    shift_right if Input.repeat?(:RIGHT)
    #shift_left(true) if Input.repeat?(:L)
    #shift_right(true) if Input.repeat?(:R)
    action if Input.trigger?(:C) && enable?(item)
  end

  # Scorri a sinistra se è una variabile o una barra
  def shift_left(fast = false)
    return unless item.can_decrement?
    return unless enable?(item)
    item.decrement(fast || Input.press?(:A))
    Sound.play_cursor
    refresh
  end

  # Scorri a destra se è una variabile o una barra
  def shift_right(fast = false)
    return unless item.can_increment?
    return unless enable?(item)
    item.increment(fast || Input.press?(:A))
    Sound.play_cursor
    refresh
  end
end

#==============================================================================
# ** Window_OptionPopup
#------------------------------------------------------------------------------
#  Classe d'appoggio per le finestre di popup
#==============================================================================
class Window_OptionPopup < Window_Selectable
  # Inizializzazione
  def initialize(y, option, width = 200)
    super(Graphics.width, y, width, Graphics.height - y)
    @option = option
    @data = []
    refresh
    select_last
  end

  # Refresh
  def refresh
    make_option_list
    create_contents
    draw_all_items
  end

  # Ottiene la lista delle opzioni dei valori
  def make_option_list
  end

  # Restituisce il numero di oggetti
  def item_max
    @data.nil? ? 0 : @data.size
  end

  # Restituisce l'opzione selezionata
  def select_last
  end

  # Restituisce la nuova opzione selezionata dall'utente
  def selected_value
    @keys ? @keys[self.index] : self.index
  end
end

#==============================================================================
# ** Generic_PopupWindow
#------------------------------------------------------------------------------
#  Finestra dei popup generici delle opzioni
#==============================================================================
class Generic_PopupWindow < Window_OptionPopup
  # Inizializzazione
  #   y: coordinata Y
  #   option: opzione del popup
  def initialize(y, option)
    super(y, option, 200)
  end

  # disegna l'oggetto
  def draw_item(index)
    rect = item_rect(index)
    draw_text(rect, item(index))
  end

  # Ottiene l'elenco dei valori dell'opzione
  def make_option_list
    @data = @option.values
    if @data.is_a?(Hash)
      @keys = @data.keys
      @data = @data.values
    end
  end

  # Restituisce il valore selezionato
  def item(index = self.index)
    @data[index]
  end

  # Restituisce la chiave
  def key(index = self.index)
    @keys[index]
  end

  # Restituisce l'opzione selezionata
  def select_last
    if @option.values.is_a?(Array)
      self.index = [[@option.value, 0].max, @option.values.size - 1].min
    else
      self.index = keys_from_hash
    end
  end

  # Restituisce l'opzione selezionata dall'hash dei valori
  def keys_from_hash
    if @keys.include?(@option.value)
      @keys.find_index(@option.value)
    else
      0
    end
  end
end

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  Aggiunta dei parametri
#==============================================================================
class Game_Temp
  attr_accessor :in_game
end

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  Aggiunta dei parametri
#==============================================================================
class Game_System
  attr_accessor :enabling_options

  def option_enable(tag, state)
    @enabling_options = {} if @enabling_options.nil?
    @enabling_options[tag] = state
  end
end