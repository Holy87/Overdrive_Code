#==============================================================================
# ** FairyTitle
#------------------------------------------------------------------------------
#  Grafica del bosco con le luci
#==============================================================================
class FairyTitle < AnimatedTitle
  # Inizializzazione delle componenti grafiche
  def title_initialize
    @variabile1 = false
    @variabile2 = false
    @variabile3 = false
    $animated_background.bitmap = Cache.system("")
    @sfondo = Sprite.new
    @sfondo.bitmap = Cache.picture("sfondo2")
    @luce1 = Sprite.new
    @luce2 = Sprite.new
    @luce1b = Sprite.new
    @luce2b = Sprite.new
    @Titolo = Sprite.new
    @luce3 = Sprite.new
    @luce3b = Sprite.new
    @Titolo.opacity = 0
    @Titolo.bitmap = Cache.picture("title2")
    @luce1.bitmap = Cache.picture("ministar1")
    @luce2.bitmap = Cache.picture("ministar2")
    @luce3.bitmap = Cache.picture("ministar3")
    @luce1b.bitmap = Cache.picture("ministar1")
    @luce2b.bitmap = Cache.picture("ministar2")
    @luce3b.bitmap = Cache.picture("ministar3")
    @luce1.x = 640
    @luce2.x = -640
    @luce3.x = -640
    @luce1b.x = 1280
    @luce2b.x = -1280
    @luce3b.x = -1280
    @counter = 0
  end
  # Aggiornamento delle componenti
  def graphics_update
    @Titolo.opacity += 1
    @counter += 1
    if @counter > 0
      @luce1.x -= 1
      @luce1b.x -= 1
      @counter = 0
    end
    @luce2.x += 1
    @luce3.x += 2
    @luce2b.x += 1
    @luce3b.x += 2
    if @variabile3 == false
      @luce3.opacity -= 2
      @luce3b.opacity += 2
    else
      @luce3.opacity += 2
      @luce3b.opacity -= 2
    end
    if @variabile1 == false
      @luce1.opacity -= 2
      @luce1b.opacity -= 2
    else
      @luce1.opacity += 2
      @luce1b.opacity += 2
    end
    if @variabile2 == false
      @luce2.opacity -= 1
      @luce2b.opacity -= 1
    else
      @luce2.opacity += 1
      @luce2b.opacity += 1
    end
    @variabile1 = true if @luce1.opacity <= 75
    @variabile2 = true if @luce2.opacity <= 125
    @variabile1 = false if @luce1.opacity >=250
    @variabile2 = false if @luce2.opacity >= 200
    @variabile3 = true if @luce3.opacity < 100
    @variabile3 = false if @luce3.opacity > 250
    @luce1.x = 640 if (@luce1.x <= -640)
    @luce2.x = -640 if (@luce2.x >= 640)
    @luce3.x = -640 if (@luce3.x >= 640)
    @luce1b.x = 640 if (@luce1b.x <= -640)
    @luce2b.x = -640 if (@luce2b.x >= -640)
    @luce3b.x = -640 if (@luce3b.x >= 640)
  end
end

Animated_Titles.add_animated_title(FairyTitle)