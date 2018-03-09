require File.expand_path('rm_vx_data')

#===============================================================================
# ** Window_Emoji
#-------------------------------------------------------------------------------
# Finestra di selezione emoji
#===============================================================================
class Window_Emoji < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, Graphics.width, fitting_height(4))
    @column_max = 14
    #@spacing = 3
    get_data
    create_contents
    refresh
    self.index = 0
    deactivate
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Ottieni i dati degli emoji
  #--------------------------------------------------------------------------
  def get_data; @data = Emoji.elements; end
  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di oggetti
  #--------------------------------------------------------------------------
  def item_max
    return 0 unless @data
    @data.size
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'emoji all'elemento selezionato
  # @return [Emoji]
  #--------------------------------------------------------------------------
  def item; @data[self.index]; end
  #--------------------------------------------------------------------------
  # * Disegna l'elemento
  #--------------------------------------------------------------------------
  def draw_item(index)
    return if @data[index].nil?
    rect = item_rect(index)
    draw_emoji(@data[index].icon, rect.x, rect.y)
  end
end