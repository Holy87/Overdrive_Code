class BubbleTitle < AnimatedTitle
  def title_initialize
    @sfondo = Sprite.new(@viewport)
    @sfondo.bitmap = Cache.title("SfondoNew")
    #@sfondo.bitmap.hue_change(215)
    @bolla = Cache.title("Bolla")
    @uppersf = Sprite.new(@viewport)
    @uppersf.bitmap = Cache.title("UpperNew")
    #@uppersf.bitmap.hue_change(215)
    @sfondo.z = 0
    @sfondo.opacity = 0
    @uppersf.opacity = 0
    @uppersf.z = 99
    @bubbles = []
    for i in 0..30
      add_new_bubbles(rand(Graphics.height))
    end
  end

  def graphics_update
    update_bubbles
    add_new_bubbles if rand(30) == 0
  end

  def update_bubbles
    @bubbles.each { |bubble|
      update_bubble(bubble)
    }
  end

  def add_new_bubbles(y = Graphics.height)
    return if @bubbles.size > 60
    bubble = Sprite_Bubble.new(@viewport, rand(200)+20)
    bubble.y = y
    bubble.x = rand(Graphics.width)
    bubble.bitmap = @bolla
    @bubbles.push(bubble)
    @uppersf.z = bubble.z + 1 if @uppersf.z < bubble.z
  end

  def dispose
    dispose_bubbles
    super
  end

  def update_bubble(bubble)
    return if bubble.nil?
    bubble.update
    if bubble.out_of_bound?
      bubble.dispose
      @bubbles.delete(bubble)
    end
  end

  def dispose_bubbles
    @bubbles.each { |bubble|
      bubble.dispose
    }
  end
end

class Sprite_Bubble < Sprite
  def initialize(viewport, magnitudine = 100)
    super(viewport)
    set_magnitudine(magnitudine)
    @speed = rand(50)+1
    @start_lateral_speed = rand(@speed)
    @lateral_speed = @start_lateral_speed
    @starting_x = self.x
    @lateral_wideness = rand(100)
    @direction = rand(1)
    @increment = false
    @sx = @sy = 0
    self.wave_amp = 5
    #self.opacity = 255 - rand(100)
  end

  def set_magnitudine(magnitudine)
    self.zoom_x = magnitudine.to_f / 100.0
    self.zoom_y = magnitudine.to_f / 100.0
  end

  def update
    super
    update_movements
  end

  def update_movements
    ascensional_speed = @speed - @lateral_speed.abs/2
    new_y = calc_speed_y(ascensional_speed)
    if self.y - new_y >= 0
      self.y -= new_y
    else
      self.opacity -= 1
    end
    if @direction > 0
      self.x -= calc_speed_x
    else
      self.x += calc_speed_x
    end
    #self.x += calc_speed(@lateral_speed, @x_speed)
    update_lateral_speed
  end

  def update_lateral_speed
    adder = rand(2)-1
    return if (@lateral_speed + adder).abs > @speed
    @lateral_speed += adder
  end

  def switch_direction
    @direction == 0 ? @direction = 1 : @direction = 0
  end

  def calc_speed_y(speed)
    return 1 if speed >= 60
    @sy += speed
    if @sy >= 60
      @sy -= 60
      return 1
    else
      return 0
    end
  end

  def calc_speed_x
    return 1 if @lateral_speed >= 60
    @sx += @lateral_speed
    if @sx >= 60
      @sx -= 60
      return 1
    else
      return 0
    end
  end

  def out_of_bound?
    return true if self.opacity == 0
    #return true if self.zoom_x <= 0
    #return true if self.y < 0 - self.width
    return false
  end
end

Animated_Titles.add_animated_title(BubbleTitle)