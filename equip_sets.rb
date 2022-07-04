#===============================================================================
# SET EQUIPAGGIAMENTI MODIFICATO PER OVERDRIVE
#===============================================================================
# Autore: Holy87
# Versione: 2.0
# Difficoltà utente: ★★
#-------------------------------------------------------------------------------
# In molti giochi di ruolo occidentali, se riesci a trovare ed a indossare
# tutti i pezzi di uno stesso equipaggiamento ottieni svariati bonus. Ad esempio,
# trovare l'armatura del drago + guanti del drago + elmo del drago + scudo del
# drago potrebbe conferirti immunità al fuoco e maggiore attacco se indossati
# tutti insieme. In questo modo si dà più importanza alle armors di quanto se
# ne fosse data in passato.
# È anche possibile fare un set se due armi specifiche sono equipaggiate insieme
# (ovviamente il personaggio deve poter equipaggiare due armi).
# Lo script assegna uno stato alterato specifico all'eroe quando viene attivato
# uno specifico set. Installare uno script che estende le possibilità degli
# stati alterati renderebbe molto più utile questo script.
# * ATTENZIONE * lo script è stato concepito per attivare 1 solo bonus set
# armatura, per bonus set multipli viene preso quello con ID più alto.
#-------------------------------------------------------------------------------
# Istruzioni:
# Copiare lo script sotto Materials, prima del Main.
# Configurare in basso i set con i relativi equipaggiamenti richiesti. Ricordati
# che se vengono soddisfatte le condizioni per due set diversi, solo quello con
# ID più alto viene soddisfatto.
# In questo modo puoi impostare diversi bonus a seconda se l'equipaggiamento è
# completo oppure no.
# 
#-------------------------------------------------------------------------------
# Compatibilità:
# Game_Battler -> Alias del metodo states
# Game_Actor   -> Alias del metodo change_equip
#-------------------------------------------------------------------------------

#===============================================================================
# ** Impostazioni
#===============================================================================
module SETS
  Armors =   {
      #Configura i vari set. A sinistra lo stato da attivare, nell'array tutti gli
      #equipaggiamenti necessari.
      #Stato => [Armatura1,Armatura2,Armatura3,...]
      188=>[26,68],   #Armors Alluminio Huges
      190=>[6,31,77], #Armors Ferro + Scudo
      189=>[31,77],   #Armors Ferro
      191=>[30,76],   #Armors Folletto
      192=>[29,69],   #Armors Cuoio
      194=>[9,40,81], #Armors Imperiale + Scudo
      193=>[40,81],   #Armors Imperiale
      195=>[42,83],   #Armors Mistico
      196=>[41,82],   #Armors Fuorilegge
      198=>[10,43,84],#set nemesi+ scudo
      197=>[43,84],   #set nemesi
      200=>[11,44,85],#set custode + scudo
      199=>[44,85],   #set custode
      201=>[45,86],   #set benedetto
      202=>[46,87],   #set elfico
      203=>[47,89],   #set vento
      204=>[48,88],   #set caccia
      211=>[27,65],   #set magico
      231=>[25,67],   #set alluminio classico
      235=>[41,82],#set fuorilegge
      236=>[47,89],#set vento
  }

  #Configura le coppie di armi. A sinistra lo stato da attivare, nell'array
  #le coppie di armi necessarie per attivare il bonus.
  #Stato => [Arma1, Arma2]
  Weapons = {
      205=>[31,32],
      209=>[40,15],
      206=>[40,36],
      210=>[130,133]
  }

end #configurazione

$imported = {} if $imported == nil
$imported["H87_EquipArmorss"] = 2.0

#===============================================================================
# ** classe Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  alias change_equip_set change_equip unless $@

  # restituisce il set soddisfatto o nil.
  def armor_set
    armor_ids = armors.compact.map{|a| a.real_id}
    SETS::Armors.select{|k,v| (v - armor_ids).empty? }.map{ |a| a[0] }.max
  end

  # restituisce il set soddisfatto dell'arma con maggiore priorità
  # o nil se nessuno è soddisfatto
  def weapon_set
    weapon_ids = weapons.compact.map { |w| w.real_id }
    SETS::Weapons.select{|k,v| (v - weapon_ids).empty? }.map{ |a| a[0] }.max
  end

  # cambia l'equipaggiamento dell'eroe
  # @param [Integer] equip_type
  # @param [RPG::Weapon, RPG::Armor] item
  def change_equip(equip_type, item, test = false)
    change_equip_set(equip_type, item, test)
    apply_bonus_set
  end

  # ricalcola i bonus set dopo il cambio equipaggiamenti
  def apply_bonus_set
    init_bonus_sets
    add_set_bonus(armor_set)
    add_set_bonus(weapon_set)
  end

  # aggiunge il bonus del set all'eroe. Ignora se bonus è nil
  # @param [Integer] bonus
  def add_set_bonus(bonus)
    return if bonus.nil?
    return if @set_bonuses.include?(bonus)
    @set_bonuses.push(bonus)
  end

  # inizializza i bonus set e cancella tutti
  def init_bonus_sets
    @set_bonuses = []
  end

  # restituisce i bonus set attivati
  # @return [Array<RPG::State>]
  def set_bonuses
    init_bonus_sets if @set_bonuses.nil?
    @set_bonuses.compact.map { |state_id| $data_states[state_id] }
  end
end #game_actor

#===============================================================================
# ** classe Game_Enemy
#===============================================================================
class Game_Enemy < Game_Battler
  # restituisce i bonus set attivati
  # @return [Array<RPG::State>]
  def set_bonuses
    [] # array vuoto perché non hanno equip
  end
end

#===============================================================================
# ** classe Game_Battler
#===============================================================================
class Game_Battler
  alias no_set_states states unless $@

  # restituisce gli status attuali + bonus set attivati
  # @return [Array<RPG::State>]
  def states
    no_set_states + set_bonuses
  end
end #game_battler

class RPG::Armor
  # bonus set. 0 se non ne ha, altrimenti restituisce
  # lo status bonus
  def set_bonus
    @set_bonus ||= init_set_bonus
  end

  def has_variant_set?
    return false if set_bonus == 0
    return false if SETS::Armors[set_bonus + 1].nil?
    (SETS::Armors[set_bonus] - SETS::Armors[set_bonus + 1]).empty?
  end

  # @return [Integer, nil]
  def facultative_set_equip_id
    return nil unless has_variant_set?
    (SETS::Armors[set_bonus + 1] - SETS::Armors[set_bonus]).first
  end

  private

  def init_set_bonus
    @set_bonus = 0
    SETS::Armors.each_pair do |state_id, armors|
      if armors.include? @id
        @set_bonus = state_id
        return @set_bonus
      end
    end
    @set_bonus
  end
end