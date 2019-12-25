##===============================================================================
# LETTORE MUSICALE
#===============================================================================
# Autore: Holy87
# Versione: 1.0
# Difficoltà utente: ★
#-------------------------------------------------------------------------------
# Ascolta la musica nel gioco!
# Questo script può:
# ● Ascoltare un BGM sito nel gioco
# ● Ascoltare una canzone nella cartella Documenti\Nome Gioco\Musica
#   (se non c'è, verrà creata automaticamente)
# ● Modificare la musica della battaglia e la fanfara di vittoria
#-------------------------------------------------------------------------------
# Istruzioni:
# Copiare lo script sotto Materials, prima del Main. Impostare l'icona della
# musica in MUSIC_ICON.
#-------------------------------------------------------------------------------
# Compatibilità:
# ...poi vi spiego
#===============================================================================
#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  Testi per il menu
#==============================================================================
module Vocab
  # Testo d'aiuto quando si evidenzia musica del gioco
  JB_MUSIC = "Riproduci una musica del gioco."
  # Testo d'aiuto quando si evidenzia la musica personalizzata
  JB_CUSTM = "Riproduci una canzone situata in Documenti\\Overdrive\\Musica"
  # Testo che mostra la musica in riproduzione
  JB_PLAYN = "Attualmente in riproduzione: "
  # Testo d'aiuto quando si evidenzia ferma la musica
  JB_STOPM = "Ferma la musica personalizzata."
  # Testo d'aiuto quando si evidenzia musica di battaglia
  JB_BATTL = "Scegli una canzone per la battaglia."
  # Testo d'aiuto quando si evidenzia ME di vittoria
  JB_BATTM = "Scegli un motivo per la vittoria."
  # Testo d'aiuto per la musica battaglia o vittoria personalizzata
  JB_BTSEL = "Attualmente selezionata: "
  # Nessuna...
  JB_NONE  = "Nessuna."
  # Testo per l'impostazione della musica predefinita
  DEFAULTM = "Predefinita"
  # Comando riproduci musica
  MENU_PLAY_BGM = "Riproduci musica del gioco"
  # Comando riproduci musica personalizzata
  MENU_PLAY_MSC = "Riproduci musica personalizzata"
  # Comando di stop
  MENU_STOP_MSC = "Ferma la musica"
  # Comando di impostazione musica di battaglia
  MENU_CUST_BMS = "Imposta musica di battaglia"
  # Comando di imposta musica vittoria
  MENU_CUST_BME = "Imposta fanfara di vittoria"
  # Nome della cartella dove inserire la musica personale
  MUSICFOLDER = "Musica"
  # Descrizione dei comandi su mappa
  JB_CONTROLS = "Controlli nel gioco:"
  # Descrizione per fermare la musica
  JB_STOP_PLAY = "Stop/Riproduci"
  # Descrizione per avanzare con la musica
  JB_NEXT = "Prossimo brano"
  # Descrizione per indietreggiare con la musica
  JB_PREV = "Brano precedente"
  # Comando per fermare la musica
  JB_K_STOP = "Ctrl + A"
  # Comando per avanzare
  JB_K_NEXT = "Ctrl + Pag Giù"
  # Comando per brano recedente
  JB_K_PREV = "Ctrl + Pag Su"
end

#==============================================================================
# ** MusicManager
#------------------------------------------------------------------------------
#  Gestione della musica in riproduzione
#==============================================================================
module MusicManager
  #ICONA DELLA MUSICA
  MUSIC_ICON = 475

  module_function
  #--------------------------------------------------------------------------
  # * Riproduce la musica su mappa
  #     item: percorso della canzone
  #     bgm: false se è la musica del gioco, true altrimenti
  #--------------------------------------------------------------------------
  def play_music(item, bgm = false)
    $game_temp.map_bgm = RPG::BGM::last if $game_temp.playing_music.nil?
    RPG::Music.new(item).play
    $game_temp.playing_music = File.basename(item,".*")
    @last_play = $game_temp.playing_music
    $game_temp.playing_music_path = bgm ? bgm_path : get_music_path
  end
  #--------------------------------------------------------------------------
  # * Ferma la musica
  #--------------------------------------------------------------------------
  def stop_music
    RPG::BGM.stop
    $game_temp.playing_music = nil
    $game_temp.map_bgm.play unless $game_temp.map_bgm.nil?
  end
  #--------------------------------------------------------------------------
  # * Ottiene il percorso della musica personale
  #--------------------------------------------------------------------------
  def get_music_path
    path = Win.getFolderPath+"/"+$data_system.game_title+"/"+Vocab::MUSICFOLDER
    Dir.mkdir(path)  if !File.directory?(path)
    return path
  end
  #--------------------------------------------------------------------------
  # * Restituisce il percorso dei BGM del gioco
  #--------------------------------------------------------------------------
  def bgm_path
    return "./Audio/BGM"
  end
  #--------------------------------------------------------------------------
  # * Restituisce la lista della musica personale
  #--------------------------------------------------------------------------
  def get_music_list(path)
    music_array = []
    Dir.foreach(path) {|x|                  #per ogni file nel percorso
      next if x == "." or x == ".."       #passa al prossimo se è ind.
      file = path+"/"+x
      supported_formats = %w(.mp3 .ogg .mid .midi .wav)
      next if File.directory?(file)
      music_array.push(file) if supported_formats.include?(File.extname(file).downcase)
    }
    music_array
  end
  #--------------------------------------------------------------------------
  # * Restituisce la musica in riproduzione
  #     advance: avanzamento del brano
  #--------------------------------------------------------------------------
  def playing_music(advance = 0)
    music_list = get_music_list(get_music_path)
    play_order = 0
    unless @last_play.nil?
      for i in 0..music_list.size-1
        if File.basename(music_list[i],".*") == @last_play
          play_order = i
          break
        end
      end
    end
    play_order += advance
    play_order = 0 if play_order == music_list.size
    play_order = music_list.size - 1 if play_order < 0
    play_order
  end
  #--------------------------------------------------------------------------
  # * Riproduce la prossima canzone
  #--------------------------------------------------------------------------
  def play_next_song
    play_on_map(playing_music(1))
  end
  #--------------------------------------------------------------------------
  # * Riproduce la canzone precedente
  #--------------------------------------------------------------------------
  def play_previous_song
    play_on_map(playing_music(-1))
  end
  #--------------------------------------------------------------------------
  # * Riproduce la musica sulla mappa mostrando il popup
  #     play_order: ordine della canzone nell'elenco
  #--------------------------------------------------------------------------
  def play_on_map(play_order)
    Sound.play_load
    music_list = get_music_list(get_music_path)
    play_music(music_list[play_order], false)
    Popup.show($game_temp.playing_music, MUSIC_ICON)
  end
end #musicmanager

#==============================================================================
# ** Scene_JukeBox
#------------------------------------------------------------------------------
#  Questa schermata fa selezionare la musica.
#==============================================================================
class Scene_JukeBox < Scene_MenuBase
  include MusicManager
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_selection_window
    create_info_window
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra di comando
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = JukeBox_Command_Window.new(300, @help_window)
    @command_window.x = 0
    @command_window.y = @help_window.height
    @command_window.set_handler(:play_bgm, method(:set_bgm_path))
    @command_window.set_handler(:stop, method(:command_stop))
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra di selezione brano
  #--------------------------------------------------------------------------
  def create_selection_window
    x = @command_window.width
    y = @help_window.height
    w = Graphics.width - x
    h = Graphics.height - y
    @selection_window = Window_MusicSelect.new(x, y, w, h)
    @selection_window.set_handler(:ok, method(:music_select))
    @selection_window.set_handler(:cancel, method(:back_window))
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra di informazioni
  #--------------------------------------------------------------------------
  def create_info_window
    y = Graphics.height - 128
    @info_window = Window_JukeBox_Controls.new(0, y, @command_window.width)
  end
  #--------------------------------------------------------------------------
  # * Esecuzione del comando invio
  #--------------------------------------------------------------------------
  def command_ok
    if @command_window.active
      command_select
    else
      music_select
    end
  end
  #--------------------------------------------------------------------------
  # * Esecuzione del comando ESC
  #--------------------------------------------------------------------------
  def command_back
    Sound.play_cancel
    if @command_window.active
      back_scene
    else
      back_window
    end
  end

  def set_bgm_path

  end

  def set_music_path

  end

  def set_music_path_with_bg_change

  end

  #--------------------------------------------------------------------------
  # * Selezione del comando
  #--------------------------------------------------------------------------
  def command_select
    case @command_window.item
    when :play_bgm
      active_selection_window(bgm_path)
    when :play_music
      active_selection_window(get_music_path)
    when :battle_bgm, :battle_me
      active_selection_window(get_music_path, true)
    when :stop
      command_stop
    else
      # type code here
    end
  end
  #--------------------------------------------------------------------------
  # * Ferma la musica
  #--------------------------------------------------------------------------
  def command_stop
    Sound.play_decision
    stop_music if $game_temp.playing_music != nil
  end
  #--------------------------------------------------------------------------
  # * Attiva la finestra di selezione della canzone
  #     path: percorso della canzone
  #     gb_change: true se deve mostrare il comando "predefinito"
  #--------------------------------------------------------------------------
  def active_selection_window(path, gb_change = false)
    Sound.play_ok
    @command_window.active = false
    @selection_window.set_data(get_music_list(path), gb_change)
    @selection_window.active = true
  end
  #--------------------------------------------------------------------------
  # * Processo di selezione del brano evidenziato
  #--------------------------------------------------------------------------
  def music_select
    Sound.play_ok
    case @command_window.item
    when :play_bgm, :play_music
      start_play(@command_window.item == :play_bgm)
    when :battle_bgm
      set_battle_bgm
    when :battle_me
      set_battle_me
    else
      # type code here
    end
  end
  #--------------------------------------------------------------------------
  # * Inizia la riproduzione
  #     bgm: musica selezionata
  #--------------------------------------------------------------------------
  def start_play(bgm)
    play_music(@selection_window.item, bgm)
    back_window
  end
  #--------------------------------------------------------------------------
  # * Disattiva la finestra di selezione e torna ai comandi
  #--------------------------------------------------------------------------
  def back_window
    @selection_window.active = false
    @command_window.active = true
    @selection_window.set_data([])
    @selection_window.index = -1
  end
  #--------------------------------------------------------------------------
  # * Torna alla schermata precedente
  #--------------------------------------------------------------------------
  def back_scene
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # * Imposta il BGM di battaglia
  #--------------------------------------------------------------------------
  def set_battle_bgm
    if @selection_window.item == :default
      $game_system.custom_battle_music = nil
      $game_system.custom_battle_music_path = nil
    else
      $game_system.custom_battle_music = @selection_window.music_name
      $game_system.custom_battle_music_path = @selection_window.item
    end
    back_window
  end
  #--------------------------------------------------------------------------
  # * Imposta il ME di battaglia
  #--------------------------------------------------------------------------
  def set_battle_me
    if @selection_window.item == :default
      $game_system.custom_battle_end_me = nil
      $game_system.custom_battle_end_me_path = nil
    else
      $game_system.custom_battle_end_me = @selection_window.music_name
      $game_system.custom_battle_end_me_path = @selection_window.item
    end
    back_window
  end
end #scene_jukebox

#==============================================================================
# ** JukeBox_Command_Window
#------------------------------------------------------------------------------
#  Questa finestra viene mostrata all'interno di Scene_JukeBox e mostra i
#  comandi principali.
#==============================================================================
class JukeBox_Command_Window < Window_Command
  #-----------------------------------------------------------------------------
  # * inizializzazione
  #-----------------------------------------------------------------------------
  def initialize(width,help)
    create_list
    @item_max = @contents.size
    @help_window = help
    super(width,@contents)
    setup
  end
  #-----------------------------------------------------------------------------
  # * crezione del contenuto
  #-----------------------------------------------------------------------------
  def create_list
    @contents = [Vocab::MENU_PLAY_BGM, Vocab::MENU_PLAY_MSC, Vocab::MENU_STOP_MSC,
                 Vocab::MENU_CUST_BMS, Vocab::MENU_CUST_BME]
    @key = [:play_bgm, :play_music, :stop, :battle_bgm, :battle_me]
  end
  #-----------------------------------------------------------------------------
  # * settaggio
  #-----------------------------------------------------------------------------
  def setup
    refresh
    @index = 0
  end
  #--------------------------------------------------------------------------
  # * aggiornamento help
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(help_text)
  end
  #--------------------------------------------------------------------------
  # * restituisce il testo d'aiuto dell'oggetto
  #--------------------------------------------------------------------------
  def help_text
    case self.item
    when :play_bgm
      return Vocab::JB_MUSIC
    when :play_music
      return Vocab::JB_CUSTM
    when :stop
      return Vocab::JB_STOPM + selected_bgm
    when :battle_bgm
      return Vocab::JB_BATTL + battle_bgm
    when :battle_me
      return Vocab::JB_BATTM + battle_me
    else
      # type code here
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce la stringa della musica d'ambiente
  #--------------------------------------------------------------------------
  def selected_bgm
    tx = "|" + Vocab::JB_PLAYN
    if $game_temp.playing_music.nil?
      tx += RPG::BGM.last.name
    else
      tx += $game_temp.playing_music
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce la stringa del BGM di battaglia
  #--------------------------------------------------------------------------
  def battle_bgm
    return "" if $game_system.custom_battle_music.nil?
    "|" + Vocab::JB_BTSEL + $game_system.custom_battle_music
  end
  #--------------------------------------------------------------------------
  # * restituisce la stringa del me di vittoria
  #--------------------------------------------------------------------------
  def battle_me
    return "" if $game_system.custom_battle_end_me.nil?
    "|" + Vocab::JB_BTSEL + $game_system.custom_battle_end_me
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto
  #--------------------------------------------------------------------------
  def item
    @key[self.index]
  end
end  #jukebox_commandwindow

#==============================================================================
# ** Window_MusicSelect
#------------------------------------------------------------------------------
#  Questa finestra mostra l'elenco delle canzoni all'interno di Scene_JukeBox.
#==============================================================================
class Window_MusicSelect < Window_Selectable
  include MusicManager
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    self.active = false
    @data = []
    @column_max = 1
    self.index = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    return :default if @active_default && self.index == 0
    @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Imposta l'elenco delle canzoni
  #     data: array con le canzoni (percorso completo)
  #     active_default: true se aggiunge il comando default
  #--------------------------------------------------------------------------
  def set_data(data, active_default = false)
    @data = data
    @active_default = active_default
    @index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def refresh
    @data.unshift(Vocab::DEFAULTM) if @active_default
    @item_max = @data.size
    create_contents
    (0...@item_max).each { |i|
      draw_item(i)
    }
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  #     index: indice dell'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    item = File.basename(@data[index],".*")
    draw_icon(MUSIC_ICON, rect.x, rect.y)
    self.contents.draw_text(rect.x + 24, rect.y, rect.width-24, WLH, item)
  end
  #--------------------------------------------------------------------------
  # * Restituisce il nome della canzone
  #--------------------------------------------------------------------------
  def music_name
    return File.basename(self.item,".*")
  end
end #window_musicselect

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  Aggiunta degli attributi per la musica personalizzata in battaglia
#==============================================================================
class Game_System
  attr_accessor :custom_battle_music
  attr_accessor :custom_battle_music_path
  attr_accessor :custom_battle_end_me
  attr_accessor :custom_battle_end_me_path
  #--------------------------------------------------------------------------
  # * Restituisce il BGM di battaglia
  #--------------------------------------------------------------------------
  alias jb_battle_bgm battle_bgm unless $@
  def battle_bgm
    return get_custom_battle_music unless @custom_battle_music.nil?
    return jb_battle_bgm
  end
  #--------------------------------------------------------------------------
  # * Restituisce il ME di vittoria
  #--------------------------------------------------------------------------
  alias jb_battle_end_me battle_end_me unless $@
  def battle_end_me
    return get_custom_battle_end_me unless @custom_battle_end_me.nil?
    return jb_battle_end_me
  end
  #--------------------------------------------------------------------------
  # * Restituisce la musica di battaglia personalizzata
  #--------------------------------------------------------------------------
  def get_custom_battle_music
    return RPG::Music.new(@custom_battle_music_path)
  end
  #--------------------------------------------------------------------------
  # * Restituisce il ME personalizzato
  #--------------------------------------------------------------------------
  def get_custom_battle_end_me
    return RPG::CME.new(@custom_battle_end_me_path)
  end
end #game_system

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  Aggiunta degli attributi della musica in riproduzione
#==============================================================================
class Game_Temp
  attr_accessor :playing_music        #musica in ascolto
  attr_accessor :playing_music_path   #percorso della musica
  attr_accessor :map_bgm              #bgm della mappa non riprodotto e conserv.
end # game_temp

#==============================================================================
# ** RPG::Music
#------------------------------------------------------------------------------
#  A differenza di RPG::BGM, questa prende il file da un percorso nel PC
#==============================================================================
class RPG::Music < RPG::BGM
  #--------------------------------------------------------------------------
  # * Esecuzione della canzone
  #--------------------------------------------------------------------------
  def play
    Audio.bgm_play(@name, @volume, @pitch)
  end
  #--------------------------------------------------------------------------
  # * Disabilitazione del fade
  #--------------------------------------------------------------------------
  def self.fade(time)
  end
end # rpg::bgm

#==============================================================================
# ** RPG::CME
#------------------------------------------------------------------------------
#  A differenza di RPG::CME, questa prende il file da un percorso nel PC
#==============================================================================
class RPG::CME < RPG::ME
  #--------------------------------------------------------------------------
  # * Esecuzione della canzone
  #--------------------------------------------------------------------------
  def play
    Audio.bgm_play(@name, @volume, @pitch)
  end
end # rpg::me

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  Modifica dei metodi per il cambio musica
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * Cambia automaticamente BGM e BGS
  #--------------------------------------------------------------------------
  def autoplay
    if @map.autoplay_bgm
      @map.bgm.play if $game_temp.playing_music.nil?
      $game_temp.map_bgm = @map.bgm
    end
    @map.bgs.play if @map.autoplay_bgs
  end
end #game_map

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  Aggiunta dei controlli del lettore
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  alias jb_player_update update unless $@
  def update
    jb_player_update
    music_player_controls
  end
  #--------------------------------------------------------------------------
  # * Controlli dei comandi per gestire la musica in ascolto
  #--------------------------------------------------------------------------
  def music_player_controls
    return if $game_map.interpreter.running?
    MusicManager.play_next_song if Input.trigger?(Input::R) && Input.press?(Input::CTRL)
    MusicManager.play_previous_song if Input.trigger?(Input::L) && Input.press?(Input::CTRL)
    if Input.trigger?(Input::X) && Input.press?(Input::CTRL)
      if $game_temp.playing_music.nil?
        MusicManager.play_on_map(MusicManager.playing_music)
      else
        MusicManager.stop_music
      end
    end
  end
end # scene_map

#==============================================================================
# ** Window_JukeBox_Controls
#------------------------------------------------------------------------------
#  Finestra che mostra i comandi del lettore eseguibili su mappa
#==============================================================================
class Window_JukeBox_Controls < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, WLH*4+32)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.color = crisis_color
    self.contents.draw_text(0,0,contents.width, WLH,Vocab::JB_CONTROLS)
    self.contents.font.color = system_color
    self.contents.draw_text(0,WLH,contents.width, WLH,Vocab::JB_STOP_PLAY)
    self.contents.draw_text(0,WLH*2,contents.width, WLH,Vocab::JB_NEXT)
    self.contents.draw_text(0,WLH*3,contents.width, WLH,Vocab::JB_PREV)
    self.contents.font.color = normal_color
    self.contents.draw_text(0,WLH,contents.width, WLH,Vocab::JB_K_STOP,2)
    self.contents.draw_text(0,WLH*2,contents.width, WLH,Vocab::JB_K_NEXT,2)
    self.contents.draw_text(0,WLH*3,contents.width, WLH,Vocab::JB_K_PREV,2)
  end
end # fine dello script