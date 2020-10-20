#==============================================================================
# ** GrassTitle
#------------------------------------------------------------------------------
#  Grafica dell'erba
#==============================================================================
class GrassTitle < AnimatedTitle
  # Inizializzazione delle componenti grafiche
  def title_initialize
    $animated_background.bitmap = Cache.system("")
    @sfondo = Sprite.new
    @sfondo2 = Sprite.new
    @fumo = Sprite.new
    @fiori = Sprite.new
    @Titolo = Sprite.new
    @fiori.opacity = 0
    @Titolo.opacity = 0
    @fumo.opacity = 0
    @sfondo.bitmap = Cache.picture("sfondo3")
    @sfondo2.bitmap = Cache.picture("sfondo3")
    @fumo.bitmap = Cache.picture("undertitle2")
    @fiori.bitmap = Cache.picture("undertitle3")
    @Titolo.bitmap = Cache.picture("titolo3")
    @fiori.x = 70
    @fiori.y = 45
    @fumo.x = 20
    @sfondo2.x = 1828
    @Titolo.x = 30
    @Titolo.y = 30
    @Titolo.z = 1
    @counter = 0
  end
  # Aggiornamento delle componenti
  def graphics_update
    @counter += 1
    @Titolo.opacity += 1 if @sfondo2.x <2000
    @fiori.opacity += 1 if @Titolo.opacity > 250
    @fumo.opacity += 1 if @fiori.opacity > 250
    if @counter > 2
      @sfondo.x -= 1
      @sfondo2.x -= 1
      @counter = 0
    end
    @sfondo.x = 1828 if @sfondo.x <= -1828
    @sfondo2.x = 1828 if (@sfondo2.x <= -1828)
  end
end

Animated_Titles.add_animated_title(GrassTitle)