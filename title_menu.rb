require 'rm_vx_data' if false
#===============================================================================
# Menu Titolo Redux di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script sostituisce il menu classico del titolo con uno moderno e più
# funzionale.
# Funzioni:
# ● Grafica carina con animazioni
# ● Non ha bisogno di immagini o configurazioni (ma puoi, se vuoi)
# ● Compatibile con tutti gli script: riesce a riconoscere i comandi aggiunti al
#   menu classico e riconvertirli al nuovo menu.
# ● Alta personalizzazione: puoi modificare la disposizione, il font, i colori,
#   usare immagini al posto di testo e cursori e altro ancora!
# ● Mostra un "Premi Start" e copyright all'avvio del gioco prima del menu
# ● Comando "Resume" che a differenza di carica partita, carica direttamente
#   l'ultimo salvataggio senza passare per la schermata di caricamento.
#===============================================================================
# ** Istruzioni:
# Copiare lo script sotto Materials e prima del Main. Configurare l'aspetto
# nelle opzioni in basso. Le eventuali immagini da usare vanno messe nella
# cartella Pictures.
#===============================================================================
# ** Impostazioni dello script
#-------------------------------------------------------------------------------
# Qui puoi personalizzare il tuo menu della schermata del titolo.
#===============================================================================
module Title_Settings
  #--------------------------------------------------------------------------
  # * Opzioni di base
  #--------------------------------------------------------------------------
  # Comando "Continua". A differenza di "Carica", questo carica direttamente
  # l'ultimo salvataggio senza passare dalla schermata di caricamento
  CONTINUE_COMMAND_ENABLED = true
  # Mostra "Premi Start" (o "Premi Invio") all'avvio del gioco.
  SHOW_PRESS_START = true
  # Mostra il copyright? (configurabile in basso). Compare solo quando è
  # attiva l'opzione di mostrare "Premi Start"
  SHOW_COPYRIGHT = true
  # mostra il cursore di sfondo sotto il testo
  SHOW_BACK_CURSOR = true
  # Mostra la versione del gioco? Compare solo se viene mostrato anche
  # il copyright. Funziona solo se hai anche il Modulo Universale.
  SHOW_GAME_VERSION = true
  # Usare le immagini al posto delle voci nel menu iniziale? Se impostato
  # su true, allora bisogna specificare le immagini (nella cartella
  # Pictured) che devono essere utilizzate, per ogni simbolo.
  # I simboli possono essere :new_game, :continue, :shutdown ecc...
  USE_IMAGES = false
  IMAGE_COMMANDS = {
      :new_game => '',
      :continue => '',
      :shutdown => '',
      :update   => '',
      :credits  => ''
  }
  # Usare un'immagine per il cursore (lo sfondo sotto alle voci)?
  CURSOR_PICTURE = '' # metti il nome dell'immagine nella cartella Pictures
  # Mostrare una immagine invece del testo quando esce Premi Start?
  PRESS_START_PICTURE = ''
  # Scegli il nome del suono SE da utilizzare quando si preme START.
  START_SE = 'Item3'
  # Immagine di un cursore piccolo a fianco della voce (tipo un dito)
  LITTLE_CUR_IMAGE = ''
  LITTLE_CUR_IMAGE_MIRRORED = false # mostra un altro cursore identico sulla destra
  LITTLE_CUR_ADJ_X = -10
  LITTLE_CUR_ADJ_Y = 3
  #--------------------------------------------------------------------------
  # * Fonts
  #--------------------------------------------------------------------------
  # Nome del font
  FONT_NAME = ['Times New Roman']
  # Grandezza del font delle voci del menu
  FONT_SIZE = 25
  # testo in grassetto?
  TITLE_BOLD = false
  # Testo in corsivo?
  TITLE_ITALIC = false
  # Testo con bordo? (sconsigliato se usi glowed)
  TITLE_OUTLINE = false
  # Testo luminescente?
  TITLE_GLOWED = true
  # Ombra nel testo del titolo?
  TITLE_SHADOW = false
  # Raggio della luminescenza
  TITLE_GLOW_STRENGHT = 2
  # Grandezza del font "Premi Start"
  START_SIZE = 30
  # Grandezza del font del copyright (e versione)
  COPYRIGHT_SIZE = 16
  #--------------------------------------------------------------------------
  # * Posizioni
  #--------------------------------------------------------------------------
  COMMAND_HEIGHT = 25         # distanza tra le voci del menu
  COMMAND_Y = 220             # altezza della finestra del menu
  COMMAND_X_ADJ = 0           # sposta il titolo orizzontalmente risp. al centro
  PRESS_START_Y = 250         # altezza della voce "Premi Start"
  COMMAND_OFFSET = 0          # spostamento a destra dei prossimi comandi
  COMMAND_ALIGN = 1           # allineamento 0: sinistra, 1: centro, 2: destra
  #--------------------------------------------------------------------------
  # * Colori
  #--------------------------------------------------------------------------
  # Colore primario del testo
  TITLE_COLOR = Color::LIGHTGOLDENRODYELLOW
  # Colore del bordo (se usi il testo in luminescenza)
  TITLE_BORDER_COLOR = Color::RED
  # Colore del cursore
  TITLE_CURSOR_COLOR = Color::BLACK
  # Colore del flash a intermittenza
  SELECTED_FLASH_COLOR = Color::WHITE
  # Colore del cursore di sfondo quando viene azionato un comando
  SELECTION_FLASH_CURSOR_COLOR = Color::WHITE
  # Colore di sfondo del testo per copyright e versione
  BACKGROUND_COPYRIGHT_COLOR = nil
  # Tonalità               R     G     B   GR
  TITLE_SELECTED_TONE = [-50,     0,  255, 255] # tonalità testo selezionato
  TITLE_DISABLED_TONE = [-100, -100, -100, 255] # tonalità testo disabilitato
  # Opacità con opzione disattivata
  DISABLED_OPACITY = 128
  #--------------------------------------------------------------------------
  # * Timing
  #--------------------------------------------------------------------------
  SELECTED_FLASH_DURATION = 60  # durata (in frame) del falsh se selez.
  UNSELECT_FADE_SPEED = 8       # velocità fade. Più è alto, più è veloce.
  CURSOR_SPEED = 2              # velocità di spostamento. Più è alto, più è vel.
  OPEN_SPEED = 10               # velocità di apertura.
  SELECT_TIMING = 30            # frame di attesa dopo aver premuto Invio
  #--------------------------------------------------------------------------
  # * Text
  #--------------------------------------------------------------------------
  # Comando Continua (carica automaticamente l'ultimo salvataggio)
  CONTINUE_COMMAND_TEXT = 'Continua'
  # Copyright
  COPYRIGHT_TEXT = '© 2017 Holy87 - Tutti i diritti riservati'
  # Testo normale all'avvio
  PRESS_START_TEXT = 'Premi INVIO'
  # Testo mostrato se è collegato un controller XBox o compatibili
  PRESS_START_TEXT_PAD = 'Premi START'
end

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
#  Some vocabs...
#===============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Command resume
  #--------------------------------------------------------------------------
  def self.continue_game
    Title_Settings::CONTINUE_COMMAND_TEXT
  end
  #--------------------------------------------------------------------------
  # * Command press start when a game pad is connected
  #--------------------------------------------------------------------------
  def self.press_start
    Title_Settings::PRESS_START_TEXT_PAD
  end
  #--------------------------------------------------------------------------
  # * Command press start when a game pad is not connected
  #--------------------------------------------------------------------------
  def self.press_enter
    Title_Settings::PRESS_START_TEXT
  end
  #--------------------------------------------------------------------------
  # * Copyright string
  #--------------------------------------------------------------------------
  def self.copyright
    Title_Settings::COPYRIGHT_TEXT
  end
  #--------------------------------------------------------------------------
  # * Game version string
  #--------------------------------------------------------------------------
  def self.game_version
    sprintf('v. %s  ', $game_system.game_version)
  end
end

#===============================================================================
# ** Sound
#-------------------------------------------------------------------------------
# Add start sound definition
#===============================================================================
module Sound
  #--------------------------------------------------------------------------
  # * When the player press start
  #--------------------------------------------------------------------------
  def self.play_start
    RPG::SE.new(Title_Settings::START_SE).play
  end
end

#===============================================================================
# ** Game_Temp
#-------------------------------------------------------------------------------
# Memorizes if the player pressed start on the title screen, so it will not be
# showed if the player goes back from the load scene or others, but it will if
# the player goes back to title from quitting or game over.
#===============================================================================
class Game_Temp; attr_accessor :start_pressed; end

#===============================================================================
# ** Title_Core
#-------------------------------------------------------------------------------
# Main methods for the title screen menu
#===============================================================================
module Title_Core
  #--------------------------------------------------------------------------
  # * Selected tone
  #--------------------------------------------------------------------------
  def self.tone_selected
    tone = Title_Settings::TITLE_SELECTED_TONE
    Tone.new(tone[0], tone[1], tone[2], tone[3])
  end
  #--------------------------------------------------------------------------
  # * Disabled tone
  #--------------------------------------------------------------------------
  def self.tone_disabled
    tone = Title_Settings::TITLE_DISABLED_TONE
    Tone.new(tone[0], tone[1], tone[2], tone[3])
  end
  #--------------------------------------------------------------------------
  # * Gets if a picture is configured for the cursor
  #--------------------------------------------------------------------------
  def self.cursor_use_picture?
    Title_Settings::CURSOR_PICTURE && Title_Settings::CURSOR_PICTURE.size > 0
  end
  #--------------------------------------------------------------------------
  # * The cursor picture
  #--------------------------------------------------------------------------
  def self.cursor_picture
    Cache.picture(Title_Settings::CURSOR_PICTURE)
  end
  #--------------------------------------------------------------------------
  # * Returns the text size of a bitmap
  # @return [Rect]
  #--------------------------------------------------------------------------
  def self.text_size(size, text)
    bitmap = Bitmap.new(100, 100)
    bitmap.font.size = size
    bitmap.font.name = Title_Settings::FONT_NAME
    bitmap.font.bold = Title_Settings::TITLE_BOLD
    width = bitmap.text_size(text).width
    height = bitmap.text_size(text).height
    bitmap.dispose
    Rect.new(0, 0, width, height)
  end
  #--------------------------------------------------------------------------
  # * Adds to script updater
  #--------------------------------------------------------------------------
  if $imported['h87-script_updater']
    Script_Updater.add_script('new_title', '1.0')
  end
end

#===============================================================================
# ** Window_TitleCommand
#-------------------------------------------------------------------------------
# Normal title command windows for script edit
#===============================================================================
# noinspection RubyResolve
class Window_TitleCommand < Window_Command
  attr_reader :list
  # @attr[Cotainer_TitleCommand] menu_command
  attr_accessor :menu_command
  #--------------------------------------------------------------------------
  # * Open method redefinition: hold that window!
  #--------------------------------------------------------------------------
  def open
    @menu_command.open if @menu_command
  end
  #--------------------------------------------------------------------------
  # * Prevent window activation
  #--------------------------------------------------------------------------
  def activate; @menu_command.activate if @menu_command; end
  #--------------------------------------------------------------------------
  # * Closing sequence for new menu command
  #--------------------------------------------------------------------------
  def close; @menu_command.close if @menu_command; end
  #--------------------------------------------------------------------------
  # * Returns the handler list
  #--------------------------------------------------------------------------
  def handlers; @handler; end
end

#===============================================================================
# ** Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  alias h87_titl_map_start start unless $@
  #--------------------------------------------------------------------------
  # * Adding press start reactivation
  #--------------------------------------------------------------------------
  def start
    h87_titl_map_start
    $game_temp.start_pressed = false
  end
end

#===============================================================================
# ** Scene_Title
#-------------------------------------------------------------------------------
# The main scene
#===============================================================================
class Scene_Title < Scene_Base
  alias create_old_command create_command_window unless $@
  alias update_old_items update unless $@
  alias terminate_old_items terminate unless $@
  #--------------------------------------------------------------------------
  # * Command window creation (aliased)
  #--------------------------------------------------------------------------
  def create_command_window
    create_old_command
    create_new_viewport
    create_new_command
    create_press_start
    select_command
  end
  #--------------------------------------------------------------------------
  # * Update process (aliased)
  #--------------------------------------------------------------------------
  def update
    update_old_items
    update_press_start
    update_title_command
  end
  #--------------------------------------------------------------------------
  # * Termination process (aliased)
  #--------------------------------------------------------------------------
  def terminate
    terminate_old_items
    dispose_title_command
    dispose_press_start
  end
  #--------------------------------------------------------------------------
  # * Menu viewport creation
  #--------------------------------------------------------------------------
  def create_new_viewport
    @command_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @command_viewport.z = 150
  end
  #--------------------------------------------------------------------------
  # * New menu title creation
  #--------------------------------------------------------------------------
  def create_new_command
    handlers = @command_window.handlers
    list = @command_window.list
    @new_command = Container_TitleCommand.new(@command_viewport, list, handlers)
    @new_command.set_handler(:resume, method(:command_resume))
    @command_window.menu_command = @new_command
  end
  #--------------------------------------------------------------------------
  # * Press start graphic creation
  #--------------------------------------------------------------------------
  def create_press_start
    @press_start = Start_Press.new(@command_viewport)
    @press_start.set_start_handler(method(:show_command))
  end
  #--------------------------------------------------------------------------
  # * Show menu
  #--------------------------------------------------------------------------
  def show_command
    @new_command.open
    @new_command.activate
  end
  #--------------------------------------------------------------------------
  # * Select wich graphic use for first (press start or main menu)
  #--------------------------------------------------------------------------
  def select_command
    if Title_Settings::SHOW_PRESS_START && !$game_temp.start_pressed
      @press_start.open
    else
      show_command
    end
  end
  #--------------------------------------------------------------------------
  # * Command resume (load the last save)
  #--------------------------------------------------------------------------
  def command_resume
    close_command_window
    fadeout_all
    fadeout_all
    DataManager.load_game(DataManager.last_savefile_index)
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * Press start graphic update
  #--------------------------------------------------------------------------
  def update_press_start; @press_start.update; end
  #--------------------------------------------------------------------------
  # * Menu title command update
  #--------------------------------------------------------------------------
  def update_title_command; @new_command.update; end
  #--------------------------------------------------------------------------
  # * Menu title command dispose
  #--------------------------------------------------------------------------
  def dispose_title_command; @new_command.dispose; end
  #--------------------------------------------------------------------------
  # * Press start graphic dispose
  #--------------------------------------------------------------------------
  def dispose_press_start; @press_start.dispose; end
  #--------------------------------------------------------------------------
  # * Close command window redefinition: close the new menu
  #--------------------------------------------------------------------------
  def close_command_window
    @new_command.close
    @press_start.ensure_invisible
    update until @new_command.close?
  end
end

#===============================================================================
# ** Sprite_TitleButton
#-------------------------------------------------------------------------------
# Menu command sprite
#===============================================================================
class Sprite_TitleButton < Sprite
  # @attr[String] text
  # @attr[Symbol] tag
  # @attr[Boolean] enabled
  attr_reader :text
  attr_reader :tag
  attr_reader :enabled
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param [Viewport] viewport
  # @param [Integer] x
  # @param [Integer] y
  # @param [String] text
  # @param [Boolean] enabled
  # @param [Symbol] tag
  #--------------------------------------------------------------------------
  def initialize(viewport, x, y, text, enabled = true, tag = nil)
    super(viewport)
    self.x = x
    self.y = y
    @enabled = enabled
    @selected = false
    @tag = tag
    @text = text
    self.opacity = 0
    create_bitmap
    center
  end
  #--------------------------------------------------------------------------
  # * Self bitmap creation (from nothing)
  #--------------------------------------------------------------------------
  def prepare_bitmap
    size = Title_Core.text_size(font_size, @text)
    width = size.width + padding * 2
    height = size.height + padding * 2
    self.bitmap = Bitmap.new(width, height)
    self.bitmap.font.color = font_color
    self.bitmap.font.name = font_name
    self.bitmap.font.bold = font_bold
    self.bitmap.font.outline = font_outline
    self.bitmap.font.italic = font_italic
    self.bitmap.font.shadow = font_shadow
  end
  #--------------------------------------------------------------------------
  # * Bitmap creation
  #--------------------------------------------------------------------------
  def create_bitmap
    if use_image?
      self.bitmap = Cache.picture(image_graphic)
    else
      prepare_bitmap
      write_text
    end
  end
  #--------------------------------------------------------------------------
  # * Bitmap padding (for glow)
  #--------------------------------------------------------------------------
  def padding; glow? ? 3 : 0; end
  #--------------------------------------------------------------------------
  # * Text writing
  #--------------------------------------------------------------------------
  def write_text
    if glow?
      self.bitmap.draw_glowed_text(0, 0, self.width, self.height, @text, 1, 2, glow_color)
    else
      self.bitmap.draw_text(0, 0, self.width, self.height, @text, 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Sets ox and oy at the center
  #--------------------------------------------------------------------------
  def center
    adjust_sprite_ox
    self.oy = self.height / 2
  end
  #--------------------------------------------------------------------------
  # * Adjust the sprite ox
  #--------------------------------------------------------------------------
  def adjust_sprite_ox
    case Title_Settings::COMMAND_ALIGN
      when 0
        self.ox = 0
      when 1
        self.ox = self.width/2
      when 2
        self.ox = self.width
      else
        self.ox = self.width/2
    end
  end
  #--------------------------------------------------------------------------
  # * Returns the font color
  #--------------------------------------------------------------------------
  def font_color
    if enabled?
      Title_Settings::TITLE_COLOR
    else
      color = Title_Settings::TITLE_COLOR.clone
      color.alpha = Title_Settings::DISABLED_OPACITY
      color
    end
  end
  #--------------------------------------------------------------------------
  # * Returns the glow color
  #--------------------------------------------------------------------------
  def glow_color
    if enabled?
      Title_Settings::TITLE_BORDER_COLOR
    else
      color = Title_Settings::TITLE_BORDER_COLOR.clone
      color.alpha = Title_Settings::DISABLED_OPACITY
      color
    end
  end
  #--------------------------------------------------------------------------
  # * Font name
  #--------------------------------------------------------------------------
  def font_name; Title_Settings::FONT_NAME; end
  #--------------------------------------------------------------------------
  # * Font size
  #--------------------------------------------------------------------------
  def font_size; Title_Settings::FONT_SIZE; end
  #--------------------------------------------------------------------------
  # * Font bold
  #--------------------------------------------------------------------------
  def font_bold; Title_Settings::TITLE_BOLD; end
  #--------------------------------------------------------------------------
  # * Font italic
  #--------------------------------------------------------------------------
  def font_italic; Title_Settings::TITLE_ITALIC; end
  #--------------------------------------------------------------------------
  # * Font outline
  #--------------------------------------------------------------------------
  def font_outline; Title_Settings::TITLE_OUTLINE; end
  #--------------------------------------------------------------------------
  # * Font shadow
  #--------------------------------------------------------------------------
  def font_shadow; Title_Settings::TITLE_SHADOW; end
  #--------------------------------------------------------------------------
  # * Use image?
  #--------------------------------------------------------------------------
  def use_image?; Title_Settings::USE_IMAGES; end
  #--------------------------------------------------------------------------
  # * Image graphic name (if use image)
  #--------------------------------------------------------------------------
  def image_graphic; Title_Settings::IMAGE_COMMANDS[@tag]; end
  #--------------------------------------------------------------------------
  # * Glow the text?
  #--------------------------------------------------------------------------
  def glow?; Title_Settings::TITLE_GLOWED; end
  #--------------------------------------------------------------------------
  # * Enabled?
  #--------------------------------------------------------------------------
  def enabled=(value)
    return if @enabled == value
    @enabled = value
    create_bitmap
    if enabled?
      if @selected
        self.tone = selected_tone
      else
        self.tone = Tone.new(0, 0, 0, 0)
      end
    else
      self.tone = Title_Core.tone_disabled
    end
  end
  #--------------------------------------------------------------------------
  # * Set enabled state
  #--------------------------------------------------------------------------
  def enabled?; @enabled; end
  #--------------------------------------------------------------------------
  # * Select this command
  #--------------------------------------------------------------------------
  def select
    @selected = true
    if enabled?
      self.tone = selected_tone
      flash_selected
    end
  end
  #--------------------------------------------------------------------------
  # * Unselect this command
  #--------------------------------------------------------------------------
  def unselect
    @selected = false
    self.tone = unselected_tone
    stop_blink
  end
  #--------------------------------------------------------------------------
  # * Unselect tone
  # @return [Tone]
  #--------------------------------------------------------------------------
  def unselected_tone
    if enabled?
      Tone.new(0, 0, 0, 0)
    else
      Title_Core.tone_disabled
    end
  end
  #--------------------------------------------------------------------------
  # * Select tone
  # @return [Tone]
  #--------------------------------------------------------------------------
  def selected_tone
    Title_Core.tone_selected
  end
  #--------------------------------------------------------------------------
  # * Flash
  #--------------------------------------------------------------------------
  def flash_selected
    color = Title_Settings::SELECTED_FLASH_COLOR
    duration = Title_Settings::SELECTED_FLASH_DURATION
    interval = duration * 2
    blink(color, interval, duration)
  end
end

#===============================================================================
# ** Sprite_TitleCursor
#-------------------------------------------------------------------------------
# This cursor is used when you choose to show a little cursor left on the
# title command (like an hand, sword or arrow)
#===============================================================================
class Sprite_TitleCursor < Sprite
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param [Viewport] viewport
  # @param [Integer] range
  # @param [Integer] speed
  #--------------------------------------------------------------------------
  def initialize(viewport, range = 2, speed = 5)
    super(viewport)
    @tilt_range = range
    @tilt_speed = 60 / [[1, speed].max, 60].min
    @tilt_count = 0
    @reverse = false
  end
  #--------------------------------------------------------------------------
  # * Update process
  #--------------------------------------------------------------------------
  def update
    super
    update_tilt
  end
  #--------------------------------------------------------------------------
  # * Tilt update (going right and left)
  #--------------------------------------------------------------------------
  def update_tilt
    @tilt_count += 1
    if @tilt_count >= @tilt_speed
      move_tilt
      @tilt_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Move tilt
  #--------------------------------------------------------------------------
  def move_tilt
    if @reverse
      self.ox -= 1
      @reverse = false if center_x - self.ox <= @tilt_range
    else
      self.ox += 1
      @reverse = true if self.ox - center_x <= @tilt_range
    end
  end
  #--------------------------------------------------------------------------
  # * Center
  # @return [Integer]
  #--------------------------------------------------------------------------
  def center_x; self.width / 2; end
end

#===============================================================================
# ** Container_TitleCommand
#-------------------------------------------------------------------------------
# This class contains the new title commands and graphic.
#===============================================================================
class Container_TitleCommand
  # @attr[Viewport] viewport
  # @attr[Integer] openness
  # @attr[Boolean] active
  attr_reader :viewport
  attr_reader :openness
  attr_accessor :active
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param [Viewport] viewport
  # @param [Hash] commands
  # @param [Array] handlers
  #--------------------------------------------------------------------------
  def initialize(viewport, commands, handlers)
    @viewport = viewport
    @list = commands
    @handler = handlers
    @index = 0
    @wait = 0
    @openness = 0
    @active = false
    check_continue_enabled
    create_command_graphic
    make_selection
    update_opacity
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    update_items
    update_handlers
    update_cursor
    update_waiting
    update_open
    update_close
  end
  #--------------------------------------------------------------------------
  # * Create command graphic
  #--------------------------------------------------------------------------
  def create_command_graphic
    draw_cursor
    draw_items
    draw_little_cursor
  end
  #--------------------------------------------------------------------------
  # * Update items
  #--------------------------------------------------------------------------
  def update_items
    @items.each{|item| item.update}
  end
  #--------------------------------------------------------------------------
  # * Cursor update
  #--------------------------------------------------------------------------
  def update_cursor
    process_cursor_move
    @cursor.update
    @little_cursor.update if show_little_cursor?
  end
  #--------------------------------------------------------------------------
  # * Update handlers
  #--------------------------------------------------------------------------
  def update_handlers
    process_handling
  end
  #--------------------------------------------------------------------------
  # * Update waiting, call action handler when finished
  #--------------------------------------------------------------------------
  def update_waiting
    @wait -= 1
    @wait_handler.call if @wait_handler && @wait == 0
  end
  #--------------------------------------------------------------------------
  # * Draw cursor
  #--------------------------------------------------------------------------
  def draw_cursor
    @cursor = Sprite.new(@viewport)
    return unless use_back_cursor?
    if Title_Core.cursor_use_picture?
      @cursor.bitmap = Title_Core.cursor_picture
    else
      @cursor.bitmap =  cursor_bitmap
    end
    @cursor.opacity = 0
    @cursor.y = item_height(@index)
    @cursor.x = Graphics.width / 2
    @cursor.ox = @cursor.width / 2
    @cursor.oy = @cursor.height / 2
  end
  #--------------------------------------------------------------------------
  # * Draw little cursor
  #--------------------------------------------------------------------------
  def draw_little_cursor
    @little_cursor = Sprite_TitleCursor.new(@viewport)
    return unless show_little_cursor?
    @little_cursor.bitmap = Cache.picture(Title_Settings::LITTLE_CUR_IMAGE)
    @little_cursor.ox = @little_cursor.width / 2
    @little_cursor.oy = @little_cursor.height / 2
    @little_cursor.opacity = 0
  end

  # draw little cursor mirrored
  def draw_little_cursor_mirrored
    @little_cursor_m = Sprite_TitleCursor.new(@viewport)
    return unless show_little_cursor_mirrored?
    @little_cursor_m.bitmap = Cache.picture(Title_Settings::LITTLE_CUR_IMAGE)
    @little_cursor_m.mirror = true
    @little_cursor_m.ox = @little_cursor_m.width / 2
    @little_cursor_m.oy = @little_cursor_m.height / 2
    @little_cursor_m.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Check continue enabled
  #--------------------------------------------------------------------------
  def check_continue_enabled
    return unless Title_Settings::CONTINUE_COMMAND_ENABLED
    if continue_enabled
      hash = {:name=>Vocab.continue_game, :symbol=>:resume,
              :enabled=> true, :ext => nil}
      @list.insert(0, hash)
    end
  end
  #--------------------------------------------------------------------------
  # * Get the first selected command
  #--------------------------------------------------------------------------
  def make_selection
    if !Title_Settings::CONTINUE_COMMAND_ENABLED && continue_enabled
      select_symbol(:continue)
    else
      select(0)
    end
  end
  #--------------------------------------------------------------------------
  # * Wait process, can call a method when the wait is done
  # @param [Integer] frames
  # @param [Method] handler
  #--------------------------------------------------------------------------
  def wait(frames, handler = nil)
    @wait = frames
    @wait_handler = handler
  end
  #--------------------------------------------------------------------------
  # * Set Handler Corresponding to Operation
  #     method : Method set as a handler (Method object)
  #--------------------------------------------------------------------------
  def set_handler(symbol, method)
    @handler[symbol] = method
  end
  #--------------------------------------------------------------------------
  # * Returns the cursor bitmap
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def cursor_bitmap
    bitmap = Bitmap.new(Graphics.width, cursor_height)
    bitmap.fill_rect(0, 0, Graphics.width, cursor_height, cursor_color)
    bitmap
  end
  #--------------------------------------------------------------------------
  # * The cursor height
  #--------------------------------------------------------------------------
  def cursor_height
    Title_Settings::COMMAND_HEIGHT
  end
  #--------------------------------------------------------------------------
  # * Menu active?
  #--------------------------------------------------------------------------
  def active; @active && @wait <= 0; end
  #--------------------------------------------------------------------------
  # * Cursor color
  # @return [Color]
  #--------------------------------------------------------------------------
  def cursor_color
    Title_Settings::TITLE_CURSOR_COLOR
  end
  #--------------------------------------------------------------------------
  # * Draw items
  #--------------------------------------------------------------------------
  def draw_items
    @items = []
    item_max.times{|index| draw_item(index)}
  end
  #--------------------------------------------------------------------------
  # * The command height
  #--------------------------------------------------------------------------
  def command_height; Title_Settings::COMMAND_HEIGHT; end
  #--------------------------------------------------------------------------
  # * Select and index
  #--------------------------------------------------------------------------
  def select(index)
    @index = index
    update_cursor_position(index)
    normalize_all_tones
    item(index).select
  end
  #--------------------------------------------------------------------------
  # * Cursor position update after a select command
  #--------------------------------------------------------------------------
  def update_cursor_position(index)
    update_back_cursor_position(index)
    update_little_cursor_position(index)
  end
  #--------------------------------------------------------------------------
  # * Back cursor position update
  #--------------------------------------------------------------------------
  def update_back_cursor_position(index)
    return unless show_back_cursor?
    x = Graphics.width / 2
    @cursor.smooth_move(x, item_height(index), Title_Settings::CURSOR_SPEED)
  end
  #--------------------------------------------------------------------------
  # * Little cursor position update
  #--------------------------------------------------------------------------
  def update_little_cursor_position(index)
    return unless show_little_cursor?
    x = adjust_cur_x(index)
    y = item_height(index) + Title_Settings::LITTLE_CUR_ADJ_Y
    @little_cursor.smooth_move(x, y, Title_Settings::CURSOR_SPEED)
    return unless show_little_cursor_mirrored?
    x = adjust_cur_m_x(index)
    @little_cursor_m.smooth_move(x, y, Title_Settings::CURSOR_SPEED)
  end
  #--------------------------------------------------------------------------
  # * Show little cursor?
  #--------------------------------------------------------------------------
  def show_little_cursor?
    Title_Settings::LITTLE_CUR_IMAGE != ''
  end

  # show little cursor mirrored?
  def show_little_cursor_mirrored?
    show_little_cursor? && Title_Settings::LITTLE_CURSOR_MIRRORED
  end
  #--------------------------------------------------------------------------
  # * Show back cursor?
  #--------------------------------------------------------------------------
  def show_back_cursor?
    Title_Settings::SHOW_BACK_CURSOR
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Continue
  #--------------------------------------------------------------------------
  def continue_enabled
    DataManager.save_file_exists?
  end
  #--------------------------------------------------------------------------
  # * Normalize all tones
  #--------------------------------------------------------------------------
  def normalize_all_tones
    item_max.times {|index|
      item(index).unselect
    }
  end
  #--------------------------------------------------------------------------
  # * Item height
  #--------------------------------------------------------------------------
  def item_height(index)
    initial_y + index * command_height
  end
  #--------------------------------------------------------------------------
  # * Adjust menu Y position
  #--------------------------------------------------------------------------
  def initial_y; Title_Settings::COMMAND_Y; end
  #--------------------------------------------------------------------------
  # * Adjust menu X position
  #--------------------------------------------------------------------------
  def adjust_x(index = 0)
    Title_Settings::COMMAND_X_ADJ + Title_Settings::COMMAND_OFFSET * index
  end
  #--------------------------------------------------------------------------
  # * Adjust cursor X position
  #--------------------------------------------------------------------------
  def adjust_cur_x(index)
    (item(index).left_x) + Title_Settings::LITTLE_CUR_ADJ_X
  end

  # Adjust mirrored cursor X position
  def adjust_cur_m_x(index)
    (item(index).right_x) - Title_Settings::LITTLE_CUR_ADJ_X
  end
  #--------------------------------------------------------------------------
  # * Get Command Name
  #--------------------------------------------------------------------------
  def command_name(index)
    @list[index][:name]
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Command
  #--------------------------------------------------------------------------
  def command_enabled?(index)
    @list[index][:enabled]
  end
  #--------------------------------------------------------------------------
  # * Get Command Data of Selection Item
  #--------------------------------------------------------------------------
  def current_data
    index >= 0 ? @list[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Symbol of Selection Item
  #--------------------------------------------------------------------------
  def current_symbol
    current_data ? current_data[:symbol] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Extended Data of Selected Item
  #--------------------------------------------------------------------------
  def current_ext
    current_data ? current_data[:ext] : nil
  end
  #--------------------------------------------------------------------------
  # * Move Cursor to Command with Specified Symbol
  #--------------------------------------------------------------------------
  def select_symbol(symbol)
    @list.each_index {|i| select(i) if @list[i][:symbol] == symbol }
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    x = Graphics.width / 2 + adjust_x(index)
    y = item_height(index)
    text = command_name(index)
    enabled = command_enabled?(index)
    symbol = @list[index][:symbol]
    item = Sprite_TitleButton.new(@viewport, x, y, text, enabled, symbol)
    item.opacity = 0
    @items.push(item)
  end
  #--------------------------------------------------------------------------
  # * Check for Handler Existence
  #--------------------------------------------------------------------------
  def handle?(symbol)
    @handler.include?(symbol)
  end
  #--------------------------------------------------------------------------
  # * Call Handler
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    @handler[symbol].call if handle?(symbol)
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    active && open? && item_max > 0
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if index < item_max - col_max || (wrap && col_max == 1)
      select((index + col_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if index >= col_max || (wrap && col_max == 1)
      select((index - col_max + item_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of OK Processing
  #--------------------------------------------------------------------------
  def ok_enabled?; true; end
  #--------------------------------------------------------------------------
  # * Call OK Handler
  #--------------------------------------------------------------------------
  def call_ok_handler
    if handle?(current_symbol)
      call_handler(current_symbol)
    else
      activate
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    if current_item_enabled?
      Sound.play_ok
      Input.update
      timing = Title_Settings::SELECT_TIMING
      @cursor.flash(Title_Settings::SELECTION_FLASH_CURSOR_COLOR, timing)
      wait(Title_Settings::SELECT_TIMING, method(:wait_for_ok))
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Waiting process
  #--------------------------------------------------------------------------
  def wait_for_ok
    deactivate
    call_ok_handler
  end
  #--------------------------------------------------------------------------
  # * Cursor Movement Processing
  #--------------------------------------------------------------------------
  def process_cursor_move
    return unless cursor_movable?
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:DOWN)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:UP)
    Sound.play_cursor if @index != last_index
  end
  #--------------------------------------------------------------------------
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    process_ok       if ok_enabled?        && Input.trigger?(:C)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    current_data ? current_data[:enabled] : false
  end
  #--------------------------------------------------------------------------
  # * Item max number
  #--------------------------------------------------------------------------
  def item_max; @list.size; end
  #--------------------------------------------------------------------------
  # * Column max
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # * Index
  #--------------------------------------------------------------------------
  def index; @index; end
  #--------------------------------------------------------------------------
  # * Returns the item at the index
  # @return [Sprite_TitleButton]
  #--------------------------------------------------------------------------
  def item(index = @index); @items[index]; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def activate; @active = true; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def deactivate; @active = false; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def dispose
    @cursor.dispose
    @items.each{|item| item.dispose}
    @little_cursor.dispose
  end
  #--------------------------------------------------------------------------
  # * Update Open Processing
  #--------------------------------------------------------------------------
  def update_open
    return if open?
    return unless @opening
    self.openness += Title_Settings::OPEN_SPEED
    @opening = false if open?
    update_opacity
  end
  #--------------------------------------------------------------------------
  # * Update Close Processing
  #--------------------------------------------------------------------------
  def update_close
    return if close?
    return unless @closing
    @openness -= Title_Settings::OPEN_SPEED
    @closing = false if close?
  end
  #--------------------------------------------------------------------------
  # * Update opacity
  #--------------------------------------------------------------------------
  def update_opacity
    @cursor.opacity = self.openness
    @items.each{|item| item.opacity = self.openness}
  end
  #--------------------------------------------------------------------------
  # * Open Window
  #--------------------------------------------------------------------------
  def open
    @opening = true unless open?
    @closing = false
    @cursor.pulse(150, 200, 2)
    @little_cursor.fade(255, Title_Settings::OPEN_SPEED)
    @items.each{|item| item.fade(255, Title_Settings::OPEN_SPEED)}
    self
  end
  #--------------------------------------------------------------------------
  # * Close Window
  #--------------------------------------------------------------------------
  def close
    @closing = true unless close?
    @opening = false
    @cursor.pulse_stop
    @little_cursor.fade(0, Title_Settings::OPEN_SPEED)
    @cursor.fade(0, Title_Settings::OPEN_SPEED)
    @items.each{|item| item.fade(0, Title_Settings::OPEN_SPEED)}
    self
  end
  #--------------------------------------------------------------------------
  # * Self openness
  #--------------------------------------------------------------------------
  def openness; @openness; end
  #--------------------------------------------------------------------------
  # * Set self openness (0~255)
  #--------------------------------------------------------------------------
  def openness=(value)
    @openness = [[0, value].max, 255].min
  end
  #--------------------------------------------------------------------------
  # * Closed?
  #--------------------------------------------------------------------------
  def close?; @openness <= 0; end
  #--------------------------------------------------------------------------
  # * Fully opened?
  #--------------------------------------------------------------------------
  def open?; @openness >= 255; end
  #--------------------------------------------------------------------------
  # * Use classic back cursor?
  #--------------------------------------------------------------------------
  def use_back_cursor?; Title_Settings::SHOW_BACK_CURSOR; end
end

#===============================================================================
# ** Start_Press
#-------------------------------------------------------------------------------
# Press start & copyright-version text graphic
#===============================================================================
class Start_Press
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param [Viewport] viewport
  #--------------------------------------------------------------------------
  def initialize(viewport)
    @viewport = viewport
    create_press_start
    create_copyright
    @active = false
    @open = false
  end
  #--------------------------------------------------------------------------
  # * Create press start sprite
  #--------------------------------------------------------------------------
  def create_press_start
    @start_sprite = Sprite.new(@viewport)
    @start_sprite.bitmap = create_start_bitmap
    @start_sprite.oy = @start_sprite.height/2
    @start_sprite.ox = @start_sprite.width/2
    @start_sprite.y = Title_Settings::PRESS_START_Y
    @start_sprite.x = Graphics.width / 2
    @start_sprite.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Create copyright graphic
  #--------------------------------------------------------------------------
  def create_copyright
    @copyright = Sprite.new(@viewport)
    @copyright.bitmap = create_copyright_bitmap if show_copyright?
    @copyright.y = Graphics.height - @copyright.height
    @copyright.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Open graphic
  #--------------------------------------------------------------------------
  def open
    @start_sprite.pulse(0, 255, 5)
    @copyright.fade(255, 50) if Title_Settings::SHOW_COPYRIGHT
    @active = true
    @open = true
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    return unless @open
    @start_sprite.update
    @copyright.update
    update_handler
  end
  #--------------------------------------------------------------------------
  # * Dispose sprites
  #--------------------------------------------------------------------------
  def dispose
    @start_sprite.dispose
    @copyright.dispose
  end
  #--------------------------------------------------------------------------
  # * Set the start handler
  # @param[Method] method
  #--------------------------------------------------------------------------
  def set_start_handler(method)
    @start_method = method
  end
  #--------------------------------------------------------------------------
  # * Show the copyright?
  #--------------------------------------------------------------------------
  def show_copyright?
    Title_Settings::SHOW_COPYRIGHT
  end
  #--------------------------------------------------------------------------
  # * Update start handler
  #--------------------------------------------------------------------------
  def update_handler
    return unless @active
    return if @start_method.nil?
    if Input.trigger?(:START) || Input.trigger?(:C) || Input.trigger?(:B)
      close
      $game_temp.start_pressed = true
      call_start_handler
      Input.update
    end
  end
  #--------------------------------------------------------------------------
  # * Close action
  #--------------------------------------------------------------------------
  def close
    close_start
    close_copyright
    Sound.play_start
    @active = false
  end
  #--------------------------------------------------------------------------
  # * Make all graphics invisible
  #--------------------------------------------------------------------------
  def ensure_invisible
    @start_sprite.pulse_stop
    @start_sprite.opacity = 0
    @copyright.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Close start screen
  #--------------------------------------------------------------------------
  def close_start
    flash_d = Title_Settings::SELECTED_FLASH_DURATION
    fade_speed = Title_Settings::UNSELECT_FADE_SPEED / 2
    @start_sprite.pulse_stop
    @start_sprite.flash(Title_Settings::SELECTED_FLASH_COLOR, flash_d)
    @start_sprite.change_size(@start_sprite.width * 4, 1, fade_speed)
    @start_sprite.fade(0, Title_Settings::UNSELECT_FADE_SPEED / 2)
  end
  #--------------------------------------------------------------------------
  # * Close copyright graphic
  #--------------------------------------------------------------------------
  def close_copyright
    @copyright.smooth_move(0, Graphics.height, Title_Settings::CURSOR_SPEED)
  end
  #--------------------------------------------------------------------------
  # * Call Start handler
  #--------------------------------------------------------------------------
  def call_start_handler
    @start_method.call
  end
  #--------------------------------------------------------------------------
  # * Create Press Start bitmap
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def create_start_bitmap
    if Title_Settings::PRESS_START_PICTURE.size > 0
      Cache.picture(Title_Settings::PRESS_START_PICTURE)
    else
      if $imported['H87-XInput'] && XInput.controller_plugged_in?
        text = Vocab.press_start
      else
        text = Vocab.press_enter
      end
      size = Title_Core.text_size(Title_Settings::START_SIZE, text)
      bitmap = Bitmap.new(size.width + 6, size.height + 6)
      bitmap.font.size = Title_Settings::START_SIZE
      bitmap.font.name = Title_Settings::FONT_NAME
      bitmap.font.bold = Title_Settings::TITLE_BOLD
      bitmap.font.italic = Title_Settings::TITLE_ITALIC
      bitmap.font.outline = Title_Settings::TITLE_OUTLINE
      bitmap.font.shadow = Title_Settings::TITLE_SHADOW
      if glow?
        bitmap.draw_glowed_text(0, 0, bitmap.width, bitmap.height, text, 1, 2, glow_color)
      else
        bitmap.draw_text(0, 0, bitmap.width, bitmap.height, text, 1)
      end
      bitmap
    end
  end
  #--------------------------------------------------------------------------
  # * Create copyright (and version) bitmap
  #--------------------------------------------------------------------------
  def create_copyright_bitmap
    height = Title_Core.text_size(Title_Settings::COPYRIGHT_SIZE, 'O').height + 6
    bitmap = Bitmap.new(Graphics.width, height)
    set_bitmap_font(bitmap)
    draw_bitmap_background(bitmap)
    draw_copyright(bitmap)
    draw_version(bitmap)
    bitmap
  end
  #--------------------------------------------------------------------------
  # * Set bitmap font
  #--------------------------------------------------------------------------
  def set_bitmap_font(bitmap)
    bitmap.font.size = Title_Settings::COPYRIGHT_SIZE
    bitmap.font.name = Title_Settings::FONT_NAME
    bitmap.font.bold = Title_Settings::TITLE_BOLD
    bitmap.font.italic = Title_Settings::TITLE_ITALIC
    bitmap.font.outline = Title_Settings::TITLE_OUTLINE
    bitmap.font.shadow = Title_Settings::TITLE_SHADOW
  end
  #--------------------------------------------------------------------------
  # * Draw copyright bibmap background
  #--------------------------------------------------------------------------
  def draw_bitmap_background(bitmap)
    return if Title_Settings::BACKGROUND_COPYRIGHT_COLOR.nil?
    bitmap.fill_rect(0,0,bitmap.width, bitmap.height, Title_Settings::BACKGROUND_COPYRIGHT_COLOR)
  end
  #--------------------------------------------------------------------------
  # * Draw copyright text
  #--------------------------------------------------------------------------
  def draw_copyright(bitmap)
    return unless Title_Settings::SHOW_COPYRIGHT
    text = Vocab.copyright
    if glow?
      bitmap.draw_glowed_text(0, 0, bitmap.width, bitmap.height, text, 1, 2, glow_color)
    else
      bitmap.draw_text(0, 0, bitmap.width, bitmap.height, text, 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw version text
  #--------------------------------------------------------------------------
  def draw_version(bitmap)
    return unless Title_Settings::SHOW_GAME_VERSION
    return unless $imported['H87_UniversalModule']
    version = Vocab.game_version
    if glow?
      bitmap.draw_glowed_text(0, 0, bitmap.width, bitmap.height, version, 2, 2, glow_color)
    else
      bitmap.draw_text(0, 0, bitmap.width, bitmap.height, version, 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Glow text?
  #--------------------------------------------------------------------------
  def glow?; Title_Settings::TITLE_GLOWED; end
  #--------------------------------------------------------------------------
  # * Glow color
  #--------------------------------------------------------------------------
  def glow_color; Title_Settings::TITLE_BORDER_COLOR; end
end