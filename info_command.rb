#===============================================================================
# ** Vocab
#===============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Comando bestiario
  #--------------------------------------------------------------------------
  def self.bestiary; 'Bestiario'; end
  #--------------------------------------------------------------------------
  # * Comando Manuale di gioco
  #--------------------------------------------------------------------------
  def self.manual; 'Manuale'; end
  #--------------------------------------------------------------------------
  # * Comando oggettario
  #--------------------------------------------------------------------------
  def self.item_wiki; 'Oggettario'; end
  #--------------------------------------------------------------------------
  # * comando per aprire le guide
  #--------------------------------------------------------------------------
  def self.wiki; 'Wiki'; end
  #--------------------------------------------------------------------------
  # * comando mappa
  #--------------------------------------------------------------------------
  def self.worldmap; 'Mappa'; end
  #--------------------------------------------------------------------------
  # * comando Alchimia
  #--------------------------------------------------------------------------
  def self.alchemy_command; $data_skills[339].name; end
  #--------------------------------------------------------------------------
  # * comando Sintetizza
  #--------------------------------------------------------------------------
  def self.synthetize_command; $data_skills[358].name; end
  #--------------------------------------------------------------------------
  # * comando Elabora
  #--------------------------------------------------------------------------
  def self.elaborate_command; 'Elabora'; end
end

#===============================================================================
# ** Vocab
#===============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Determina se ha il bestiario
  #--------------------------------------------------------------------------
  def has_bestiary?; has_item?($data_items[154]); end
  #--------------------------------------------------------------------------
  # * Determina se ha un oggettario
  #--------------------------------------------------------------------------
  def has_item_wiki?; has_item?($data_items[110]); end
  #--------------------------------------------------------------------------
  # * Determina se ha una guida
  #--------------------------------------------------------------------------
  def has_guide?; has_item?($data_items[107]); end
  #--------------------------------------------------------------------------
  # * Determina il party ha la mappa del mondo
  #--------------------------------------------------------------------------
  def has_worldmap?; has_item?($data_items[153]); end
  #--------------------------------------------------------------------------
  # * Determina se ha una wiki
  #--------------------------------------------------------------------------
  def has_any_wiki?
    has_bestiary? || has_guide? || has_item_wiki? || has_worldmap?
  end
  #--------------------------------------------------------------------------
  # * Il gruppo può usare l'alchimia?
  #--------------------------------------------------------------------------
  def use_alchemy?
    alchemist_present? and alchemist.skill_learn?($data_skills[339])
  end
  #--------------------------------------------------------------------------
  # * Il gruppo può scomporre oggetti?
  #--------------------------------------------------------------------------
  def use_synthetize?
    alchemist_present? and alchemist.skill_learn?($data_skills[358])
  end
  #--------------------------------------------------------------------------
  # * Il gruppo può elaborare cose?
  #--------------------------------------------------------------------------
  def has_any_elaborate?; use_alchemy? or use_synthetize?; end
end

#===============================================================================
# ** Window_HelpCommand
#-------------------------------------------------------------------------------
# Finestra che raccoglie le voci di guida
#===============================================================================
class Window_HelpCommnad < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  # @return [Integer]
  #--------------------------------------------------------------------------
  def window_width; 160; end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab.bestiary, :bestiary) if bestiary_active?
    add_command(Vocab.item_wiki, :item_w) if item_wiki_active?
    add_command(Vocab.manual, :manual) if guide_active?
    add_command(Vocab.worldmap, :map) if worldmap_active?
  end
  #--------------------------------------------------------------------------
  # * Determina se il comando bestiario è attivo
  #--------------------------------------------------------------------------
  def bestiary_active?; $game_party.has_bestiary?; end
  #--------------------------------------------------------------------------
  # * Determina se il comando oggettario è attivo
  #--------------------------------------------------------------------------
  def item_wiki_active?; $game_party.has_item_wiki?; end
  #--------------------------------------------------------------------------
  # * Determina se il comando guida è attivo
  #--------------------------------------------------------------------------
  def guide_active?; $game_party.has_guide?; end
  #--------------------------------------------------------------------------
  # * Determina se la mappa del mondo è visibile
  #--------------------------------------------------------------------------
  def worldmap_active?; $game_party.has_worldmap?; end
end

#===============================================================================
# ** Window_ElaborateCommand
#-------------------------------------------------------------------------------
# Finestra che raccoglie le voci di lavorazione oggetti
#===============================================================================
class Window_ElaborateCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super
    self.openness = 0
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  # @return [Integer]
  #--------------------------------------------------------------------------
  def window_width; 160; end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab.alchemy_command, :alchemy) if alchemy_active?
    add_command(Vocab.synthetize_command, :synth) if synthetis_active?
  end
  #--------------------------------------------------------------------------
  # * determina se si può mostrare il comando Alchimia
  #--------------------------------------------------------------------------
  def alchemy_active?; $game_party.use_alchemy?; end
  #--------------------------------------------------------------------------
  # * Determina se si può mostrare il comando Sintetizza
  #--------------------------------------------------------------------------
  def synthetis_active?; $game_party.use_synthetize?; end
end

#===============================================================================
# ** Scene_Menu
#===============================================================================
class Scene_Menu < Scene_Base
  alias wiki_start start unless $@
  alias wiki_create_command_window create_command_window unless $@
  alias wiki_terminate terminate unless $@
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    wiki_start
    create_wiki_window
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra dei comandi
  #--------------------------------------------------------------------------
  def create_command_window
    wiki_create_command_window
    @command_window.set_handler(:wiki, method(:wiki_selection))
    @command_window.set_handler(:elaborate, method(:elaborate_selection))
  end
  #--------------------------------------------------------------------------
  # * Elimina la finestra dei comandi
  #--------------------------------------------------------------------------
  def terminate
    wiki_terminate
    @wiki_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra d'aiuto
  #--------------------------------------------------------------------------
  def create_wiki_window
    index = @command_window.symbol_index(:wiki)
    if index
      rect = @command_window.get_absolute_rect(index)
      x = rect.x
      y = rect.y
    else
      x = 0
      y = 0
    end
    @wiki_window = Window_HelpCommnad.new(x, y)
    @wiki_window.z = @command_window.z + 10
    @wiki_window.set_handler(:bestiary, method(:command_bestiary))
    @wiki_window.set_handler(:item_w, method(:command_item_wiki))
    @wiki_window.set_handler(:manual, method(:command_manual))
    @wiki_window.set_handler(:map, method(:command_worldmap))
    @wiki_window.set_handler(:cancel, method(:wiki_cancel))
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra Elaborazioni
  #--------------------------------------------------------------------------
  def create_elaborate_window
    index = @command_window.symbol_index(:elaborate)
    if index
      rect = @command_window.get_absolute_rect(index)
      x = rect.x
      y = rect.y
    else
      x = 0
      y = 0
    end
    @elaborate_window = Window_ElaborateCommand.new(x, y)
    @elaborate_window.z = @command_window.z + 10
    @elaborate_window.set_handler(:alchemy, method(:command_alchemy))
    @elaborate_window.set_handler(:synth, method(:command_synthetize))
    @elaborate_window.set_handler(:cancel, method(:elaborate_cancel))
  end
  #--------------------------------------------------------------------------
  # * Chiude la finestra d'aiuto
  #--------------------------------------------------------------------------
  def wiki_cancel
    @wiki_window.close
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Apre la finestra d'aiuto
  #--------------------------------------------------------------------------
  def wiki_selection
    @wiki_window.open
    @wiki_window.activate
  end
  #--------------------------------------------------------------------------
  # * Apre il bestiario
  #--------------------------------------------------------------------------
  def command_bestiary
    SceneManager.call(Scene_Bestiary)
  end
  #--------------------------------------------------------------------------
  # * Apre l'oggettario
  #--------------------------------------------------------------------------
  def command_item_wiki
    SceneManager.call(Scene_Itempedia)
  end
  #--------------------------------------------------------------------------
  # * Apre il manuale
  #--------------------------------------------------------------------------
  def command_manual
    SceneManager.call(Scene_Guide)
  end
  #--------------------------------------------------------------------------
  # * Apre la worldmap
  #--------------------------------------------------------------------------
  def command_worldmap
    SceneManager.call(Scene_Worldmap)
  end
  #--------------------------------------------------------------------------
  # * Apre la finestra Alchimia
  #--------------------------------------------------------------------------
  def command_alchemy
    SceneManager.call(Scene_Alchemy)
  end
  #--------------------------------------------------------------------------
  # * Apre la finestra Sintetizza
  #--------------------------------------------------------------------------
  def command_synthetize
    SceneManager.call(Scene_Synthetize)
  end
  #--------------------------------------------------------------------------
  # * Seleziona Elabora dal menu
  #--------------------------------------------------------------------------
  def elaborate_selection
    @elaborate_window.open
    @elaborate_window.activate
  end
  #--------------------------------------------------------------------------
  # * Chiude la finestra di elaborazione
  #--------------------------------------------------------------------------
  def elaborate_cancel
    @elaborate_window.close
    @command_window.activate
  end
end

#===============================================================================
# ** Window_MenuCommand
#===============================================================================
class Window_MenuCommand < Window_Command
  alias wiki_create_commands add_original_commands unless $@
  #--------------------------------------------------------------------------
  # * Aggiunge il comando Wiki (se ha almeno uno dei tre oggetti)
  #--------------------------------------------------------------------------
  def add_original_commands
    wiki_create_commands
    add_command(Vocab.elaborate_command, :elaborate, true, :arrow) if $game_party.has_any_elaborate?
    add_command(Vocab.wiki, :wiki, true, :arrow) if $game_party.has_any_wiki?
  end
end