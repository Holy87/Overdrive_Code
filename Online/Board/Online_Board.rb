#===============================================================================
# ** Dimensional_Sphere_Settings
#-------------------------------------------------------------------------------
# Impostazioni della sfera dimensionale
#===============================================================================
module Overdrive_Board_Settings
  # Nomi delle sfere sparse per il mondo
  PLACES = {
      :badupub => ['Baduelle', ' di '],
      :entrabalti => ['Caverne di Baltimora', ' delle '],
      :baltimora => ['Caverne di Baltimora', ' delle '],
      :sirenas => ['Sirenas', ' di '],
      :sirepub => ['Pub di Sirenas', ' del '],
      :monfepub => ['Pub di Monferras', ' del '],
      :cerantopos => ['Tana del Cerantopos', ' della '],
      :florea => ['Castello di Florea', ' del '],
      :villa => ['Villa Stregata', ' della '],
      :bejed => ['Torre di Bejed', ' della '],
      :bejed2 => ['Torre di Bejed', ' della '],
      :scalabejed => ['Torre di Bejed', ' della '],
      :ciclamini1 => ['Monti Ciclamini', ' dei '],
      :ciclamini2 => ['Monti Ciclamini', ' dei '],
      :ciclamini3 => ['Monti Ciclamini', ' dei '],
      :ciclamini4 => ['Monti Ciclamini', ' dei '],
      :pigwarts => ['Accademia di Pigwarts', ' dell\''],
      :labirinto => ['Villa Stregata - Labirinto', ' della '],
      :labirinto2 => ['Villa Stregata - Labirinto', ' della '],
      :vampiro => ['Dimora del vampiro', ' della '],
      :carpia => ['Carpia', ' di '],
      :fasbury => ['Porto di Fasbury', ' del '],
      :sotterraneo => ['Stanza segreta', ' della '],
      :piramide => ['Piramide Gassosa - P1', ' della '],
      :piramide2 => ['Piramide Gassosa - P3', ' della '],
      :piramide3 => ['Piramide Gassosa - P5', ' della '],
      :faideeiba => ['Faide-Eiba', ' di '],
      :deserto => ['Deserto Yascha', ' del '],
      #:farse => ['Farse',' di '],
      :miniere10 => ['Miniere di Elmore', ' delle '],
      :miniere1 => ['Miniere di Elmore', ' delle '],
      :minierecarr => ['Profondità di Elmore', ' della '],
      :minierenigma => ['Enigma su binari', ' dell\''],
      :farse => ['Sotterranei di Farse', ' dei '],
      :casaforesta => ['Foresta di Elmore', ' della '],
      :fogne1 => ['Fogne di Balthazar', ' delle '],
      :fogne2 => ['Fogne di Balthazar', ' delle '],
      :tempiofuori => ['Esterno dell\'antico Tempio', ' dell\''],
      :stanzatempio => ['Tempio perduto', ' del '],
      :tempiototem => ['Tempio perduto - piani inf.', ' del '],
      :preogre => ['Rovine di Adele', ' delle '],
      :kumog => ['Monte Kumo', ' del '],
      :kumogr2 => ['Grotta di Kumo', ' della '],
      :kaji => ['Vulcano Kaji', ' del '],
      :kajie => ['Grotta Kaji', ' della '],
      :cavaneve => ['Monti innevati', ' dei '],
      :cavaneve2 => ['Monti innevati', ' dei '],
      :diamantica => ['Diamantica', ' di '],
      :havbase1 => ['Base di Havoc 1F', ' della '],
      :havbase2 => ['Base di Havoc 3F', ' della '],
      :yugureporto => ['Porto di Yugure', ' del '],
      :selvas => ['Selva di salici', ' della '],
      :balthazar => ['Città di Balthazar', ' della '],
      :balthapub => ['Pub di Balthazar', ' del '],
      :balthac1 => ['Castello in guerra', ' del '],
      :balthac2 => ['Castello di Balthazar', ' del '],
      :adele => ['Pub di Adele', ' del '],
      :yugupub => ['Pub di Yugure', ' del '],
      :nevandrapub => ['Pub di Nevandra', ' del '],
      :nevandracast => ['Castello di Nevandra', ' del '],
      :northur => ['Porto di Northur', ' del '],
      :casamonica => ['Villa di Monica', ' della '],
      :test => ['prova', ' di ']
  }

  BOARD_WINDOW_SETTINGS = {
      :max_characters => 50,
      :max_lines => 4
  }

  PLAYER_TAG_PATTERN = /@{([\w\-@.\s]+)}/i
  EMOJI_KEY = :VK_TAB

  NOTIFY_SOUND = 'Chime2'
  TAG_COLOR_CODE = 17

  REPORT_MOTIVES = [
      'Insulti verso una persona',
      'Parole di odio o discriminazione',
      'Spoiler su parti della trama',
      'Oscenità e/o volgarità',
      'Divulga informazioni private o sensibili',
      'Spam, pubblicità, phishing o frode'
  ]

  REPORT_HELP = [
      "Seleziona questa opzione se il messaggio contiene insulti mirati|verso un altro giocatore.",
      "Seleziona questa opzione se il messaggio contiene discriminazioni di|ogni genere (etnia, religione, orientamento sessuale ecc...)",
      "Seleziona questa opzione se il messaggio rivela parti della storia dove|il giocatore potrebbe non essere ancora arrivato.",
      "Seleziona questa opzione se sono presenti, secondo te, parole che non|dovrebbero essere presenti.",
      "Seleziona questa opzione se sono presenti numeri di telefono, indirizzi, email,|password ed altre informazioni sensibili."
  ]
end

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# Vocaboli principali
#===============================================================================
module Vocab
  # Testo mostrato quando scarica i messaggi
  def self.mess_download
    'Download dei messaggi in corso...'
  end

  # Quando non ci sono messaggi nella sfera
  def self.no_messages
    'Non ci sono messaggi in questa sfera. Vuoi essere il primo?'
  end

  # Quando non si ricevono i dati
  def self.data_error
    'Errore nella ricezione dei dati.'
  end

  # Quando c'è un errore di connessione
  def self.connection_error
    'Impossibile collegarsi al server del gioco.'
  end

  # Il numero di messaggi
  def self.message_number
    '%d messaggi'
  end

  # Aiuto della bacheca
  def self.board_help
    'Premi Azione per inserire un messaggio.'
  end

  # Aiuto nell'inserimento del testo
  def self.writing_help
    '%s + %s per spedire, %s per annullare.'
  end

  # Aiuto durante l'invio del messaggio
  def self.send_help
    'Invio in corso, attendere...'
  end

  # Testo d'errore invio
  def self.send_error
    'Errore nell\'inviare il messaggio. Riprova.'
  end

  # Testo d'errore invio
  def self.auth_error
    'Errore di autenticazione.'
  end

  # Testo mostrato se bannato
  def self.ban_error
    'ATTENZIONE: Sei stato bannato. Non puoi inviare altri messaggi.'
  end

  # Comandi della bacheca
  def self.board_write
    'Scrivi'
  end

  def self.board_reply
    'Rispondi'
  end

  def self.board_alert
    'Segnala'
  end

  def self.board_stats
    'Informazioni'
  end

  def self.update_board
    'Aggiorna'
  end

  def self.banned
    'BANNATO'
  end

  def self.message_report_warning
    "Utilizza questa funzione responsabilmente.\nSegnala solo per i motivi riportati in seguito."
  end

  def self.report_sent
    "Segalazione inviata. Verrà presa in carico il prima possibile."
  end

  def self.report_send_error
    "Non è stato possibile inviare la segnalazione."
  end

  def self.board_message_sent
    "Messaggio inviato."
  end
end


#===============================================================================
# ** Scene_MessageBoard
#-------------------------------------------------------------------------------
# Schermata della sfera dimensionale
#===============================================================================
class Scene_MessageBoard < Scene_MenuBase
  # Inizializzazione
  def start
    super
    create_main_viewport
    get_message_board
    create_info_window
    create_messages_window
    create_writing_window
    create_command_window
    create_emoji_window
    create_player_window
    create_report_window
    create_alert_message_window
    create_transition_sprite
    download_messages
  end

  def update
    super
    @transition_sprite.update
  end

  def terminate
    super
    @transition_sprite.dispose
    dispose_main_viewport
  end

  def get_message_board
    @board = Dimensional_Sphere.new($game_temp.sphere_id)
  end

  # @return [Dimensional_Sphere]
  def message_board
    @board
  end

  def download_messages
    begin
      message_board.refresh
      messages = message_board.messages
      @info_window.set_help(:downloaded)
      @info_window.set_number(messages.size)
    rescue InternetConnectionException => error
      if error.code == 0
        @info_window.set_help(:connection_error)
      else
        Logger.error error.message
        @info_window.set_help(:data_error, error.code)
      end
      messages = []
    ensure
      @message_window.set_messages(messages || [])
    end
  end

  # Creazione della finestra delle informazioni
  def create_info_window
    @info_window = Window_BoardInfo.new
    @info_window.set_name(message_board.name)
  end

  # Creazione della finestra dei messaggi
  def create_messages_window
    @message_window = Window_BoardMessage.new(@info_window.height)
    @message_window.y = @info_window.height
    @message_window.set_board(message_board)
    @message_window.set_handler(:cancel, method(:return_scene))
    @message_window.set_handler(:ok, method(:message_handling))
  end

  # Crea la finestra di scrittura del messaggio
  def create_writing_window
    @writing_window = Window_BoardWriter.new(0, @info_window.height)
    @writing_window.set_done_handler(method(:do_send))
    @writing_window.set_cancel_handler(method(:cancel_message))
    #@writing_window.set_emoji_handler(method(:open_emoji))
    @writing_window.max_characters = 200
    @writing_window.openness = 0
  end

  # Crea la finestra dei comandi
  def create_command_window
    @command_window = Window_BoardChoice.new(@info_window.height)
    @command_window.set_handler(:write, method(:do_write))
    @command_window.set_handler(:reply, method(:do_reply))
    @command_window.set_handler(:alert, method(:do_alert))
    @command_window.set_handler(:stats, method(:do_stats))
    @command_window.set_handler(:cancel, method(:do_back))
    @command_window.set_handler(:update, method(:do_update))
  end

  def create_report_window
    @report_window = Window_MessageReport.new(0, 0)
    @report_window.openness = 0
    @report_window.set_handler(:ok, method(:send_report))
    @report_window.set_handler(:cancel, method(:close_report))
  end

  # Crea la finestra delle emoji
  def create_emoji_window
    y = @info_window.height + @writing_window.height
    @emoji_window = Window_Emoji.new(0, y)
    @emoji_window.set_handler(:ok, method(:add_emoji))
    @emoji_window.set_handler(:cancel, method(:close_emoji))
  end

  def create_player_window
    y = @info_window.height
    @player_window = Window_PlayerInfo.new(0, y, Graphics.width)
    @player_window.set_cancel_handler(method(:close_player_info))
    @player_window.openness = 0
  end

  def create_alert_message_window
    @alert_message_window = Window_MessageAlert.new(Graphics.width, @report_window.bottom_corner)
    @alert_message_window.visible = false
  end

  def create_transition_sprite
    @transition_sprite = Sprite.new
    @transition_sprite.viewport = @viewport
    @viewport.z = 999
  end

  # Scrive il messaggio
  def do_write(player_name = nil)
    @old_help = @info_window.help
    @info_window.set_help(:writing)
    @command_window.unselect_start
    y = @message_window.y + @writing_window.height
    @message_window.smooth_move(0, y)
    @writing_window.activate
    @writing_window.clear
    @writing_window.set_player_quote(player_name) if player_name
    @writing_window.visible = true
    @writing_window.open
  end

  # Apertura delle emoji
  def open_emoji
    @emoji_window.open
    @emoji_window.activate
    y = @info_window.height + @writing_window.height + @emoji_window.height
    @message_window.smooth_move(0, y)
  end

  # Aggiunta dell'emoji al testo
  def add_emoji
    @writing_window.add_character(@emoji_window.item.char)
    @emoji_window.activate
  end

  # Chiude la finestra delle emoji
  def close_emoji
    @emoji_window.deactivate
    @emoji_window.close
    y = @info_window.height + @writing_window.height
    @message_window.smooth_move(0, y)
    @writing_window.activate
  end

  # Scrive il messaggio con risposta
  def do_reply
    do_write @message_window.item.author_name
  end

  # Segnala un messaggio
  def do_alert
    @alert_message_window.clear
    @transition_sprite.visible = false
    @transition_sprite.bitmap = @message_window.current_item_bitmap
    @transition_sprite.x = @message_window.absolute_rect.x
    @transition_sprite.y = @message_window.absolute_rect.y
    show_dialog(Vocab.message_report_warning, method(:open_alert_window), :warning)
  end

  def open_alert_window
    @info_window.smooth_move(0, 0 - @info_window.height)
    @message_window.smooth_move(0, Graphics.height)
    unless @alert_message_window.visible
      @alert_message_window.x = Graphics.width
      @alert_message_window.visible = true
    end
    @alert_message_window.smooth_move(0, @alert_message_window.y)
    @command_window.unselect_start
    @report_window.open
    @transition_sprite.visible = true
    @transition_sprite.smooth_move(0 + @alert_message_window.padding, 0 + @alert_message_window.padding, 4, method(:activate_alert_window))
  end

  def activate_alert_window
    @alert_message_window.set_bitmap(@transition_sprite.bitmap)
    @transition_sprite.bitmap.dispose
    @transition_sprite.bitmap = nil
    @report_window.index = 0
    @report_window.activate
  end

  # Visualizza le statistiche
  def do_stats
    player = @message_window.item.author
    @command_window.activate
    @player_window.player = player
    @command_window.unselect_start
    @message_window.smooth_move(0, Graphics.height)
    @player_window.y = Graphics.height
    @player_window.visible = true
    @player_window.smooth_move(0, @info_window.height)
    @player_window.open
  end

  # Chide la finestra delle informazioni
  def close_player_info
    @player_window.smooth_move(0, Graphics.height)
    @message_window.smooth_move(0, @info_window.bottom_corner)
    @message_window.activate
  end

  # Invia il messaggio
  def do_send
    @writing_window.close
    @info_window.set_help(:sending)
    Graphics.update
    @message_window.smooth_move(0, @info_window.height)
    result = message_board.post(@writing_window.text)
    if result.success?
      Sound.play_use_item
      @info_window.set_help(nil)
      @board.refresh
      @message_window.refresh
      @message_window.index = 0
      show_dialog(Vocab.board_message_sent, @message_window)
    else
      Sound.play_buzzer
      @info_window.set_help(result.failed_message)
      show_dialog(Vocab.send_error, @message_window, :error)
    end
  end

  # Aggiorna la sfera
  def do_update
    @message_window.smooth_move(0, @info_window.height)
    @command_window.unselect_start
    download_messages
    @message_window.activate
  end

  # Annulla l'invio del messaggio
  def cancel_message
    @info_window.set_help(@old_help)
    @message_window.smooth_move(0, @info_window.height)
    @message_window.activate
    @writing_window.close
  end

  # Gestisce cosa fanno i messaggi
  def message_handling
    @command_window.select_start(@message_window.item)
    @message_window.smooth_move(@command_window.width, @message_window.y)
  end

  # Annulla l'operazione delle opzioni
  def do_back
    @message_window.smooth_move(0, @message_window.y)
    @message_window.activate
    @command_window.unselect_start
  end

  def close_report
    @report_window.close
    @info_window.smooth_move(0, 0)
    @alert_message_window.smooth_move(Graphics.width, @alert_message_window.y)
    @message_window.smooth_move(0, @info_window.height)
    @message_window.activate
  end

  def send_report
    @report_window.close
    operation = Online.report_board_message @message_window.message.message_id, @report_window.index
    if operation.success?
      show_dialog(Vocab.report_sent, method(:close_report))
    else
      message = sprintf("%s\n\\c[2]%s", Vocab.report_send_error, operation.failed_message)
      show_dialog(message, method(:close_report), :error)
    end
  end
end

#===============================================================================
# ** Window_BoardInfo
#-------------------------------------------------------------------------------
# Piccola finestra sulle informazioni della sfera dimensionale
#===============================================================================
class Window_BoardInfo < Window_Base
  ALERT_ICON = 644
  INFO_ICON = 612
  LOADING_ICONS = [1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223]
  attr_reader :help
  # Inizializzazione
  def initialize
    super(0, 0, Graphics.width, fitting_height(2))
    @loading_state = 0
  end

  # Refresh
  def refresh
    contents.clear
    draw_title
    draw_help
  end

  # Aggiorna il rettangolo dell'icona
  def refresh_square
    contents.clear_rect(0, line_height, 24, 24)
    draw_icon(loading_icon, 0, line_height)
  end

  # Disegna il titolo della sfera
  def draw_title
    if @name != nil
      draw_text(0, 0, contents_width, line_height, @name)
    end
  end

  # Disegna la stringa d'aiuto
  def draw_help
    return if @help.nil?
    case @help
    when :connecting
      icon = loading_icon
      text = Vocab.mess_download
      color = crisis_color
    when :downloaded
      icon = INFO_ICON
      text = Vocab.board_help
      color = normal_color
    when :connection_error
      icon = ALERT_ICON
      text = Vocab.connection_error
      color = knockout_color
    when :data_error
      icon = ALERT_ICON
      text = sprintf('%s (%s)', Vocab.data_error, @additional_info)
      color = knockout_color
    when :writing
      icon = INFO_ICON
      text = sprintf(Vocab.writing_help,
                     Vocab.key_name(:VK_CONTROL),
                     Vocab.key_name(:VK_RETURN),
                     Vocab.key_name(:VK_ESCAPE))
                     #Vocab.key_name(Overdrive_Board_Settings::EMOJI_KEY))
      color = normal_color
    when :sending
      icon = loading_icon
      text = Vocab.send_help
      color = crisis_color
    when :error_banned, Online::PLAYER_BANNED
      icon = ALERT_ICON
      text = Vocab.ban_error
      color = knockout_color
    when :send_error, Online::SERVER_ERROR, Online::UNPROCESSED, Online::NO_CONNECTION_ERROR
      icon = ALERT_ICON
      text = Vocab.send_error
      color = knockout_color
    when :auth_error
      icon = ALERT_ICON
      text = Vocab.auth_error
      color = knockout_color
    else
      icon = ALERT_ICON
      text = @help
      color = knockout_color
    end
    draw_icon(icon, 0, line_height)
    change_color(color)
    draw_text(24, line_height, contents_width, line_height, text)
    change_color(normal_color)
    if @number != nil
      text = sprintf(Vocab.message_number, @number)
      draw_text(0, 0, contents_width, line_height, text, 2)
    end
  end

  # imposta il nome della sfera
  # @param [String] name
  def set_name(name)
    @name = name
    refresh
  end

  # imposta il numero di messaggi
  #   value: numero
  def set_number(value)
    @number = value
    refresh
  end

  # imposta il tipo d'aiuto
  #   symbol: simbolo del tipo
  def set_help(symbol, additional_info = nil)
    @help = symbol
    @loading_state = 0 if @help == :connecting
    @additional_info = additional_info
    refresh
  end

  # aggiornamento
  def update
    super
    update_loading if @help == :connecting
  end

  # aggiorna il caricamento della finestra
  def update_loading
    return unless Graphics.frame_count % 4 == 0
    @loading_state += 1
    refresh_square
  end

  # restituisce l'icona adatta del caricamento
  def loading_icon
    LOADING_ICONS[@loading_state % LOADING_ICONS.size]
  end
end


#===============================================================================
# ** Game_Interpreter
#===============================================================================
class Game_Interpreter
  # Caricamento della sfera
  #   board_id: codice della sfera
  def load_board(board_id)
    $game_temp.sphere_id = board_id
    SceneManager.call(Scene_MessageBoard)
  end
end

#===============================================================================
# ** Game_Temp
#-------------------------------------------------------------------------------
# Aggiunta dell'ID della sfera che si sta visualizzando
#===============================================================================
class Game_Temp
  # ID della sfera dimensionale
  attr_accessor :sphere_id
end

#===============================================================================
# ** Window_BoardChoice
#-------------------------------------------------------------------------------
# Finestra di comandi selezionando un messaggio
#===============================================================================
class Window_BoardChoice < Window_Command
  # inizializzazione
  #   y: posizione y
  def initialize(y)
    super(Graphics.width, y)
    deactivate
    self.visible = false
    self.height = Graphics.height - y
  end

  # restituisce la larghezza della finestra
  def window_width
    150
  end

  # crea la finestra dei comandi
  def make_command_list
    add_command(Vocab.board_write, :write, can_write?)
    add_command(Vocab.board_reply, :reply, can_reply?)
    add_command(Vocab.board_alert, :alert, can_report?)
    add_command(Vocab.board_stats, :stats, can_view_stats?)
    add_command(Vocab.update_board, :update)
  end

  # Apparizione della finestra
  def select_start(item)
    activate
    self.x = 0 - self.width
    smooth_move(0, self.y)
    self.index = 0
    self.visible = true
    @item = item
    refresh
  end

  # Scomparsa della finestra
  def unselect_start
    deactivate
    smooth_move(0 - self.width, self.y)
    self.index = 0
  end

  # Restituisce true se l'utente può scrivere un messaggio
  def can_write?
    $game_system.can_upload?
  end

  # Restituisce true se l'utente può rispondere ad un giocatore
  def can_reply?
    return false unless item
    return false unless can_write?
    return false unless item.registered?
    return false if item.banned?
    return false if item.author_id == $game_system.player_id
    can_write?
  end

  # Restituisce true se l'utente può segnalare un messaggio
  def can_report?
    return false unless can_write?
    item != nil
  end

  # Restituisce true se è possibile vedere le informazioni sul giocatore
  def can_view_stats?
    return false unless item
    item.registered?
  end

  # Restituisce l'oggetto
  # @return [Board_Message]
  def item
    @item
  end
end

#===============================================================================
# ** Window_MessageReport
#-------------------------------------------------------------------------------
# Questa finestra mostra le opzioni
#===============================================================================
class Window_MessageReport < Window_Selectable
  def initialize(x, y)
    make_item_list
    super(x, y, Graphics.width, auto_height)
    create_contents
    refresh
  end

  def make_item_list
    @data = Overdrive_Board_Settings::REPORT_MOTIVES
  end

  def item_max
    @data.size
  end

  def draw_item(index)
    motive = @data[index]
    rect = item_rect(index)
    draw_text(rect, motive)
  end

  def auto_height
    fitting_height(item_max)
  end
end

class Window_MessageAlert < Window_Base
  def initialize(x, y)
    super(x, y, Graphics.width, fitting_height(5))
  end
  # @param [Bitmap] bitmap
  def set_bitmap(bitmap)
    contents.blt(0,0,bitmap, Rect.new(0, 0, contents_width, contents_height))
  end

  def clear
    contents.clear
  end
end