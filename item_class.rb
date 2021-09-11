#==============================================================================
# ** Classi Oggetto di Holy87
# Difficoltà utente: ★
# v1.0
# -----------------------------------------------------------------------------
# Descrizione:
# Questo script ti permette di mostrare delle stelline sull'icona del'abilità,
# oggetto, arma o armatura che indicherà il suo valore.
# -----------------------------------------------------------------------------
# Uso:
# ●Installare lo script sotto Materials, prima del Main e sotto lo script
#  YEM ItemOverhaul, se c'è.
# ●Importa la grafica delle icone delle stelline, mettile nel tuo iconset,
#  quindi imposta l'ID dell'icona per ogni livello nella sezione della
#  configurazione
# ●Inserisci nella tag delle note la riga <classe: x>, dove x sta al valore
#  dell'arma, se vuoi impostare un valore manualmente per gli oggetti.
#==============================================================================
$imported = {} if $imported == nil
$imported['H87_ItemClass'] = true
module H87_ItemClass
  #==============================================================================
  # ** Configurazione
  # Configura lo script in pochi semplici passi!
  #==============================================================================
  #Imposta la propria icona per ogni livello dell'oggetto. Non è obbligatorio
  #usarne 5, puoi mettere quanti livelli vuoi.
  Icone = {
      #Liv  Icona
      1 => 368,
      2 => 369,
      3 => 370,
      4 => 371,
      5 => 372,
      6 => 373
  }

  # * Assegnazione automatica delle classi
  # Lo script assegna automaticamente il valore di un oggetto a seconda delle
  # sue proprietà. Ti sembra che lo script sia troppo generoso/tirchio per i
  # tuoi gusti? Modifica le proporzioni di stelle da dare a seconda della
  # tipologia! Imposta 0 se non vuoi che venga calcolato automaticamente il
  # valore per quella categoria.

  # Proporzioni Poteri
  Prop_Skill = 0
  # Proporzioni Oggetti
  Prop_Item = 0
  # Proporzioni Armi
  Prop_Weap = 50
  # Proporzioni Armature
  Prop_Armr = 50

  # Dove mostrare le stelle
  # :icon -> sull'icona
  # :name -> dopo il nome
  # :none -> da nessuna parte
  SHOW_ON = :icon # :icon o :none

  #============================================================================
  # ** FINE CONFIGURAZIONE **
  # Modificare da questo punto in poi è rischioso. Fallo solo se sai ciò che fai!
  #============================================================================


  # Testo per le tag
  Classe = /<classe:[ ]*(\d+)>/i

end

module RPG
  class BaseItem #Superclasse di tutti gli oggetti
    attr_accessor :tier #Nuovo attributo
    #--------------------------------------------------------------------------
    # * Restituisce il livello dell'oggetto
    #--------------------------------------------------------------------------
    # @return [Integer]
    def tier
      @tier;
    end

    #--------------------------------------------------------------------------
    # * Inizializza il livello della classe dell'oggetto
    #--------------------------------------------------------------------------
    def carica_cache_personale_class
      return if @cache_caricata2
      @cache_caricata2 = true
      @tier = 0
      case self
      when RPG::Skill
        calcola_valore_skill if H87_ItemClass::Prop_Skill > 0
      when RPG::Item
        calcola_valore_item if H87_ItemClass::Prop_Item > 0
      when RPG::Weapon
        calcola_valore_weapon if H87_ItemClass::Prop_Weap > 0
      when RPG::Armor
        calcola_valore_armor if H87_ItemClass::Prop_Armr > 0
      else
        # type code here
      end
      self.note.split(/[\r\n]+/).each { |riga|
        case riga
        when H87_ItemClass::Classe
          @tier = $1.to_i
        else
          # type code here
        end
      }
    end

    #--------------------------------------------------------------------------
    # * Calcola il valore dei poteri
    #--------------------------------------------------------------------------
    def calcola_valore_skill
      if self.base_damage < 0 #Se è una magia di cura
        valore = (self.base_damage - 100).to_f / -55.0
      else
        valore = (self.base_damage - 50).to_f / 10.0
        valore = 1 if valore < 1
      end
      valore += (self.atk_f.to_f + self.spi_f.to_f) / 3.1 if self.base_damage != 0
      #moltiplicatori bonus
      valore *= 2.3 if self.absorb_damage
      valore *= 1.5 if self.ignore_defense and self.base_damage > 0
      valore *= 1.9 if self.damage_to_mp
      valore += self.plus_state_set.size.to_f * 4.0
      valore += 20.0 if plus_state_set.include?($data_states[1])
      valore += self.minus_state_set.size.to_f * 2.0
      valore *= self.hit.to_f / 100.0
      valore *= 0.9 if self.physical_attack
      case self.scope
      when 2, 8, 10 #Totale
        valore *= 1.5
      when 3 #Nemico singolo continuo
        valore *= 2.0
      when 4 #Nemico a caso
        valore *= 0.8
      when 5 #Due nemici a caso
        valore *= 1.5
      when 6 #Tre nemici a caso
        valore *= 2.2
      else
        valore *= 1
      end
      valore = 100.0 if valore > 100
      valore = valore * H87_ItemClass::Icone.size
      valore = valore.to_f / 100.0
      valore *= H87_ItemClass::Prop_Skill / 100.0
      @tier = valore.to_i
    end

    #--------------------------------------------------------------------------
    # * Calcola il valore degli oggetti
    #--------------------------------------------------------------------------
    def calcola_valore_item
      valore = self.base_damage.to_f
      self.base_damage < 0 ? valore /= -60.0 : valore /= 17.0
      valore += (self.atk_f.to_f + self.spi_f.to_f) / 3.1 if self.base_damage != 0
      valore *= 2.3 if self.absorb_damage
      valore *= 1.5 if self.ignore_defense and self.base_damage > 0
      valore *= 1.9 if self.damage_to_mp
      valore += self.plus_state_set.size.to_f * 4.0
      valore += 20.0 if plus_state_set.include?($data_states[1])
      valore += self.minus_state_set.size.to_f * 1.5
      if parameter_type != 0
        case parameter_type
        when 1 #Aumento HP
          valore += parameter_points.to_f * 0.4
        when 2 #Aumento MP
          valore += parameter_points.to_f * 2.0
        when 3..6 #Tutti gli altri
          valore += parameter_points.to_f * 6.7
        else
          # type code here
        end
      end
      valore += hp_recovery.to_f * 0.02
      valore += mp_recovery.to_f * 0.05
      valore += hp_recovery_rate.to_f * 0.6
      valore += mp_recovery_rate.to_f * 0.6
      case self.scope
      when 2, 8, 10
        valore *= 1.5
      when 3
        valore *= 1.5
      when 4
        valore *= 0.8
      when 5
        valore *= 1.25
      when 6
        valore *= 2.5
      else
        valore *= 1
      end
      valore = 100.0 if valore > 100
      valore = valore * H87_ItemClass::Icone.size
      valore = valore.to_f / 100.0
      valore *= H87_ItemClass::Prop_Item / 100.0
      @tier = valore.to_i
    end

    #--------------------------------------------------------------------------
    # * Calcola il valore delle armi
    #--------------------------------------------------------------------------
    def calcola_valore_weapon
      valore = 7.0
      valore += self.atk.to_f * 1.4
      valore += self.def.to_f * 1.2
      valore += self.spi.to_f * 1.5
      valore += self.agi.to_f * 1.2
      valore += self.state_set.size.to_f * 15.0 # Bonus per ogni status
      valore += (self.element_set.size - 1).to_f * 5.0 if element_set.size != 0
      valore *= self.hit.to_f / 100.0 #Mira
      # Bonus dell'arma
      valore *= 0.7 if self.two_handed # Valore minore del 30% se a due mani
      valore *= 1.3 if self.fast_attack
      valore *= 1.4 if self.critical_bonus
      valore *= 2.0 if self.dual_attack
      valore = 100.0 if valore > 100
      valore = valore * H87_ItemClass::Icone.size
      valore = valore.to_f / 100.0
      valore *= H87_ItemClass::Prop_Weap / 100.0
      @tier = valore.to_i
    end

    #--------------------------------------------------------------------------
    # * Calcola il valore delle armature
    #--------------------------------------------------------------------------
    def calcola_valore_armor
      valore = 1.0
      case self.kind
      when 0 #valore per scudo
        valore += self.atk.to_f * 1.3
        valore += self.def.to_f * 4.0
        valore += self.spi.to_f * 1.3
        valore += self.agi.to_f * 1.3
      when 1 #se è un elmo
        valore += self.atk.to_f * 1.3
        valore += self.def.to_f * 3.8
        valore += self.spi.to_f * 1.3
        valore += self.agi.to_f * 1.3
      when 2 #se è un'armatura
        valore += self.atk.to_f * 1.3
        valore += self.def.to_f * 3.0
        valore += self.spi.to_f * 1.3
        valore += self.agi.to_f * 1.3
      when 3 #se è un accessorio
        valore += self.atk.to_f * 2.0
        valore += self.def.to_f * 2.0
        valore += self.spi.to_f * 2.0
        valore += self.agi.to_f * 2.0
      else
        # type code here
      end
      valore += self.state_set.size.to_f * 5.0
      valore += self.element_set.size.to_f * 5.0
      valore += self.eva.to_f * 3.0
      valore += 80.0 if self.auto_hp_recover
      valore += 80.0 if self.half_mp_cost
      valore += 50 if self.prevent_critical
      valore += 80.0 if self.double_exp_gain
      valore = 100.0 if valore > 100
      valore = valore * H87_ItemClass::Icone.size
      valore = valore.to_f / 100.0
      valore *= H87_ItemClass::Prop_Armr / 100.0
      @tier = valore.to_i
    end
  end

  #BaseItem
end #Usable

#==============================================================================
# ** Window_Base
#==============================================================================
class Window_Base < Window
  alias disegna_nome_oggetto draw_item_name
  #-----------------------------------------------------------------------------
  # * draw item name
  # @param [RPG::BaseItem] item
  # @param [Fixnum] x
  # @param [Fixnum] y
  # @param [Boolean] enabled
  #-----------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    disegna_nome_oggetto(item, x, y, enabled, width)
    if item != nil and item.tier != 0 and H87_ItemClass::SHOW_ON != :none
      x += H87_ItemClass::SHOW_ON == :icon ? 0 : 24 + text_size(item.name).width + 1
      draw_icon(H87_ItemClass::Icone[item.tier], x, y, enabled)
    end
  end
end

#Window_Base

#==============================================================================
# ** Scene_Title
#==============================================================================
class Scene_Title < Scene_Base
  alias carica_db2 load_bt_database unless $@
  alias carica_db_22 load_database unless $@
  #-----------------------------------------------------------------------------
  # * Alias metodo load_bt_database
  #-----------------------------------------------------------------------------
  def load_bt_database
    carica_db2
    carica_skills_class
    carica_item_class
    carica_armor_class
    carica_weapon_class
  end

  #-----------------------------------------------------------------------------
  # * Alias metodo load_database
  #-----------------------------------------------------------------------------
  def load_database
    carica_db_22
    carica_skills_class
    carica_item_class
    carica_armor_class
    carica_weapon_class
  end

  #-----------------------------------------------------------------------------
  # * inizializza skill nel caricamento
  #-----------------------------------------------------------------------------
  def carica_skills_class
    $data_skills.each { |skill|
      next if skill == nil
      skill.carica_cache_personale_class
    }
  end

  #-----------------------------------------------------------------------------
  # * inizializza oggetti nel caricamento
  #-----------------------------------------------------------------------------
  def carica_item_class
    $data_items.each { |item|
      next if item == nil
      item.carica_cache_personale_class
    }
  end

  #-----------------------------------------------------------------------------
  # * inizializza armature nel caricamento
  #-----------------------------------------------------------------------------
  def carica_armor_class
    $data_armors.each { |armor|
      next if armor == nil
      armor.carica_cache_personale_class
    }
  end

  #-----------------------------------------------------------------------------
  # * inizializza armi nel caricamento
  #-----------------------------------------------------------------------------
  def carica_weapon_class
    $data_weapons.each { |weapon|
      next if weapon == nil
      weapon.carica_cache_personale_class
    }
  end
end

# scene_title

#==============================================================================
# ** Compatibilità Yanfly
#==============================================================================
if $imported["ItemOverhaul"]
  class Window_ItemList < Window_Selectable
    alias nuovo_draw_item draw_obj_name

    def draw_obj_name(obj, rect, enabled)
      nuovo_draw_item(obj, rect, enabled)
      if obj != nil and obj.tier != 0
        draw_icon(H87_ItemClass::Icone[obj.tier], rect.x, rect.y, enabled)
      end
    end
  end
end