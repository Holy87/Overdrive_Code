#===============================================================================
# ** SKILL DELAY DI HOLY87 **
# 04/07/2020 -> versione 1.2.2 (fix su forget skill)
# 01/08/2019 -> versione 1.2.1 (aggiunta della ricarica sui danni)
# 26/07/2019 -> Versione 1.2 (bugfix e miglioramenti al codice)
# 03/02/2013 -> Versione 1.1 (bugfix e maggiori opzioni)
# 12/10/2012 -> Versione 1.0
# Difficoltà utente: ★★
#===============================================================================
# DESCRIZIONE:
# Questo script fa in modo che un potere abbia bisogno di un tempo di "ricarica"
# una volta usato. Il tempo può essere calcolato per:
# ●Turni: quanti turni occorrono al personaggio che ha utilizzato l'abilità per
#  renderla di nuovo disponibile
# ●Battaglie: quante battaglie deve vincere il personaggio per poter rendere di
#  nuovo l'abilità utilizzabile
# ●Passi: quanti passi deve fare il giocatore sulla mappa per ricaricare il
#  potere.
# ●Danni: quanti deve ricevere il personaggio per ricaricare il potere.
# Quando si seleziona l'abilità, compariranno delle "tacche" di un numero uguale
# ai turni o alle battaglie necessari per ricaricare le abilità, al di sotto del
# nome del potere. Nel caso si tratti di un'abilità che si ricarica camminando o
# tramite danni, allora comparirà una barra.
#===============================================================================
# UTILIZZO:
# Installare lo script sotto Materials e prima del Main, al di sotto del Costo
# Poteri Alternativo, se installato.
# Inserire nel blocco delle note dell'abilità desiderata, le seguenti etichette:
# <ricarica turni: x> per fare in modo che l'abilità si ricarichi dopo x turni
# <ricarica battaglie: x>, per fare in modo che l'abilità si ricarichi dopo x
# battaglie; oppure
# <ricarica passi: x>, per fare in modo che l'abilità si ricarichi dopo x passi.
# <ricarica danni: x%>, per fare in modo che l'abilità si ricarichi dopo aver
# subito danni pari all'x% degli HP totali
#===============================================================================
# COMPATIBILITA':
# Compatibile con Tankentai SBS, con o senza ATB. Non dovrebbe creare conflitti.
# Compatibile con il sistma di popup generale (v1.1 in poi), in questo caso,
# verrà mostrato un popup quando si ricarica un'abilità tramite passi.
#===============================================================================
# NOTE:
# Non è possibile inserire più tipi di ricarica, nel caso se ne inserissero di
# più, viene preso solo un tipo.
# Nel caso dell'ATB, il numero di turni è un pò ambiguo, quindi le abilità si
# ricaricano ogni volta che quel personaggio agisce.
#===============================================================================

$imported ||= {}
$imported["H87_SkillDelay"] = 1.2

module H87_Delay
#===============================================================================
# ** CONFIGURAZIONE **
#===============================================================================
#Inserisci i colori delle barre (il numero si riferisce al colore del testo.
#Colore tacche piene per abilità turni
  TURN_COLOR = 3
  #colore tacche vuote per abilità turni
  TURN_BG_COLOR = 7
  #colore tacche piene per abilità battaglie
  BATTLE_COLOR = 10
  #colore tacche vuote per abilità battaglie
  BATTLE_BG_COLOR = 7
  #colore barra per abilità che si ricaricano per passi
  STEPS_COLOR = 17
  #colore barra vuota per abilità che si ricaricano per passi
  STEPS_BG_COLOR = 7

  # colore barra per abilità che si caricano subendo danni
  DAMAGE_COLOR = 10

  # colore barra vuota per abilità che si caricano subendo danni
  DAMAGE_BG_COLOR = 7

  #Altezza della barra e delle tacche, in pixel
  BAR_HEIGHT = 1

  # Vuoi che le abilità che si ricaricano con i turni si ricarichino completamente
  # alla fine di una battaglia?
  RESET_OUT_OF_BATTLE = true

  # Vuoi che quando c'è un ricovero totale o una locanda, si ricarichino tutte
  # le abilità?
  INN_RECOVER = true

  # Vuoi che le abilità che si ricaricano con i turni siano visibili anche su
  # menu, o solo in battaglia? (true se si, false altrimenti)
  TURN_SKILLS_VISIBLE_ON_MENU = true

  #-------------------------------------------------------------------------------
  # * Solo con Popup:
  #-------------------------------------------------------------------------------
  #Vuoi usare un popup nel caso un'abilità che si ricarica per passi torni
  #disponibile? true: si, false: no
  UsePopup = true

  #Colore del popup
  #R  G    B    S
  PopupColor = [0, 100, 150, 20]
  #SE che viene eseguito quando un potere è carico.
  SE = "Skill"
  #Testo che viene mostrato nel popup:
  TXT = "%s di %s pronto!"

  #===============================================================================
  # ** FINE CONFIGURAZIONE **
  # Attenzione: Non modificare ciò che c'è oltre, a meno che tu non sappia ciò che
  # fai!
  #===============================================================================


  #===============================================================================
  #stringhe
  TURN_DELAY_TAG = /<ricarica turni:[ ]*(\d+)>/i
  BATTLE_DELAY_TAG = /<ricarica battaglie:[ ]*(\d+)>/i
  STEP_DELAY_TAG = /<ricarica passi:[ ]*(\d+)>/i
  DAMAGE_DELAY_TAG = /<ricarica danni:[ ]*(\d+)%>/i
  START_UNLOADED_TAG = /<inizia scarico>/i

  #-----------------------------------------------------------------------------
  # *Restituisce true se è possibile mostrare i popup
  #-----------------------------------------------------------------------------
  def self.allow_popup?
    return false unless $imported["H87_Popup"]
    UsePopup
  end

end #modulo

#===============================================================================
# ** Classe Game_Battler
#===============================================================================
class Game_Battler
  attr_accessor :turn_skills #attributo per caricamento turni
  attr_accessor :battle_skills #attributo per caricamento battaglie
  # @return[]
  attr_accessor :step_skills #attributo per caricamento passi

  alias rec_skill_all recover_all unless $@
  alias inizializza_turni initialize unless $@
  alias usabile_da_delay skill_can_use? unless $@
  alias h87_delay_execute_damage execute_damage unless $@

  # Alias metodo initialize
  def initialize
    inizializza_turni
    @turn_skills = {}
    @battle_skills = {}
    @step_skills = {}
    @damage_skills_limit = {}
  end

  # Restituisce un hash con tutti i poteri che ha in carica (turni)
  def turn_skills
    @turn_skills ||= {}
  end

  # Restituisce un hash con tutti i poteri che ha in carica (battaglie)
  def battle_skills
    @battle_skills ||= {}
  end

  # Restituisce un hash con tutti i poteri che ha in carica (passi)
  # @return [Hash<Integer,RPG::Skill>]
  def step_skills
    @step_skills ||= Hash.new
  end

  def damage_skills
    @damage_skills_limit ||= {}
    @damage_skills ||= {}
  end

  # Aggiunge un nuovo potere al caricamento dei turni
  # @param [RPG::Skill] skill
  def add_turn_skill(skill)
    @turn_skills[skill.id] = skill.turn_delay
  end

  # Resetta tutte le skill che hanno un caricamento turni (dopo ogni battaglia)
  def flush_turn_skills
    turn_skills.clear
  end

  def flush_damage_skills
    damage_skills.clear
    @damage_skills_limit.clear
  end

  # Aggiunge un nuovo potere al caricamento delle battaglie
  # @param [RPG::Skill] skill
  def add_battle_skill(skill)
    @battle_skills[skill.id] = skill.battle_delay
  end

  # Aggiunge un nuovo potere al caricamento dei passi
  # @param [RPG::Skill] skill
  def add_step_skill(skill)
    @step_skills[skill.id] = skill.step_delay
  end

  def add_damage_skill(skill)
    value = (skill.damage_delay * self.mhp).to_i
    @damage_skills[skill.id] = value
    @damage_skills_limit[skill.id] = value
  end

  # Abbassa di 1 unità i turni dei poteri
  def scale_turn
    @turn_skills.each_key { |delay|
      @turn_skills[delay] -= 1
      @turn_skills.delete(delay) if @turn_skills[delay] <= 0
    }
  end

  # Abbassa di 1 unità le battaglie dei poteri
  def scale_battle
    @battle_skills ||= {}
    @battle_skills.each_key { |delay|
      @battle_skills[delay] -= 1
      @battle_skills.delete(delay) if @battle_skills[delay] <= 0
    }
  end

  # Abbassa di 1 unità i passi dei poteri
  def scale_step
    @step_skills ||= {}
    @step_skills.each_key do |delay|
      @step_skills[delay] -= 1
      if @step_skills[delay] <= 0
        @step_skills.delete(delay)
        show_popup($data_skills[delay]) if H87_Delay.allow_popup?
      end
    end
  end

  def scale_damage
    damage = @hp_damage
    damage_skills.each_key do |skill_id|
      damage_skills[skill_id] -= damage
      if damage_skills[skill_id] <= 0
        damage_skills.delete(skill.id)
        @damage_skills_limit.delete(skill.id)
      end
    end
  end

  # restituisce il rateo [0..1] rispetto alla carica piena
  # @param [RPG::Skill] skill
  def skill_steps_load_rate(skill)
    return 0 if step_skills[skill.id].nil?
    step_skills[skill.id].to_f / skill.step_delay
  end

  # restituisce il rateo [0..1] rispetto alla carica piena
  # @param [RPG::Skill] skill
  def skill_damage_load_rate(skill)
    return 0 if damage_skills[skill.id].nil?
    damage_skills[skill.id].to_f / @damage_skills_limit
  end

  def unload_skills
    skills.each do |skill|
      add_turn_skill(skill) if skill.start_unloaded and skill.turn_delay > 0
      add_damage_skill(skill) if skill.start_unloaded and skill.damage_delay > 0
    end
  end

  # Mostra il popup
  def show_popup(delay)
    RPG::SE.new(H87_Delay::SE).play
    text = sprintf(H87_Delay::TXT, delay.name, name)
    Popup.show(text, delay.icon_index, H87_Delay::PopupColor)
  end

  # Alias metodo skill_can_use?
  def skill_can_use?(skill)
    return if skill == nil
    return false if no_charged(skill)
    usabile_da_delay(skill)
  end

  # determina se il potere non è ancora caricato
  def no_charged(skill)
    return true if skill.turn_delay > 0 and self.turn_skills.include?(skill.id)
    return true if skill.battle_delay > 0 and self.battle_skills.include?(skill.id)
    skill.step_delay > 0 and step_skills.include?(skill.id)
  end

  # ricarica tutte le skill del battler
  def recharge_all
    flush_turn_skills
    battle_skills.clear
    step_skills.clear
    damage_skills.clear
    @damage_skills_limit.clear
  end

  # recupera tutte le skill
  def recover_all
    rec_skill_all
    recharge_all if H87_Delay::INN_RECOVER
  end

  # processo di esecuzione del danno
  def execute_damage(user)
    h87_delay_execute_damage(user)
    scale_damage if @hp_damage > 0
  end


end #game_battler

#===============================================================================
# ** Game_Enemy
#===============================================================================
class Game_Enemy < Game_Battler
  # enemy skills array
  # @return [Array<RPG::Skill>]
  def skills
    sks = enemy.actions.map do |action|
      action.skill? ? $data_skills[action.skill_id] : nil
    end
    sks.compact
  end
end

class Game_Actor < Game_Battler
  alias h87_step_forget_skill forget_skill unless $@

  def forget_skill(skill_id)
    h87_step_forget_skill skill_id
    @step_skills.delete skill_id if @step_skills
    @battle_skills.delete skill_id if @battle_skills
  end
end

#===============================================================================
# ** Classe Skill
#===============================================================================
class RPG::Skill
  attr_reader :turn_delay #attributo per tempo turni
  attr_reader :battle_delay #attributo per tempo battaglie
  attr_reader :step_delay #attributo per tempo passi
  attr_reader :damage_delay #attributo per tempo danni
  attr_reader :start_unloaded # flag se comincia scarica

  # caricamento poteri
  # noinspection RubyCaseWithoutElseBlockInspection
  def carica_cache_personale3
    return if @cache_caricata3
    @cache_caricata3 = true
    @turn_delay = 0
    @battle_delay = 0
    @step_delay = 0
    @damage_delay = 0
    @start_unloaded = false
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
        #---
      when H87_Delay::TURN_DELAY_TAG
        @turn_delay = $1.to_i
      when H87_Delay::BATTLE_DELAY_TAG
        @battle_delay = $1.to_i
        @turn_delay = 0
      when H87_Delay::STEP_DELAY_TAG
        @step_delay = $1.to_i
        @battle_delay = 0
        @turn_delay = 0
      when H87_Delay::DAMAGE_DELAY_TAG
        @damage_delay = $1.to_i
      when H87_Delay::START_UNLOADED_TAG
        @start_unloaded = true
      end
    }
  end

  def must_start_unloaded?
    return false if @step_delay > 0
    return false if @battle_delay > 0
    @start_unloaded
  end

end #RPG::Skill

#===============================================================================
# ** Classe Scene_Title
#===============================================================================
class Scene_Title < Scene_Base

  #-----------------------------------------------------------------------------
  # *Alias metodo load_bt_database
  #-----------------------------------------------------------------------------
  alias carica_db3 load_bt_database unless $@

  def load_bt_database
    carica_db3
    carica_skills3
  end

  #-----------------------------------------------------------------------------
  # *Alias metodo load_database
  #-----------------------------------------------------------------------------
  alias carica_db_23 load_database unless $@

  def load_database
    carica_db_23
    carica_skills3
  end

  #-----------------------------------------------------------------------------
  # Inizializza nel caricamento
  #-----------------------------------------------------------------------------
  def carica_skills3
    $data_skills.each do |skill|
      next if skill == nil
      skill.carica_cache_personale3
    end
  end

end # scene_title

#===============================================================================
# ** Classe Scene_Battle
# noinspection RubyBlockToMethodReference
#===============================================================================
class Scene_Battle < Scene_Base
  alias h87starter start unless $@
  alias terminater3 terminate unless $@
  alias h87te turn_end unless $@
  alias h87eas execute_action_skill unless $@
  alias h87pv process_victory unless $@
  alias h87ea execute_action unless $@

  # inizio
  def start
    h87starter
    delay_reset if H87_Delay::RESET_OUT_OF_BATTLE
    unload_skills
  end

  # battle terminate
  def terminate
    terminater3
    delay_reset if H87_Delay::RESET_OUT_OF_BATTLE
  end


  # riazzera le ricariche dei poteri (turni)
  def delay_reset
    $game_party.members.each do |member|
      member.flush_turn_skills
      member.flush_damage_skills
    end
  end

  # scarica le abilità che partono scariche
  def unload_skills
    ($game_party.members + $game_troop.members).each do |member|
      member.unload_skills
    end
  end

  # fine del turno, aumenta la carica delle skill a turni (solo se non ATB)
  def turn_end(member = nil)
    h87te(member)
    scale_all unless $imported["TankentaiATB"]
  end

  # scala i turni di tutte le skill dell'eroe
  def scale_all
    $game_party.members.each { |member| member.scale_turn }
  end

  # Alias metodo execute_action_skill
  def execute_action_skill
    h87eas
    return if @active_battler == nil
    skill = @active_battler.action.skill
    return if skill == nil
    @active_battler.add_turn_skill(skill) if skill.turn_delay > 0
    @active_battler.add_battle_skill(skill) if skill.battle_delay > 0
    @active_battler.add_step_skill(skill) if skill.step_delay > 0
  end

  # Alias metodo execute_action
  def execute_action
    h87ea
    @active_battler.scale_turn if $imported["TankentaiATB"] and @active_battler != nil
  end

  # Alias metodo process_victory
  def process_victory
    h87pv
    $game_party.members.each { |member|
      member.scale_battle
    }
  end
end #scene_battle

#===============================================================================
# ** Classe Window_Skill
#===============================================================================
class Window_Skill < Window_Selectable
  alias h87di draw_item unless $@

  # draw item
  # @param [Integer] index
  def draw_item(index)
    position = h87di(index)
    rect = item_rect(index)
    skill = @data[index]
    x = rect.x + 24
    y = rect.y + rect.height - H87_Delay::BAR_HEIGHT
    length = rect.width - 24
    if skill.turn_delay > 0 and ($game_temp.in_battle or H87_Delay::TURN_SKILLS_VISIBLE_ON_MENU)
      draw_skill_turn_delay(x, y, length, skill)
    elsif skill.battle_delay > 0
      draw_skill_battle_delay(x, y, length, skill)
    elsif skill.step_delay > 0
      draw_skill_step_delay(x, y, length, skill)
    end
    position
  end

  # disegna le barre di caricamento della skill per i turni
  # @param [Integer] x
  # @param [Integer] y
  # @param [RPG::Skill] skill
  def draw_skill_turn_delay(x, y, length, skill)
    bar_len = length / skill.turn_delay - 3
    left = @actor.turn_skills[skill.id] || 0
    charged = skill.turn_delay - left

    draw_skill_loading_bars x, y, bar_len, H87_Delay::TURN_BG_COLOR, H87_Delay::TURN_COLOR, charged, skill.turn_delay
  end

  # disegna le barre di caricamento della skill per le battaglie
  # @param [Integer] x
  # @param [Integer] y
  # @param [RPG::Skill] skill
  def draw_skill_battle_delay(x, y, length, skill)
    bar_len = length / skill.battle_delay - 3
    left = @actor.battle_skills[skill.id] || 0
    charged = skill.battle_delay - left

    draw_skill_loading_bars x, y, bar_len, H87_Delay::BATTLE_BG_COLOR, H87_Delay::BATTLE_COLOR, charged, skill.battle_delay
  end

  # disegna la barra di caricamento dell'abilità per i passi
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] length
  # @param [Integer] inactive_color
  # @param [Integer] active_color
  # @param [Integer] charged
  # @param [Integer] total
  def draw_skill_loading_bars(x, y, length, inactive_color, active_color, charged, total)
    (0..total - 1).each do |i|
      color = text_color(charged > i ? active_color : inactive_color)
      contents.fill_rect(x + ((length + 3) * i), y, length, H87_Delay::BAR_HEIGHT, color)
    end
  end

  # disegna la ricarica dei passi per l'abilità
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] length
  # @param [RPG::Skill] skill
  def draw_skill_step_delay(x, y, length, skill)
    caricato = @actor.step_skills[skill.id] || 0
    caricato = skill.step_delay - caricato
    contents.fill_rect(x, y, length, H87_Delay::BAR_HEIGHT, text_color(H87_Delay::STEPS_BG_COLOR))
    lung = length.to_f * (caricato.to_f / skill.step_delay.to_f)
    contents.fill_rect(x, y, lung, H87_Delay::BAR_HEIGHT, text_color(H87_Delay::STEPS_COLOR))
  end

  # disegna la ricarica dei danni per l'abilità
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] length
  # @param [RPG::Skill] skill
  def draw_skill_damage_delay(x, y, length, skill)
    ratio = @actor.skill_damage_load_rate(skill)
    inactive_color = text_color(H87_Delay::DAMAGE_BG_COLOR)
    active_color = text_color(H87_Delay::DAMAGE_COLOR)
    draw_skill_loading(x, y, length, inactive_color, active_color, ratio)
  end

  # disegna la barra di ricarica
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] length
  # @param [Color] inactive_color
  # @param [Color] active_color
  # @param [Float] ratio
  def draw_skill_loading(x, y, length, inactive_color, active_color, ratio)
    length -= 3
    h = H87_Delay::BAR_HEIGHT
    contents.fill_rect(x, y, length, h, inactive_color)
    contents.fill_rect(x, y, length * ratio, h, active_color)
  end
end #window_skill

#===============================================================================
# ** Classe Scene_Skill
#===============================================================================
class Scene_Skill < Scene_Base
  alias h87usn use_skill_nontarget unless $@

  # use skill nontarget
  def use_skill_nontarget
    h87usn
    if @skill.battle_delay > 0
      @actor.add_battle_skill(@skill)
      @skill_window.refresh
    elsif @skill.step_delay > 0
      @actor.add_step_skill(@skill)
      @skill_window.refresh
    end
  end
end #scene_skill

#===============================================================================
# ** Classe Game_Party
#===============================================================================
class Game_Party < Game_Unit
  alias h87is increase_steps unless $@

  # incrementa i passi dell'eroe
  # noinspection RubyBlockToMethodReference
  def increase_steps
    h87is
    $game_party.members.each { |member|
      member.scale_step
    }
  end
end #game_party