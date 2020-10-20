# ** IMPOSTAZIONI

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


# ** Game_Actor
----
#

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


# ** SkillWrapper
----
#

class SkillWrapper
  attr_reader :type   # :skill o :state
  attr_reader :id     # ID dell'oggetto
  
  # * inizializzazione
  
  # @param [Symbol] type il tipo di oggetto :skill o :state
  # @param [Integer] id l'ID dell'oggetto nel database
  def initialize(type, id)
    @type = type
    @id = id
  end
  
  # * restituisce l'effettivo oggetto
  # @return [RPG::BaseItem]
  
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
  
  # * ottiene il nome dell'abilità
  
  def name; object.name; end
  
  # * ottiene l'ID icona della skill
  
  def icon; object.icon_index; end
  
  # * determina se la skill è passiva
  
  def passive?; @type == :state; end
end


# ** Game_Battler
----
#

class Game_Battler
  alias skcanu_hide skill_can_use? unless $@
  
  # *
  
  # noinspection RubyResolve
  def skill_can_use?(skill)
    return false if actor? && hidden_skills.include?(skill.id) && $game_party.in_battle?
    skcanu_hide(skill)
  end
end


# ** Game_Actor
----
#

class Game_Actor < Game_Battler
  alias unsorted_skills skills unless $@
  alias sk_init initialize unless $@
  
  # inizializzazione
  
  def initialize(actor_id)
    sk_init(actor_id)
    @skill_orders = {}
  end
  
  # * ottiene tutte le skill (comprese quelle passive)
  
  def get_all_skills
    all_sk = @skills.collect{|id| SkillWrapper.new(:skill, id)}
    all_sk.concat(@learned_passives.collect{|id| SkillWrapper.new(:state, id)})
  end
  
  # * restituisce l'ordinamento di un'abilità. Se non è impostato,
  # restituisce il suo ID.
  # @param [RPG::Skill] skill
  
  def skill_order(skill)
    @skill_orders ||= {}
    @skill_orders[skill.id] || skill.id
  end
  
  # * Cambia l'ordinamento di due abilità
  # @param [RPG::Skill] skill1
  # @param [RPG::Skill] skill2
  
  def change_order(skill1, skill2)
    temp = skill_order(skill1)
    @skill_orders[skill1.id] = skill_order(skill2)
    @skill_orders[skill2.id] = temp
  end
  
  # * mostra l'elenco delle abilità ordinate per ordinamento
  # @return [Array<RPG::Skill>]
  
  def skills
    unsorted_skills.select {|skill| !skill_hidden?(skill.id) }
        .sort{|a, b| skill_order(a) <=> skill_order(b)}
  end
  
  # * contiene le skill nascoste
  
  def hidden_skills
    @hidden_skills ||= []
  end
  
  # * aggiunge una skill a quelle nascoste
  
  def add_hidden_skill(skill_id)
    hidden_skills.push(skill_id) unless skill_hidden? skill_id
  end
  
  # * rimuove una skill nascosta
  
  def remove_hidden_skill(skill_id)
    hidden_skills.delete(skill_id)
  end
  
  # * determina se la skill è nascosta
  
  def skill_hidden?(skill_id)
    hidden_skills.include?(skill_id)
  end
end

# ** Scene_Skill
# schermata delle abilità (revamped)
class Scene_Skill < Scene_Base
  alias h87skill_start start unless $@
  alias h87skill_update update unless $@
  alias h87skill_terminate terminate unless $@
  
  # inizio
  def start
    h87skill_start
    adjust_windows
    create_command_window
    create_command_help_window
    create_details_window
  end

  def adjust_windows
    @target_window.x = 0 - @target_window.width
    @target_window.y = @help_window.height + @command_window.height
  end
  
  # crea la finestra dei comandi
  def create_command_window
    @command_window = Window_SkillCommand.new(0,0)
    @command_window.x
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:right, method(:next_actor))
    @command_window.set_handler(:left, method(:prev_actor))
  end

  # crea la finestra d'aiuto
  def create_help_window
    super
    @help_window.y = @command_window.bottom_corner
  end
  
  # crea la finestra dello stato dell'eroe
  def create_status_window
    x = @command_window.rx
    width = Graphics.width - x
    @actor_window = Window_ActorInfo.new(x, 0, width, actor)
    @command_window.height = @actor_window.height
  end
  
  # crea la finestra di legenda tasti da premere
  def create_command_help_window
    @keys_window = Window_KeyHelp.new
    @target_window.height = Graphics.height - @target_window.y - @keys_window.height
  end
  
  # crea e aggiunge la finestra dell'elenco delle abilità
  def place_skill_window
    x = 0; y = @help_window.bottom_corner
    width = @target_window.width
    height = @target_window.height
    @skill_window.move(x, y, width, height)
    @skill_window.actor = actor
    @skill_window.set_handler(:ok, method(:determine_skill))
    @skill_window.set_handler(:cancel, method(:skill_unselection))
    @skill_window.set_handler(:shift, method(:start_skill_sort))
    @skill_window.set_handler(:function, method(:switch_skill_hidden))
  end
  
  # Crea e aggiunge la finestra dei dettagli skill
  
  def create_details_window
    x = @skills_window.width
    y = @skill_window.y
    width = Graphics.width - x
    height = @skills_window.height
    @info_window = Window_ItemInfo.new(x, y, width, height)
    @skills_window.set_info_window @info_window
  end
  
  # * Restituisce l'eroe attuale
  # @return [Game_Actor]
  def actor; @actor; end
  
  # inizia l'ordinamento delle abilità
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
  
  # attivazione della finestra delle abilità
  def skill_selection
    @skills_window.activate
    @skills_window.index = 0 if @skills_window.index < 0
  end
  
  # disattivazione della finestra delle abilità
  def skill_unselection
    @skills_window.deactivate
    @command_window.activate
  end
end

# * Window_SkillCommand
# la finestra dei comandi della nuova schermata delle abilità.
class Window_SkillCommand < Window_Command
  
  # crea la finestra dei comandi
  def make_command_list
    add_command(Vocab::skills_command, :skills)
  end
  
  # Restituisce il comando evidenziato
  # @return [Symbol]
  def item; @list[@index][:symbol]; end
end

# * Window_Skill
# modifica della finestra standard delle abilità
class Window_Skill < Window_Selectable
  include ListWindow
  alias h87_nskill_initialize initialize unless $@
  
  # inizializzazione
  # @param [Integer] x coordinata X
  # @param [Integer] y coordinata Y
  def initialize(x, y, width, height, actor)
    h87_nskill_initialize(x, y, width, height, actor)
    @sort_mode = false
    @sorting_skill = 0
    @info_window = nil
  end
  
  # determina il numero di colonne
  def col_max; 1; end

  # disegna l'oggetto (skill)
  def draw_item(index)
    skill = @data[index]
    if skill
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(skill, rect.x, rect.y, enable?(skill))
      draw_skill_cost(rect, skill)
    end
  end

  # mostra l'eroe corrente
  # @return [Game_Actor]
  def current_actor
    if SceneManager.scene_is?(Scene_NewSkill)
      @actor
    elsif SceneManager.scene_is?(Scene_Battle) and SceneManager.scene.active_battler != nil
      SceneManager.scene.active_battler
    else
      @actor
    end
  end

  # imposta l'eroe e aggiorna la finestra
  # @param [Game_Actor] actor
  def actor=(actor)
    return if @actor == actor

    @actor = actor
    refresh
  end

  # disegna la linea rossa di cancellazione abilità
  # @param [Integer] index l'indice dell'oggetto nella finestra
  def draw_hidden_line(index)
    skill = @data[index]
    if @actor.hidden_skills.include?(skill.id)
      rect = item_rect(index)
      x = rect.x + 5
      y = rect.y + line_height/2
      length = rect.width - 10
      contents.fill_rect(x,y,length,2,Color::RED.deopacize)
    end
  end

  # colore di sfondo dell'abilità selezionata da spostare
  # @return [Color]
  def sort_color
    text_color(H87SkillSettings::SORT_RECT_COLOR_ID).deopacize
  end
 
  # seleziona l'oggetto corrente ed avvia la modalità sorting
  def start_sort_selection
    return if @sort_mode

    @sorting_skill = self.index
    @sort_mode = true
    redraw_current_item
  end

  # termina la selezione della seconda abilità da scambiare
  # @param [True,False] sorting_ok se true, le abilità vengono scambiate
  def end_sort_selection(sorting_ok = false)
    return unless @sort_mode

    reorder_data_from_sort if sorting_ok
    @sort_mode = false
    redraw_item(@sorting_skill)
    @sorting_skill = nil
    redraw_current_item if sorting_ok
  end
  
  # determina se la finestra è in modalità ordinamento
  def sorting?; @sort_mode; end
  
  # restituisce l'abilità che dev'essere scambiata
  # @return [RPG::Skill]
  def sorting_skill; @data[@sorting_skill]; end
  
  # determina se l'abilità può essere utilizzata
  def enable?(index)
    @actor.skill_can_use?(@data[index])
  end
  
  # ottiene lo stato di attivazione della skill selezionata
  def current_item_enabled?
    enable?(@data[index])
  end
  
  # applica l'ordinamento dell'abilità
  def reorder_data_from_sort
    @data[@index], @data[@sorting_skill] = @data[@sorting_skill], @data[@index]
  end
end

# Finestra che mostra lo status dell'eroe con le informazioni di base.
class Window_SkillStatus < Window_Base
  # noinspection RubyArgCount
  def initialize(x, y)
    super(x, y, window_width, fitting_height(4))
    @actor = nil
    refresh

  end

  # la larghezza della finestra
  # @return [Integer]
  def window_width
    344 + (padding * 2)
  end

  # imposta l'eroe e aggiorna la finestra
  # @param [Game_Actor] new_actor
  def actor=(new_actor)
    return if @actor == new_actor

    @actor = new_actor
    refresh
  end

  def refresh
    contents.clear
    return if @actor.nil?

    draw_actor_face(actor, 0, 0)
    draw_actor_simple_status(actor, 100, 0)
  end
end