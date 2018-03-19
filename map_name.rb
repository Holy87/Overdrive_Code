require File.expand_path('rm_vx_data') if false

#===============================================================================
# ** Impostazioni script
#===============================================================================
module Settings
  LOCATION_WINDOW_ICON = 1156   # icona locazione
  PLAYTIME_WINDOW_ICON = 1157   # icona tempo di gioco
end

#===============================================================================
# ** Game_Map
#===============================================================================
class Game_Map
  attr_reader :map_id
  #--------------------------------------------------------------------------
  # * Restituisce il nome della mappa
  # @return [String]
  #--------------------------------------------------------------------------
  def map_name; $game_temp.map_names[@map_id]; end
end

#===============================================================================
# ** Game_Temp
#===============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # * Restituisce un hash con ID_MAPPA => Nome
  # @return [Hash<String>]
  #--------------------------------------------------------------------------
  def map_names
    @map_names ||= load_map_names
  end
  #--------------------------------------------------------------------------
  # * Carica i nomi della mappa (solo la prima volta)
  #--------------------------------------------------------------------------
  def load_map_names
    data = load_data('Data/MapInfos.rvdata')
    names = {}
    data.each_pair{|key, value| names[key] = value.name}
    names
  end
end

#===============================================================================
# ** Window_Location
#===============================================================================
class Window_Location < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height = fitting_height(1))
    super
    refresh
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'indice icona della posizione
  # @return [Integer]
  #--------------------------------------------------------------------------
  def icon; Settings::LOCATION_WINDOW_ICON; end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_icon(icon, 0, 0)
    change_color(normal_color)
    draw_text_ex(24, 0, $game_map.map_name)
  end
end

#===============================================================================
# ** Window_PlayTime
#===============================================================================
class Window_PlayTime < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height = fitting_height(1))
    super
    refresh
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'indice icona della posizione
  # @return [Integer]
  #--------------------------------------------------------------------------
  def icon; Settings::PLAYTIME_WINDOW_ICON; end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    draw_icon(icon, 0, 0)
    change_color(normal_color)
    half_refresh
  end
  #--------------------------------------------------------------------------
  # * Evita di disegnare tutto, solo il testo
  #--------------------------------------------------------------------------
  def half_refresh
    contents.clear_rect(24, 0, contents_width - 24, line_height)
    draw_text(24, 0, contents_width - 24, line_height, $game_system.playtime_s, 2)
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    half_refresh if Graphics.frame_count % Graphics.frame_rate == 0
  end
end

#===============================================================================
# ** Scene_Menu
#===============================================================================
class Scene_Menu < Scene_Base
  alias pt_loc_start start unless $@
  alias pt_loc_update update unless $@
  alias pt_loc_terminate terminate unless $@
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    pt_loc_start
    create_location_window
    create_playtime_window
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra di posizione
  #--------------------------------------------------------------------------
  def create_location_window
    x = @status_window.x
    width = @status_window.width
    @location_window = Window_Location.new(x, 0, width)
    @location_window.y = Graphics.height - @location_window.height
    @status_window.height = Graphics.height - @location_window.height
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra del tempo di gioco
  #--------------------------------------------------------------------------
  def create_playtime_window
    width = @command_window.width
    y = @location_window.y
    @playtime_window = Window_PlayTime.new(0, y, width)
    @gold_window.y = @playtime_window.y - @gold_window.height
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    pt_loc_update
    @playtime_window.update
  end
  #--------------------------------------------------------------------------
  # * Uscita
  #--------------------------------------------------------------------------
  def terminate
    pt_loc_terminate
    @playtime_window.dispose
    @location_window.dispose
  end
end