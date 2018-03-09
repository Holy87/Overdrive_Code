#===============================================================================
# ** Plane_Engine
#-------------------------------------------------------------------------------
# Modulo che include i metodi di movimento del Plane
#===============================================================================
module Plane_Engine
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubblici
  #--------------------------------------------------------------------------
  attr_accessor :x_speed  #velocità orizzontale (1/100 di frame)
  attr_accessor :y_speed  #velocità verticale
  #--------------------------------------------------------------------------
  # * Inizializzazione delle variabili
  #--------------------------------------------------------------------------
  def plane_engine_init
    @x_speed = 0
    @y_speed = 0
    @x_state = 0
    @y_state = 0
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def plane_engine_update
    update_x
    update_y
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della coordinata X in movimento
  #--------------------------------------------------------------------------
  def update_x
    @x_state += @x_speed
    @picture.ox += (@x_state/100)
    @x_state = @x_state % 100
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della coordinata Y in movimento
  #--------------------------------------------------------------------------
  def update_y
    @y_state += @y_speed
    @picture.oy += (@y_state/100)
    @y_state = @y_state % 100
  end
end #plane engine