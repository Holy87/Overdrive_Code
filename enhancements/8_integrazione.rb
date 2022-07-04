#===============================================================================
# ** Sprite
#-------------------------------------------------------------------------------
# Aggiunta dei moduli per installare le nuove funzioni
#===============================================================================
class Sprite
  # Inclusione dei moduli
  include Spark_Engine # modulo per le particelle
  include Sprite_Engine # modulo per metodi aggiuntivi Sprite
  include Fade_Engine # modulo per l'opacità (fade e pulsazione)
  # Alias dei metodi principali
  unless $@
    alias h87EnSprite_initialize initialize
    alias h87EnSprite_update update
    alias h87EnSprite_dispose dispose
  end
  # Inizializzazione
  #   viewport: viewport
  def initialize(viewport = nil)
    h87EnSprite_initialize(viewport)
    spark_engine_init
    sprite_engine_init
    fade_engine_init
  end

  # Aggiornamento
  def update
    h87EnSprite_update rescue return
    fade_engine_update
    spark_engine_update
    sprite_engine_update
  end

  # Dispose
  def dispose
    kill_pending_threads
    h87EnSprite_dispose
    delete_sparks
  end

  # Loads the bitmap in another thread, so
  # @param [Proc] block
  def set_bitmap_async(*args, &block)
    kill_pending_threads
    @bitmap_thread = Thread.new(args, block) do |args, block|
      begin
        self.bitmap = block.call(args)
      rescue
        puts sprintf("An error is occurred in %s instance while loading bitmap.\n%s->%s", self, $!, $!.message)
      end

    end
  end

  def kill_pending_threads
    return if @bitmap_thread.nil?
    Thread.kill(@bitmap_thread) rescue nil
  end

  # Coordinata X del lato sinistro
  def left_x
    self.x - self.ox;
  end

  # Coordinata X del lato destro
  def right_x
    self.x - self.ox + self.width;
  end

  # Coordinata Y del lato inferiore
  def bottom_y
    self.y - self.oy + self.height;
  end

  # Coordinata Y del lato superiore
  def upper_y
    self.y - self.oy;
  end
end

#sprite

#===============================================================================
# ** Plane
#-------------------------------------------------------------------------------
# Aggiunta delle funzioni di movimento automatico e fade al Plane
#===============================================================================
class Plane
  include Fade_Engine
  include Plane_Engine
  # Alias dei metodi
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

  # Aggiornamento
  def update
    h87EnPlane_update
    fade_engine_update
    plane_engine_update
  end
end

#plane

#===============================================================================
# ** Sprite_Spark
#-------------------------------------------------------------------------------
# Sottoclasse di Sprite, sono le scintille che escono da un altro sprite
#===============================================================================
class Sprite_Spark < Sprite
  # Variabili d'istanza pubbliche
  attr_accessor :vector_x #vettore X
  attr_accessor :vector_y #vettore Y
  # Inizializzazione
  # @param [Viewport] viewport
  def initialize(viewport = nil)
    super(viewport)
    self.ox = self.width / 2
    self.oy = self.height / 2
    self.flash(Color.new(255, 255, 255), 10)
  end

  # Restituisce se è una scintilla
  def is_spark?
    true;
  end

  # Aggiornamento
  def update
    super
    self.opacity -= 8
    update_direction
  end

  # Aggiornamento della direzione
  def update_direction
    return if @dir_x.nil? || @dir_y.nil?
    self.x += @dir_x / 4
    self.y += @dir_y / 4
  end

  # Imposta la direzione
  #   x: vettore X
  #   y: vettore Y
  def set_direction(x, y)
    @dir_x = x
    @dir_y = y
  end
end

#sprite spark

#===============================================================================
# ** Sprite_Base
#===============================================================================
class Sprite_Base < Sprite
  unless $@
    alias h87ensp_initialize initialize
  end

  def initialize(viewport = nil)
    h87ensp_initialize(viewport)
  end
end

#===============================================================================
# ** Sprite_Container
# Questo è un contenitore di Sprite. Si gestisce come gli sprite, a differenza
# che puoi gestire più livelli.
#===============================================================================
class Sprite_Container
  # @return [Fixnum]
  attr_reader :x
  # @return [Fixnum]
  attr_reader :y
  # @return [Viewport]
  attr_reader :viewport

  # @param [Viewport] viewport
  def initialize(viewport)
    @sprites = []
    @x = 0
    @y = 0
    self.viewport = viewport
  end

  # @return [Array<Sprite>]
  def sprites
    @sprites
  end

  # @param [Sprite] sprite
  def add_sprite(sprite)
    sprite.viewport = @viewport
    sprite.x = @x
    sprite.y = @y
    sprite.opacity = self.opacity
    sprite.visible = self.visible
    @sprites.push(sprite)
    self.z = self.z # per reimpostare le z
  end

  # @param [Bitmap] bitmap
  def add_bitmap(bitmap)
    sprite = Sprite.new(@viewport)
    sprite.bitmap = bitmap
    add_sprite(sprite)
  end

  # @param [Viewport] new_viewport
  def viewport=(new_viewport)
    @viewport = new_viewport
    sprites.each { |sprite| sprite.viewport = new_viewport}
  end

  def x=(value)
    sprites.each { |sprite| sprite.x = value }
    @x = value
  end

  def y=(value)
    sprites.each { |sprite| sprite.y = value }
    @x = value
  end

  def z=(value)
    sprites.each_with_index{|sprite, i| sprite.z = value + i}
    @z = value
  end

  def z
    return 0 if sprites.empty?
    sprites.first.z
  end

  def width
    return 0 if sprites.empty?
    sprites.max{|a, b| a.width <=> b.width}.width
  end

  def height
    return 0 if sprites.empty?
    sprites.max{|a, b| a.height <=> b.height}.height
  end

  def opacity
    return 255 if sprites.empty?
    sprites.first.opacity
  end

  def opacity=(value)
    sprites.each { |sprite| sprite.opacity = value }
  end

  def visible
    return true if sprites.empty?
    sprites.first.visible
  end

  alias visible? visible

  def visible=(value)
    sprites.each { |sprite| sprite.visible = value }
  end

  def update
    sprites.each { |sprite| sprite.update }
  end

  def dispose
    sprites.each { |sprite| sprite.dispose }
  end

  def disposed?
    sprites.select { |sprite| sprite.disposed? }.any?
  end
end

class Window_Base < Window
  include Fade_Engine

  alias :h87_en_window_init :initialize
  alias :h87_en_window_upd :update

  def initialize(x, y, width, height)
    h87_en_window_init(x, y, width, height)
    fade_engine_init
  end

  def update
    h87_en_window_upd
    update_fading
  end

  def smooth_left
    save_position
    smooth_move(0 - self.width, self.y)
  end

  def smooth_right
    save_position
    smooth_move(Graphics.width, self.y)
  end

  def smooth_down
    save_position
    smooth_move(self.x, Graphics.height)
  end

  def smooth_up
    save_position
    smooth_move(self.x, 0 - self.height)
  end

  def smooth_reset_position
    return unless @old_position
    smooth_move(@old_position[:x], @old_position[:y])
    @old_position = nil
  end

  def save_position
    @old_position = {:x => self.x, :y => self.y}
  end
end