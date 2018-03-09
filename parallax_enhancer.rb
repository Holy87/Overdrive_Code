require File.expand_path('rm_vx_data')

module ParallaxEnhancer
  MAPS = {
      419 => [:fog]
  }

  PARALLAXES = {
      :fog => {:image => '', :z => 10, :blend_type => 0, :x => 1, :y => 0}
  }

  def self.map_parallaxes(map_id)
    map = MAPS[map_id]
    par = []
    return par if map.nil?
    map.each{|parallax|
      par.push(Custom_Parallax.new(parallax))
    }
  end
  par
end

class Custom_Parallax
  attr_reader :image_name
  attr_reader :blend_type
  attr_reader :opacity
  attr_reader :x
  attr_reader :y
  attr_reader :z

  def initialize(set)
    @image_name = set[:image]
    @blend_type = set[:blend_type] ? set[:blend_type] : 0
    @opacity = set[:opacity] ? set[:opacity] : 255
    @z = set[:z] ? set[:z] : 1
    @x = set[:x] ? set[:x] : 0
    @y = set[:y] ? set[:y] : 0
  end

  def bitmap; Cache.parallax(@image_name); end
end

class Game_Map
  attr_reader :custom_parallaxes

  alias h87_parallaxes setup_parallax unless $@
  def setup_parallax
    h87_parallaxes
    setup_custom_parallaxes
  end

  def setup_custom_parallaxes
    @custom_parallaxes = ParallaxEnhancer.map_parallaxes(@map_id)
  end
end

class Spriteset_Map
  alias h87_create_parallax create_parallax
  def create_parallax
    h87_create_parallax
    @parallaxes = []
  end
end