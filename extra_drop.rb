#===============================================================================
# Ricompense battaglie extra di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script vi permette di aggiungere alle ricompense di fine battaglia
# ulteriore oro, esperienza e drop. Per farlo, basta eseguire un chiama
# script all'interno dell'evento in battaglia ed inserire i seguenti comandi
# ● add_battle_exp(valore)
#   per aggiungere esperienza a fine battaglia (sostituisci valore con un numero
#   rappresentante l'esperienza)
# ● add_battle_gold(valore)
#   per aggiungere oro ai drop di fine battaglia
# ● add_battle_drop(oggetto)
#   per aggiungere un oggetto a fine battaglia (ricordati che come oggetto vuole
#   l'istanza di una determinata classe, ad esempio
#   $data_items[ID] per item, $data_weapons[ID] per armi e $data_armors[ID] per
#   armature). Quindi, se voglio aggiungere una pozione, dovrò scrivere
#   add_battle_drop($data_items[1])
#===============================================================================
$imported = {} if $imported == nil
$imported['H87-ExtraDrop'] = 1.0
#==============================================================================
# ** Game_Troop
#------------------------------------------------------------------------------
#  This class contains the enemy troop. It's contained in the $game_troop inst.
#==============================================================================
class Game_Troop < Game_Unit
  #--------------------------------------------------------------------------
  # * Instance variables
  #--------------------------------------------------------------------------
  attr_accessor :extra_gold   # extra gold at the end of the battle
  attr_accessor :extra_exp    # extra exp at the end of the battle
  #--------------------------------------------------------------------------
  # * Alias methods
  #--------------------------------------------------------------------------
  alias h87_d_setup setup unless $@
  alias h87_d_make_drop_items make_drop_items unless $@
  alias h87_d_gold_total gold_total unless $@
  alias h87_d_exp_total exp_total unless $@
  alias h87_d_initialize initialize unless $@
  #--------------------------------------------------------------------------
  # * Object initialization
  #--------------------------------------------------------------------------
  def initialize
    h87_d_initialize
    setup_extra_drop
  end
  #--------------------------------------------------------------------------
  # * Alias method for troop setup
  #--------------------------------------------------------------------------
  def setup(troop_id)
    h87_d_setup(troop_id)
    setup_extra_drop
  end
  #--------------------------------------------------------------------------
  # * Iniitalize new instance variables
  #--------------------------------------------------------------------------
  def setup_extra_drop
    @extra_drop = []
    @extra_gold = 0
    @extra_exp = 0
  end
  #--------------------------------------------------------------------------
  # * Returns the extra drop array
  #--------------------------------------------------------------------------
  def custom_drops; @extra_drop; end
  #--------------------------------------------------------------------------
  # * Add an item to extra drop array
  #--------------------------------------------------------------------------
  def add_drop(item); @extra_drop.push(item); end
  #--------------------------------------------------------------------------
  # * Make drop items alias method
  #--------------------------------------------------------------------------
  def make_drop_items; h87_d_make_drop_items + custom_drops; end
  #--------------------------------------------------------------------------
  # * Gets the total gold plus extra
  #--------------------------------------------------------------------------
  def gold_total
    [h87_d_gold_total + @extra_gold, 0].max
  end
  #--------------------------------------------------------------------------
  # * Gets the total exp plus extra
  #--------------------------------------------------------------------------
  def exp_total
    [h87_d_exp_total + @extra_exp, 0].max
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Adding new methods for script call thought events
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Adds an item to drop
  #--------------------------------------------------------------------------
  def add_battle_drop(item)
    return unless $game_troop
    $game_troop.add_drop(item)
  end
  #--------------------------------------------------------------------------
  # * Adds exp
  #--------------------------------------------------------------------------
  def add_battle_exp(exp)
    return unless $game_troop
    $game_troop.extra_exp += exp
  end
  #--------------------------------------------------------------------------
  # * Adds gold
  #--------------------------------------------------------------------------
  def add_battle_gold(gold)
    return unless $game_troop
    $game_troop.extra_gold = gold
  end
end