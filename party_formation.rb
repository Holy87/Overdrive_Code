
require 'rm_vx_data' if false # you can delete this when the scirpt is complete

module FormationConfig
  # Colore di sfondo per eroi non selezionabili
  DISABLED_COLOR = Color.new(255, 0, 0, 128)
  # Colore di sfondo per eroi selezionati (da scambiare)
  SELECTED_COLOR = Color.new(0, 255, 0, 128)

  # Vocaboli
  ACTIVE_MEMBERS = 'Componenti attivi'
  STANDBY_MEMBERS = 'Riserve'
  VISTA_CHANGE = 'Cambia vista'
  GROUP_CHANGE = 'Cambia scheda'
end

#===============================================================================
# ** Vocab
#===============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Membri attivi
  #--------------------------------------------------------------------------
  def self.active_members; FormationConfig::ACTIVE_MEMBERS; end
  #--------------------------------------------------------------------------
  # * Membri in standby
  #--------------------------------------------------------------------------
  def self.standby_members; FormationConfig::STANDBY_MEMBERS; end
  #--------------------------------------------------------------------------
  # * Aiuto cambia vista
  #--------------------------------------------------------------------------
  def self.formation_vista_change; FormationConfig::VISTA_CHANGE; end
  #--------------------------------------------------------------------------
  # * Aiuto cambia gruppo
  #--------------------------------------------------------------------------
  def self.formation_group_change; FormationConfig::GROUP_CHANGE; end
end

#===============================================================================
# ** Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * L'eroe è fisso nel gruppo?
  #--------------------------------------------------------------------------
  def fixed?; fixed_member?; end
  #--------------------------------------------------------------------------
  # * L'eroe non può essere aggiunto al gruppo attivo?
  #--------------------------------------------------------------------------
  def unavaiable?; false; end
end

#===============================================================================
# ** Window_PartyMembers
#-------------------------------------------------------------------------------
# Finestra generica che mostra i membri del gruppo
#===============================================================================
class Window_PartyMembers < Window_Selectable
  attr_accessor :active_index # Indice selezionato dalla finestra
  #--------------------------------------------------------------------------
  # * Inizializzazione della finestra
  #--------------------------------------------------------------------------
  def intialize(x, y, height)
    make_actor_list
    super(x, y, window_width, height)
    @old_index = 0
    @active_index = nil
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto scelto
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = get_actor(index)
    return if actor.nil?
    rect = item_rect(index)
    enabled = actor_enabled?(index)
    if self.active_index == index
      contents.fill_rect(rect, FormationConfig::SELECTED_COLOR)
    elsif !enabled
      contents.fill_rect(rect, FormationConfig::DISABLED_COLOR)
    end
    draw_actor_face(actor, rect.x, rect.y, enabled)
    contents.color.alpha = enabled ? 255 : 128
    width = (rect.width - rect.x - 100) / 2
    draw_basic_info(actor, rect.x + 100, rect.y, width)
  end
  #--------------------------------------------------------------------------
  # * Disegna le informazioni principali
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def draw_basic_info(actor, x, y, width)
    draw_actor_name(actor, x, y, width)
    draw_actor_class(actor, x, y + line_height, width)
    draw_actor_level(actor, x, y + line_height * 2)
    draw_actor_state(actor, x, y + line_height * 3)
  end
  #--------------------------------------------------------------------------
  # * Disegna le informazioni su HP, MP, EXP ecc...
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def draw_life_info(actor, x, y, width)
    draw_actor_hp(actor, x, y, width)
    draw_actor_mp(actor, x, y + line_height, width)
    draw_actor_exp(actor, x, y + line_height * 2, width)
    draw_actor_jp(actor, x, y + line_height * 3, width)
  end

  def draw_actor_parameter

  end
  #--------------------------------------------------------------------------
  # * Definisce la larghezza della finestra (1/2 di schermo)
  #--------------------------------------------------------------------------
  def window_width; Graphics.width / 2; end
  #--------------------------------------------------------------------------
  # * Crea la lista degli eroi (definito nelle classi figlie)
  #--------------------------------------------------------------------------
  def make_actor_list; end
  #--------------------------------------------------------------------------
  # * Numero di oggetti
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 1 ; end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto puntato dal cursore
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def item; @data[@index]; end
  #--------------------------------------------------------------------------
  # * Determina se l'oggetto è abilitato allo spostamento
  #--------------------------------------------------------------------------
  def current_item_enabled?; actor_enabled?(@index); end
  #--------------------------------------------------------------------------
  # * L'eroe può essere spostato? (definito nelle classi figlie)
  #--------------------------------------------------------------------------
  def actor_enabled?(index); end
  #--------------------------------------------------------------------------
  # * Restituisce l'eroe all'indice scelto
  # @param [Integer] index
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def get_actor(index) @data[index]; end
  #--------------------------------------------------------------------------
  # * Altezza del cursore
  #--------------------------------------------------------------------------
  def item_height; line_height * 4; end
  #--------------------------------------------------------------------------
  # * Attivazione della finestra
  #--------------------------------------------------------------------------
  def activate
    super
    self.index = @old_index
  end
  #--------------------------------------------------------------------------
  # * Disattivazione della finestra
  #--------------------------------------------------------------------------
  def deactivate
    super
    @old_index = self.index
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Seleziona l'eroe
  #--------------------------------------------------------------------------
  def select_actor
    self.active_index = self.index
    redraw_current_item
    activate
  end
  #--------------------------------------------------------------------------
  # * Deseleziona l'eroe
  #--------------------------------------------------------------------------
  def unselect_actor
    return if self.active_index.nil?
    old_active = self.active_index
    self.active_index = nil
    redraw_item(old_active)
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della finestra
  #--------------------------------------------------------------------------
  def refresh
    make_actor_list
    super
  end
end

#===============================================================================
# ** Window_ActiveMembers
#-------------------------------------------------------------------------------
# Finestra che mostra l'elenco dei membri attivi in battaglia
#===============================================================================
class Window_ActiveMembers < Window_PartyMembers
  #--------------------------------------------------------------------------
  # * Ottiene la lista degli eroi da quelli in campo
  #--------------------------------------------------------------------------
  def make_actor_list; @data = $game_party.battle_members; end
  #--------------------------------------------------------------------------
  # * L'eroe può essere spostato?
  #--------------------------------------------------------------------------
  def actor_enabled?(index); get_actor(index).fixed?; end
end

#===============================================================================
# ** Window_ReserveMembers
#-------------------------------------------------------------------------------
# Finestra che mostra l'elenco dei membri in riserva
#===============================================================================
class Window_ReserveMembers < Window_PartyMembers
  #--------------------------------------------------------------------------
  # * Ottiene la lista degli eroi da quelli in riserva
  #--------------------------------------------------------------------------
  def make_actor_list; @data = $game_party.stand_by_members; end
  #--------------------------------------------------------------------------
  # * L'eroe può essere spostato?
  #--------------------------------------------------------------------------
  def actor_enabled?(index); get_actor(index).unavaiable?; end
end

#===============================================================================
# ** Window_Dummy
#-------------------------------------------------------------------------------
# Una semplice finestra che mostra semplice testo centrato e giallo
#===============================================================================
class Window_Dummy < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, fitting_height(1))
  end
  #--------------------------------------------------------------------------
  # * Imposta il testo
  #--------------------------------------------------------------------------
  def set_text(text)
    return if @text == text
    @text = text
    contents.clear
    change_color(crisis_color)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end
end

#==============================================================================
# ** Window_FormationHelp
#------------------------------------------------------------------------------
# Mostra i comandi per fare cose
#==============================================================================
class Window_FormationHelp < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Larghezza della finestra
  #--------------------------------------------------------------------------
  def window_width; Graphics.width; end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    width = contents_width / 2
    draw_vista_help(0, 0, width)
    draw_change_help(width, 0, width)
  end
  #--------------------------------------------------------------------------
  # * Disegna il comando equip
  #--------------------------------------------------------------------------
  def draw_vista_help(x, y, width)
    draw_key_icon(:X, x, y)
    draw_text(x + 24, y, width - 24, line_height, Vocab.formation_vista_change)
  end
  #--------------------------------------------------------------------------
  # * Disegna il comando eroi
  #--------------------------------------------------------------------------
  def draw_change_help(x, y, width)
    draw_key_icon(:LEFT, x, y)
    draw_key_icon(:RIGHT, x + 24, y)
    draw_text(x + 48, y, width - 48, line_height, Vocab.formation_group_change)
  end
end

#===============================================================================
# ** Scene_PartyFormation
#-------------------------------------------------------------------------------
# Schermata del cambio di formazione
#===============================================================================
class Scene_PartyFormation < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Processo iniziale
  #--------------------------------------------------------------------------
  def start
    super
    @selected_actor = nil
    @selected_actor_window = nil
    create_description_windows
    create_command_help_window
    create_active_members_window
    create_reserve_members_window
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei membri attivi
  #--------------------------------------------------------------------------
  def create_active_members_window
    y = @left_window.bottom_corner
    height = Graphics.height - y - @command_help_window.height
    width = Graphics.width / 2
    @active_members_window = Window_ActiveMembers.new(0, y, width, height)
    @active_members_window.activate
    @active_members_window.set_handler(:right, method(:pass_on_right))
    @active_members_window.set_handler(:cancel, method(:on_cancel))
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei membri in stand-by
  #--------------------------------------------------------------------------
  def create_reserve_members_window
    y = @right_window.bottom_corner
    height = Graphics.height - y - @command_help_window.height
    width = Graphics.width / 2
    @reserve_members_window = Window_ReserveMembers.new(width, y, width, height)
    @reserve_members_window.set_handler(:left, method(:pass_on_left))
    @reserve_members_window.set_handler(:cancel, method(:on_cancel))
  end
  #--------------------------------------------------------------------------
  # * Creazione delle finestre di descrizione
  #--------------------------------------------------------------------------
  def create_description_windows
    width = Graphics.width / 2
    @left_window = Window_Dummy.new(0, 0, width)
    @right_window = Window_Dummy.new(width, 0, width)
    @left_window.set_text(Vocab.active_members)
    @right_window.set_text(Vocab.standby_members)
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei tasti
  #--------------------------------------------------------------------------
  def create_command_help_window
    @command_help_window = Window_FormationHelp.new(0, 0)
    @command_help_window.y = Graphics.height - @command_help_window.height
  end
  #--------------------------------------------------------------------------
  # * Su selezione di un eroe
  #--------------------------------------------------------------------------
  def on_actor_selection
    if @selected_actor.nil?
      active_window.select_actor
      @selected_actor = active_window.item
      @selected_actor_window = active_window
    else
      exchange_members
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def on_cancel
    if @selected_actor
      @selected_actor_window.unselect_actor
      @selected_actor = nil
      @selected_actor_window = nil
    else
      return_scene
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def exchange_members

  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def pass_on_left
    @active_members_window.activate
    @reserve_members_window.deactivate
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def pass_on_right
    @active_members_window.deactivate
    @reserve_members_window.activate
  end
  #--------------------------------------------------------------------------
  # * Restituisce la finestra attiva
  # @return [Window_PartyMembers]
  #--------------------------------------------------------------------------
  def active_window
    return @active_members_window if @active_members_window.active
    @reserve_members_window
  end

  def on_vista_change

  end
end