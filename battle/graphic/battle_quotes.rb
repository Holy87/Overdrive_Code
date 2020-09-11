#questo piccolo script mi serve sostanzialmente a fare in modo che i personaggi
#parlino in battaglia senza usare troppi comandi e troppe switch.

#==============================================================================
# ** modulo Battle
#==============================================================================
module Battle
  #-----------------------------------------------------------------------------
  # Restituisce true se il giocatore è in party e non ha mai parlato e inserisce
  # automaticamente il quote nella lista delle citazioni che già sono state fatte.
  # In questo modo con un semplice if si risparmiano switch e si risparmia di
  # mettere altri comandi.
  # @param [Fixnum] id_gioc
  # @param [String] quote
  #-----------------------------------------------------------------------------
  def self.quote(id_gioc,quote = "")
    quote_id = get_quote_id(id_gioc, quote)
    return false unless $game_temp.in_battle
    return false unless $game_party.members.include?($game_actors[id_gioc])
    return false if $game_party.battlequotes.include?(quote_id)
    $game_party.push_quote(quote_id)
    return true
  end
  #--------------------------------------------------------------------------
  # * crea l'ID della citazione
  # @param [Fixnum] id_gioc
  # @param [String] quote
  # @return [String]
  #--------------------------------------------------------------------------
  def self.get_quote_id(id_gioc, quote)
    if quote == ""
      quoteid = sprintf('%d-%d', id_gioc, $game_troop.troop_id)
    else
      quoteid = sprintf('%d-%s', id_gioc, quote)
    end
    quoteid
  end
end

#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * restituisce le citaioni di battaglia
  # @return [Array]
  #--------------------------------------------------------------------------
  def battlequotes
    @battlequotes = [] if @battlequotes == nil
    @battlequotes
  end
  #--------------------------------------------------------------------------
  # * aggiunge una citazione
  #--------------------------------------------------------------------------
  def push_quote(quote)
    @battlequotes = [] if @battlequotes == nil
    @battlequotes.push(quote)
  end

  def sinergy_full?
    # code here
  end
end

#==============================================================================
# ** Game_Troop
#==============================================================================
class Game_Troop < Game_Unit
  attr_reader :troop_id
end
