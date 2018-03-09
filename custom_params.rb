=begin
HIT ed EVA custom
v1.0
Serve per cambiare i valori iniziali di mira ed evasione.
=end

#==============================================================================
# ** Impostazioni
#==============================================================================
module H87_HitConfig
  # Parametri di mira iniziali
  Hits = {
  2 => -10,#Monica
  3 => 2, #Antonio
  5 => 1,#Maria
  6 => -15,#Cira
  8 => -1,#Claudio
  9 => 1,#Michele
  13=> -15,#Larsa
  14=> -2,#Dante
  }

  # Parametri di evasione iniziali
  Evas = {
  1 => -1,#fra
  3 => -1,#anto
  8 => 1,#clau
  }
end

#==============================================================================
# ** H87_CustomHit
#==============================================================================
module H87_CustomHit
  #-----------------------------------------------------------------------------
  # * restituisce il modificatore di mira
  #-----------------------------------------------------------------------------
  def self.hit_modifier(actor_id)
    hits(actor_id) ? hits(actor_id) : 0
  end
  #-----------------------------------------------------------------------------
  # * restituisce il modificatore di evasione
  #-----------------------------------------------------------------------------
  def self.eva_modifier(actor_id)
    eva(actor_id) ? eva(actor_id) : 0
  end
  #-----------------------------------------------------------------------------
  # * restituisce la mira configurata
  #-----------------------------------------------------------------------------
  def self.hits(actor_id); H87_HitConfig::Hits[actor_id]; end
  #-----------------------------------------------------------------------------
  # * restituisce l'evasione configurata
  #-----------------------------------------------------------------------------
  def self.eva(actor_id); H87_HitConfig::Evas[actor_id]; end
end

#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  alias h87_hit_mod hit unless $@
  alias h87_eva_mod eva unless $@
  #-----------------------------------------------------------------------------
  # * alias della mira
  #-----------------------------------------------------------------------------
  def hit
    h87_hit_mod + H87_CustomHit.hit_modifier(self.id)
  end
  #-----------------------------------------------------------------------------
  # * alias dell'evasione
  #-----------------------------------------------------------------------------
  def eva
    h87_eva_mod + H87_CustomHit.eva_modifier(self.id)
  end
end
