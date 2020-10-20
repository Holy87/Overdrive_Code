# MINIMAPPA
# V 1.0
# Permette di visualizzare una minimappa.
# La minimappa compare se posseduti determinati oggetti.

module MapPopup_Options
  MAP_X = 10
  MAP_Y = 10
  MAP_W = 80
  MAP_H = 60

  BG_COLOR = Color::BLACK.deopacize
  FR_COLOR = Color::BLACK
  PT_COLOR = Color::RED

  MAP_COLORS = {
      :passable => Color::WHITE.deopacize,
      :save => Color::LIGHTGREEN,
      :teleport => Color::CYAN
  }

  MINIMAP_ITEMS = {
      # ITEM_ID => MAP_IDS
      251 => [8, (37..45).to_a],
      252 => [(189..193).to_a, 5],
      253 => [185,186,187,194,195],
      254 => [214,215,216,235,239],
      255 => [230],
      256 => [240, 241, 242, 329],
      257 => [(271..276).to_a],
      258 => [(310..317).to_a,426,427],
      259 => [158, 163],
      260 => [(73..79).to_a], # selva di salici
      261 => [(115..124).to_a, 126, 127, 133], # monti ciclamini
      262 => [369, (372..380).to_a, 413], # diamantica
      263 => [(333..336).to_a, (353..355).to_a] # 
  }

  # non più usato
  DISABLED = [1,142,266,179,184,223,224,228,4,114,261,262,263,268,269,270,327,
              292,295,296,298,346,162,183,205,215,216,235,238,239,382,404,407,211,357,364,
              84,243]

  # OPZIONI MINIMAPPA
  MINIMAP_SWITCH = 616
  MINIMAP_SIZE_SW = 617
  OPTION_STR = 'Mostra Minimappa'
  OPTION_HLP = 'Mostra o nascondi la minimappa quando è disponibile.'
  OPTION_ON = 'Mostra'
  OPTION_OFF = 'Nascondi'
  OPTION_SIZE = 'Dimensioni minimappa'
  OPTION_SZ_HLP = 'Scegli le dimensioni della minimappa dei dungeon quando disponibile.'
  OPTION_SMALL = 'Piccola'
  OPTION_BIG = 'Media'
end

class Sprite_MiniMap
  include MapPopup_Options

  def initialize(viewport)
    @x = viewport.rect.x
    @y = viewport.rect.y
    @viewport = viewport
    create_map
    self.visible = $game_system.minimap_activated?
  end

  def update
    check_commands
    relocate_map
  end

  def dispose
    @background.dispose
    @map_pic.dispose
    @map_frame.dispose
  end

  def create_map
    create_background
    create_map_picture
    create_map_frame
    relocate_map
  end

  def create_background
    @background = Sprite.new(@viewport)
    @background.bitmap = background_bitmap
    @background.zoom_x = $game_system.minimap_zoom
    @background.zoom_y = $game_system.minimap_zoom
  end

  def create_map_picture
    @map_pic = Sprite.new(@viewport)
    @map_pic.bitmap = get_map_bitmap
    @map_pic.zoom_x = $game_system.minimap_zoom
    @map_pic.zoom_y = $game_system.minimap_zoom
  end

  def create_map_frame
    @map_frame = Sprite.new(@viewport)
    @map_frame.bitmap = Cache.minimap_frame
    @map_frame.zoom_x = $game_system.minimap_zoom
    @map_frame.zoom_y = $game_system.minimap_zoom
  end

  def relocate_map
    return if @visible == false
    @background.x = 0
    @background.y = 0
    mult = $game_system.minimap_zoom
    @map_pic.x = (MAP_W/2 - $game_player.x) * mult
    @map_pic.y = (MAP_H/2 - $game_player.y) * mult
    @map_pic.z = @background.z + 1
    @map_frame.z = @map_pic.z + 1
  end

  def check_commands
    return unless $game_system.minimap_activated? and $game_system.minimap_enabled?
    switch_visible if Input.trigger?(:R)
  end

  def switch_visible
    Sound.play_ok
    self.visible = !@visible
  end

  def visible=(new_visibility)
    @visible = new_visibility
    $game_system.minimap_activated = new_visibility
    @viewport.visible = @visible
  end

  def get_map_bitmap
    Cache.minimap($game_map.map_id)
  end

  def background_bitmap
    Cache.minimap_background
  end

end

class Game_Party < Game_Unit

  # @return [Array<RPG::Item>]
  def minimap_items
    items.select { |item| MapPopup_Options::MINIMAP_ITEMS.keys.include?(item.id) }
  end

  # restituisce un array di tutte le mappe di cui il gruppo può vedere
  # la minimappa
  # @return [Array<Integer>]
  def unlocked_minimaps
    minimap_items.inject([]) {|sum, item| sum + MapPopup_Options::MINIMAP_ITEMS[item.id]}.flatten
  end
end

class Game_System
  def minimap_activated?
    $game_switches[MapPopup_Options::MINIMAP_SWITCH] == true
  end

  def minimap_activated=(active)
    $game_switches[MapPopup_Options::MINIMAP_SWITCH] = active
  end

  def minimap_enabled?
    return false if MapPopup_Options::DISABLED.include?($game_map.map_id)
    return false unless $game_party.unlocked_minimaps.include?($game_map.map_id)
    return false if $game_map.width < 25 && $game_map.height < 20
    true
  end

  def minimap_double_sized?
    $game_switches[MapPopup_Options::MINIMAP_SIZE_SW]
  end

  def minimap_zoom
    minimap_double_sized? ? 2 : 1
  end

end

module Cache
  # @param [Bitmap] map_id
  def self.minimap(map_id)
    @minimaps = {} if @minimaps.nil?
    @minimaps[map_id] = create_minimap if @minimaps[map_id].nil?
    return @minimaps[map_id]
  end

  def self.create_minimap
    map = $game_map
    bitmap = Bitmap.new(map.width, map.height)
    (0..map.width).each do |i|
      (0..map.height).each do |j|
        tile = map.minimap_type(i, j)
        next if tile == :not_passable
        bitmap.set_pixel(i, j, MapPopup_Options::MAP_COLORS[tile])
      end
    end
    bitmap
  end

  def self.minimap_background
    if @minim_bg.nil?
      color = MapPopup_Options::BG_COLOR
      w = MapPopup_Options::MAP_W
      h = MapPopup_Options::MAP_H
      @minim_bg = Bitmap.new(w, h)
      @minim_bg.fill_rect(0, 0, w, h, color)
    end
    return @minim_bg
  end

  def self.minimap_frame
    if @minim_fr.nil?
      color = MapPopup_Options::FR_COLOR
      point = MapPopup_Options::PT_COLOR
      w = MapPopup_Options::MAP_W
      h = MapPopup_Options::MAP_H
      @minim_fr = Bitmap.new(w, h)
      @minim_fr.fill_rect(0,0,w,1,color)
      @minim_fr.fill_rect(0,0,1,h,color)
      @minim_fr.fill_rect(w-1, 0, 1, h, color)
      @minim_fr.fill_rect(0, h-1, w, 1, color)
      @minim_fr.set_pixel(w/2, h/2, point)
    end
    return @minim_fr
  end
end

class Game_Event < Game_Character

  # determina se l'evento è un teletrasporto
  def teleport?
    return false if @list.nil?
    return false unless self.character_name.empty?
    #return false if @trigger != 2
    return false if @list.select{|command| [101,102].include? command.code }.any?
    @list.select{|command| command.code == 201}.any?
  end
end

class Game_Map
  def minimap_type(x, y)
    return :save if save_chrystal_on_xy?(x, y)
    return :teleport if teleport_on_xy?(x, y)
    return :passable if minimap_passable_on_xy?(x, y)
    :not_passable
  end

  def save_chrystal_on_xy?(x, y)
    events_xy(x, y).select{ |evt| evt.save_chrystal? }.any?
  end

  def teleport_on_xy?(x, y)
    events_xy(x, y).select{ |evt| evt.teleport? }.any?
  end

  def minimap_passable_on_xy?(x, y, flag = 0x01)
    [2, 1, 0].each { |i|
      tile_id = @map.data[x, y, i]
      return false if tile_id == nil
      pass = @passages[tile_id]
      next if pass & 0x10 == 0x10
      return true if pass & flag == 0x00
      return false if pass & flag == flag
    }
    false
  end
end

class Spriteset_Map
  include MapPopup_Options

  alias mmp_old_initialize initialize unless $@
  def initialize
    create_minimap_viewport
    create_minimap
    mmp_old_initialize
  end

  def create_minimap_viewport
    mult = $game_system.minimap_zoom
    @viewport_minimap = Viewport.new(MAP_X, MAP_Y, MAP_W * mult, MAP_H * mult)
    @viewport_minimap.z = 150
  end

  def create_minimap
    return unless minimap_enabled?
    @minimap = Sprite_MiniMap.new(@viewport_minimap)
  end

  def minimap_enabled?
    $game_system.minimap_activated? and $game_system.minimap_enabled?
  end

  def update_minimap
    return if @minimap.nil?
    @minimap.update
  end

  def dispose_minimap
    return if @minimap.nil?
    @minimap.dispose
  end

  alias wp_disposes dispose_viewports unless $@
  def dispose_viewports
    wp_disposes
    @viewport_minimap.dispose
  end

  alias mp_old_update update unless $@
  def update
    mp_old_update
    update_minimap
  end

  alias mp_old_dispose dispose unless $@
  def dispose
    mp_old_dispose
    dispose_minimap
  end

end