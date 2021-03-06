#===============================================================================
# ESTENSIONE DI CONSOLE LOG PER RPG MAKER VX e VX-ACE
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script è stato scritto principalmente per aiutarmi nella programmazione
# con l'ormai vetusto RPG Maker VX, ma può essere usato anche su VX Ace per
# avere un log del debug che si stampa a schermo oppure per usare una console
# più potente (powerShell) e che non viene chiusa con la chiusura del test.
#===============================================================================
# Istruzioni: inserire lo script sopra tutti gli altri script o sotto Materials.
#
# SE USI RPG MAKER VX (non ACE)
# Assicurarsi di avere Windows PowerShell nel vostro PC. Windows 8 e 10 ne sono
# già provvisti, per tutti gli altri occorre scaricarlo.
# https://github.com/powershell/powershell

#===============================================================================
# ** CONFIGURAZIONE
#===============================================================================
module H87Logger
  # nome del file di log
  FILENAME = 'game.log'
  # aprire automaticamente la shell all'avvio del test?
  AUTO_OPEN_SHELL = true
  # azzerare i log all'avvio del gioco?
  CLEAN_LOG_ON_STARTUP = true
  # modificare print di VX Ace per scrivere nei log anziché nella console?
  FORCE_PRINT_ON_CONSOLE = false


  #===============================================================================
  # ** FINE CONFIGURAZIONE
  #===============================================================================
  PS_WINDOW_NAMES = [
      'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe',
      'Windows PowerShell'
  ]

  def self.log_directory
    './'
  end

  # scrive il testo nel log solo in modalità test
  def self.test_log(*args)
    return unless $TEST
    log(args)
  end

  # scrive il testo nel log
  def self.log(*args)
    begin
      file = File.open(log_directory + FILENAME, 'a')
      file.write(args.map { |obj| obj.to_s }.join(' '))
    rescue
      #nulla
    ensure
      file.close
    end
  end

  # apre la PowerShell
  def self.open_shell
    return unless AUTO_OPEN_SHELL
    return if ps_window_exist?
    Thread.new { system("powershell -command \"Get-Content -Path #{FILENAME} -Wait\"") }
    sleep(0.01)
  end

  # determina se una finestra di Windows PowerShell è già aperta
  def self.ps_window_exist?
    f_w_e = Win32API.new("user32", "FindWindowEx", 'LLPP', 'I')
    PS_WINDOW_NAMES.each { |name|
      return true if f_w_e.call(0, 0, nil, name) > 0
    }
    false
  end

  # cancella i log precedenti
  def self.delete_prec_log
    return unless CLEAN_LOG_ON_STARTUP
    File.delete(FILENAME) rescue nil
  end

  # inizializza i log
  def self.init
    #return unless $TEST
    delete_prec_log
    log Time.now
    open_shell
  end
end

#===============================================================================
# ** Logger
#===============================================================================
module Logger
  # logga un'informazione
  def self.info(*args)
    H87Logger.log('[INFO]    ', args)
  end

  # logga un errore
  def self.error(*args)
    H87Logger.log('[ERROR]   ', args)
  end

  # logga un avvertimento
  def self.warning(*args)
    H87Logger.log('[WARNING] ', args)
  end
end

#===============================================================================
# ** Object
#===============================================================================
class Object
  # aggiunge il metodo println
  def println(*args)
    H87Logger.test_log(args, "\n")
  end

  def puts_e(*args)
    puts('[ERROR]   ', args)
  end

  def puts_i(*args)
    puts('[INFO]    ', args)
  end

  def puts_w(*args)
    puts('[WARNING] ', args)
  end

  # modifica i metodi print e puts su VX
  if RUBY_VERSION == '1.8.1' or H87Logger::FORCE_PRINT_ON_CONSOLE
    alias msgbox print unless $@

    def print(*args)
      H87Logger.test_log(*args)
    end

    def puts(*args)
      H87Logger.test_log(args, "\n")
    end
  end
end

# avvio
$imported = {} if $imported.nil?
$imported['H87-ConsoleLogger'] = 1.0
H87Logger.init