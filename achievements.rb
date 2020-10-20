#===============================================================================
# SISTEMA OBIETTIVI
#===============================================================================
# Autore: Holy87
# Versione: 1.7
# Difficoltà utente: ★★★
# RICHIEDE IL MODULO UNIVERSALE, SENZA QUELLO NON FUNZIONA
#
# changelog v1.6
# ● supporta le opzioni di gioco: aggiunge l'opzione di attivare o disattivare i
#   popup quando è installato lo script delle opzioni
# ● nuove condizioni di conquista degli obiettivi, tra le quali lo sblocco
#   quando vengono ottenuti un certo numero di obiettivi, quando si uccidono un
#   certo numero di mostri, danni totali, danni in un colpo, cure totali ecc...
# ● Possibilità di impostare le condizioni di un obiettivo via script in modo
#   completamente personalizzabile
# ● Ottimizzazione generale del codice, ora molto più ordinato e stabile
# ● Nuovo sistema di memorizzazione degli obiettivi sbloccati (i vecchi
#   obiettivi già sbloccati verranno convertiti al primo avvio)
# ● Il comando Obiettivi nella schermata del titolo ora è prima di Esci
# ● fix per la schermata del logo
# changelog v1.5
# ● gli obiettivi non si attivano più durante il test battaglia
# ● il popup viene mostrato correttamente durante la battaglia
# changelog v1.3
# ● fix crash nel test battaglia
# changelog v 1.2
# ● fix di alcuni bug
# changelog v 1.1
# ● fix di alcuni bug
# ● aggiunta compatibilità al menu titolo personalizzato
# ● aggiunta la possibilità di mostrare gli obiettivi dal menu di gioco
# ● aggiunta la barra di progresso degli obiettivi
#-------------------------------------------------------------------------------
# Questo script ti permetterà di implementare obiettivi e trofei nel gioco! Ora
# anche il tuo gioco può essere professionale come quelli più famosi.
# Gli obiettivi sbloccati verranno automaticamente memorizzati anche se non hai
# salvato la partita, e sono indipendenti dal salvataggio. Questo significa che
# puoi creare obiettivi che richiedono di giocare la stessa partita più volte,
# come "Finisci il gioco con il finale migliore" e "Finisci il gioco con il
# finale peggiore".
# Puoi impostare gli obiettivi per essere sbloccati tramite eventi nel gioco,
# oppure all'attivazione di alcune switch o variabili, oppure al raggiungimento
# di un certo numero di battaglie, denaro accumulato ecc..., tutto in modo
# semplice e che non richiede particolari abilità nello script!
# Questo script può:
# ● Mostrare la lista degli obiettivi sbloccati nella schermata principale
# ● mostrare un pop-up universale al raggiungimento di un determinato obiettivo
# ● i pop-up sono universali, possono essere mostrati non solo in mappa, ma
#   anche dal menu, in battaglia e ovunque!
# ● Se più obiettivi vengono sbloccati contemporaneamente (cosa rara, ma
#   possibile), lo script provvederà a mostrare i pop-up successivi appena dopo
#   la scoparsa del precedente.
# ● Si possono impostare gli obiettivi "nascosti"
#
# Guardando gli obiettivi, è possibile vedere quanto manca al loro completamento.
# Nel caso vengano visti dalla schermata del titolo, vengono presi i dati dell'
# ultimo salvataggio effettuato.
#-------------------------------------------------------------------------------
# Istruzioni:
# Copiare lo script sotto Materials, prima del Main. Icone degli obiettivi,
# immagine di sfondo della schermata e immagine del pop-up vanno tutti nella
# cartella Graphics\Pictures.
# Creare gli obiettivi nella sezione più in basso seguendo le istruzioni.
# Se vuoi sbloccare un obiettivo da evento, usa un Chiama Script con questo
# comando: unlock_achievement(id), dove id è l'ID dell'obiettivo.
#
#-------------------------------------------------------------------------------
# Compatibilità:
# Compatibile con tutti gli script, compreso "Menu Titolo Personalizzato".
#-------------------------------------------------------------------------------
# Note:
# Per evitare lag, il controllo sul tempo di gioco viene effettuato
# quando si cambia schermata.
#-------------------------------------------------------------------------------
module H87_Achievements
  #===============================================================================
  # ** CONFIGURAZIONE **
  #===============================================================================
  #Inserimento dell'elenco dei trofei. Inserire come da esempio:
  #1 => [A,B,C,D,E,F,G,H],
  #2 => [A,B,C,D,E,F,G,H],
  #3 ....
  #A: File immagine che rappresenta l'icona del trofeo
  #B: Nome dell'obiettivo
  #C: Descrizione dell'obiettivo (vai a capo con il carattere "|")
  #D: Punteggio ottenuto conquistando l'obiettivo
  #E: false se è visibile, true se è nascosto e visibile solo al compimento
  #F: Come si sblocca
  #   0: In modo manuale
  #   1: All'attivazione di un preciso switch
  #   2: Al valore di una precisa variabile
  #   3: Denaro
  #   4: Denaro totale ottenuto
  #   5: Livello raggiunto con un qualsiasi eroe
  #   6: Passi totali
  #   7: Salvataggi
  #   8: Combattimenti vinti
  #   9: Fughe
  #  10: Combattimenti totali
  #  11: Oro speso al negozio
  #  12: Oro guadagnato dalla vendita di oggetti
  #  13: Tempo di gioco totale (in ore)
  #  14: Numero ottenuto di uno specifico tipo di oggetto
  #  15: Quando si sbloccano un certo numero di obiettivi
  #  16: Quando sono stati uccisi un certo numero di nemici
  #  17: Quando è stato ucciso un certo numero di un nemico specifico
  #  18: Quando è stato inflitto un certo numero di danni totali
  #  19: Quando è stato inflitto certo danno in un colpo solo da qualsiasi eroe
  #  20: Numero di nemici uccisi in un turno
  #  21: Danni in un turno
  #  22: Cure ricevute in totale
  #  codice: Se scrivi un codice ruby, la condizione diventa il risultato di
  #  quel codice. Ad esempio: "$game_actors[1].mhp" la condizione di sblocco
  #  sarà sugli HP massimi dell'eroe 1.
  #G: Solo nei casi dal 2 in poi, inserire il valore da raggiungere.
  #H: Nel caso di switch o variabile, inserire l'ID della
  #   switch o della variabile. Nel caso 14, inserire l'ID dell'oggetto.
  #   Nel caso 17, l'ID del nemico.
  # Sezione Obiettivi
  Trophies = {
      #ID         A                     B                   C                      D   E    F   G   H
      1 => ['Prima missione', "Inizia l'avventura!", "Accetta la prima missione", 10, false, 1, nil, 1],
      2 => ["Boss", "Ammazzaboss", "Sconfiggi il boss", 50, true, 0],
      3 => ["Livello", "Livello 5!", "Raggiungi il livello 5", 20, false, 5, 5],
      4 => ["Passi2", "Maratoneta", "Compi 200 passi", 10, false, 6, 200],
      5 => ["Passi", "Combattente", "Vinci 10 combattimenti", 20, false, 8, 10],
      6 => ["Soldi", "Soldi!", "Guadagna 20 argenti", 20, true, 4, 2000],
      7 => ["Scrigni", "Trovatore", "Apri 5 scrigni", 10, false, 2, 5, 1],
      8 => ["Salvataggio", "Prudente", "Salva il gioco 3 volte", 10, true, 7, 3],
      9 => ["100danni", "Batosta!", "Causa almeno 100 punti danno|in un colpo",
            10, false, 19, 100],
      10 => ["999heal", "Paziente", "Curati di 999 punti in totale", 15, false, 22, 999],
      11 => ["Morte", "Due in uno!", "Sconfiggi due nemici in un turno.", 10, false, 20, 2],
      12 => ["Attacco", "Forza bruta", "Raggiungi attacco 60 con Eric", 10, false, "$game_actors[1].atk", 60],
      13 => ["Boss", "Completo!", "Sblocca tutti gli obiettivi", 20, false, 15, 12],
  }

  # Sezione Vocaboli
  # Testo del menu nella schermata del titolo
  ACHVTEXT = "Obiettivi"
  # Testo del nome obiettivo se nascosto
  HIDDTEXT = "Obiettivo nascosto"
  # Testo descrizione dell'obiettivo se nascosto (un | va a capo)
  HIDDDESC = "Continua a giocare per sbloccare quest'obiettivo."
  # Testo dei punteggi ottenuti dagli obiettivi sbloccati
  POINTEXT = "Punteggio:"
  # Testo del totale degli obiettivi sbloccati
  UNLKTEXT = "Sbloccati:"
  # Testo che viene mostrato se l'obiettivo è bloccato
  LOCKTEXT = "Obiettivo bloccato"
  #Testo che viene mostrato se l'obiettivo è stato sbloccato
  DATETEXT = "Ottenuto il"
  #Testo del valore dell'obiettivo
  VALRTEXT = "punti"
  #Testo sul pop-up quando è stato sbloccato un obiettivo
  UNLOCKNEW = "Obiettivo completato!"

  # Sezione Impostazioni
  #Mostrare il comando nel menu iniziale?
  ShowTitle = true

  #Mostrare il comando nel menu di gioco?
  ShowMenu = true

  #Imposta una switch che, se attivata, mostra il comando nel menu
  MenuSw = 0 #imposta 0 se vuoi che sia visibile sempre

  #Vuoi mostrare la barra di progresso degli obiettivi?
  ShowProgress = true

  # Sezione Immagini
  # Imposta true se le finestre della schermata degli obiettivi devono essere
  # trasparenti.
  Transparent = false
  # Seleziona il file immagine usato come sfondo nella finestra degli obiettivi.
  BACKIMAGE = "" # "" se non lo vuoi
  # Seleziona il file immagine che viene usato per mostrare il popup quando
  # viene completato un obiettivo.
  RECTIMAGE = "Achievements_Rect"
  # Solo se hai anche lo script Menu Titolo Personalizzato, imposta l'immagine
  # del pulsante "Trofei" nella schermata principale
  OBJIMAGE = "T_Trofei"
  # Anche qui solo se hai lo script MTP, imposta l'immagine del fumetto.
  BALIMAGE = "B_Trofei"
  # Velocità di scorrimento delle immagini nella schermata degli obiettivi
  SPEED = 2 #1: immediato 2: velocissimo 3: veloce 4: normale

  # Sezione Pop-Up
  # Per quanti frame deve restare il pop-up prima di scomparire?
  BANNERTIME = 300
  # Impostazioni per la scritta superiore del pop-up ("Obiettivo sbloccato")
  UTF = "Arial" #Font
  UTG = 20 #Grandezza
  UTC = [255, 255, 255] #Colore (Rosso,Verde,Blu)
  UTB = true #Testo in grassetto? (true=grassetto)
  UTI = false #Testo in corsivo? (true=corsivo)
  UTS = false #Ombra testo? (true=si)
  #Impostazioni per la scritte inferiore (nome dell'obiettivo)
  DTF = "Arial" #Font
  DTG = 15 #Grandezza
  DTC = [255, 255, 255] #Colore (Rosso,Verde,Blu)
  DTB = false #Testo in grassetto? (true=grassetto)
  DTI = false #Testo in corsivo? (true=corsivo)
  DTS = false #Ombra testo? (true=si)

  ADJUSTX = 0 #modifica la distanza dal centro (coord x)
  ADJUSTY = 0 #modifica la distanza dal centro (coord y)

  # Animazione di movimento nella comparsa del popup.
  #true: dal basso verso l'alto; false: solo fade
  MOVEMENTS = true

  # Sezione Audio
  # Scegli se al completamento di un obiettivo si esegue un SE o un ME (fanfara)
  PlayME = true #true = ME, false = SE
  # Inserisci il nome del file audio da riprodurre
  SE = "Fanfare1"

  # Sezione Menu Opzioni
  # Configura questa parte se hai lo script Menu Opzioni di Holy87 per far
  # comparire l'opzione di attivare o disattivare i popup quando sblocchi un
  # obiettivo.
  OPT_ENABLED = true #attivare l'opzione? false altrimenti
  OPT_SWITCH = 110 #switch di attivazione dell'opzione.
  OPT_TEXT = "Popup obiettivi" #testo della voce nel menu
  OPT_HELP = "Mostra o nascondi i popup quando viene sbloccato un obiettivo."
  OPT_ON = "Mostra" #testo opzione attiva
  OPT_OFF = "Nascondi" #testo opzione disattivata

  # Sezione Altro
  # Extra: Seleziona i membri del gruppo che non vuoi che siano considerati
  # quando si controlla il livello massimo del gruppo (ID separati da virgola)
  ExludedMembers = []


  #===============================================================================
  # ** FINE CONFIGURAZIONE **
  # Attenzione: Non modificare ciò che c'è oltre, a meno che tu non sappia ciò che
  # fai! C'è gente che si è suicidata per molto meno, fidati.
  #===============================================================================
  $imported = {} if $imported == nil
  $imported['H87_Achievements'] = 1.7

  #===============================================================================
  # ** modulo H87_Achievements
  #===============================================================================
  module_function
  # Esegue il controllo sugli obiettivi
  def self.check(type, param = nil)
    return if $BTEST
    return unless $cache_switches_achievements
    return unless $game_achievements
    return if type == 1 && !$cache_switches_achievements.include?(param)
    return if type == 2 && !$cache_variables_achievements.include?(param)
    achievements = $game_achievements.select do |achievement|
      !achievement.unlocked? and achievement.condition == type
    end
    achievements.each { |ach| ach.unlock if ach.condition_met?(param) }
    check(15) if type != 15 #per il controllo obiettivo su obiettivi
  end

  # Comando che sblocca l'obiettivo
  #   id = id obiettivo
  def self.unlock_achievement(id)
    return if get_achievement(id).nil?
    get_achievement(id).unlock
  end

  # @param [Fixnum] id
  # @return [Achievement]
  def self.get_achievement(id)
    return if $game_achievements.nil?
    $game_achievements.select{|ach| ach.id == id}.first
  end

  # Restituisce i punti ottenuti da tutti gli obiettivi sbloccati
  # @return [Integer]
  def self.gained_points
    $game_achievements.inject(0) { |sum, ach| sum + ach.reward}
  end

  # Restituisce il totale punti di tutti gli obiettivi
  # @return [Integer]
  def self.total_points
    unlocked_achievements.inject(0) { |sum, ach| sum + ach.reward}
  end

  # Restituisce il numero degli obiettivi sbloccati
  # @return [Integer]
  def unlocked_achievements_size
    $game_achievements.select { |ach| ach.unlocked? }.size
  end
  
  alias unlockeds unlocked_achievements_size

  # Restituisce il numero di obiettivi totali
  # @return [Integer]
  def self.total_achievements
    $game_achievements.size
  end
  
  # @return [Array<Achievement>]
  def self.unlocked_achievements
    $game_achievements.select { |ach| ach.unlocked? }
  end

  # Restituisce l'elenco dei trofei. Alias questo metodo per altri trofei.
  # @return [Hash{Fixnum->Array<String or Fixnum or FalseClass>}]
  def trophies
    Trophies
  end

  # achievement personalizzati
  def custom_achievements
    update_custom_achievements if @c_ach.nil?
    @c_ach
  end

  # aggiorna gli achievement personalizzati
  def update_custom_achievements
    return if $game_achievements.nil?
    @c_ach = $game_achievements.select { |ach| !ach.unlocked? && ach.custom? }
  end
end #achievements

#===============================================================================
# ** classe Scene_Achievements
#------------------------------------------------------------------------------
#  Questa è la schermata dove vengono visualizzati gli obiettivi
#==============================================================================
class Scene_Achievements < Scene_MenuBase
  # start
  def start
    super
    initialize_status
    create_status_window
    create_achievement_window
    create_info_window
    if H87_Achievements::Transparent
      @status_window.opacity = 0
      @info_window.opacity = 0
    end
  end

  # Carica lo stato
  def initialize_status
    @data_loaded = DataManager.load_game(DataManager.last_savefile_index)
  end

  # aggiornamento
  def update
    super
    return_scene if Input.trigger?(:B)
    @achievement_window.update # non è una vera finestra, quindi aggiorno
  end

  # aggiunta dello sfondo
  def create_background
    super
    @plus_sprite = Sprite.new
    @plus_sprite.bitmap = Cache.picture(H87_Achievements::BACKIMAGE)
  end

  # eliminazione dello sfondo
  def dispose_background
    super
    @plus_sprite.dispose
  end

  # gestione uscita dalla schermata
  def terminate
    super
    dispose_achievement_window
    dispose_info_window
    dispose_status_window
  end

  # creazione finestra di status
  def create_status_window
    @status_window = Window_AchievementStatus.new #vedi la classe più in basso
    @status_window.y = Graphics.height - @status_window.height
  end

  # creazione finestra informazioni
  def create_info_window
    y = @achievement_window.height
    w = Graphics.width
    h = Graphics.height - y - @status_window.height
    @info_window = Window_AchievementInfo.new(0, y, w, h)
    @achievement_window.set_info(@info_window)
  end

  # creazione finestra degli obiettivi
  def create_achievement_window
    @achievement_window = Window_Achievements.new #non è una vera finestra
  end

  # eliminazione della finestra obiettivi
  def dispose_achievement_window
    @achievement_window.dispose
  end

  # eliminazione finestra status
  def dispose_status_window
    @status_window.dispose
  end

  # eliminazione finestra info
  def dispose_info_window
    @info_window.dispose
  end
end

#===============================================================================
# ** classe Window_Achievements (non è una vera finestra!)
#------------------------------------------------------------------------------
#  Mostra le icone degli obiettivi come elenchi
#==============================================================================
class Window_Achievements
  # inizializzazione
  def initialize
    @index = 0
    refresh
  end

  # refresh
  def refresh
    @emblems = $game_achievements.collect{|ach| create_emblem(ach)}
  end

  # settaggio del riferimento della finestra info da aggiornare
  def set_info(info_window)
    @info_window = info_window
    update_info
  end

  # creazione degli emblemi
  #   achievement: obiettivo
  # @param [Achievement] achievement
  # @return [Sprite]
  def create_emblem(achievement)
    sprite = Sprite.new
    sprite.bitmap = Cache.picture(achievement.icon)
    if achievement.unlocked?
      sprite.opacity = 255
    else
      sprite.opacity = 50
      if achievement.hidden?
        sprite.tone.set(-255, -255, -255, 255)
      end
    end
    sprite.ox = sprite.width / 2
    sprite.oy = sprite.height / 2
    sprite.y = self.height / 2
    sprite
  end

  # larghezza e altezza
  def width
    Graphics.width
  end

  #restituisce la larghezza
  def height
    150
  end

  #restituisce l'altezza
  # eliminazione degli emblemi
  def dispose
    all_emblems.each{|emblem| emblem.dispose}
  end
  
  # @return [Array<Sprite>]
  def all_emblems
    @emblems
  end

  # aggiornamento
  def update
    left if Input.repeat?(Input::LEFT)
    right if Input.repeat?(Input::RIGHT)
    update_objects
  end

  # azione sinistra
  def left
    return if @index <= 0
    @index -= 1
    Sound.play_cursor
    update_info
  end

  # azione destra
  def right
    return if @index >= @emblems.size - 1
    @index += 1
    Sound.play_cursor
    update_info
  end

  # aggiornamento degli oggetti
  def update_objects
    all_emblems.each_with_index{|emblem, index| update_emblem(emblem, index)}
  end

  # aggiornamento della singola icona
  #   index = indice dell'icona
  # @param [Sprite] emblem
  def update_emblem(emblem, index)
    sp = H87_Achievements::SPEED
    if @index == index
      if emblem.zoom_x < 1
        distance = 1 - emblem.zoom_x
        emblem.zoom_x += distance / sp
        emblem.zoom_y += distance / sp
      end
    else
      if emblem.zoom_x > 0.5
        distance = 0.5 - emblem.zoom_x
        emblem.zoom_x += distance / sp
        emblem.zoom_y += distance / sp
      end
    end
    if emblem.x != graphic_center(index)
      distance = graphic_center(index) - emblem.x
      emblem.x += distance / sp
    end
  end

  # restituisce la posizione che deve avere ogni icona
  def graphic_center(index = @index)
    center = self.width / 2
    if index > @index
      center += (@emblems[index].width + @emblems[@index].width) / 2
      (@index + 1..index - 1).each { |i|
        center += @emblems[i].width # @emblems[i].zoom_x
      }
    elsif index < @index
      center -= ((@emblems[index].width + @emblems[@index].width) / 2)
      (index + 1..@index - 1).each { |i|
        center -= @emblems[i].width # @emblems[i].zoom_x
      }
    end
    center
  end

  # aggiornamento della finestra info con l'indice attuale
  def update_info
    @info_window.set(H87_Achievements.get_achievement(@index + 1))
  end
end

#window_achievement

#==============================================================================
# ** classe Window_AchievementStatus
#------------------------------------------------------------------------------
#  Finestra che mostra il numero di obiettivi sbloccati
#==============================================================================
class Window_AchievementStatus < Window_Base
  # inizializzazione
  def initialize
    super(0, Graphics.height - (line_height * 32), Graphics.width, line_height + 32)
    refresh
  end

  # refresh
  def refresh
    contents.clear
    points = H87_Achievements.gained_points
    totalp = H87_Achievements.total_points
    text = sprintf("%s %d/%d", H87_Achievements::POINTEXT, points, totalp)
    draw_text(4, 0, self.width - 32, line_height, text)
    unlock = H87_Achievements.unlocked_achievements_size
    totala = H87_Achievements.total_achievements
    text = sprintf("%s %d/%d", H87_Achievements::UNLKTEXT, unlock, totala)
    draw_text(4, 0, self.width - 46, line_height, text, 2)
  end
end

#window_achievementstatus

#==============================================================================
# ** Window_AchievementInfo
#------------------------------------------------------------------------------
#  Finestra che mostra le informazioni sull'obiettivo
#==============================================================================
class Window_AchievementInfo < Window_Base
  # @attr[Achievement] achievement
  attr_reader :achievement
  # inizializzazione
  def initialize(x, y, w, h)
    super(x, y, w, h)
    @achievement = nil
    refresh
  end

  # refresh
  def refresh
    contents.clear
    return if @achievement == nil
    if !self.achievement.unlocked? and self.achievement.hidden?
      name = H87_Achievements::HIDDTEXT
      desc = H87_Achievements::HIDDDESC.split('|')
      reward = '???'
    else
      name = self.achievement.name
      desc = self.achievement.description.split('|')
      reward = self.achievement.reward
    end
    draw_achievement_name(name)
    draw_achievement_reward(reward)
    line = draw_achievement_description(desc)
    draw_achievement_details(line)
  end

  # mostra il nome dell'obiettivo se non nascosto, altrimenti ???
  def draw_achievement_name(name)
    change_color(crisis_color)
    default_size = contents.font.size
    contents.font.size = default_size + 15
    contents.draw_text(4, 0, self.width - 36, line_height * 2, name, 1)
    contents.font.size = default_size
    change_color(normal_color)
  end

  # Disegna la ricompensa dell'obiettivo
  def draw_achievement_reward(reward)
    return if !@achievement.unlocked? && @achievement.hidden?
    valuename = H87_Achievements::VALRTEXT
    text = sprintf('%d %s', reward, valuename)
    draw_text(4, line_height * 3, contents_width, line_height, text, 1)
  end

  # mostra lo stato dell'obiettivo (nascosto, bloccato o sbloccato)
  # @param [Array<String>] desc
  def draw_achievement_description(desc)
    desc.each_with_index{|text, i| draw_text(4, line_height * (4 + i), contents_width, line_height, text, 1) }
    desc.size
  end

  # mostra i dettagli dell'obiettivo (data sblocco, progressi...)
  def draw_achievement_details(line)
    if @achievement.unlocked?
      change_color power_up_color
      text = H87_Achievements::DATETEXT
      date = sprintf("%s %s", text, @achievement.date)
      draw_text(4, line_height * (5 + line), contents_width, line_height, date, 1)
    elsif can_draw_bar?
      draw_progress_bar(4, line_height * (5 + line), contents_width / 2, line_height)
    else
      change_color power_down_color
      text = H87_Achievements::LOCKTEXT
      draw_text(4, line_height * (5 + line), contents_width, line_height, text, 1)
    end
  end

  # restituisce true se si può disegnare la barra di progresso
  def can_draw_bar?
    return false unless H87_Achievements::ShowProgress
    return false unless @data_loaded
    return false unless @achievement.has_bar?
    return false if @achievement.hidden?
    true
  end

  # disegna la barra di progresso
  def draw_progress_bar(x, y, width, height)
    max = @achievement.max_value
    val = @achievement.value
    val = [max, val].min
    xa = x + width / 2
    contents.fill_rect(xa, y + (height * 2 / 3), width, height / 3, gauge_back_color)
    per = val * width / max
    contents.gradient_fill_rect(xa, y + (height * 2 / 3), per, height / 3, mp_gauge_color1, mp_gauge_color2)
    draw_text(xa, y, width, height, sprintf("%d/%d", val, max), 1)
  end

  # settaggio dell'obiettivo
  #   achievement: obiettivo
  # @param [Achievement] achievement
  def set(achievement)
    return if @achievement == achievement
    @achievement = achievement
    refresh
  end
end

#window_achievementinfo

#==============================================================================
# ** Achievement
#------------------------------------------------------------------------------
#  Questa classe si occupa della creazione materiale dell'obiettivo. L'istanza
#  di questa classe fa riferimento a $game_achievements.
#==============================================================================
class Achievement
  include H87_Achievements #inclusione del modulo
  # variabili d'istanza pubblici
  attr_reader :id #ID obiettivo
  attr_reader :name #nome obiettivo
  attr_reader :description #descrizione
  attr_reader :icon #icona usata
  attr_reader :condition #condizione
  attr_reader :reward #punteggio ottenuto
  attr_reader :date #data di ottenimento
  attr_reader :object #oggetto del valore
  # metodi semplici
  def hidden?
    @hidden
  end

  #restituisce true se nascosto
  def max_value
    @max_value
  end

  #restituisce il valore da sbloccare
  def unlocked?
    @unlocked
  end

  #restituisce true se è sbloccato
  def has_bar?
    store_var?
  end

  #restituisce true se ha una barra
  def custom?
    @condition.is_a?(String)
  end

  #true se è personalizzato
  # azione di sblocco dell'obiettivo
  def unlock
    return if unlocked?
    @unlocked = true
    $cache_variables_achievements.delete(@object) if self.condition == 2
    $cache_switches_achievements.delete(@object) if self.condition == 1
    set_date
    save_to_settings
    SceneManager.scene.push_banner(self.id)
    update_custom_achievements if custom?
  end

  # imposta la data di sblocco dell'obiettivo
  def set_date
    date = Time.new
    date_text = sprintf("%d/%d/%d", date.day, date.month, date.year)
    @date = date_text
  end

  # salva i dati di sblocco nel file settings
  def save_to_settings
    $game_settings[:achievements] = {} if $game_settings[:achievements].nil?
    $game_settings[:achievements][@id] = @date
    $game_settings.save
  end

  # inizializzazione
  #   trophy_id: id dell'obiettivo
  # @param [Integer] trophy_id
  def initialize(trophy_id)
    achievement = trophies[trophy_id]
    @id = trophy_id
    @name = achievement[1]
    @icon = achievement[0]
    @description = achievement[2]
    @reward = achievement[3]
    @hidden = achievement[4]
    @condition = achievement[5]
    @object = 0
    @max_value = 0
    @max_value = achievement[6] if achievement[6]
    @object = achievement[7] if achievement[7]
    get_achievement_state
  end

  # aggiorna lo stato dell'obiettivo
  def get_achievement_state
    DataManager.load_h87settings
    $game_settings[:achievements] = {} if $game_settings[:achievements].nil?
    if $game_settings[:achievements][@id] != nil
      @unlocked = true
      @date = $game_settings[:achievements][@id]
    else
      @unlocked = false
      @date = ''
    end
  end

  # restituisce true se le condizioni dell'obiettivo sono soddisfatte
  def condition_met?(param = nil)
    return false if self.condition == 0
    return switch_condition if self.condition == 1
    value(param) >= @max_value
  end

  # restituisce il progresso dell'obiettivo, o -1 se non è calcolabile.
  def value(param = nil)
    case self.condition
    when 2
      return variable_condition
    when 3
      return gold_condition
    when 4
      return total_gold_condition
    when 5
      return level_max_condition
    when 6
      return total_step_condition
    when 7
      return save_count_condition
    when 8
      return total_win_condition
    when 9
      return total_escape_condition
    when 10
      return total_battles_condition
    when 11
      return total_gold_spent_condition
    when 12
      return total_gold_sell_condition
    when 13
      return gametime_condition
    when 14
      return item_number_condition
    when 15
      return achievements_unlocked
    when 16
      return killed_enemies_condition
    when 17
      return killed_enemy_condition
    when 18
      return total_damage_condition
    when 19
      return single_damage_condition(param)
    when 20
      return turn_killed_enemies
    when 21
      return turn_damage
    when 22
      return total_heal
    when String
      return eval(self.condition)
    else
      return 0
    end
  end

  # restituisce true se l'obiettivo rappresenta un valore da accumulare.
  def store_var?
    if custom?
      return false if value == 0
      return false unless value.is_a?(Integer)
    end
    ary = [0, 1, 19, 20, 21]
    !ary.include?(self.condition)
  end

  # condizione per attivazione switch
  def switch_condition
    sw = $game_switches[@object]
    if sw.nil?
      Logger.warning "L'obiettivo #{@id} fa riferimento ad uno switch che non esiste."
      false
    else
      sw
    end
  end

  # Condizione per valore variabile
  # @return [Integer]
  def variable_condition
    $game_variables[@object]
  end

  # Condizione per oro posseduto
  # @return [Integer]
  def gold_condition
    $game_party.gold
  end

  # Condizione oro totale guadagnato
  # @return [Integer]
  def total_gold_condition
    $game_party.total_gold
  end

  # Condizione livello massimo raggiunto
  # @return [Integer]
  def level_max_condition
    $game_party.total_max_level
  end

  # Condizione passi totali
  # @return [Integer]
  def total_step_condition
    $game_party.steps
  end

  # Condizione salvataggi
  # @return [Integer]
  def save_count_condition
    $game_system.save_count
  end

  # Condizione vittorie
  # @return [Integer]
  def total_win_condition
    $game_party.total_victories
  end

  # Condizione fughe
  # @return [Integer]
  def total_escape_condition
    $game_party.total_escapes
  end

  # Condizione battaglie totali
  # @return [Integer]
  def total_battles_condition
    $game_party.total_battles
  end

  # Condizione oro speso
  # @return [Integer]
  def total_gold_spent_condition
    $game_party.total_gold_spent
  end

  # Condizione oro guadagnato dalle vendite
  # @return [Integer]
  def total_gold_sell_condition
    $game_party.total_sell
  end

  # Condizione ore di gioco
  # @return [Integer]
  def gametime_condition
    total_hours
  end

  # Condizione oggetti ottenuti
  # @return [Integer]
  def item_number_condition
    $game_party.total_items(@object)
  end

  # Condizione tutti gli obiettivi sbloccati
  # @return [Integer]
  def achievements_unlocked
    unlockeds
  end

  # Condizione nemici uccisi
  # @return [Integer]
  def killed_enemies_condition
    $game_party.enemies_killed
  end

  # Condizione nemico ucciso
  # @return [Integer]
  def killed_enemy_condition
    $game_party.enemy_killed(@object)
  end

  # Condizione danno totale inflitto
  # @return [Integer]
  def total_damage_condition
    $game_party.total_damage_dealed
  end

  # Condizione danno singolo inflitto
  # @return [Integer]
  def single_damage_condition(value)
     value
  end

  # Nemici uccisi in un turno
  # @return [Integer]
  def turn_killed_enemies
    BattleManager.enemies_killed
  end

  # Danno causato in un turno
  # @return [Integer]
  def turn_damage
    BattleManager.turn_damage
  end

  # Cura totale
  # @return [Integer]
  def total_heal
    $game_party.total_heal
  end

  # Conta morti di un eroe
  # @return [Integer]
  def dead_count
    $game_actors[@object].dead_count
  end

  # Restituisce le ore totali di gioco
  # @return [Integer]
  def total_hours
    sec = Graphics.frame_count / Graphics.frame_rate
    sec / 3600
  end
end

#achievement

#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  Aggiunta degli alias che gestiscono i banner
#==============================================================================
class Scene_Base
  # alias start per aggiungere il banner universale
  alias h87ach_startb start unless $@

  def start
    h87ach_startb
    H87_Achievements.check(13) if $game_achievements != nil
  end

  # aggiornamento
  alias h87upd_update update unless $@

  def update
    h87upd_update
    custom_achievement_check
    update_ach_animat
  end

  # aggiunta di un nuovo banner chiamando l'oggetto
  def push_banner(achievement_id)
    return unless achievement_popup_enabled?
    $game_temp.achievement_animations.push_banner(H87_Achievements.get_achievement(achievement_id))
  end

  # aggiornamento dei banner
  def update_ach_animat
    $game_temp.achievement_animations.update rescue nil
  end

  # restituisce true se i popup sono abilitati
  def achievement_popup_enabled?
    return true unless $imported['H87_Options']
    return true unless H87_Achievements::OPT_ENABLED
    $game_switches[H87_Achievements::OPT_SWITCH]
  end

  # controlla le condizioni degli obiettivi personalizzati
  def custom_achievement_check
    return if $game_achievements.nil?
    achs = H87_Achievements.custom_achievements
    return if achs.empty?
    achs.each { |ach| H87_Achievements.unlock_achievement(ach.id) if ach.condition_met? }
  end
end

#scene_base

#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  Aggiunta dei comandi e del caricamento degli obiettivi
#==============================================================================
class Scene_Title < Scene_Base
  # aggiunta del comando
  alias achiev_command_window create_command_window unless $@

  def create_command_window
    achiev_command_window
    @command_window.set_handler(:achievements, method(:command_achievements))
  end
  
  # metodo di passaggio alla schermata degli obiettivi
  def command_achievements
    $game_temp.achievements_from_title = true
    SceneManager.call(Scene_Achievements)
  end
end
#scene_title

#==============================================================================
# ** Window_TitleCommand
#------------------------------------------------------------------------------
#  Aggiunta del comando obiettivi nella schermata del titolo
#==============================================================================
unless $imported["H87_TitleMenu"] #se non c'è il menu titolo personalizzato
  class Window_TitleCommand < Window_Command
    alias h87_ach_add_command add_command unless $@
    # alias metodo add_command
    def add_command(name, symbol, enabled = true, ext = nil)
      if H87_Achievements::ShowTitle and symbol == :shutdown
        add_command(H87_Achievements::ACHVTEXT, :achievements)
      end
      h87_ach_add_command(name, symbol, enabled, ext)
    end
  end
end #window_titlecommand

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  Aggiunta del caricamento degli obiettivi
#==============================================================================
module DataManager
  class << self
    alias h87_ach_create_game_objects create_game_objects
  end

  def self.create_game_objects
    h87_ach_create_game_objects
    init_achievements
  end
  # caricamento di $game_achievements
  def self.init_achievements
    $game_achievements = load_achievements
    if $game_temp.achievement_animations != nil
      $game_temp.achievement_animations.hide
    else
      $game_temp.achievement_animations = Achievement_Banner.new
    end
    $cache_variables_achievements = load_variable_achievements
    $cache_switches_achievements = load_switches_achievements
  end

  # caricamento degli obiettivi
  # @return [Array<Achievement>]
  def self.load_achievements
    achievements = []
    (1..H87_Achievements.trophies.size).each do |i|
      achievements[i] = Achievement.new(i)
    end
    achievements.compact
  end

  # caricamento della cache delle variabili
  # per limitare lag, viene creata una cache di variabili da tenere sotto
  # controllo quando si controllano gli obiettivi, così da non controllarle
  # tutte.
  def self.load_variable_achievements
    $game_achievements.select{|ach| ach.condition == 2 and !ach.unlocked?}.inject([]){|sum, ach| sum.push(ach.object) }
  end

  # caricamento della cache degli obiettivi
  def self.load_switches_achievements
    $game_achievements.select{|ach| ach.condition == 1 and !ach.unlocked?}.inject([]){|sum, ach| sum.push(ach.object) }
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Aggiunta dei comandi evento e dei controlli a switch e variabili
#==============================================================================
class Game_Interpreter
  # Sblocco dell'obiettivo
  def unlock_achievement(id)
    H87_Achievements.unlock_achievement(id)
  end

  # comando di schermata degli obiettivi
  def open_achievement
    $game_temp.achievements_from_title = false
    SceneManager.call(Scene_Achievements)
  end
end

class Game_Temp
  attr_accessor :achievements_from_title
  attr_accessor :achievement_animations
end

#game_interpreter

#==============================================================================
# ** Game_Variables
#------------------------------------------------------------------------------
#  aggiunta del controllo sulle variabili
#==============================================================================
class Game_Variables
  alias old_modify []= unless $@
  # riscrittura
  def []=(variable_id, value)
    old_modify(variable_id, value)
    H87_Achievements.check(2, variable_id)
  end
end

#game_variables

#==============================================================================
# ** Game_Switches
#------------------------------------------------------------------------------
#  aggiunta del controllo sugli Switch
#==============================================================================
class Game_Switches
  alias old_modify []= unless $@
  # riscrittura
  def []=(switch_id, value)
    old_modify(switch_id, value)
    H87_Achievements.check(1, switch_id)
  end
end

#gameswitches

#==============================================================================
# ** Achievements_Graphic
#------------------------------------------------------------------------------
# Classe che gestisce la grafica del pop-up
# noinspection RubyInstanceMethodNamingConvention
#==============================================================================
class Achievement_Graphic
  def x
    @sprite.x
  end

  def y
    @sprite.y
  end

  # inizializzazione
  # @param [Achievement] achievement
  def initialize(achievement)
    @achievement = achievement
    @disappeared = false
    @counter = 0
    create_main_graphics
  end

  # creazione della grafica necessaria
  def create_main_graphics
    create_sprite
    create_achievement_image
    create_achievement_text
  end

  # creazione dello sprite del banner
  def create_sprite
    @sprite = Sprite.new
    @sprite.bitmap = Cache.picture(H87_Achievements::RECTIMAGE)
    @sprite.opacity = 0
    @sprite.oy = @sprite.height / 2
    @sprite.x = (Graphics.width - @sprite.width) / 2 + H87_Achievements::ADJUSTX
    @sprite.y = Graphics.height / 2 + H87_Achievements::ADJUSTY
    @sprite.y += 50 if H87_Achievements::MOVEMENTS
    @sprite.z = 500
  end

  # creazione dello sprite dell'immagine obiettivo
  def create_achievement_image
    @emblem = Sprite.new
    @emblem.bitmap = Cache.picture(@achievement.icon)
    @emblem.ox = @emblem.width / 2
    @emblem.oy = @emblem.height / 2
    setup_emblem
  end

  # impostazione posizione rispetto al banner
  def setup_emblem
    @emblem.x = @sprite.x
    @emblem.y = @sprite.y
    @emblem.z = @sprite.z + 1
    @emblem.opacity = @sprite.opacity
  end

  # scrittura del testo sulla bitmap del banner
  def create_achievement_text
    x = @emblem.width / 2
    y = (@sprite.height / 2) - 24
    @sprite.bitmap.font.name = H87_Achievements::UTF
    @sprite.bitmap.font.size = H87_Achievements::UTG
    c = H87_Achievements::UTC
    @sprite.bitmap.font.color = Color.new(c[0], c[1], c[2])
    @sprite.bitmap.font.bold = H87_Achievements::UTB
    @sprite.bitmap.font.italic = H87_Achievements::UTI
    @sprite.bitmap.font.shadow = H87_Achievements::UTS
    @sprite.bitmap.draw_text(x, y, @sprite.width - x, 24, H87_Achievements::UNLOCKNEW)

    @sprite.bitmap.font.name = H87_Achievements::DTF
    @sprite.bitmap.font.size = H87_Achievements::DTG
    c = H87_Achievements::DTC
    @sprite.bitmap.font.color = Color.new(c[0], c[1], c[2])
    @sprite.bitmap.font.bold = H87_Achievements::DTB
    @sprite.bitmap.font.italic = H87_Achievements::DTI
    @sprite.bitmap.font.shadow = H87_Achievements::DTS
    @sprite.bitmap.draw_text(x, y + 24, @sprite.width - x, 24, @achievement.name)
  end

  # aggiornamento
  def update
    @counter += 1
    @sprite.y -= 1 if @sprite.y > Graphics.height / 2 + H87_Achievements::ADJUSTY and H87_Achievements::MOVEMENTS
    if @counter < H87_Achievements::BANNERTIME
      @sprite.opacity += 4
    else
      @sprite.opacity -= 10
    end
    setup_emblem
    @disappeared = true if @sprite.opacity <= 0
  end

  # restituisce true se è scomparso
  def disappeared?
    @disappeared
  end

  # eliminazione del banner
  def dispose
    @emblem.opacity = 0
    @sprite.opacity = 0
    @emblem.dispose
    @sprite.bitmap.dispose
    @sprite.dispose
  end
end

#achievement_graphic

#==============================================================================
# ** Achievement_Banner
#------------------------------------------------------------------------------
#  Classe che gestisce l'aggiornamento e la comparsa di tutti i pop-up
#==============================================================================
class Achievement_Banner
  # inizializzazione
  def initialize
    @waiting_list = [] #lista d'attesa per altri obiettivi
    @banner = nil
  end

  # aggiunta di un nuovo banner
  #   achievement: obiettivo
  def push_banner(achievement)
    if @banner != nil
      @waiting_list.push(achievement)
    else
      add_banner(achievement)
    end
  end

  # aggiunta del banner
  #   achievement: obiettivo bersaglio
  def add_banner(achievement)
    RPG::ME.stop if H87_Achievements::PlayME
    play_sound
    @banner = Achievement_Graphic.new(achievement)
  end

  # esecuzione del suono
  def play_sound
    if H87_Achievements::PlayME
      RPG::ME.new(H87_Achievements::SE).play
    else
      RPG::SE.new(H87_Achievements::SE).play
    end
  end

  # aggiornamento
  def update
    if @banner != nil
      @banner.update
      next_banner if @banner.disappeared?
    end
  end

  # passa al prossimo banner
  def next_banner
    @banner.dispose
    if @waiting_list.size > 0
      add_banner(@waiting_list[0])
      @waiting_list.delete_at(0)
    else
      @banner = nil
    end
  end

  # nascondi tutti i banner
  def hide
    return if @banner == nil
    @waiting_list = []
    @banner.dispose
    @banner = nil
  end
end

#achievement_banner

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Aggiunta dei controlli per lo sblocco degli obiettivi
#==============================================================================
class Game_Party < Game_Unit
  # alias metodo gain_gold
  alias h87_Ach_gain_gold gain_gold unless $@

  def gain_gold(n)
    h87_Ach_gain_gold(n)
    gain_total_gold(n)
  end

  # alias metodo gain_item
  alias h87ach_gain_item gain_item unless $@

  def gain_item(item, n, include_equip = false)
    h87ach_gain_item(item, n, include_equip)
    gain_item_in_total(item, n) if n > 0 and item.is_a?(RPG::Item)
  end

  # aggiunge l'hash degli oggetti totali
  def gain_item_in_total(item, n)
    @total_items = {} if @total_items == nil
    @total_items[item.id] = 0 if @total_items[item.id] == nil
    @total_items[item.id] += n
    H87_Achievements.check(14, item.id)
  end

  # restituisce il totale di oggetti ottenuti
  def total_items(id)
    @total_items = {} if @total_items == nil
    return 0 if @total_items[id] == nil
    @total_items[id]
  end

  # restituisce l'oro totale ottenuto nel corso del gioco
  def total_gold
    @total_gold = 0 if @total_gold == nil
    @total_gold
  end

  # aggiunge l'oro al totale
  def gain_total_gold(n)
    @total_gold = 0 if @total_gold == nil
    @total_gold += n
    H87_Achievements.check(3)
    H87_Achievements.check(4)
  end

  # restituisce il max livello del gruppo escludendo alcuni personaggi
  def total_max_level
    $game_party.all_members.
        select{|actor| !H87_Achievements::ExludedMembers.include?(actor.id)}.
        collect{|actor| actor.level}.max
  end

  # alias metodo increase_steps per aggiungere un controllo
  alias h87ach_is increase_steps unless $@

  def increase_steps
    h87ach_is
    H87_Achievements.check(6)
  end

  # restituisce il totale speso nei negozi
  def total_gold_spent
    @total_gold_spent ||= 0
  end

  # aggiunge un valore al totale speso nei negozi
  def total_gold_spent=(n)
    @total_gold_spent = n
    H87_Achievements.check(11)
  end

  # restituisce le battaglie totali che ha effettuato il giocatore
  def total_battles
    @total_battles = 0 if @total_battles == nil
    @total_battles
  end

  # cambia le battaglie totali
  def total_battles=(n)
    @total_battles = 0 if @total_battles == nil
    @total_battles = n
    H87_Achievements.check(10)
  end

  # restituisce le vittorie totali del giocatore
  def total_victories
    @total_victories = 0 if @total_victories == nil
    @total_victories
  end

  # cambia le vittorie totali
  def total_victories=(n)
    @total_victories = 0 if @total_victories == nil
    @total_victories = n
  end

  # restituisce le fughe totali del giocatore
  def total_escapes
    @total_escapes = 0 if @total_escapes == nil
    @total_escapes
  end

  # cambia le fughe totali
  def total_escapes=(n)
    @total_escapes = n
  end

  # restituisce il denaro totale guadagnato vendendo oggetti
  def total_sell
    @total_sell ||= 0
  end

  # cambia il totale oggetti
  def total_sell=(n)
    @total_sell = n
    H87_Achievements.check(12)
  end

  # Restituisce il totale dei nemici uccisi
  def enemies_killed
    @enemies_killed ||= 0
  end

  # Restituisce il numero di un certo tipo di nemici uccisi
  def enemy_killed(enemy_id)
    @enemy_killed ||= {}
    @enemy_killed[enemy_id] = 0 unless @enemy_killed[enemy_id]
    @enemy_killed[enemy_id]
  end

  # Aggiunge un nemico ucciso
  def add_enemy_killed(enemy_id)
    @enemies_killed ||= 0
    @enemies_killed += 1
    @enemy_killed = {} if @enemy_killed.nil?
    @enemy_killed[enemy_id] = 0 if @enemy_killed[enemy_id].nil?
    @enemy_killed[enemy_id] += 1
    H87_Achievements.check(16)
    H87_Achievements.check(17)
  end

  # Restituisce il danno totale inflitto dal gruppo sui nemici
  def total_damage_dealed
    @total_damage_dealed ||= 0
  end

  # Aggiunge del danno al totale
  def add_damage_dealed(damage)
    @total_damage_dealed ||= 0
    @total_damage_dealed += damage
    H87_Achievements.check(18)
  end

  # Aggiunge la cura al totale
  def add_total_heal(heal)
    @total_heal = 0 if @total_heal.nil?
    @total_heal += heal
    H87_Achievements.check(22)
  end

  # Restituisce la cura totale
  def total_heal
    @total_heal = 0 if @total_heal.nil?
    @total_heal
  end
end

#game_party

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  Aggiunta controlli per il numero di salvataggi
#==============================================================================
class Game_System
  # aggiunge il controllo salvataggi al conteggio
  alias h87ach_on_before_save on_before_save unless $@

  def on_before_save
    h87ach_on_before_save
    H87_Achievements.check(7)
  end
end

#game_system

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  Controllo obiettivi quando si combatte
#==============================================================================
class Scene_Battle < Scene_Base
  # alias start per aumentare le battaglie totali
  alias h87ach_start start unless $@

  def start
    h87ach_start
    $game_party.total_battles += 1
  end

  # alias update_basic per l'aggiornamendo del popup in battaglia
  alias h87_ach_up_basic update_basic unless $@

  def update_basic
    h87_ach_up_basic
    update_ach_animat
  end
end

#scene_battle

#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Controllo obiettivi in battaglia
#==============================================================================
module BattleManager
  # noinspection RubyResolve
  class << self
    alias h87ach_process_victory process_victory
    alias h87ach_pe process_escape
    alias h87_ach_te turn_end
    alias h87_ach_setup setup
  end

  # alias inizio battaglia
  def self.setup(troop_id, can_escape = true, can_lose = false)
    h87_ach_setup(troop_id, can_escape, can_lose)
    @enemies_killed = 0
    @turn_damage = 0
  end

  # alias vittoria per aumentare le vittorie totali
  def self.process_victory
    h87ach_process_victory
    $game_party.total_victories += 1
    H87_Achievements.check(20)
    H87_Achievements.check(21)
    true
  end

  # alias fuga per aumentare le fughe totali
  def self.process_escape
    success = h87ach_pe
    $game_party.total_escapes += 1 if success
    return success
  end

  # aggiunta nemici uccisi nel turno
  def self.add_enemy_killed
    @enemies_killed += 1
  end

  # aggiunte il danno nel turno
  def self.add_turn_damage(damage)
    @turn_damage += damage
  end

  # restituisce i nemici uccisi nel turno
  def self.enemies_killed
    @enemies_killed
  end

  # restituisce il danno causato in un turno
  def self.turn_damage
    @turn_damage
  end

  # fine del turno
  def self.turn_end
    h87_ach_te
    H87_Achievements.check(20)
    H87_Achievements.check(21)
    @enemies_killed = 0
    @turn_damage = 0
  end
end #battlemanager

#==============================================================================
# ** Scene_Shop
#------------------------------------------------------------------------------
#  Controllo obiettivi sull'acquisto
#==============================================================================
class Scene_Shop < Scene_MenuBase
  alias h87ach_do_buy do_buy unless $@
  alias h87ach_do_sell do_sell unless $@
  # Alias dell'azione di acquisto
  def do_buy(number)
    h87ach_do_buy(number)
    $game_party.total_gold_spent += (number * buying_price)
  end

  #--------------------------------------------------------------------------
  # Alias della vendita
  #--------------------------------------------------------------------------
  def do_sell(number)
    h87ach_do_sell(number)
    $game_party.total_sell += (number * selling_price)
  end
end

#scene_shop

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  Aggiunta dei banner degli obiettivi
#==============================================================================
class Scene_Map < Scene_Base
  alias h87_ach_start start unless $@
  #--------------------------------------------------------------------------
  # Inizio
  #--------------------------------------------------------------------------
  def start
    h87_ach_start
    H87_Achievements.check(8)
    H87_Achievements.check(9)
  end
end

#scene_map

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  Controllo sul livello superiore
#==============================================================================
class Game_Actor < Game_Battler
  alias h87a_lu level_up unless $@
  # alias del metodo level_up per controllare gli obiettivi su livello
  def level_up
    h87a_lu
    H87_Achievements.check(5)
  end

  # conteggio morti
  def dead_count
    @dead_count = 0 if @dead_count.nil?
    @dead_count
  end

  # aggiunge una morte al conteggio
  def dead_count=(value)
    @dead_count = 0 if @dead_count.nil?
    @dead_count += value
    H87_Achievements.check(23)
  end
end

#game_actor

#==============================================================================
# ** Window_MenuCommand
#------------------------------------------------------------------------------
#  Aggiunta del comando Obiettivi
#==============================================================================
class Window_MenuCommand < Window_Command
  alias h87_ach_origc add_original_commands unless $@
  #--------------------------------------------------------------------------
  # aggiunta del comando
  #--------------------------------------------------------------------------
  def add_original_commands
    h87_ach_origc
    add_command(H87_Achievements::ACHVTEXT, :achievements) if ach_enabled
  end

  #--------------------------------------------------------------------------
  # restituisce se il comando obiettivi è abilitato
  #--------------------------------------------------------------------------
  def ach_enabled
    return false unless H87_Achievements::ShowMenu
    return false if H87_Achievements::MenuSw > 0 and !$game_switches[H87_Achievements::MenuSw]
    true
  end
end

#menucommand

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  Controllo al danneggiamento dei nemici
#==============================================================================
class Game_Battler < Game_BattlerBase
  alias h87_ach_die die unless $@
  alias h87_ach_execute_damage execute_damage unless $@
  #--------------------------------------------------------------------------
  # Alias metodo morte
  #--------------------------------------------------------------------------
  def die
    h87_ach_die
    if self.enemy?
      $game_party.add_enemy_killed(self.enemy_id)
      BattleManager.add_enemy_killed
    else
      self.dead_count += 1
    end
  end

  #--------------------------------------------------------------------------
  # Processo danno
  #--------------------------------------------------------------------------
  def execute_damage(user)
    h87_ach_execute_damage(user)
    if user.actor?
      if @result.hp_damage > 0 && self.enemy?
        H87_Achievements.check(19, @result.hp_damage)
        $game_party.add_damage_dealed(@result.hp_damage)
      end
      if @result.hp_damage < 0 && self.actor?
        H87_Achievements.check(22, @result.hp_damage * -1)
        $game_party.add_total_heal(@result.hp_damage * -1)
      end
    end
  end
end

#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  Aggiunta della schermata degli obiettivi nel menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  alias h87_ach_ccw create_command_window unless $@
  #--------------------------------------------------------------------------
  # Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    h87_ach_ccw
    @command_window.set_handler(:achievements, method(:command_achievements))
  end

  # metodo di passaggio alla schermata degli obiettivi
  def command_achievements
    $game_temp.achievements_from_title = false
    SceneManager.call(Scene_Achievements)
  end
end

#scenemenu

#==============================================================================
# ** Game_Options
#------------------------------------------------------------------------------
#  Aggiunta dell'opzione se è impostato lo script
#==============================================================================
if $imported["H87_Options"] && H87_Achievements::OPT_ENABLED
  hash = {:type => :switch, :text => H87_Achievements::OPT_TEXT,
          :help => H87_Achievements::OPT_HELP, :sw => H87_Achievements::OPT_SWITCH,
          :on => H87_Achievements::OPT_ON, :off => H87_Achievements::OPT_OFF,
          :default => true
  }
  H87Options.push_game_option(hash)
end