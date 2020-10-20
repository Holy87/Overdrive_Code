#==============================================================================
# ** MoonTitle
#------------------------------------------------------------------------------
#  Grafica del titolo rosso con nuvole e luna
#==============================================================================
class MoonTitle < AnimatedTitle
  # Inizializzazione delle componenti grafiche
  def title_initialize
    @provolone = 0
    @contatore = 0
    @cielo = Sprite.new
    @cielo.bitmap = Cache.picture("RT-Cielo")
    @luna = Sprite.new
    @luna.bitmap = Cache.picture("RT-Luna")
    @nuvola0a = Sprite.new
    @nuvola0a.bitmap = Cache.picture("RT-Nuvola0")
    @nuvola0b = Sprite.new
    @nuvola0b.bitmap = Cache.picture("RT-Nuvola0")
    @nuvola2a = Sprite.new
    @nuvola2a.bitmap = Cache.picture("RT-Nuvola2")
    @nuvola2b = Sprite.new
    @nuvola2b.bitmap = Cache.picture("RT-Nuvola2")
    @nuvola1a = Sprite.new
    @nuvola1a.bitmap = Cache.picture("RT-Nuvola1")
    @nuvola1b = Sprite.new
    @nuvola1b.bitmap = Cache.picture("RT-Nuvola1")
    @montagna1 = Sprite.new
    @montagna1.bitmap = Cache.picture("RT-Montagne")
    @nube = Sprite.new
    @nube.bitmap = Cache.picture("RT-Nube")
    @nube2 = Sprite.new
    @nube2.bitmap = Cache.picture("RT-Nube")
    @montagna2 = Sprite.new
    @montagna2.bitmap = Cache.picture("RT-Montagna2")
    @Titolo = Sprite.new
    @Titolo.bitmap = Cache.picture("RT-Titolo")
    @nube.y = Graphics.height - @nube.height
    @nube2.y = Graphics.height - @nube2.height
    @nube2.x = Graphics.width
    @Titolo.x = Graphics.width / 2 - @Titolo.width / 2
    @Titolo.y = 50
    @nuvola1b.x = @nuvola1a.width
    @nuvola2b.x = @nuvola2a.width / 2
    @nuvola0b.x = @nuvola0a.width / 2
    @montagna1.y = Graphics.height - @montagna1.height
    @montagna2.y = Graphics.height - @montagna2.height
    @Titolo.z = 20
    @montagna2.z = 12
    @nube.z = 11
    @nube2.z = 10
    @montagna1.z = 9
    @nuvola1a.z = 8
    @nuvola1b.z = 7
    @nuvola1a.z = 6
    @nuvola1b.z = 5
    @nuvola2a.z = 4
    @nuvola2b.z = 3
    @luna.z = 2
    @cielo.z = 1
    @contatore = 5000 if @hide_title
    @nube.wave_amp = 5
    @nube.wave_length = 200
    @nube2.wave_amp = 5
    @nube2.wave_length = 200
    @components = [@cielo, @luna, @nuvola0a, @nuvola0b, @nuvola2a, @nuvola2b,
                   @nuvola1a, @nuvola1b, @montagna1, @nube, @nube2, @montagna2, @Titolo]
  end

  # Aggiornamento delle componenti
  def graphics_update
    @nube.update
    @nube2.update
    @nube.x -= 1
    @nube.x = Graphics.width if @nube.x < 0 - @nube.width
    @nube2.x -= 1
    @nube2.x = Graphics.width if @nube2.x < 0 - @nube2.width
    @provolone += 1
    @nuvola1a.x -= 1 if @provolone % 2 == 1
    @nuvola2a.x -= 1 if @provolone % 4 == 1
    @nuvola1b.x -= 1 if @provolone % 2 == 1
    @nuvola2b.x -= 1 if @provolone % 4 == 1
    @nuvola0b.x -= 1
    @nuvola0a.x -= 1
    @nuvola1a.x = Graphics.width if @nuvola1a.x <= 0 - @nuvola1a.width
    @nuvola1b.x = Graphics.width if @nuvola1b.x <= 0 - @nuvola1b.width
    @nuvola2a.x = @nuvola2a.width / 2 if @nuvola2a.x < 0 - @nuvola2a.width
    @nuvola2b.x = @nuvola2b.width / 2 if @nuvola2b.x < 0 - @nuvola2a.width
    @nuvola0b.x = @nuvola0b.width / 2 if @nuvola0b.x < 0 - @nuvola0a.width
    @nuvola0a.x = @nuvola0a.width / 2 if @nuvola0a.x < 0 - @nuvola0a.width
  end

  # Aggiornamento della scomparsa - ricomparsa del titolo
  def update_title_hiding
    if @darken
      @Titolo.y -= 10 if @Titolo.y > @Titolo.width * -1
    else
      @Titolo.y += 10 if @Titolo.y < 50
    end
  end

  # Aggiornamento
  def update
    super
    update_title_hiding
  end
end

Animated_Titles.add_animated_title(MoonTitle)