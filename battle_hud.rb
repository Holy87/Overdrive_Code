require File.expand_path 'rm_vx_data'
#===============================================================================
# Overdrive Battle HUD
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo HUD di battaglia sostituisce la vecchia finestra status con delle barre
# animate e dinamiche. Le funzioni sono le seguenti:
# - Mostra barre PV ed MP con lunghezza determinata da PV e PM massimi
# - Mostra il danno/cura con tacche rosse o verdi sulla barra
# - Mostra tutti gli status alterati. Se si supera il limite di 5, cominciano a
# ruotare.
# - Se uno stato alterato sta per svanire, lampeggia
# - Se un eroe sta per morire, si avverte un suono e la sua barra lampeggia
# - Mostra anche le barre Furia e tempo di evocazione
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main.
# RICHIEDE UNA SERIE DI SCRIPT INCLUSI NEL GIOCO.
# Non dico che è vietato usarlo per il vostro gioco, ma necessita di adattamenti.

#===============================================================================
# ** CONFIGURAZIONE
#===============================================================================
module H87HUD_SETTINGS
  # Colori dello sfondo delle barre
  BAR_COLORS = {
      :hp => Color.new(122, 0, 38),
      :black => Color.new(0, 0, 0, 128),
      :damage => Color.new(255, 0, 0),
      :heal => Color.new(20, 200, 0),
      :back => Color.new(0, 0, 0, 128),
  }
  # Colori gradienti
  GRAD_COLORS1 = {
      :hp => Color.new(255, 0, 0),
      :mp => Color.new(4, 169, 218),
      :wh => Color.new(255, 255, 255),
      :ch => Color.new(123, 227, 29),
      :es => Color::DEEPPINK
  }

  GRAD_COLORS2 = {
      :hp => Color.new(248, 147, 29),
      :mp => Color.new(122, 217, 246),
      :wh => Color.new(255, 255, 255, 0),
      :ch => Color.new(201, 255, 48),
      :es => Color::PINK
  }

  # Tonalità dell'eroe attivo
  SELECTED_TONE = Tone.new(100, 255, 0)
  # Tonalità del riquadro volto eroe
  NORMAL_FACE_TONE = Tone.new(0, 0, 0)
  DEAD_FACE_TONE = Tone.new(0, 0, 0, 255)
  # Colori del flash volto eroe
  DAMAGE_FLASH_CL = Color::RED
  HEAL_FLASH_CL = Color::GREEN
  FLASH_DURATION = 30
  # Altezza barra PV
  HP_HEIGHT = 12
  # Altezza barra PM
  MP_HEIGHT = 6
  # Grafica immagine dei numeri
  NUMBERGRAPH = "Numbers"
  # Altezza dell'immagine dei numeri PV
  NUMBER_Y = 0
  # Spaziatura delle cifre
  NUMBER_SPACING = 12
  # Velocità del cambiamento dei numeri
  NUMBER_DIVIDER = 50
  # Altezza barra eroe
  BSH = 28
  # Grafica immagine dei numeri PM
  MPNUMBERGRAPH = "NumbersL"
  # Altezza
  MPNUMBER_Y = 15
  # Spaziatura
  MPNUMBER_SPACING = 7
  # Sfondo della barra HUD
  HUD_BACKGROUND = 'HudBackground'
  # Suono d'allarme quando un personaggio sta per morire
  ALARM_SE = ["Ice1", 100, 150]
end

#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
# Aggiunta delle barre
#==============================================================================
module Cache
  include H87HUD_SETTINGS
  # Restituisce la barra dell'HUD
  # type: tipo di barra
  # @return [Bitmap]
  def self.hud_bar(type)
    @hud_bars = {} if @hud_back_bars.nil?
    return @hud_bars[type] if @hud_bars[type]
    bitmap = Bitmap.new(1, 1)
    bitmap.set_pixel(0, 0, proper_color(type))
    @hud_bars[:type] = bitmap
    return bitmap
  end

  # Restituisce il battle face dell'eroe
  # actor_id: ID dell'eroe
  # @param [Integer] actor_id
  # @return [Bitmap]
  def self.battle_face(actor_id)
    load_bitmap("Graphics/Battle Faces/", sprintf('%03d', actor_id))
  end

  # Restituisce il colore appropriato del tipo
  # type: tipo
  # @param [Object] type
  # @return [Color]
  def self.proper_color(type)
    return BAR_COLORS[type]
  end

  # Restituisce la bimap gradiente per la barra
  # type: tipo
  # @return [Bitmap]
  def self.gradient_bitmap(type)
    @gradient_bitmaps = {} if @gradient_bitmaps.nil?
    return @gradient_bitmaps[type] if @gradient_bitmaps[type]
    bitmap = Bitmap.new(500, 1)
    bitmap.gradient_fill_rect(0, 0, 500, 1, gc1(type), gc2(type))
    @gradient_bitmaps[type] = bitmap
    return bitmap
  end

  # Returns the first gradient color
  # type: bar type
  # @return [Color]
  def self.gc1(type)
    GRAD_COLORS1[type]
  end

  # Returns the second gradient color
  # type: bar type
  # @return [Color]
  def self.gc2(type)
    GRAD_COLORS2[type]
  end
end

#==============================================================================
# ** BattleHud
#------------------------------------------------------------------------------
# HUD principale
# noinspection RubyInstanceVariableNamingConvention
#==============================================================================
class Battle_Hud
  # Instance variables
  attr_reader :x
  attr_reader :y
  attr_reader :width
  attr_reader :index
  # Initialization
  def initialize
    @x = 0
    @index = -1
    @y = Graphics.height - (5 * H87HUD_SETTINGS::BSH)
    @width = Graphics.width
    create_background
    create_contents
  end

  # Create HUD contents
  def create_contents
    @members = $game_party.battle_members
    @members_id = get_members_id(@members)
    create_battle_status
    move_battle_status_origin
  end

  # Useless methods
  def x=(value)
    ; @x = value;
  end

  def y=(value)
    ; @y = value;
  end

  def active=(value)
    ; @active = value;
  end

  def active;
    true;
  end

  # Sets the HUD visibility
  # value: HUD visibility true/false
  def visible=(value)
    value ? show : hide
    #@battle_status_elements.each {|battlestatus|
    # battlestatus.visible = value
    #}
  end

  # hides the batle status with animation
  def hide;
    @viewport.smooth_move(0, self.height);
  end

  # shows the battle status with animation
  def show;
    @viewport.smooth_move(0, 0);
  end

  # Sets the selected actor
  # value: actor index
  def index=(value)
    return if @index == value
    @battle_status_elements.each { |battlestatus|
      battlestatus.selected = false
    }
    if @index >= 0 and @battle_status_elements[@index] != nil
      @battle_status_elements[@index].selected = true
    end
  end

  # Moves all battle status HUD to origin
  def move_battle_status_origin
    @battle_status_elements.each { |battlestatus|
      y = battlestatus.y - height
      battlestatus.smooth_move(0, y)
    }
    @background.smooth_move(0, Graphics.height - height)
  end

  # Returns an array of battle members ID
  # members: $game_party.members
  # @param [Array<Game_Actor>] members
  # @return [Array]
  def get_members_id(members)
    ary = []
    members.each do |member|
      ary.push(member.id)
    end
    ary
  end

  # Returns HUD height (fixed)
  def height
    $game_party.battle_members.size * H87HUD_SETTINGS::BSH
  end

  # Refresh
  def refresh
    if party_members_changed?
      clear_all # ripristina tutti i personaggi se il gruppo cambia
    else
      @battle_status_elements.each { |bt| bt.refresh }
    end
  end

  # Determines if the party changed
  def party_members_changed?
    @members_id != get_members_id($game_party.members)
  end

  # Dispose old HUD for party changing
  def clear_all
    @battle_status_elements.each { |bt| bt.smooth_move(0, Graphics.height + 2) }
    @moving = true
  end

  # HUD background creation
  def create_background
    @background = Sprite.new
    @background.bitmap = Cache.hud_bar(:back)
    @background.width = @width
    @background.y = Graphics.height
    @background.height = H87HUD_SETTINGS::BSH * 6
    @background.opacity = 0
  end

  # Actor status creation
  def create_battle_status
    yy = Graphics.height
    @battle_status_elements = []
    @members.each { |member|
      battlestatus = Actor_BattleStatus.new(x, yy, width, member)
      battlestatus.viewport = @viewport unless @viewport.nil?
      @battle_status_elements.push(battlestatus)
      yy += battlestatus.height
    }
  end

  # Update
  def update
    @background.update
    @battle_status_elements.each { |battlestatus|
      battlestatus.update
    }
    if @moving
      if out_of_border?
        @moving = false
        delete_contents
        create_contents
      end
    end
  end

  # Delete contents for party change
  def delete_contents
    @battle_status_elements.each { |bt| bt.dispose }
    @battle_status_elements.clear
  end

  # Returns true if HUD is out of border (down corner)
  def out_of_border?
    return false if @battle_status_elements.empty?
    @battle_status_elements[0].y >= Graphics.height
  end

  # Sets the new viewport
  # viewport: new viewport
  # @param [Viewport] viewport
  def viewport=(viewport)
    @viewport = viewport
    @battle_status_elements.each { |bt| bt.viewport = viewport }
    @background.viewport = viewport
  end

  # Object dispose
  def dispose
    @battle_status_elements.each { |bt| bt.dispose }
    @background.dispose
  end
end

#==============================================================================
# ** Actor_BattleStatus
#------------------------------------------------------------------------------
# HUD class for single actor
#==============================================================================
# noinspection RubyInstanceVariableNamingConvention
class Actor_BattleStatus
  include Smooth_Movements
  # Instance variables
  # @return [Game_Actor] actor
  attr_reader :x
  attr_reader :width
  attr_reader :y
  attr_reader :height
  attr_reader :selected
  # Initialization
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Game_Actor] actor
  def initialize(x, y, width, actor)
    @actor = actor
    @x = x
    @y = y
    @width = width
    @height = H87HUD_SETTINGS::BSH
    @attached_objects_x = {}
    @attached_objects_y = {}
    @selected = false
    @viewport = nil
    create_status
    create_faces
    create_bars
    create_numbers
    create_divider
    adjust_positions
  end

  # restituisce l'eroe
  # @return [Game_Actor]
  def actor;
    @actor;
  end

  # Background creation
  def create_divider
    divider = Sprite.new(@viewport)
    divider.bitmap = Cache.system(H87HUD_SETTINGS::HUD_BACKGROUND)
    #divider.x = 0
    divider.y = -2 #27
    #divider.opacity = 128
    #divider.width = self.width/1.5
    register_object divider
    @divider = divider
  end

  # Update
  def update
    @attached_objects_x.each_key { |obj| obj.update }
    update_smooth_movements
  end

  # Sets the selected state
  # value: true/false
  def selected=(value)
    return if @selected == value
    @selected = value
    if @selected
      @divider.tone = H87HUD_SETTINGS::SELECTED_TONE
    else
      @divider.tone = Tone.new(0, 0, 0)
    end
  end

  # Sets the visible state
  # value: true/false
  def visible=(value)
    @attached_objects_x.each_key { |obj| obj.visible = value }
  end

  # Dispose
  def dispose
    @attached_objects_x.each_key { |obj| obj.dispose }
  end

  # Refresh
  def refresh
    @status_container.set_states(actor.states)
    @hp_bar.width = hp_width
    @hp_bar.set_value(actor.hp_rate * 100)
    @hp_numbers.change_value(actor.hp, actor.mhp)
    if actor.charge_gauge?
      @anger_bar.width = anger_width
      @anger_bar.set_value(actor.anger_rate * 100)
      @anger_numbers.change_value(actor.anger, actor.max_anger)
    else
      @mp_bar.width = mp_width
      @mp_bar.set_value(actor.mp_rate * 100)
      @mp_numbers.change_value(actor.mp, actor.mmp)
    end
    if actor.is_esper?
      @esper_bar.set_value($game_temp.domination_turns_rate * 100)
    end
    @bface.z = 999
    refresh_bface
  end

  # Battle Face refresh (change color if KO)
  def refresh_bface
    @old_hp = actor.hp if @old_hp.nil?
    return if @old_hp == actor.hp
    @bface.tone = actor.hp > 0 ? H87HUD_SETTINGS::NORMAL_FACE_TONE : H87HUD_SETTINGS::DEAD_FACE_TONE
    duration = H87HUD_SETTINGS::FLASH_DURATION
    if actor.hp < @old_hp
      @bface.flash(H87HUD_SETTINGS::DAMAGE_FLASH_CL, duration)
    else
      @bface.flash(H87HUD_SETTINGS::HEAL_FLASH_CL, duration)
    end
    @old_hp = actor.hp
  end

  # Status container creation
  def create_status
    @status_container = States_Shower.new(0, 0, 120, actor)
    register_object(@status_container)
  end

  # Battle Face creation
  def create_faces
    @bface = Sprite.new
    @bface.bitmap = Cache.battle_face(actor.id)
    @bface.x = 122
    register_object(@bface)
  end

  # Bars creation
  def create_bars
    create_hp_bar
    actor.charge_gauge? ? create_anger_bar : create_mp_bar
    create_esper_bar if actor.is_esper?
  end

  # HP bar creation
  def create_hp_bar
    @hp_bar = Battle_HpBar.new(210, 4, hp_width)
    @hp_bar.set_value(actor.hp_rate * 100)
    register_object(@hp_bar)
  end

  # MP bar creation
  def create_mp_bar
    @mp_bar = Battle_MpBar.new(210, 18, mp_width)
    @mp_bar.set_value(actor.mp_rate * 100)
    register_object(@mp_bar)
  end

  # Anger gauge creation
  def create_anger_bar
    @anger_bar = Battle_Charge_Bar.new(210, 18, anger_width)
    @anger_bar.set_value(actor.anger_rate * 100)
    register_object(@anger_bar)
  end

  # Esper Gauge Creation
  def create_esper_bar
    width = esper_width
    x = @mp_bar.x + @mp_bar.width + 10
    @esper_bar = Battle_EsperBar.new(x, 18, width)
    @esper_bar.set_value($game_temp.domination_turns_rate * 100)
    register_object(@esper_bar)
  end

  # returns HP bar width
  def hp_width
    max_width = Graphics.width - 230
    [actor.mhp * hp_divisor(max_width), max_width].min
  end

  # returns MP bar width
  def mp_width
    max_width = Graphics.width - 230
    [actor.mmp * mp_divisor(max_width), max_width].min
  end

  # Returns anger gauge width
  def anger_width
    max_width = Graphics.width - 230
    [actor.max_anger * anger_divisor(max_width), max_width].min
  end

  # restituisce la larghezza della barra di carica della dominazione
  def esper_width
    $game_temp.domination_max_turns * 3
  end

  # returns the proper HP divisor for bar max width
  def hp_divisor(max_width)
    pmhp = $game_party.mhp
    if pmhp * 0.1 > max_width
      max_width.to_f / $game_party.mhp
    else
      0.1
    end
  end

  # returns the proper MP divisor for bar max width
  def mp_divisor(max_width)
    pmmp = $game_party.mmp
    if pmmp * 0.5 > max_width
      max_width.to_f / $game_party.mmp
    else
      0.5
    end
  end

  # Returns the default anger size
  def anger_divisor(max_width)
    if actor.max_anger > max_width
      max_width.to_f / actor.max_anger
    else
      1
    end
  end

  # Numbers creation
  def create_numbers
    create_hp_numbers
    actor.charge_gauge? ? create_anger_numbers : create_mp_numbers
  end

  # HP number creation
  def create_hp_numbers
    y = H87HUD_SETTINGS::NUMBER_Y
    graph = H87HUD_SETTINGS::NUMBERGRAPH
    spacing = H87HUD_SETTINGS::NUMBER_SPACING
    @hp_numbers = Battle_Numbers.new(208, y, graph, spacing)
    @hp_numbers.set_value(actor.hp)
    @hp_numbers.z = 999
    register_object(@hp_numbers)
  end

  # MP number creation
  def create_mp_numbers
    y = H87HUD_SETTINGS::MPNUMBER_Y
    graph = H87HUD_SETTINGS::MPNUMBERGRAPH
    spacing = H87HUD_SETTINGS::MPNUMBER_SPACING
    @mp_numbers = Battle_Numbers.new(208, y, graph, spacing)
    @mp_numbers.set_value(actor.mp)
    @mp_numbers.z = 999
    register_object(@mp_numbers)
  end

  # Charge number creation
  def create_anger_numbers
    y = H87HUD_SETTINGS::MPNUMBER_Y
    graph = H87HUD_SETTINGS::MPNUMBERGRAPH
    spacing = H87HUD_SETTINGS::MPNUMBER_SPACING
    @anger_numbers = Battle_Numbers.new(208, y, graph, spacing)
    @anger_numbers.set_value(actor.anger)
    @anger_numbers.z = 999
    register_object(@anger_numbers)
  end

  # Sets the proper viewport
  # viewport = viewport
  def viewport=(viewport)
    @attached_objects_x.each_key { |object| object.viewport = viewport }
  end

  # Update position for all registered objects
  def adjust_positions
    adjust_x
    adjust_y
  end

  # Set the HUD X coordinate
  def x=(value)
    @x = value
    adjust_x
  end

  # Set the HUD Y coordinate
  def y=(value)
    @y = value
    adjust_y
  end

  # Sets the proper X coordinate for all registered objects
  def adjust_x
    @attached_objects_x.each_pair do |object, x|
      object.x = self.x + x
    end
  end

  # Sets the proper Y coordinate for all registered objects
  def adjust_y
    @attached_objects_y.each_pair do |object, y|
      object.y = self.y + y
    end
  end

  # Register an object to bind at HUD
  def register_object(object)
    @attached_objects_x[object] = object.x
    @attached_objects_y[object] = object.y
  end
end

#==============================================================================
# ** Battle_Bar
#------------------------------------------------------------------------------
# Class for showing generic bars like HP/MP
#==============================================================================
# noinspection RubyInstanceMethodNamingConvention,RubyInstanceVariableNamingConvention
class Battle_Bar
  # Initialize
  # x: X coordinate
  # y: Y coordinate
  # width: bar width
  # height: bar height
  # background_bitmap: bitmap for empty back bar
  # foreground_bitmap: bitmap for bar sprite
  def initialize(x, y, width, height, background_bitmap, foreground_bitmap)
    create_sprites(background_bitmap, foreground_bitmap)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    @actor = nil
  end

  # Other methods
  def x;
    @x;
  end

  def y;
    @y;
  end

  def z;
    @z;
  end

  def width;
    @width;
  end

  def height;
    @height;
  end

  def actor;
    @actor;
  end

  # Sets the visible property
  def visible=(value)
    @background.visible = value
    @foreground.visible = value
    @mid_bar.visible = value
  end

  # Bar sprites creation
  # background_bitmap: bitmap for empty back bar
  # foreground_bitmap: bitmap for bar sprite
  # @param [Bitmap] background_bitmap
  # @param [Bitmap] foreground_bitmap
  def create_sprites(background_bitmap, foreground_bitmap)
    @background = Sprite.new
    @mid_bar = Sprite.new
    @foreground = Sprite.new
    @background.bitmap = background_bitmap
    @mid_bar.bitmap = mid_bitmap
    @foreground.bitmap = foreground_bitmap
  end

  # Returns the bitmap for the mid bar (the one that fills green/red)
  # @param [Symbol] type
  # @return [Bitmap]
  def mid_bitmap(type = :black)
    Cache.hud_bar(type)
  end

  # Sets the X coordinate
  # value: X coordinate
  def x=(value)
    @x = value
    @background.x = value
    @foreground.x = value + 1
    @mid_bar.x = value + 1
  end

  # Sets the Y coordinate
  # value: Y coordinate
  def y=(value)
    @y = value
    @background.y = value
    @foreground.y = value + 1
    @mid_bar.y = value + 1
  end

  # Sets the Z coordinate
  # value: Z coordinate
  def z=(value)
    @z = value
    @background.z = value
    @mid_bar.z = value + 1
    @foreground.z = value + 2
  end

  # Set width
  # value: new width
  def width=(value)
    @width = value
    @background.width = value
    set_foreground_width(@value) unless @value.nil?
  end

  # set height
  # value: new height
  def height=(value)
    @height = value
    @background.height = value
    @mid_bar.height = value - 2
    @foreground.height = value - 2
  end

  # Calc the proper foreground bar width
  # value: 0 to 1 float
  def calc_for_width(value)
    (self.width * value / 100.0).to_i - 2
  end

  # Sets the width for foreground bar
  # value: 0 to 1 float
  def set_foreground_width(value)
    @foreground.width = calc_for_width(value)
  end

  # Update
  def update
    update_blink if @value <= 20 && @value > 0
    @background.update
    @foreground.update
    @mid_bar.update
  end

  # Dispose
  def dispose
    @background.dispose
    @foreground.dispose
    @mid_bar.dispose
  end

  # Sets new viewport
  # viewport: viewport
  def viewport=(viewport)
    @background.viewport = viewport
    @foreground.viewport = viewport
    @mid_bar.viewport = viewport
  end

  # Flash update process (it must be overriden)
  def update_blink
  end

  # Sets the new bar value
  def set_value(value)
    return if value.nil?
    if @value.nil?
      @foreground.width = calc_for_width(value)
      @value = value
      return
    end
    return if @value == value
    if value > @value
      @mid_bar.bitmap = mid_bitmap(:heal)
      @mid_bar.width = calc_for_width(value)
      speed = [(@value - value) / 10, 1].max
      @foreground.change_size(calc_for_width(value), @foreground.screen_height, speed)
    else
      @mid_bar.bitmap = mid_bitmap(:damage)
      @mid_bar.width = calc_for_width(@value)
      @foreground.width = calc_for_width(value)
      speed = [(value - @value) / 10, 1].max
      @mid_bar.change_size(calc_for_width(value), @mid_bar.screen_height, speed)
    end
    @value = value
  end
end

#==============================================================================
# ** Battle_HpBar
#------------------------------------------------------------------------------
# Bar for HP
#==============================================================================
class Battle_HpBar < Battle_Bar
  # Initialization
  # x: X coordinate
  # y: Y coord
  # width: bar width
  def initialize(x, y, width)
    height = H87HUD_SETTINGS::HP_HEIGHT
    background_bitmap = Cache.hud_bar(:black)
    foreground_bitmap = Cache.gradient_bitmap(:hp)
    super(x, y, width, height, background_bitmap, foreground_bitmap)
  end

  # Flash update process
  def update_blink
    if Graphics.frame_count % 100 == 0
      @background.flash(Color.new(255, 0, 0, (250 - @value * 4)), 60)
      @foreground.flash(Color.new(255, 255, 255), 60)
      se = H87HUD_SETTINGS::ALARM_SE
      RPG::SE.new(se[0], se[1], se[2]).play
    end
  end
end

#==============================================================================
# ** Battle_MpBar
#------------------------------------------------------------------------------
# Bar for MP
#==============================================================================
class Battle_MpBar < Battle_Bar
  # Initialization
  # x: X coordinate
  # y: Y coord
  # width: bar width
  def initialize(x, y, width)
    height = H87HUD_SETTINGS::MP_HEIGHT
    background_bitmap = Cache.hud_bar(:black)
    foreground_bitmap = Cache.gradient_bitmap(:mp)
    super(x, y, width, height, background_bitmap, foreground_bitmap)
  end

  # Flash update process
  def update_blink
    if Graphics.frame_count % 50 == 0
      @background.flash(Color.new(255, 255, 255, 50), 40)
      @foreground.flash(Color.new(255, 255, 255, 50), 40)
    end
  end
end

#==============================================================================
# ** Battle_EsperBar
#------------------------------------------------------------------------------
# Bar for Esper duration
#==============================================================================
class Battle_EsperBar < Battle_Bar
  def initialize(x, y, width = 100)
    height = H87HUD_SETTINGS::MP_HEIGHT
    background_bitmap = Cache.hud_bar(:black)
    foreground_bitmap = Cache.gradient_bitmap(:es)
    super(x, y, width, height, background_bitmap, foreground_bitmap)
  end
end

#==============================================================================
# ** Battle_Charge_Bar
#------------------------------------------------------------------------------
# Bar for Charging
#==============================================================================
class Battle_Charge_Bar < Battle_Bar
  # Initialization
  # x: X coordinate
  # y: Y coord
  # width: bar width
  def initialize(x, y, width)
    height = H87HUD_SETTINGS::MP_HEIGHT
    background_bitmap = Cache.hud_bar(:black)
    foreground_bitmap = Cache.gradient_bitmap(:ch)
    super(x, y, width, height, background_bitmap, foreground_bitmap)
  end
end

#==============================================================================
# ** Battle_Number
#------------------------------------------------------------------------------
# Single number displayed on bar
#==============================================================================
class Battle_Number < Sprite
  # Initialization
  # number_graphic: bitmap to choose for number font
  def initialize(number_graphic)
    super(nil)
    @bitmap_number = Cache.system(number_graphic)
    @numbers = []
    self.visible = false
    (0..9).each { |i|
      @numbers.push(get_bitmap(i))
    }
  end

  # Returns the proper bitmap by index in number_graphic
  # index: number index
  # @param [Bitmap] index
  def get_bitmap(index)
    width = @bitmap_number.width / 10
    height = @bitmap_number.height
    t_bitmap = Bitmap.new(width, height)
    rect = Rect.new(width * index, 0, width, height)
    t_bitmap.blt(0, 0, @bitmap_number, rect)
    t_bitmap
  end

  # Set a new number
  # number: value from 0 to 9
  def set_number(number)
    return if number > 9 or number < 0
    self.bitmap = @numbers[number]
  end
end

#==============================================================================
# ** Battle_Numbers
#------------------------------------------------------------------------------
# Container class with numbers
#==============================================================================
# noinspection RubyInstanceVariableNamingConvention
class Battle_Numbers
  # Instance variables
  attr_reader :x
  attr_reader :y
  attr_reader :z
  # Object initialization
  # x: X coord
  # y: Y coord
  # number_graphic: graphic for number
  # spacing: number spacing
  def initialize(x, y, number_graphic, spacing)
    @x = x
    @y = y
    @number_graphic = number_graphic
    @spacing = spacing
    @value = 0
    create_numbers
    recall_numbers
  end

  # Number creation
  def create_numbers
    @numbers = []
    (0..4).each { |i|
      @numbers[i] = Battle_Number.new(@number_graphic)
    }
  end

  # Set number coordinates
  def recall_numbers
    reset_x
    reset_y
  end

  # Set initial X coordinate for all numbers
  def reset_x
    x = @x
    @numbers.each do |number|
      number.x = x
      x += @spacing
    end
  end

  # Returns container width
  def width;
    50;
  end

  # Returns container height
  def height;
    10;
  end

  # Set initial T coordinate for all numbers
  def reset_y
    @numbers.each { |num| num.y = @y }
  end

  # Set new X coordinate
  # value: new X coordinate
  def x=(value)
    @x = value
    reset_x
  end

  # Set new Y coordinate
  # value: new Y coordinate
  def y=(value)
    @y = value
    reset_y
  end

  # eSet new Z coordinate
  # value: new Z coordinate
  def z=(value)
    @z = value
    @numbers.each { |num| num.z = value }
  end

  # Set visibility
  def visible=(value)
    @numbers.each { |num| num.visible = value }
  end

  # Change number value
  # value: new value
  # max: proportion for max hp/mp
  def change_value(value, max)
    set_tone(value, max)
    return if @value == value
    mul = value <=> @value
    @change_speed = [(value - @value).abs / H87HUD_SETTINGS::NUMBER_DIVIDER, 1].max * mul
    @target = value
  end

  # Set instantly the new value with no animation
  # value: new value
  def set_value(value)
    return if value == @value
    @value = value
    val_string = value.to_i.to_s
    @numbers.each_with_index { |number, i|
      if val_string[i].nil? or i >= val_string.size
        number.visible = false
      else
        number.visible = true
        number.set_number(val_string[i..i].to_i)
      end
    }
  end

  # update number changing
  def update_change
    return if @target.nil?
    return if @change_speed.nil?
    return if @change_speed == 0
    if (@target - @value).abs <= @change_speed.abs
      set_value(@target)
      @change_speed = nil
    else
      set_value(@value + @change_speed)
    end
  end

  # Set number tonality when low
  # value: number value
  # max: max parameter (hp/mp)
  def set_tone(value, max)
    if value == 0
      change_tone(:red)
    elsif value <= max / 5
      change_tone(:yellow)
    else
      change_tone(:normal)
    end
  end

  # Change tonality
  # type: symbol :normal, :red, :yellow
  def change_tone(type = :normal)
    tone = get_tone(type)
    @numbers.each { |num| num.tone = tone }
  end

  # Returns the proper tone
  # type: symbol :normal, :red, :yellow
  def get_tone(type)
    case type
    when :normal
      return Tone.new(0, 0, 0)
    when :red
      return Tone.new(0, -255, -255, 255)
    when :yellow
      return Tone.new(0, 0, -255, 255)
    else
      return Tone.new(0, 0, 0, 0)
    end
  end

  # Update process
  def update
    @numbers.each { |num| num.update }
    update_change
  end

  # Dispose
  def dispose
    @numbers.each { |num| num.dispose }
  end

  # Set viewport
  def viewport=(viewport)
    @numbers.each { |num| num.viewport = viewport }
  end
end

#==============================================================================
# ** States_Shower
#------------------------------------------------------------------------------
# contenitore delle icone degli stati alterati
# noinspection RubyInstanceVariableNamingConvention,RubyInstanceMethodNamingConvention
#==============================================================================
class States_Shower
  # parametri d'istanza pubblici
  attr_reader :width
  attr_reader :height
  attr_reader :x
  attr_reader :y
  attr_reader :visible
  # inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Game_Actor] actor
  def initialize(x, y, width, actor)
    @x = x
    @y = y
    @width = width
    @height = 24
    @actor = actor
    @states = {}
    @visible = true
    @states_id = []
    @viewport = nil
    refresh(actor.states)
  end

  # ottiene la larghezza della barra
  def width;
    @width;
  end

  # ottiene l'altezza della barra
  def height;
    @height;
  end

  # ottiene la coordinata x
  def x;
    @x;
  end

  # ottiene la coordinata y
  def y;
    @y;
  end

  # imposta la coordinata x
  def x=(value)
    dist = value - @x
    @x = value
    @states.each_value { |icon| icon.x += dist }
  end

  # imposta la coordinata y
  def y=(value)
    @y = value
    @states.each_value { |icon| icon.y = value }
  end

  # imposta la visibilità
  def visible=(value)
    @visible = value
    @states.each_value { |icon| icon.visible = value }
  end

  # la coordinata z
  def z
    return 0 if @states.empty?
    @states.values.collect { |st| st.z }.max
  end

  # imposta il viewport
  # @param [Viewport] viewport
  def viewport=(viewport)
    @viewport = viewport
    @states.each_value { |state| state.viewport = viewport }
  end

  # aggiunge uno stato
  # @param [RPG::State] state
  def add_state(state)
    state_icon = Sprite.new(@viewport)
    state_icon.bitmap = state_bitmap(state)
    state_icon.y = @y
    state_icon.x = right_side - 24
    state_icon.viewport = @viewport
    state_icon.z = 1
    @states[state.id] = state_icon
  end

  # restituisce la grafica dello stato
  # @param [Bitmap] state
  def state_bitmap(state)
    bitmap2 = Bitmap.new(24, 24)
    bitmap2.draw_icon(state.icon_index, 0, 0)
    bitmap2
  end

  # la coordinata del lato destro
  def right_side
    right = self.width + self.x
    @states.each_value do |state|
      right = state.x if state.x < right
    end
    right
  end

  # imposta gli stati
  # @param [Array<RPG::State>] states
  def set_states(states)
    if states_id(states) == @states_id
      check_removing_states(states)
    else
      @states_id = states_id(states)
      delete_all_states
      refresh(states)
      check_removing_states(states)
    end
  end

  # controlla gli stati che stanno scomparendo
  def check_removing_states(states)
    states.each { |state|
      next if state.hold_turn == 0
      next if @states[state.id].nil?
      next if actor.state_turns[state.id].nil?
      @states[state.id].pulse(50, 200, 5) if actor.state_turns[state.id] <= 1
    }
  end

  # restituisce l'eroe
  # @return [Game_Actor]
  def actor;
    @actor;
  end

  # restituisce gli ID degli stati dell'eroe
  # @param [Array<RPG::State>] states_array
  # @return [Array<Integer>]
  def states_id(states_array)
    states_array.collect { |st| st.id }
  end

  # cancella tutti gli stati
  def delete_all_states
    @states.each_value { |state| state.opacity = 0; state.dispose }
    @states.clear
  end

  # refresh
  def refresh(states)
    states.each do |state|
      next if state.priority < 2
      add_state(state)
    end
  end

  # eliminazione
  def dispose;
    @states.each_value { |state_icon| state_icon.dispose };
  end

  # aggiornamento
  def update
    if @states.size > 5
      update_scrolling
    end
    @states.each_value { |state_icon| state_icon.update }
  end

  # aggiorna il movimento
  def update_scrolling
    return unless @visible
    @states.each_value do |state_icon|
      state_icon.x += 1
      state_icon.change_size(0, 24, 1) if near_border?(state_icon)
      if out_of_border?(state_icon)
        state_icon.x = right_side - 24
        state_icon.width = 24
      end
    end
  end

  # determina se vicino al bordo
  def near_border?(sprite)
    sprite.x == self.x + self.width - 23
  end

  # determina se fuori dal bordo
  def out_of_border?(sprite)
    sprite.x > self.x + self.width
  end
end

#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party < Game_Unit
  # gli HP del componente con HP più alti
  def mhp
    battle_members.collect { |member| member.mhp }.max
  end

  # gli MP del componente con MP più alti
  def mmp
    battle_members.collect { |member| member.mmp }.max
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  alias h87hud_create_info_viewport create_info_viewport unless $@
  alias h87hud_terminate terminate unless $@
  alias h87hud_process_v process_victory unless $@
  alias h87hud_update_basic update_basic unless $@
  # alias for Viewport creation
  def create_info_viewport
    h87hud_create_info_viewport
    @hud_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @status_window.visible = false
    @status_window.dispose
    @status_window = Battle_Hud.new
    @status_window.viewport = @hud_viewport
  end

  # Terminate
  def terminate
    h87hud_terminate
    @hud_viewport.dispose
  end

  # Nascondo la barra alla vittoria
  def process_victory
    @status_window.visible = false
    h87hud_process_v
  end

  # aggiorna il viewport per lo smooth move
  def update_basic
    h87hud_update_basic
    @hud_viewport.update
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
# Public instance variables
#==============================================================================
class Game_Actor < Game_Battler
  # Get reading access
  attr_reader :state_turns
end

#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
# This class is used t
#==============================================================================
class Window_BattleStatus < Window_Selectable
  alias h87hud_index index unless $@
  # Override method: Refresh
  def refresh
    @battle_hud.refresh unless @battle_hud.nil?
  end

  # Assign the HUD object to refresh
  # hud: battle_hud
  def content_refresh=(hud)
    @battle_hud = hud
  end

  # Override method Visible
  # value: true/false
  def visible=(value)
    super(value)
    @battle_hud.visible = value if @battle_hud != nil
  end

  # Alias method index
  # value: selected index
  def index=(value)
    h87hud_index(value)
    @battle_hud.index = value if @battle_hud != nil
  end
end