=begin
 ==============================================================================
  ■ Opzioni skin finestre di Holy87
      versione 1.1
      Difficoltà utente: ★★
      Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
      lo script nei propri progetti, sia amatoriali che commerciali. Vietata
      l'attribuzione impropria.
 ==============================================================================
    Questo script aggiunge al menu delle opzioni le impostazioni per i temi
    personalizzati dei menu. Puoi:
    - Inserire tutte le windowskin che vuoi in Graphics/Windowskins
    - Permettere al giocatore di inserire temi custom in Documenti/Gioco/Skins
    - Impostare tutte le proprietà della windowskin come font, trasparenza e
      tonalità predefinita in un file di testo
 ==============================================================================
  ■ Compatibilità
    Window_Base -> alias initialize
 ==============================================================================
  ■ Installazione e istruzioni
    Installare questo script sotto Materials e prima del Main.

    ● Requisiti
    RICHIEDE IL MENU DELLE OPZIONI DI GIOCO DI HOLY87 (1.2 o superiore)
    http://pastebin.com/raw.php?i=qmq1qpdV
    Se vuoi fare in modo che il giocatore possa inserire le windowskin
    personalizzate nella sua cartella utente, hai bisogno anche dello script
    dei salvataggi nei documenti:
    https://holy87.wordpress.com/2015/08/12/savegame-in-my-documents/

    ● Istruzioni di base
    Crea una cartella Windowskins nella cartella Graphics del tuo progetto.
    Inserisci tutte le windowskin che vuoi.
    Puoi personalizzare ulteriormente la winowskin impostandone la trasparenza,
    la tonalità predefinita, il/i font, grandezza font, tipo (grassetto, corsivo)
    ombra, contorno ecc...

    ● Personalizzazione windowskin
    Se vuoi personalizzare nel dettaglio la skin, ecco cosa devi fare:
    - Crea un documento di testo nella cartella Windowskins con lo stesso
      nome del file. Ad esempio, se la skin si chiama Window.png, il file
      deve chiamarsi Window.txt
    - Scrivi all'interno del file gli attributi su ogni riga. Gli attributi
      che puoi scrivere sono i seguenti:

      name: Nuovo nome
      per assegnare un nome della finestra diverso dal nome del file

      fonts: Arial, Verdana, Elvetica
      Assegna un font diverso da quello di default per questo tema. Puoi mettere
      più font separati da virgola in modo che se nel computer non è installato
      quel determinato font, potrai utilizzare il successivo.

      bold: true
      Imposta il font in grassetto quando è attivato questo tema.

      italic: true
      Imposta il font in corsivo quando è attivato questo tema.

      font size: x
      Impsota la grandezza del carattere a x

      outline: false
      Elimina il contorno del testo

      shadow: true
      Aggiunge l'ombra al testo (come in RPG Maker MV)

      opacity: x
      Imposta l'opacità dello sfondo finestra da 0 a 255 (192 di default)

      tone: X,Y,Z
      Imposta una tonalità personalizzata della finestra, dove X, Y e Z sono
      rispettivamente i colori rosso, verde e blu (da -255 a 255)

      tone locked: true
      Blocca il cambio di tonalità per questo tema. L'utente non può cambiare
      tonalità della windowskin

      background: x
      Imposta uno sfondo (nella cartella Picture) quando si seleziona questa
      windowskin.

      background_opacity: x
      Imposta un'opacità per lo sfondo (che va a sovrapporsi a quello sotto)

      outline color: A,B,C,D
      Imposta un colore del contorno dove A: Colore rosso, B: Verde, C: Blu,
      D: Trasparenza. Quest'ultimo è facoltativo.
 ==============================================================================
=end

#==============================================================================
# ** CONFIGURAZIONE
#==============================================================================
module WindowskinsManager
  # Imposta la finestra predefinita all'avvio del gioco
  DEFAULT_SKIN = "Stripes"
  # Vuoi aggiungere la cartella delle windowskins custom in Documenti?
  USE_CUSTOM = true #false se non vuoi questa funzione
  # Nome della cartella
  INT_SK_FOLDER = "Graphics/Windowskins"
  EXT_SK_FOLDER = "Skins"
  # Stringhe di testo nelle opzioni
  SET_HELP = "Imposta un tema delle finestre personalizzato."
  SET_TEXT = "Tema"
  SET_REDC = "Rosso"
  SET_REDH = "Cambia la tonalità di rosso dello sfondo."
  SET_GREE = "Verde"
  SET_GREH = "Cambia la tonalità di verde dello sfondo."
  SET_BLUE = "Blu"
  SET_BLUH = "Cambia la tonalità di blu dello sfondo."
end

# --- --- --- --- --- --- FINE DELLA CONFIGURAZIONE --- --- --- --- --- ---
#    Non modificare oltre questo script se non sai dove mettere le mani.


$imported = {} if $imported == nil
$imported["H87_Windowskins"] = 1.1
unless $imported["H87_Options"]
  msgbox "Windowskins script requires Holy87 Settings Menu v1.2.0 or better."
end
#==============================================================================
# ** WindowskinsManager
#------------------------------------------------------------------------------
#  Handles the windowskins list
#==============================================================================
module WindowskinsManager
  module_function
  # Returns the windows folder name
  def window_folder
    EXT_SK_FOLDER;
  end

  # Gets the list of all windowskins objects
  def list
    default_windowskins.merge(user_windowskins)
  end

  # An hash with all the windowskin names {"name" => "name"}
  def name_list
    h = {}
    list.keys.each { |key| h[key] = key }
    h
  end

  # Gets all the default windowskins in the game folder
  def default_windowskins
    fetch_windowskin_folder(INT_SK_FOLDER)
  end

  # Gets all the custom windowskins in user folder
  def user_windowskins
    return {} unless $imported['H87_Homesave']
    return {} unless USE_CUSTOM
    fetch_windowskin_folder(custom_windowskins_folder)
  end

  # Searches for all windowskins in the folder
  # @param [String] path
  # @return [Hash]
  def fetch_windowskin_folder(path)
    windowskins = {}
    Dir.foreach(path) do |file_name|
      next if file_name == "." || file_name == '..'
      file = path + "/" + file_name
      next if File.directory?(file)
      next unless File.extname(file).downcase == '.png'
      ws = Window_Skin.new(file)
      windowskins[ws.name] = ws
    end
    windowskins
  end

  # Returns the complete folder path
  # noinspection RubyResolve
  # @return [String]
  def custom_windowskins_folder
    fpath = Homesave.project_data_directory + '/' + window_folder
    Dir.mkdir(fpath) unless File.directory?(fpath)
    fpath
  end

  # Adds the skin options in the settings menu
  def set_options
    H87Options.push_appearance_option(window_hash)
    H87Options.push_appearance_option(red_hash)
    H87Options.push_appearance_option(green_hash)
    H87Options.push_appearance_option(blue_hash)
  end

  # Gets the windowskin selection hash
  # @return [Hash]
  def window_hash
    {
        :type => :variable,
        :var => 0,
        :text => SET_TEXT,
        :help => SET_HELP,
        :val_mt => :get_windowskin,
        :method => :set_windowskin,
        :values => name_list,
        :popup => "Window_SkinPopup"
    }
  end

  # Gets the red color selection hash
  # @return [Hash]
  def red_hash
    {
        :type => :bar,
        :text => SET_REDC,
        :help => SET_REDH,
        :var => 0,
        :max => 255,
        :min => -255,
        :color => Color.new(255, 0, 0),
        :perc => false,
        :not_initialize => true,
        :condition => "$game_system.tone_allowed?",
        :val_mt => :get_red_tone,
        :method => :set_red_tone}
  end

  # Gets the gren color selection hash
  # @return [Hash]
  def green_hash
    {
        :type => :bar,
        :text => SET_GREE,
        :help => SET_GREH,
        :var => 0,
        :max => 255,
        :min => -255,
        :color => Color.new(0, 255, 0),
        :perc => false,
        :not_initialize => true,
        :condition => "$game_system.tone_allowed?",
        :val_mt => :get_green_tone,
        :method => :set_green_tone}
  end

  # Gets the blue color selection hash
  # @return [Hash]
  def blue_hash
    {
        :type => :bar,
        :text => SET_BLUE,
        :help => SET_BLUH,
        :var => 0,
        :max => 255,
        :min => -255,
        :color => Color.new(0, 0, 255),
        :perc => false,
        :not_initialize => true,
        :condition => "$game_system.tone_allowed?",
        :val_mt => :get_blue_tone,
        :method => :set_blue_tone}
  end
end

#==============================================================================
# ** Window_Skin
#------------------------------------------------------------------------------
#  Class that handles all windowskin informations
#==============================================================================
class Window_Skin
  # Public instance variables
  # @return [String]
  attr_reader :path #file path
  # @return [String]
  attr_reader :name #windowskin name
  # @return [Tone]
  attr_reader :tone #windowskin color
  attr_reader :bold #text bold
  attr_reader :italic #text italic
  attr_reader :outline #text outline
  attr_reader :opacity #text opacity
  attr_reader :shadow #text shadow
  # @return [String or Array<String>]
  attr_reader :font_name #fonts array
  # @return [String]
  attr_reader :file_name #file name
  attr_reader :font_size #text size
  # @return [Color]
  attr_reader :font_color #font color
  # @return [Color]
  attr_reader :font_out_color #outline color
  # @return [String]
  attr_reader :background #background image
  attr_reader :background_opacity
  attr_reader :tone_locked #tone locked?
  # Object initialization
  #   path: file path
  def initialize(path)
    @path = File.dirname(path) + "/"
    @file_name = File.basename(path,".png")
    @name = @file_name
    @font_color = text_color
    check_skin_settings
  end

  # Check if a skin setting file exists
  def check_skin_settings
    settings_file = @path + @file_name + ".txt"
    if File.exist?(settings_file)
      fetch_skin_settings(settings_file)
    end
  end

  # Reads the settings file and settes the proper parameters
  #   settings_file: Settings file to read
  def fetch_skin_settings(settings_file)
    File.open(settings_file, "r") do |file|
      file.each_line do |line|
        case line
        when /name[ ]*[=:][ ]*(.+)/i;
          @name = $1
        when /bold[ ]*[=:][ ]*(.+)/i;
          @bold = ch_tf($1)
        when /italic[ ]*[=:][ ]*(.+)/i;
          @italic = ch_tf($1)
        when /outline[ ]*[=:][ ]*(.+)/i;
          @outline = ch_tf($1)
        when /shadow[ ]*[=:][ ]*(.+)/i;
          @shadow = ch_tf($1)
        when /tone locked[ ]*[=:][ ]*(.+)/i;
          @tone_locked = ch_tf($1)
        when /fonts[ ]*[=:][ ]*(.+)/i;
          @font_name = $1.split(",")
        when /font size[ ]*[=:][ ]*(\d+)/i;
          @font_size = $1.to_i
        when /opacity[ ]*[=:][ ]*(\d+)/i;
          @opacity = $1.to_i
        when /background[ ]*[=:][ ]*(.+)/i;
          @background = $1
        when /background[ _]opacity[ ]*[=:][ ]*(\d+)/i;
          @background_opacity = $1.to_i
        when /^color[ ]*[=:][ ]*(.+)/i
          colors = $1.split(/[ ]*,[ ]*/)
          @font_color = Color.new(255, 255, 255, 255)
          @font_color.red = colors[0].to_i if colors[0]
          @font_color.green = colors[1].to_i if colors[1]
          @font_color.blue = colors[2].to_i if colors[2]
          @font_color.alpha = colors[3].to_i if colors[3]
        when /^outline color[ ]*[=:][ ]*(.+)/i
          colors = $1.split(/[ ]*,[ ]*/)
          @font_out_color = Color.new(0, 0, 0, 255)
          @font_out_color.red = colors[0].to_i if colors[0]
          @font_out_color.green = colors[1].to_i if colors[1]
          @font_out_color.blue = colors[2].to_i if colors[2]
          @font_out_color.alpha = colors[3].to_i if colors[3]
        when /tone[ ]*[=:][ ]*(.+)/i
          begin
            colors = $1.split(/[ ]*,[ ]*/).collect { |a| a.to_i }
            @tone = Tone.new(colors[0], colors[1], colors[2])
          rescue Exception
            Logger.error $!
            Logger.error $!.message
          end
        else
          puts 'Invalid ' + line + ' data'
        end
      end
    end
  end

  # Returns true or false for a proper string
  #   string: string to read. Returns true if string == "true",
  #                           Returns false if string == "false",
  #                           Otherwise, returns nil.
  def ch_tf(string)
    if string =~ /(true|false)/i
      return true if string.downcase == "true"
      return false if string.downcase == "false"
    end
    nil
  end

  # Returns the windowskin bitmap
  # @return [Bitmap]
  def bitmap
    Cache.windowskin(@file_name + '.png', @path);
  end

  # Get Text Color
  #     n : Text color number  (0-31)
  # @param [Integer] n
  # @return [Color]
  def text_color(n = 0)
    x = 64 + (n % 8) * 8
    y = 96 + (n / 8) * 8
    bitmap.get_pixel(x, y)
  end
end

#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  Module for loading resources
#==============================================================================
module Cache
  # Returns the windowskin bitmap
  def self.windowskin(filename, path = WindowskinsManager::INT_SK_FOLDER + '/')
    load_bitmap(path, filename)
  end
end

#==============================================================================
# ** Game_System
#==============================================================================
class Game_System
  attr_accessor :tone_customized
  # Returns the selected windowskin or default if none is setted
  # @return [Window_Skin]
  def selected_windowskin
    set_windowskin(default_windowskin) if @selected_windowskin.nil?
    @selected_windowskin
  end

  # Returns the default widnowskin
  # @return [Window_Skin]
  def default_windowskin
    Window_Skin.new(WindowskinsManager::INT_SK_FOLDER + '/' + WindowskinsManager::DEFAULT_SKIN)
  end

  # Sets a windowskin to the game
  #   skin_name: if it's a string, sets the windowskin of the list from key
  #              if it's an integer or nil, sets the default windowskin
  #              if it's a Window_Skin object, sets that windowskin
  # @param [String or Window_Skin] skin_name
  def set_windowskin(skin_name)
    if skin_name == 0 or skin_name.nil?
      windowskin = default_windowskin
    elsif skin_name.is_a?(Window_Skin)
      windowskin = skin_name
    else
      windowskin = WindowskinsManager.list[skin_name]
    end
    if windowskin.nil?
      puts "Nessuna Windowskin per #{skin_name}"
      return
    end
    @selected_windowskin = windowskin
    if windowskin.tone != nil
      @backup_tone = self.window_tone.clone if @tone_customized
      self.window_tone = windowskin.tone
      @tone_customized = false
    else
      if @backup_tone != nil
        self.window_tone = @backup_tone
        @backup_tone = nil
      else
        self.window_tone = $data_system.window_tone if $data_system
      end
    end
    update_font_settings
  end

  # Refreshes the windowskin as the save loads
  def refresh_windowskin
    set_windowskin(selected_windowskin)
  end

  # Change the font settings setted in the windowskin.
  def update_font_settings
    change_font_setting(:default_name, :font_name)
    change_font_setting(:default_size, :font_size)
    change_font_setting(:default_bold, :bold)
    change_font_setting(:default_italic, :italic)
    change_font_setting(:default_shadow, :shadow)
    change_font_setting(:default_outline, :outline)
    change_font_setting(:default_color, :font_color)
    change_font_setting(:default_out_color, :font_out_color)
  end

  # Change the specified font setting.
  #   f_param: Font class attribute
  #   w_param: Window_Skin class proper attribute
  #   If w_param is nil, loads the default font setting.
  # @param [Symbol] f_param font param
  # @param [Symbol] w_param windowskin param
  def change_font_setting(f_param, w_param)
    default_param = (f_param.to_s + '=').to_sym
    value = selected_windowskin.send(w_param)
    if value.is_a?(Color) or value != nil
      Font.send(default_param, selected_windowskin.send(w_param))
    else
      Font.send(default_param, Font_BK.send(f_param))
    end
  end

  # Returns true if the player can change the windowskin tone
  def tone_allowed?
    !selected_windowskin.tone_locked
  end

  # resets windowskin settings if windowskin not found
  def fallback_windowskin
    return if WindowskinsManager.list.keys.include?(selected_windowskin.name)
    set_windowskin default_windowskin
  end
end

#==============================================================================
# ** Window_SkinPopup
#------------------------------------------------------------------------------
#  Window for windowskin selection
#==============================================================================
class Window_SkinPopup < Generic_PopupWindow
  # Override method for cursor up
  def cursor_up(wrap = false)
    super(wrap)
    update_skins
  end

  # Override method for curson down
  def cursor_down(wrap = false)
    super(wrap)
    update_skins
  end

  # Update the system windowskin for all windows
  def update_skins
    $game_system.set_windowskin(item)
    SceneManager.scene.change_skin
    refresh_windowskin(true)
  end
end

#==============================================================================
# ** Scene_Options
#------------------------------------------------------------------------------
#  Adds the method to refresh all windows
#==============================================================================
class Scene_Options < Scene_MenuBase
  # Change scene windowskin
  def change_skin
    reset_skins
    set_background2_bitmap
  end

  # Refresh all windows skins
  def reset_skins
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.refresh_windowskin(true) if ivar.is_a?(Window)
    end
  end
end

#==============================================================================
# ** Option
#------------------------------------------------------------------------------
#  New option methods
#==============================================================================
class Option
  # Get the system windowskin name
  # @return [String]
  def get_windowskin
    $game_system.selected_windowskin.name
  end

  # Sets the windowskin (useless, anyway)
  def set_windowskin(value)
    $game_system.set_windowskin(value)
  end

  # Gets the system red tone
  # @return [Integer]
  def get_red_tone
    $game_system.window_tone.red
  end

  # Sets the system red tone
  # @param [Integer] value
  def set_red_tone(value)
    $game_system.window_tone.red = value
    $game_system.tone_customized = true
  end

  # Gets the system green tone
  # @return [Integer]
  def get_green_tone
    $game_system.window_tone.green
  end

  # Sets the system green tone
  # @param [Integer] value
  def set_green_tone(value)
    $game_system.window_tone.green = value
    $game_system.tone_customized = true
  end

  # Gets the system blue tone
  # @return [Integer]
  def get_blue_tone
    $game_system.window_tone.blue
  end

  # Sets the system blue tone
  # @param [Integer] value
  def set_blue_tone(value)
    $game_system.window_tone.blue = value
    $game_system.tone_customized = true
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  Windowskin reset for windows
#==============================================================================
class Window_Base < Window
  alias h87_wskins_initialize initialize unless $@
  # Initialization alias
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  def initialize(x, y, width, height)
    h87_wskins_initialize(x, y, width, height)
    refresh_windowskin
  end

  # Loads the windowskin
  #   need_refresh: true if you want to recreate contents and refresh.
  def refresh_windowskin(need_refresh = false)
    return unless $game_system
    if $game_system.selected_windowskin != nil
      $game_system.fallback_windowskin
      self.windowskin = $game_system.selected_windowskin.bitmap
      unless @boc
        if $game_system.selected_windowskin.opacity != nil
          self.back_opacity = $game_system.selected_windowskin.opacity
          @boc = false
        else
          self.back_opacity = 192
          @boc = false
        end
      end
      if need_refresh
        create_contents
        refresh
      end
    end
  end

  # Back opacity setting override
  def back_opacity=(value)
    super
    @boc = true
  end
end

class Scene_MenuBase < Scene_Base
  alias h87_wsk_create_background create_background unless $@
  alias h87_wsk_dispose_background dispose_background unless $@
  # Create Background
  def create_background
    h87_wsk_create_background
    @background_sprite2 = Sprite.new
    @background_sprite2.z = @background_sprite.z + 1 if @background_sprite
    set_background2_bitmap
  end

  def set_background2_bitmap
    picture_name = $game_system.selected_windowskin.background
    bitmap = picture_name.nil? ? nil : Cache.picture(picture_name)
    @background_sprite2.bitmap = bitmap
    @background_sprite2.opacity = $game_system.selected_windowskin.background_opacity || 255
  end

  # Menu Background disposer
  def dispose_background
    h87_wsk_dispose_background
    @background_sprite2.dispose
  end
end

#==============================================================================
# ** Font_BK
#------------------------------------------------------------------------------
#  backup container for fonts
#==============================================================================
module Font_BK
  # Stores the default font settings
  def self.make_font_bk
    @fdn = Font.default_name.clone
    @fds = Font.default_size
    @fdb = Font.default_bold
    @fdi = Font.default_italic
    @fdh = Font.default_shadow
    @fdo = Font.default_outline
    @fdc = Font.default_color.clone
    @fdoc = Font.default_out_color.clone
  end

  # Releases the stored settings to the font.
  def self.default_name
    @fdn;
  end

  def self.default_size
    @fds;
  end

  def self.default_bold
    @fdb;
  end

  def self.default_italic
    @fdi;
  end

  def self.default_shadow
    @fdh;
  end

  def self.default_outline
    @fdo;
  end

  def self.default_color
    @fdc;
  end

  def self.default_out_color
    @fdoc;
  end
end

#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  # noinspection ALL
  class << self
    alias wsk_extract_save_contents extract_save_contents
  end

  # Alias method extract_save_contents
  def self.extract_save_contents(contents)
    wsk_extract_save_contents(contents)
    $game_system.refresh_windowskin
  end
end

# Creates a backup for font default settings
Font_BK.make_font_bk

# Inserts the option
WindowskinsManager.set_options