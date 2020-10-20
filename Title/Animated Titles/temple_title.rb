#==============================================================================
# ** TempleTitle
#------------------------------------------------------------------------------
#  Grafica del tempio
#==============================================================================
class TempleTitle < AnimatedTitle
  # Inizializzazione delle componenti grafiche
  def title_initialize
    $animated_background.bitmap = Cache.system("")
    @counter = 0
    @sfondo = Sprite.new
    @sfondo.bitmap = Cache.picture("Sfondo5")
    @sfumatura = Sprite.new
    @sfumatura.bitmap = Cache.picture("Sfumatura")
    @sfumatura.x = -640
    @sfumatura.opacity = 120
    @sfondo2 = Sprite.new
    @sfondo2.bitmap = Cache.picture("Sfondo6")
    @Titolo = Sprite.new
    @Titolo.bitmap = Cache.picture("Titolo4-1")
    @Titolo.opacity = 0
    @Titolo.x = 30
    @Titolo.y = 0
  end
  # Aggiornamento delle componenti
  def graphics_update
    @sfumatura.x +=5
    @sfumatura.x = -640 if @sfumatura.x >= 1280
    @Titolo.y +=1 if @Titolo.y < 30
    @Titolo.opacity += 5 if @Titolo.opacity < 255
    @counter += 1
    case @counter
    when 0
      @Titolo.bitmap = Cache.picture("Titolo4-1")
    when 2
      @Titolo.bitmap = Cache.picture("Titolo4-2")
    when 4
      @Titolo.bitmap = Cache.picture("Titolo4-3")
    when 6
      @Titolo.bitmap = Cache.picture("Titolo4-4")
    when 8
      @Titolo.bitmap = Cache.picture("Titolo4-5")
    when 10
      @Titolo.bitmap = Cache.picture("Titolo4-6")
    when 12
      @Titolo.bitmap = Cache.picture("Titolo4-7")
    when 14
      @Titolo.bitmap = Cache.picture("Titolo4-8")
    when 16
      @Titolo.bitmap = Cache.picture("Titolo4-9")
    when 18
      @Titolo.bitmap = Cache.picture("Titolo4-10")
    when 20
      @Titolo.bitmap = Cache.picture("Titolo4-11")
      @counter = -2
    end
  end
end

Animated_Titles.add_animated_title(TempleTitle)