require File.expand_path('rm_vx_data')

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#
#==============================================================================
module H87SkillSettings
  VOCAB_PASSIVE =     'Passiva'
  VOCAB_SKILLS_CMD =  'Elenco abilità'
  VOCAB_PASSIVES_CMD ='Abilità passive'
  VOCAB_LEARN_CMD =   'Apprendi'
  VOCAB_SORT_CMD =    'Riordina'
  VOCAB_USE_SKILL =   'Usa'
  VOCAB_HIDE_SKILL =  'Nascondi'
  VOCAB_SHOW_SKILL =  'Mostra'
  VOCAB_LEARN_SKILL = 'Impara'
  VOCAB_SORT_SKILL =  'Riordina'
  VOCAB_EXCH_SKILL =  'Sostituisci'
  VOCAB_RELE_SKILL =  'Rilascia'
  VOCAB_SKILL_BACK =  'Indietro'

  REORDER_KEY_COMMAND = :Y
  HIDE_KEY_COMMAND = :X

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
  def self.use_skill; H87SkillSettings::VOCAB_USE_SKILL; end
  def self.hide_skill; H87SkillSettings::VOCAB_HIDE_SKILL; end
  def self.show_skill; H87SkillSettings::VOCAB_SHOW_SKILL; end
  def self.learn_skill; H87SkillSettings::VOCAB_LEARN_SKILL; end
  def self.sort_skill; H87SkillSettings::VOCAB_SORT_SKILL; end
  def self.release_skill; H87SkillSettings::VOCAB_RELE_SKILL; end
  def self.exhange_skill; H87SkillSettings::VOCAB_EXCH_SKILL; end
  def self.back_skill; H87SkillSettings::VOCAB_SKILL_BACK; end
end

#==============================================================================
# ** Game_Actor
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
# ** Game_Actor
#------------------------------------------------------------------------------
#
#==============================================================================
class Game_Actor < Game_Battler
  alias unsorted_skills skills unless $@
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
    @skills_window = Window_SkillList.new(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Crea e aggiunge la finestra dei dettagli skill
  #--------------------------------------------------------------------------
  def create_details_window

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
    add_command(Vocab.skills_command, :skills)
    add_command(Vocab.passives_command, :passives)
    add_command(Vocab.learn_command, :learn)
    add_command(Vocab.sort_command, :sort)
  end
  #--------------------------------------------------------------------------
  # * Ridefinizione del metodo select per aggiornare la schermata
  #--------------------------------------------------------------------------
  def update_cursor; super; check_cursor_handler; end
  #--------------------------------------------------------------------------
  # * Restituisce il comando evidenziato
  # @return [Symbol]
  #--------------------------------------------------------------------------
  def item; @list[@index][:symbol]; end
end

