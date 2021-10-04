#===============================================================================
# MODULO INTERFACCIA ONLINE
#===============================================================================
# Autore: Holy87
# Versione: 2.0
# Difficoltà utente: ★★
#-------------------------------------------------------------------------------
# Questo script serve per interfacciarsi e comunicare con il servizio online di
# Overdrive (https://github.com/Holy87/overdrive_server)
# 
#-------------------------------------------------------------------------------
# Istruzioni:
# Copiare lo script sotto Materials, prima del Main.
# Necessita del Modulo di Supporto universale e di un decodificatore JSON.
# 
# I tipi di operazioni sono due: get ed upload. Questi metodi prendono
# obbligatoriamente due parametri (e terzo facoltativo): il primo è 
# la risorsa a cui si sta tentando di accedere, mentre il secondo è la
# operazione da eseguire. Nel terzo parametro ci sono parametri aggiuntivi
# da mandare al server per operazioni necessarie.
# Si utilizza get quando si vuole ottenere delle informazioni dal server,
# spesso non è necessario essere autenticati. Il metodo get restituisce
# un oggetto response se è andato a buon fine, oppure lancia l'errore
# InternetConnectionException, da qui puoi ottenere il codice d'errore HTTP.
# Si utilizza upload invece quando si vuole effettuare un'operazione che MODIFICA
# dei dati. Questa operazione tenta di effettuare il login se non si è ancora
# collegati. L'operazione di upload restituisce un oggetto Operation_Result
# dove è possibile ottenere il risultato della nostra operazione e se è andata
# a buon fine.
# Esempio:
# 
# Voglio ottenere le informazioni su un giocatore:
# 
# begin
#   response = Online.get :player, :get_player, {player_name: 'CiccioBello'}
#   return Online_Player.new(response.decode_json)
# rescue => error
#   puts 'Errore: ' + error.message
# end
#
# Il metodo get convertirà i parametri nella richiesta HTTP GET con url:
# http://overdriverpg.it/api/player/get_player.json?player_name=CiccioBello
# e restituirà una risposta il cui body è una stringa JSON.
# Utilizzando il metodo decode_json della risposta, avremo un hash con tutti
# i parametri. Il costruttore di Online_Player prende l'hash e inizializza
# tutti i suoi attributi.
# 
# Distribuzione:
# Se vuoi usare questo script per il tuo gioco non ho nulla in contrario, tieni
# però presente che potrei non fornirti alcun supporto.
#-------------------------------------------------------------------------------

module Online
  # Switch di attivazione/disattivazione delle feature online. Il giocatore può
  # scegliere se giocare online o offline in qualsiasi momento.
  ACTIVATION_SWITCH = 426
  SHARE_PARTY_SW = 427 # switch per condivisione membri del gruppo

  # Percorso delle chiamate al server nel dominio del gioco. Ad esempio, se il dominio è www.miogioco.it,
  # le API risiederanno in www.miogioco.it/api/risorsa/metodo
  SUBPATH_API = 'api'

  # codice risposta OK
  OK_RESPONSE = 1

  # Vocaboli
  NO_PLAYER_VOCAB = 'Giocatore non trovato.'
  WRONG_DATA_VOCAB = 'Errore del server.'
  CONN_ERROR_VOCAB = 'Non riesco a connettermi al server.'
  SERVER_CONNECTION = 'Connessione in corso...'

  # Costanti per registrazione personaggio
  NAME_VALID = 0
  NAME_ALREADY_PRESENT = 1
  NAME_WORD_FORBIDDEN = 2
  SPECIAL_CHARACTER_NOT_ALLOWED = 3
  NAME_TOO_SHORT = 4
  CREATION_ERROR = 5
  NAME_INTERNAL_SERVER_ERROR = 6

  # Costanti per errori risultato operazioni
  PLAYER_UNREGISTERED = -1
  PLAYER_BANNED = -2
  SERVER_ERROR = 500
  UNPROCESSED = 2
  DATA_ERROR = 700
  NO_CONNECTION_ERROR = 600
  PLAYER_SAME = 6

  OPERATION_FAILED_ADVICES = {
    PLAYER_UNREGISTERED => "Sembra che ci siano problemi con l'autenticazione. Contatta il supporto.",
    PLAYER_BANNED => "Non ti è più concessa questa azione: accesso bloccato.",
    UNPROCESSED => "Non sono riuscito ad eseguire l'operazione. Per favore, riprova.",
    NO_CONNECTION_ERROR => "Non riesco a contattare il server. Controlla la connessione.",
    HTTP::HTTP_STATUS_SERVER_ERROR => "Errore del server. Per favore contatta il supporto tecnico.",
    HTTP::HTTP_STATUS_DENIED => "Operazione non permessa. Contatta il supporto tecnico.",
    HTTP::HTTP_STATUS_SERVICE_UNAVAIL => "Server in manutenzione. Prova più tardi.",
    DATA_ERROR => "Errore nella ricezione dei dati.",
    PLAYER_SAME => "Stai eseguendo l'operazione su te stesso.",
    CREATION_ERROR => "Errore di creazione record"
  }

  SERVER_STATUS_MESSAGES = {
    :down => "Non riesco a connettermi.\nControlla la tua connessione e rirpova.",
    :maintenance => "Mi spiace, ma al momento il server di\ngioco è in manutenzione. Riprova più tardi!",
    :unknown => "Ci sono dei problemi con la connessione al server.\nControlla la connessione e riprova!",
    :up => "Tutto ok, sei connesso!"
  }

  ONLINE_MODE_TERM = "Modalità di gioco"
  ONLINE_MODE_HELP = "Puoi scegliere se attivare o disattivare la modalità Online.|Se disattivata, tutte le funzionalità online verranno rimosse dal gioco."
  ONLINE_MODE_OFF = "Offline"
  ONLINE_MODE_ON = "Online"

  SHARE_PARTY_TERM = "Condividi Eroi"
  SHARE_PARTY_HELP = "Scegli se condividere le informazioni del tuo party con gli altri.|L'impostazione sarà resa effetiva solo dopo il salvataggio."
  SHARE_PARTY_ON = "Condividi"
  SHARE_PARTY_OFF = "Non condividere"

  # se true, il giocatore ha effettuato il login.
  @logged = false
  # se true, significa che il primo login è fallito. Evita di tentare ulteriori volte in modo
  # da non rallentare l'esperienza di gioco.
  @disconnected = false

  # Percorso directory contenenti le chiamate alle azioni
  def self.api_path
    HTTP.domain + (SUBPATH_API ? '/' + SUBPATH_API + '/' : '/')
  end

  # effettua il login al servizio
  # @param [Fixnum] retries numero di tentativi
  def self.login(retries = 3)
    operation = post :player, :login, $game_system.auth_params

    # ritenta se è una bad request (a volte capita)
    if !operation.success? and operation.error_code == HTTP::HTTP_STATUS_BAD_REQUEST and retries > 0
      Logger.warning("Login attempt failed. Retrying... #{4 - retries}")
      return login(retries - 1)
    end

    $game_system.banned = operation.error_code == PLAYER_BANNED
    @logged = operation.success?
    if @logged
      Logger.info("✅ ACCESSO EFFETTUATO")
    else
      Logger.info("⛔ ACCESSO NON RIUSCITO")
    end
    if !operation.success? and operation.error_code == NO_CONNECTION_ERROR
      @disconnected = true
    end
  end

  # effettua il logout uscendo dal gioco
  def self.logout
    HTTP.delete_cookie('PHPSESSID')
    @logged = false
  end

  def self.logged_in?
    @logged
  end

  def self.cannot_connect?
    @disconnected
  end

  # ottiene la risposta dal server di Overdrive indicando la risorsa ed
  # il metodo ed ottenendo la risposta sempre come formato JSON.
  # @param [Symbol] resource risorsa da maneggiare
  # @param [Symbol] action metodo da chiamare
  # @param [Hash] params parametri dell'operazione
  # @return [HTTP::Response]
  def self.get(resource, action, params = {})
    raise InternetConnectionException.new('Disconnected', NO_CONNECTION_ERROR) if @disconnected
    response = HTTP.get(api_path + "#{resource}/#{action}.json", params)
    Logger.info("📡", response.body) if $TEST
    code = response.code == 0 ? NO_CONNECTION_ERROR : response.code
    raise InternetConnectionException.new(response.body, code) unless response.ok?
    response
  end

  # carica dati sul server di Overdrive. Si assicura
  # di effettuare il login prima di fare la post.
  # @param [Symbol] resource
  # @param [Symbol] action
  # @param [Hash] params
  # @return [Online::Operation_Result]
  def self.upload(resource, action, params = {})
    login unless logged_in?
    post resource, action, params
  end

  # determina se la componente online è abilitata
  def self.enabled?
    $game_switches[Online::ACTIVATION_SWITCH]
  end

  def self.share_party?
    $game_switches[Online::SHARE_PARTY_SW]
  end

  # restituisce lo stato dei server
  # up: il server è online ed operativo
  # maintenance: il server è online, ma è disattivato per manutenzione
  # down: il server non è raggiungibile (connessione assente o server down)
  # @return [Symbol]
  def self.service_status
    begin
      response = get(:application, :status)
      return :up if response.ok? and response.decode_json == OK_RESPONSE
    rescue InternetConnectionException => e
      return :maintenance if e.code == HTTP::HTTP_STATUS_SERVICE_UNAVAIL
      return :down
    end
    :unknown
  end

  # determina se il nome è valido per la registrazione. Lancia ConnectionException
  # se non c'è connessione.
  # @param [String] name
  # @return [String]
  def self.check_name_valid(name)
    begin
      response = get :player, :check_name_valid, { :name => name }
      return Online::NO_CONNECTION_ERROR if response.code == 0
      return response.body.to_i
    rescue => error
      Logger.error(error.message)
      CREATION_ERROR
    end
  end

  # Registra il giocatore e restituisce un hash con questi attributi:
  # * status: true se registrato, false altrimenti
  # * motive: solo se status è false, il motivo del rifiuto
  # * message: solo se status è false, un messaggio aggiuntivo
  # * player_id: solo se status è true, l'ID del giocatore creato
  # Può lanciare InternetConnectionException se ci sono errori del server.
  # @param [String] name
  # @param [Integer] face
  # @return [Online::Operation_Result]
  def self.register_new_player(name, face, title = nil)
    return Operation_Result.from_code(HTTP::HTTP_STATUS_DENIED) if $game_system.user_registered?
    data = { :name => name, :face_id => face, :game_token => $game_system.game_token }
    data[:title_id] = title if title != nil
    data[:old_token] = $game_party.id_partita if $game_party.id_partita != nil
    post :player, :create, data
  end

  # Carica i progressi del giocatore sul server
  # @return [HTTP::Response]
  def self.update_player_data
    return unless $game_system.can_upload?
    upload :player, :update, get_play_data
  end

  # cambia il titolo del giocatore
  # @param [Integer] title_id
  # @return [Online::Operation_Result]
  def self.change_title(title_id)
    return unless $game_system.can_upload?
    params = { :title_id => title_id || 0 }
    upload :player, :update_title, params
  end

  # cambia l'avatar del giocatore
  # @param [Integer] avatar_id
  # @return [Online::Operation_Result]
  def self.change_avatar(avatar_id)
    return unless $game_system.can_upload?
    params = { :face_id => avatar_id }
    upload :player, :update_face, params
  end

  # invia la segnalazione di un messaggio anomalo
  def self.report_board_message(message_id, type)
    return unless $game_system.can_upload?
    params = { :message_id => message_id, :report_type => type }
    upload :feedback, :report_message, params
  end

  # ottiene i dati di gioco da caricare sul server
  # @return [Hash{Symbol->String or Fixnum}]
  def self.get_play_data
    data = {
      :level => $game_party.total_max_level, # <- livello più alto del gruppo
      :hours => $game_system.playtime / 60 / 60,
      :minutes => $game_system.playtime / 60 % 60,
      :story => $game_system.story_progress,
      :quests => $game_system.completed_quests, # <- dal nuovo quest system
      :exp => $game_actors[2].exp, # <- Exp di Monica
      :gold => $game_party.gold,
      :points => H87_Achievements.gained_points,
      :party => share_party? ? $game_party.base64_party : nil
    }
    data
  end

  def self.connection_error_description(status_code)
    HTTP::RESPONSE_CODE_DESCRIPTIONS[status_code]
  end

  private

  # effettua una POST sul server di Overdrive
  # @param [Symbol] resource
  # @param [Symbol] action
  # @param [Hash] params
  # @return [Online::Operation_Result]
  def self.post(resource, action, params)
    Logger.info("➡", params) if $TEST
    return Operation_Result.from_code(NO_CONNECTION_ERROR) if @disconnected
    response = HTTP.post(api_path + "#{resource}/#{action}.json", params)
    Logger.info("⬅", response.body) if $TEST
    code = response.code == 0 ? NO_CONNECTION_ERROR : response.code
    return Operation_Result.from_code(code) unless response.ok?
    Operation_Result.new(response.decode_json) rescue Operation_Result.from_code(DATA_ERROR)
  end
end

#===============================================================================
# ** Operation_Result
#-------------------------------------------------------------------------------
# Oggetto che contiene i risultati di un'operazione di Upload.
#===============================================================================
class Online::Operation_Result
  def initialize(data)
    raise ArgumentError.new("Missing Data") if data.nil?
    @data = data
  end

  def self.from_code(error_code)
    Online::Operation_Result.new({ 'status' => false, 'error_code' => error_code })
  end

  # true se l'operazione è andata a buon fine, false altrimenti
  # @return [Boolean]
  def status
    @data['status']
  end

  # un oggetto generico come risposta dall'operazione, se presente
  def result
    @data['result']
  end

  # il motivo per cui l'operazione è fallita come codice
  # d'errore
  # @return [Integer]
  def error_code
    @data['error_code'] || 0
  end

  # messaggio aggiuntivo del codice d'errore, se presente
  # @return [String]
  def message
    @data['message']
  end

  # @return [TrueClass, FalseClass]
  def success?
    status == true
  end

  # @return [TrueClass, FalseClass]
  def failed?
    !success?
  end

  # ottiene il messaggio di causa fallimento operazione da
  # mostrare al giocatore
  # @return [String]
  def failed_message
    Online::OPERATION_FAILED_ADVICES[@data['error_code'].to_i || "Errore sconosciuto (#{error_code})"]
  end
end

#===============================================================================
# ** HTTP::Response
#===============================================================================
class HTTP::Response

  # restituisce il body di risposta decodificato in JSON.
  def decode_json
    JSON.decode(self.body)
  end
end

#===============================================================================
# ** DateParser
# Include le funzioni di parse delle date, da includere nelle classi
#===============================================================================
module DateParser
  # @param [String] date_str
  def date_from_string(date_str)
    if date_str =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/
      Time.local($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
    end
  end

  # restituisce la data formattata come testo
  # @param [Time] date
  def formatted_date(date)
    return '' if date.nil?
    sprintf('%d/%d/%d alle %d:%d', date.day, date.month, date.year,
            date.hour, date.min)
  end
end

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# Stringhe necessarie al gioco
#===============================================================================
module Vocab
  def self.server_connection
    Online::SERVER_CONNECTION
  end

  def self.no_player
    Online::NO_PLAYER_VOCAB
  end

  def self.wrong_player_data
    Online::WRONG_DATA_VOCAB
  end

  def self.connection_error
    Online::CONN_ERROR_VOCAB
  end
end

class Scene_MenuBase
  # mostra una finestra di dialogo di connessione in corso mentre
  # scarica i dati dal server
  def await_server(message = Vocab.server_connection, &block)
    show_dialog_waiting(message, true)
    @error = nil
    Graphics.update
    Thread.new do
      begin
        block.call
      rescue => err
        Logger.error(err.class.to_s + ": " + err.message + "; " + err.backtrace[0])
        @error = err
      ensure
        close_dialog_window
      end
    end
    raise(@error) if @error != nil
  end
end

# Attivare o disattivare invio dati di gioco
H87Options.push_internet_option({
                                  :type => :switch,
                                  :text => Online::ONLINE_MODE_TERM,
                                  :help => Online::ONLINE_MODE_HELP,
                                  :on => Online::ONLINE_MODE_ON,
                                  :off => Online::ONLINE_MODE_OFF,
                                  :sw => Online::ACTIVATION_SWITCH
                                })

H87Options.push_internet_option({
                                  :type => :switch,
                                  :text => Online::SHARE_PARTY_TERM,
                                  :help => Online::SHARE_PARTY_HELP,
                                  :on => Online::SHARE_PARTY_ON,
                                  :off => Online::SHARE_PARTY_OFF,
                                  :sw => Online::SHARE_PARTY_SW,
                                  :default => true
                                })

# Attivare o disattivare popup messaggi sfera dimensionale
# H87Options.push_internet_option({
#                                     :type => :switch,
#                                     :text => 'Notifiche nuovi messaggi',
#                                     :help => 'Se questa funzione viene attivata, ti verrà mostrato un avviso quando|viene aggiunto un messaggio a una sfera su cui hai scritto di recente.',
#                                     :on => 'Notifica',
#                                     :off => 'Nascondi',
#                                     :default => true,
#                                     :sw => 579,
#                                     :condition => '$game_switches[426]'
#                                 })