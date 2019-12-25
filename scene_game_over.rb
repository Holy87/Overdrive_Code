#==============================================================================
# ** GAME OVER
#------------------------------------------------------------------------------
# Questa schermata sovrascrive il gameover di default
#==============================================================================
module GO_Settings
  VOCABS = {
      :retry => 'Carica l\'ultimo salvataggio',
      :load  => 'Carica salvataggio',
      :exit  => 'Vai al Titolo',
      :death_on_map => 'Questa volta ti è andata male, ritenta!'
  }
  #--------------------------------------------------------------------------
  # * Consigli
  #--------------------------------------------------------------------------
  TIPS = [
      #---------------------------------------------------------------------|
      "Sfrutta gli elementi a tuo favore per ricaricare la Sinergia più velocemente.",
      "Infliggi stati alterati come Cecità, sui nemici specializzati nella forza bruta.",
      "Diminuisci l'intelligenza dei nemici più forti per semplificare le tattiche di battaglia.",
      "Fuggi se non ti senti in grado di sconfiggere i nemici!",
      "Cerca di caricare velocemente la Sinergia curando o attaccando su bersagli multipli.",
      "Usa scanner o abilità come Esamina per trovare i punti deboli dei nemici.",
      "I difensori hanno una gran capacità di assorbire i colpi, usa la loro Provocazione per difendere i più deboli.",
      "Usa Silenzio sui nemici che fanno uso di magie potenti.",
      "Indebolisci i nemici più forti con debuff come AntiDifesa o Lentezza.",
      "Usa le Dominazioni per aiutarti negli scontri più difficili.",
      "Pianifica gli accessori da equipaggiare prima di uno scontro importante.",
      "Metti abilità speciali sulle armi per avere un gran vantaggio in battaglia.",
      "Pezzi di armature dello stesso tipo danno diversi bonus.",
      "Usa le Dominazioni quando hai bisogno di supporto extra.",
      "Prepararsi prima della battaglia può essere una tattica vincente!",
      "Cambia i membri del gruppo per cambiare tattica, se non riesci a battere un boss.",
      "Potenzia le armi ed usa le armature in set per ottenere il massimo dal tuo equipaggiamento.",
      "Se i nemici sono immuni a Silenzio, potresti provare ad azzerare i loro PM...",
      "Mettici più impegno, cribbio!",
      "Sali di qualche livello, prima di affrontare un combattimento che non riesci a vincere.",
      "Procurati equipaggiamenti migliori per vincere le battaglie più difficili.",
      "Piazza personaggi con affinità elementali adeguate ad affrontare i boss specializzati su uno specifico elemento.",
      "Se i mostri in una zona sembrano troppo difficili per te, evitala. Probabilmente non è il momento di andarci.",
      "Prova a cambiare membri del gruppo per variare strategia.",
      "Non sempre l'equipaggiamento più potente è anche il migliore. Tieni conto anche delle loro abilità.",
      "Non attivare troppi Perk sulle Dominazioni, o dureranno troppo poco.",
      "Evoca una Dominazione durante la Sinergia, causerà danni devastanti!",
      "Non sprecare tutti i PM! Conservali per qualche boss a sorpresa.",
      "La Sinergia si carica più velocemente se i nemici sono numerosi.",
      "Spesso un'arma rara o leggendaria è più efficace di un'arma superiore, ma comune.",
      "Usa le barriere dei maghi per ridurre i danni che subiscono.",


  ]

  COMMAND_TIMER = 300 # dopo quanti frame appare la finestra dei comandi

  # file immagine per gli sprite
  TITLE_GRAPHIC = 'TitleGO'
  FOG_GRAPHIC = 'FOGG'
  LIGHT_GRAPHIC = 'lightarrow'
end

#==============================================================================
# ** Vocab
#==============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * comando ricarica
  # @return [String]
  #--------------------------------------------------------------------------
  def self.go_retry; GO_Settings::VOCABS[:retry]; end
  #--------------------------------------------------------------------------
  # * comando carica salvataggio
  # @return [String]
  #--------------------------------------------------------------------------
  def self.go_load; GO_Settings::VOCABS[:load]; end
  #--------------------------------------------------------------------------
  # * comando esci
  # @return [String]
  #--------------------------------------------------------------------------
  def self.go_exit; GO_Settings::VOCABS[:exit]; end
  #--------------------------------------------------------------------------
  # * messaggio di morte su mappa
  # @return [String]
  #--------------------------------------------------------------------------
  def self.go_map_death; GO_Settings::VOCABS[:go_map_death]; end
end

#==============================================================================
# ** Game_Temp
#==============================================================================
class Game_Temp
  # @return [Bitmap] battle_snapshot
  attr_accessor :battle_snapshot  # l'immagine prima del game over
  attr_accessor :last_in_battle   # se si muore su mappa o in battaglia
end

#==============================================================================
# ** Scene_Gameover
#------------------------------------------------------------------------------
# modifiche alla schermata orignale
#==============================================================================
class Scene_Gameover < Scene_Base
  include GO_Settings
  #--------------------------------------------------------------------------
  # * start
  #--------------------------------------------------------------------------
  def start
    super
    play_gameover_music
    fadeout_frozen_graphics
    create_background
    create_gameover_graphic
    create_tips_window
    create_gameover_command
    @counter = 0
    $game_temp.battle_snapshot = nil
  end
  #--------------------------------------------------------------------------
  # * update
  #--------------------------------------------------------------------------
  def update
    super
    update_gameover_graphic
    update_gameover_window
  end
  #--------------------------------------------------------------------------
  # * terminate
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
    dispose_gameover_graphic
    dispose_gameover_command
  end
  #--------------------------------------------------------------------------
  # * play gameover music
  #--------------------------------------------------------------------------
  def play_gameover_music
    RPG::BGM.stop
    RPG::BGS.stop
    $data_system.gameover_me.play
  end
  #--------------------------------------------------------------------------
  # * Fade Out Frozen Graphics
  #--------------------------------------------------------------------------
  def fadeout_frozen_graphics
    #Graphics.transition(fadeout_speed)
    Graphics.freeze
  end
  #--------------------------------------------------------------------------
  # * Execute Transition
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(fadein_speed)
  end
  #--------------------------------------------------------------------------
  # * crea la grafica del gameove
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = gameover_background
    @background_sprite.tone.set(-100, -100, -100, 255)
    @background_sprite.wave_length = 400
    @background_sprite.ox = Graphics.width/2
    @background_sprite.x = Graphics.width/2
  end
  #--------------------------------------------------------------------------
  # * crea lo sfondo del Game Over
  #--------------------------------------------------------------------------
  def gameover_background
    bitmap1 = $game_temp.battle_snapshot
    bitmap2 = Cache.picture("FrameGO")
    bitmap1.blt(0, 0, bitmap2, Rect.new(0,0,Graphics.width,Graphics.height),150)
    bitmap1
  end
  #--------------------------------------------------------------------------
  # * crea la grafica del Game Over
  #--------------------------------------------------------------------------
  def create_gameover_graphic
    @fog = Sprite.new
    @fog2 = Sprite.new
    @lucesup = Sprite.new
    @luceinf = Sprite.new
    @gameover_title = Sprite.new
    @gameover_title.bitmap = Cache.system(TITLE_GRAPHIC)
    @fog.bitmap = Cache.picture(FOG_GRAPHIC)
    @fog2.bitmap = Cache.picture(FOG_GRAPHIC)
    @lucesup.bitmap = Cache.system(LIGHT_GRAPHIC)
    @luceinf.bitmap = Cache.system(LIGHT_GRAPHIC)
    @fog.opacity = 0
    @fog2.opacity = 0
    @fog2.x = -640
    @gameover_title.opacity = 0
    @gameover_title.y = 100
    @lucesup.x = 640
    @lucesup.y = 95
    @luceinf.x = -640
    @luceinf.y = 221
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei comandi del gameover
  #--------------------------------------------------------------------------
  def create_gameover_command
    @gameover_command = Window_GOCommand.new
    @gameover_command.set_handler(:retry, method(:command_retry))
    @gameover_command.set_handler(:load, method(:command_load))
    @gameover_command.set_handler(:exit, method(:goto_title))
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei consigli
  #--------------------------------------------------------------------------
  def create_tips_window
    @tips_window = Window_GoHelp.new
    @tips_window.set_text(get_random_tip)
    @tips_window.opacity = 0
    @tips_window.contents_opacity = 0
    @tips_window.y = 380
    @black_sprite = Sprite.new
    @black_sprite.bitmap = generate_background_sprite
    @black_sprite.opacity = 100
    @black_sprite.x = @tips_window.x
    @black_sprite.y = @tips_window.y
  end
  #--------------------------------------------------------------------------
  # * ottiene lo sprite di sfondo dei consigli
  #--------------------------------------------------------------------------
  def generate_background_sprite
    bitmap = Bitmap.new(@tips_window.width, @tips_window.height)
    bitmap.fill_rect(0, 0, @tips_window.width, @tips_window.height, Color.new(0, 0, 0))
    bitmap
  end
  #--------------------------------------------------------------------------
  # * aggiorna la grafica del gameover
  #--------------------------------------------------------------------------
  def update_gameover_graphic
    if @counter < COMMAND_TIMER
      @counter += 2
      @background_sprite.wave_amp = @counter /38
    end
    @background_sprite.update
    @background_sprite.wave_amp += 1 if @background_sprite.wave_amp < 8
    @tips_window.contents_opacity += 2
    @fog.x += 1
    @fog2.x += 1
    if @fog.x >= 640
      @fog.x = -640
    end
    if @fog2.x >= 640
      @fog2.x = -640
    end
    if @fog.opacity < 50
      @fog.opacity += 1
      @fog2.opacity += 1
    end
    if @lucesup.x > 0
      @lucesup.x -= 4
      @luceinf.x += 4
    end
    if @lucesup.x == 0
      @gameover_title.opacity += 1
    end
  end
  #--------------------------------------------------------------------------
  # * aggiorna la fnestra del gameover
  #--------------------------------------------------------------------------
  def update_gameover_window
    @gameover_command.open if @counter >= COMMAND_TIMER / 2
    @gameover_command.update
  end
  #--------------------------------------------------------------------------
  # * ottiene un consiglio a caso
  #--------------------------------------------------------------------------
  def get_random_tip
    $game_temp.last_in_battle ? TIPS[rand(TIPS.size)] : Vocab.go_map_death
  end
  #--------------------------------------------------------------------------
  # * elimina tutta la grafica del gameover
  #--------------------------------------------------------------------------
  def dispose_gameover_graphic
    @fog.dispose
    @fog2.dispose
    @gameover_title.dispose
    @lucesup.dispose
    @luceinf.dispose
    @tips_window.dispose
    @black_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * elimina la finestra dei comandi
  #--------------------------------------------------------------------------
  def dispose_gameover_command
    @gameover_command.dispose
  end
  #--------------------------------------------------------------------------
  # * elimina lo sfondo
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * ricarica l'ultimo salvataggio
  #--------------------------------------------------------------------------
  def command_retry
    if DataManager.load_game(DataManager.last_savefile_index)
      on_load_success
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * vai alla schermata di caricamento
  #--------------------------------------------------------------------------
  def command_load
    snapshot_for_background
    $scene = Scene_File.new(false, false, false)
  end
  #--------------------------------------------------------------------------
  # * Transition to Title Screen
  #--------------------------------------------------------------------------
  def goto_title
    fadeout_all
    SceneManager.goto(Scene_Title)
  end
  #--------------------------------------------------------------------------
  # * Esegue quando il caricamento è riuscito
  #--------------------------------------------------------------------------
  def on_load_success
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * Get Fade Out Speed
  #--------------------------------------------------------------------------
  def fadeout_speed; 60; end
  #--------------------------------------------------------------------------
  # * Get Fade In Speed
  #--------------------------------------------------------------------------
  def fadein_speed; 120; end
end

#==============================================================================
# ** Window_GOCommand
#------------------------------------------------------------------------------
# mostra i comandi del gameover
#==============================================================================
class Window_GOCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Inizializzazione
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
  def window_width; 230; end
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
    add_command(Vocab.go_retry, :retry)
    add_command(Vocab.go_load, :load)
    add_command(Vocab.go_exit, :exit)
  end
end

#==============================================================================
# ** Window_GoHelp
#------------------------------------------------------------------------------
# mostra suggerimenti del game over
#==============================================================================
class Window_GoHelp < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    super(0,0,Graphics.width,fitting_height(3))
    @text = ''
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @text.nil?
    draw_formatted_text(0, 0, contents_width, @text)
  end
  #--------------------------------------------------------------------------
  # * imposta il nuovo testo
  #--------------------------------------------------------------------------
  def set_text(string)
    @text = string
    refresh
  end
end

#==============================================================================
# ** classe Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  alias go_terminate terminate unless $@
  #--------------------------------------------------------------------------
  # * aggiungi snapshot all'uscita
  #--------------------------------------------------------------------------
  def terminate
    $game_temp.battle_snapshot = Graphics.snap_to_bitmap
    $game_temp.last_in_battle = true
    go_terminate
  end
end

#==============================================================================
# ** classe Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  alias go_terminate terminate unless $@
  #--------------------------------------------------------------------------
  # * aggiungi snapshot all'uscita
  #--------------------------------------------------------------------------
  def terminate
    $game_temp.battle_snapshot = Graphics.snap_to_bitmap
    $game_temp.last_in_battle = false
    go_terminate
  end
end
