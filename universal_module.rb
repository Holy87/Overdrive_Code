=begin
 ==============================================================================
  ■ Utility universali di Holy87
      versione 1.8.1
      Difficoltà utente: ★★★★★
      Licenza: CC-BY. Chiunque può scaricare, modificare, distribuire e utilizzare
      lo script nei propri progetti, sia amatoriali che commerciali. Vietata
      l'attribuzione impropria.

  ■ Questo modulo serve a espandere a nuovi livelli i vostri script e permetter-
    vi di creare feature nel vostro gioco prima impensabili, nel modo più
    semplice e immediato possibile. Cosa è possibile fare?
    ● Salvare delle variabili indipendenti dal salvataggio
    ● Ottenere informazioni dal sistema, quali la risoluzione dello schermo,
      la lingua del sistema, la versione di Windows, il nome utente, il
      percorso della cartella documenti ecc...
    ● Scaricare un file e/o inviare una richiesta ed ottenere risposta da un web
      server, anche in modo asincrono e nel modo più facile possibile
    ● Ottenere informazioni sulla versione del gioco o impostarla
    ● Codificare/decodificare una stringa in rot13 o Base64
    ● Altro ancora!
 ==============================================================================
  ■ Changelog
    ● V 1.8.0
      - Cambia i metodi to_s di Hash per mostrarli meglio su stampa
      - Ottiene informazioni sul mouse (posizione, click, visibilità...)
      - Supporto HTTPS per richieste web POST
      - HTTP.send_post_request DEPRECATO
      - await_response_async DEPRECATO
      - Nuovi metodi per richieste web:
        HTTP.get, HTTP.post, HTTP.put, HTTP.delete
        Queste restituiranno un oggetto Response (vedi documentazione sotto)
      - Metodo per donwload dei file migliorato
      - Aggiunta dei metodi minutes, hours e days negli integer (vedi esempi)
      - La versione del gioco può essere inserita nel file Game.ini
        invece che nel file dedicato Version.ini
      - Nuovo metodo per ottenere la lingua del sistema: Win.locale_name al posto
        di Win.language. A differenza di quest'ultimo, ora è possibile ottenere
        direttamente la descrizione della lingua corrente (es. en-US, it-IT ecc...)
      - Win.language DEPRECATO
      - Win.temp_flush DEPRECATO
      - Sistemazione e rifinitura del codice
      - Aggiunti i metodi on_vx_ace? e on_vx? che determinano su che versione
        di RPG Maker sta girando lo script.
      - Molti miglioramenti e correzioni.
    ● V 1.7.1
      - Bugfix
      - Win.get_folderPath deprecato. Al suo posto utilizzare il nuovo metodo
        Win.get_folder_path
      - Miglioramenti generali nel codice
    ● V 1.7.0
      - Possibilità di inviare richieste POST ad un servizio Web
      - Possibilità di leggere un testo copiato negli appunti
      - Possibilità di ottenere la bitmap dell'immagine del giorno di Bing
      - Aggiunta di correzioni e robustezza
    ● V 1.6.3
      - Bugfix e correzioni generali
    ● V 1.6.2
      - Aggiunti metodi di download asincroni anche in Game_Interpreter per
        avvio download da call script
    ● V 1.6.1
      - Bugfix che poteva mandare in crash il gioco se non si era connessi ad
        internet
    ● V 1.6.0
      - aggiunti metodi al kernel base64_encode e base64_decode
      - bugfix
    ● V 1.5.0
      - Puoi ottenere la lingua del sistema con Win.language
      - Aggiunta possibilità di codificare o decodificare una stringa in Base64
      - Puoi aggiungere in Game.ini la versione del gioco e richiamarla in
      - $game_system.game_version
      - aggiunti metodi asincroni per il download nelle finestre
    ● V 1.4.0
      - Possibilità di ottenere risposte da un sito web tramite GET
      - metodi asincroni per gestire i download (vedere la documentazione)
      - funzione per generare stringhe random di lunghezza arbitraria
      - funzione per codificare una stringa in ROT13
      - get_folderPath per ottenere i percorsi delle cartelle del PC
      - fix problemi di download su VX Ace

 ==============================================================================
  ■ Compatibilità
    DataManager -> alias load_normal_database, load_battle_test_database
    Scene_Base  -> alias update
    Window_Base -> alias update
 ==============================================================================
  ■ Installazione
    Installare questo script sotto Materials e prima del Main. Metterlo sopra a
    tutti gli altri script che fanno uso di questo modulo.
 ==============================================================================
  ■ Istruzioni
    Usare da script o da chiama evento le seguenti chiamate: quando vedi delle
    parentesi quadre [] a dei valori significa che è facoltativo.

  ▼ Valori universali di gioco
    L'oggetto $game_settings è una classe universale che salva e conserva un
    valore indipendentemente dal salvataggio. Può essere usato per memorizzare
    impostazioni nella schermata del titolo, sbloccare gli extra o gestire gli
    obiettivi, o qualsiasi cosa ti venga in mente.

    ● $game_settings[quellochevuoi] = ilvalorechevuoi
      memorizza il valore che vuoi, e viene automaticamente salvato nel file
      game_settings.rvdata, che si trova nella cartella del gioco. Il valore
      viene salvato anche se la partita non è stata salvata.

    ● $game_settings[quellochevuoi]
      restituisce il valore di quellochevuoi.

    ● Puoi impostare la versione del gioco creando un file nel progetto con il
      nome "version.ini", e all'interno scriverci la versione come 1.0.2.5
      Puoi richiamare la versione dal gioco da $game_system.game_version
      Es. versione = $game_system.game_version
      print versione.major => 1
      print versione.minor => 0
      print versione.build => 2
      print versione.revision => 5
      print versione => 1.0.2.5
      print versione > "1.0.1.7" => false

  ▼ Chiamate di sistema

    ● Win.version:
      restituisce un decimale con il numero di versione di Windows in uso.
        5.0 -> Windows 2000
        5.1 -> Windows Xp
        5.2 -> Windows Xp (64 bit)
        6.0 -> Windows Vista
        6.1 -> Windows 7
        6.2 -> Windows 8
        6.3 -> Windows 8.1
        10.0-> Windows 10

    ● Win.username
      Restituisce una stringa con nome utente di Windows attualmente in uso

    ● Win.homepath
      Restituisce il percorso utente del computer. Esempio:
      C:/Users/nomeutente/                      in Windows Vista e succ.
      C:/Documents and Settings/nomeutente      in Windows 2000 e Xp

    ● Win.get_folder_path([simbolo])
      Restituisce il percorso di una cartella definita dal simbolo:
        :docs -> cartella documenti dell'utente
        :imgs -> cartella immagini dell'utente
        :dskt -> destkop dell'utente
        :musc -> cartella musica dell'utente
        :vdeo -> cartella video dell'utente
        :prog -> cartella dei programmi installati (C:\Programmi (x86))
        * se non è definito un simbolo, viene preso :docs

    ● Win.shutdown[(mode)]
      Spegne il computer, a seconda di mode (se si omette è 0):
        0: spegnimento normale
        1: riavvio
        2: ibernazione

    ● Win.open(filepath)
      Apre una cartella o un file sul PC. Specificare il percorso in filepath
      Esempi:
        Win.open(C:/Windows/system32/calc.exe) avvierà la calcolatrice
        Win.open(Win.homepath+"/Desktop") aprirà la cartella del desktop

    ● Win.temp_flush(nomefile) - DEPRECATO
      elimina il file dai file temporanei di internet. Utilizzarlo prima di un
      download di un file che viene aggiornato molto spesso.

    ● Win.datenow[(partition)]
      Restituisce la data attuale in stringa in formato "gg/mm/aaaa". Se
      viene inserito partition come valore:
      0: restituisce il numero del giorno in intero
      1: restituisce il numero del mese attuale in intero
      2: restituisce il numero dell'anno attuale in intero

    ● Win.timenow[(partition)]
      Restituisce l'ora attuale in formato "hh:mm" (h 0~24)
      partition: 0 -> restituisce le ore in intero
      partition: 1 -> restituisce il minuto attuale 0~59
      partition: 2 -> restituisce i secondi 0~59

    ● Win.language
      Restituisce un codice con la lingua del sistema in uso. Per l'elenco delle
      lingue con i rispettivi codici vedere questo link:
      http://support.microsoft.com/kb/193080

    ● Win.screen_resolution
      restituisce un array di due interi contenenti la risoluzione in lunghezza
      e altezza dello schermo (es. [1024,730]). Ricordati che non restituisce
      la risoluzione completa, ma solo la parte di schermo utilizzabile (cioè
      quella non nascosta dalla barra delle applicazioni)

    ● Screen.resize(lunghezza, larghezza)
      ridimensiona la finestra di gioco. Ricordati che questa funzione non
      aumenta la risoluzione del gioco, ma stretcha l'immagine.

  ▼ Appunti
    ● Clipboard.read_text
      Restituisce una stringa di testo copiato dagli appunti (ad esempio,
      quando si fa copia da un testo selezionato)

  ▼ Funzioni per le stringhe

    ● String.random([n_caratteri])
      Restituisce una stringa casuale di n_caratteri. Se n_caratteri non è
      definito, la stringa sarà di 4.
      Esempi:
      print String.random     #=> ajpf
      print String.random(7)  #=> opetnpg

    ● crypt_rot13
      Cripta una stringa in rot13 in modo da essere illeggibile (sposta ogni
      carattere di 13 posti nell'alfabeto). Richiamare il metodo alla stringa
      crittografata per farla tornare normale. Esempi:
      print "Casa".crypt_rot13    #=> "Pnfn"
      print "Pnfn".crypt_rot13    #=> "Casa"

    ● Base64.encode(stringa) e Base64.decode(stringa)
      Restituisce una stringa in Base64 per l'interscambio di dati web
      Per ulteriori informazioni: http://it.wikipedia.org/wiki/Base64

    ● Integer #minutes, #hours, #days
      restituiscono minuti, giorni ed ore come numero di secondi. Esempio:
      5.minutes => 300 (300 secondi costituiscono 5 minuti)
      10.hours => 36000

  ▼ Internet e HTTP

    ----------------------------------------------------------------------------
    * Metodi semplificati per operazioni asincrone
    ----------------------------------------------------------------------------
    I metodi semplificati permettono una facile gestione dei download e delle
    risposte su internet in modo da usare meno codice possibile ed essere più
    efficienti. Questi metodi possono essere usati solo in una Scene, Window o
    nelle classi dove viene incluso il modulo Async_Downloads.

    ● send_post_request(url, parametri[, https])
      Invia una richiesta POST all'url indicato inviando i parametri e ne
      restituisce la risposta sottoforma di stringa.
      Esempio:
      parametri = {"user" => "Francesco", "password" => "banana"}
      print send_post_request(www.miosito.com/login.php, parametri)
      imposta https a true se si usufruisce di una connessione HTTPS

    ● download_async(url, metodo[, priorità, cartella])
      Avvia il download di un file da url. Lancia automaticamente il metodo
      nome_metodo quando il download è completato
      (il nome del metodo dev'essere passato come simbolo)
      Esempi:
      download_async("www.miosito.com/immagine.jpg", method(:carica_immagine))
      (bisogna anche definire il metodo carica_immagine)
      Il download del file è molto lento per non alterare la fluidità del gioco.
      Se vuoi velocizzare il download, metti true nel campo priorità.

    ● get_response_async(url, metodo, priorità)
      Avvia la ricezione della risposta dall'indirizzo dell'url, ed avvia il
      metodo definito da method_name nonappena la risposta è stata ricevuta.
      A differenza del precedente, il metodo da richiamare deve avere un
      parametro in ingresso, che è la stringa della risposta.
      All'interno dell'URL si possono anche inserire i parametri per una
      richiesta di tipo GET (ad esempio, login.php?user=francesco&password=banana)
      Purtroppo RPG Maker non gestisce correttamente il multithreading, quindi
      ci sarà sempre un blocco del gioco mentre invia la risposta, che dipende
      dalle prestazioni del server.

    ● abort_download(nomefile)
      Annulla il download di nomefile.

    ● download_status(filename)
      Restituisce un numero intero da 0 a 100 rappresentante lo stato di download.

    ----------------------------------------------------------------------------
    * Immagine del giorno di Bing
    ----------------------------------------------------------------------------
    Bing propone ogni giorno una nuova foto dal mondo. Puoi ottenere quest'im-
    magine dal modulo Cache:

    ● Cache.bing_daily
      ti restituirà una Bitmap pronta per l'utilizzo (restituisce nil se ci sono
      problemi di connessione)
      La risoluzione predefinita è 640x480, ma puoi ottenerne altre impostando
      la risoluzione nel secondo parametro:
      Cache.bing_daily('1920x1080')
      Non tutti i formati sono disponibili. Alcune delle risoluzioni sono:
        QVGA (320x240, 4:3)
        VGA (640x480, 4:3)
        SVGA (800x600, 4:3)
        XGA (1024x768, 4:3)
        WXGA (1280x720 o 1280x800, 16:9)
        HD768 (1366x768, 16:9)
        FULLHD (1920x1080,16:9)
        WUXGA (1920x1200, 16:10)
      Puoi anche selezionare la risoluzione da Resolution. esempio:
        Cache.bing_daily(Resolution::SVGA)
        Cache.bing_daily(Resolution::WXGA)

    ● Cache.bing_daily_copyright
      Puoi ottenere l'origine dell'immagine (soggetto, autore e copyright)
      Attenzione: da usare dopo aver preso l'immagine!

    ----------------------------------------------------------------------------
    * Metodi più complessi per la gestione completa dei download
    ----------------------------------------------------------------------------
    Questi metodi possono essere usati ovunque e permettono una gestione più
    complessa e funzionale dei download. Possono anche essere usati affiancati
    ai metodi più semplici.

    ● await_response(url)
      Avvia la ricezione della risposta e restituisce direttamente la stringa
      senza attesa. Può bloccare l'esecuzione del gioco per qualche secondo,
      perciò meglio metterlo durante caricamenti o cambi di schermata.
      Esempio:
      print await_response(www.miosito.com)
      Una cosa del genere stamperà tutto il codice HTML della pagina.

    ● HTTP.domain
      restituisce il dominio principale del tuo server (configura in basso).
      usalo nelle locazioni internet in modo da cambiare velocemente dominio

    ● HTTP.download(percorsofile[,destinazione[,bassa priorità]])
      Scarica il file dal percorso. Se il percorso di destinazione è omesso,
      verrà scaricato nella cartella del gioco (cioè "./") Esempio:
      HTTP.download("http://www.miosito.it/immagine.png","./Graphics/Pictures")
        scaricherà immagine.png nella cartella Graphics/Pictures del gioco.
      HTTP.download("http://www.miosito.it/immagine.png")
        scaricherà immagine.png nella cartella del gioco.
      HTTP.download(HTTP.domain+"/immagine.png", Win.getFolderPath(:dskt))
        scaricherà immagine.png da http://www.miosito.it sul desktop.
      Imposta true in bassa priorità per velocizzare il gioco durante il download
      (il download sarà più lento)

    ● HTTP.get_server_response(url, response_name)
      Ottiene la risposta o legge il contenuto di un indirizzo web e lo memorizza
      nel proprio contenitore. url è l'indirizzo, mentre response_name è un
      identificatore per ritrovarlo.

    ● HTTP.await_response(url)
      come await_response senza HTTP

    ● HTTP.response(response_name)
      Restituisce il testo letto da get_server_response. Usalo dopo aver
      prima controllato che il download sia stato effettuato

    ● HTTP.downloaded?(nomefile)
      Restituisce true se il file che si sta scaricando è stato scaricato
      completamente. Restituisce false se non è stato neanche iniziato o se è
      ancora in corso. Al posto di nomefile si può mettere il nome della risposta
      per controllare se è stata ricevuta quando si usa get_server_response e
      prima di utilizzare HTTP.response.

    ● HTTP.progress(nomefile)
      Restituisce la percentuale di scaricamento del file in un float compreso
      tra 0.0 e 100.0. Restituisce 0 se il download non è cominciato.

    ● HTTP.filesize(nomefile)
      restituisce la grandezza del file in bit: dividi per 8 per ottenere i byte.

    ● HTTP.sizeloaded(nomefile)
      restituisce il numero di bit scaricati del file: dividi per 8 per ottenere
      i byte.

    ● HTTP.time_passed(nomefile)
      restituisce il tempo in secondi del tempo che ha richiesto il download.
      Restituisce 0 se il download non è completato o non esiste.

    ● HTTP.downloads
      restituisce un hash contenente l'elenco dei download

    ● HTTP.completed
      restituisce il numero dei download completati

    ● HTTP.get_file_size(url)
      restituisce la grandezza del file senza scaricarlo

    ● HTTP.file_good?(nomefile)
      controlla se il file è stato scaricato correttamente

    ● Browser.open(url)
      apre il browser ad un sito scelto. Ricordati che se l'url è troppo grande,
      potrebbe non avviare il sito. In questo caso ti consiglio di usare tinyurl
      o goo.gl per rimpicciolire il link.
=end

#==============================================================================
module H87_ModConfig
  HTTPDOMAIN = 'http://miosito.com/' #dominio principale
  SETTINGNAME = 'game_settings.rvdata2' #file impostazioni universali
  VERSIONFILE = 'version.ini' #file versione di gioco
  PROCESSNAME = 'RGSS Player' #nome del processo
  RMUSERAGENT = 'RMVXA' #nome user agent per richieste POST
end

$imported = {} if $imported == nil
$imported['H87_UniversalModule'] = 1.8

#==============================================================================
# ** Win
#------------------------------------------------------------------------------
#  Questo modulo gestisce le chiamate di sistema e recupera informazioni sul
#  computer
#==============================================================================
module Win
  # HOW TO HANDLE WINDOWS DATA TYPES:
  # https://docs.microsoft.com/en-us/windows/win32/winprog/windows-data-types
  # | Type Name        | Data Type                      | pack-unpack character |
  # | BOOL             | 32-bit signed integer (0/1)    | l                     |
  # | BOOLEAN          | same as BYTE                   | C
  # | BYTE             | 8-bit unsigned char            | C                     |
  # | SHORT            | 16-bit integer                 | s                     |
  # | LONG             | 32-bit signed integer          | l                     |
  # | WORD             | 16-bit unsigned integer        | S                     |
  # | DWORD            | 32-bit unsigned integer        | L                     |
  # | UINT             | 32-bit unsigned integer        | L                     |
  # | WPARAM/UINT_PTR  | 32/64-bit unsigned int         | I_                    |
  # | LPARAM/LONG_PTR  | 32/64-bit signed Long          | l_                    |
  # | LPTSTR           | null-terminated string pointer | A*                    |
  # * note: Game.exe is 32-bit program, WPARAM and LPARAM are always 32-bit.


  # Win32APIs
  # noinspection RubyConstantNamingConvention
  GetUserName = Win32API.new('advapi32', 'GetUserName', 'PP', 'I')
  # noinspection RubyConstantNamingConvention
  GetEnvironmentVariable = Win32API.new('kernel32', 'GetEnvironmentVariable', 'PPL', 'L')
  # noinspection RubyConstantNamingConvention
  SHGetFolderPath = Win32API.new('shell32', 'SHGetFolderPath', 'LLLLP', 'L')
  # noinspection RubyConstantNamingConvention
  GetSystemMetrics = Win32API.new('user32', 'GetSystemMetrics', 'I', 'I')
  # noinspection RubyConstantNamingConvention
  GetVersionEx = Win32API.new('kernel32', 'GetVersionEx', 'P', 'I')
  # noinspection RubyConstantNamingConvention - deprecato
  GetUserDefaultLCID = Win32API.new('kernel32', 'GetUserDefaultLCID', [], 'I')
  # https://docs.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-getsystemdefaultlocalename
  GetSystemDefaultLocaleName = Win32API.new('kernel32', 'GetSystemDefaultLocaleName', 'PI', 'I')
  # noinspection RubyConstantNamingConvention
  GetWindowRect = Win32API.new('user32', 'GetWindowRect', 'PP', 'I')
  # https://docs.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-getlasterror
  GetLastError = Win32API.new('kernel32', 'GetLastError', '', 'I')

  # useful error codes
  ERROR_SUCCESS = 0
  ERROR_INVALID_FUNCTION = 1
  ERROR_FILE_NOT_FOUND = 2
  ERROR_PATH_NOT_FOUND = 3
  ERROR_TOO_MANY_OPEN_FILES = 4
  ERROR_ACCESS_DENIED = 5
  ERROR_INVALID_HANDLE = 6
  ERROR_NOT_ENOUGH_MEMORY = 8
  ERROR_OUTOFMEMORY = 14

  # Constants
  SM_CYFULLSCREEN = 17 # The height of the client area for a full-screen window
  #                      on the primary display monitor, in pixels
  SM_CXFULLSCREEN = 16 # The width of the client area for a full-screenwindow
  #                      on the primary display monitor, in pixels
  SM_CXHTHUMB = 10 # The width of the thumb box in a horizontal scroll bar
  SM_CYCAPTION = 4 # The height of a caption area, in pixels.
  SM_CXFIXEDFRAME = 7 # The thickness of the frame around the perimeter of a
  #                      window that has a caption but is not sizable
  SM_CYFIXEDFRAME = 8 # The width of the vertical border the perimeter of a
  #                      window that has a caption but is not sizable
  SM_CXSCREEN = 0 # The width of the screen of the primary display monitor

  # Default locale name length
  LOCALE_NAME_MAX_LENGTH = 85

  # Restituisce il nome utente di Windows
  # @return [String]
  def self.username
    name = ' ' * 128
    size = '128'
    GetUserName.call(name, size)
    username = name.unpack('A*')
    return username[0]
  end

  # Restituisce la cartella utente di Windows
  # @return [String]
  def self.homepath
    username = ' ' * 256 #userprofile
    GetEnvironmentVariable.call('userprofile', username, 256)
    username.unpack('A*')[0].gsub('\\', '/')
  end

  # Restituisce il percorso di una cartella del computer
  # @param [Symbol] symbol
  # @return [String]
  def self.get_folder_path(symbol = :docs)
    case symbol
    when :user
      index = 40
    when :docs, :documents
      index = 5
    when :imgs, :images, :pictures
      index = 39
    when :musc, :music
      index = 13
    when :vdeo, :video
      index = 14
    when :strp, :start_menu
      index = 2
    when :prog, :program_files
      index = 38
    when :appd, :app_data
      index = 28
    when :desktop
      index = 0
    when :favs, :favorites
      index = 6
    when :roaming
      index = 26
    else
      index = 0
    end
    path = "\0" * 128
    SHGetFolderPath.call(0, index, 0, 2, path)
    path.unpack('A*')[0].gsub('\\', '/')
  end

  # Returns the Vista+ saved games folder
  # @return [String]
  def self.saved_games_folder
    get_folder_path(:user) + '/Saved Games'
  end

  # Deprecated, left for compatibility
  # @param [Symbol] symbol
  # @return [String]
  # @deprecated
  def self.getFolderPath(symbol = :docs)
    get_folder_path(symbol)
  end

  # Restituisce la larghezza della cornice della finestra
  # @return [String]
  def self.window_frame_width
    GetSystemMetrics.call(SM_CXFIXEDFRAME)
  end

  # Restituisce l'altezza della barra del titolo
  # @return [String]
  def self.window_title_height
    GetSystemMetrics.call(SM_CYCAPTION)
  end

  # Elimina il file temporaneo per aggiornarlo prima di un download.
  #   inserire il nome del file.
  # @param [String] filename
  # @deprecated non viene più utilizzato
  def self.temp_flush(filename)
    if version < 6
      path = homepath + "/Impostazioni locali/Temporary Internet Files"
      unless File.directory?(path)
        path = homepath + "/Local Settings/Temporary Internet Files"
        return unless File.directory?(path)
      end
      fetch_folder_for_delete(path, filename)
    else
      path = homepath + '/AppData/Local/Microsoft/Windows/Temporary Internet Files/Content.IE5'
      unless File.directory?(path)
        path = homepath + '/AppData/Local/Microsoft/Windows/INetCache/IE'
      end
      return unless File.directory?(path)
      Dir.foreach(path) { |x| #per ogni file nel percorso
      next if x == "." or x == '..' #passa al prossimo se è ind.
      if File.directory?(path + "/" + x) #se il file è una cartella
        folder = path + "/" + x #entra nella cartella
        #noinspection Rails3Deprecated
        fetch_folder_for_delete(folder, filename)
      end
      }
    end
  end

  # Cerca nella cartella il file da cancellare
  #   path: directory
  #   nomefile: file da cancellare
  # @deprecated
  def self.fetch_folder_for_delete(path, nomefile)
    Dir.foreach(path) { |y| #per ogni file nella cartella
    next if File.directory?(path + '/' + y) #passa al prossimo se è una c.
                            #noinspection Rails3Deprecated
    if no_ext(nomefile) == y[0..no_ext(nomefile).size - 1] #se l'inizio del nome corrisp.
      begin
        File.delete(path + '/' + y) #eliminalo
      rescue
        next
      end
    end
    }
  end

  # Restituisce la versione di Windows in uso
  # @return [String]
  def self.version
    s = [20 + 128, 0, 0, 0, 0, ''].pack('LLLLLa128')
    GetVersionEx.call(s)
    a = s.unpack('LLLLLa128')
    indice = a[1].to_f
    dec = a[2].to_f / 10
    return indice + dec
  end

  # Restituisce il nome del file senza estensione.
  # @return [String]
  # @deprecated
  def self.no_ext(nomefile)
    nome = nomefile.split(".")
    return nome[0..nome.size - 2]
  end

  # Returns a rect containing the screen
  # @return [Rect]
  def self.screen
    width = GetSystemMetrics.call(SM_CXFULLSCREEN)
    height = GetSystemMetrics.call(SM_CYFULLSCREEN)
    Rect.new(0, 0, width, height)
  end

  # Restituisce un array di larghezza e altezza della parte utilizzabile dello
  #   schermo: non conta lo spazio della barra delle applicazioni.
  # @deprecated use Win::screen instead
  def self.screen_resolution
    x = GetSystemMetrics.call(SM_CXFULLSCREEN)
    y = GetSystemMetrics.call(SM_CYFULLSCREEN)
    return [x, y]
  end

  # returns the system locale name (ex. it-IT, en-US, ...)
  # @return [String]
  def self.locale_name
    buff = " " * LOCALE_NAME_MAX_LENGTH
    GetSystemDefaultLocaleName.call(buff, LOCALE_NAME_MAX_LENGTH)
    buff.unpack('A' * LOCALE_NAME_MAX_LENGTH).delete_if { |x| x == "" } * ''
  end

  # Restituisce un intero come codice della lingua del sistema
  # @deprecated use locale_name
  def self.language
    GetUserDefaultLCID.call
  end

  # Restituisce la data attuale
  def self.datenow(partition = -1)
    date = Time.now
    case partition
    when -1
      return sprintf('%d/%d/%d', date.day, date.month, date.year)
    when 0
      return date.day
    when 1
      return date.month
    when 2
      return date.year
    else
      return -1
    end
  end

  # Restituisce l'ora attuale
  def self.timenow(partition = -1)
    date = Time.now
    case partition
    when -1
      return sprintf('%d:%d', date.hour, date.min)
    when 0
      return date.hour
    when 1
      return date.min
    when 2
      return date.sec
    else
      return -1
    end
  end

  # arresta il computer in modalità diverse.
  def self.shutdown(mode = 0)
    string = 'system '
    case mode
    when 0
      string += '-s'
    when 1
      string += '-r'
    when 2
      string += '-h'
    else
      return -1
    end
    system(string)
  end

  # this method should be used within Win32 API functions that need HWND
  # parameters
  # @return [Integer]
  def self.current_window
    Screen::FindWindowEx.call(0, 0, H87_ModConfig::PROCESSNAME, nil)
  end

  # gets the system window rect.
  # @return [Rect]
  def self.get_window_rect
    w_rect = [0, 0, 0, 0].pack('l_l_l_l_')
    this_window = current_window
    GetWindowRect.call(this_window, w_rect)
    rect = w_rect.unpack('l_l_l_l_')
    Rect.new(rect[0], rect[1], rect[2] - rect[0], rect[3] - rect[1])
  end
end #win

#==============================================================================
# ** Clipboard
#------------------------------------------------------------------------------
#  This module handles the Windows clibpoard.
#==============================================================================
# noinspection ALL
module Clipboard
  # Clipboard types
  CF_TEXT = 1 #plain text
  CF_BITMAP = 2 #bitmap
  CF_METAFILEPICT = 3 #metafile
  CF_SYLK = 4 #symbolic link
  CF_DIF = 5 #data interchange format
  CF_TIFF = 6 #tiff text format
  CF_OEMTEXT = 7 #OEM text format. Not sure it's useful
  CF_DIB = 8 #Device Independent Bitmap Format

  # Windows APIs
  OpenClipboard = Win32API.new('user32', 'OpenClipboard', 'L', 'I')
  GetClipboardData = Win32API.new('user32', 'GetClipboardData', 'I', 'I')
  SetClipboardData = Win32API.new('user32', 'SetClipboardData', 'IP', 'p')
  CloseClipboard = Win32API.new('user32', 'CloseClipboard', 'V', 'I')
  GlobalLock = Win32API.new('kernel32', 'GlobalLock', 'L', 'L')
  GlobalUnlock = Win32API.new('kernel32', 'GlobalUnlock', 'L', '')
  GlobalSize = Win32API.new('kernel32', 'GlobalSize', 'L', 'L')
  MemCpy = Win32API.new('ntdll', 'memcpy', 'PPL', 'L')
  IsClipboardFormatAvailable = Win32API.new('user32', 'IsClipboardFormatAvailable', 'I', 'I')
  # Returns a copied text from Windows clipboard. Can raise an error.
  # @return [String]
  # @raise [ClipboardDataAccessException]
  def self.read_text
    return '' unless open
    begin
      if format_avaiable?(CF_TEXT)
        handle = get_clipboard_data(CF_TEXT)
        buff_size = data_size(handle)
        buffer = ' ' * (buff_size - 1)
        copy_memory(buffer, handle, buff_size)
        data = buffer.gsub('\0', '')
      else
        puts 'No text avaiable in clipboard'
        data = ''
      end
    rescue
      Logger.warning 'Read clipboard error!'
      data = ''
    ensure
      CloseClipboard.call
    end
    data
  end

  # Returns a copied text from Windows clipboard without exceptions.
  # @return [String]
  def self.read_text_safe
    read_text rescue ''
  end

  # Opens the clipboard
  # @return [Integer]
  def self.open
    OpenClipboard.call(0)
  end

  # Closes the clipboard
  def self.close
    CloseClipboard.call
  end

  # @param [Integer] format
  # @return [Integer]
  def self.format_avaiable?(type)
    IsClipboardFormatAvailable.call(type)
  end

  # @param [Object] handle
  # @return [Integer]
  def self.data_size(handle)
    GlobalSize.call(handle)
  end

  # @param [Integer] type
  # @return [Object]
  def self.get_clipboard_data(type)
    GetClipboardData.call(type)
  end

  # @param [String] data
  # @param [Object] handle
  # @param [Integer] size
  # @return [String]
  def self.copy_memory(data, handle, size)
    MemCpy.call(data, handle, size)
  end
end #clipboard

#==============================================================================
# ** Screen
#------------------------------------------------------------------------------
#  Questo modulo gestisce il ridimensionamento della finestra di gioco
#==============================================================================
module Screen
  MoveWindow = Win32API.new("user32", "MoveWindow", 'LIIIIL', 'L')
  FindWindowEx = Win32API.new("user32", "FindWindowEx", 'LLPP', 'I')

  # ridimensiona la finestra e la centra
  # @param[Integer] width nuova larghezza
  # @param[Integer] height nuova altezza
  def self.resize(width, height)
    this_window = FindWindowEx.call(0, 0, H87_ModConfig::PROCESSNAME, nil)
    res_x = Win.screen_resolution[0] #risoluzione x
    res_y = Win.screen_resolution[1] #risoluzione y
    width += Win.window_frame_width * 2
    height += Win.window_frame_width * 2 + Win.window_title_height
    new_x = [(res_x - width) / 2, 0].max #ottiene la nuova coordinata, ma non
    new_y = [(res_y - height) / 2, 0].max #fa passare oltre il bordo
    MoveWindow.call(this_window, new_x, new_y, width, height, 1)
  end
end #screen

#==============================================================================
# ** HTTP
#------------------------------------------------------------------------------
#  Questo modulo permette di interfacciarsi ad internet e gestire i download.
#  Ringraziamenti: Berka (il codice è ispirato al suo)
#==============================================================================
module HTTP
  # Connection types
  INTERNET_OPEN_TYPE_PRECONFIG = 0
  INTERNET_OPEN_TYPE_DIRECT = 1
  INTERNET_OPEN_TYPE_PROXY = 3


  # Internet service types
  INTERNET_SERVICE_URL = 0
  INTERNET_SERVICE_FTP = 1
  INTERNET_SERVICE_GOPHER = 2
  INTERNET_SERVICE_HTTP = 3

  # Internet ports
  INTERNET_INVALID_PORT_NUMBER = 0
  INTERNET_DEFAULT_FTP_PORT = 21
  INTERNET_DEFAULT_GOPHER_PORT = 70
  INTERNET_DEFAULT_HTTP_PORT = 80
  INTERNET_DEFAULT_HTTPS_PORT = 443
  INTERNET_DEFAULT_SOCKS_PORT = 1080

  # Internet flags

  # Makes only asynchronous requests on handles descended from the
  # handle returned from this function
  INTERNET_FLAG_ASYNC = 0

  # Forces a download of the requested file, object, or directory listing
  # from the origin server, not from the cache. The FtpFindFirstFile,
  # FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl
  # functions use this flag.
  INTERNET_FLAG_RELOAD = 0x80000000
  INTERNET_FLAG_NO_CACHE_WRITE = 0x04000000

  # Returns the data as a WIN32_FIND_DATA structure when retrieving
  # FTP directory information. If this flag is not specified or if the call is made
  # through a CERN proxy, InternetOpenUrl returns the HTML version of the directory.
  # Only the InternetOpenUrl function uses this flag.
  INTERNET_FLAG_RAW_DATA = 1073741824

  # Uses secure transaction semantics.
  # This translates to using Secure Sockets Layer/Private Communications Technology
  # (SSL/PCT) and is only meaningful in HTTP requests.
  # This flag is used by HttpOpenRequest and InternetOpenUrl, but this is redundant
  # if https:// appears in the URL.The InternetConnect function uses this flag for
  # HTTP connections; all the request handles created under this connection will
  # inherit this flag.
  INTERNET_FLAG_SECURE = 0x00800000

  # Transfers file as ASCII (FTP only).
  # This flag can be used by FtpOpenFile, FtpGetFile, and FtpPutFile.
  INTERNET_FLAG_TRANSFER_ASCII = 0x00000001

  # Transfers file as binary (FTP only).
  # This flag can be used by FtpOpenFile, FtpGetFile, and FtpPutFile.
  INTERNET_FLAG_TRANSFER_BINARY = 0x00000002

  # Indicates that no callbacks should be made for that API.
  # This is used for the dxContext parameter of the functions that allow asynchronous operations.
  INTERNET_NO_CALLBACK = 0x00000000

  # Attempts to use an existing InternetConnect object if one exists with the same attributes
  # required to make the request. This is useful only with FTP operations, since FTP is the
  # only protocol that typically performs multiple operations during the same session. WinINet
  # caches a single connection handle for each HINTERNET handle generated by InternetOpen.
  # The InternetOpenUrl and InternetConnect functions use this flag for Http and Ftp connections.
  INTERNET_FLAG_EXISTING_CONNECT = 0x20000000

  # Does not add the returned entity to the cache.
  # This is identical to the preferred value, INTERNET_FLAG_NO_CACHE_WRITE.
  INTERNET_FLAG_DONT_CACHE = 0x04000000

  # Indicates that this is a Forms submission.
  INTERNET_FLAG_FORMS_SUBMIT = 0x00000040

  # Does not make network requests. All entities are returned from the cache.
  # If the requested item is not in the cache, a suitable error, such as
  # ERROR_FILE_NOT_FOUND, is returned. Only the InternetOpen function uses this flag.
  INTERNET_FLAG_FROM_CACHE = 0x01000000

  # Disables detection of this special type of redirect. When this flag is used,
  # WinINet transparently allows redirects from HTTPS to HTTP URLs.
  # This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
  INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP = 0x00008000

  # Disables detection of this special type of redirect. When this flag is used,
  # WinINet transparently allow redirects from HTTP to HTTPS URLs.
  # This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
  INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS = 0x00004000

  # Uses keep-alive semantics, if available, for the connection.
  # This flag is used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
  # This flag is required for Microsoft Network (MSN), NTLM, and other types of
  # authentication.
  INTERNET_FLAG_KEEP_CONNECTION = 0x00400000

  # QUERY INFO FLAGS

  # Retrieves the acceptable media types for the response.
  HTTP_QUERY_ACCEPT = 24

  # Retrieves the acceptable character sets for the response.
  HTTP_QUERY_ACCEPT_CHARSET = 25

  # Retrieves the acceptable content-coding values for the response.
  HTTP_QUERY_ACCEPT_ENCODING = 26

  # Retrieves the cache control directives.
  HTTP_QUERY_CACHE_CONTROL = 49

  # Retrieves the size of the resource, in bytes.
  HTTP_QUERY_CONTENT_LENGTH = 5

  # Retrieves an MD5 digest of the entity-body for the purpose of providing
  # an end-to-end message integrity check (MIC) for the entity-body.
  # For more information, see RFC1864, The Content-MD5 Header Field,
  # at https://ftp.isi.edu/in-notes/rfc1864.txt.
  HTTP_QUERY_CONTENT_MD5 = 52

  # Receives the content type of the resource (such as text/html).
  HTTP_QUERY_CONTENT_TYPE = 1

  # Retrieves any cookies associated with the request.
  HTTP_QUERY_COOKIE = 44

  # Receives the status code returned by the server.
  # For more information and a list of possible values, see HTTP Status Codes.
  HTTP_QUERY_STATUS_CODE = 19


  # HTTP Status Codes

  # The request can be continued.
  HTTP_STATUS_CONTINUE = 100

  # The request completed successfully.
  HTTP_STATUS_OK = 200

  # The request has been fulfilled and resulted in the creation of a new resource.
  HTTP_STATUS_CREATED = 201

  # The request has been accepted for processing,
  # but the processing has not been completed
  HTTP_STATUS_ACCEPTED = 202

  # The requested resource has been assigned to a new permanent URI
  # (Uniform Resource Identifier), and any future references to this resource
  # should be done using one of the returned URIs.
  HTTP_STATUS_MOVED = 301

  # The requested resource resides temporarily under a different URI
  # (Uniform Resource Identifier).
  HTTP_STATUS_REDIRECT = 302

  # The request could not be processed by the server due to invalid syntax.
  HTTP_STATUS_BAD_REQUEST = 400

  # The requested resource requires user authentication.
  HTTP_STATUS_DENIED = 401

  # The server understood the request, but is refusing to fulfill it.
  HTTP_STATUS_FORBIDDEN = 403

  # The server has not found anything matching the requested
  # URI (Uniform Resource Identifier).
  HTTP_STATUS_NOT_FOUND = 404

  # The HTTP verb used is not allowed.
  HTTP_STATUS_BAD_METHOD = 405

  # The server timed out waiting for the request.
  HTTP_STATUS_REQUEST_TIMEOUT = 408

  # The server encountered an unexpected condition that prevented it from fulfilling the request.
  HTTP_STATUS_SERVER_ERROR = 500

  # The server does not support the functionality required to fulfill the request.
  HTTP_STATUS_NOT_SUPPORTED = 501

  # The server, while acting as a gateway or proxy, received an invalid response
  # from the upstream server it accessed in attempting to fulfill the request.
  HTTP_STATUS_BAD_GATEWAY = 502

  # The service is temporarily overloaded.
  HTTP_STATUS_SERVICE_UNAVAIL = 503

  RESPONSE_CODE_DESCRIPTIONS = {
      0 => 'HOST UNREACHABLE',
      HTTP_STATUS_OK => 'OK',
      HTTP_STATUS_BAD_REQUEST => 'BAD REQUEST',
      HTTP_STATUS_BAD_GATEWAY => 'BAD GATEWAY',
      HTTP_STATUS_MOVED => 'MOVED',
      HTTP_STATUS_REDIRECT => 'REDIRECTED',
      HTTP_STATUS_FORBIDDEN => 'FORBIDDEN',
      HTTP_STATUS_BAD_METHOD => 'BAD METHOD',
      HTTP_STATUS_NOT_FOUND => 'NOT FOUND',
      HTTP_STATUS_SERVER_ERROR => 'INTERNAL SERVER ERROR',
      HTTP_STATUS_SERVICE_UNAVAIL => 'SERVICE UNAVAILABLE',
      HTTP_STATUS_REQUEST_TIMEOUT => 'REQUEST TIMEOUT',
      HTTP_STATUS_BAD_GATEWAY => 'BAD GATEWAY'
  }


  #API Calls
  #SetPrClass = Win32API.new('kernel32','SetPriorityClass','pi','i').call(-1,128)
  InternetOpenA = Win32API.new("wininet", 'InternetOpenA', 'plppl', 'l').call(
      H87_ModConfig::RMUSERAGENT, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, INTERNET_FLAG_ASYNC)
  InternetConnectA = Win32API.new("wininet", 'InternetConnectA', 'lplpplll', 'l')
  InternetOpenUrl = Win32API.new("wininet", 'InternetOpenUrl', 'lppllp', 'l')
  InternetReadFile = Win32API.new("wininet", 'InternetReadFile', 'lpip', 'l')
  InternetCloseHandle = Win32API.new('wininet', 'InternetCloseHandle', 'l', 'l')
  HttpQueryInfo = Win32API.new('wininet', 'HttpQueryInfo', 'LLPPP', 'I')
  HttpOpenRequest = Win32API.new('wininet', 'HttpOpenRequestA', 'pppppplp', 'l')
  HttpSendRequest = Win32API.new('wininet', 'HttpSendRequestA', 'PPLPL', 'L')

  # launches an HTTP GET request
  # @param [String] url
  # @param [Hash] params
  # @return [Response]
  def self.get(url, params = {}, secure = false)
    url += '?' + prepare_request(params) if params.size > 0
    send_request url, :get, {}, secure
  end

  # launches an HTTP POST request
  # @param [String] url
  # @param [Hash] params
  # @return [Response]
  def self.post(url, params, secure = false)
    send_request url, :post, params, secure
  end

  # launches an HTTP PUT request
  # @param [String] url
  # @param [Hash] params
  # @return [Response]
  def self.put(url, params, secure = false)
    send_request url, :put, params, secure
  end

  # launch an HTTP DELETE request
  # @param [String] url
  # @param [Hash] params
  # @return [Response]
  def self.delete(url, params, secure = false)
    send_request url, :delete, params, secure
  end

  # saves a file async and returns the data request.
  # Use
  # @return [HTTP::Request]
  # @param [String] url
  # @param [String] save_path
  # @param [String] filename
  # @param [Method] callback
  def self.download(url, save_path = './', filename = nil, callback = nil, secure = false)
    request = Request.new(url, filename)
    filename = url_info(url) if filename.nil?
    @http_requests ||= {}
    @completed ||= []
    @http_requests[filename] = request
    @completed[filename] = false
    request.uri = url
    request.thread = Thread.start(request, url, save_path, filename, secure) do |request, url, save_path, filename, secure|
      open_resource(request, url, [INTERNET_FLAG_RELOAD], secure)
      if request.response.ok?
        save_file(save_path, filename, request.response.body)
      end
      @http_requests.delete[filename]
      @completed[filename] = true
    end
    request
  end


  # @return [HTTP::Request]
  # @param [String] url
  # @param [Method] callback
  # @param [Boolean] secure
  def self.read_async(url, callback = nil, secure = false)
    request = Request.new(url)
    @http_requests ||= {}
    @completed ||= []
    @http_requests[url] = request
    @completed[url] = false
    request.uri = url
    request.thread = Thread.start(request, url, secure) do |request, url, secure|
      open_resource(request, url, [INTERNET_FLAG_RELOAD], secure)
      @http_requests.delete[url]
      @completed[url] = true
    end
    request
  end

  # launches a request with more options
  # @param [String] url
  # @param [Symbol, String] method
  # @param [Hash] params
  # @param [Array<Integer>] flags
  # @return [Response]
  def self.send_request(request, method = :get, params = {}, force_https = false, flags = [INTERNET_FLAG_RELOAD])
    url = request.uri
    Logger.info sprintf('%s -> %s', method.to_s.upcase, url)
    force_https = true if url =~ /^https:\/\//
    info = url_info(url)
    server = info[:server]
    root = info[:root]
    accept = '*/*'
    headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'
    port = force_https ? INTERNET_DEFAULT_HTTPS_PORT : INTERNET_DEFAULT_HTTP_PORT
    service = INTERNET_SERVICE_HTTP
    request = prepare_request(params)
    flags.push(INTERNET_FLAG_SECURE) if force_https
    opts = flags.uniq.inject(0) { |o, flag| o | flag }
    response = Response.new

    session = InternetConnectA.call(InternetOpenA, server, port, nil, nil, service, 0, 1)

    if session.nil?
      response.code = Win::GetLastError.call
      response.body = "Error while connecting to the server (code: #{response.code})"
      Logger.info response.description
      return response
    end

    h_file = HttpOpenRequest.call(session, method.to_s.upcase, root, nil, nil, accept, opts, 0)

    if HttpSendRequest.call(h_file, headers, headers.size, request, request.size)
      response.code = status_code h_file
      response.size = content_size h_file
      response.body = internet_read_file h_file
    else
      response.code = Win::GetLastError.call
      response.body = "Error while sending request (code: #{response.code})."
    end
    InternetCloseHandle.call(h_file)
    Logger.info response.description
    response
  end

  # reads a resource from the web using HTTP protocol
  # @return [HTTP::Response]
  # @param [HTTP::Request] ref
  # @param [String] url
  # @param [Array<Integer>] flags
  def self.open_resource(ref, url, flags = [], force_https = false)
    force_https = true if url =~ /^https:\/\//
    info = url_info(url)
    server = info[:server]
    headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'
    url += '?' + prepare_request(params)
    port = force_https ? INTERNET_DEFAULT_HTTPS_PORT : INTERNET_DEFAULT_HTTP_PORT
    service = INTERNET_SERVICE_HTTP
    flags.push(INTERNET_FLAG_SECURE) if force_https
    opts = flags.uniq.inject(0) { |o, flag| o | flag }
    response = ref.response

    connection = InternetConnectA.call(InternetOpenA, server, port, '', '', service,
                                       INTERNET_FLAG_TRANSFER_ASCII, 0)

    if connection.nil?
      Logger.error 'Error while connecting to the server.'
      raise InternetConnectionException.new 'Error while connecting to the server.'
    end

    file = InternetOpenUrl.call(InternetOpenA, url, headers, headers.size, opts, nil)
    response.code = status_code file
    response.size = content_size file
    response.body = internet_read_file file, ref
    InternetCloseHandle.call(file)
    response
  end

  def self.requests
    @http_requests ||= {}
  end

  # Sends a post-type request.
  # @param [String] url
  # @param [Hash] params
  # @param [Integer] method
  # @return [String]
  # @deprecated use HTTP::post instead
  def self.send_post_request(url, params = {}, force_https = false)
    send_request(url, :post, params, force_https).body
  end

  # Gets the url info
  # @param [String] uri
  # @return [Hash]
  def self.url_info(uri)
    address = uri.gsub(/^http[s]?:\/\//i, '').split('/')
    {
        server: address[0],
        root: address.size > 1 ? address[1..address.size].join('/') : address[0],
        filename: address[-1],

    }
  end

  # Gets the request string
  # @param [Hash] request_array
  # @return [String]
  def self.prepare_request(request_array)
    array = []
    request_array.each_pair { |key, value|
      array.push(sprintf('%s=%s', key.to_s, value.to_s.gsub(' ', '+')))
    }
    array * '&'
  end

  def self.save_file(folder, filename, data)
    if File.directory?(folder)
      obj = File.open(folder + filename, 'wb') << data
      obj.close #chiusura del file
    else
      string = '%s is not a valid folder, so %s will not be saved.'
      Logger.warning sprintf(string, folder, filename)
    end
  end


  # @param [Object] h_file
  # @param [String] read buffer
  # @param [Integer] buffer_size
  # @return [String]
  def self.internet_read_file(h_file, response = '', buffer_size = 1024)
    loop do
      lp_buffer = ' ' * buffer_size
      bytes_read = [0].pack('i!')
      read_ok = InternetReadFile.call(h_file, lp_buffer, buffer_size, bytes_read)
      read_size = bytes_read.unpack('i!')[0]
      response << lp_buffer[0, read_size]
      break if read_ok and read_size == 0 or read_size == "NaN"
    end
    response
  end

  # gets some (int) info from web resource
  # @param [Object] file the header file
  # @param [Integer] info_code the info code (see query constants)
  # @return [Integer]
  def self.http_query_info(file, info_code)
    buffer = "\0" * 128
    buffer_length = [buffer.size - 1].pack('l')
    status = HttpQueryInfo.call(file, info_code, buffer, buffer_length, nil)
    raise InternetConnectionException.new('Failed to receive the data') unless status
    buffer.delete!("\0").to_i
  end

  # gets the status code (200 OK, 500 Server error, 404...)
  # @return [Integer]
  def self.status_code(file)
    http_query_info file, HTTP_QUERY_STATUS_CODE
  end

  # gets the resource download size
  # @return [Integer]
  def self.content_size(file)
    http_query_info file, HTTP_QUERY_CONTENT_LENGTH
  end

  # Ottiene la dimensione di un file remoto in modo asincrono
  def self.get_file_size_async(url)
    @filesize = {} if @filesize.nil?
    Thread.start(url) { |url|
      @filesize[url] = get_file_size(url)
    }
  end

  # Restituisce true se la dimensione del file è stata ottenuta
  def self.size_get?(url)
    return false if @filesize.nil?
    return @filesize[url] != nil?
  end

  # Ottiene la dimensione di un file remoto
  def self.get_file_size(url)
    file = InternetOpenUrl.call(InternetOpenA, url, nil, 0, 0, 0)
    size = content_size file
    InternetCloseHandle.call(file)
    size
  end

  # Ottiene la risposta del server e la piazza nell'array delle rispose
  #   url: indirizzo della richiesta
  #   response_name: nome della risposta (per poterla leggere)
  #   low_priority: priorità (false se normale, true se bassa)
  # @deprecated utilizza HTTP::read_async
  #noinspection RubyUnusedLocalVariable
  def self.get_server_response(url, _response_name, _low_priority = false)
    get(url)
  end

  # Restituisce direttamente il testo di risposta dal server, interrompendo
  #   l'esecuzione del gioco fino a quando non arriva la risposta.
  #   url: indirizzo della richiesta
  # @deprecated utilizza HTTP.get
  def self.await_get_server_response(url)
    get(url).body
  end

  class << self
    alias await_response await_get_server_response
  end
  # Restituisce true se il file è scaricato.
  # filename: nome del file
  def self.downloaded?(filename)
    return false if @received.nil?
    return false if @received[filename].nil?
    return false if @size[filename].nil?
    return true if @received[filename] >= @size[filename]
    return true if progress(filename) >= 100
    return true if progress(filename).to_s == "NaN"
    return true if @completed[filename]
    false
  end

  # Restituisce la grandezza del file da scaricare in byte
  # filename: nome del file
  def self.filesize(filename)
    return 0 if @size.nil?
    return 0 if @size[filename].nil?
    return @size[filename]
  end

  # Restituisce la quantità di byte scaricati
  # filename: nome del file
  # @deprecated usa il parametro dalla request restituita
  def self.sizeloaded(filename)
    requests[filename]
    #TODO: Continuare
  end

  # Restituisce la percentuale di progresso del download
  # filename: nome del file
  def self.progress(filename)
    @received = {} if @received.nil?
    return 0 if @received[filename].nil?
    return @received[filename].to_f / @size[filename] * 100
  end

  # Restituisce l'hash dei download
  def downloads
    return {} if @downloads.nil?
    @downloads
  end

  # Restituisce il numero di secondi che ci sono voluti per scaricare
  def self.time_passed(filename)
    return 0 if @timepassed[filename] == nil
    return @timepassed[filename]
  end

  # Restituisce il numero dei download completati
  def self.completed
    return 0 if @downloaded.nil?
    return @downloaded
  end

  # Restituisce la risposta dal server
  #   response_name: id della risposta
  def self.response(response_name)
    return 0 if @message.nil? || @message[response_name].nil?
    return @message[response_name]
  end

  # Restituisce i download
  def self.downloads
    @downloads ||= {}
    return @downloads
  end

  # Restituisce il dominio principale
  def self.domain
    H87_ModConfig::HTTPDOMAIN
  end

  # Controlla se il file scaricato è buono e restituisce true o false
  def self.file_good?(filename)
    if File.exist?(filename) #apre il file in sola lett.
      File.open(filename, "r") do |f|
        f.lineno = 1 # imposta la riga n.1
        txt = f.gets
        return check_response(txt)
      end
    else
      return false
    end
  end

  # Restituisce true se il testo non è vuoto
  def self.check_response(text)
    return false if text == "" or text.nil?
    first = text[0].chr
    return false if first == "" or first == nil
    return true
  end


  class Response
    attr_accessor :code
    attr_accessor :head
    # @return [String]
    attr_accessor :body
    attr_accessor :size

    def initialize
      @code = 0
      @head = ''
      @body = ''
      @size = 0
    end

    def ok?
      @code | HTTP_STATUS_OK == @code
    end

    def progress
      @body.size.to_f / @size.to_f
    end

    # the response code
    # @return [Integer]
    def code
      @code.to_i
    end

    def json?
      return false if @body.nil?
      return false if @body.empty?
      #noinspection RegExpRedundantEscape
      @body =~ /^(\{.+\}|\[.*\])$/smi
    end

    # @return [String]
    def description
      description = RESPONSE_CODE_DESCRIPTIONS[@code] || ''
      sprintf('%d %s', @code, description)
    end

    def to_s
      @body
    end
  end


  class Request
    attr_accessor :state
    # @return [String]
    attr_accessor :uri
    # @return [Thread]
    attr_accessor :thread
    # @return [HTTP::Response]
    attr_accessor :response
    # @return [Method] the callback method when the resource is ready
    attr_accessor :callback_method
    # @return [String] the filename
    attr_accessor :filename


    def initialize(uri, filename = nil)
      @uri = uri
      @thread = nil
      @state = :ready
      @byte_downloaded = 0
      @response = HTTP::Response.new
      @filename = filename || HTTP.url_info(uri)[:filename]
    end
  end
end

#==============================================================================
# ** Async_Downloads
#------------------------------------------------------------------------------
#  Dev'essere incluso nelle classi che fanno uso dei metodi download_async.
#==============================================================================
module Async_Downloads
  # Scarica un file in modo asincrono lanciando automaticamente il metodo.
  #   url:          indirizzo del file
  #   method_name:  nome del metodo, in simbolo (ad es. :apri)
  #   low:          true se è a bassa incidenza, false altrimenti
  #   folder:       percorso del file di salvataggio
  def download_async(url, method, folder = "./", https = true)
    filename = url.split('/')[-1]
    if filename.downcase.include? ".php"
      puts "Questo URL chiama un file PHP, pertanto non verrà salvato."
      puts "Utilizzare invece il metodo get_repsonse_async."
      return
    end
    @async_downloads = {} if @async_downloads.nil?
    @async_downloads[filename] = method
    HTTP.download(url, folder, nil, https)
  end

  # @return [Hash{Symbol->HTTP::Request}]
  def async_downloads
    @async_downloads = {}
  end

  # Restituisce direttamente la stringa di risposta dal server
  #   url: indirizzo della richiesta
  # @param [String] url
  # @return [String]
  # @raise [InternetConnectionException]
  def await_response(url)
    HTTP.get(url).body
  end

  # Controlla i download e lancia il metodo associato se completato.
  def check_async_downloads
    return if @async_downloads.nil? || @async_downloads.size == 0
    @async_downloads.each_key do |key|
      if HTTP.downloaded?(key)
        @async_downloads[key].call
        @async_downloads.delete(key)
      end
    end
  end

  # Controlla le risposte e lancia il metodo associato quando ricevuta.
  def check_async_requests
    return if @async_responses.nil? || @async_responses.size == 0
    @async_responses.each_key do |key|
      if HTTP.downloaded?(key) && HTTP.response(key) != nil
        @async_responses[key].call(HTTP.response(key))
        @async_responses.delete(key)
      end
    end
  end

  # Cancella un download o l'attesa di una risposta
  #   filename: nome del file o id della risposta
  def abort_download(filename)
    Thread.kill(HTTP.downloads[filename])
  end

  # Restituisce la percentuale di download da 0 a 100
  #   filename: nome del file
  # @param [String] filename
  # @return [Integer]
  def download_status(filename)
    status = HTTP.progress(filename)
    [[0, status].max, 100].min.to_i
  end
end

#==============================================================================
# ** Modulo Browser per aprire il browser predefinito del PC
#==============================================================================
module Browser
  # apre il browser
  #   url: url impostato
  # @param [String] url
  def self.open(url, avoid_protocol = false)
    #controlla che ci siano prefissi
    if url[0..6] != 'http://' and url[0..7] != 'https://' and !avoid_protocol
      open_url = 'http://' + url
    else
      open_url = url
    end
    shell = Win32API.new('Shell32', 'ShellExecute', %w(L P P P P L), 'L')
    Thread.new { shell.call(0, 'open', open_url, 0, 0, 1) }
    sleep(0.01)
    SceneManager.exit
  end
end #browser

#==============================================================================
# ** Mouse
#==============================================================================
module Mouse
  CURRPOS = Win32API.new('User32', 'GetCursorPos', 'P', 'I')
  # gets the current cursor position
  # @return [MousePoint]
  def self.cursor_position
    lpoint = [0, 0].pack('l_l_')
    result = CURRPOS.call(lpoint)
    if result > 0
      ary = lpoint.unpack('l_l_')
      MousePoint.new(ary[0], ary[1])
    else
      raise GetMousePosException.new('Error occurred when obtaining cursor position')
    end
  end
end

#==============================================================================
# ** MousePoint
# noinspection RubyInstanceVariableNamingConvention
#==============================================================================
class MousePoint
  # @attr[Fixnum] x
  # @attr[Fixnum] y
  attr_accessor :x
  attr_accessor :y
  # object initialization
  # @param [Fixnum] x
  # @param [Fixnum] y
  def initialize(x, y)
    @x = x
    @y = y
  end
end

#==============================================================================
# ** Modulo Browser per la codifica/decodifica di stringhe in Base64
#==============================================================================
module Base64
  # Restituisce una stringa decodificata da Base64
  #     string: stringa da decodificare
  # @param [String] string
  # @return [String]
  def self.decode(string)
    string.gsub(/\s+/, '').unpack('m')[0]
  end

  # Restituisce una stringa codificata in Base64
  #     string: stringa da codificare
  # @param [String] string
  # @return [String]
  def self.encode(string)
    [string].pack("m")
  end
end #base64

#==============================================================================
# ** Classe Settings (per le impostazioni comuni ai salvataggi)
#==============================================================================
class H87_Settings
  # @return [Hash]
  attr_accessor :settings

  # restituisce l'elemento corrispondente al parametro
  # @param [Object] param
  # @return [Object]
  def [](param)
    @settings ||= {}
    @settings[param]
  end

  # inizializzazione
  def initialize
    @settings = {}
  end

  # cambia o aggiunge un elemento dell'hash
  def []=(param_name, value)
    @settings[param_name] = value
    save
  end

  # Registra i dati salvati
  def save
    save_data($game_settings, DataManager.settings_path)
  end
end

#settings

#==============================================================================
# ** Game_Version
#------------------------------------------------------------------------------
# Questa classe è d'appoggio per gestire la versione del gioco.
#==============================================================================
class Game_Version
  include Comparable #per la verifica delle versioni se maggiore o minore
  attr_accessor :major #numero di major release
  attr_accessor :minor #numero di minor release
  attr_accessor :build #numero di versione build
  attr_accessor :revision #numero di revisione
  # Inizializzazione
  #     version_string: versione in stringa (ad es. 1.5.3.1)
  # @param [String] version_string
  # @param [Integer] starting_major
  def initialize(version_string, starting_major = 1)
    @major = starting_major
    @minor = 0
    @build = 0
    @revision = 0
    version_string.gsub!(/\s\n\r/, '')
    return unless version_string =~ /[\d]+([.[\d]]*)/
    version_string = version_string.split('.')
    @major = version_string[0].to_i
    return if version_string[1].nil?
    @minor = version_string[1].to_i
    return if version_string[2].nil?
    @build = version_string[2].to_i
    return if version_string[3].nil?
    @revision = version_string[3].to_i
  end

  # Restituisce la versione attuale del gioco
  # @return [Game_Version]
  def self.now
    if File.exist?(H87_ModConfig::VERSIONFILE)
      file = File.open(H87_ModConfig::VERSIONFILE, 'r')
      str = file.read
      file.close
      Game_Version.new(str)
    elsif get_version_from_game_ini != nil
      get_version_from_game_ini
    else
      Game_Version.new('1.0.0.0')
    end
  end

  # Ottiene la versione del gioco da Game.ini
  # @return [Game_Version]
  def self.get_version_from_game_ini
    return nil unless File.exist?('Game.ini')
    version = nil
    file = File.open('Game.ini', 'r')
    File.readlines.each { |line|
      if line =~ /version[ ]*=[ ]*([.\d]+)/i
        version = Game_Version.new($1)
      end
    }
    file.close
    version
  end

  # Compara una versione o una stringa con se stessa
  def <=>(other)
    return self <=> Game_Version.new(other) if other.is_a?(String)
    return self.major <=> other.major if self.major != other.major
    return self.minor <=> other.minor if self.minor != other.minor
    return self.build <=> other.build if self.build != other.build
    self.revision <=> other.revision
  end

  # restituisce la versione in stringa
  def to_s
    sprintf('%d.%d.%d.%d', @major, @minor, @build, @revision)
  end
end

#game_version

#==============================================================================
# ** RPG::System -> aggiunta del metodo per la versione del gioco
#==============================================================================
class Game_System
  # Restituisce la versione del gioco attuale
  def game_version
    Game_Version.now
  end
end

#rpg_system

#==============================================================================
# ** DataManager -> aggiunta dei metodi per caricare i settaggi
#==============================================================================
module DataManager
  # alias
  # noinspection RubyResolve
  class << self
    alias h87set_load_n_db load_normal_database
    alias h87set_load_b_db load_battle_test_database
  end

  # caricamento nd
  def self.load_normal_database
    load_h87settings
    h87set_load_n_db
  end

  # caricamento btd
  def self.load_battle_test_database
    load_h87settings
    h87set_load_b_db
  end

  # restituisce il percorso delle impostazioni
  def self.settings_path
    H87_ModConfig::SETTINGNAME
  end

  # carica le impostazioni universali
  def self.load_h87settings
    return if $game_settings
    if File.exist?(settings_path)
      $game_settings = load_data(settings_path)
    else
      $game_settings = H87_Settings.new
      save_data($game_settings, settings_path)
    end
  end
end #datamanager

#==============================================================================
# ** Resolution
#------------------------------------------------------------------------------
# Un contenitore di risoluzioni
#==============================================================================
module Resolution
  QVGA = '320x240' # 4:3
  VGA = '640x480' # 4:3
  WSVGA = '1024x600' # 16:9
  SVGA = '800x600' # 4:3
  XGA = '1024x768' # 4:3
  SXGA = '1280x1024' # 4:3
  WXGA = '1280x720' # 16:9
  HD768 = '1366x768' # 16:9
  FULLHD = '1920x1080' # 16:9
  WUXGA = '1920x1200' # 16:10
end

#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
# Aggiunta della possibilità di scaricare l'immagine del giorno.
#==============================================================================
module Cache
  # Restituisce l'immagine del giorno di Bing come bitmap.
  #   È possibile specificare una risoluzione. Risoluzioni supportate:
  #   QVGA, VGA, SVGA, XGA, WXGA, HD768, FULLHD, WUXGA
  # @param [String] resolution
  # @return [Bitmap]
  def self.bing_daily(resolution = Resolution::VGA)
    if bing_daily_ready?(resolution)
      return @bing_daily[resolution]
    end
    @bing_info = get_bing_xml if @bing_info.nil?
    if @bing_info != nil
      @bing_daily_copyright = @bing_info[:copyright]
      image_name = @bing_info[:filename] + "_#{resolution}.jpg"
      url = "http://www.bing.com#{@bing_info[:url]}_#{resolution}.jpg"
      response = HTTP.download(url, bing_download_folder).response
      loop do
        break if response.progress >= 1
      end
      if response.ok?
        bitmap = load_bitmap(bing_download_folder, image_name)
        @bing_daily ||= {}
        @bing_daily[resolution] = bitmap
        bitmap
      else
        puts '[ERROR] for Bing Image ' + url
      end
    else
      nil
    end
  end

  # Restituisce la cartella di download dell'immagine
  # @return [String]
  def self.bing_download_folder;
    './Graphics/Pictures/Bing';
  end

  # Restituisce il copyright dell'immagine del giorno. usare solo se già
  #   scaricata l'immagine!
  # @return [String]
  def self.bing_daily_copyright
    if @bing_daily_copyright
      @bing_daily_copyright
    else
      @bing_info = get_bing_xml
      if @bing_info.nil?
        ''
      else
        @bing_daily_copyright = @bing_info[:copyright]
        @bing_daily_copyright
      end
    end
  end

  # Ottiene il feed xml dell'immagine di Bing e ne restituisce un hash con
  #   informazioni, oppure nil se la connessione non è riuscita
  # @return [Hash]
  def self.get_bing_xml
    lang = $imported['H87_Localization'] ? H87Localization.system_language : 'en-US'
    url = "http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=#{lang}"
    response = HTTP.get(url, {}, true)
    if response.ok?
      info = {}
      if response.body =~ /<urlBase>(.+)<\/urlBase>/i
        info[:url] = $1
        info[:filename] = File.basename(info[:url]).gsub(/[\/?!]/, '')
      end

      if response =~ /<copyright>(.+)<\/copyright>/i
        info[:copyright] = $1
      else
        info[:copyright] = ''
      end
    else
      return nil
    end
    info
  end

  # Controlla se l'immagine del giorno è scaricata
  def self.bing_daily_ready?(resolution = Resolution::VGA)
    @bing_daily != nil && @bing_daily[resolution.to_sym] != nil
  end
end

#==============================================================================
# ** Aggiunta di alcuni metodi utili per le stringhe
#==============================================================================
class String
  # Metodo Random: restituisce una stringa a caso
  #   size: numero di caratteri della stringa
  # @param [Integer] size
  # @return [String]
  def self.random(size = 4)
    rand(36 ** size).to_s(36)
  end

  # Restituisce la stessa stringa ma crittografata in ROT13
  #   http://it.wikipedia.org/wiki/ROT13
  # @return [String]
  def crypt_rot13
    self.tr('A-Za-z', 'N-ZA-Mn-za-m')
  end
end

#fine della stringa

#==============================================================================
# ** Inclusione dei metodi asincroni in Scene_Base
#==============================================================================
class Scene_Base
  include Async_Downloads # inclusione del modulo
  # Alias del metodo d'aggiornamento
  alias h87_module_update update unless $@

  def update
    h87_module_update
    check_async_downloads #controlla i download
    check_async_requests #controlla le richieste
  end
end #scene_base

#==============================================================================
# ** Inclusione dei metodi asincroni in Window_Base
#==============================================================================
class Window_Base
  include Async_Downloads # inclusione del modulo
  # Alias del metodo d'aggiornamento
  alias h87_module_update update unless $@

  def update
    h87_module_update
    check_async_downloads #controlla i download
    check_async_requests #controlla le richieste
  end
end #scene_base

class Integer
  # returns minutes in seconds
  # @return [Integer]
  def minutes
    self * 60
  end

  # returns hours in seconds
  # @return [Integer]
  def hours
    self * 3600
  end

  # @return [Integer]
  def seconds
    self
  end

  # returns days in seconds
  # @return [Integer]
  def days
    hours * 24
  end
end

#==============================================================================
# ** Object
#------------------------------------------------------------------------------
# Metodi universali di gioco
#==============================================================================
class Object
  # Metodo di stampa riga
  # @deprecated not used anymore. Please use puts instead
  def println(*args)
    puts *args
  end

  # Metodi di conversione Base64
  # @param [String] string
  # @return [String]
  def base64_encode(string)
    Base64.encode(string)
  end

  # @param [String] string
  # @return [String]
  def base64_decode(string)
    Base64.decode(string)
  end

  # Restituisce direttamente la stringa di risposta dal server
  #   url: indirizzo della richiesta
  # @param [String] url
  # @return [String]
  def await_response(url)
    HTTP.get(url).body
  end

  # Restituisce direttamente la stringa di risposta dal server
  #   url: indirizzo della richiesta
  # @param [String] url
  # @param [Hash] params
  # @return [String]
  # @raise [InternetConnectionException]
  def submit_post_request(url, params = {}, https = false)
    HTTP.post(url, params, https).body
  end

  # Determina se il gioco è VX Ace
  def on_vx_ace?
    RUBY_VERSION == '1.9.2'
  end

  # Determina se il gioco è VX
  def on_vx?
    RUBY_VERSION == '1.8.1'
  end
end

#==============================================================================
# ** Time
#==============================================================================
class Time
  # @param [Date] date_str
  def self.from_string(date_str)
    if date_str =~ /(\d{4})-(\d{2})-(\d{2})/
      Time.local($1.to_i, $2.to_i, $3.to_i)
    else
      raise WrongDateFormatError('You must use format YYYY-MM-DD')
    end
  end
end

#==============================================================================
# ** Hash
#------------------------------------------------------------------------------
# changed to_s method to better print
#==============================================================================
class Hash
  # hsh.to_s     -> string
  # hsh.inspect  -> string
  #
  # Return the contents of this hash as a string.
  #
  #     h = { "c" => 300, "a" => 100, "d" => 400, "c" => 300  }
  #     h.to_s   #=> "{\"c\"=>300, \"a\"=>100, \"d\"=>400}"
  def to_s
    '{' + (self.inject([]) do |a, (key, value)|
      a.push(sprintf('%s=>%s', key, value))
    end * ',') + '}'
  end
end

#==============================================================================
# ** Array
#------------------------------------------------------------------------------
# changed to_s method to better print
#==============================================================================
class Array
  # ary.inspect  -> string
  # ary.to_s     -> string
  #
  # Creates a string representation of +self+.
  #
  #    [ "a", "b", "c" ].to_s     #=> "[\"a\", \"b\", \"c\"]"
  def to_s
    '[' + (self * ',') + ']'
  end
end


# launched when can't connect with the server
class InternetConnectionException < StandardError
  attr_accessor :code

  # @param [String] message
  # @param [Fixnum] code
  def initialize(message, code = nil)
    super(message)
    @code = code
  end

  # determines if the connection is not available
  def server_unreachable?
    @code == 0
  end
end

# launched when can't read from the clipboard
class ClipboardDataAccessException < Exception; end

# launched when fails to obtaining the mouse position
class GetMousePosException < Exception; end

class WrongDateFormatError < StandardError

end

unless $imported['H87-ConsoleLogger']
  module Logger
    def self.info(*args)
      args[0] = '[INFO] ' + args[0].to_s
      puts args
    end

    def self.error(*args)
      args[0] = '[ERROR] ' + args[0].to_s
      puts args
    end

    def self.warning(*args)
      args[0] = '[WARNING] ' + args[0].to_s
      puts args
    end
  end
end