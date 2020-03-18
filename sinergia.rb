#===============================================================================
# SINERGIA v1.0
# (testato solo su Overdrive)
#
#===============================================================================
# Questo script permette di eseguire mosse finali al caricamento della barra
# Sinergia. La Sinergia è una barra unica, quando si riempie è possibile
# far eseguire le mosse finali a tutti i personaggi. Inoltre, è possibile
# assegnare uno status automaticamente agli eroi quando la Sinergia è attiva.
#===============================================================================
# Istruzioni:
# Inserire i seguenti tag di status ed equipaggiamenti
# <incentivo: +/-x> dona sinergia con il passare dei turni
# <sinergia iniziale: x> bonus sinergia a inizio battaglia (se si resetta)
# <durata sinergia: +/-x%> altera la durata della sinergia quando attiva
# <bonus sinergia: +/-x%> aumenta l'acquisizione della sinergia
# <difesa sinergia: +/-x%> diminuisce la sinergia persa quando si subisce
# dei danni. Ovviamente, se diminuisce.
# <sinergia difendi: +/-x%> acquisisci sinergia quando vieni colpito mentre
# ti difendi.
# <sinergia attacca: +/-x%>
# <sinergia status: +/-x%>
# <sinergia debole: +/-x%>
# <sinergia cura: +/-x%>
# <sinergia uccisione: x>
# <sinergia vittoria: x>
# <sinergia evasione: x>
# <sinergia critico: +/-x%>
# Le mosse che usano la sinergia devono avere il seguente tag:
# <sinergico>
# Queste mosse saranno disponibili solo quando la sinergia è attiva.
# Se vuoi che una mossa abbia un accumulo predefinito di sinergia, usa il tag
# <sinergia: x> dove x è l'accumulo di sinergia
#===============================================================================

#===============================================================================
# ** Impostazioni Sinergia
#-------------------------------------------------------------------------------
# Tavola delle impostazioni della Sinergia
#===============================================================================
module H87_SINERGIC
  # Configurazione di base della Sinergia
  # Nome delle abilità speciali
  SIN_NAME = 'Sinergia'
  # Valore masimo della sinergia
  SIN_MAX = 1000
  # Decremento della Sinergia ad ogni turno quando attiva
  SINERGY_DECREASE = 75
  # Incremento predefinito con attacco/cura
  DEFAULT_INCREASE = 80
  # Divisore per l'azione del nemico (incremento di base / divisore)
  ENEMY_DIVIDER = 0 # se 0, non decresce
  # Incremento per infliggere uno stato alterato
  STATE_INFLICT = 30
  # Bonus moltiplicatore se si sfrutta una debolezza
  ELEMENT_WEAKNESS_BONUS = 1.5 # 1.0: +100%, 1.5: +150%
  # Malus moltiplicatore se si attacca con una resistenza
  ELEMENT_RESIST_MALUS = 0.5
  # Decremento della sinergia se un nemico mette KO un eroe
  ENEMY_KILL_MALUS = 0
  # Moltiplicatore base della Sinergia quando si causa un attacco
  # critico
  DEFAULT_CRITICAL_INCREASE = 2
  # Decremento della sinergia quando viene usata un'abilità speciale
  SPECIAL_SKILL_REDUCTION = 200
  # Azzeramento della Sinergia dopo la battaglia?
  BATTLE_RESET = true
  # non resettare la Sinergia se piena
  NOT_RESET_IF_FULL = true
  # Determina la quantità di Sinergia ad inizio battaglia in rapporto
  # a quanta è rimasta dalla battaglia precedente. Ad esempio:
  # 0   -> la Sinergia a inizio battaglia è vuota
  # 0.5 -> la Sinergia a inizio battaglia è la metà di quella rimasta
  # 1.0 -> la Sinergia a inizio battaglia è uguale a quella rimasta
  INITIAL_BATTLE_RESET = 0.4
  # Bilancia automaticamente l'ammonto di sinergia con il rapporto
  # numero di nemici / numero di eroi sul campo. Più ci sono nemici,
  # più la sinergia si carica rapidamente (e viceversa)
  AUTO_BALANCE = true
  # modificatore di bilanciamento (non più usato, ignorare).
  BALANCE_RATE = 1.5
  # modificatore accumulo sinergia se stai affrontando un boss
  BOSS_RATE = 0.3
  # Comando di attivazione della sinergia
  SINERGY_BUTTON = :X
  # Stato alterato aggiunto agli eroi quando la sinergia è attiva
  SINERGY_STATE = 76
  # Switch della sinergia auto-attiva. Se 0 nasconde l'opzione
  SINERGY_OPT_SW = 610
  # Configurazione grafica
  # Coordinata Y della Sinergia
  SINBAR_Y = 310
  # Immagine di sfondo
  BACKGROUND_SIN = "SinergyBackground"
  # Immagine della Cornice
  CORNER_SIN = "SinergyCorner"
  # Immagine della barra attiva
  ACTIVE_SIN = "SinergyCharged"
  # Immagine del flusso animato (quello che si muove
  POWER_SIN = "SinergyPower"
  # Immagine dell'effetto particellare
  PIXEL_SIN = "SinergyPixel"
  # Immagine della luce al margine destro
  LIGHT_SIN = "SinergyLight"
  # Velocità di movimento
  MOVE_SPEED = 2
  # Tonalità della barra attiva con sinergia
  ACTIVE_TONE = Tone.new(255, 0, 255, 255)
  # Tonalità dello sfondo attiva la sinergia
  B_ACTV_TONE = Tone.new(0, -255, 0, 255)
  # Tonalità dello sfondo quando non attiva
  B_DEFT_TONE = Tone.new(-30, -30, -20, 255)
  # Suono di attivazione della Sinergia
  ACTIV_SOUND = "Up4"
  # attivare effetti particellari? Disattivato perché influisce negativamente
  # sulle prestazioni.
  PARTICLE_EFFECTS = false

  SINERGY_ANIM_ID = 457

  CORNER_ANIM_ID = 458
  CORNER_ACTIV_ANIM_IDS = [459, 460, 461, 462]
  # Configurazione impostazione sinergia dal menu
  SIN_SETTINGS = {
      :type => :switch,
      :text => "Attivazione sinergia",
      :help => "Scegli se attivare la sinergia con la pressione del tasto o|automaticamente quando raggiunge il massimo.",
      :sw => SINERGY_OPT_SW,
      :on => "Automatica",
      :off => "Manuale",
      :default => false,
  }
end

#===============================================================================
# ** Sinergy_Stats
#-------------------------------------------------------------------------------
# Attributi per la Sinergia
#===============================================================================
module Sinergy_Stats
  INCENTIVE = /<incentivo:[ ]*([+\-]\d+)>/i
  SIN_DURAB = /<durata sinergia:[ ]*([+\-]\d+)([%％])>/i
  SIN_BONUS = /<bonus sinergia:[ ]*([+\-]\d+)([%％])>/i
  SIN_DEFEN = /<difesa sinergia:[ ]*([+\-]\d+)([%％])>/i
  SIN_ON_GRD = /<sinergia difendi:[ ]*(\d+)([%％])>/i
  SIN_ON_ATK = /<sinergia attacca:[ ]*(\d+)([%％])>/i
  SIN_ON_STA = /<sinergia status:[ ]*(\d+)([%％])>/i
  SIN_ON_WEA = /<sinergia debole:[ ]*(\d+)([%％])>/i
  SIN_ON_HEA = /<sinergia cura:[ ]*(\d+)([%％])>/i
  SIN_ON_KIL = /<sinergia uccisione:[ ]*(\d+)>/i
  SIN_ON_VIC = /<sinergia vittoria:[ ]*(\d+)>/i
  SIN_ON_EVA = /<sinergia evasione:[ ]*(\d+)>/i
  SIN_ON_STR = /<sinergia iniziale:[ ]*(\d+)>/i
  SIN_ON_CRI = /<sinergia critico:[ ]*([+\-]\d+)([%％])>/i
  SIN_ON_INI = /<sinergia iniziale:[ ]*([+\-]\d+)>/i
  attr_reader :incentive #incentivo: incremento minimo sinergia a turni
  attr_reader :sin_durab #bonus di durata della Sinergia quando è attiva
  attr_reader :sin_defense #riduce il calo della sinergia quando colpito
  attr_reader :sin_bonus #aumenta l'incremento della sinergia
  attr_reader :sin_on_guard #aumenta la sinergia se colpito mentre ci si dif
  attr_reader :sin_on_attack #aumenta la sinergia quando si causa danno
  attr_reader :sin_on_heal #aumenta la sinergia quando si cura
  attr_reader :sin_on_kill #aumenta la sinergia quando si uccide un nemico
  attr_reader :sin_on_victory #aumenta la sinergia quando si vince
  attr_reader :sin_on_weak #aumenta la sinergia se debolezza elementale
  attr_reader :sin_on_state #aumenta la sinergia se si causa stati alter.
  attr_reader :sin_on_eva #aumenta la sinergia se si schiva il colpo
  attr_reader :sin_on_start #sinergia all'inizio della battaglia
  attr_reader :sin_on_cri #bonus sinergia per danni critici
  # Caricamento degli attributi sinergia
  def load_sinergy_stats
    return if @sinergy_loaded
    @sinergy_loaded = true
    @incentive = 0
    @sin_durab = 0
    @sin_bonus = 0
    @sin_defense = 0
    @sin_on_guard = 0
    @sin_on_attack = 0
    @sin_on_heal = 0
    @sin_on_kill = 0
    @sin_on_victory = 0
    @sin_on_weak = 0
    @sin_on_state = 0
    @sin_on_eva = 0
    @sin_on_start = 0
    @sin_on_cri = 0
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
      when INCENTIVE
        @incentive = $1.to_i
      when SIN_DURAB
        @sin_durab = $1.to_f / 100
      when SIN_BONUS
        @sin_bonus = $1.to_f / 100
      when SIN_DEFEN
        @sin_defense = $1.to_f / 100
      when SIN_ON_GRD
        @sin_on_guard = $1.to_f / 100
      when SIN_ON_ATK
        @sin_on_attack = $1.to_f / 100
      when SIN_ON_STA
        @sin_on_state = $1.to_f / 100
      when SIN_ON_WEA
        @sin_on_weak = $1.to_f / 100
      when SIN_ON_HEA
        @sin_on_heal = $1.to_f / 100
      when SIN_ON_KIL
        @sin_on_kill = $1.to_i
      when SIN_ON_VIC
        @sin_on_victory = $1.to_i
      when SIN_ON_EVA
        @sin_on_eva = $1.to_i
      when SIN_ON_INI
        @sin_on_start = $1.to_i
      when SIN_ON_CRI
        @sin_on_cri = $1.to_f / 100
      else
        # type code here
      end
    }
  end
end #sinergyStats

module Vocab
  def self.sinergy_name
    H87_SINERGIC::SIN_NAME
  end
end

#===============================================================================
# ** RPG::UsableItem
#-------------------------------------------------------------------------------
# Per oggetti e abilità
#===============================================================================
class RPG::UsableItem
  attr_reader :custom_sinergy # valore personalizzato di sinergia
  attr_reader :special_skill # è un'abilità che richiede sinergia?
  # Caricamento attributi
  def load_sinergy_stats
    return if @sinergy_loaded
    @sinergy_loaded = true
    @special_skill = false
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
      when /<sinergia:[ ]*(\d+)>/i
        @custom_sinergy = $1.to_i
      when /<sinergico>/i
        @special_skill = true
      else
        # type code here
      end
    }
  end
end #usableitem

#===============================================================================
# ** Classi Weapon, Armor e State
#-------------------------------------------------------------------------------
# Inclusione dei parametri sinergia
#===============================================================================
class RPG::Weapon
  include Sinergy_Stats
end
class RPG::Armor
  include Sinergy_Stats
end
class RPG::State
  include Sinergy_Stats
end
class RPG::Item
  include Sinergy_Stats
end

#===============================================================================
# ** Scene_Title
#-------------------------------------------------------------------------------
# Aggiunta del caricamento degli attributi
#===============================================================================
class Scene_Title < Scene_Base
  alias h87sinergy_load_database load_database unless $@
  alias h87sinergy_load_bt_database load_bt_database unless $@
  # Caricamento del database
  def load_database
    h87sinergy_load_database
    load_data_sinergy
  end

  # Caricamento del database per battle test
  def load_bt_database
    h87sinergy_load_bt_database
    load_data_sinergy
  end

  # Caricamento dei dati
  def load_data_sinergy
    load_weapon_sinergy
    load_armor_sinergy
    load_state_sinergy
    load_skill_sinergy
    load_item_sinergy
  end

  # Attributi delle abilità
  def load_skill_sinergy
    $data_skills.each { |skill|
      next if skill.nil?
      skill.load_sinergy_stats
    }
  end

  # Attributi delgli oggetti
  def load_item_sinergy
    $data_items.each { |item|
      next if item.nil?
      item.load_sinergy_stats
    }
  end

  # Caricamento degli attributi delle armi
  def load_weapon_sinergy
    $data_weapons.each { |weapon|
      next if weapon.nil?
      weapon.load_sinergy_stats
    }
  end

  # Attributi armature
  def load_armor_sinergy
    $data_armors.each { |armor|
      next if armor.nil?
      armor.load_sinergy_stats
    }
  end

  # Attributi Stati
  def load_state_sinergy
    $data_states.each { |state|
      next if state.nil?
      state.load_sinergy_stats
    }
  end
end #title

#===============================================================================
# ** Game_System
#===============================================================================
class Game_System
  # determina se la sinergia si deve attivare automaticamente
  def auto_sinergy?
    $game_switches[H87_SINERGIC::SINERGY_OPT_SW]
  end
end

#===============================================================================
# ** Game_Battler
#-------------------------------------------------------------------------------
# Aggiunti i controlli Sinergia
#===============================================================================
class Game_Battler
  include H87_SINERGIC
  alias h87sinergia_asc apply_state_changes unless $@
  alias h87sinergia_eff attack_effect unless $@
  alias h87sinergia_ski skill_effect unless $@
  alias h87sinergia_scu skill_can_use? unless $@
  alias h87sinergia_exd execute_damage unless $@
  alias h87sinergia_sts states unless $@
  # Aumenta la sinergia al danno
  # @param [Game_Battler] user
  def execute_damage(user)
    check_sinergic_damage(user)
    check_sinergic_heal(user)
    h87sinergia_exd(user)
  end

  # Controlla la sinergia data nella cura
  # @param [Game_Actor] user
  def check_sinergic_heal(user)
    return unless SceneManager.scene_is?(Scene_Battle)
    if (@hp_damage < 0 or @mp_damage < 0) and actor?
      if user.actor?
        $game_party.add_sinergy(user.sinergic_increase)
      else
        $game_party.add_sinergy(sinergic_increase)
      end
    end
  end

  # Controllo che se è un'abilità Sinergia, non può essere usata
  # @param [RPG::Skill] skill
  def skill_can_use?(skill)
    return false if skill.special_skill && !$game_party.sinergy_active?
    h87sinergia_scu(skill)
  end

  # Controlla l'aggiunta della sinergia al danno
  # @param [Game_Battler] user
  def check_sinergic_damage(user)
    return unless $scene.is_a?(Scene_Battle)
    return if $game_party.sinergy_active?
    skill = user.action.action_object
    element_set = skill.nil? ? user.element_set : skill.element_set
    $game_party.add_sinergy(skill.custom_sinergy) if skill
    return unless damaged?
    if guard? and actor?
      $game_party.add_sinergy(sinergic_increase * sin_guard_bonus)
    end
    mult = get_multiplier(element_set, user)
    $game_party.add_sinergy(user.sinergic_increase * mult)
  end

  # Ottiene il moltiplicatore Sinergia
  # @param [Game_Battler] attacker
  # @param [Array] element_set
  def get_multiplier(element_set, attacker)
    return 0 if guarding?
    mult = @critical ? attacker.sin_on_critical : 1
    if elements_max_rate(element_set) > 100
      mult += ELEMENT_WEAKNESS_BONUS + attacker.sin_weak_bonus
    elsif elements_max_rate(element_set) < 100
      mult -= ELEMENT_RESIST_MALUS
    end
    mult -= sinergic_defense if actor?
    mult /= 2.0 if attacker.has2w
    mult
  end

  # Controlla i cambi di stato
  #   obj: skill o oggetto
  # @param [RPG::UsableItem] obj
  def apply_state_changes(obj)
    old = @added_states.clone
    h87sinergia_asc(obj)
    return unless $scene.is_a?(Scene_Battle)
    return if $game_party.sinergy_active?
    return if old == @added_states
    user = $scene.active_battler
    $game_party.add_sinergy(user.sinergic_state)
  end

  # Applica gli effetti dell'attacco normale
  #     attacker : Attaccante
  # @param [Game_Battler] attacker
  def attack_effect(attacker)
    h87sinergia_eff(attacker)
    return if $game_party.sinergy_active?
    $game_party.add_sinergy(sin_evade_bonus) if @evaded
    $game_party.add_sinergy(attacker.sin_kill_bonus) if dead?
  end

  # Applica gli effetti della skill
  #     user : Utilizzatore
  #     skill: abilità
  # @param [Game_Battler] user
  # @param [RPG::Skill] skill
  def skill_effect(user, skill)
    h87sinergia_ski(user, skill)
    return if $game_party.sinergy_active?
    $game_party.add_sinergy(sin_evade_bonus) if @evaded
    $game_party.add_sinergy(user.sin_kill_bonus) if dead?
  end

  # Controllo della Sinergia per un'abilità
  # @param [Game_Battler] user
  # @param [RPG::Skill] obj
  def check_sinergic_skill(user, obj)
    return unless $scene.is_a?(Scene_Battle)
    return if $game_party.sinergy_active?
    if @hp_damage < 0 || @mp_damage < 0
      sinergic_heal(obj)
    elsif @hp_damage > 0 || @mp_damage > 0
      check_sinergic_damage(user)
    end
  end

  # Modifica sinergia per cura
  #   obj: Oggetto
  # @param [RPG::Skill] obj
  def sinergic_heal(obj)
    return if !actor? and ENEMY_DIVIDER == 0
    m = actor? ? 1 : -1
    value = obj.custom_sinergy.nil? ? sinergic_increase : obj.custom_sinergy * m
    $game_party.sinergic_state += value * sin_heal_bonus
  end

  # Incremento sinergia del battler
  def sinergic_increase
    0
  end

  # Restituisce il rate di difesa della sinergia
  def sinergic_defense
    0.0
  end

  # Incremento sinergia del battler su status
  def sin_state_increase
    0
  end

  # Incremento della Sinergia a Status
  def sinergic_state
    sin_state_increase * sin_state_bonus
  end

  # Bonus Sinergia in attacco
  def sin_attack_bonus
    1.0
  end

  # Bonus Sinergia in Status
  def sin_state_bonus
    1.0
  end

  # Bonus Sinergia per debolezze
  def sin_weak_bonus
    1.0
  end

  # Bonus Sinergia per guardia
  def sin_guard_bonus
    1.0
  end

  # Bonus Sinergia per cura
  def sin_heal_bonus
    1.0
  end

  # Bonus Sinergia per evasione
  def sin_evade_bonus
    0
  end

  # Bonus Sinergia per uccisione
  def sin_kill_bonus
    0
  end

  # Bonus Sinergia per vittoria
  def sin_victory_bonus
    0
  end

  # bonus Sinergia per attacco critico
  def sin_on_critical
    2
  end

  # Ha 2 armi?
  def has2w
    false
  end

  # Restituisce gli stati alterati più quello del bonus sinergia se attivo
  # @return [Array<RPG::State>]
  def states
    _states = h87sinergia_sts
    if SINERGY_STATE > 0 and actor? and $game_party.sinergy_active?
      _states.push($data_states[SINERGY_STATE])
    end
    _states
  end
end #game_battler

#===============================================================================
# ** Game_Actor
#-------------------------------------------------------------------------------
# Parametri della Sinergia
# noinspection Rails3Deprecated
#===============================================================================
class Game_Actor < Game_Battler
  # Restituisce l'incremento predefinito della Sinergia
  def sinergic_default_increase
    DEFAULT_INCREASE
  end

  # Restituisce l'incremento della Sinergia con eventuale bonus
  def sinergic_increase
    sinergic_default_increase * (1.0 + sin_bonus)
  end

  # Incremento sinergia del battler su status
  def sin_state_increase
    STATE_INFLICT
  end

  # Restituisce il bonus durata sinergia dell'eroe
  def sin_duration_bonus
    0.0 + features_sum(:sin_durab)
  end

  # Restituisce il bonus sinergia dell'eroe
  def sin_bonus
    features_sum(:sin_bonus)
  end

  # Restituisce il bonus di riduzione sinergia se attaccati
  def sinergic_defense
    super + features_sum(:sin_defense)
  end

  # Restituisce il bonus Sinergia quando si causa stati alterati
  def sinergic_state_bonus
    sinergic_default_increase * sin_state_bonus
  end

  # Restituisce il bonus Sinergia quando si sfruttano le debolezze
  def sinergic_weak_bonus
    sinergic_default_increase * sin_weak_bonus
  end

  # Restituisce il bonus attacco
  def sin_attack_bonus
    super + features_sum(:sin_on_attack)
  end

  # Restituisce il bonus guardia
  def sin_guard_bonus
    super + features_sum(:sin_on_guard)
  end

  # Restituisce il bonus uccisione
  def sin_kill_bonus
    super + features_sum(:sin_on_kill)
  end

  # Restituisce il bonus debolezze
  def sin_weak_bonus
    super + features_sum(:sin_on_weak)
  end

  # Restituisce il bonus stato alterato
  def sin_state_bonus
    super + features_sum(:sin_on_state)
  end

  # Restituisce il bonus Vittoria
  def sin_victory_bonus
    super + features_sum(:sin_on_victory)
  end

  # Restituisce il bonus Cura
  def sin_heal_bonus
    features_sum(:sin_on_heal)
  end

  # Restituisce il bonus Evasione
  def sin_evade_bonus
    features_sum(:sin_on_eva)
  end

  # Restituisce il bonus Incentivo dell'eroe
  def sin_incentive
    features_sum(:incentive)
  end

  # Sinergia iniziale
  def starting_sinergy
    features_sum(:sin_on_start)
  end

  # bonus Sinergia per attacco critico
  def sin_on_critical
    DEFAULT_CRITICAL_INCREASE + features_sum(:sin_on_cri)
  end
end #game_actor

#===============================================================================
# ** Game_Enemy
#-------------------------------------------------------------------------------
# Constrollo Sinergia alla morte
#===============================================================================
class Game_Enemy < Game_Battler
  # Restituisce l'incremento predefinito della Sinergia
  def sinergic_default_increase
    return 0 if ENEMY_DIVIDER == 0
    DEFAULT_INCREASE / ENEMY_DIVIDER * -1
  end

  # Restituisce l'incremento della Sinergia
  def sinergic_increase
    sinergic_default_increase
  end

  # Incremento sinergia del battler su status
  def sin_state_increase
    return 0 if ENEMY_DIVIDER == 0
    STATE_INFLICT / ENEMY_DIVIDER * -1
  end

  # Decremento della Sinergia se un nemico uccide un alleato
  def sin_kill_bonus
    ENEMY_KILL_MALUS * -1
  end
end #enemy

#===============================================================================
# ** Game_Party
#-------------------------------------------------------------------------------
# Aggiunta della Sinergia del gruppo
#===============================================================================
class Game_Party < Game_Unit
  include H87_SINERGIC
  # Restituisce il bonus della sinergia iniziale
  def starting_sinergy
    members.compact.inject(0) { |v, m| v + m.starting_sinergy } + rand(100)
  end

  # Imposta la sinergia del gruppo
  #   value: valore sinergia
  def sinergic_state=(value)
    @sinergic_state = 0 if @sinergic_state.nil?
    return if @sinergic_state >= SIN_MAX # per evitare che scenda quando piena
    @sinergic_state = [[0, value].max, SIN_MAX].min
    check_sinergy_activation
  end

  # Aggiunge sinergia
  def add_sinergy(value)
    s1 = sinergic_state
    if in_battle? and $game_troop.boss_fight?
      value *= BOSS_RATE
    end
    @sinergic_state = [s1 + value.to_i, SIN_MAX].min
    check_sinergy_activation
  end

  # consuma la sinergia
  def lose_sinergy(value)
    @sinergic_state -= value
    @sinergic_state = 0 if @sinergic_state < 0
    check_sinergy_activation
  end

  # Riempie la sinergia al massimo
  def fill_sinergy
    self.sinergic_state = SIN_MAX
  end

  # azzera la sinergia
  def reset_sinergy(multiplier = 0)
    return if sinergy_full? && NOT_RESET_IF_FULL
    @sinergic_state *= multiplier
    @sinergy_active = false
  end

  # Restituisce la sinergia del gruppo
  def sinergic_state
    @sinergic_state ||= 0
  end

  # Controllo attivazione Sinergia
  def check_sinergy_activation
    if sinergy_active?
      @sinergy_active = false if @sinergic_state <= 0
    elsif sinergy_full? and $game_system.auto_sinergy?
      @sinergy_active = true
    end
  end

  # determina se la sinergia è piena
  def sinergy_full?
    sinergic_state >= SIN_MAX
  end

  # Restituisce se la Sinergia è attivata
  def sinergy_active?
    @sinergy_active
  end

  # Imposta il valore della Sinergia
  def sinergy_active=(value)
    @sinergy_active = value
  end

  # Incremento della sinergia per bonus vittoria
  def check_sinergic_victory
    return if sinergy_active?
    add_sinergy(sinergic_victory)
  end

  # Bonus vittoria sinergia
  def sinergic_victory
    battle_members.compact.inject(0) { |bonus, member| bonus + member.sin_victory_bonus }
  end

  # Aggiornamento della Sinergia alla fine del turno
  def update_sinergy_turn
    if sinergy_active?
      lose_sinergy(SINERGY_DECREASE / sinergy_bonus_duration)
    else
      add_sinergy(sinergy_incentive)
    end
  end

  # Restituisce l'incentivo totale della Sinergia
  def sinergy_incentive
    battle_members.compact.inject(0) { |v, m| v + m.sin_incentive }
  end

  # Restituisce il bonus durata della Sinergia
  def sinergy_bonus_duration
    battle_members.compact.inject(1.0) { |v, m| v + m.sin_duration_bonus }
  end
end #game_party

#===============================================================================
# ** Scene_Battle
#-------------------------------------------------------------------------------
# Aggiunta barra Sinergia
#===============================================================================
class Scene_Battle < Scene_Base
  alias h87sin_start start unless $@
  alias h87sin_update_basic update_basic unless $@
  alias h87sin_terminate terminate unless $@
  alias h87sin_tend turn_end unless $@
  alias h87sin_eas execute_action_skill unless $@
  alias h87sin_process_victory process_victory unless $@

  # Inizio
  def start
    h87sin_start
    create_sin_bar
    $game_party.add_sinergy($game_party.starting_sinergy) if H87_SINERGIC::BATTLE_RESET
  end

  # Riduzione della Sinergia
  def execute_action_skill
    h87sin_eas
    skill = @active_battler.action.skill
    return if skill.nil?
    if skill.special_skill
      puts 'usata skill speciale'
      $game_party.lose_sinergy(H87_SINERGIC::SPECIAL_SKILL_REDUCTION)
    end
    if $imported['CostoHoly']
      $game_party.lose_sinergy(@active_battler.calc_var_cost(skill))
    end
  end

  # Aggiornamento
  def update_basic(main = false)
    # noinspection RubyArgCount
    h87sin_update_basic(main)
    update_sinergy_activation
    update_sin_bar
  end

  # Terminazione
  def terminate
    h87sin_terminate
    #hide_sinergy_bar
    dispose_sin_bar
    reset_sinergy
  end

  # controlla la pressione del tasto per attivare la sinergia
  def update_sinergy_activation
    return if $game_system.auto_sinergy?
    return if $game_party.sinergy_active?
    return unless $game_party.sinergy_full?
    if Input.trigger?(H87_SINERGIC::SINERGY_BUTTON)
      $game_party.sinergy_active = true
      end_item_selection
      end_skill_selection
    end
  end

  # Fine del turno
  def turn_end(member = nil)
    h87sin_tend(member)
    check_sinergy_change
  end

  # Esecuzione di vittoria
  def process_victory
    hide_sinergy_bar
    h87sin_process_victory
    $game_party.check_sinergic_victory
  end

  # nasconde la barra della sinergia
  def hide_sinergy_bar
    @s_view1.visible = false
    @s_view2.visible = false
    @s_view3.visible = false
  end

  # mostra la barra della sinergia
  def show_sinergy_bar
    @s_view1.visible = true
    @s_view2.visible = true
    @s_view3.visible = true
  end

  # determina se visibile o meno
  def sinergy_bar_visible?
    !@s_view1.disposed? and @s_view1.visible
  end

  # imposta la visibilità
  def sinergy_bar_visible=(value)
    value ? show_sinergy_bar : hide_sinergy_bar
  end

  # Reset della Sinergia a fine battaglia se era attivata.
  # Dato che il valore non cambia se la sinergia è al max, la sinergia si
  # resetta solo se il giocatore ha usato almeno una skill speciale.
  def reset_sinergy
    if $game_party.sinergy_active? or H87_SINERGIC::BATTLE_RESET
      $game_party.reset_sinergy(H87_SINERGIC::INITIAL_BATTLE_RESET)
    end
  end

  # Cambia la sinergia alla fine del turno
  def check_sinergy_change
    $game_party.update_sinergy_turn
  end

  # Creazione della barra Sinergia
  def create_sin_bar
    create_sinergy_viewports
    create_sinergy_graphic
  end

  # Creazione dei viewport
  def create_sinergy_viewports
    @s_view1 = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @s_view1.z = 150
    @s_view2 = Viewport.new(0, 0, 0, 0)
    @s_view2.z = 200
    @s_view3 = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @s_view3.z = 250
  end

  # Aggiornamento della barra Sinergia
  def create_sinergy_graphic
    @sinergy_bar = Sprite_Sinergy.new(@s_view1, @s_view2, @s_view3)
  end

  # Aggiornamento della barra Sinergia
  def update_sin_bar
    @sinergy_bar.update if sinergy_bar_visible?
  end

  # Eliminazione della barra Sinergia
  def dispose_sin_bar
    @sinergy_bar.dispose
    @s_view1.dispose
    @s_view2.dispose
    @s_view3.dispose
  end
end #scene_battle

#===============================================================================
# ** Sprite_Sinergy
#-------------------------------------------------------------------------------
# Sprite principale della Sinergia
#===============================================================================
class Sprite_Sinergy
  include H87_SINERGIC
  # Inizializzazione
  #   view1, 2 e 3: viewport di sfondo, della barra e della cornice
  # @param [Viewport] view1
  # @param [Viewport] view2
  # @param [Viewport] view3
  def initialize(view1, view2, view3)
    @view1 = view1
    @view2 = view2
    @view3 = view3
    @pixels = []
    create_graphic
    set_proper_value
  end

  # Creazione della grafica
  def create_graphic
    @fake_sprite = Sprite.new
    create_background_rect
    create_fill_rect
    create_corner
    create_sinergy_button
  end

  # crea il pulsante di attivazione della Sinergia
  def create_sinergy_button
    @sinergy_button = Sprite_SinergyButton.new(@view3)
    @sinergy_button.x = @corner.x - 30
    @sinergy_button.y = @corner.y + (@corner.height - @sinergy_button.height) / 2
    @sinergy_button.visible = false
  end

  # Aggiunge un nuovo pixel
  def add_pixel
    height = @fill.height
    pixel = Sprite.new(@view2)
    pixel.bitmap = Cache.system(PIXEL_SIN)
    pixel.ox = pixel.width / 2
    pixel.oy = pixel.height / 2
    pixel.x = @fill.x + @view2.rect.width
    pixel.y = rand(height) + @fill.y
    pixel.opacity = 200
    @pixels.push(pixel)
  end

  # Aggiunge un nuovo pixel (con sinergia attiva)
  def add_superpixel
    pixel = Sprite.new(@view2)
    pixel.bitmap = Cache.system(PIXEL_SIN)
    pixel.ox = pixel.width / 2
    pixel.oy = pixel.height / 2
    pixel.y = @fill.height + @fill.y
    pixel.x = rand(@view2.rect.width) + @fill.x
    pixel.tone = ACTIVE_TONE
    pixel.opacity = 200
    @pixels.push(pixel)
  end

  # Aggiorna i pixel
  def update_pixels
    @pixels.each do |pixel|
      pixel.x -= 1
      pixel.opacity -= 10
      if pixel.opacity == 0
        pixel.dispose
        @pixels.delete(pixel)
      end
    end
  end

  # Aggiorna i pixel in sinergia attiva
  def update_superpixels
    @pixels.each do |pixel|
      pixel.y -= 1
      pixel.opacity -= 20
      if pixel.opacity == 0
        pixel.dispose
        @pixels.delete(pixel)
      end
    end
  end

  # Crea l'immagine di sfondo della barra
  def create_background_rect
    @background = Sprite.new(@view1)
    @background.bitmap = Cache.system(BACKGROUND_SIN)
    @background.x = Graphics.width / 2 - @background.width / 2
    @background.y = SINBAR_Y
    @background.opacity = 200
    @background.tone = B_DEFT_TONE
  end

  # Crea l'immagine della barra
  def create_fill_rect
    @fill = Sprite.new(@view2)
    @fill.bitmap = Cache.system(ACTIVE_SIN)
    @power = Plane.new(@view2)
    @power.bitmap = Cache.system(POWER_SIN)
    @power.opacity = 50
    @power2 = Plane.new(@view2)
    @power2.bitmap = Cache.system(POWER_SIN)
    @power2.zoom_x = 2
    @power2.zoom_y = 2
    @power2.opacity = 50
    @view2.rect.x = @background.x
    @view2.rect.y = @background.y
    @view2.rect.height = @background.height
    @light = Sprite.new(@view2)
    @light.bitmap = Cache.system(LIGHT_SIN)
    @light.y = @fill.y
    @light.ox = @light.width / 2
  end

  # Crea la cornice della barra
  def create_corner
    @corner = Sprite_SinergyBar.new(@view3)
    @corner.bitmap = Cache.system(CORNER_SIN)
    @corner.x = Graphics.width / 2 - @corner.width / 2
    @corner.y = SINBAR_Y + (@background.height / 2 - @corner.height / 2)
  end

  # Imposta il valore della Sinergia
  def set_proper_value
    @fake_sprite.x = fill_width($game_party.sinergic_state)
    @view2.rect.width = @fake_sprite.x
  end

  # Restituisce la larghezza che deve avere il viewport della barra
  def fill_width(value)
    [[@background.width.to_f / SIN_MAX * value, 0].max, @background.width].min
  end

  # Aggiornamento
  def update
    update_size
    update_animation
    update_activation
    handle_pixels
    update_button_placement
    @background.update
    @corner.update
    @fill.update
  end

  # aggiorna lo stato del pulsante
  def update_button_placement
    return if $game_system.auto_sinergy?
    @sinergy_button.update
    unless $game_party.sinergy_active?
      @sinergy_button.visible = $game_party.sinergy_full?
    end
  end

  # Gestione degli effetti particellari
  def handle_pixels
    return unless H87_SINERGIC::PARTICLE_EFFECTS
    if @active
      update_superpixels
      flash_bar
      (0..@view2.rect.width / 20 + 1).each {
        add_superpixel
      }
    else
      update_pixels
      add_pixel
    end
  end

  # Eliminazione
  def dispose
    @background.viewport = nil
    @corner.viewport = nil
    @fill.viewport = nil
    @power.viewport = nil
    @light.viewport = nil
    @background.dispose
    @corner.dispose
    @fill.dispose
    @power.dispose
    @pixels.each { |pixel| pixel.dispose }
    @light.dispose
    @sinergy_button.dispose
  end

  # Aggiornamento della grandezza
  def update_size
    @fake_sprite.update
    @view2.rect.width = @fake_sprite.x
    @light.x = @fill.x + @view2.rect.width
    return if @value == $game_party.sinergic_state
    @value = $game_party.sinergic_state
    @fake_sprite.smooth_move(fill_width(@value), 0, 3)
  end

  # Flash dello sfondo
  def flash_bar
    if Graphics.frame_count % 30 == 0
      @background.flash(Color.new(255, 255, 255, 100), 30)
    end
  end

  # Aggiornamento dell'animazione della barra
  def update_animation
    if $game_party.sinergy_active?
      @power.ox -= 5
      @power.oy += 2
      @power2.ox -= 3
      @power2.oy -= 2
    else
      @power.ox -= 2
      @power.oy += 1
      @power2.ox -= 1
      @power2.oy -= 1
    end
  end

  # Controllo dell'attivazione
  def update_activation
    $game_party.sinergy_active? ? activate : deactivate
  end

  # Attivazione
  def activate
    return if @active
    RPG::SE.new(ACTIV_SOUND).play
    color = Color.new(255, 255, 255)
    @background.flash(color, 60)
    @fill.flash(color, 60)
    @corner.flash(color, 60)
    @background.tone = B_ACTV_TONE
    @fill.tone = ACTIVE_TONE
    @light.tone = ACTIVE_TONE
    @corner.animate
    @active = true
    @sinergy_button.disappear if @sinergy_button.visible
  end

  # Disattivazione della Sinergia
  def deactivate
    return unless @active
    default_tone = Tone.new(0, 0, 0, 0)
    @sinergy_button.opacity = 255
    @background.tone = B_DEFT_TONE
    @fill.tone = default_tone
    @light.tone = default_tone
    @active = false
  end
end #sinergysprite

class Sprite_SinergyBar < Sprite_Base
  # aggiornamento
  def update
    super
    @animation_duration -= 1 if @animation != nil
    animate_random
  end

  # inizia l'animazione
  def animate
    start_animation($data_animations[H87_SINERGIC::CORNER_ANIM_ID])
  end

  # inizia un'animazione a caso
  def animate_random
    return if animation?
    return unless $game_party.sinergy_active?
    if Graphics.frame_count % 180 == 0
      anim_ids = H87_SINERGIC::CORNER_ACTIV_ANIM_IDS
      id = anim_ids[rand(anim_ids.size - 1)]
      start_animation($data_animations[id])
    end
  end
end

class Sprite_SinergyButton < Sprite_Base

  # inizializzazione
  def initialize(viewport = nil)
    super
    create_button_bitmap
  end

  # crea la bitmap del pulsante
  def create_button_bitmap
    bmp = Bitmap.new(24, 24)
    bmp.draw_key_icon(H87_SINERGIC::SINERGY_BUTTON, 0, 0)
    self.bitmap = bmp
    @contr_connected = Input.controller_connected?
  end

  # aggiornamento
  def update
    super
    return unless self.visible
    update_controller_plug
    update_move
  end

  # aggiorna la grafica del pulsante se viene sconnesso o connesso il pad
  def update_controller_plug
    return if Input.controller_connected? == @contr_connected
    create_button_bitmap
  end

  # aggiorna l'animazione di pressione
  def update_move
    if Graphics.frame_count % 30 == 0
      self.oy = -4
      self.flash(Color::SKYBLUE, 10)
    elsif self.oy < 0
      self.oy += 1
    end
  end

  # scompari
  def disappear
    start_animation($data_animations[H87_SINERGIC::SINERGY_ANIM_ID])
    fade(0, 10)
  end
end

class Game_Troop < Game_Unit

  # determina se è una boss fight
  def boss_fight?
    members.select { |member| member.boss_type?}.any?
  end
end
