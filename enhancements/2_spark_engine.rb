#===============================================================================
# ** Spark_Engine
#-------------------------------------------------------------------------------
# Motore che gestisce le scintille degli Sprite
#===============================================================================
$imported = {} if $imported == nil
$imported["H87-Spark_Engine"] = 1.0
module Spark_Engine
  DEFAULT_SPARK_IMAGE = 'Spark'
  RANDOM = 0
  UP = 8
  DOWN = 2
  RIGHT = 6
  LEFT = 4
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_accessor :spark_active     # se le scintille sono attive
  attr_accessor :spark_density    # densità di creazione delle scintille
  attr_accessor :spark_bitmap     # bitmap delle scintille
  attr_accessor :spark_spawn_ray  # raggio di comparsa delle scintille
  attr_accessor :spark_direction
  #--------------------------------------------------------------------------
  # * Inizializzazione delle variabili
  #--------------------------------------------------------------------------
  def spark_engine_init
    @sparks = []
    @spark_bitmap = Cache.picture(DEFAULT_SPARK_IMAGE)
    @spark_active = false
    @spark_density = 10
    @spark_spawn_ray = 10
    @spark_direction = RANDOM
    @is_spark = false
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def spark_engine_update
    update_sparks
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento delle scintille
  #--------------------------------------------------------------------------
  def update_sparks
    return if @is_spark
    @sparks.each do |spark|
      spark.update
      if spark.opacity == 0
        spark.dispose
        @sparks.delete(spark)
      end
    end
    add_sparks(@spark_density) if @spark_active
  end
  #--------------------------------------------------------------------------
  # * Aggiunge delle scintille
  #   density: densità di creazione
  #--------------------------------------------------------------------------
  def add_sparks(density)
    density.times do
      add_new_spark if rand(10) == 0
    end
  end
  #--------------------------------------------------------------------------
  # * Cancellazione di tutte le scintille
  #--------------------------------------------------------------------------
  def delete_sparks
    @sparks.each do |spark|
      spark.opacity = 0
      spark.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce se è una scintilla
  #--------------------------------------------------------------------------
  def is_spark?; false; end
  #--------------------------------------------------------------------------
  # * Aggiunge una nuova scintilla
  #--------------------------------------------------------------------------
  def add_new_spark
    spark = Sprite_Spark.new(self.viewport)
    spark.bitmap = @spark_bitmap
    spark_x = rand(@spark_spawn_ray*2) - @spark_spawn_ray
    spark_y = rand(@spark_spawn_ray*2) - @spark_spawn_ray
    spark.x = spark_x + sprite_center_x
    spark.y = spark_y + sprite_center_y
    case @spark_direction
    when RANDOM
      spark.set_direction(spark.x - sprite_center_x, spark.y - sprite_center_y)
    when UP
      spark.set_direction(0, (rand(2)+1) * -1)
    when DOWN
      spark.set_direction(0, (rand(2)+1))
    when LEFT
      spark.set_direction((rand(2)+1) * -1, 0)
    when RIGHT
      spark.set_direction((rand(2)+1), 0)
    else
      spark.set_direction(0, 0)
    end

    spark.opacity = self.opacity
    @sparks.push(spark)
  end
  #--------------------------------------------------------------------------
  # * Ferma tutte le scintille
  #--------------------------------------------------------------------------
  def stop_sparks
    delete_sparks
    @sparks = []
    @spark_active = false
  end
end #spark engine

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