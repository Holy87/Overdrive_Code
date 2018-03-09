#===============================================================================
# ** Spark_Engine
#-------------------------------------------------------------------------------
# Motore che gestisce le scintille degli Sprite
#===============================================================================
module Spark_Engine
  DEFAULT_SPARK_IMAGE = 'Spark'
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_accessor :spark_active     # se le scintille sono attive
  attr_accessor :spark_density    # densità di creazione delle scintille
  attr_accessor :spark_bitmap     # bitmap delle scintille
  attr_accessor :spark_spawn_ray  # raggio di comparsa delle scintille
  #--------------------------------------------------------------------------
  # * Inizializzazione delle variabili
  #--------------------------------------------------------------------------
  def spark_engine_init
    @sparks = []
    @spark_bitmap = Cache.picture(DEFAULT_SPARK_IMAGE)
    @spark_active = false
    @spark_density = 10
    @spark_spawn_ray = 10
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
    spark.set_direction(spark.x - sprite_center_x, spark.y - sprite_center_y)
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