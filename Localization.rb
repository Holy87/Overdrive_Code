
=begin
 ==============================================================================
  ■ Localizzazione del gioco di Holy87
      versione 1.0.3
      Difficoltà utente: ★★★
      Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
      lo script nei propri progetti, sia amatoriali che commerciali. Vietata
      l'attribuzione impropria.
 ==============================================================================
    Questo script permette al gioco di essere multilingua! Si possono creare
    file della lingua diversi per poter permettere ai giocatori di giocare alla
    loro lingua madre.
 ==============================================================================
  ■ Compatibilità
    DataManager -> alias load_normal_database
    Bitmap -> alias initialize, draw_text
 ==============================================================================
  ■ Changelog
    25/06/2015 -> v1.0.3
    ● È possibile interpolare stringhe semplici con stringhe localizzate, ad
      esempio "{S: hello} Eric!" -> "Ciao Eric!"
    ● È possibile inserire più chiavi localizzate in una sola stringa, ad esempio
      "{S: hello} {S: friends}" -> "Ciao amici"
    23/06/2015 -> v1.0.2
    ● Risolto il bug per i due punti : nei messaggi
    ● Risolto il bug del tag nome eroe nei messaggi \n
    ● Risolto il glitch per la finestra delle scelte dei messaggi
    07/06/2015 -> v1.0.1
    ● Ora se una stringa nella lingua selezionata non è stata trovata, prende
      la stringa dalla lingua standard se c'è, altrimenti dalla lingua predefinita
      invece di mostrare una stringa vuota.
    ● Altri bugfix
 ==============================================================================
  ■ Installazione e istruzioni
    Installare questo script sotto Materials e prima del Main.
    RICHIEDE IL MODULO DI SUPPORTO UNIVERSALE DI HOLY87.
    Lo script delle opzioni di gioco, se presente, deve stare sopra di questo
    script.
    
  ■ Istruzioni per come impostare il gioco
      
    ● Prima di tutto, creare la cartella Localization all'interno della
      cartella principale del progetto. All'interno di questo bisogna creare
      tanti file quante le lingue volute. Esempio: Voglio creare il file della
      lingua italiana. Creo il file it.ini, dove it è il diminutivo di italiano
      e ini è l'estensione del file (basta cambiare .txt in .ini). È importante
      che la lingua abbia l'estensione del file scelta.
      Apri il file, e la prima cosa da creare all'interno è un tag dove inserirci
      le informazioni sulla lingua. Quindi
      <header>
      Language:Italiano
      ID:1040
      </header>
      Language è la lingua mostrata nelle opzioni, mentre ID è l'ID della lingua
      del sistema, in modo che se la lingua di Windows è impostata in Italiano,
      il gioco partirà direttamente con la lingua italiana. Tutti i codici delle
      lingue puoi trovarli a questa pagina
      http://support.microsoft.com/kb/193080
      https://msdn.microsoft.com/en-US/library/ee825488(v=cs.20).aspx
      
    ● La seconda cosa da fare è creare le stringhe che ci servono vengano messe
      nel gioco. Crea il tag strings come abbiamo fatto con header. Ad esempio
      <strings>
      greetings:Ciao!
      defeat:Sei stato sconfitto.
      </strings>
      È importante che le stringhe siano SULLA STESSA RIGA. Metti il simbolo \n
      se vuoi che il testo vada a capo nel gioco.
      
    ● Nel gioco, metti il tag {S: NomeStringa} per sostituire il testo con la
      stringa nell'appropriato file della lingua. Ad esempio, se in un messaggio
      del gioco o in qualsiasi altra parte scriverai {S: greetings}, al momento
      del gioco, se impostata la lingua italiana, il giocatore vedrà la scritta
      Ciao! al posto del tag.
      Funziona anche con gli oggetti del database e tutti gli script che hai
      installato!
      
    ● In verità, c'è un altro modo per gli oggetti del database. Puoi creare
      altri tag con header items, skills, ecc... contenenti le informazioni di
      ogni elemento del database per attributi. Ad esempio, scrivendo
      <skills>
      ID:1, name:Attacca, description:Attacca con l'arma equipaggiata; message1: attacca!
      </skills>
      Il punto e virgola separa gli attributi. Per mostrare il ; nel gioco,
      scrivi \;
      La skill 1 del database avrà nome, descrizione e messaggio indicati nel
      file della lingua. Una volta ultimato non resterà che modificare il file
      per le altre lingue.
      
    ● E per le immagini?
      Nel caso tu abbia delle immagini che mostrano un testo e vuoi mostrare
      un'immagine differente a seconda della lingua selezionata, basterà mettere
      più immagini con la differenza che nel nome finale metto _lingua.
      Ad esempio, se ho un'immagine chiamata Nuvola.png nella cartella Pictures,
      creo l'immagine Nuvola_it.png e Nuvola_fr.png nella stessa cartella.
      Se il gioco ha la lingua italiana, quando andrò a caricare Nuvola vedrò
      l'immagine Nuvola_it, mentre in francese Nuvola_en e in tutte le altre
      lingue la classica Nuvola.
 ==============================================================================
=end
#==============================================================================
# ** SETTINGS
#------------------------------------------------------------------------------
#  Imposta le opzioni dello script
#==============================================================================
module H87Localization
  module Settings
    #--------------------------------------------------------------------------
    # * Lingua predefinita se non è installata quella del sistema
    #--------------------------------------------------------------------------
    DEFAULT_LANGUAGE = "en"
    #--------------------------------------------------------------------------
    # * Cartella dei file della lingua
    #--------------------------------------------------------------------------
    LANG_FOLDER = "Localization"
    #--------------------------------------------------------------------------
    # * Comando nelle opzioni
    #--------------------------------------------------------------------------
    OPTION_LANGUAGE = "{S: Lang_Option}"
    #--------------------------------------------------------------------------
    # * Descrizione del comando nelle opzioni
    #--------------------------------------------------------------------------
    OPTION_DESCRIPTION = "{S: Lang_Description}"
  end
end

#---------------------------- FINE CONFIGURAZIONE ------------------------------






$imported = {} if $imported == nil
$imported["H87_Localization"] = 1.0

#==============================================================================
# ** module H87Localization
#------------------------------------------------------------------------------
#  Module for language-check processing.
#==============================================================================
module H87Localization 
                          
  REG_EXCAPE = /\{S:[ ]+(.+?)\}/
  #--------------------------------------------------------------------------
  # * Gets a string. If it contains a reference to a localized strings, returns
  #   the localized strings. Otherwise, the string itself.
  #   str: string to check
  #--------------------------------------------------------------------------
  def self.check_localized_string(str)
    DataManager.load_localization if $data_localization.nil?
    r = REG_EXCAPE
    return str.to_s.gsub(r){|s|get_localized_string($1) if s =~ r}
  end
  #--------------------------------------------------------------------------
  # * Returns the selected language (if set by user or system default)
  #--------------------------------------------------------------------------
  def self.selected_system_language
    DataManager.load_h87settings unless $game_settings
    if $game_settings["sys_lang"].nil? 
      return default_game_language
    else
      return $game_settings["sys_lang"]
    end
  end
  #--------------------------------------------------------------------------
  # * Returns the default language if not setted by user
  #--------------------------------------------------------------------------
  def self.default_game_language
    proper_l(system_language)
  end
  #--------------------------------------------------------------------------
  # * Returns the Windows language.
  #--------------------------------------------------------------------------
  def self.system_language
    code = Win.language
    return default_language if lang_from_code(code).nil?
    return lang_from_code(code)
  end
  #--------------------------------------------------------------------------
  # * Checks if there is the language with sub-language, otherwise returns
  #   the traditional language
  #--------------------------------------------------------------------------
  def self.proper_l(lang)
    if language_avaiable?(lang)
      return lang
    else
      return dialet?(lang) ? proper_l(base_language(lang)) : default_language
    end
  end
  #--------------------------------------------------------------------------
  # * Returns the traditional language from the dialet.
  #   lang: language (i.e. "en-uk" -> "en")
  #--------------------------------------------------------------------------
  def base_language(lang)
    return lang unless dialet?(lang)
    return lang.split("-")[0]
  end
  #--------------------------------------------------------------------------
  # * Returns the language short name (es. "en") from a code (es. 1033)
  #--------------------------------------------------------------------------
  def self.lang_from_code(code)
    installed_languages.each do |language|
      return language.short if language.id == code
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Return true if a language is installed
  #   lang: language short name
  #--------------------------------------------------------------------------
  def self.language_avaiable?(lang)
    installed_languages.each do |language|
      return true if lang == language.short
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Return the language file name
  #   lang: language short name
  #--------------------------------------------------------------------------
  def self.language_file(lang)
    language_folder+"/#{lang}.ini"
  end
  #--------------------------------------------------------------------------
  # * Return the language files folder
  #--------------------------------------------------------------------------
  def self.language_folder
    return Settings::LANG_FOLDER
  end
  #--------------------------------------------------------------------------
  # * Return the default language when the player's language is not avaiable
  #--------------------------------------------------------------------------
  def self.default_language
    Settings::DEFAULT_LANGUAGE
  end
  #--------------------------------------------------------------------------
  # * Return true if the language is a traditional language or a sub-language.
  #   lang: language. I.E.: en-uk => true, en => false
  #--------------------------------------------------------------------------
  def self.dialet?(lang)
    return lang =~ /[.]+\-[.]+/
  end
  #--------------------------------------------------------------------------
  # * Return the avaiable languages list
  #--------------------------------------------------------------------------
  def self.installed_languages
    @languages = check_installed_languages if @languages.nil?
    return @languages
  end
  #--------------------------------------------------------------------------
  # * Checks all the languages in language folder.
  #--------------------------------------------------------------------------
  def self.check_installed_languages
    languages = []
    Dir.foreach(language_folder) {|x|
      next if x == "." or x == ".."
      file_name = language_folder+"/"+x
      next if File.directory?(file_name)
      dl = Data_Localization.new
      File.open(file_name,"r") do |file|
        if dl.language_ok?(file.read)
          short = File.basename(file_name,".*")
          name = dl.lang_name
          id = dl.lang_id
          languages.push(Language.new(id, short, name))
        end
      end
    }
    return languages
  end
  #--------------------------------------------------------------------------
  # * Return the Option hash (if Option Menu is installed)
  #--------------------------------------------------------------------------
  def self.create_option
    { :type => :variable,
      :text => Settings::OPTION_LANGUAGE,
      :help => Settings::OPTION_DESCRIPTION,
      :var  => "sys_lang",
      :open_popup => true,
      :method => :update_language,
      :val_mt => :selected_language,
      :values => installed_languages_names
    }
  end
  #--------------------------------------------------------------------------
  # * Return the name of all avaiable languages
  #--------------------------------------------------------------------------
  def self.installed_languages_names
    hash = {}
    for language in installed_languages
      hash[language.short] = language.name
    end
    return hash
  end
  #--------------------------------------------------------------------------
  # * Return the proper string from a tag.
  #--------------------------------------------------------------------------
  def self.get_localized_string(string_id)
    DataManager.load_localization unless $data_localization
    return $data_localization.get_string(string_id)
  end
end

#==============================================================================
# ** class Option
#------------------------------------------------------------------------------
#  Loading language after selecting a new lang.
#==============================================================================
class Option
  #--------------------------------------------------------------------------
  # * Reload the language after selection
  #--------------------------------------------------------------------------
  def update_language(lang)
    DataManager.load_localization unless $data_localization
    $data_localization.load_language(lang)
  end
  #--------------------------------------------------------------------------
  # * Get the saved languages form options, or default language
  #--------------------------------------------------------------------------
  def selected_language
    return $game_settings["sys_lang"] if $game_settings["sys_lang"] != nil
    return H87Localization.default_game_language
  end
end

#==============================================================================
# ** Bitmap
#------------------------------------------------------------------------------
#  Methods for taking the right bitmap and draw proper text
#==============================================================================
class Bitmap
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias h87localization_dt draw_text unless $@
  alias h87localization_init initialize unless $@
  #--------------------------------------------------------------------------
  # * Object initialization
  #--------------------------------------------------------------------------
#~   def initialize(*args)
#~     if args[0].is_a?(String)
#~       begin
#~         DataManager.load_h87settings unless $game_settings
#~         DataManager.load_localization unless $data_localization
#~         args2 = args.clone
#~         args2[0]+="_#{$game_settings["sys_lang"]}"
#~         h87localization_init(*args2)
#~       rescue
#~         h87localization_init(*args)
#~       end
#~     else
#~       h87localization_init(*args)
#~     end
#~   end
  #--------------------------------------------------------------------------
  # * draw_text
  #--------------------------------------------------------------------------
  def draw_text(*args)
    a_index = args[0].is_a?(Rect) ? 1 : 4
    args[a_index] = H87Localization.check_localized_string(args[a_index])
    h87localization_dt(*args)
  end
end

module Cache
   class << self
     alias old_load_bitmap load_bitmap
   end
   #--------------------------------------------------------------------------
   # * Load Bitmap
   #--------------------------------------------------------------------------
   def self.load_bitmap(folder_name, filename, hue = 0)
     if !Dir.glob(folder_name + filename + "_" + current_language + ".*").empty?
       old_load_bitmap(folder_name, filename + "_" + current_language, hue)
     else
       old_load_bitmap(folder_name, filename, hue)
     end
   end
end

#==============================================================================
# ** class Object
#------------------------------------------------------------------------------
#  Changing sprintf method
#==============================================================================
class Object
  alias unlocalized_sprintf sprintf unless $@
  #--------------------------------------------------------------------------
  # * sprintf
  #--------------------------------------------------------------------------
  def sprintf(*args)
    args[0]=H87Localization.check_localized_string(args[0])
    unlocalized_sprintf(*args)
  end
  #--------------------------------------------------------------------------
  # * current_language method
  #--------------------------------------------------------------------------
  def current_language
    return default_game_language.to_s unless $game_settings["sys_lang"]
    return $game_settings["sys_lang"]
  end
end

#==============================================================================
# ** class Language
#------------------------------------------------------------------------------
#  A simple class for handling languages
#==============================================================================
class Language
  #--------------------------------------------------------------------------
  # * Public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :id       #language ID
  attr_accessor :short    #language short name
  attr_accessor :name     #language true name
  #--------------------------------------------------------------------------
  # * Object initialization
  #--------------------------------------------------------------------------
  def initialize(id, short, name)
    @id = id.to_i
    @short = short
    @name = name
  end
end

#==============================================================================
# ** module DataManager
#------------------------------------------------------------------------------
#  For language loading
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  class << self
    alias h87loc_load_n_db load_normal_database
    alias h87loc_load_b_db load_battle_test_database
  end
  # -------------------------------------------------------------------------- 
  # * database loading
  # --------------------------------------------------------------------------
  def self.load_normal_database
    h87loc_load_n_db
    load_localization
  end
  # -------------------------------------------------------------------------- 
  # * bt loading
  # --------------------------------------------------------------------------
  def self.load_battle_test_database
    h87loc_load_b_db
    load_localization if $data_localization.nil?
  end
  #--------------------------------------------------------------------------
  # * language loading
  #--------------------------------------------------------------------------
  def self.load_localization
    $data_localization = Data_Localization.new
    $data_localization.load_language(H87Localization.selected_system_language)
  end
end

#==============================================================================
# ** class Window_Base
#------------------------------------------------------------------------------
#  Changing method for advanced text drawing
#==============================================================================
class Window_Base < Window
  alias h87loc_dte draw_text_ex unless $@
  #--------------------------------------------------------------------------
  # * draw_text_ex
  #--------------------------------------------------------------------------
  def draw_text_ex(x, y, text)
    h87loc_dte(x, y, H87Localization.check_localized_string(text))
  end
end

#==============================================================================
# ** class Game_Message
#------------------------------------------------------------------------------
#  Changing the text message
#==============================================================================
class Game_Message
  alias h87loc_add add unless $@
  #--------------------------------------------------------------------------
  # * Add Text
  #--------------------------------------------------------------------------
  def add(text)
    h87loc_add(H87Localization.check_localized_string(text))
  end
end

#==============================================================================
# ** class Game_Interpreter
#------------------------------------------------------------------------------
#  Game Interpreter class
#==============================================================================
class Game_Interpreter
  alias h87loc_setup_choices setup_choices unless $@
  #--------------------------------------------------------------------------
  # * Alias method for setup_choices, makes the choice window fit the text.
  #--------------------------------------------------------------------------
  def setup_choices(params)
    par0 = params.clone
    par0[0].map! {|text| H87Localization.check_localized_string(text) }
    h87loc_setup_choices(par0)
  end
end

#==============================================================================
# ** class Data_Localization
#------------------------------------------------------------------------------
#  Localization class for language and strings handling. Used in
#  $data_localization instance.
#==============================================================================
class Data_Localization
  #--------------------------------------------------------------------------
  # * public instance variables
  #--------------------------------------------------------------------------
  attr_reader :lang_name
  attr_accessor :language
  #--------------------------------------------------------------------------
  # * object initialization
  #--------------------------------------------------------------------------
  def initialize(lang = nil)
    @strings = {}
    load_language(lang, false) if lang
  end
  #--------------------------------------------------------------------------
  # * language ID/code
  #--------------------------------------------------------------------------
  def lang_id
    return @lang_id.to_i
  end
  #--------------------------------------------------------------------------
  # * Checks if a game string contains a loalized string
  #--------------------------------------------------------------------------
  def parse_string(string)
    H87Localization.check_localized_string(string)
  end
  #--------------------------------------------------------------------------
  # * Takes a string from the loaded strings of the active language
  #--------------------------------------------------------------------------
  def get_string(string_id)
    if @strings[string_id] != nil
      return @strings[string_id].gsub(/\\n[^\[^<]/i,"\n")
    else
      println "String not found for value #{string_id}"
      return string_from_other_languages(string_id, @language)
    end
  end
  #--------------------------------------------------------------------------
  # * Loads a new language
  #   lang_name: language short name
  #--------------------------------------------------------------------------
  def load_language(lang_name, database = true)
    @language = lang_name
    file = H87Localization.language_file(lang_name)
    unless File.exist?(file)
      println "Language file #{file} not found."
      return
    end
    File.open(file, "r") do |content|
      @readstring = content.read
    end
    if language_ok?(@readstring)
      load_database(@readstring) if $data_system && database
      load_strings(@readstring)
      println "Language loaded: #{file}."
    else
      println "Cannot read the #{file} file."
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Returns true if the file is a language file
  #--------------------------------------------------------------------------
  def language_ok?(readstring)
    return false unless readstring =~ category_regexp("header")
    info = string_array($1)
    begin
      @lang_name = info["Language"]
      @lang_id = info["ID"]
      return true
    rescue
      return false
    end
  end
  #--------------------------------------------------------------------------
  # * Load the localized database from file
  #--------------------------------------------------------------------------
  def load_database(readstring)
    load_items(readstring)
    load_skills(readstring)
    load_weapons(readstring)
    load_armors(readstring)
    load_enemies(readstring)
    load_actors(readstring)
    load_classes(readstring)
    load_states(readstring)
    load_terms(readstring)
  end
  #--------------------------------------------------------------------------
  # * Load items array
  #--------------------------------------------------------------------------
  def load_items(readstring)
    item_list = load_data(readstring, "items",:id, :name, :description)
    change_array($data_items, item_list)
  end
  #--------------------------------------------------------------------------
  # * Load skills array
  #--------------------------------------------------------------------------
  def load_skills(readstring)
    item_list = load_data(readstring, "skills",:id, :name, :description, 
    :message1, :message2)
    change_array($data_skills, item_list)
  end
  #--------------------------------------------------------------------------
  # * load weapons array
  #--------------------------------------------------------------------------
  def load_weapons(readstring)
    item_list = load_data(readstring, "weapons",:id, :name, :description)
    change_array($data_weapons, item_list)
  end
  #--------------------------------------------------------------------------
  # * load armors array
  #--------------------------------------------------------------------------
  def load_armors(readstring)
    item_list = load_data(readstring, "armors",:id, :name, :description)
    change_array($data_armors, item_list)
  end
  #--------------------------------------------------------------------------
  # * load enemies array
  #--------------------------------------------------------------------------
  def load_enemies(readstring)
    item_list = load_data(readstring, "enemies",:id, :name)
    change_array($data_enemies, item_list)
  end
  #--------------------------------------------------------------------------
  # * load actors array
  #--------------------------------------------------------------------------
  def load_actors(readstring)
    item_list = load_data(readstring, "actors",:id, :name, :title, :description)
    change_array($data_actors, item_list)
  end
  #--------------------------------------------------------------------------
  # * load class array
  #--------------------------------------------------------------------------
  def load_classes(readstring)
    item_list = load_data(readstring, "classes",:id, :name)
    change_array($data_classes, item_list)
  end
  #--------------------------------------------------------------------------
  # * load states array
  #--------------------------------------------------------------------------
  def load_states(readstring)
    item_list = load_data(readstring, "states",:id, :name, :message1, :message2,
    :message3, :message4)
    change_array($data_states, item_list)
  end
  #--------------------------------------------------------------------------
  # * load terms array
  #--------------------------------------------------------------------------
  def load_terms(readstring)
    terms = $data_system.terms
    basic = get_string_array(readstring, "basic")
    params = get_string_array(readstring, "params")
    etypes = get_string_array(readstring, "etypes")
    commands = get_string_array(readstring, "commands")
    set_terms(terms.basic, basic)
    set_terms(terms.params, params)
    set_terms(terms.etypes, etypes)
    set_terms(terms.commands, commands)
  end
  #--------------------------------------------------------------------------
  # * Takes a substring from the file depending from the <type>...</type> tag
  #--------------------------------------------------------------------------
  def category_regexp(cat_name)
    return /[.]*<#{cat_name}>(.*)<\/#{cat_name}>[.]*/im
  end
  #--------------------------------------------------------------------------
  # * Load generic game strings
  #--------------------------------------------------------------------------
  def load_strings(readstring)
    @strings = get_string_array(readstring, "strings")
  end
  #--------------------------------------------------------------------------
  # * returns the string array
  #   readstring: file readed
  #   #header: string type
  #--------------------------------------------------------------------------
  def get_string_array(readstring, header)
    if readstring =~ category_regexp(header)
      return string_array($1)
    end
  end
  #--------------------------------------------------------------------------
  # * takes the proper string from file to array
  #--------------------------------------------------------------------------
  def set_terms(terms_array, term_hash)
    return if term_hash.nil?
    for i in 0..terms_array.size-1
      next if term_hash[i.to_s].nil?
      terms_array[i] = term_hash[i.to_s]
    end
  end
  #--------------------------------------------------------------------------
  # * strings array creation
  #--------------------------------------------------------------------------
  def string_array(text)
    strings = {}
    text.split(/[\r\n]+/).each do |string|
      case string
      when /[\s]*([^:.]*+)[\s]*:[\s]*(.+)[\s]*/i
        key = $1
        val = $2
        key.gsub!(/[\t\n]/,""); val.gsub!(/[\t\n]/,"")
        if strings[key].nil?
          strings[key] = val
        else
          println "#{key} is defined twice!\n#{key}->#{strings[key]}\n#{$1}->#{val}"
        end
      end
    end
    return strings
  end
  #--------------------------------------------------------------------------
  # * Return the regexp for taking a parameter
  #--------------------------------------------------------------------------
  def param_regexp
    return /[\s]*(.+)[\s]*:(.+)[\s]*/i
  end
  #--------------------------------------------------------------------------
  # * loads a data file to the system
  #--------------------------------------------------------------------------
  def load_data(*args)
    readstring = args[0]
    if readstring =~ category_regexp(args[1])
      id = args[2]
      text = $1
      hash = {}
      text.each_line do |line|
        item = get_item_from_parameters(line)
        next if item.empty? or item[id] == nil
        idd = item[id].to_i
        hash[idd] = {}
        for i in 3..args.size-1
          hash[idd][args[i]] = item[args[i]]
        end
      end
    end
    return hash
  end
  #--------------------------------------------------------------------------
  # * Exchange the old array of the database from the new array
  #--------------------------------------------------------------------------
  def change_array(array, param_list)
    return if param_list.nil?
    param_list.each_pair do |key, params|
      next if array[key].nil?
      param_copy(array[key], params)
    end
  end
  #--------------------------------------------------------------------------
  # * Copy a parameter from the localized string to the old string
  #   params: param array
  #--------------------------------------------------------------------------
  def param_copy(item, params)
    params.each_pair do |param, value|
      next if value.nil?
      val = value.gsub("\\n","\n")
      eval("item.#{param.to_s} = val")
    end
  end
  #--------------------------------------------------------------------------
  # * Gets a item from ID
  #   line: ID
  #--------------------------------------------------------------------------
  def get_item_from_parameters(line)
    item = {}
    line.split(";").each do |param|
      if param =~ param_regexp
        key = $1; val = $2
        key.gsub!(/[\t\n]/,""); val.gsub!(/[\t\n]/,"")
        item[key.downcase.to_sym] = val
      end
    end
    return item
  end
  #--------------------------------------------------------------------------
  # * Dialet?
  #   lang: language short name
  #--------------------------------------------------------------------------
  def dialet?(lang)
    return H87Localization.dialet?(lang)
  end
  #--------------------------------------------------------------------------
  # * Loads a string from another language.
  #   string_id: string to load
  #   language: current language
  #--------------------------------------------------------------------------
  def string_from_other_languages(string_id, language)
    if H87Localization.dialet?(language)
      traditional = H87Localization.base_language(language)
      return string_from_other_languages(string_id, traditional)
    elsif language != H87Localization.default_language
      return get_language_string(string_id, H87Localization.default_language)
    else
      return "?#{string_id}?"
    end
  end
  #--------------------------------------------------------------------------
  # * Gets a string from another language and stores it
  #--------------------------------------------------------------------------
  def get_language_string(string_id, language)
    dl = Data_Localization.new(language)
    @strings[string_id] = dl.get_string(string_id)
    return @strings[string_id]
  end
end

#--------------------------------------------------------------------------
# * Command for adding the language selection from Settings menu.
#--------------------------------------------------------------------------
if $imported["H87_Options"]
  H87Options.push_system_option(H87Localization.create_option)
end