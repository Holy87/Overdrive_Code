module FormationConfig
  # Icona quando un personaggio non può essere cambiato
  LOCKED_ICON = 1248

  # Vocaboli
  ACTIVE_MEMBERS = 'Componenti attivi'
  STANDBY_MEMBERS = 'Riserve'
  VISTA_CHANGE = 'Cambia vista'
  GROUP_CHANGE = 'Cambia scheda'
  PARTYFORM_COMMAND = 'Formazione'

  # Numero di membri predefinito per la battaglia
  DEFAULT_BATTLE_MEMBERS = 4

  # Switch per disabilitare la Formazione
  PARTYFORM_DISABLE_SWITCH = 113

  # Switch per far comparire il comando Formazione dal Menu
  PARTYFORM_UNLOCKED_SWITCH = 70

  # Puoi cambiare formazione in tutte le mappe?
  PARTYFORM_IN_ALL_MAPS = false

  # Nel caso la formazione sia disabilitata in tutte le mappe, in quali
  # è possibile cambiare gruppo?
  PARTYFORM_ENABLED_MAPS = [1]

  # Le riserve possono usare le abilità dal menu?
  USE_SKILL_RESERVE = false

  # Il comando "Recupero totale" al gruppo comprende anche le riserve?
  RECOVERY_ALL_PARTY = true

  # Il comando "Aggiungi esperienza" al gruppo comprende anche le riserve?
  ADD_EXP_PARTY = true

  # La percentuale di esperienza che acquisiscono i membri del gruppo
  # quando non partecipano alle battaglie
  STANDBY_BATTLE_EXP_RATE = 60
end

#===============================================================================
# ** Vocab
#===============================================================================
module Vocab
  # Membri attivi
  def self.active_members;
    FormationConfig::ACTIVE_MEMBERS;
  end

  # Membri in standby
  def self.standby_members;
    FormationConfig::STANDBY_MEMBERS;
  end

  # Aiuto cambia vista
  def self.formation_vista_change;
    FormationConfig::VISTA_CHANGE;
  end

  # Aiuto cambia gruppo
  def self.formation_group_change;
    FormationConfig::GROUP_CHANGE;
  end

  def self.partyform_command
    FormationConfig::PARTYFORM_COMMAND
  end
end

#===============================================================================
# ** Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  alias h87_pf_skill_can_use skill_can_use? unless $@

  # restituisce la posizione nel gruppo
  def party_index
    $game_party.all_members.index(self)
  end

  # determina se è un membro attivo del gruppo
  def battle_member?
    $game_party.battle_members.include?(self)
  end

  # determina se è un membro fisso del gruppo (che non può essere cambiato)
  def fixed_member?
    $game_party.fixed_members.include?(self)
  end

  # determina se non può essere messo in battaglia
  def disabled_member?
    $game_party.disabled_members.include?(self)
  end

  # determina se può usare una determinata abilità
  # @param [RPG::Skill] skill
  def skill_can_use?(skill)
    return false unless (battle_member? || FormationConfig::USE_SKILL_RESERVE)
    h87_pf_skill_can_use(skill)
  end
end

class Game_Temp
  # flag per forzare members a restituire tutti i membri
  attr_accessor :force_reserve_members
end

#===============================================================================
# ** Game_Party
#===============================================================================
class Game_Party < Game_Unit
  attr_accessor :max_battle_member_count

  alias h87_formation_initialize initialize unless $@
  def initialize
    h87_formation_initialize
    @max_battle_member_count = FormationConfig::DEFAULT_BATTLE_MEMBERS
    @fixed_actors = []
  end

  # i membri del gruppo in riserva
  # @return [Array<Game_Actor>]
  def stand_by_members
    all_members[max_battle_members, 99].select { |actor| actor.exist? }
  end

  # @return [Integer]
  def max_battle_members
    @max_battle_member_count ||= FormationConfig::DEFAULT_BATTLE_MEMBERS
  end

  # alias del metodo
  alias max_battle_member_count max_battle_members unless $@

  # @param [Game_Actor] member1
  # @param [Game_Actor] member2
  def switch_members(member1, member2)
    return if member1 == member2
    swap_order(member1.party_index, member2.party_index)
  end

  def only_active_members?
    return true if $game_temp.in_battle
    return true if SceneManager.scene.is_a?(Scene_Map)
    false
  end

  # i membri del gruppo che non possono essere rimossi
  # @return [Array<Game_Actor>]
  def fixed_members
    @fixed_actors ||= []
    @fixed_actors.collect { |actor_id| $game_actors[actor_id] }
  end

  # aggiunge un membro tra quelli attivi nel gruppo
  # @param [Integer] actor_id
  # @param [Integer] index
  def add_battle_member(actor_id, index = nil)
    return unless @actors.include?(actor_id)
    if index.nil?
      return if battle_members.include?($game_actors[actor_id])
      return if battle_members.size >= max_battle_members # non serve granché
      index = battle_members.size
    end

    @actors.delete(actor_id)
    @actors.insert(index, actor_id)
  end

  # rende un personaggio fisso o meno.
  # Se il personaggio non è presente nel gruppo, lo aggiunge.
  # Se il personaggio non è tra i membri attivi, lo aggiunge
  # sostituendo l'ultimo presente.
  def fix_actor(actor_id, fixed = false)
    fixed ? apply_fix_actor(actor_id) : unfix_actor(actor_id)
  end

  def apply_fix_actor(actor_id)
    return if @fixed_actors.include? actor_id
    @fixed_actors.push(actor_id)
    unless battle_members.include?(actor_id)
      removable = battle_members.select { |member| !member.fixed_member?}.last
      return if removable.nil?
      @actors.delete(actor_id)
      @actors.insert(removable.party_index, actor_id)
    end
  end

  def unfix_actor(actor_id)
    @fixed_actors.delete(actor_id)
  end

  # per compatibilità con il vecchio KGC
  def set_max_battle_member_count(new_value)
    @max_battle_member_count = new_value
  end

  def full?
    @actors.size >= @max_battle_member_count
  end

  def reserve_exp_rate
    FormationConfig::STANDBY_BATTLE_EXP_RATE / 100.0
  end

end

#===============================================================================
# ** Window_PartyMembers
#-------------------------------------------------------------------------------
# Finestra generica che mostra i membri del gruppo
#===============================================================================
class Window_PartyMembers < Window_Selectable
  attr_accessor :active_index # Indice selezionato dalla finestra
  # Inizializzazione della finestra
  def initialize(x, y, height = window_height)
    make_item_list
    super(x, y, window_width, height)
    refresh
    @old_index = 0
    @active_index = nil
  end

  # reimposta la finestra
  def reset
    make_item_list
    unselect_actor
    refresh
  end

  def window_height
    fitting_height(16)
  end

  # Disegna l'oggetto scelto
  def draw_item(index)
    actor = get_actor(index)
    return if actor.nil?
    rect = item_rect(index)
    enabled = enable? actor
    if @active_index == index
      contents.fill_rect(rect, pending_color)
    elsif !enabled
      #contents.fill_rect(rect, knockout_color.deopacize(50))
    end
    draw_actor_face(actor, rect.x, rect.y, enabled)
    contents.font.color.alpha = enabled ? 255 : 128

    draw_actor_level(actor, rect.x, rect.y)
    draw_gauge(rect.x, rect.y + 86, 96, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    if actor.charge_gauge?
      draw_gauge(rect.x, rect.y + 91, 96, actor.anger_rate, anger_gauge_color1, anger_gauge_color2)
    else
      draw_gauge(rect.x, rect.y + 91, 96, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    end

    width = (rect.width - rect.x - 100)
    draw_actor_extra_info(actor, rect.x + 100, rect.y, width)
    #draw_actor_parameter(actor, rect.x + 100, rect.y, width)
    # draw_basic_info(actor, rect.x + 100, rect.y, width)
    draw_icon(FormationConfig::LOCKED_ICON, rect.x + 68, rect.y) unless enabled
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Float] rate
  # @param [Color] color1
  # @param [Color] color2
  def draw_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    contents.fill_rect(x, y, width, 5, gauge_back_color)
    contents.gradient_fill_rect(x, y, fill_w, 5, color1, color2)
  end

  # Disegna le informazioni principali
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_basic_info(actor, x, y, width)
    draw_actor_name(actor, x, y, width)
    draw_actor_class(actor, x, y + line_height, width)
    draw_actor_level(actor, x, y + line_height * 2)
    draw_actor_state(actor, x, y + line_height * 3)
  end

  # Disegna le informazioni su HP, MP, EXP ecc...
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_life_info(actor, x, y, width)
    draw_actor_hp(actor, x, y, width)
    draw_actor_mp(actor, x, y + line_height, width)
    draw_actor_exp(actor, x, y + line_height * 2, width)
    draw_actor_jp(actor, x, y + line_height * 3, width)
  end

  # Disegna le informazioni extra
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_extra_info(actor, x, y, width)
    draw_actor_name(actor, x, y, width)
    x_st = text_size(actor.name).width + 2
    draw_actor_state(actor, x + x_st, y, width - x_st)
    draw_actor_equip_icons(actor, x, y + line_height, width)
    draw_actor_basic_stats(actor, x, y + line_height * 2, width)
    #draw_actor_exp(actor, x, y + line_height * 2, width)
    #draw_actor_jp(actor, x, y + line_height * 3, width)
  end

  # disegna i parametri dell'eroe
  def draw_actor_parameter(actor, x, y, width)
    w = width / 2
    6.times do |i|
      draw_actor_param(actor, i % 2 * w + x, i % 2 + y, i)
    end
  end

  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_basic_stats(actor, x, y, width, columns = 2)
    param_width = width / columns
    stats = [:atk, :def, :spi, :agi]
    stats.each_with_index do |stat, i|
      draw_actor_param_icon(actor, stat,
                            x + (param_width * (i % columns)),
                            y + (line_height * (i / columns)),
                            param_width)
    end
  end

  # @param [Game_Actor] actor
  # @param [Symbol] param
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_actor_param_icon(actor, param, x, y, width)
    draw_icon($data_system.param_icon(param), x, y)
    draw_text(x + 24, y, width - 24, line_height, actor.send(param))
  end

  # Definisce la larghezza della finestra (1/2 di schermo)
  def window_width
    Graphics.width / 2
  end

  # Crea la lista degli eroi (definito nelle classi figlie)
  def make_item_list
  end

  # Numero di oggetti
  def item_max
    @data ? @data.size : 0
  end

  # Restituisce l'oggetto puntato dal cursore
  # @return [Game_Actor]
  def item
    return @data[@index] if @index >= 0
    @data[@old_index]
  end

  # Determina se l'oggetto è abilitato allo spostamento
  def current_item_enabled?
    enable?(@data[@index])
  end

  # L'eroe può essere spostato?
  # @param [Game_Actor] actor
  def enable?(actor)
    true
  end

  # Restituisce l'eroe all'indice scelto
  # @param [Integer] index
  # @return [Game_Actor]
  def get_actor(index)
    @data[index]
  end

  # Altezza del cursore
  def item_height
    line_height * 4
  end

  # Attivazione della finestra
  def activate
    super
    self.index = @old_index || 0
  end

  # Disattivazione della finestra
  def deactivate
    super
    @old_index = [self.index, 0].max
    self.index = -1
  end

  # Seleziona l'eroe
  def select_actor
    @active_index = @old_index
    redraw_item(@active_index)
    activate
  end

  # Deseleziona l'eroe
  def unselect_actor
    return if @active_index.nil?
    old_active = @active_index
    self.active_index = nil
    redraw_item(old_active)
  end

  # determina se un eroe è già selezionato per
  # lo scambio
  # @return [TrueClass, FalseClass]
  def actor_selected?
    @active_index != nil
  end

  # ottiene l'eroe selezionato per lo scambio
  # @return [Game_Actor]
  def selected_actor
    return nil unless actor_selected?
    get_actor @active_index
  end

  def get_absolute_rect(index = nil)
    super(index || @active_index || @old_index)
  end
end

#===============================================================================
# ** Window_ActiveMembers
#-------------------------------------------------------------------------------
# Finestra che mostra l'elenco dei membri attivi in battaglia
#===============================================================================
class Window_ActiveMembers < Window_PartyMembers

  # Ottiene la lista degli eroi da quelli in campo
  def make_item_list
    @data = $game_party.battle_members
  end

  # L'eroe può essere spostato?
  # @param [Game_Actor] actor
  def enable?(actor)
    return false if actor.nil?
    !actor.fixed_member?
  end
end

#===============================================================================
# ** Window_ReserveMembers
#-------------------------------------------------------------------------------
# Finestra che mostra l'elenco dei membri in riserva
#===============================================================================
class Window_ReserveMembers < Window_PartyMembers
  # Ottiene la lista degli eroi da quelli in riserva
  def make_item_list
    @data = $game_party.stand_by_members
  end
end

#===============================================================================
# ** Window_PartyTitle
#-------------------------------------------------------------------------------
# Una semplice finestra che mostra semplice testo centrato e giallo
#===============================================================================
class Window_PartyTitle < Window_Base
  # Inizializzazione
  def initialize(x, y, width)
    super(x, y, width, 64)
  end

  # Imposta il testo
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
  # inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  def initialize(x, y)
    super(x, y, window_width, fitting_height(1))
    refresh
  end

  # Larghezza della finestra
  def window_width;
    Graphics.width;
  end

  # Refresh
  def refresh
    contents.clear
    width = contents_width / 2
    draw_vista_help(0, 0, width)
    draw_change_help(width, 0, width)
  end

  # Disegna il comando equip
  def draw_vista_help(x, y, width)
    draw_key_icon(:X, x, y)
    draw_text(x + 24, y, width - 24, line_height, Vocab.formation_vista_change)
  end

  # Disegna il comando eroi
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
  # Processo iniziale
  def start
    super
    @selected_actor = nil
    create_description_windows
    #create_command_help_window
    create_active_members_window
    create_reserve_members_window
    @last_window = :active_members_window
  end

  # Creazione della finestra dei membri attivi
  def create_active_members_window
    y = @left_window.bottom_corner
    @active_members_window = Window_ActiveMembers.new(0, y)
    @active_members_window.set_handler(:right, method(:pass_on_right))
    @active_members_window.set_handler(:cancel, method(:on_cancel))
    @active_members_window.set_handler(:ok, method(:on_actor_selection))
    @active_members_window.y = Graphics.height - @active_members_window.height
    @active_members_window.activate
  end

  # Creazione della finestra dei membri in stand-by
  def create_reserve_members_window
    x = Graphics.width/2
    y = @right_window.bottom_corner
    @reserve_members_window = Window_ReserveMembers.new(x, y)
    @reserve_members_window.set_handler(:left, method(:pass_on_left))
    @reserve_members_window.set_handler(:cancel, method(:on_cancel))
    @reserve_members_window.set_handler(:ok, method(:on_actor_selection))
    @reserve_members_window.y = Graphics.height - @reserve_members_window.height
    @reserve_members_window.deactivate
  end

  # Creazione delle finestre di descrizione
  def create_description_windows
    width = Graphics.width / 2
    @left_window = Window_PartyTitle.new(0, 0, width)
    @right_window = Window_PartyTitle.new(width, 0, width)
    @left_window.set_text(Vocab.active_members)
    @right_window.set_text(Vocab.standby_members)
  end

  # Creazione della finestra dei tasti
  def create_command_help_window
    @command_help_window = Window_FormationHelp.new(0, 0)
    @command_help_window.y = Graphics.height - @command_help_window.height
  end

  # Su selezione di un eroe
  def on_actor_selection
    if any_actor_selected?
      exchange_members
    else
      active_window.select_actor
    end
  end

  # *
  def on_cancel
    if any_actor_selected?
      @active_members_window.unselect_actor
      @reserve_members_window.unselect_actor
      active_window.activate
    else
      return_scene
    end
  end

  # procede allo scambio degli eroi
  def exchange_members
    $game_party.switch_members(selected_actor, current_actor)
    @active_members_window.reset
    @reserve_members_window.reset
    active_window.activate
  end

  # *
  def pass_on_left
    @active_members_window.activate
    @reserve_members_window.deactivate
    @last_window = :active_members_window
  end

  # *
  def pass_on_right
    @active_members_window.deactivate
    @reserve_members_window.activate
    @last_window = :reserve_members_window
  end

  # Restituisce la finestra attiva
  # @return [Window_ActiveMembers, Window_ReserveMembers]
  def active_window
    return @active_members_window if @last_window == :active_members_window
    return @reserve_members_window if @last_window == :reserve_members_window
    nil
  end

  def on_vista_change

  end

  # @return [Game_Actor]
  def current_actor
    active_window.item
  end

  # @return [Game_Actor]
  def selected_actor
    return @active_members_window.selected_actor if @active_members_window.actor_selected?
    return @reserve_members_window.selected_actor if @reserve_members_window.actor_selected?
    nil
  end

  def any_actor_selected?
    @active_members_window.actor_selected? or @reserve_members_window.actor_selected?
  end
end

class Game_Interpreter
  def call_partyform
    return if $game_temp.in_battle
    $game_temp.next_scene = :formation
  end
end

class Scene_Menu < Scene_Base
  def command_formation
    SceneManager.call(Scene_PartyFormation)
  end
end

class Game_System
  # determina se il comando di formazione è abilitato
  def formation_enabled
    return false if $game_switches[FormationConfig::PARTYFORM_DISABLE_SWITCH]
    return false if $game_party.all_members.size < 2
    formation_grated_position?
  end

  def formation_grated_position?
    FormationConfig::PARTYFORM_IN_ALL_MAPS or
        FormationConfig::PARTYFORM_ENABLED_MAPS.include?($game_map.map_id)
  end

  def formation_disabled
    !formation_enabled
  end

  # determina se il comando formazione è presente nel menu
  def formation_unlocked
    $game_switches[FormationConfig::PARTYFORM_UNLOCKED_SWITCH]
  end
end

class Scene_Map < Scene_Base
  alias h87_formation_update_scene_change update_scene_change

  # aggiorna il cambio di schermata
  def update_scene_change
    return if $game_player.moving?
    #noinspection RubyResolve
    return call_partyform if $game_temp.next_scene == :partyform
    h87_formation_update_scene_change
  end

  # chiama la formazione
  def call_partyform
    $game_temp.next_scene = nil
    SceneManager.call(Scene_PartyFormation)
  end
end

class Game_Interpreter
  alias h87_f_command_314 command_314 unless $@
  alias h87_f_command_315 command_315 unless $@

  def call_partyform
    return if $game_temp.in_battle
    $game_temp.next_scene = :partyform
  end

  def set_max_battle_member_count(value = nil)
    $game_party.max_battle_member_count = value
  end

  def party_full?
    $game_party.full?
  end

  def permit_partyform(enabled = true)
    $game_switches[FormationConfig::PARTYFORM_DISABLE_SWITCH] = !enabled
  end

  def fix_actor(actor_id, fixed = true)
    $game_party.fix_actor(actor_id, fixed)
  end

  def add_battle_member(actor_id, index = nil)
    $game_party.add_battle_member(actor_id, index)
  end

  def command_314
    $game_temp.force_reserve_members = true
    h87_f_command_314
    $game_temp.force_reserve_members = false
    true
  end

  def command_315
    $game_temp.force_reserve_members = true
    h87_f_command_315
    $game_temp.force_reserve_members = false
    true
  end
end

class Scene_Battle < Scene_Base
  alias h87_f_display_level_up display_level_up unless $@

  def display_level_up
    h87_f_display_level_up
    gain_reserve_exp
  end

  def gain_reserve_exp
    exp = $game_troop.exp_total * $game_party.reserve_exp_rate
    $game_party.stand_by_members.compact.each { |member| member.gain_exp(exp.to_i, false) }
  end
end

class Game_Troop < Game_Unit
  alias distribute_active_members_jp distribute_jp unless $@

  def distribute_jp
    distribute_active_members_jp
    jp = $game_troop.dead_members.inject(0) {|sum, enemy| sum + enemy.enemy.jp } * $game_party.reserve_exp_rate
    $game_party.stand_by_members.compact.each { |member| member.earn_jp(jp.to_i) }
  end
end