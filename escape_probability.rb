$imported = {} if $imported == nil
$imported["H87_Escape"] = true
#===============================================================================
# ** Probabilità di fuga **
# Versione: 1.1 (19/11/2019)
# Difficoltà utente: ★★
#===============================================================================
# DESCRIZIONE:
# Questo script permette di modificare le probabilità di fuga grazie ad
# equipaggiamenti e stati alterati. Inoltre modifica il calcolo delle
# probabilità di fuga, considerando solo i nemici (e gli alleati) attualmente
# in grado di muoversi. Questo significa che sarà molto più facile fuggire con
# nemici addormentati o paralizzati, e più difficile se lo stesso è con gli
# alleati.
#===============================================================================
# UTILIZZO:
# Installare lo script sotto Materials e prima del Main.
# Inserire, nel riquadro delle note dello stato o dell'equipaggiamento, la
# seguente etichetta:
# <fuga: x> dove x è il valore (valori positivi aumentano le probabilità, valori
# negativi le diminuiscono) (max 100: probabilità sicura).
# I bonus sono cumulativi.
# Se vuoi far fuggire il gruppo, basta che scrivi in un chiama script:
# force_escape
# puoi creare abilità che chiamano un evento comune con questa skill. La fuga
# non funzionerà contro i boss.
# force_escape(true) fa fuggire gli eroi dall'incontro anche se si tratta di un
# boss.
#===============================================================================
# COMPATIBILITA':
# Compatibile con quasi tutti gli script.
#===============================================================================
module H87_Escape
  # IMPOSTAZIONI

  #Cambia il valore di questa costante per aggiustare il valore base delle
  #probabilità di fuga:
  ESCAPE_ADJUSTER = 15

#===============================================================================
# ** FINE CONFIGURAZIONE **
# Attenzione: Non modificare ciò che c'è oltre, a meno che tu non sappia ciò che
# fai!
#===============================================================================

  EB = /<(?:FUGA|fuga):[ ]*(\d+)>/i
end

module EscapeBonusItem
  attr_reader :escape_bonus

  def escape_bonus
    @escape_bonus
  end

  def carica_cache_personale_esc
    return if @cache_caricatae
    @cache_caricatae=true
    @escape_bonus = 0
    self.note.split(/[\r\n]+/).each { |riga|
      case riga
      when H87_Escape::EB
        @escape_bonus += $1.to_i
      else
        # type code here
      end
    }
  end
end

#===============================================================================
# ** Game_Actor
#===============================================================================
class Game_Actor < Game_Battler

  # restituisce il bonus di fuga
  def escape_bonus
    features_sum :escape_bonus
  end
end # game_actor

#===============================================================================
# ** Classe Armi
#===============================================================================
class RPG::Weapon
  include EscapeBonusItem
end

#===============================================================================
# ** Classe Armature
#===============================================================================
class RPG::Armor
  include EscapeBonusItem
end

#===============================================================================
# ** Classe Status
#===============================================================================
class RPG::State
  include EscapeBonusItem
end

#==============================================================================
# ** Scene_Title
#==============================================================================
class Scene_Title < Scene_Base
  #-----------------------------------------------------------------------------
  # *Alias metodo load_bt_database
  #-----------------------------------------------------------------------------
  alias l_bt_de load_bt_database unless $@
  def load_bt_database
    l_bt_de
    setup_escape_states
    setup_escape_armors
    setup_escape_weapons
  end
  #-----------------------------------------------------------------------------
  # *Alias metodo load_database
  #-----------------------------------------------------------------------------
  alias ld_de load_database unless $@
  def load_database
    ld_de
    setup_escape_states
    setup_escape_armors
    setup_escape_weapons
  end
  #-----------------------------------------------------------------------------
  # *Inizializza nel caricamento
  #-----------------------------------------------------------------------------
  def setup_escape_states
    $data_states.each do |state|
      next if state == nil
      state.carica_cache_personale_esc
    end
  end
  #-----------------------------------------------------------------------------
  # *setup_escape_armors
  #-----------------------------------------------------------------------------
  def setup_escape_armors
    $data_armors.each do |armor|
      next if armor == nil
      armor.carica_cache_personale_esc
    end
  end
  #-----------------------------------------------------------------------------
  # *setup_escape_weapons
  #-----------------------------------------------------------------------------
  def setup_escape_weapons
    $data_weapons.each do |weapon|
      next if weapon == nil
      weapon.carica_cache_personale_esc
    end
  end
end # scene_title

class Game_Unit
  def total_agi
    members.select {|member| member.movable?}.inject(0) { |s, m| s + m.agi }
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #-----------------------------------------------------------------------------
  # *Alias metodo start
  #-----------------------------------------------------------------------------
  alias re_start start unless $@
  def start
    re_start
    @sure_escape = false
  end
  #-----------------------------------------------------------------------------
  # * cambia le prob. di fuga
  #-----------------------------------------------------------------------------
  def make_escape_ratio
    actors_agi = $game_party.total_agi
    enemies_agi = $game_troop.total_agi
    @escape_ratio = 150 - 100 * enemies_agi / actors_agi
    @escape_ratio += H87_Escape::ESCAPE_ADJUSTER
    @escape_ratio += actors_escape_bonus
  end
  #-----------------------------------------------------------------------------
  # * controlla il bonus di fuga degli eroi
  #-----------------------------------------------------------------------------
  def actors_escape_bonus
    bonus = $game_party.members.inject(0) { |b, member| b + member.escape_bonus }
    bonus += 999999 if @sure_escape
    bonus
  end
  #-----------------------------------------------------------------------------
  # * viene eseguito quando la fuga è obbligata da eventi.
  #-----------------------------------------------------------------------------
  def ensure_escape
    @sure_escape = true
    make_escape_ratio
    process_escape
  end
end # scene_battle

#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  def force_escape(boss_also = false)
    if $scene.is_a?(Scene_Battle)
      $scene.ensure_escape if boss_also or $game_troop.can_escape
    end
  end
end #game_interpreter
