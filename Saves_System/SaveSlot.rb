#===============================================================================
# ** Save_Slot
#-------------------------------------------------------------------------------
# Questa classe viene gestita all'interno di Saves_Collection
#===============================================================================
class Save_Slot
  attr_reader :header               #salvataggio
  attr_reader :save_number          #numero dello slot
  attr_reader :x                    #posizione x
  attr_reader :y                    #posizione y
  attr_accessor :screenshot_loaded  #restituisce true se lo screen è pronto
  SCREENWIDTH = 80                  #LARGHEZZA
  HEIGHT = 64                       #ALTEZZA

  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, save_slot, viewport, header = nil)
    @x = x; @y = y
    @new_x = x; @new_y = y
    @speed = 2
    @save_number = save_slot
    @header = header
    @viewport = viewport
    create_screenshot_graphic
    create_save_info
    if !header.nil?
      @header = header
      extract_contents
      create_info_bitmap
      create_loading_bar
    else
      create_empty_file_bitmap
      create_fake_screen
      create_empty_info
    end
    update_slot_position
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    update_position
    update_loading_bar if !@loading_bar.nil?
    update_screenshot
  end
  #--------------------------------------------------------------------------
  # * Eliminazione
  #--------------------------------------------------------------------------
  def dispose
    @screenshot.bitmap.dispose if !@screenshot.bitmap.nil?
    @screenshot.dispose
    @save_contents.bitmap.dispose
    @save_contents.dispose
    @loading_bar.dispose if !@loading_bar.nil?
  end
  #--------------------------------------------------------------------------
  # * Creazione screenshot falso
  #--------------------------------------------------------------------------
  def create_fake_screen
    @screenshot.bitmap = black_bitmap
    @screenshot_loaded = true
  end
  #--------------------------------------------------------------------------
  # * Creazione delle informazioni sullo
  #--------------------------------------------------------------------------
  def create_empty_info
    @info_rect = Sprite.new(@viewport)
    @info_rect.bitmap = @info
    #@info_rect.ox = -165
  end

  def create_empty_file_bitmap
    @info = Bitmap.new(Graphics.width - SCREENWIDTH - 10, HEIGHT)
    @info.draw_text(0,0,@info.width,@info.height,Vocab.slot_empty,1)
    draw_save_number(0,2)
  end


  #--------------------------------------------------------------------------
  # * Restituisce true se lo slot di salvataggio è vuoto
  #--------------------------------------------------------------------------
  def is_empty?
    return @header.nil?
  end

  #--------------------------------------------------------------------------
  # * Muove lo slot ad una coordinata prefissata
  #     x: coordinata traguardo
  #     y: coordinata traguardo
  #     speed: 1: immediato, 2: velocissimo, 3: lento
  #--------------------------------------------------------------------------
  def move_to(x, y, speed = 2)
    @new_x = x
    @new_y = y
    @speed = speed
  end

  def move_x(x)
    @new_x = x
  end

  def move_y(y)
    @new_y = y
  end


  #--------------------------------------------------------------------------
  # * Muove la finestra
  #--------------------------------------------------------------------------
  def update_position
    @x += (@new_x - @x)/@speed
    @y += (@new_y - @y)/@speed
    update_slot_position
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la barra di caricamento
  #--------------------------------------------------------------------------
  def update_loading_bar
    @loading_bar.update
  end

  #--------------------------------------------------------------------------
  # * Aggiorna l'apparizione dello screenshot
  #--------------------------------------------------------------------------
  def update_screenshot
    return unless @screenshot_loaded
    @screenshot.opacity += 25
  end

  def contents
    @header
  end

  def members
    @actors
  end

  #--------------------------------------------------------------------------
  # * Estrae i contenuti dal salvataggio
  #--------------------------------------------------------------------------
  def extract_contents
    @play_time     = contents[:playtime_s]
    @gold          = contents[:gold]
    @map_name      = contents[:map_name]
    @actors        = contents[:characters]
    @player        = contents[:player_name]
    @story         = contents[:story]
  end

  #--------------------------------------------------------------------------
  # * Crea lo sprite dello screenshot
  #--------------------------------------------------------------------------
  def create_screenshot_graphic
    @screenshot_loaded = false
    @screenshot = Sprite.new(@viewport)
    @screenshot.opacity = 0
  end

  #--------------------------------------------------------------------------
  # * Crea lo sprite delle informazioni
  #--------------------------------------------------------------------------
  def create_save_info
    @info = Bitmap.new(Graphics.width-10, HEIGHT)
    @info_rect = Sprite.new(@viewport)
    @info_rect.bitmap = @info
    @info_rect.ox = -5#165
  end

  #--------------------------------------------------------------------------
  # * Restituisce la bitmap delle informazioni
  #--------------------------------------------------------------------------
  def create_info_bitmap
    @info = Bitmap.new(Graphics.width-10, HEIGHT)
    #draw_party_members(80, 2)
    draw_save_number(85,60)
    draw_bars
    #draw_playTime(0, 98)
    #draw_story(0,122)
    #draw_gold(0,98)
    #draw_location(0, 122)
  end

  def draw_party_members(x, y)
    return if @actors.nil?
    for i in 0..@actors.size-1
      draw_character_info(@actors[i], x + (i*96), y)
    end
  end

  def draw_bars
    color1 = Color.new(255,255,255,128)
    color2 = Color.new(255,255,255,0)
    @info.gradient_fill_rect(0, 2, @info.width, 1, color1, color2)
    @info.gradient_fill_rect(0, @info.height - 2, @info.width, 1, color1, color2)
  end

  def draw_save_number(x, y)
    @info.draw_text(x,y,@info.width-x,line_height,sprintf(Vocab.slot,@save_number))
  end

  def draw_playTime(x, y)
    @info.font.color = system_color
    @info.draw_text(x, y, @info.width-x, line_height,Vocab.play_time)
    @info.font.color = normal_color
    xx = x+ @info.text_size(Vocab.play_time).width
    @info.draw_text(xx, y, @info.width-xx,line_height,@play_time)
  end

  def draw_gold(x, y)
    @info.font.color = normal_color
    @info.draw_text(x, y, @info.width-x, line_height,@gold,2)
    @info.font.color = system_color
    xx = @info.width - @info.text_size(@gold).width
    @info.draw_text(x, y, xx, line_height,Vocab.gold,2)
    @info.font.color = normal_color
  end

  def draw_location(x, y)
    @info.draw_text(x,y,@info.width,line_height,@map_name)
  end

  def draw_story(x,y)
    st = (@story.to_f/CPanel::MAX_STORY*100).to_i
    @info.draw_text(x,y,@info.width,line_height,sprintf(Vocab.story,st),2)
  end

  def draw_character_info(actor, x, y)
    draw_face(actor[0], actor[1], x, y, 96)
    draw_hp_bar(actor,x,y+90)
    draw_level(actor,x+2,y+2)
  end

  def draw_hp_bar(actor, x, y)
    @info.fill_rect(x,y,94,4,Color.new(0,0,0))
    @info.fill_rect(x+1,y+1,92,2,gauge_back_color)
    w = [actor[3].to_f/actor[4]*92.0, 92].min
    @info.fill_rect(x+1,y+1,w,2,hp_gauge_color1)
  end

  def draw_level(actor, x, y)
    @info.draw_text(x, y, 90, line_height, actor[2])
  end

  #--------------------------------------------------------------------------
  # * Crea la barra di caricamento
  #--------------------------------------------------------------------------
  def create_loading_bar
    @loading_bar = Loading_Bar.new(@x, @y, 60, @viewport)
  end

  #--------------------------------------------------------------------------
  # * Carica lo screenshot dal salvataggio
  #--------------------------------------------------------------------------
  def start_load_screenshot
    show_loading_bar
    Thread.new{extract_graphic}
  end

  #--------------------------------------------------------------------------
  # * Estrae la bitmap dal salvataggio (usato in thread separato)
  #--------------------------------------------------------------------------
  def extract_graphic
    if !Cache.screenshot(@save_number, header).nil?
      bitmap_screenshot = Cache.screenshot(@save_number, header)
      @screenshot.zoom_x = 2
      @screenshot.zoom_y = 2
    else @virtualb = DataManager.load_screenshot(@save_number)
    if @virtualb.nil?
      bitmap_screenshot = black_bitmap
    else
      bitmap_screenshot = @virtualb.get_bitmap
      @screenshot.zoom_x = 2
      @screenshot.zoom_y = 2
      Cache.add_screenshot(@save_number, bitmap_screenshot, header[:key])
    end
    end
    @screenshot.bitmap = bitmap_screenshot
    @screenshot_loaded = false
    @loading_bar.disappear
  end

  #--------------------------------------------------------------------------
  # * Restituisce una bitmap nera di dimensioni 160x120
  #--------------------------------------------------------------------------
  def black_bitmap
    bitmap = Bitmap.new(80, 60)
    bitmap.fill_rect(0,0,80,60,Color.new(10,10,10))
    return bitmap
  end

  #--------------------------------------------------------------------------
  # * Aggiorna la posizione degli elementi dello slot
  #--------------------------------------------------------------------------
  def update_slot_position
    @screenshot.x = @x
    @screenshot.y = @y
    @info_rect.x = @x
    @info_rect.y = @y
    if @loading_bar != nil
      @loading_bar.x = @x + 30
      @loading_bar.y = @y + 80
    end
  end

  def line_height
    return 24
  end

  #--------------------------------------------------------------------------
  # * Get Normal Text Color
  #--------------------------------------------------------------------------
  def normal_color
    #return Color.new(255,255,255)
  end
  #--------------------------------------------------------------------------
  # * Get System Text Color
  #--------------------------------------------------------------------------
  def system_color
    return Color.new(255,255,0)
  end
  #--------------------------------------------------------------------------
  # * Get Crisis Text Color
  #--------------------------------------------------------------------------
  def crisis_color
    return text_color(17)
  end
  #--------------------------------------------------------------------------
  # * Get Gauge Background Color
  #--------------------------------------------------------------------------
  def gauge_back_color
    return Color.new(120,120,120)
  end
  #--------------------------------------------------------------------------
  # * Get HP Gauge Color 1
  #--------------------------------------------------------------------------
  def hp_gauge_color1
    return Color.new(0,255,128)
  end
  #--------------------------------------------------------------------------
  # * Draw Icon
  #     icon_index : Icon number
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     enabled    : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y, enabled = true)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * line_height, icon_index / 16 * line_height, line_height, line_height)
    @info.blt(x, y, bitmap, rect, enabled ? 255 : 128)
  end
  #--------------------------------------------------------------------------
  # * Draw Face Graphic
  #     face_name  : Face graphic filename
  #     face_index : Face graphic index
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     size       : Display size
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, x, y, size = 96)
    bitmap = Cache.face(face_name)
    rect = Rect.new(0, 0, 0, 0)
    rect.x = face_index % 4 * 96 + (96 - size) / 2
    rect.y = face_index / 4 * 96 + (96 - size) / 2
    rect.width = size
    rect.height = size
    @info.blt(x, y, bitmap, rect)
    bitmap.dispose
  end
end #save_slot


