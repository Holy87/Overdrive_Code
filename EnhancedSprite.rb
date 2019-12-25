#===============================================================================
# ** Sprite
#-------------------------------------------------------------------------------
# Aggiunta dei moduli per installare le nuove funzioni
#===============================================================================
class Sprite
  #--------------------------------------------------------------------------
  # * Inclusione dei moduli
  #--------------------------------------------------------------------------
  include Spark_Engine    # modulo per le particelle
  include Sprite_Engine   # modulo per metodi aggiuntivi Sprite
  include Fade_Engine     # modulo per l'opacità (fade e pulsazione)
  #--------------------------------------------------------------------------
  # * Alias dei metodi principali
  #--------------------------------------------------------------------------
  unless $@
    alias h87EnSprite_initialize initialize
    alias h87EnSprite_update update
    alias h87EnSprite_dispose dispose
  end
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #   viewport: viewport
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    h87EnSprite_initialize(viewport)
    spark_engine_init
    sprite_engine_init
    fade_engine_init
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    h87EnSprite_update rescue return
    fade_engine_update
    spark_engine_update
    sprite_engine_update
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    h87EnSprite_dispose
    delete_sparks
  end
  #--------------------------------------------------------------------------
  # * Coordinata X del lato sinistro
  #--------------------------------------------------------------------------
  def left_x; self.x - self.ox; end
  #--------------------------------------------------------------------------
  # * Coordinata X del lato destro
  #--------------------------------------------------------------------------
  def right_x; self.x - self.ox + self.width; end
  #--------------------------------------------------------------------------
  # * Coordinata Y del lato inferiore
  #--------------------------------------------------------------------------
  def bottom_y; self.y - self.oy + self.height; end
  #--------------------------------------------------------------------------
  # * Coordinata Y del lato superiore
  #--------------------------------------------------------------------------
  def upper_y; self.y - self.oy; end
end #sprite

#===============================================================================
# ** Plane
#-------------------------------------------------------------------------------
# Aggiunta delle funzioni di movimento automatico e fade al Plane
#===============================================================================
class Plane
  include Fade_Engine
  include Plane_Engine
  #--------------------------------------------------------------------------
  # * Alias dei metodi
  #--------------------------------------------------------------------------
  alias h87EnPlane_initialize initialize unless $@
  if method_defined? :update
    alias h87EnPlane_update update unless $@
  else
    def h87EnPlane_update; end
  end

  # Inizializzazione
  # @param [Viewport] viewport
  def initialize(viewport = nil)
    h87EnPlane_initialize(viewport)
    fade_engine_init
    plane_engine_init
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    h87EnPlane_update
    fade_engine_update
    plane_engine_update
  end
end #plane

#===============================================================================
# ** Sprite_Spark
#-------------------------------------------------------------------------------
# Sottoclasse di Sprite, sono le scintille che escono da un altro sprite
#===============================================================================
class Sprite_Spark < Sprite
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_accessor :vector_x #vettore X
  attr_accessor :vector_y #vettore Y
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  # @param [Viewport] viewport
  def initialize(viewport = nil)
    super(viewport)
    self.ox = self.width/2
    self.oy = self.height/2
    self.flash(Color.new(255,255,255),10)
  end
  #--------------------------------------------------------------------------
  # * Restituisce se è una scintilla
  #--------------------------------------------------------------------------
  def is_spark?; true; end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    self.opacity -= 8
    update_direction
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della direzione
  #--------------------------------------------------------------------------
  def update_direction
    return if @dir_x.nil? || @dir_y.nil?
    self.x += @dir_x/4
    self.y += @dir_y/4
  end
  #--------------------------------------------------------------------------
  # * Imposta la direzione
  #   x: vettore X
  #   y: vettore Y
  #--------------------------------------------------------------------------
  def set_direction(x, y)
    @dir_x = x
    @dir_y = y
  end
end #sprite spark

class Sprite_Base < Sprite
  unless $@
    alias h87ensp_initialize initialize
  end

  def initialize(viewport = nil)
    h87ensp_initialize(viewport)

  end
end