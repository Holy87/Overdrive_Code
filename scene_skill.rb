require File.expand_path('rm_vx_data')

#==============================================================================
# ** IMPOSTAZIONI
#==============================================================================
module H87SkillSettings
  VOCAB_PASSIVE =     'Passiva'
  VOCAB_SKILLS_CMD =  'Elenco abilità'
  VOCAB_PASSIVES_CMD ='Abilità passive'
  VOCAB_LEARN_CMD =   'Apprendi'
  VOCAB_SORT_CMD =    'Riordina'
  VOCAB_UPGRADE_CMD = 'Potenzia'
  VOCAB_USE_SKILL =   'Usa'
  VOCAB_HIDE_SKILL =  'Nascondi'
  VOCAB_SHOW_SKILL =  'Mostra'
  VOCAB_LEARN_SKILL = 'Impara'
  VOCAB_SORT_SKILL =  'Riordina'
  VOCAB_EXCH_SKILL =  'Sostituisci'
  VOCAB_RELE_SKILL =  'Rilascia'
  VOCAB_SKILL_BACK =  'Indietro'
  VOCAB_NOWSKILL =    'Ora'
  VOCAB_NEXSKILL =    'Prossimo'

  PARAM_VOCABS = {
      :base_damage => 'Danno base',
      :spi_f => 'Influenza Spi.',
      :atk_f => 'Influenza Att.',
      :agi_f => 'Influenza Agi.',
      :def_f => 'Influenza Dif.',
      :plus_state_set => 'Condizioni inflitte',
      :minut_state_set => 'Condizioni rimosse',
      :mp_cost => 'Costo PM',
      :hp_cost => 'Costo PV',
      :anger_cost => 'Costo Furia',
      :element_set => 'Elementi',
      :hit => 'Prob. di colpire',
      :aggro_set => 'Incremento Odio',
      :grudge_set => 'Incremento Odio',
      :state_inf_dur => 'Bonus Durata Stati',
      :anger_rate => 'Incremento Furia',
      :tank_odd => 'Odio sul Tank',
      :syn_bonus => 'Bonus Sinergia',
      :heal => 'Cura base'
  }

  REORDER_KEY_COMMAND = :Y
  HIDE_KEY_COMMAND = :X

  SORT_RECT_COLOR_ID = 27

end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#
#==============================================================================
module Vocab
  def self.passive; H87SkillSettings::VOCAB_PASSIVE; end
  def self.skills_command; H87SkillSettings::VOCAB_SKILLS_CMD; end
  def self.passives_command; H87SkillSettings::VOCAB_PASSIVES_CMD; end
  def self.learn_command; H87SkillSettings::VOCAB_LEARN_CMD; end
  def self.sort_command; H87SkillSettings::VOCAB_SORT_CMD; end
  def self.upgrade_command; H87SkillSettings::VOCAB_UPGRADE_CMD; end
  def self.use_skill; H87SkillSettings::VOCAB_USE_SKILL; end
  def self.hide_skill; H87SkillSettings::VOCAB_HIDE_SKILL; end
  def self.show_skill; H87SkillSettings::VOCAB_SHOW_SKILL; end
  def self.learn_skill; H87SkillSettings::VOCAB_LEARN_SKILL; end
  def self.sort_skill; H87SkillSettings::VOCAB_SORT_SKILL; end
  def self.release_skill; H87SkillSettings::VOCAB_RELE_SKILL; end
  def self.exhange_skill; H87SkillSettings::VOCAB_EXCH_SKILL; end
  def self.back_skill; H87SkillSettings::VOCAB_SKILL_BACK; end
  def self.vocab_actual_skill; H87SkillSettings::VOCAB_NOWSKILL; end
  def self.next_skill_level; H87SkillSettings::VOCAB_NEXSKILL; end
  def self.skill_param_vocab(sym); H87SkillSettings::PARAM_VOCABS[sym]; end
  end
end

#==============================================================================
# ** SkillWrapper
#------------------------------------------------------------------------------
#
#==============================================================================
class SkillWrapper
  attr_reader :type   # :skill o :state
  attr_reader :id     # ID dell'oggetto
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  # @param [Symbol] type il tipo di oggetto :skill o :state
  # @param [Integer] id l'ID dell'oggetto nel database
  def initialize(type, id)
    @type = type
    @id = id
  end
  #--------------------------------------------------------------------------
  # * restituisce l'effettivo oggetto
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def object
    case @type
    when :skill
      $data_skills[@id]
    when :state
      $data_states[@id]
    else
      nil
    end
  end
  #--------------------------------------------------------------------------
  # * ottiene il nome dell'abilità
  #--------------------------------------------------------------------------
  def name; object.name; end
  #--------------------------------------------------------------------------
  # * ottiene l'ID icona della skill
  #--------------------------------------------------------------------------
  def icon; object.icon_index; end
  #--------------------------------------------------------------------------
  # * determina se la skill è passiva
  #--------------------------------------------------------------------------
  def passive?; @type == :state; end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#
#==============================================================================
class Game_Battler
  alias skcanu_hide skill_can_use? unless $@
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_can_use?(skill)
    return false if actor? && hidden_skills.include?(skill.id) && $game_party.in_battle?
    skcanu_hide(skill)
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#
#==============================================================================
class Game_Actor < Game_Battler
  alias unsorted_skills skills unless $@
  alias sk_init initialize unless $@
  #--------------------------------------------------------------------------
  # inizializzazione
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    sk_init(actor_id)
    @skill_orders = {}
  end
  #--------------------------------------------------------------------------
  # * ottiene tutte le skill (comprese quelle passive)
  #--------------------------------------------------------------------------
  def get_all_skills
    all_sk = @skills.collect{|id| SkillWrapper.new(:skill, id)}
    all_sk.concat(@learned_passives.collect{|id| SkillWrapper.new(:state, id)})
  end
  #--------------------------------------------------------------------------
  # * restituisce l'ordinamento di un'abilità. Se non è impostato,
  # restituisce il suo ID.
  # @param [RPG::Skill] skill
  #--------------------------------------------------------------------------
  def skill_order(skill)
    @skill_orders ||= {}
    @skill_orders[skill.id] || skill.id
  end
  #--------------------------------------------------------------------------
  # * Cambia l'ordinamento di due abilità
  # @param [RPG::Skill] skill1
  # @param [RPG::Skill] skill2
  #--------------------------------------------------------------------------
  def change_order(skill1, skill2)
    temp = skill_order(skill1)
    @skill_orders[skill1.id] = skill_order(skill2)
    @skill_orders[skill2.id] = temp
  end
  #--------------------------------------------------------------------------
  # * mostra l'elenco delle abilità ordinate per ordinamento
  # @return [Array<RPG::Skill>]
  #--------------------------------------------------------------------------
  def skills
    unsorted_skills.sort{|a, b| skill_order(a) <=> skill_order(b)}
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def hidden_skills
    @hidden_skills ||= []
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def add_hidden_skill(skill_id)
    hidden_skills.push(skill_id)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def remove_hidden_skill(skill_id)
    hidden_skills.delete(skill_id)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_hidden?(skill_id)
    hidden_skills.include?(skill_id)
  end
end

#==============================================================================
# ** Scene_NewSkill
#------------------------------------------------------------------------------
#
#==============================================================================
class Scene_NewSkill < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_help_window
    create_status_window
    create_command_help_window
    create_skills_window
    create_details_window
    create_skill_learn_window
    create_skill_compare_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei comandi
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_SkillCommand.new(0,0)
  end
  #--------------------------------------------------------------------------
  # * crea la finestra d'aiuto
  #--------------------------------------------------------------------------
  def create_help_window
    super
    @help_window.y = @command_window.bottom_corner
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dello stato dell'eroe
  #--------------------------------------------------------------------------
  def create_status_window
    x = @command_window.rx
    width = Graphics.width - x
    @actor_window = Window_ActorInfo.new(x, 0, width, actor)
    @command_window.height = @actor_window.height
  end
  #--------------------------------------------------------------------------
  # * crea la finestra di legenda tasti da premere
  #--------------------------------------------------------------------------
  def create_command_help_window
    @keys_window = Window_KeyHelp.new
  end
  #--------------------------------------------------------------------------
  # * crea e aggiunge la finestra dell'elenco delle abilità
  #--------------------------------------------------------------------------
  def create_skills_window
    x = 0; y = @help_window.bottom_corner
    width = Graphics.width / 2
    height = Graphics.height - y - @keys_window.y
    @skills_window = Window_Skill.new(x, y, width, height, actor)
    @skills_window.set_handler(:ok, method(:determine_skill))
    @skills_window.set_handler(:cancel, method(:skill_unselection))
    @skills_window.set_handler(:shift, method(:start_skill_sort))
    @skills_window.set_handler(:function, method(:switch_skill_hidden))
  end
  #--------------------------------------------------------------------------
  # * Crea e aggiunge la finestra dei dettagli skill
  #--------------------------------------------------------------------------
  def create_details_window

  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_skill_compare_window
    x = @skills_window.width
    y = @skills_window.y
    w = Graphics.width - x
    h = @skills_window.height
    @compare_window = Window_SkillCompare.new(x, y, w, h)
    @compare_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Crea ed aggiunge la finestra di apprendimento abilità
  #--------------------------------------------------------------------------
  def create_skill_learn_window

  end
  #--------------------------------------------------------------------------
  # * Restituisce l'eroe attuale
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def actor; @actor; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start_skill_sort
    @skills_window.start_sort_selection
    @skills_window.set_handler(:cancel, method(:end_skill_sort))
    @skills_window.set_handler(:shift, method(:end_skill_sort))
    @skills_window.set_handler(:ok, method(:sort_skills))
    @skills_window.set_handler(:function, nil)
  end

  def end_skill_sort(sort_ok = false)
    @skills_window.end_sort_selection(sort_ok)
    @skills_window.set_handler(:ok, method(:determine_skill))
    @skills_window.set_handler(:cancel, method(:skill_unselection))
    @skills_window.set_handler(:shift, method(:start_skill_sort))
    @skills_window.set_handler(:function, method(:switch_skill_hidden))
  end

  def sort_skills
    actor.change_order(@skills_window.skill, @skills_window.sorting_skill)
    @skills_window.end_sort_selection(true)
  end

  def switch_skill_hidden
    skill = @skill_window.skill
    if skill.occasion < 2
      if @actor.hidden_skills.include?(skill.id)
        @actor.remove_hidden_skill(skill.id)
      else
        @actor.add_hidden_skill(skill.id)
      end
      Sound.play_decision
      @skill_window.redraw_current_item
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_selection
    @skills_window.activate
    @skills_window.index = 0 if @skills_window.index < 0
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def skill_unselection
    @skills_window.deactivate
    @command_window.activate
  end
end

#==============================================================================
# ** Window_SkillCommand
#------------------------------------------------------------------------------
# la finestra dei comandi della nuova schermata delle abilità.
#==============================================================================
class Window_SkillCommand < Window_Command
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::skills_command, :skills)
    add_command(Vocab::passives_command, :passives)
    add_command(Vocab::learn_command, :learn)
    add_command(Vocab::upgrade_command, :upgrade)
  end
  #--------------------------------------------------------------------------
  # * Restituisce il comando evidenziato
  # @return [Symbol]
  #--------------------------------------------------------------------------
  def item; @list[@index][:symbol]; end
end

#==============================================================================
# ** Window_Skill
#------------------------------------------------------------------------------
# modifica della finestra standard delle abilità
#==============================================================================
class Window_Skill < Window_Selectable
  alias h87_nskill_initialize initialize unless $@
  alias h87_nskill_draw_item draw_item unless $@
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    h87_nskill_initialize(x, y, width, height, actor)
    @sort_mode = false
    @sorting_skill = 0
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_item(index)
    if @sort_mode and index == @sorting_skill
      contents.fill_rect(item_rect(index), sort_color)
    end
    pos = h87_nskill_draw_item(index)
    draw_hidden_line(index)
    pos
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_hidden_line(index)
    skill = @data[index]
    if @actor.hidden_skills.include?(skill.id)
      rect = item_rect(index)
      x = rect.x + 5
      y = rect.y + line_height/2
      length = rect.width - 10
      contents.fill_rect(x,y,length,2,Color.new(255,0,0,150))
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def sort_color
    col = text_color(H87SkillSettings::SORT_RECT_COLOR_ID)
    col.alpha = 128
    col
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start_sort_selection
    @sorting_skill = self.index
    @sort_mode = true
    redraw_current_item
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def end_sort_selection(sorting_ok = false)
    reorder_data_from_sort if sorting_ok
    @sort_mode = false
    redraw_item(@sorting_skill)
    @sorting_skill = nil
    redraw_current_item if sorting_ok
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def sorting?; @sort_mode; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def sorting_skill; @data[@sorting_skill]; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def enable?(index)
    @actor.skill_can_use?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * ottiene lo stato di attivazione della skill selezionata
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def reorder_data_from_sort
    @data[@index], @data[@sorting_skill] = @data[@sorting_skill], @data[@index]
  end
end

class Window_SkillCompare < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @skill = nil
  end
  #--------------------------------------------------------------------------
  # * imposta la skill
  # @param [RPG::Skill] skill
  #--------------------------------------------------------------------------
  def set_skill(skill)
    return if @skill == skill
    @skill = skill
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @skill.nil?
    return if @skill.level_maxed?
    draw_pairings
  end
  #--------------------------------------------------------------------------
  # * disegna le differenze
  #--------------------------------------------------------------------------
  def draw_pairings
    change_color(normal_color)
    differences = @skill.next_level_compare
    y = line_height
    next_level_skill = @skill.get_skill_for_level(@skill.skill_level + 1)
    differences.each{|diff|
      y += draw_difference(diff, y, other_sk)
    }
  end
  #--------------------------------------------------------------------------
  # * disegna la differenza
  # @param [Symbol] sym
  # @param [Integer] y
  # @param [RPG::Skill] skill
  #--------------------------------------------------------------------------
  def draw_difference(sym, y, skill)
    attr_1 = eval("@skill.#{sym.to_s}")
    attr_2 = eval("skill.#{sym.to_s}")
    if sym == :base_damage and @skill.base_damage < 0
      title = Vocab::skill_param_vocab(:heal)
    else
      title = Vocab::skill_param_vocab(sym)
    end
    change_color(system_color)
    draw_text(0, y, contents_width, line_height, title)
    if attr_1.is_a?(Array)
      draw_param_icons(y + line_height, attr_1, attr_2, sym) + line_height
    else
      draw_params(y + line_height, attr_1, attr_2) + line_height
    end

  end
  #--------------------------------------------------------------------------
  # * disegna il confronto tra due array
  # @param [Integer] y
  # @param [Array] param1
  # @param [Array] param2
  # @param [Symbol] sym
  # @return [Integer] il numero di y aggiunto
  #--------------------------------------------------------------------------
  def draw_param_icons(y, param1, param2, sym)
    width = contents_width / 2 - 12
    x = contents_width / 2 + 12
    if sym == :element_set
      icons1 = param1.map{|id|Y6::ICON[:element_icons][id]}
      icons2 = param2.map{|id|Y6::ICON[:element_icons][id]}
    else
      icons1 = param1.map{|id|$data_states[id].icon_index}
      icons2 = param2.map{|id|$data_states[id].icon_index}
    end
    draw_icons(0, y, width, icons1)
    draw_text(0, y, contents_width, line_height, '➡', 1)
    draw_icons(x, y, width, icons2)
  end
  #--------------------------------------------------------------------------
  # * disegna il confronto tra due parametri numerici
  # @param [Integer] y
  # @param [Integer] param1
  # @param [Integer] param2
  # @return [Integer] y aggiunto (sempre 24)
  #--------------------------------------------------------------------------
  def draw_params(y, param1, param2)
    change_color(normal_color)
    width = contents_width / 2 - 12
    x = contents_width / 2 + 12
    draw_text(0, y, width, line_height, param1)
    draw_text(x, y, width, line_height, param2, 2)
    draw_text(0, y, contents_width, line_height, '➡', 1)
    line_height
  end
  #--------------------------------------------------------------------------
  # * disegna l'elenco delle icone
  #--------------------------------------------------------------------------
  def draw_icons(x, y, width, icons)
    cols = width / 24
    lines = (icons.size / cols) + 1
    icons.each{|icon, index|
      draw_icon(icon, x + ((index % cols) * 24), y + index / cols)
    }
    lines * line_height
  end
end