=begin
 ==============================================================================
  ■ Difficoltà di gioco di Holy87
      versione 1.0
      Difficoltà utente: ★
      Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
      lo script nei propri progetti, sia amatoriali che commerciali. Vietata
      l'attribuzione impropria.
 ==============================================================================
    Questo script permette di selezionare un livello di difficoltà del gioco.
    Puoi impostare quanti livelli di difficoltà desideri, cambiando probabilità
    di drop, esperienza, oro e parametri dei nemici. La difficoltà è salvata in
    una variabile di gioco, per cui puoi aggiungere condizioni nel gioco a
    seconda del livello di diffoltà scelto tramite semplici condizioni evento
    (ad esempio, puoi far comparire meno scrigni a livello difficile)
 ==============================================================================
  ■ Compatibilità
    Scene_Title -> alias command_new_game
                   alias create_command_window
                   alias start
 ==============================================================================
  ■ Installazione e istruzioni
    Installare questo script sotto Materials e prima del Main.
    Lo script è Plug&Play. Puoi modificare alcuni settaggi in basso, nella
    sezione CONFIGURAZIONE (in particolare, i livelli di difficoltà).
    Puoi specificare un nuovo livello di difficoltà aggiungendo nell'array un
    nuovo hash (gli hash sono valori nelle parentesi {}) con le seguenti
    caratteristiche:
    name: nome difficoltà (ad es. facile, normale, difficile)
    drop_rate: modifica la probabilità di drop (100 è normale, 200 doppio)
    exp_rate: modifica l'esperienza ottenuta in percentuale (come sopra)
    gold_rate: come sopra, ma per l'oro
    enemy_mhp: HP massimi del nemico
    enemy_mmp: MP massimi del nemico
    enemy_atk: attacco dei nemici
    enemy_def: difesa dei nemici
    enemy_mat: attacco magico dei nemici
    enemy_mdf: difesa magica dei nemici
    enemy_agi: agilità dei nemici
    enemy_luk: fortuna dei nemici
 ==============================================================================
=end


#==============================================================================
# ** CONFIGURAZIONE
#==============================================================================
module Game_Difficulty
  LEVELS = [
    {name: 'Facile', drop_rate: 80,
      enemy_mhp: 75,
      enemy_atk: 75,
      ememy_mat: 75,
      enemy_agi: 75
      },
    {name: 'Normale'}, #nessun'altra configurazione, normale
    {name: 'Difficile',
      drop_rate: 110,
      exp_rate: 110,
      gold_rate: 80,
      enemy_mhp: 125,
      enemy_atk: 125,
      enemy_def: 110,
      enemy_mat: 125,
      enemy_mdf: 110,
      enemy_luk: 125
    }
  ]
  #--------------------------------------------------------------------------
  # * Alcune impostazioni dello script
  #--------------------------------------------------------------------------
  # ID della variabile che memorizzerà la difficoltà scelta
  DIFFICULTY_VARIABLE = 50
  # Vuoi permettere al giocatore di modificare il livello di difficoltà dal
  # menu di gioco?
  SHOW_IN_SETTINGS = true
  # Vuoi mostrare i livelli di difficoltà selezionabili in un popup? (attiva
  # questa opzione se i livelli di difficoltà sono troppi per essere mostrati
  # in una sola riga)
  SHOW_POPUP = false
  # Vuoi mostrare la finestra di selezione livello di difficoltà all'avvio di
  # una nuova partita?
  SHOW_LEVEL_WINDOW = true
  # Livello di difficoltà predefinito
  DEFAULT_DIFFICULTY = 1 # normale
  #--------------------------------------------------------------------------
  # * Vocaboli
  #--------------------------------------------------------------------------
  # Nome del comando nelle opzioni di gioco
  DIFFICULTY_CMD = 'Difficoltà'
  # Testo d'aiuto comando nelle opzioni di gioco
  DIFFICULTY_HELP = 'Seleziona il livello di difficoltà.'
  # Testo d'aiuto nella selezione difficoltà sulla schermata del titolo
  SELECT_HELP = 'Seleziona il livello di difficoltà.'
end

#==============================================================================
# ** FINE CONFIGURAZIONE
#------------------------------------------------------------------------------
#                 - ATTENZIONE: NON MODIFICARE OLTRE! -
#==============================================================================


$imported = {} if $imported == nil
$imported['H87_Difficulty'] = 1.0
#==============================================================================
# ** Game_Difficulty
#------------------------------------------------------------------------------
#
#==============================================================================
module Game_Difficulty
  #--------------------------------------------------------------------------
  # * Returns the difficulties array
  # @return [Array]
  #--------------------------------------------------------------------------
  def self.get_difficulties
    LEVELS.collect {|lev| lev[:name]}
  end
  #--------------------------------------------------------------------------
  # * Option hash
  #--------------------------------------------------------------------------
  hash = {
      :type       => :variable,
      :text       => DIFFICULTY_CMD,
      :help       => DIFFICULTY_HELP,
      :var        => DIFFICULTY_VARIABLE,
      :values     => get_difficulties,
      :open_popup => SHOW_POPUP}
  #--------------------------------------------------------------------------
  # * Adding the setting to Game Options
  #--------------------------------------------------------------------------
  H87Options.push_game_option(hash) if SHOW_IN_SETTINGS && $imported['H87_Options']
end

$imported = {} if $imported.nil?
$imported['H87-GameDifficulty'] = 1.0
#==============================================================================
# ** Difficulty_Level
#------------------------------------------------------------------------------
# Contains informations for the difficulty settings
#==============================================================================
class Difficulty_Level
  attr_reader :name             # difficulty name
  attr_reader :exp_rate         # exp rate
  attr_reader :drop_rate        # drop rate
  attr_reader :gold_rate        # gold rate
  attr_reader :enemy_mhp_rate   # enemy max hp rate
  attr_reader :enemy_mmp_rate   # enemy max mp rate
  attr_reader :enemy_atk_rate   # enemy attack rate
  attr_reader :enemy_mat_rate   # enemy magic attack rate
  attr_reader :enemy_mdf_rate   # enemy magic defense rate
  attr_reader :enemy_def_rate   # enemy defense rate
  attr_reader :enemy_agi_rate   # enemy agi rate
  attr_reader :enemy_luk_rate   # enemy luck rate
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param[Hash] hash
  #--------------------------------------------------------------------------
  def initialize(hash)
    @name = hash[:name]
    @exp_rate = hash[:exp_rate] ? hash[:exp_rate] : 100
    @drop_rate = hash[:drop_rate] ? hash[:drop_rate] : 100
    @gold_rate = hash[:gold_rate] ? hash[:gold_rate] : 100
    @enemy_mhp_rate = hash[:enemy_mhp] ? hash[:enemy_mhp] : 100
    @enemy_mmp_rate = hash[:enemy_mmp] ? hash[:enemy_mmp] : 100
    @enemy_atk_rate = hash[:enemy_atk] ? hash[:enemy_atk] : 100
    @enemy_def_rate = hash[:enemy_def] ? hash[:enemy_atk] : 100
    @enemy_mat_rate = hash[:enemy_mat] ? hash[:enemy_mat] : 100
    @enemy_mdf_rate = hash[:enemy_mdf] ? hash[:enemy_mdf] : 100
    @enemy_agi_rate = hash[:enemy_agi] ? hash[:enemy_agi] : 100
    @enemy_luk_rate = hash[:enemy_luk] ? hash[:enemy_luk] : 100
  end
end

#==============================================================================
# ** Game_System
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Difficulty variable ID
  #--------------------------------------------------------------------------
  def difficulty_id
    $game_variables[Game_Difficulty::DIFFICULTY_VARIABLE]
  end
  #--------------------------------------------------------------------------
  # * Returns the current difficulty level
  # @return [Difficulty_Level]
  #--------------------------------------------------------------------------
  def current_difficulty
    hash = Game_Difficulty::LEVELS[difficulty_id]
    Difficulty_Level.new(hash)
  end
end

#==============================================================================
# ** Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  alias h87_gl_pb param_base unless $@
  alias h87_gl_gold gold unless $@
  alias h87_gl_exp exp unless $@
  alias h87_gl_dir drop_item_rate unless $@
  #--------------------------------------------------------------------------
  # * Changes param base adjusting to the difficulty level
  #--------------------------------------------------------------------------
  def param_base(param_id)
    h87_gl_pb(param_id) * adjust_difficulty(param_id) / 100
  end
  #--------------------------------------------------------------------------
  # * Gold
  #--------------------------------------------------------------------------
  def gold
    h87_gl_gold * $game_system.current_difficulty.gold_rate / 100
  end
  #--------------------------------------------------------------------------
  # * Exp
  #--------------------------------------------------------------------------
  def exp
    h87_gl_exp * $game_system.current_difficulty.exp_rate / 100
  end
  #--------------------------------------------------------------------------
  # * Drop item rate
  #--------------------------------------------------------------------------
  def drop_item_rate
    h87_gl_dir * ($game_system.current_difficulty.drop_rate / 100.0 + 1.0)
  end
  #--------------------------------------------------------------------------
  # * Param multiplier
  #--------------------------------------------------------------------------
  def adjust_difficulty(param_id)
    d_lev = $game_system.current_difficulty
    case param_id
      when 0; return d_lev.enemy_mhp_rate # mhp
      when 1; return d_lev.enemy_mmp_rate # mmp
      when 2; return d_lev.enemy_atk_rate # atk
      when 4; return d_lev.enemy_def_rate # def
      when 3; return d_lev.enemy_mat_rate # mat
      when 5; return d_lev.enemy_mdf_rate # mdf
      when 6; return d_lev.enemy_agi_rate # agi
      when 7; return d_lev.enemy_luk_rate # luk
      else;      return 100
    end
  end
end

#==============================================================================
# ** Window_DifficultySelect
#------------------------------------------------------------------------------
# Window for difficulty level selection
#==============================================================================
class Window_DifficultySelect < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object initialization
  #--------------------------------------------------------------------------
  def initialize
    make_command_list
    super(0, 0, 160, window_height)
    self.width = window_width
    create_contents
    update_placement
    refresh
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Update Window Position
  #--------------------------------------------------------------------------
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height * 1.6 - height) / 2
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    [[max_text + padding * 2 + 4, 160].max, Graphics.width].min
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @list.size
  end
  #--------------------------------------------------------------------------
  # * Draw item
  #--------------------------------------------------------------------------
  def draw_item(index)
    draw_text(item_rect(index), item(index).name, alignment)
  end
  #--------------------------------------------------------------------------
  # * Returns the current item (or indexed)
  # @param [Integer] index
  # @return [Difficulty_Level]
  #--------------------------------------------------------------------------
  def item(index = @index)
    @list[index]
  end
  #--------------------------------------------------------------------------
  # * Make command list
  #--------------------------------------------------------------------------
  def make_command_list
    @list = difficulty_levels
  end
  #--------------------------------------------------------------------------
  # * Difficulty levels array
  # @return [Array]
  #--------------------------------------------------------------------------
  def difficulty_levels
    Game_Difficulty::LEVELS.collect{|level| Difficulty_Level.new(level)}
  end
  #--------------------------------------------------------------------------
  # * Max lenght of the commands
  #--------------------------------------------------------------------------
  def max_text
    difficulty_levels.collect{|level| text_size(level.name).width}.max
  end
  #--------------------------------------------------------------------------
  # * Text alignment
  #--------------------------------------------------------------------------
  def alignment; 1; end
  #--------------------------------------------------------------------------
  # * Selects the default difficulty index
  #--------------------------------------------------------------------------
  def default_index; select(Game_Difficulty::DEFAULT_DIFFICULTY); end
end

#==============================================================================
# ** Window_LevelHelp
#------------------------------------------------------------------------------
# Help windows for difficulty selection in the title menu
#==============================================================================
class Window_LevelHelp < Window_Base
  #--------------------------------------------------------------------------
  # * Object initialization
  #--------------------------------------------------------------------------
  def initialize(y)
    super(0, y, 160, fitting_height(line_number))
    self.width = window_width
    center_window
    create_contents
    refresh
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Line number
  #--------------------------------------------------------------------------
  def line_number; 1; end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    [[text_size(text).width + padding * 2 + 4, 160].max, Graphics.width].min
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text(0, 0, contents_width, line_height, text, 1)
  end
  #--------------------------------------------------------------------------
  # * Text showed
  #--------------------------------------------------------------------------
  def text; Game_Difficulty::SELECT_HELP; end
  #--------------------------------------------------------------------------
  # * Center the window
  #--------------------------------------------------------------------------
  def center_window
    self.x = (Graphics.width - self.width)/2
    self.y = self.y - self.height
  end
end

#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
# Adding new window for difficulty selection when a new game occurs
#==============================================================================
class Scene_Title < Scene_Base
  alias h87gl_start start unless $@
  alias h87gl_create_command_window create_command_window unless $@
  alias h87gl_cng command_new_game unless $@
  #--------------------------------------------------------------------------
  # * Start process
  #--------------------------------------------------------------------------
  def start
    h87gl_start
    create_difficulty_window
  end
  #--------------------------------------------------------------------------
  # * Changing method if a level selection is active
  #--------------------------------------------------------------------------
  def create_command_window
    h87gl_create_command_window
    if level_select?
      @command_window.set_handler(:new_game, method(:command_difficulty))
    end
  end
  #--------------------------------------------------------------------------
  # * Difficulty window creation
  #--------------------------------------------------------------------------
  def create_difficulty_window
    @difficulty_window = Window_DifficultySelect.new
    @difficulty_window.set_handler(:ok, method(:command_new_game))
    @difficulty_window.set_handler(:cancel, method(:command_recall_title))
    @difficulty_help = Window_LevelHelp.new(@difficulty_window.y)
  end
  #--------------------------------------------------------------------------
  # * Difficulty selection
  #--------------------------------------------------------------------------
  def command_difficulty
    close_command_window
    @difficulty_window.default_index
    @difficulty_help.open
    @difficulty_window.open
    @difficulty_window.activate
  end
  #--------------------------------------------------------------------------
  # * Reactivates the command title window
  #--------------------------------------------------------------------------
  def command_recall_title
    close_level_window
    @command_window.open
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Close level window
  #--------------------------------------------------------------------------
  def close_level_window
    @difficulty_help.close
    @difficulty_window.close
    update until @difficulty_window.close?
  end
  #--------------------------------------------------------------------------
  # * Command new game
  #--------------------------------------------------------------------------
  def command_new_game
    close_level_window
    h87gl_cng
    var = Game_Difficulty::DIFFICULTY_VARIABLE
    if level_select?
      $game_variables[var] = @difficulty_window.index
    else
      $game_variables[var] = Game_Difficulty::DEFAULT_DIFFICULTY
    end
  end
  #--------------------------------------------------------------------------
  # * Determines if the selection must appear
  #--------------------------------------------------------------------------
  def level_select?
    Game_Difficulty::SHOW_LEVEL_WINDOW
  end
end