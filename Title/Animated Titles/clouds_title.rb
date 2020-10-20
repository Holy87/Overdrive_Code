#==============================================================================
# ** CloudTitle
#------------------------------------------------------------------------------
#  Grafica del cielo con le nuvole
#==============================================================================
class CloudTitle < AnimatedTitle
  # Inizializzazione delle componenti grafiche
  def title_initialize
    $animated_background.bitmap = Cache.system("Title")
    @Nuv5 = Sprite.new
    @Nuv5.bitmap = Cache.picture ("Cloud6")
    @Nuv6 = Sprite.new
    @Nuv6.bitmap = Cache.picture ("Cloud6")
    @Nuv3 = Sprite.new
    @Nuv3.bitmap = Cache.picture ("Cloud4")
    @Nuv4 = Sprite.new
    @Nuv4.bitmap = Cache.picture ("Cloud4")
    @Nuv1 = Sprite.new
    @Nuv1.bitmap = Cache.picture ("Cloud1")
    @Nuv2 = Sprite.new
    @Nuv2.bitmap = Cache.picture ("Cloud1")
    @Nub = Sprite.new
    @Nub.bitmap = Cache.picture ("BigCloud")
    @Nub.z = 2
    @monitor = Sprite.new
    @monitor.bitmap = Cache.picture("Sfondo TV")
    @monitor.opacity = 0
    @monitor.z = 1
    @Nub.opacity = 250
    @Nub.x = 10000
    @Nub.y = 100
    @Nuv5.x = 0
    @Nuv5.y = 330
    @Nuv6.x = 640
    @Nuv6.y = 325
    @Nuv3.x = 0
    @Nuv3.y = 335
    @Nuv4.x = 640
    @Nuv4.y = 330
    @Nuv1.x = 120
    @Nuv1.y = 400
    @Nuv2.x = 900
    @Nuv2.y = 350
    @Titolo = Sprite.new
    @Titolo.bitmap = Cache.picture("Titolotxt")
    @Trasp = false
    @Titolo.opacity = 0
    @Titolo.x = 73
    @Titolo.y = 10
  end
  # Aggiornamento delle componenti
  def graphics_update
    @Titolo.opacity +=1 unless @Trasp
    @Trasp = true if @Titolo.opacity >= 250
    @Titolo.opacity -= 1 if @Trasp
    @Trasp = false if @Titolo.opacity <= 100
    @Nub.x -= 20
    @Nub.x = 10000 if @Nub.x <= -2000
    @Nuv1.x -= 5
    @Nuv1.x = 480 if @Nuv1.x <= -900
    @Nuv2.x -= 5
    @Nuv2.x = 600 if @Nuv2.x <= -900
    @Nuv3.x -= 2
    @Nuv3.x = 600 if @Nuv3.x <= -800
    @Nuv4.x -= 2
    @Nuv4.x = 600 if @Nuv4.x <= -800
    @Nuv5.x -= 1
    @Nuv5.x = 600 if @Nuv5.x <= -800
    @Nuv6.x -= 1
    @Nuv6.x = 600 if @Nuv6.x <= -800
  end
end

Animated_Titles.add_animated_title(CloudTitle)