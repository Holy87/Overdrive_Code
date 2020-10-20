#===============================================================================
# ** SISTEMA DI REGISTRAZIONE
#-------------------------------------------------------------------------------
# Qui è definito il sistema di registrazione giocatore
#===============================================================================
module Settings
  # Impostazioni
  #
  SCENE_BGM = 'Ship3'

  # Lunghezza massima del nome giocatore
  MAX_NICKNAME_LEN = 20

  # Nome dell'immagine di sfondo
  REGISTR_WALLPAPER = 'SfondoOnline'
  # Stringhe
  REGR_HELP1 = 'Vuoi registrare il tuo profilo online? Ti servirà per accedere|alle funzionalità web del gioco (puoi farlo anche più tardi).'
  REGR_HELP2 = "Scegli nome, avatar e titolo per farti conoscere dagli altri!\nPotrai cambiare avatar e titolo anche successivamente."
  REGR_HELP3 = 'Nome da 3 a 15 caratteri alfanumerici, spazi e simboli - _|Scegli bene, perché non potrai cambiarlo.'
  REGR_HELP4 = 'Scegli un\'immagine in cui i giocatori ti identificheranno.|Puoi cambiare successivamente l\'immagine quando vuoi.'
  REGR_HELP5 = 'Completa la registrazione.'
  REGR_HELP6 = 'I titoli sono dei riconoscimenti particolari ottenuti.|Se non ne hai ancora, puoi sbloccarli in seguito!'
  VOC_PLAYER_NAME = 'Nome giocatore'
  VOC_REGISTERING = 'Registrazione in corso...'
  VOC_REGSUCCESS = "Registrazione completata!"
  VOC_REGFAILED = "Errore: c'è stato un errore nella registrazione.\nSe il problema persiste, contattare il supporto tecnico."
  VOC_REGISTER_CMD = 'Registrati'
  VOC_CANC_REG_CMD = 'Salta'
  VOC_REG_NAME_CMD = 'Nome utente'
  VOC_REG_AVAT_CMD = 'Avatar'
  VOC_REG_SUBM_CMD = 'Procedi'
  VOC_REG_NAME_TXT = 'Nome'
  VOC_REG_AVAT_TXT = 'Avatar'
  REG_NAME_CHECK = 'Controllo in corso...'
  REG_NAME_AVAILABLE = 'Questo nome è disponibile'
  REG_NAME_USED = 'Questo nome è già usato.'
  REG_NAME_ERROR = 'Errore. Per favore, riprova'
  REG_NAME_FORBIDDEN = 'Non puoi usare questo nome.'
  REG_NAME_SPECIAL = 'Sono presenti simboli non validi.'
  REG_NAME_TOO_SHORT = 'Il nome deve contenere almeno 3 caratteri.'
  REG_WELCOME_TITLE = "Ciao, %s!"
  REG_WELCOME_MESSAGE = "Ti diamo il benvenuto alla community online di Overdrive!\nContribuisci a mantenere l'Online un ambiente vivace e divertente."



end

#===============================================================================
# ** Game_Temp
#-------------------------------------------------------------------------------
# Aggiunta dell'attributo step1
#===============================================================================
class Game_Temp
  attr_accessor :registration_step
end

module Vocab
  # Primo passo della registrazione
  def self.registration_step1
    Settings::REGR_HELP1
  end

  # Secondo passo della registrazione
  def self.registration_step2
    Settings::REGR_HELP2
  end

  # Descrizione d'aiuto del comando Avatar
  def self.registration_help_avatar
    Settings::REGR_HELP4
  end

  # Descrizione d'aiuto del comando Nome
  def self.registration_help_name
    Settings::REGR_HELP3
  end

  # Descrizione d'aiuto del comando Invia
  def self.registration_help_submit
    Settings::REGR_HELP5
  end

  def self.registration_help_title
    Settings::REGR_HELP6
  end

  # Comando nome del giocatore
  def self.player_name
    Settings::VOC_PLAYER_NAME
  end

  # Processo di registrazione in corso
  def self.registration_processing
    Settings::VOC_REGISTERING
  end

  # Messaggio di registrazione avvenuta
  def self.registration_successful
    Settings::VOC_REGSUCCESS
  end

  # Messaggio di registrazione fallita
  def self.registration_failed
    Settings::VOC_REGFAILED
  end

  # Comando Registra
  def self.register_command
    Settings::VOC_REGISTER_CMD
  end

  # Comando Annulla
  def self.register_cancel
    Settings::VOC_CANC_REG_CMD
  end

  # Comando conferma nome utente
  def self.reg_username_cmd
    Settings::VOC_REG_NAME_CMD
  end

  # Comando conferma avatar
  def self.reg_avatar_cmd
    Settings::VOC_REG_AVAT_CMD
  end

  #  Comando invia
  def self.reg_submit_cmd
    Settings::VOC_REG_SUBM_CMD
  end

  # Nome utente
  def self.username
    Settings::VOC_REG_NAME_TXT
  end

  # Avatar
  def self.avatar
    Settings::VOC_REG_AVAT_TXT
  end

  # Controllo nome in corso
  def self.name_check
    Settings::REG_NAME_CHECK
  end

  # Nome disponibile
  def self.name_available
    Settings::REG_NAME_AVAILABLE
  end

  def self.name_too_short
    Settings::REG_NAME_TOO_SHORT
  end

  # Nome usato
  def self.name_used
    Settings::REG_NAME_USED
  end

  # Nome non corretto
  def self.name_wrong
    Settings::REG_NAME_FORBIDDEN
  end

  def self.name_symbol_not_allowed
    Settings::REG_NAME_SPECIAL
  end

  # Errore controllo nome
  def self.name_error
    Settings::REG_NAME_ERROR
  end

  def self.registration_error_description(error_code)
    case error_code
    when Online::NAME_ALREADY_PRESENT
      name_used
    when Online::NAME_WORD_FORBIDDEN
      name_wrong
    when Online::SPECIAL_CHARACTER_NOT_ALLOWED
      Settings::REG_NAME_SPECIAL
    when Online::CREATION_ERROR
      registration_failed
    else
      'Errore sconosciuto.'
    end
  end
end

#===============================================================================
# ** Scene_Registration
#-------------------------------------------------------------------------------
# Schermata di registrazione del giocatore
#===============================================================================
class Scene_Registration < Scene_MenuBase
  def start
    $game_temp.registration_step ||= 0
    #$game_system.on_before_save
    #start_bgm
    super
    @service_status = nil
    create_help_window
    create_command_window
    create_choice_window
    create_info_window
    create_typing_window
    create_avatar_window
    create_titles_window
    create_eula_sprite
  end

  def start_bgm
    RPG::BGM.new(Settings::SCENE_BGM).play
  end

  # Creazione dello sfondo della schermata
  def create_background
    @background_sprite = Plane.new
    @background_sprite.bitmap = Cache.parallax(Settings::REGISTR_WALLPAPER)
    @background_sprite.x_speed = 1
    @background_sprite.y_speed = 1
  end

  def dispose_background
    @background_sprite.dispose
  end

  # Aggiornamento
  def update
    super
    @background_sprite.update
    update_eula_input
  end

  def update_eula_input
    return unless @eula_sprite.visible
    if Input.trigger?(:X)
      Sound.play_ok
      Input.update
      @help_window.open
      @eula_sprite.visible = false
      init_registration_windows
    elsif Input.trigger?(:B)
      Sound.play_cancel
      Input.update
      @eula_sprite.visible = false
      @help_window.open
      back
    end
  end

  def open_eula
    @eula_sprite.visible = true
    @choice_window.close
    @help_window.close
    Input.update
  end

  # Creazione della finestra di selezione
  def create_choice_window
    @choice_window = Window_RegChoice.new
    @choice_window.set_handler(:register, method(:open_eula))
    @choice_window.set_handler(:cancel, method(:go_game))
    @choice_window.openness = 0
    if $game_temp.registration_step == 0
      @help_window.set_text(Vocab.registration_step1)
      @choice_window.activate
      @choice_window.open
    end
  end

  # Creazione della finestra di registrazione
  def create_command_window
    @command_window = Window_RegistrationCommand.new(0, @help_window.bottom_corner)
    @command_window.help_window = @help_window
    @command_window.set_handler(:name, method(:set_name))
    @command_window.set_handler(:avatar, method(:set_avatar))
    @command_window.set_handler(:title, method(:select_title))
    @command_window.set_handler(:register, method(:register))
    @command_window.set_handler(:cancel, method(:back))
    @command_window.openness = 0
    @command_window.deactivate
    if $game_temp.registration_step == 1
      @command_window.open
      @command_window.activate
    end
  end

  # Creazione della finestra di selezione avatar
  def create_avatar_window
    @avatar_window = Window_AvatarList.new(0, 0, Graphics.width)
    @avatar_window.y = Graphics.height - @avatar_window.height
    @avatar_window.visible = false
    @avatar_window.active = false
    @avatar_window.set_handler(:ok, method(:avatar_selected))
    @avatar_window.set_handler(:cancel, method(:close_avatar))
  end

  def create_titles_window
    y = @avatar_window.y
    height = Graphics.height - y
    width = Graphics.width
    @titles_window = Window_PlayerTitles.new(0, y, width, height)
    @titles_window.set_handler(:ok, method(:title_selected))
    @titles_window.set_handler(:cancel, method(:close_title))
    @titles_window.visible = false
    @titles_window.active = false
    @titles_window.help_window = @help_window
    @titles_window.index = 0
  end

  # Crea la finestra delle informazioni
  def create_info_window
    x = @command_window.right_corner
    y = @help_window.bottom_corner
    width = Graphics.width - x
    @info_window = Window_RegistrationInfo.new(x, y, width)
    @info_window.openness = 0 if $game_temp.registration_step == 0
  end

  # Creazione della finestra del nome eroe
  def create_typing_window
    x = @info_window.x + 20 #Graphics.width / 2 - 200
    y = @command_window.bottom_corner + 20 #Graphics.height/2
    params = {
        :max_characters => Settings::MAX_NICKNAME_LEN,
        :permitted => Text_Inputable::ALPHA_WITH_SPACING|Text_Inputable::BASE_SYMBOLS,
        :max_lines => 1,
        :title => Vocab.player_name
    }
    @rename_window = Window_SingleLineInput.new(x, y, params)
    @rename_window.set_done_handler(method(:do_rename))
    @rename_window.set_cancel_handler(method(:do_nothing))
    @rename_window.openness = 0
  end

  def create_eula_sprite
    @eula_sprite = Sprite.new
    @eula_sprite.bitmap = Cache.eula_bitmap
    @eula_sprite.visible = false
    @eula_sprite.z = 200
  end

  def update_service_status
    @service_status = Online.service_status
  end

  # Rinomina
  def do_rename
    @info_window.set_player_name @rename_window.text
    check_name_valid
    @rename_window.close
    @command_window.activate
  end

  def check_name_valid
    status = Online.check_name_valid(@rename_window.text)
    @info_window.set_name_status status
    update_registration_ready
  end

  def update_registration_ready
    @command_window.registration_ok = @info_window.data_ok?
  end

  # Esci dalla finestra di cambio nickname
  def do_nothing
    @command_window.activate
    @rename_window.close
  end

  # Inizializzazione della procedura di registrazione
  def configure_registration
    update_service_status
    if @service_status == :up
      show_dialog(Vocab.registration_step2, method(:init_registration_windows), :info)
    else
      Sound.play_buzzer
      Logger.warning @service_status
      show_dialog(Online::SERVER_STATUS_MESSAGES[@service_status], @choice_window, :error)
    end
  end

  def init_registration_windows
    @choice_window.close
    @command_window.open
    @command_window.activate
    @info_window.set_name_status Online.check_name_valid(@info_window.name)
    @info_window.open
    $game_temp.registration_step = 1
  end

  # Torna indietro
  def back
    @eula_sprite.visible = false
    @choice_window.open
    @command_window.close
    @info_window.close
    @choice_window.activate
    $game_temp.registration_step = 0
    @help_window.set_text(Vocab.registration_step1)
  end

  # Attiva la finestra di selezione nome
  def set_name
    @rename_window.text = @info_window.name
    @rename_window.open
    @rename_window.activate
  end

  # Attiva la finestra di selezione avatar
  def set_avatar
    @avatar_window.activate
    @avatar_window.x = 0 - @avatar_window.width unless @avatar_window.visible
    @avatar_window.visible = true
    @avatar_window.smooth_move(0, @avatar_window.y)
  end

  def select_title
    @titles_window.activate
    @titles_window.x = 0 - Graphics.width unless @titles_window.visible
    @titles_window.visible = true
    @titles_window.smooth_move(0, @titles_window.y)
  end

  # Procedura di selezione avatar
  def avatar_selected
    @info_window.change_avatar(@avatar_window.index)
    close_avatar
  end

  # Chiusura della finestra di selezione avatar
  def close_avatar
    @avatar_window.smooth_move(0 - @avatar_window.width, @avatar_window.y)
    @command_window.activate
    update_registration_ready
  end

  def title_selected
    @info_window.change_title(@titles_window.title)
    close_title
  end

  def close_title
    @titles_window.smooth_move(0 - Graphics.width, @titles_window.y)
    @command_window.activate
  end

  # Procedura di avvio registrazione
  def register
    show_dialog_waiting(Vocab.registration_processing, true)
    Graphics.update
    begin
      handle_response Online.register_new_player(@info_window.name, @info_window.avatar, @info_window.title.id)
    rescue InternetConnectionException
      Logger.error $!.message
      show_dialog(Vocab.connection_error, @command_window)
    end
  end

  # Metodo chiamato quando è stato ricevuto il risultato dell'operazione
  # @param [Online::Operation_Result] operation
  def handle_response(operation)
    if operation.success?
      $game_system.init_player_data
      $game_system.register(operation.result, @info_window.name, @info_window.avatar, @info_window.title)
      $game_system.save_online_placeholder
      DataManager.load_online_data
      $game_system.add_local_notification(:welcome, sprintf(Settings::REG_WELCOME_TITLE, @info_window.name), Settings::REG_WELCOME_MESSAGE)
      show_dialog(Vocab.registration_successful, method(:go_game))
    else
      text_error = Vocab.registration_error_description(operation.error_code)
      show_dialog(text_error, @command_window)
      Logger.info(operation.failed_message)
    end
  end

  # Ritorna al gioco se caricato
  def go_game
    #RPG::BGM.fade(30)
    #Graphics.fadeout(30)
    #Graphics.frame_count = 0
    DataManager.autosave(true, false)
    SceneManager.goto(Scene_Map)
    #$game_system.on_after_load
  end
end

#===============================================================================
# ** Window_RegChoice
#-------------------------------------------------------------------------------
# Finestra di scelta se registrare o saltare
#===============================================================================
class Window_RegChoice < Window_Command
  # Object Initialization
  def initialize
    super(0, 0)
    update_placement
    self.openness = 0
    open
  end

  # Get Window Width
  def window_width
    160
  end

  # Update Window Position
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height * 1.6 - height) / 2
  end

  # Create Command List
  def make_command_list
    add_command(Vocab.register_command, :register)
    add_command(Vocab.register_cancel, :cancel)
  end
end

#===============================================================================
# ** Window_Registration
#-------------------------------------------------------------------------------
# Finestra di controllo registrazione
#===============================================================================
class Window_RegistrationCommand < Window_Command
  # Inizializzazione
  # @param [Integer] y
  def initialize(x, y)
    @registration_ok = false
    super
  end

  # Larghezza della finestra
  # @return [Integer]
  def window_width
    Graphics.width / 3
  end

  # Crea la lista dei comandi
  def make_command_list
    add_command(Vocab.reg_username_cmd, :name)
    add_command(Vocab.reg_avatar_cmd, :avatar)
    add_command(Vocab.change_title, :title)
    add_command(Vocab.reg_submit_cmd, :register, @registration_ok)
  end

  # Registrazione completata
  def registration_ok=(value)
    return if value == @registration_ok
    @registration_ok = value
    refresh
  end

  # Aggiorna la finestra d'aiuto
  def update_help
    case current_symbol
    when :name
      text = Vocab.registration_help_name
    when :avatar
      text = Vocab.registration_help_avatar
    when :register
      text = Vocab.registration_help_submit
    when :title
      text = Vocab.registration_help_title
    else
      text = ''
    end
    @help_window.set_text(text)
  end
end

module Cache
  # crea la bitmap che mostra le condizioni
  # @param [Fixnum] width
  # @param [Fixnum] height
  # @return [Bitmap]
  def self.eula_bitmap(width = Graphics.width, height = Graphics.height)
    @eula_bitmap ||= create_eula_bitmap(width, height)
  end

  # @param [Fixnum] width
  # @param [Fixnum] height
  # @return [Bitmap]
  def self.create_eula_bitmap(width, height)
    padding = 10
    bitmap = Bitmap.new(width, height)
    bitmap.fill_rect(0, 0, width, height, Color::BLACK.deopacize(220))
    bitmap.font.color = Color::WHITE
    bitmap.font.bold = false
    bitmap.font.italic = false
    bitmap.font.size = 15
    bitmap.line_height = 12
    bitmap.font.shadow = false
    bitmap.font.outline = false
    text = (Online.get(:application, :eula).decode_json rescue 'EULA ERROR')
    text.gsub!('\n',"\n")
    text.gsub!('\r',"\r")
    bitmap.draw_formatted_text(padding, padding, width - (padding * 2), text)
    y = height - 24
    bitmap.font.size = 23
    bitmap.draw_key_icon(:X, padding, y)
    bitmap.font.color = Color::GREENYELLOW
    bitmap.draw_text(24 + padding, y, width, 24, 'Accetta le condizioni')
    x = width / 2
    bitmap.font.color = Color::ORANGERED
    bitmap.draw_key_icon(:B, x, y)
    bitmap.draw_text(x + 24, y, width, 24, 'Rifiuta le condizioni')
    bitmap
  end
end