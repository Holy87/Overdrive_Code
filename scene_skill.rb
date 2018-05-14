require File.expand_path('rm_vx_data')

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
end

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

class SkillWrapper
  attr_reader :type   # :skill o :state
  attr_reader :id     # ID dell'oggetto
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize(type, id)
    @type = type
    @id = id
  end
  #--------------------------------------------------------------------------
  # *
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
  # *
  #--------------------------------------------------------------------------
  def name; object.name; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def icon; object.icon_index; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def passive?; @type == :state; end
end

class Game_Actor < Game_Battler
  alias unsorted_skills skills unless $@
  def get_all_skills
    all_sk = @skills.collect{|id| SkillWrapper.new(:skill, id)}
    all_sk.concat(@learned_passives.collect{|id| SkillWrapper.new(:state, id)})
  end

  # @param [RPG::Skill] skill
  def skill_order(skill)
    @skill_orders ||= {}
    @skill_orders[skill.id] || skill.id
  end

  # @param [RPG::Skill] skill1
  # @param [RPG::Skill] skill2
  def change_order(skill1, skill2)
    temp = skill_order(skill1)
    @skill_orders[skill1.id] = skill_order(skill2)
    @skill_orders[skill2.id] = temp
  end

  def skills
    unsorted_skills.sort{|a, b| skill_order(a) <=> skill_order(b)}
  end
end

class Scene_NewSkill < Scene_MenuBase
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_command_help_window
    create_skills_window
    create_details_window
    create_skill_learn_window
  end

  def create_command_window

  end

  def create_status_window

  end

  def create_command_help_window

  end

  def create_skills_window

  end

  def create_details_window

  end

  def create_skill_learn_window

  end
end

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

