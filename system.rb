#===============================================================================
# ** Game_System
#-------------------------------------------------------------------------------
# passaggio di alcuni dettagli di impostazione in Game_System
#===============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # ottiene il tempo di gioco come oggetto
  # @return [Playtime]
  #--------------------------------------------------------------------------
  def playtime_time; Playtime.new(self.playtime); end
  #--------------------------------------------------------------------------
  # ottiene l'andamento della storia attuale
  #--------------------------------------------------------------------------
  def story_progress; $game_variables[72]; end
  #--------------------------------------------------------------------------
  # determina il valore raggiunto del progresso alla fine della storia
  #--------------------------------------------------------------------------
  def max_story; CPanel::MAX_STORY; end
  #--------------------------------------------------------------------------
  # ottiene le quest completate
  #--------------------------------------------------------------------------
  def completed_quests; $game_variables[17]; end
  #--------------------------------------------------------------------------
  # ottiene il variatore di ottenimento dell'esperienza nei combattimenti
  #--------------------------------------------------------------------------
  def exp_rate; CPanel::EXPRATE; end
  #--------------------------------------------------------------------------
  # ottiene il variatore di ottenimento di oro nei combattimenti
  #--------------------------------------------------------------------------
  def gold_rate; CPanel::GOLDRATE; end
  #--------------------------------------------------------------------------
  # ottiene il variatore di PA ottenuti nei combattimenti
  #--------------------------------------------------------------------------
  def ap_rate; CPanel::APDRATE; end
  #--------------------------------------------------------------------------
  # ottiene la versione del salvataggio
  #--------------------------------------------------------------------------
  def save_version; CPanel::SAVE_VERSION; end
  #--------------------------------------------------------------------------
  # non ricordo.
  #--------------------------------------------------------------------------
  def mp_divisor; CPanel::MPDIVISOR; end
end

#===============================================================================
# ** Playtime
#-------------------------------------------------------------------------------
# una semplice classe che memorizza le ore di gioco.
#===============================================================================
class Playtime
  attr_reader :hour # ore di gioco
  attr_reader :min  # minuti di gioco
  attr_reader :sec  # secondi di gioco
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  # @param [Integer] seconds i secondi totali
  def initialize(seconds)
    @hour = seconds / 60 / 60
    @min = seconds / 60 % 60
    @sec = seconds % 60
  end
  #--------------------------------------------------------------------------
  # * versione stampabile
  # @return [String]
  #--------------------------------------------------------------------------
  def to_s; sprintf('%02d:%02d:%02d', hour, min, sec); end
end