#===============================================================================
# ** Window_Avatar
#-------------------------------------------------------------------------------
# La finestra di selezione dell'avatar
#===============================================================================
class Window_AvatarList < Window_Selectable
  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def initialize(x, y, width, lines = 2)
    make_item_list
    super(x, y, width, fitting_height(lines))
    self.index = 0
    refresh
  end

  # numero massimo di colonne
  def col_max
    [(self.width - padding * 2) / 96, 1].max
  end

  # numero massimo di oggetti
  def item_max
    @data ? @data.size : 0
  end

  def spacing
    0
  end

  def line_height
    96
  end

  # Ottiene i dati dei volti avatar
  def make_item_list
    @data = $game_temp.avatars.all_faces;
  end

  # Disegna l'oggetto all'indice
  def draw_item(index)
    return if @data[index].nil?
    rect = item_rect(index)
    draw_avatar(index, rect.x, rect.y)
  end
end