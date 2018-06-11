require File.expand_path('rm_vx_data')

module Settings
  #--------------------------------------------------------------------------
  # * Impostazioni
  #--------------------------------------------------------------------------
  # Nome dell'immagine di sfondo
  REGISTR_WALLPAPER = 'SfondoOnline'
  #--------------------------------------------------------------------------
  # * Stringhe
  #--------------------------------------------------------------------------
  REGR_HELP1 = 'Vuoi registrare il tuo profilo online?|Ti servirà per accedere alle funzionalità web del gioco.'
  REGR_HELP2 = 'Inserisci il nome e l\'avatar del tuo profilo, verranno visti dagli|altri giocatori.'
  REGR_HELP3 = 'Nome da 3 a 15 caratteri alfanumerici, spazi e simboli - _|Scegli bene, perché non potrai cambiarlo.'
  REGR_HELP4 = 'Scegli un\'immagine in cui i giocatori ti identificheranno.|Puoi cambiare successivamente l\'immagine quando vuoi.'
  REGR_HELP5 = 'Completa la registrazione.'
  VOC_PLAYER_NAME = 'Nome giocatore'
  VOC_REGISTERING = 'Registrazione in corso...'
  VOC_REGSUCCESS = 'La registrazione è avvenuta con successo!'
  VOC_REGFAILED = 'Errore: c\'è stato un errore nella registrazione.\nSe il problema persiste, contattare il supporto tecnico.'
  VOC_REGISTER_CMD = 'Registrati'
  VOC_CANC_REG_CMD = 'Salta'
  VOC_REG_NAME_CMD = 'Nome utente'
  VOC_REG_AVAT_CMD = 'Avatar'
  VOC_REG_SUBM_CMD = 'Procedi'
  VOC_REG_NAME_TXT = 'Nome'
  VOC_REG_AVAT_TXT = 'Avatar'
  REG_NAME_CHECK = 'Controllo in corso...'
  REG_NAME_AVAILABLE = 'Questo nome è disponibile'
  REG_NAME_USED = 'Questo nome è già in uso'
  REG_NAME_ERROR = 'Errore: Impossibile connettersi'
  REG_NAME_NO = 'Non puoi usare questo nome.'
end

#===============================================================================
# ** Game_Temp
#-------------------------------------------------------------------------------
# Aggiunta dell'attributo step1
#===============================================================================
class Game_Temp
  attr_accessor :step1
end

module Vocab
  #--------------------------------------------------------------------------
  # * Primo passo della registrazione
  #--------------------------------------------------------------------------
  def self.registration_step1; Settings::REGR_HELP1; end
  #--------------------------------------------------------------------------
  # * Secondo passo della registrazione
  #--------------------------------------------------------------------------
  def self.registration_step2; Settings::REGR_HELP2; end
  #--------------------------------------------------------------------------
  # * Descrizione d'aiuto del comando Avatar
  #--------------------------------------------------------------------------
  def self.registration_help_avatar; Settings::REGR_HELP4; end
  #--------------------------------------------------------------------------
  # * Descrizione d'aiuto del comando Nome
  #--------------------------------------------------------------------------
  def self.registration_help_name; Settings::REGR_HELP3; end
  #--------------------------------------------------------------------------
  # * Descrizione d'aiuto del comando Invia
  #--------------------------------------------------------------------------
  def self.registration_help_submit; Settings::REGR_HELP5; end
  #--------------------------------------------------------------------------
  # * Comando nome del giocatore
  #--------------------------------------------------------------------------
  def self.player_name; Settings::VOC_PLAYER_NAME; end
  #--------------------------------------------------------------------------
  # * Processo di registrazione in corso
  #--------------------------------------------------------------------------
  def self.registration_processing; Settings::VOC_REGISTERING; end
  #--------------------------------------------------------------------------
  # * Messaggio di registrazione avvenuta
  #--------------------------------------------------------------------------
  def self.registration_successful; Settings::VOC_REGSUCCESS; end
  #--------------------------------------------------------------------------
  # * Messaggio di registrazione fallita
  #--------------------------------------------------------------------------
  def self.registration_failed; Settings::VOC_REGFAILED; end
  #--------------------------------------------------------------------------
  # * Comando Registra
  #--------------------------------------------------------------------------
  def self.register_command; Settings::VOC_REGISTER_CMD; end
  #--------------------------------------------------------------------------
  # * Comando Annulla
  #--------------------------------------------------------------------------
  def self.register_cancel; Settings::VOC_CANC_REG_CMD; end
  #--------------------------------------------------------------------------
  # * Comando conferma nome utente
  #--------------------------------------------------------------------------
  def self.reg_username_cmd; Settings::VOC_REG_NAME_CMD; end
  #--------------------------------------------------------------------------
  # * Comando conferma avatar
  #--------------------------------------------------------------------------
  def self.reg_avatar_cmd; Settings::VOC_REG_AVAT_CMD; end
  #--------------------------------------------------------------------------
  # *  Comando invia
  #--------------------------------------------------------------------------
  def self.reg_submit_cmd; Settings::VOC_REG_SUBM_CMD; end
  #--------------------------------------------------------------------------
  # * Nome utente
  #--------------------------------------------------------------------------
  def self.username; Settings::VOC_REG_NAME_TXT; end
  #--------------------------------------------------------------------------
  # * Avatar
  #--------------------------------------------------------------------------
  def self.avatar; Settings::VOC_REG_AVAT_TXT; end
  #--------------------------------------------------------------------------
  # * Controllo nome in corso
  #--------------------------------------------------------------------------
  def self.name_check; Settings::REG_NAME_CHECK; end
  #--------------------------------------------------------------------------
  # * Nome disponibile
  #--------------------------------------------------------------------------
  def self.name_available; Settings::REG_NAME_AVAILABLE; end
  #--------------------------------------------------------------------------
  # * Nome usato
  #--------------------------------------------------------------------------
  def self.name_used; Settings::REG_NAME_USED; end
  #--------------------------------------------------------------------------
  # * Nome non corretto
  #--------------------------------------------------------------------------
  def self.name_wrong; Settings::REG_NAME_NO; end
  #--------------------------------------------------------------------------
  # * Errore controllo nome
  #--------------------------------------------------------------------------
  def self.name_error; Settings::REG_NAME_ERROR; end
end

#===============================================================================
# ** Scene_Registration
#-------------------------------------------------------------------------------
# Schermata di registrazione del giocatore
#===============================================================================
class Scene_Registration < Scene_MenuBase
  def start
    super
    create_help_window
    create_choice_window
    create_registration_window
    create_info_window
    create_typing_window
    create_avatar_window
  end
  #--------------------------------------------------------------------------
  # * Creazione dello sfondo della schermata
  #--------------------------------------------------------------------------
  def create_menu_background
    @menuback_sprite = Plane.new
    @menuback_sprite.bitmap = Cache.parallax(Settings::REGISTR_WALLPAPER)
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    @menuback_sprite.ox += 1
    @menuback_sprite.oy += 1
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra di selezione
  #--------------------------------------------------------------------------
  def create_choice_window
    @choice_window = Window_RegChoice.new
    @choice_window.set_handler(:register, method(:configure_registration))
    @choice_window.set_handler(:cancel, method(:go_game))
    if !$game_temp.step1
      help_text(0)
    else
      @choice_window.visible = self.openness = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra di registrazione
  #--------------------------------------------------------------------------
  def create_registration_window
    @reg_window = Window_Registration.new(@help_window.height)
    @reg_window.help_window = @help_window
    @reg_window.set_handler(:name, method(:set_name))
    @reg_window.set_handler(:avatar, method(:set_avatar))
    @reg_window.set_handler(:register, method(:register))
    @reg_window.set_handler(:cancel, method(:back))
    @reg_window.openness = 0 unless $game_temp.step1
    @reg_window.help_window = @help_window
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra di selezione avatar
  #--------------------------------------------------------------------------
  def create_avatar_window
    y = @reg_window.y + @reg_window.height
    @avatar_window = Window_Avatar.new(0,y,128, Graphics.height - y)
    @avatar_window.visible = false
    @avatar_window.active = false
    @avatar_window.set_handler(:ok, method(:avatar_selected))
    @avatar_window.set_handler(:cancel, method(:close_avatar))
  end
  #--------------------------------------------------------------------------
  # * Imposta il testo d'aiuto
  #--------------------------------------------------------------------------
  def help_text(value)
    case value
      when 0
        txt = Vocab.registration_step1
      when 1
        txt = Vocab.registration_step2
      else
        txt = ''
    end
    @help_window.set_text(txt)
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra delle informazioni
  #--------------------------------------------------------------------------
  def create_info_window
    @info_window = Window_RegistrationInfo.new(180, 200)
    @info_window.command_window = @reg_window
    @info_window.openness = 0 unless $game_temp.step1
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra del nome eroe
  #--------------------------------------------------------------------------
  def create_typing_window
    x = @reg_window.width + 20  #Graphics.width / 2 - 200
    y = @reg_window.y + 20      #Graphics.height/2
    w = 400
    @typing_window = Window_Typing.new(x, y, w, Vocab.player_name)
    @typing_window.max_char = 15
    @typing_window.set_handler(:ok, method(:do_rename))
    @typing_window.set_handler(:cancel, method(:do_nothing))
    @typing_window.input_scope = Window_Typing::NICKNAME
    @typing_window.deactivate
  end
  #--------------------------------------------------------------------------
  # * Rinomina
  #--------------------------------------------------------------------------
  def do_rename
    #@info_window.waiting
    #@typing_window.set_closing_handler(method(:change_name))
    change_name(@typing_window.text)
    @typing_window.close
    @reg_window.activate
    @typing_window.deactivate
  end
  #--------------------------------------------------------------------------
  # * Procedura di chiamata popup per selezione nome eroe
  #--------------------------------------------------------------------------
  def change_name(text)
    return if text == @info_window.name
    @info_window.change_name(text)
  end
  #--------------------------------------------------------------------------
  # * Esci dalla finestra di cambio nickname
  #--------------------------------------------------------------------------
  def do_nothing
    @typing_window.deactivate
    @reg_window.activate
    @typing_window.close
  end
  #--------------------------------------------------------------------------
  # * Inizializzazione della procedura di registrazione
  #--------------------------------------------------------------------------
  def configure_registration
    help_text(1)
    @choice_window.close
    @reg_window.open
    @reg_window.activate
    @info_window.open
    $game_temp.step1 = true
  end
  #--------------------------------------------------------------------------
  # * Torna indietro
  #--------------------------------------------------------------------------
  def back
    help_text(0)
    @choice_window.open
    @reg_window.close
    @info_window.close
    @choice_window.activate
    $game_temp.step1 = false
  end
  #--------------------------------------------------------------------------
  # * Attiva la finestra di selezione nome
  #--------------------------------------------------------------------------
  def set_name
    @typing_window.text = @info_window.name
    @typing_window.open
    @typing_window.activate
  end
  #--------------------------------------------------------------------------
  # * Attiva la finestra di selezione avatar
  #--------------------------------------------------------------------------
  def set_avatar
    @avatar_window.activate
    @avatar_window.x = 0 - @avatar_window.width
    @avatar_window.visible = true
    @avatar_window.smooth_move(0, @avatar_window.y)
  end
  #--------------------------------------------------------------------------
  # * Procedura di selezione avatar
  #--------------------------------------------------------------------------
  def avatar_selected
    @info_window.change_avatar(@avatar_window.index)
    close_avatar
  end
  #--------------------------------------------------------------------------
  # * Chiusura della finestra di selezione avatar
  #--------------------------------------------------------------------------
  def close_avatar
    @avatar_window.smooth_move(0 - @avatar_window.width, @avatar_window.y)
    @reg_window.activate
  end
  #--------------------------------------------------------------------------
  # * Procedura di avvio registrazione
  #--------------------------------------------------------------------------
  def register
    show_dialog_waiting(Vocab.registration_processing, true)
    Graphics.update
    begin
      r = Online.register_player(@info_window.name, @info_window.avatar)
      response_gained(r)
    rescue
      show_dialog(Vocab.connection_error, @reg_window)
    end
    #get_response_async(param, method(:response_gained)) < obsoleto
  end
  #--------------------------------------------------------------------------
  # * Parametri per il GET. Non più usato, il metodo cambia in POST
  #--------------------------------------------------------------------------
  def param
    name = @info_window.name
    id = $game_party.id_partita
    avatar = @info_window.avatar
    params = Base64.encode(sprintf('%s,%s,%d',name,id,avatar))
    Online.api_path + '/regnew.php?get=' + params
  end
  #--------------------------------------------------------------------------
  # * Metodo chiamato quando è stata ricevuta la risposta
  #--------------------------------------------------------------------------
  def response_gained(success)
    if success
      show_dialog(Vocab.registration_successful, method(:go_game))
      $game_system.player = Online_Player.new(@info_window.name, @info_window.avatar)
    else
      println response
      show_dialog(Vocab.registration_failed,@reg_window)
    end
  end
  #--------------------------------------------------------------------------
  # * Ritorna al gioco se caricato
  #--------------------------------------------------------------------------
  def go_game
    RPG::BGM.fade(30)
    @dialog_window.visible = false
    @dialog_window.dispose
    @info_window.visible = false
    @info_window.dispose
    SceneManager.goto(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * Nuovo Gioco
  #--------------------------------------------------------------------------
  def command_new_game
    DataManager.setup_new_game
    RPG::BGM.fade(1500)
    Graphics.fadeout(60)
    Graphics.wait(40)
    Graphics.frame_count = 0
    RPG::BGM.stop
    $game_map.autoplay
  end
end

#===============================================================================
# ** Window_RegChoice
#-------------------------------------------------------------------------------
# Finestra di scelta se registrare o saltare
#===============================================================================
class Window_RegChoice < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    update_placement
    self.openness = 0
    open
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width; 160; end
  #--------------------------------------------------------------------------
  # * Update Window Position
  #--------------------------------------------------------------------------
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height * 1.6 - height) / 2
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
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
class Window_Registration < Window_Command
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def initialize(y)
    @registration_ok = false
    super(0, y)
  end
  #--------------------------------------------------------------------------
  # * Larghezza della finestra
  # @return [Integer]
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width/3
  end
  #--------------------------------------------------------------------------
  # * Crea la lista dei comandi
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab.reg_username_cmd, :name)
    add_command(Vocab.reg_avatar_cmd, :avatar)
    add_command(Vocab.reg_submit_cmd, :register, @registration_ok)
  end
  #--------------------------------------------------------------------------
  # * Registrazione completata
  #--------------------------------------------------------------------------
  def registration_ok=(value)
    return if value == @registration_ok
    @registration_ok = value
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    case index
      when 0
        text = Vocab.registration_help_name
      when 1
        text = Vocab.registration_help_avatar
      when 2
        text = Vocab.registration_help_submit
      else
        text = ''
    end
    @help_window.set_text(text)
  end
end

#===============================================================================
# ** Window_RegistrationInfo
#-------------------------------------------------------------------------------
# Finestra di informazioni sulla registrazione
#===============================================================================
class Window_RegistrationInfo < Window_Base
  #--------------------------------------------------------------------------
  # * Informazioni sulla registrazione
  #--------------------------------------------------------------------------
  attr_accessor :command_window # finestra di comando
  attr_reader :name             # nome
  attr_reader :avatar           # avatar
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y)
    width = Graphics.width - x*2
    height = line_height * 8
    super(x, y, width, height)
    @command_window = nil
    @name = Win.username
    @avatar = nil
    name_check
  end
  #--------------------------------------------------------------------------
  # * Attesa
  #--------------------------------------------------------------------------
  def waiting
    @checking = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Controllo nome
  #--------------------------------------------------------------------------
  def name_check
    if requirements_met(@name)
      Thread.new{get_response_async(request, method(:check_response))}
      @checking = 0
    else
      @checking = 4
    end
    @command_window.registration_ok = false if @command_window
    refresh
  end
  #--------------------------------------------------------------------------
  # * Se il nickname soddisfa i requisiti
  #--------------------------------------------------------------------------
  def requirements_met(text); text =~ /^[\w \-_]{3,15}$/i; end
  #--------------------------------------------------------------------------
  # * Preparazione della richiesta per controllare se il nome è disponibile
  #--------------------------------------------------------------------------
  def request
    domain = Online.api_path
    req_api = '/name_check.php?name='
    parameter = Base64.encode(@name)
    domain + req_api + parameter
  end
  #--------------------------------------------------------------------------
  # * Cambia nome (avviato alla conferma del nome digitato)
  # @param [String] new_name
  #--------------------------------------------------------------------------
  def change_name(new_name)
    return if new_name==@name
    @name = new_name
    name_check
  end
  #--------------------------------------------------------------------------
  # * Cambio avatar
  # @param [Integer] new_avatar
  #--------------------------------------------------------------------------
  def change_avatar(new_avatar)
    return if @avatar == new_avatar
    @avatar = new_avatar
    update_registration_ok
    refresh
  end
  #--------------------------------------------------------------------------
  # * Controllo della risposta
  #--------------------------------------------------------------------------
  def check_response(value)
    case value
      when Online::NO_PLAYER
        @checking = 1
        update_registration_ok
      when '1'
        @checking = 2
      when '-1'
        @checking = 4
      else
        print value if $TEST
        @checking = 3
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # *  Non ricordo.
  #--------------------------------------------------------------------------
  def update_registration_ok
    return unless @command_window
    @command_window.registration_ok = @checking == 1 && @avatar != nil
  end
  #--------------------------------------------------------------------------
  # * Sta controllando il nome?
  #--------------------------------------------------------------------------
  def checking?; @checking == 0; end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(system_color)
    draw_text(0,0,contents_width, line_height,Vocab.username + ':')
    change_color(normal_color)
    draw_text(text_size(Vocab.username + ': ').width,0,contents_width, line_height, @name)
    draw_name_avaiability
    change_color(system_color)
    draw_text(0,line_height*2,contents_width, line_height,Vocab.avatar + ':')
    draw_image
  end
  #--------------------------------------------------------------------------
  # * Disegna l'immagine dell'avatar
  #--------------------------------------------------------------------------
  def draw_image
    x = text_size(Vocab.avatar + ': ').width
    draw_avatar(@avatar, x, line_height*2)
  end
  #--------------------------------------------------------------------------
  # * Mostra la disponibilità del nome
  #--------------------------------------------------------------------------
  def draw_name_avaiability
    case @checking
      when 0
        change_color(normal_color)
        text = Vocab.name_check
      when 1
        change_color(power_up_color)
        text = Vocab.name_available
      when 2
        change_color(power_down_color)
        text = Vocab.name_used
      when 3
        change_color(crisis_color)
        text = Vocab.name_error
      when 4
        change_color(power_down_color)
        text = Vocab.name_wrong
      else
        text = ''
    end
    draw_text(0, line_height, contents_width, line_height, text, 1)
  end
end

#===============================================================================
# ** Window_Avatar
#-------------------------------------------------------------------------------
# La finestra di selezione dell'avatar
#===============================================================================
class Window_Avatar < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    make_item_list
    super
    self.index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * numero massimo di colonne
  #--------------------------------------------------------------------------
  def col_max; [self.width / item_width, 1].max; end
  #--------------------------------------------------------------------------
  # * numero massimo di oggetti
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * Altezza del blocco
  #--------------------------------------------------------------------------
  def item_height; 96; end
  #--------------------------------------------------------------------------
  # * Larghezza del blocco
  #--------------------------------------------------------------------------
  def item_width; 96; end
  #--------------------------------------------------------------------------
  # * Ottiene i dati dei volti avatar
  #--------------------------------------------------------------------------
  def make_item_list; @data = $game_temp.avatars.all_faces; end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto all'indice
  #--------------------------------------------------------------------------
  def draw_item(index)
    return if @data[index].nil?
    rect = item_rect(index)
    draw_avatar(index, rect.x, rect.y)
  end
end