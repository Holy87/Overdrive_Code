$imported = {} if $imported == nil
$imported["H87-SkillCost"] = 1.3
#===============================================================================
# Cost abilità di Holy87
# Difficoltà utente: ★★
# Versione 1.3
# Changelog v1.3
# - Refactoring leggero del codice
# - Possibilità di impostare il costo MP in base
#   all'attacco o Spirito del personaggio (in %)
# - Possibilità di impostarei il numero di oggetti richiesti
# - Possibilità di moltiplicare il numero di oggetti per nemici o
#   per alleati (per le skill che colpiscono più bersagli)
# Changelog v1.2
# - Possibilità di richiedere un oggetto
# - Risolti alcuni bug, migliorato il codice
# Changelog v1.1
# - Inserite notetag abilità
# - possibilità di inserire cost in %
# - visualizzazione contemporanea dei costi
# - possibilità di personalizzare il colore
#===============================================================================
# Questo script, compatibile al 100% con il tankentai, fa in modo che le abilità
# consumino HP, denaro o una variabile scelta, valore fisso o percentuale.
# Inserisci nelle note dell'abilità i seguenti codici:
# <cost hp: x> o <cost hp: x%> per cost hp
# <cost mp: x> o <cost mp: x%> per cost mp
# <cost oro: x> o <cost oro: x%> per cost denaro
# <cost var: x> o <cost var: x%> per il cost di una variabile (vedere giù)
# <usa oggetto: x> per fare in modo che il potere consumi un oggetto (x=id)
# <cost oggetto x: y> per y oggetti x.
# <molt oggetto x bersaglio> moltiplica il numero di oggetti per i bersagli
# è possibile far costare un'abilità un numero di MP superiore a 999
# è possibile inserire più tipi di costi (es. una abilità che consuma HP e MP)
# è possibile inserire sia un valore fisso che percentuale. In questo caso i
# valori vengono sommati.
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main.
# Inserisci nelle notetag dei poteri la tag desiderata.
#===============================================================================
# Compatibilità: Compatibile al 100% con il Tankentai SBS 3.4e + ATB
#
# Window_Skill -> sostituisce il metodo draw_item
# Game_Battler -> alias di skill_can_use?
# Game_Battler -> sostituisce il metodo calc_mp_cost
# Scene_Battle -> alias di execute_action_skill
# Scene_Skill -> alias di use_skill_nontarget
#===============================================================================
# Note:
# Anche se viene visualizzato il cost di un solo tipo, l'abilità può sfruttare
# sia HP, sia MP, Denaro e variabile contemporaneamente.
# Anche la visualizzazione del cost MP default è stata cambiata.
# Cost MP -> Colore Azzurro
# Cost HP -> Colore Giallo-Arancione
# Cost Denaro -> Colore Verde
# Cost Variabile -> Colore Rosso chiaro
# Cost Oggetto -> Mostra l'icona dell'oggetto richiesto.
# Gli accessori che dimezzano il cost MP funzionano anche su HP, Oro e Var.
#===============================================================================
# CONFIGURAZIONE
#===============================================================================
module H87_SKILL_COSTS
#------------------------------------------------------------------------------- 
# PERSONALIZZAZIONE
#-------------------------------------------------------------------------------
# Seleziona la variabile da usare come cost
  VARIABLE_ID = 281
# Imposta il simbolo da usare per il cost della variabile
  VARIABLE_SYM = "S"

# Gli accessori che dimezzano il cost MP influenzano anche il cost HP?
  HALF_HP_COST = true
# Gli accessori che dimezzano il cost MP influenzano anche il cost Denaro?
  HALF_GOLD_COST = true
# Gli accessori che dimezzano il cost MP influenzano anche il cost Variabile?
  HALF_VARIABLE_COST = true

# Seleziona il colore dei vari costi
  ColoreHP = 14
  ColoreMP = 23
  ColoreG = 3
  ColoreV = 2

# Spazio tra un cost e l'altro nel caso di abilità con più costi
  SPACING = 12
#-------------------------------------------------------------------------------
# FINE CONFIGURAZIONE
# Modifica gli script in seguito solo se sai ciò che fai!
#-------------------------------------------------------------------------------

#Stringhe
  HP_COST_EXPR = /<costo hp:[ ]*(\d+)>/i
  MP_COST_EXPR = /<costo mp:[ ]*(\d+)>/i
  GOLD_COST_EXPR = /<costo oro:[ ]*(\d+)>/i
  VARIABLE_COST_EXPR = /<costo var:[ ]*(\d+)>/i
  ITEM_COST_EXPR = /<usa oggetto:[ ]*(\d+)>/i
  MULTI_ITEM_COST_EXPR = /<costo oggetto[ ]*(\d+):[ ]*(\d+)>/i

  HP_COST_PER = /<costo hp:[ ]*(\d+)([%％])>/i
  MP_COST_PER = /<costo mp:[ ]*(\d+)([%％])>/i
  MP_COST_BATK = /<costo mp su[ ]+(\d+)([%％]) attacco base>/i
  MP_COST_BSPI = /<costo mp su[ ]+(\d+)([%％]) spirito base>/i
  GOLD_COST_PER = /<costo oro:[ ]*(\d+)([%％])>/i
  VARIABLE_COST_PER = /<costo var:[ ]*(\d+)([%％])>/i
  MUL_ITEM_N_PER = /<molt oggetto x bersaglio>/i

# Restituisce il valore della variabile scelta
  def self.var_act
    return $game_variables[VARIABLE_ID]
  end

end # fine del modulo


#===============================================================================
# * Classe Game_Battler
#===============================================================================

class RPG::Skill
  #nuovi attributi
  attr_reader :hp_cost
  attr_reader :gold_cost
  attr_reader :variable_cost
  attr_reader :hp_cost_per
  attr_reader :mp_cost_per
  attr_reader :gold_cost_per
  attr_reader :variable_cost_per
  attr_reader :consume_item
  attr_reader :consume_item_n
  attr_reader :base_atk_mp_cost
  attr_reader :base_spi_mp_cost
  attr_reader :multiply_per_target

  # Inizializzazione dei nuovi attributi - lettura notetag
  def load_skill_cost_cache
    return if @skill_cost_cache_loaded
    @skill_cost_cache_loaded = true
    @consume_item_n = 0
    @hp_cost = 0
    @gold_cost = 0
    @variable_cost = 0
    @hp_cost_per = 0
    @mp_cost_per = 0
    @gold_cost_per = 0
    @variable_cost_per = 0
    @consume_item = 0
    @base_atk_mp_cost = 0
    @base_spi_mp_cost = 0
    @multiply_per_target = false
    self.note.split(/[\r\n]+/).each do |row|
      case row
        #---
      when H87_SKILL_COSTS::HP_COST_EXPR
        @hp_cost = $1.to_i
      when H87_SKILL_COSTS::MP_COST_EXPR
        @mp_cost = $1.to_i
      when H87_SKILL_COSTS::GOLD_COST_EXPR
        @gold_cost = $1.to_i
      when H87_SKILL_COSTS::VARIABLE_COST_EXPR
        @variable_cost = $1.to_i
      when H87_SKILL_COSTS::HP_COST_PER
        @hp_cost_per = $1.to_i
      when H87_SKILL_COSTS::MP_COST_PER
        @mp_cost_per = $1.to_i
      when H87_SKILL_COSTS::GOLD_COST_PER
        @gold_cost_per = $1.to_i
      when H87_SKILL_COSTS::VARIABLE_COST_PER
        @variable_cost_per = $1.to_i
      when H87_SKILL_COSTS::ITEM_COST_EXPR
        @consume_item = $1.to_i
        @consume_item_n = 1
      when H87_SKILL_COSTS::MULTI_ITEM_COST_EXPR
        @consume_item = $1.to_i
        @consume_item_n = $2.to_i
      when H87_SKILL_COSTS::MP_COST_BATK
        @base_atk_mp_cost = $1.to_f / 100
      when H87_SKILL_COSTS::MP_COST_BSPI
        @base_spi_mp_cost = $1.to_f / 100
      when H87_SKILL_COSTS::MUL_ITEM_N_PER
        @multiply_per_target = true
      else
        # nothing
      end
    end
  end

  def target_number
    case @scope
    when 0, 2, 4, 7, 9, 11;
      0
    when 2;
      $game_temp.in_battle ? $game_troop.alive_members : 1
    when 3;
      2
    when 5;
      $game_temp.in_battle ? [$game_troop.alive_members.size, 2].min : 1
    when 6;
      $game_temp.in_battle ? [$game_troop.alive_members.size, 3].min : 1
    when 8;
      $game_party.alive_members.size
    when 10;
      $game_party.dead_members.size
    else
      ; 1
    end
  end

end #skill

#===============================================================================
# * Classe Scene_Title
#===============================================================================
class Scene_Title < Scene_Base

  # *Alias metodo load_bt_database
  alias load_bt_db_for_skill_cost load_bt_database unless $@

  def load_bt_database
    load_bt_db_for_skill_cost
    load_skill_costs
  end

  # *Alias metodo load_database
  alias load_db_for_skill_cost load_database unless $@

  def load_database
    load_db_for_skill_cost
    load_skill_costs
  end

  # Inizializza nel caricamento
  def load_skill_costs
    for skill in $data_skills
      next if skill == nil
      skill.load_skill_cost_cache
    end
  end
end # scene_title

#===============================================================================
# * Classe Game_Battler
#===============================================================================
class Game_Battler
  # *Alias metodo skill_can_use?
  alias nosenza skill_can_use? unless $@

  def skill_can_use?(skill)
    return false if calc_hp_cost(skill) > hp
    return false if calc_gold_cost(skill) > $game_party.gold
    return false if calc_var_cost(skill) > H87_SKILL_COSTS.var_act
    return false if no_item_required?(skill)
    return false if no_req_state(skill)
    nosenza(skill)
  end

  # RISCRITTURA del metodo per calcolare il cost mp
  # @param [RPG::Skill] skill
  def calc_mp_cost(skill)
    cost = 0
    cost += skill.mp_cost
    cost += maxmp * skill.mp_cost_per / 100
    cost += (base_spi + @spi_plus) * skill.base_spi_mp_cost
    cost += (base_atk + @atk_plus) * skill.base_atk_mp_cost
    cost /= 2 if half_mp_cost
    cost.to_i
  end

  # metodo per calcolare cost hp
  # @param [RPG::Skill] skill
  def calc_hp_cost(skill)
    cost = 0
    cost += skill.hp_cost
    cost += maxhp * skill.hp_cost_per / 100
    cost /= 2 if half_mp_cost and H87_SKILL_COSTS::HALF_HP_COST
    cost
  end

  # metodo per calcolare cost oro
  # @param [RPG::Skill] skill
  def calc_gold_cost(skill)
    cost = 0
    cost += skill.gold_cost
    cost += $game_party.gold * skill.gold_cost_per / 100
    cost /= 2 if half_mp_cost and H87_SKILL_COSTS::HALF_GOLD_COST
    cost
  end

  # metodo per calcolare cost variabile
  # @param [RPG::Skill] skill
  def calc_item_cost(skill)
    cost = skill.consume_item_n
    cost *= skill.target_number if skill.multiply_per_target
    cost /= 2 if half_mp_cost && cost > 1
    cost
  end

  # metodo per calcolare cost variabile
  # @param [RPG::Skill] skill
  def calc_var_cost(skill)
    cost = 0
    cost += skill.variable_cost
    cost += H87_SKILL_COSTS.var_act * skill.variable_cost_per / 100
    cost /= 2 if half_mp_cost and H87_SKILL_COSTS::HALF_VARIABLE_COST
    cost
  end

  # restituisce true se l'oggetto richiesto dalla skill non è posseduto
  # @param [RPG::Skill] skill
  def no_item_required?(skill)
    return false if skill.consume_item == 0
    item = $data_items[skill.consume_item]
    return false if $game_party.item_number(item) >= calc_item_cost(skill)
    true
  end
end # game_battler

#===============================================================================
# * Classe Window_Skill
#===============================================================================
class Window_Skill < Window_Selectable

  # @param [Rect] rect
  # @param [RPG::Skill] skill
  def draw_skill_cost(rect, skill)
    width = rect.width
    y = rect.ys

    skill = @data[index]
    width = contents_width
    width = draw_mp_cost skill, width, y, actor, enabled
    width = draw_hp_cost skill, width, y, actor, enabled
    width = draw_gold_cost skill, width, y, actor, enabled
    width = draw_var_cost skill, width, y, actor, enabled
    draw_item_cost skill, width, y, actor, enabled
  end

  # @param [RPG::Skill] skill abilità in oggetto
  # @param [Integer] width larghezza rimanente
  # @param [Integer] y coordinata y
  # @param [Game_Actor] actor eroe che possiede l'abilità
  # @param [true, false] enabled se abilitato o diasabilitato
  # @return [Integer] la nuova larghezza sottratta
  def draw_mp_cost(skill, width, y, actor, enabled)
    return width if actor.calc_mp_cost(skill) == 0
    change_color mp_cost_color, enabled
    cost = sprintf('%d%s', actor.calc_mp_cost(skill), Vocab.mp_a)
    draw_text(0, y, width, line_height, cost, 2)
    width - text_size(cost).width - H87_SKILL_COSTS::SPACING
  end

  # @param [RPG::Skill] skill abilità in oggetto
  # @param [Integer] width larghezza rimanente
  # @param [Integer] y coordinata y
  # @param [Game_Actor] actor eroe che possiede l'abilità
  # @param [true, false] enabled se abilitato o diasabilitato
  # @return [Integer] la nuova larghezza sottratta
  def draw_hp_cost(skill, width, y, actor, enabled)
    return width if actor.calc_hp_cost(skill) == 0
    change_color hp_cost_color, enabled
    cost = sprintf('%d%s', actor.calc_hp_cost(skill), Vocab.hp_a)
    draw_text(0, y, width, line_height, cost, 2)
    width - text_size(cost).width - H87_SKILL_COSTS::SPACING
  end

  # @param [RPG::Skill] skill abilità in oggetto
  # @param [Integer] width larghezza rimanente
  # @param [Integer] y coordinata y
  # @param [Game_Actor] actor eroe che possiede l'abilità
  # @param [true, false] enabled se abilitato o diasabilitato
  # @return [Integer] la nuova larghezza sottratta
  def draw_gold_cost(skill, width, y, actor, enabled)
    return width if actor.calc_gold_cost(skill) == 0
    change_color gold_cost_color, enabled
    cost = sprintf('%d%s', actor.calc_gold_cost(skill), Vocab.gold)
    draw_text(0, y, width, line_height, cost, 2)
    width - text_size(cost).width - H87_SKILL_COSTS::SPACING
  end

  # @param [RPG::Skill] skill abilità in oggetto
  # @param [Integer] width larghezza rimanente
  # @param [Integer] y coordinata y
  # @param [Game_Actor] actor eroe che possiede l'abilità
  # @param [true, false] enabled se abilitato o diasabilitato
  # @return [Integer] la nuova larghezza sottratta
  def draw_variable_cost(skill, width, y, actor, enabled)
    return width if actor.calc_var_cost(skill) == 0
    change_color var_cost_color, enabled
    cost = sprintf('%d%s', actor.calc_var_cost(skill), Vocab.var_skill)
    draw_text(0, y, width, line_height, cost, 2)
    width - text_size(cost).width - H87_SKILL_COSTS::SPACING
  end

  # @param [RPG::Skill] skill abilità in oggetto
  # @param [Integer] width larghezza rimanente
  # @param [Integer] y coordinata y
  # @param [Game_Actor] actor eroe che possiede l'abilità
  # @param [true, false] enabled se abilitato o diasabilitato
  # @return [Integer] la nuova larghezza sottratta
  def draw_item_cost(skill, width, y, actor, enabled)
    return width if actor.calc_item_cost(skill) == 0
    change_color normal_color, enabled
    cost = sprintf('x%d', actor.calc_item_cost(skill))
    draw_text(0, y, width, line_height, cost, 2)
    x = width - text_size(cost).width - 24
    draw_icon($data_items[skill.consume_item].icon_index, x, y, enabled)
    x
  end

end # window_skill

#===============================================================================
# * Classe Scene_Battle
#===============================================================================
class Scene_Battle < Scene_Base

  # alias del metodo execute_action_skill
  alias consumahp execute_action_skill unless $@

  def execute_action_skill
    consumahp
    return if @active_battler.nil?
    skill = @active_battler.action.skill
    return if skill == nil
    @active_battler.hp -= @active_battler.calc_hp_cost(skill) unless @active_battler.dead? #calcola HP cost
    $game_party.lose_gold(@active_battler.calc_gold_cost(skill)) unless @active_battler.dead?
    $game_variables[H87_SKILL_COSTS::VARIABLE_ID] -= @active_battler.calc_var_cost(skill)
    consume_item_skill(skill.consume_item, @active_battler.calc_item_cost(skill)) if skill.consume_item != 0
  end

  # Consuma l'oggetto
  # @param [Object] item_id
  # @param [Object] item_number
  def consume_item_skill(item_id, item_number)
    item = $data_items[id_oggetto]
    $game_party.lose_item(item, numero)
  end

end #scene_battle

#===============================================================================
# * Classe Window_Base
#===============================================================================

class Window_Base < Window
  # aggiunta di nuove colorazioni!
  # @return [Color]
  def mp_cost_color;
    text_color(H87_SKILL_COSTS::ColoreMP);
  end

  # @return [Color]
  def hp_cost_color;
    text_color(H87_SKILL_COSTS::ColoreHP);
  end

  # @return [Color]
  def gold_cost_color;
    text_color(H87_SKILL_COSTS::ColoreG);
  end

  # @return [Color]
  def var_cost_color;
    text_color(H87_SKILL_COSTS::ColoreV);
  end

end #window_base

#===============================================================================
# * Classe Scene_Skill
#===============================================================================
class Scene_Skill < Scene_Base

  # alias di use_skill_nontarget
  alias usasknot use_skill_nontarget unless $@

  def use_skill_nontarget
    @actor.hp -= @actor.calc_hp_cost(@skill)
    $game_party.lose_gold(@actor.calc_gold_cost(@skill))
    $game_variables[H87_SKILL_COSTS::VARIABLE_ID] -= @actor.calc_var_cost(@skill)
    $game_party.lose_item($data_items[@skill.consume_item], 1) if @skill.consume_item != 0
    usasknot
  end

end #scene_skill

#===============================================================================
# * Modulo Vocab
#===============================================================================
module Vocab
  # aggiunta del simbolo della variabile come vocab
  def self.var_skill
    return H87_SKILL_COSTS::VARIABLE_SYM
  end
end #vocab