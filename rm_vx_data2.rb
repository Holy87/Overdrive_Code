module CPanel
  #Modifica dei parametri
  TSWRate = 0.7 #moltiplicatore danno con due spade
  TWHIT = 3 #riduzione hit con due spade
  CHARGEDOMATTACK = 1 #carica della dominazione quando viene attaccata
  MPDIVISOR = 5 #divisore del danno HP in MP
  PROTECTRATE = 0.75 # moltiplicatore danno ad alleato se uno ha altruismo
  SAVE_VERSION = 4.0 # versione del salvataggio
  MAX_STORY = 57 #fine della storia per la variabile 72
  # Aggiusta il rate di guadagno nei combattimenti
  EXPRATE = 95 #rateo esperienza
  APDRATE = 100 #rateo PA
  GOLDRATE = 100 #rateo oro

  BOMB_SKILL = 549 #abilità bombifica
end

module Stati #stati negativi da copiare sul nemico
  Negativi = [2,3,4,5,6,78,13,14,15,16,28,78,79,80,87,93,94,95,112,113,115,130,
              131,132,133,134,135,136,137,287,288,289]
end

class Bitmap
  attr_reader :width
  attr_reader :height
  attr_accessor :font
  # @return[Font]
  def font; end
  def initialize(param1, param2 = nil);end
  def dispose;end
  def disposed?;end
  def blt(x, y, src_bitmap, src_rect, opacity = 255); end
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255); end
  def fill_rect(*args);end
  def gradient_fill_rect(*args);end
  #def gradient_fill_rect(rect, color1, color2, vertical = false);end
  def clear;end
  def clear_rect(*args);end
  #def clear_rect(rect);end
  def get_pixel(x, y);end
  def set_pixel(x, y, color);end
  def hue_change(hue);end+
  def blur;end
  def radial_blur(angle, division);end
  def draw_text(x, y, width, height, str, align = 0);end
  def text_size(str);end
end

class Color
  attr_accessor :red
  attr_accessor :green
  attr_accessor :blue
  attr_accessor :alpha
  def initialize(red, green, blue, alpha = 255);end
  def set(red, green, blue, alpha = 255);end
end

class Font
  attr_accessor :name
  attr_accessor :size
  attr_accessor :bold
  attr_accessor :italic
  attr_accessor :shadow
  attr_accessor :color
  attr_accessor :outline
  def initialize(name, size = 0);end
  def default_name;end
  def default_size;end
  def default_bold;end
  def default_italic;end
  def default_shadow;end
  def default_color;end
end

class Plane
  attr_accessor :bitmap
  attr_accessor :viewport
  attr_accessor :visible
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :opacity
  attr_accessor :blend_type
  attr_accessor :color
  attr_accessor :tone
  def initialize(viewport=nil);end
  def dispose;end
  def disposed?;end
end

class Rect
  attr_accessor :x, :y, :width, :height
  def initialize(x = 0,y = 0,width = 0,height = 0)
  end
  def set(x, y, width, height);end
end

class Sprite
  attr_accessor :bitmap
  attr_accessor :src_rect
  attr_accessor :visible
  attr_accessor :x
  attr_accessor :y
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :angle
  attr_accessor :wave_amp
  attr_accessor :wave_lenght
  attr_accessor :wave_speed
  attr_accessor :wave_phase
  attr_accessor :mirror
  attr_accessor :bush_depth
  attr_accessor :opacity
  attr_accessor :blend_type
  attr_accessor :color
  attr_accessor :tone
  def initialize(viewport=nil);end
  def dispose;end
  def disposed?;end
  def flash(color, duration);end
  def update; end
  def width; end
  def height; end
end

class Tone
  attr_accessor :red
  attr_accessor :green
  attr_accessor :blue
  attr_accessor :gray
  def initialize(red, green, blue, gray = 0);end
end

class Viewport
  attr_accessor :rect
  attr_accessor :visible
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :color
  attr_accessor :tone
  def initialize(x, y, width, height);end
  def dispose;end
  def disposed?;end
  def flash(color, duration);end
  def update;end
end

module Audio
  def self.bgm_play(filename, volume=100, pitch = 100);end
  def self.bgm_stop;end
  def self.bgm_fade(time);end
  def self.bgs_play(filename, volume = 100, pitch = 100);end
  def self.bgs_stop;end
  def self.bgs_fade(time);end
  def self.me_play(filename, volume = 100, pitch = 100);end
  def self.me_stop;end
  def self.me_fade(time);end
  def self.se_play(filename, volume = 100, pitch = 100);end
  def self.se_stop;end
end

module Graphics
  attr_accessor :frame_count
  attr_accessor :frame_rate
  attr_accessor :brightness
  @frame_rate = 60
  @frame_count = 0
  @brightness = 255
  def self.update;end
  def self.wait(duration);end
  def self.fadeout(duration);end
  def self.fadein(duration);end
  def self.freeze;end
  def self.transition(duration = 0, filename = "", vague = 0); end
  def self.snap_to_bitmap;end
  def self.frame_reset;end
  def self.width;end
  def self.height;end
  def self.resize_screen(width, height);end
end

module Input
  DOWN = 2
  LEFT = 4
  RIGHT = 6
  UP = 8
  SHIFT = 0
  CTRL = 0
  ALT = 0
  F5 = 0
  F6 = 0
  F7 = 0
  F8 = 0
  F9 = 0
  BACK = 0
  ENTER = 0
  ESC = 0
  SHIFT = 0
  def self.update;end
  def self.press?(num);end
  def self.trigger?(num);end
  def self.repeat?(num);end
  def self.dir4;end
  def self.dir8;end

  def self.typing?
    # code here
  end

  def self.key_type
    # code here
  end
end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab

  # Party
  def self.party
    return "Gruppo"
  end
  # Shop Screen
  ShopBuy         = "Compra"
  ShopSell        = "Vendi"
  ShopCancel      = "Cancella"
  Possession      = "Posseduti"

  # Status Screen
  ExpTotal        = "Esperienza"
  ExpNext         = "Per il prossimo %s"

  # Save/Load Screen
  SaveMessage     = "In quale file vuoi salvare?"
  LoadMessage     = "Quale salvataggio vuoi caricare?"
  File            = "File"

  # Display when there are multiple members
  PartyName       = "Il gruppo di %s"

  # Basic Battle Messages
  Emerge          = "Compare %s!"
  Preemptive      = "%s got the upper hand!"
  Surprise        = "%s was surprised!"
  EscapeStart     = "%s comincia a scappare..."
  EscapeFailure   = "...ma fallisce!"

  # Battle Ending Messages
  Victory         = "Hai vinto il combattimento!"
  Defeat          = "%s è stato sconfitto."
  ObtainExp       = "%s EXP ricevuti!"
  ObtainGold      = "%s%s ottenuti!"
  ObtainItem      = "%s trovato!"
  LevelUp         = "%s è ora al livello %s %s!"
  ObtainSkill     = "Ha imparato %s!"

  # Battle Actions
  DoAttack        = "%s attacca!"
  DoGuard         = "%s si difende."
  DoEscape        = "%s fugge."
  DoWait          = "%s sta aspettando."
  UseItem         = "%s usa %s!"

  # Critical Hit
  CriticalToEnemy = "An excellent hit!!"
  CriticalToActor = "A painful blow!!"

  # Results for Actions on Actors
  ActorDamage     = "%s took %s damage!"
  ActorLoss       = "%1$s lost %3$s %2$s!"
  ActorDrain      = "%1$s drained %3$s %2$s!"
  ActorNoDamage   = "%s took no damage!"
  ActorNoHit      = "Miss! %s took no damage!"
  ActorEvasion    = "%s evaded the attack!"
  ActorRecovery   = "%1$s recovered %3$s %2$s!"

  # Results for Actions on Enemies
  EnemyDamage     = "%s took %s damage!"
  EnemyLoss       = "%1$s lost %3$s %2$s!"
  EnemyDrain      = "%1$s drained %3$s %2$s!"
  EnemyNoDamage   = "%s took no damage!"
  EnemyNoHit      = "Miss! %s took no damage!"
  EnemyEvasion    = "%s evaded the attack!"
  EnemyRecovery   = "%1$s recovered %3$s %2$s!"

  # Non-physical skills or items failed
  ActionFailure   = "There was no effect on %s!"

  # Level
  def self.level
    return $data_system.terms.level
  end

  # Level (Abbreviation)
  def self.level_a
    return $data_system.terms.level_a
  end

  # HP
  def self.hp
    return $data_system.terms.hp
  end

  # HP (Abbreviation)
  def self.hp_a
    return $data_system.terms.hp_a
  end

  # MP
  def self.mp
    return $data_system.terms.mp
  end

  # MP (Abbreviation)
  def self.mp_a
    return $data_system.terms.mp_a
  end

  # Attack
  def self.atk
    return $data_system.terms.atk
  end

  # Defense
  def self.def
    return $data_system.terms.def
  end

  # Spirit
  def self.spi
    return $data_system.terms.spi
  end

  # Agility
  def self.agi
    return $data_system.terms.agi
  end

  # Weapon
  def self.weapon
    return $data_system.terms.weapon
  end

  # Shield
  def self.armor1
    return $data_system.terms.armor1
  end

  # Helmet
  def self.armor2
    return $data_system.terms.armor2
  end

  # Body Armor
  def self.armor3
    return $data_system.terms.armor3
  end

  # Accessory
  def self.armor4
    return $data_system.terms.armor4
  end

  # Weapon 1
  def self.weapon1
    return $data_system.terms.weapon1
  end

  # Weapon 2
  def self.weapon2
    return $data_system.terms.weapon2
  end

  # Attack
  def self.attack
    return $data_system.terms.attack
  end

  # Skill
  def self.skill
    return $data_system.terms.skill
  end

  # Guard
  def self.guard
    return $data_system.terms.guard
  end

  # Item
  def self.item
    return $data_system.terms.item
  end

  # Equip
  def self.equip
    return $data_system.terms.equip
  end

  # Status
  def self.status
    return $data_system.terms.status
  end

  # Save
  def self.save
    return $data_system.terms.save
  end

  # Game End
  def self.game_end
    return $data_system.terms.game_end
  end

  # Fight
  def self.fight
    return $data_system.terms.fight
  end

  # Escape
  def self.escape
    return $data_system.terms.escape
  end

  # New Game
  def self.new_game
    return $data_system.terms.new_game
  end

  # Continue
  def self.continue
    return $data_system.terms.continue
  end

  # Shutdown
  def self.shutdown
    return $data_system.terms.shutdown
  end

  # To Title
  def self.to_title
    return $data_system.terms.to_title
  end

  # Cancel
  def self.cancel
    return $data_system.terms.cancel
  end

  # G (Currency Unit)
  def self.gold
    return $data_system.terms.gold
  end

  def self.odds
    return "Odio"
  end

end

#==============================================================================
# ** Sound
#------------------------------------------------------------------------------
#  This module plays sound effects. It obtains sound effects specified in the
# database from the global variable $data_system, and plays them.
#==============================================================================

module Sound

  # System Sound Effect
  def self.play_system_sound(n)
    $data_system.sounds[n].play
  end

  # Cursor Movement
  def self.play_cursor
    play_system_sound(0)
  end

  # Decision
  def self.play_ok
    play_system_sound(1)
  end

  def self.play_decision; end

  # Cancel
  def self.play_cancel
    play_system_sound(2)
  end

  # Buzzer
  def self.play_buzzer
    play_system_sound(3)
  end

  # Equip
  def self.play_equip
    play_system_sound(4)
  end

  # Save
  def self.play_save
    play_system_sound(5)
  end

  # Load
  def self.play_load
    play_system_sound(6)
  end

  # Battle Start
  def self.play_battle_start
    play_system_sound(7)
  end

  # Escape
  def self.play_escape
    play_system_sound(8)
  end

  # Enemy Attack
  def self.play_enemy_attack
    play_system_sound(9)
  end

  # Enemy Damage
  def self.play_enemy_damage
    play_system_sound(10)
  end

  # Enemy Collapse
  def self.play_enemy_collapse
    play_system_sound(11)
  end

  # Boss Collapse 1
  def self.play_boss_collapse1
    play_system_sound(12)
  end

  # Boss Collapse 2
  def self.play_boss_collapse2
    play_system_sound(13)
  end

  # Actor Damage
  def self.play_actor_damage
    play_system_sound(14)
  end

  # Actor Collapse
  def self.play_actor_collapse
    play_system_sound(15)
  end

  # Recovery
  def self.play_recovery
    play_system_sound(16)
  end

  # Miss
  def self.play_miss
    play_system_sound(17)
  end

  # Evasion
  def self.play_evasion
    play_system_sound(18)
  end

  # Magic Evasion
  def self.play_magic_evasion
    play_system_sound(19)
  end

  # Magic Reflection
  def self.play_reflection
    play_system_sound(20)
  end

  # Shop
  def self.play_shop
    play_system_sound(21)
  end

  # Use Item
  def self.play_use_item
    play_system_sound(22)
  end

  # Use Skill
  def self.play_use_skill
    play_system_sound(23)
  end

end

module RPG
  class Actor
    def initialize
      @id = 0
      @name = ""
      @class_id = 1
      @initial_level = 1
      @exp_basis = 25
      @exp_inflation = 35
      @character_name = ''
      @character_index = 0
      @face_name = ""
      @face_index = 0
      @parameters = Table.new([6,100])
      for i in 1..99
        @parameters[0,i] = 400+i*50
        @parameters[1,i] = 80+i*10
        @parameters[2,i] = 15+i*5/4
        @parameters[3,i] = 15+i*5/4
        @parameters[4,i] = 20+i*5/2
        @parameters[5,i] = 20+i*5/2
      end
      @weapon_id = 0
      @armor1_id = 0
      @armor2_id = 0
      @armor3_id = 0
      @armor4_id = 0
      @two_swords_style = false
      @fix_equipment = false
      @auto_battle = false
      @super_guard = false
      @pharmacology = false
      @critical_bonus = false
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :class_id
    attr_accessor :initial_level
    attr_accessor :exp_basis
    attr_accessor :exp_inflation
    attr_accessor :character_name
    attr_accessor :character_index
    attr_accessor :face_name
    attr_accessor :face_index
    attr_accessor :parameters
    attr_accessor :weapon_id
    attr_accessor :armor1_id
    attr_accessor :armor2_id
    attr_accessor :armor3_id
    attr_accessor :armor4_id
    attr_accessor :two_swords_style
    attr_accessor :fix_equipment
    attr_accessor :auto_battle
    attr_accessor :super_guard
    attr_accessor :pharmacology
    attr_accessor :critical_bonus
  end

  class Class
    def initialize
      @id = 0
      @name = ""
      @position = 0
      @weapon_set = []
      @armor_set = []
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @learnings = []
      @skill_name_valid = false
      @skill_name = ""
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :position
    attr_accessor :weapon_set
    attr_accessor :armor_set
    attr_accessor :element_ranks
    attr_accessor :state_ranks
    attr_accessor :learnings
    attr_accessor :skill_name_valid
    attr_accessor :skill_name
  end

  class Class
    class Learning
      def initialize
        @level = 1
        @skill_id = 1
      end
      attr_accessor :level
      attr_accessor :skill_id
    end
  end
end

module RPG
  class BaseItem
    attr_accessor :id
    attr_accessor :name
    attr_accessor :icon_index
    attr_accessor :description
    attr_accessor :note
  end

  class UsableItem < BaseItem
    def initialize
      super
      @scope = 0
      @occasion = 0
      @speed = 0
      @animation_id = 0
      @common_event_id = 0
      @base_damage = 0
      @variance = 20
      @atk_f = 0
      @spi_f = 0
      @physical_attack = false
      @damage_to_mp = false
      @absorb_damage = false
      @ignore_defense = false
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    def for_opponent?
      return [1, 2, 3, 4, 5, 6].include?(@scope)
    end
    def for_friend?
      return [7, 8, 9, 10, 11].include?(@scope)
    end
    def for_dead_friend?
      return [9, 10].include?(@scope)
    end
    def for_user?
      return [11].include?(@scope)
    end
    def for_one?
      return [1, 3, 4, 7, 9, 11].include?(@scope)
    end
    def for_two?
      return [5].include?(@scope)
    end
    def for_three?
      return [6].include?(@scope)
    end
    def for_random?
      return [4, 5, 6].include?(@scope)
    end
    def for_all?
      return [2, 8, 10].include?(@scope)
    end
    def dual?
      return [3].include?(@scope)
    end
    def need_selection?
      return [1, 3, 7, 9].include?(@scope)
    end
    def battle_ok?
      return [0, 1].include?(@occasion)
    end
    def menu_ok?
      return [0, 2].include?(@occasion)
    end
    attr_accessor :scope
    attr_accessor :occasion
    attr_accessor :speed
    attr_accessor :animation_id
    attr_accessor :common_event_id
    attr_accessor :base_damage
    attr_accessor :variance
    attr_accessor :atk_f
    attr_accessor :spi_f
    attr_accessor :physical_attack
    attr_accessor :damage_to_mp
    attr_accessor :absorb_damage
    attr_accessor :ignore_defense
    attr_accessor :element_set
    attr_accessor :plus_state_set
    attr_accessor :minus_state_set
  end

  class Item < UsableItem
    def initialize
      @id = 0
      @name = ""
      @icon_index = 0
      @description = ""
      @note = ""
    end
  end

  class Skill < UsableItem
    def initialize
      super
      @scope = 1
      @mp_cost = 0
      @hit = 100
      @message1 = ""
      @message2 = ""
    end
    attr_accessor :mp_cost
    attr_accessor :hit
    attr_accessor :message1
    attr_accessor :message2
  end

end

#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  This module loads each of graphics, creates a Bitmap object, and retains it.
# To speed up load times and conserve memory, this module holds the created
# Bitmap object in the internal hash, allowing the program to return
# preexisting objects when the same bitmap is requested again.
#==============================================================================

module Cache
  #--------------------------------------------------------------------------
  # * Get Animation Graphic
  #     filename : Filename
  #     hue      : Hue change value
  #--------------------------------------------------------------------------
  def self.animation(filename, hue)
    load_bitmap("Graphics/Animations/", filename, hue)
  end
  #--------------------------------------------------------------------------
  # * Get Battler Graphic
  #     filename : Filename
  #     hue      : Hue change value
  #--------------------------------------------------------------------------
  def self.battler(filename, hue)
    load_bitmap("Graphics/Battlers/", filename, hue)
  end
  #--------------------------------------------------------------------------
  # * Get Character Graphic
  #     filename : Filename
  #--------------------------------------------------------------------------
  def self.character(filename)
    load_bitmap("Graphics/Characters/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Face Graphic
  #     filename : Filename
  #--------------------------------------------------------------------------
  def self.face(filename)
    load_bitmap("Graphics/Faces/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Parallax Background Graphic
  #     filename : Filename
  #--------------------------------------------------------------------------
  def self.parallax(filename)
    load_bitmap("Graphics/Parallaxes/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Picture Graphic
  #     filename : Filename
  #--------------------------------------------------------------------------
  def self.picture(filename)
    load_bitmap("Graphics/Pictures/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get System Graphic
  #     filename : Filename
  #--------------------------------------------------------------------------
  def self.system(filename)
    load_bitmap("Graphics/System/", filename)
  end
  #--------------------------------------------------------------------------
  # * Clear Cache
  #--------------------------------------------------------------------------
  def self.clear
    @cache = {} if @cache == nil
    @cache.clear
    GC.start
  end
  #--------------------------------------------------------------------------
  # * Load Bitmap
  #--------------------------------------------------------------------------
  def self.load_bitmap(folder_name, filename, hue = 0)
    @cache = {} if @cache == nil
    path = folder_name + filename
    if not @cache.include?(path) or @cache[path].disposed?
      if filename.empty?
        @cache[path] = Bitmap.new(32, 32)
      else
        @cache[path] = Bitmap.new(path)
      end
    end
    if hue == 0
      return @cache[path]
    else
      key = [path, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = @cache[path].clone
        @cache[key].hue_change(hue)
      end
      return @cache[key]
    end
  end
end


module RPG
  class UsableItem < BaseItem
    def initialize
      super
      @scope = 0
      @occasion = 0
      @speed = 0
      @animation_id = 0
      @common_event_id = 0
      @base_damage = 0
      @variance = 20
      @atk_f = 0
      @spi_f = 0
      @physical_attack = false
      @damage_to_mp = false
      @absorb_damage = false
      @ignore_defense = false
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    def for_opponent?
      return [1, 2, 3, 4, 5, 6].include?(@scope)
    end
    def for_friend?
      return [7, 8, 9, 10, 11].include?(@scope)
    end
    def for_dead_friend?
      return [9, 10].include?(@scope)
    end
    def for_user?
      return [11].include?(@scope)
    end
    def for_one?
      return [1, 3, 4, 7, 9, 11].include?(@scope)
    end
    def for_two?
      return [5].include?(@scope)
    end
    def for_three?
      return [6].include?(@scope)
    end
    def for_random?
      return [4, 5, 6].include?(@scope)
    end
    def for_all?
      return [2, 8, 10].include?(@scope)
    end
    def dual?
      return [3].include?(@scope)
    end
    def need_selection?
      return [1, 3, 7, 9].include?(@scope)
    end
    def battle_ok?
      return [0, 1].include?(@occasion)
    end
    def menu_ok?
      return [0, 2].include?(@occasion)
    end
    attr_accessor :scope
    attr_accessor :occasion
    attr_accessor :speed
    attr_accessor :animation_id
    attr_accessor :common_event_id
    attr_accessor :base_damage
    attr_accessor :variance
    attr_accessor :atk_f
    attr_accessor :spi_f
    attr_accessor :physical_attack
    attr_accessor :damage_to_mp
    attr_accessor :absorb_damage
    attr_accessor :ignore_defense
    attr_accessor :element_set
    attr_accessor :plus_state_set
    attr_accessor :minus_state_set
    attr_accessor :steal_prob_plus
  end
end

module RPG
  class Skill < UsableItem
    def initialize
      super
      @scope = 1
      @mp_cost = 0
      @hit = 100
      @message1 = ""
      @message2 = ""
    end
    attr_accessor :mp_cost
    attr_accessor :hit
    attr_accessor :message1
    attr_accessor :message2
  end
end

module RPG
  class Item < UsableItem
    def initialize
      super
      @scope = 7
      @price = 0
      @consumable = true
      @hp_recovery_rate = 0
      @hp_recovery = 0
      @mp_recovery_rate = 0
      @mp_recovery = 0
      @parameter_type = 0
      @parameter_points = 0
    end
    attr_accessor :price
    attr_accessor :consumable
    attr_accessor :hp_recovery_rate
    attr_accessor :hp_recovery
    attr_accessor :mp_recovery_rate
    attr_accessor :mp_recovery
    attr_accessor :parameter_type
    attr_accessor :parameter_points
  end
end

module RPG
  class Weapon < BaseItem
    def initialize
      super
      @animation_id = 0
      @price = 0
      @hit = 95
      @atk = 0
      @def = 0
      @spi = 0
      @agi = 0
      @two_handed = false
      @fast_attack = false
      @dual_attack = false
      @critical_bonus = false
      @element_set = []
      @state_set = []
      @element_rate_set = []
      @magic_states_plus = []
      @state_rate_per = {}
    end
    attr_accessor :animation_id
    attr_accessor :price
    attr_accessor :hit
    attr_accessor :atk
    attr_accessor :def
    attr_accessor :spi
    attr_accessor :agi
    attr_accessor :two_handed
    attr_accessor :fast_attack
    attr_accessor :dual_attack
    attr_accessor :critical_bonus
    attr_accessor :element_set
    attr_accessor :state_set
    attr_accessor :element_rate_set
    attr_reader :magic_states_plus
    attr_accessor :state_rate_per
  end
end

module RPG
  class Armor < BaseItem
    def initialize
      super
      @kind = 0
      @price = 0
      @eva = 0
      @atk = 0
      @def = 0
      @spi = 0
      @agi = 0
      @prevent_critical = false
      @half_mp_cost = false
      @double_exp_gain = false
      @auto_hp_recover = false
      @element_set = []
      @state_set = []
      @element_rate_set = []
      @magic_states_plus = []
      @state_rate_per = {}
    end
    attr_accessor :kind
    attr_accessor :price
    attr_accessor :eva
    attr_accessor :atk
    attr_accessor :def
    attr_accessor :spi
    attr_accessor :agi
    attr_accessor :prevent_critical
    attr_accessor :half_mp_cost
    attr_accessor :double_exp_gain
    attr_accessor :auto_hp_recover
    attr_accessor :element_set
    attr_accessor :state_set
    attr_accessor :element_rate_set
    attr_reader :magic_states_plus
    attr_accessor :state_rate_per
  end
end

module RPG
  class Enemy
    def initialize
      @id = 0
      @name = ""
      @battler_name = ""
      @battler_hue = 0
      @maxhp = 10
      @maxmp = 10
      @atk = 10
      @def = 10
      @spi = 10
      @agi = 10
      @hit = 95
      @eva = 5
      @exp = 0
      @gold = 0
      @drop_item1 = RPG::Enemy::DropItem.new
      @drop_item2 = RPG::Enemy::DropItem.new
      @levitate = false
      @has_critical = false
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @actions = [RPG::Enemy::Action.new]
      @note = ""
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :battler_name
    attr_accessor :battler_hue
    attr_accessor :maxhp
    attr_accessor :maxmp
    attr_accessor :atk
    attr_accessor :def
    attr_accessor :spi
    attr_accessor :agi
    attr_accessor :hit
    attr_accessor :eva
    attr_accessor :exp
    attr_accessor :gold
    attr_accessor :drop_item1
    attr_accessor :drop_item2
    attr_accessor :levitate
    attr_accessor :has_critical
    attr_accessor :element_ranks
    attr_accessor :state_ranks
    attr_accessor :actions
    attr_accessor :note
  end
end

module RPG
  class Enemy
    class DropItem
      def initialize
        @kind = 0
        @item_id = 1
        @weapon_id = 1
        @armor_id = 1
        @denominator = 1
      end
      attr_accessor :kind
      attr_accessor :item_id
      attr_accessor :weapon_id
      attr_accessor :armor_id
      attr_accessor :denominator
    end
  end
end

module RPG
  class Enemy
    class Action
      def initialize
        @kind = 0
        @basic = 0
        @skill_id = 1
        @condition_type = 0
        @condition_param1 = 0
        @condition_param2 = 0
        @rating = 5
      end
      def skill?
        return @kind == 1
      end
      attr_accessor :kind
      attr_accessor :basic
      attr_accessor :skill_id
      attr_accessor :condition_type
      attr_accessor :condition_param1
      attr_accessor :condition_param2
      attr_accessor :rating
    end
  end
end

module RPG
  class Troop
    def initialize
      @id = 0
      @name = ""
      @members = []
      @pages = [RPG::BattleEventPage.new]
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :members
    attr_accessor :pages
  end
end

module RPG
  class Troop
    class Member
      def initialize
        @enemy_id = 1
        @x = 0
        @y = 0
        @hidden = false
        @immortal = false
      end
      attr_accessor :enemy_id
      attr_accessor :x
      attr_accessor :y
      attr_accessor :hidden
      attr_accessor :immortal
    end
  end
end

module RPG
  class Troop
    class Page
      def initialize
        @condition = RPG::Troop::Page::Condition.new
        @span = 0
        @list = [RPG::EventCommand.new]
      end
      attr_accessor :condition
      attr_accessor :span
      attr_accessor :list
    end
  end
end

class RPG::Map
  def initialize(width, height)
    @display_name = ''
    @tileset_id = 1
    @width = width
    @height = height
    @scroll_type = 0
    @specify_battleback = false
    @battleback_floor_name = ''
    @battleback_wall_name = ''
    @autoplay_bgm = false
    @bgm = RPG::BGM.new
    @autoplay_bgs = false
    @bgs = RPG::BGS.new('', 80)
    @disable_dashing = false
    @encounter_list = []
    @encounter_step = 30
    @parallax_name = ''
    @parallax_loop_x = false
    @parallax_loop_y = false
    @parallax_sx = 0
    @parallax_sy = 0
    @parallax_show = false
    @note = ''
    @data = Table.new(width, height, 4)
    @events = {}
  end
  attr_accessor :display_name
  attr_accessor :tileset_id
  attr_accessor :width
  attr_accessor :height
  attr_accessor :scroll_type
  attr_accessor :specify_battleback
  attr_accessor :battleback1_name
  attr_accessor :battleback2_name
  attr_accessor :autoplay_bgm
  attr_accessor :bgm
  attr_accessor :autoplay_bgs
  attr_accessor :bgs
  attr_accessor :disable_dashing
  attr_accessor :encounter_list
  attr_accessor :encounter_step
  attr_accessor :parallax_name
  attr_accessor :parallax_loop_x
  attr_accessor :parallax_loop_y
  attr_accessor :parallax_sx
  attr_accessor :parallax_sy
  attr_accessor :parallax_show
  attr_accessor :note
  attr_accessor :data
  attr_accessor :events
end

class RPG::Map::Encounter
  def initialize
    @troop_id = 1
    @weight = 10
    @region_set = []
  end
  attr_accessor :troop_id
  attr_accessor :weight
  attr_accessor :region_set
end

class RPG::Event
  def initialize(x, y)
    @id = 0
    @name = ''
    @x = x
    @y = y
    @pages = [RPG::Event::Page.new]
  end
  attr_accessor :id
  attr_accessor :name
  attr_accessor :x
  attr_accessor :y
  attr_accessor :pages
end

class RPG::Event::Page
  def initialize
    @condition = RPG::Event::Page::Condition.new
    @graphic = RPG::Event::Page::Graphic.new
    @move_type = 0
    @move_speed = 3
    @move_frequency = 3
    @move_route = RPG::MoveRoute.new
    @walk_anime = true
    @step_anime = false
    @direction_fix = false
    @through = false
    @priority_type = 0
    @trigger = 0
    @list = [RPG::EventCommand.new]
  end
  attr_accessor :condition
  attr_accessor :graphic
  attr_accessor :move_type
  attr_accessor :move_speed
  attr_accessor :move_frequency
  attr_accessor :move_route
  attr_accessor :walk_anime
  attr_accessor :step_anime
  attr_accessor :direction_fix
  attr_accessor :through
  attr_accessor :priority_type
  attr_accessor :trigger
  attr_accessor :list
end

class RPG::EventCommand
  def initialize(code = 0, indent = 0, parameters = [])
    @code = code
    @indent = indent
    @parameters = parameters
  end
  attr_accessor :code
  attr_accessor :indent
  attr_accessor :parameters
end

class RPG::Event::Page::Condition
  def initialize
    @switch1_valid = false
    @switch2_valid = false
    @variable_valid = false
    @self_switch_valid = false
    @item_valid = false
    @actor_valid = false
    @switch1_id = 1
    @switch2_id = 1
    @variable_id = 1
    @variable_value = 0
    @self_switch_ch = 'A'
    @item_id = 1
    @actor_id = 1
  end
  attr_accessor :switch1_valid
  attr_accessor :switch2_valid
  attr_accessor :variable_valid
  attr_accessor :self_switch_valid
  attr_accessor :item_valid
  attr_accessor :actor_valid
  attr_accessor :switch1_id
  attr_accessor :switch2_id
  attr_accessor :variable_id
  attr_accessor :variable_value
  attr_accessor :self_switch_ch
  attr_accessor :item_id
  attr_accessor :actor_id
end

class RPG::Event::Page::Graphic
  def initialize
    @tile_id = 0
    @character_name = ''
    @character_index = 0
    @direction = 2
    @pattern = 0
  end
  attr_accessor :tile_id
  attr_accessor :character_name
  attr_accessor :character_index
  attr_accessor :direction
  attr_accessor :pattern
end

module RPG
  class State
    def initialize
      @id = 0
      @name = ""
      @icon_index = 0
      @restriction = 0
      @priority = 5
      @atk_rate = 100
      @def_rate = 100
      @spi_rate = 100
      @agi_rate = 100
      @nonresistance = false
      @offset_by_opposite = false
      @slip_damage = false
      @reduce_hit_ratio = false
      @battle_only = true
      @release_by_damage = false
      @hold_turn = 0
      @auto_release_prob = 0
      @message1 = ""
      @message2 = ""
      @message3 = ""
      @message4 = ""
      @element_set = []
      @state_set = []
      @note = ""
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :icon_index
    attr_accessor :restriction
    attr_accessor :priority
    attr_accessor :atk_rate
    attr_accessor :def_rate
    attr_accessor :spi_rate
    attr_accessor :agi_rate
    attr_accessor :nonresistance
    attr_accessor :offset_by_opposite
    attr_accessor :slip_damage
    attr_accessor :reduce_hit_ratio
    attr_accessor :battle_only
    attr_accessor :release_by_damage
    attr_accessor :hold_turn
    attr_accessor :auto_release_prob
    attr_accessor :message1
    attr_accessor :message2
    attr_accessor :message3
    attr_accessor :message4
    attr_accessor :element_set
    attr_accessor :state_set
    attr_accessor :note
  end
end

module RPG
  class AudioFile
    def initialize(name = "", volume = 100, pitch = 100)
      @name = name
      @volume = volume
      @pitch = pitch
    end
    attr_accessor :name
    attr_accessor :volume
    attr_accessor :pitch
  end
end

module RPG
  class BGM < AudioFile
    @@last = BGM.new
    def play
      if @name.empty?
        Audio.bgm_stop
        @@last = BGM.new
      else
        Audio.bgm_play("Audio/BGM/" + @name, @volume, @pitch)
        @@last = self
      end
    end
    def self.stop
      Audio.bgm_stop
      @@last = BGM.new
    end
    def self.fade(time)
      Audio.bgm_fade(time)
      @@last = BGM.new
    end
    def self.last
      @@last
    end
  end
end

module RPG
  class BGS < AudioFile
    @@last = BGS.new
    def play
      if @name.empty?
        Audio.bgs_stop
        @@last = BGS.new
      else
        Audio.bgs_play("Audio/BGS/" + @name, @volume, @pitch)
        @@last = self
      end
    end
    def self.stop
      Audio.bgs_stop
      @@last = BGS.new
    end
    def self.fade(time)
      Audio.bgs_fade(time)
      @@last = BGS.new
    end
    def self.last
      @@last
    end
  end
end

module RPG
  class ME < AudioFile
    def play
      if @name.empty?
        Audio.me_stop
      else
        Audio.me_play("Audio/ME/" + @name, @volume, @pitch)
      end
    end
    def self.stop
      Audio.me_stop
    end
    def self.fade(time)
      Audio.me_fade(time)
    end
  end
end

module RPG
  class SE < AudioFile
    def play
      unless @name.empty?
        Audio.se_play("Audio/SE/" + @name, @volume, @pitch)
      end
    end
    def self.stop
      Audio.se_stop
    end
  end
end

class Window
  def dispose; end
  def update; end
  # @return [Boolean]
  def disposed?; end
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  def move(x, y, width, height); end
  # @return [Boolean]
  def open?; end
  # @return [Boolean]
  def close?; end
  # @return [Bitmap]
  def windowskin; end
  # @return [Bitmap]
  def contents; end
  # @return [Rect]
  def cursor_rect; end
  # @return [Bitmap]
  def contents; end
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the
# global variables used by the game are initialized by this module.
#==============================================================================

module DataManager
  #--------------------------------------------------------------------------
  # * Module Instance Variables
  #--------------------------------------------------------------------------
  @last_savefile_index = 0                # most recently accessed file
  #--------------------------------------------------------------------------
  # * Initialize Module
  #--------------------------------------------------------------------------
  def self.init
    @last_savefile_index = 0
    load_database
    create_game_objects
    setup_battle_test if $BTEST
  end
  #--------------------------------------------------------------------------
  # * Load Database
  #--------------------------------------------------------------------------
  def self.load_database
    if $BTEST
      load_battle_test_database
    else
      load_normal_database
      check_player_location
    end
  end
  #--------------------------------------------------------------------------
  # * Load Normal Database
  #--------------------------------------------------------------------------
  def self.load_normal_database
  end
  #--------------------------------------------------------------------------
  # * Load Battle Test Database
  #--------------------------------------------------------------------------
  def self.load_battle_test_database
  end
  #--------------------------------------------------------------------------
  # * Check Player Start Location Existence
  #--------------------------------------------------------------------------
  def self.check_player_location
    if $data_system.start_map_id == 0
      msgbox(Vocab::PlayerPosError)
      exit
    end
  end
  #--------------------------------------------------------------------------
  # * Create Game Objects
  #--------------------------------------------------------------------------
  def self.create_game_objects
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_timer         = Game_Timer.new
    $game_message       = Game_Message.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
  end
  #--------------------------------------------------------------------------
  # * Set Up New Game
  #--------------------------------------------------------------------------
  def self.setup_new_game
    create_game_objects
    $game_party.setup_starting_members
    $game_map.setup($data_system.start_map_id)
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    Graphics.frame_count = 0
  end
  #--------------------------------------------------------------------------
  # * Set Up Battle Test
  #--------------------------------------------------------------------------
  def self.setup_battle_test
    $game_party.setup_battle_test
    BattleManager.setup($data_system.test_troop_id)
    BattleManager.play_battle_bgm
  end
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def self.save_file_exists?
    !Dir.glob('Save*.rvdata2').empty?
  end
  #--------------------------------------------------------------------------
  # * Maximum Number of Save Files
  #--------------------------------------------------------------------------
  def self.savefile_max
    return 35
  end
  #--------------------------------------------------------------------------
  # * Create Filename
  #     index : File Index
  #--------------------------------------------------------------------------
  def self.make_filename(index)
    sprintf("Salvataggio %02d.rvdata", index + 1)
  end
  #--------------------------------------------------------------------------
  # * Execute Save
  #--------------------------------------------------------------------------
  def self.save_game(index)
    #begin
    save_game_without_rescue(index)
    #rescue
    # delete_save_file(index)
    # false
    #end
  end
  #--------------------------------------------------------------------------
  # * Execute Load
  #--------------------------------------------------------------------------
  def self.load_game(index)
    load_game_without_rescue(index) #rescue false
  end
  #--------------------------------------------------------------------------
  # * Load Save Header
  #--------------------------------------------------------------------------
  def self.load_header(index)
    load_header_without_rescue(index) rescue nil
  end
  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  def self.save_game_without_rescue(index)
    File.open(make_filename(index), "wb") do |file|
      $game_system.on_before_save
      Marshal.dump(make_save_header, file)
      Marshal.dump(make_save_contents, file)
      @last_savefile_index = index
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Execute Load (No Exception Processing)
  #--------------------------------------------------------------------------
  def self.load_game_without_rescue(index)
    File.open(make_filename(index), "rb") do |file|
      Marshal.load(file)
      extract_save_contents(Marshal.load(file))
      reload_map_if_updated
      @last_savefile_index = index
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Load Save Header (No Exception Processing)
  #--------------------------------------------------------------------------
  def self.load_header_without_rescue(index)
    File.open(make_filename(index), "rb") do |file|
      return Marshal.load(file)
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Delete Save File
  #--------------------------------------------------------------------------
  def self.delete_save_file(index)
    File.delete(make_filename(index)) rescue nil
  end
  #--------------------------------------------------------------------------
  # * Create Save Header
  #--------------------------------------------------------------------------
  def self.make_save_header
    header = {}
    header[:characters] = $game_party.characters_for_savefile
    header[:playtime_s] = $game_system.playtime_s
    header
  end
  #--------------------------------------------------------------------------
  # * Create Save Contents
  #--------------------------------------------------------------------------
  def self.make_save_contents
    contents = {}
    contents[:system]        = $game_system
    contents[:timer]         = $game_timer
    contents[:message]       = $game_message
    contents[:switches]      = $game_switches
    contents[:variables]     = $game_variables
    contents[:self_switches] = $game_self_switches
    contents[:actors]        = $game_actors
    contents[:party]         = $game_party
    contents[:troop]         = $game_troop
    contents[:map]           = $game_map
    contents[:player]        = $game_player
    contents
  end
  #--------------------------------------------------------------------------
  # * Extract Save Contents
  #--------------------------------------------------------------------------
  def self.extract_save_contents(contents)
    $game_system        = contents[:system]
    $game_timer         = contents[:timer]
    $game_message       = contents[:message]
    $game_switches      = contents[:switches]
    $game_variables     = contents[:variables]
    $game_self_switches = contents[:self_switches]
    $game_actors        = contents[:actors]
    $game_party         = contents[:party]
    $game_troop         = contents[:troop]
    $game_map           = contents[:map]
    $game_player        = contents[:player]
  end
  #--------------------------------------------------------------------------
  # * Reload Map if Data Is Updated
  #--------------------------------------------------------------------------
  def self.reload_map_if_updated
    if $game_system.version_id != $data_system.version_id
      $game_map.setup($game_map.map_id)
      $game_player.center($game_player.x, $game_player.y)
      $game_player.make_encounter_count
    end
  end
  #--------------------------------------------------------------------------
  # * Get Update Date of Save File
  #--------------------------------------------------------------------------
  def self.savefile_time_stamp(index)
    File.mtime(make_filename(index)) rescue Time.at(0)
  end
  #--------------------------------------------------------------------------
  # * Get File Index with Latest Update Date
  #--------------------------------------------------------------------------
  #~   def self.latest_savefile_index
  #~     savefile_max.times.max_by {|i| savefile_time_stamp(i) }
  #~   end
  #--------------------------------------------------------------------------
  # * Get Index of File Most Recently Accessed
  #--------------------------------------------------------------------------
  def self.last_savefile_index
    @last_savefile_index
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a super class of all windows within the game.
#==============================================================================

class Window_Base < Window

  def openness=(value)
    @openness = value
  end
  # @return [Boolean]
  def visible=(va); end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  #
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system("Window")
    update_padding
    update_tone
    create_contents
    @opening = @closing = false
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    contents.dispose unless disposed?
    super
  end
  # @return [Integer]
  def padding; end
  #--------------------------------------------------------------------------
  # * Get Line Height
  #--------------------------------------------------------------------------
  # @return [Integer]
  def line_height
    return 24
  end
  #--------------------------------------------------------------------------
  # * Get Standard Padding Size
  #--------------------------------------------------------------------------
  # @return [Integer]
  def standard_padding
    return 12
  end
  #--------------------------------------------------------------------------
  # * Update Padding
  #--------------------------------------------------------------------------
  def update_padding
    self.padding = standard_padding
  end
  #--------------------------------------------------------------------------
  # * Calculate Width of Window Contents
  #--------------------------------------------------------------------------
  # @return [Integer]
  def contents_width
    width - standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  # @return [Integer]
  def contents_height
    height - standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Suited to Specified Number of Lines
  #--------------------------------------------------------------------------
  # @param [Integer] line_number
  def fitting_height(line_number)
    line_number * line_height + standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # * Update Tone
  #--------------------------------------------------------------------------
  def update_tone
    self.tone.set($game_system.window_tone)
  end
  #--------------------------------------------------------------------------
  # * Create Window Contents
  #--------------------------------------------------------------------------
  def create_contents
    contents.dispose
    if contents_width > 0 && contents_height > 0
      self.contents = Bitmap.new(contents_width, contents_height)
    else
      self.contents = Bitmap.new(1, 1)
    end
  end

  # @param [String] text
  # @return [Integer]
  def text_width(text); end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_tone
    update_open if @opening
    update_close if @closing
  end
  #--------------------------------------------------------------------------
  # * Update Open Processing
  #--------------------------------------------------------------------------
  def update_open
    self.openness += 48
    @opening = false if open?
  end
  #--------------------------------------------------------------------------
  # * Update Close Processing
  #--------------------------------------------------------------------------
  def update_close
    self.openness -= 48
    @closing = false if close?
  end
  #--------------------------------------------------------------------------
  # * Open Window
  #--------------------------------------------------------------------------
  def open
    @opening = true unless open?
    @closing = false
    self
  end
  #--------------------------------------------------------------------------
  # * Close Window
  #--------------------------------------------------------------------------
  def close
    @closing = true unless close?
    @opening = false
    self
  end
  #--------------------------------------------------------------------------
  # * Show Window
  #--------------------------------------------------------------------------
  def show
    self.visible = true
    self
  end
  #--------------------------------------------------------------------------
  # * Hide Window
  #--------------------------------------------------------------------------
  def hide
    self.visible = false
    self
  end
  #--------------------------------------------------------------------------
  # * Activate Window
  #--------------------------------------------------------------------------
  def activate
    self.active = true
    self
  end
  #--------------------------------------------------------------------------
  # * Deactivate Window
  #--------------------------------------------------------------------------
  def deactivate
    self.active = false
    self
  end
  #--------------------------------------------------------------------------
  # * Get Text Color
  #     n : Text color number (0..31)
  #--------------------------------------------------------------------------
  # @return [Color]
  def text_color(n)
    windowskin.get_pixel(64 + (n % 8) * 8, 96 + (n / 8) * 8)
  end
  #--------------------------------------------------------------------------
  # * Get Text Colors
  #--------------------------------------------------------------------------
  # @return [Color]
  def normal_color;      text_color(0);   end;    # Normal
  # @return [Color]
  def system_color;      text_color(16);  end;    # System
  # @return [Color]
  def crisis_color;      text_color(17);  end;    # Crisis
  # @return [Color]
  def knockout_color;    text_color(18);  end;    # Knock out
  # @return [Color]
  def gauge_back_color;  text_color(19);  end;    # Gauge background
  # @return [Color]
  def hp_gauge_color1;   text_color(20);  end;    # HP gauge 1
  # @return [Color]
  def hp_gauge_color2;   text_color(21);  end;    # HP gauge 2
  # @return [Color]
  def mp_gauge_color1;   text_color(22);  end;    # MP gauge 1
  # @return [Color]
  def mp_gauge_color2;   text_color(23);  end;    # MP gauge 2
  # @return [Color]
  def mp_cost_color;     text_color(23);  end;    # TP cost
  # @return [Color]
  def power_up_color;    text_color(24);  end;    # Equipment power up
  # @return [Color]
  def power_down_color;  text_color(25);  end;    # Equipment power down
  # @return [Color]
  def tp_gauge_color1;   text_color(28);  end;    # TP gauge 1
  # @return [Color]
  def tp_gauge_color2;   text_color(29);  end;    # TP gauge 2
  # @return [Color]
  def tp_cost_color;     text_color(29);  end;    # TP cost
  #--------------------------------------------------------------------------
  # * Get Background Color of Pending Item
  #--------------------------------------------------------------------------
  # @return [Color]
  def pending_color
    windowskin.get_pixel(80, 80)
  end
  #--------------------------------------------------------------------------
  # * Get Alpha Value of Translucent Drawing
  #--------------------------------------------------------------------------
  # @return [Integer]
  def translucent_alpha
    return 160
  end
  #--------------------------------------------------------------------------
  # * Change Text Drawing Color
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  # @param [Color] color
  # @param [Boolean] enabled
  def change_color(color, enabled = true)
    contents.font.color.set(color)
    contents.font.color.alpha = translucent_alpha unless enabled
  end
  #--------------------------------------------------------------------------
  # * Draw Text
  #     args : Same as Bitmap#draw_text.
  #--------------------------------------------------------------------------
  def draw_text(*args)
    contents.draw_text(*args)
  end
  #--------------------------------------------------------------------------
  # * Get Text Size
  #--------------------------------------------------------------------------
  # @return [Integer]
  def text_size(str)
    contents.text_size(str)
  end
  #--------------------------------------------------------------------------
  # * Draw Text with Control Characters
  #--------------------------------------------------------------------------
  def draw_text_ex(x, y, text)
    reset_font_settings
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
  #--------------------------------------------------------------------------
  # * Reset Font Settings
  #--------------------------------------------------------------------------
  def reset_font_settings
    change_color(normal_color)
    contents.font.size = Font.default_size
    contents.font.bold = Font.default_bold
    contents.font.italic = Font.default_italic
  end
  #--------------------------------------------------------------------------
  # * Preconvert Control Characters
  #    As a rule, replace only what will be changed into text strings before
  #    starting actual drawing. The character "\" is replaced with the escape
  #    character (\e).
  #--------------------------------------------------------------------------
  def convert_escape_characters(text)
    result = text.to_s.clone
    result.gsub!(/\\/)            { "\e" }
    result.gsub!(/\e\e/)          { "\\" }
    result.gsub!(/\eV\[(\d+)\]/i) { $game_variables[$1.to_i] }
    result.gsub!(/\eV\[(\d+)\]/i) { $game_variables[$1.to_i] }
    result.gsub!(/\eN\[(\d+)\]/i) { actor_name($1.to_i) }
    result.gsub!(/\eP\[(\d+)\]/i) { party_member_name($1.to_i) }
    result.gsub!(/\eG/i)          { Vocab::currency_unit }
    result
  end
  #--------------------------------------------------------------------------
  # * Draw State
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : draw spot width
  #--------------------------------------------------------------------------
  def draw_actor_state(actor, x, y, width = 96)
    count = 0
    for state in actor.states
      draw_icon(state.icon_index, x + 24 * count, y)
      count += 1
      break if (24 * count > width - 24)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw HP gauge
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : Width
  #--------------------------------------------------------------------------
  def draw_actor_hp_gauge(actor, x, y, width = 120)
    gw = width * actor.hp / actor.maxhp
    gc1 = hp_gauge_color1
    gc2 = hp_gauge_color2
    self.contents.fill_rect(x, y + WLH - 8, width, 6, gauge_back_color)
    self.contents.gradient_fill_rect(x, y + WLH - 8, gw, 6, gc1, gc2)
  end
  #--------------------------------------------------------------------------
  # * Draw MP Gauge
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : Width
  #--------------------------------------------------------------------------
  def draw_actor_mp_gauge(actor, x, y, width = 120)
    gw = width * actor.mp / [actor.maxmp, 1].max
    gc1 = mp_gauge_color1
    gc2 = mp_gauge_color2
    self.contents.fill_rect(x, y + WLH - 8, width, 6, gauge_back_color)
    self.contents.gradient_fill_rect(x, y + WLH - 8, gw, 6, gc1, gc2)
  end
  #--------------------------------------------------------------------------
  # * Get Name of Actor Number n
  #--------------------------------------------------------------------------
  def actor_name(n)
    actor = n >= 1 ? $game_actors[n] : nil
    actor ? actor.name : ""
  end
  #--------------------------------------------------------------------------
  # * Get Name of Party Member n
  #--------------------------------------------------------------------------
  def party_member_name(n)
    actor = n >= 1 ? $game_party.members[n - 1] : nil
    actor ? actor.name : ""
  end
  #--------------------------------------------------------------------------
  # * Character Processing
  #     c    : Characters
  #     text : A character string buffer in drawing processing (destructive)
  #     pos  : Draw position {:x, :y, :new_x, :height}
  #--------------------------------------------------------------------------
  def process_character(c, text, pos)
    case c
      when "\n"   # New line
        process_new_line(text, pos)
      when "\f"   # New page
        process_new_page(text, pos)
      when "\e"   # Control character
        process_escape_character(obtain_escape_code(text), text, pos)
      else        # Normal character
        process_normal_character(c, pos)
    end
  end
  #--------------------------------------------------------------------------
  # * Normal Character Processing
  #--------------------------------------------------------------------------
  def process_normal_character(c, pos)
    text_width = text_size(c).width
    draw_text(pos[:x], pos[:y], text_width * 2, pos[:height], c)
    pos[:x] += text_width
  end
  #--------------------------------------------------------------------------
  # * New Line Character Processing
  #--------------------------------------------------------------------------
  def process_new_line(text, pos)
    pos[:x] = pos[:new_x]
    pos[:y] += pos[:height]
    pos[:height] = calc_line_height(text)
  end
  #--------------------------------------------------------------------------
  # * New Page Character Processing
  #--------------------------------------------------------------------------
  def process_new_page(text, pos)
  end
  #--------------------------------------------------------------------------
  # * Destructively Get Control Code
  #--------------------------------------------------------------------------
  def obtain_escape_code(text)
    text.slice!(/^[\$\.\|\^!><\{\}\\]|^[A-Z]+/i)
  end
  #--------------------------------------------------------------------------
  # * Destructively Get Control Code Argument
  #--------------------------------------------------------------------------
  def obtain_escape_param(text)
    text.slice!(/^\[\d+\]/)[/\d+/].to_i rescue 0
  end
  #--------------------------------------------------------------------------
  # * Control Character Processing
  #     code : the core of the control character
  #            e.g. "C" in the case of the control character \C[1].
  #--------------------------------------------------------------------------
  def process_escape_character(code, text, pos)
    case code.upcase
      when 'C'
        change_color(text_color(obtain_escape_param(text)))
      when 'I'
        process_draw_icon(obtain_escape_param(text), pos)
      when '{'
        make_font_bigger
      when '}'
        make_font_smaller
    end
  end
  #--------------------------------------------------------------------------
  # * Icon Drawing Process by Control Characters
  #--------------------------------------------------------------------------
  def process_draw_icon(icon_index, pos)
    draw_icon(icon_index, pos[:x], pos[:y])
    pos[:x] += 24
  end
  #--------------------------------------------------------------------------
  # * Increase Font Size
  #--------------------------------------------------------------------------
  def make_font_bigger
    contents.font.size += 8 if contents.font.size <= 64
  end
  #--------------------------------------------------------------------------
  # * Decrease Font Size
  #--------------------------------------------------------------------------
  def make_font_smaller
    contents.font.size -= 8 if contents.font.size >= 16
  end
  #--------------------------------------------------------------------------
  # * Calculate Line Height
  #     restore_font_size : Return to original font size after calculating
  #--------------------------------------------------------------------------
  def calc_line_height(text, restore_font_size = true)
    result = [line_height, contents.font.size].max
    last_font_size = contents.font.size
    text.slice(/^.*$/).scan(/\e[\{\}]/).each do |esc|
      make_font_bigger  if esc == "\e{"
      make_font_smaller if esc == "\e}"
      result = [result, contents.font.size].max
    end
    contents.font.size = last_font_size if restore_font_size
    result
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side gradation
  #     color2 : Right side gradation
  #--------------------------------------------------------------------------
  def draw_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    contents.fill_rect(x, gauge_y, width, 6, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, 6, color1, color2)
  end
  #--------------------------------------------------------------------------
  # * Draw Icon
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y, enabled = true)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
  end
  #--------------------------------------------------------------------------
  # * Draw Face Graphic
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, x, y, enabled = true)
    bitmap = Cache.face(face_name)
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, 96, 96)
    contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Draw Character Graphic
  #--------------------------------------------------------------------------
  def draw_character(character_name, character_index, x, y)
    return unless character_name
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    n = character_index
    src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
    contents.blt(x - cw / 2, y - ch, bitmap, src_rect)
  end
  #--------------------------------------------------------------------------
  # * Get HP Text Color
  #--------------------------------------------------------------------------
  def hp_color(actor)
    return knockout_color if actor.hp == 0
    return crisis_color if actor.hp < actor.mhp / 4
    return normal_color
  end
  #--------------------------------------------------------------------------
  # * Get MP Text Color
  #--------------------------------------------------------------------------
  def mp_color(actor)
    return crisis_color if actor.mp < actor.mmp / 4
    return normal_color
  end
  #--------------------------------------------------------------------------
  # * Get TP Text Color
  #--------------------------------------------------------------------------
  def tp_color(actor)
    return normal_color
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Walking Graphic
  #--------------------------------------------------------------------------
  def draw_actor_graphic(actor, x, y)
    draw_character(actor.character_name, actor.character_index, x, y)
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Face Graphic
  #--------------------------------------------------------------------------
  def draw_actor_face(actor, x, y, enabled = true)
    draw_face(actor.face_name, actor.face_index, x, y, enabled)
  end
  #--------------------------------------------------------------------------
  # * Draw Name
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, x, y, width = 112)
    change_color(hp_color(actor))
    draw_text(x, y, width, line_height, actor.name)
  end
  #--------------------------------------------------------------------------
  # * Draw Class
  #--------------------------------------------------------------------------
  def draw_actor_class(actor, x, y, width = 112)
    change_color(normal_color)
    draw_text(x, y, width, line_height, actor.class.name)
  end
  #--------------------------------------------------------------------------
  # * Draw Nickname
  #--------------------------------------------------------------------------
  def draw_actor_nickname(actor, x, y, width = 180)
    change_color(normal_color)
    draw_text(x, y, width, line_height, actor.nickname)
  end
  #--------------------------------------------------------------------------
  # * Draw Level
  #--------------------------------------------------------------------------
  def draw_actor_level(actor, x, y)
    change_color(system_color)
    draw_text(x, y, 32, line_height, Vocab::level_a)
    change_color(normal_color)
    draw_text(x + 32, y, 24, line_height, actor.level, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw State and Buff/Debuff Icons
  #--------------------------------------------------------------------------
  def draw_actor_icons(actor, x, y, width = 96)
    icons = (actor.state_icons + actor.buff_icons)[0, width / 24]
    icons.each_with_index {|n, i| draw_icon(n, x + 24 * i, y) }
  end
  #--------------------------------------------------------------------------
  # * Draw Current Value/Maximum Value in Fractional Format
  #     current : Current value
  #     max     : Maximum value
  #     color1  : Color of current value
  #     color2  : Color of maximum value
  #--------------------------------------------------------------------------
  def draw_current_and_max_values(x, y, width, current, max, color1, color2)
    change_color(color1)
    xr = x + width
    if width < 96
      draw_text(xr - 40, y, 42, line_height, current, 2)
    else
      draw_text(xr - 92, y, 42, line_height, current, 2)
      change_color(color2)
      draw_text(xr - 52, y, 12, line_height, "/", 2)
      draw_text(xr - 42, y, 42, line_height, max, 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw HP
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, actor.hp, actor.mhp,
                                hp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # * Draw MP
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.mp_cost_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(x, y, width, actor.mp, actor.mmp,
                                mp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # * Draw TP
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(x + width - 42, y, 42, line_height, actor.tp.to_i, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    draw_actor_level(actor, x, y + line_height * 1)
    draw_actor_icons(actor, x, y + line_height * 2)
    draw_actor_class(actor, x + 120, y)
    draw_actor_hp(actor, x + 120, y + line_height * 1)
    draw_actor_mp(actor, x + 120, y + line_height * 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + 120, y, 36, line_height, actor.param(param_id), 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
  #--------------------------------------------------------------------------
  # * Draw Number (Gold Etc.) with Currency Unit
  #--------------------------------------------------------------------------
  def draw_currency_value(value, unit, x, y, width)
    cx = text_size(unit).width
    change_color(normal_color)
    draw_text(x, y, width - cx - 2, line_height, value, 2)
    change_color(system_color)
    draw_text(x, y, width, line_height, unit, 2)
  end
  #--------------------------------------------------------------------------
  # * Get Parameter Change Color
  #--------------------------------------------------------------------------
  def param_change_color(change)
    return power_up_color   if change > 0
    return power_down_color if change < 0
    return normal_color
  end
end

#==============================================================================
# ** Window_Help
#------------------------------------------------------------------------------
#  This window shows skill and item explanations along with actor status.
#==============================================================================

class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = 2)
    super(0, 0, Graphics.width, fitting_height(line_number))
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    set_text(item ? item.description : "")
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
  end
end

#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================

class Scene_Base
  #--------------------------------------------------------------------------
  # * Main
  #--------------------------------------------------------------------------
  def main
    start
    post_start
    update until scene_changing?
    pre_terminate
    terminate
  end
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    create_main_viewport
  end
  #--------------------------------------------------------------------------
  # * Post-Start Processing
  #--------------------------------------------------------------------------
  def post_start
    perform_transition
    Input.update
  end
  #--------------------------------------------------------------------------
  # * Determine if Scene Is Changing
  #--------------------------------------------------------------------------
  def scene_changing?
    SceneManager.scene != self
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_basic
  end
  #--------------------------------------------------------------------------
  # * Update Frame (Basic)
  #--------------------------------------------------------------------------
  def update_basic
    Graphics.update
    Input.update
    update_all_windows
  end
  #--------------------------------------------------------------------------
  # * Pre-Termination Processing
  #--------------------------------------------------------------------------
  def pre_terminate
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    Graphics.freeze
    dispose_all_windows
    dispose_main_viewport
  end
  #--------------------------------------------------------------------------
  # * Execute Transition
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(transition_speed)
  end
  #--------------------------------------------------------------------------
  # * Get Transition Speed
  #--------------------------------------------------------------------------
  def transition_speed
    return 10
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_main_viewport
    @viewport = Viewport.new
    @viewport.z = 200
  end
  #--------------------------------------------------------------------------
  # * Free Viewport
  #--------------------------------------------------------------------------
  def dispose_main_viewport
    @viewport.dispose
  end
  #--------------------------------------------------------------------------
  # * Update All Windows
  #--------------------------------------------------------------------------
  def update_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Window)
    end
  end
  #--------------------------------------------------------------------------
  # * Free All Windows
  #--------------------------------------------------------------------------
  def dispose_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Window)
    end
  end
  #--------------------------------------------------------------------------
  # * Return to Calling Scene
  #--------------------------------------------------------------------------
  def return_scene
    SceneManager.return
  end
  #--------------------------------------------------------------------------
  # * Fade Out All Sounds and Graphics
  #--------------------------------------------------------------------------
  def fadeout_all(time = 1000)
    RPG::BGM.fade(time)
    RPG::BGS.fade(time)
    RPG::ME.fade(time)
    Graphics.fadeout(time * Graphics.frame_rate / 1000)
    RPG::BGM.stop
    RPG::BGS.stop
    RPG::ME.stop
  end
  #--------------------------------------------------------------------------
  # * Determine if Game Is Over
  #   Transition to the game over screen if the entire party is dead.
  #--------------------------------------------------------------------------
  def check_gameover
    SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
  end
end

#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================

module SceneManager
  #--------------------------------------------------------------------------
  # * Module Instance Variables
  #--------------------------------------------------------------------------
  @scene = nil                            # current scene object
  @stack = []                             # stack for hierarchical transitions
  @background_bitmap = nil                # background bitmap
  #--------------------------------------------------------------------------
  # * Execute
  #--------------------------------------------------------------------------
  def self.run
    DataManager.init
    Audio.setup_midi if use_midi?
    @scene = first_scene_class.new
    @scene.main while @scene
  end
  #--------------------------------------------------------------------------
  # * Get First Scene Class
  # @return [Scene_Base]
  #--------------------------------------------------------------------------
  def self.first_scene_class
    $BTEST ? Scene_Battle : Scene_Title
  end
  #--------------------------------------------------------------------------
  # * Use MIDI?
  #--------------------------------------------------------------------------
  def self.use_midi?
    $data_system.opt_use_midi
  end
  #--------------------------------------------------------------------------
  # * Get Current Scene
  # @return [Scene_Base]
  #--------------------------------------------------------------------------
  def self.scene
    @scene
  end
  #--------------------------------------------------------------------------
  # * Determine Current Scene Class
  #--------------------------------------------------------------------------
  def self.scene_is?(scene_class)
    @scene.instance_of?(scene_class)
  end
  #--------------------------------------------------------------------------
  # * Direct Transition
  #--------------------------------------------------------------------------
  def self.goto(scene_class)
    @scene = scene_class.new
  end
  #--------------------------------------------------------------------------
  # * Call
  #--------------------------------------------------------------------------
  def self.call(scene_class)
    @stack.push(@scene)
    @scene = scene_class.new
  end
  #--------------------------------------------------------------------------
  # * Return to Caller
  #--------------------------------------------------------------------------
  def self.return
    @scene = @stack.pop
  end
  #--------------------------------------------------------------------------
  # * Clear Call Stack
  #--------------------------------------------------------------------------
  def self.clear
    @stack.clear
  end
  #--------------------------------------------------------------------------
  # * Exit Game
  #--------------------------------------------------------------------------
  def self.exit
    @scene = nil
  end
  #--------------------------------------------------------------------------
  # * Create Snapshot to Use as Background
  #--------------------------------------------------------------------------
  def self.snapshot_for_background
    @background_bitmap.dispose if @background_bitmap
    @background_bitmap = Graphics.snap_to_bitmap
    @background_bitmap.blur
  end
  #--------------------------------------------------------------------------
  # * Get Background Bitmap
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def self.background_bitmap
    @background_bitmap
  end
end

class Scene_Map < Scene_Base
  def start
    super
    @spriteset = Spriteset_Map.new
  end
end

class Spriteset_Map
  def initialize
    @viewport = Viewport.new(0,0,0,0)
    @viewport2 = Viewport.new(0,0,0,0)
  end
end


#==============================================================================
# ** Scene_MenuBase
#------------------------------------------------------------------------------
#  This class performs basic processing related to the menu screen.
#==============================================================================

class Scene_MenuBase < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    @actor = $game_party.menu_actor
    create_background
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Switch to Next Actor
  #--------------------------------------------------------------------------
  def next_actor
    @actor = $game_party.menu_actor_next
    on_actor_change
  end
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor
  #--------------------------------------------------------------------------
  def prev_actor
    @actor = $game_party.menu_actor_prev
    on_actor_change
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
  end
end

#==============================================================================
# ** Window_Selectable
#------------------------------------------------------------------------------
#  This window class contains cursor movement and scroll functions.
#==============================================================================

class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :index                    # cursor position
  attr_reader   :help_window              # help window
  attr_accessor :cursor_fix               # fix cursor flag
  attr_accessor :cursor_all               # select all cursors flag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #-------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @index = -1
    @handler = {}
    @cursor_fix = false
    @cursor_all = false
    update_padding
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get Spacing for Items Arranged Side by Side
  # @return [Integer]
  #--------------------------------------------------------------------------
  def spacing
    return 32
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  # @return [Integer]
  def item_max
    return 0
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_width
    (width - standard_padding * 2 + spacing) / col_max - spacing
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_height
    line_height
  end
  #--------------------------------------------------------------------------
  # * Get Row Count
  # @return [Integer]
  #--------------------------------------------------------------------------
  def row_max
    [(item_max + col_max - 1) / col_max, 1].max
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  # @return [Integer]
  #--------------------------------------------------------------------------
  def contents_height
    [super - super % item_height, row_max * item_height].max
  end
  #--------------------------------------------------------------------------
  # * Update Padding
  #--------------------------------------------------------------------------
  def update_padding
    super
    update_padding_bottom
  end
  #--------------------------------------------------------------------------
  # * Update Bottom Padding
  #--------------------------------------------------------------------------
  def update_padding_bottom
    surplus = (height - standard_padding * 2) % item_height
    self.padding_bottom = padding + surplus
  end
  #--------------------------------------------------------------------------
  # * Set Height
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def height=(height)
    super
    update_padding
  end
  #--------------------------------------------------------------------------
  # * Change Active State
  # @param [Boolean] active
  #--------------------------------------------------------------------------
  def active=(active)
    super
    update_cursor
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Set Cursor Position
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update_cursor
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Select Item
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def select(index)
    self.index = index if index
  end
  #--------------------------------------------------------------------------
  # * Deselect Item
  #--------------------------------------------------------------------------
  def unselect
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Get Current Line
  # @return [Integer]
  #--------------------------------------------------------------------------
  def row
    index / col_max
  end
  #--------------------------------------------------------------------------
  # * Get Top Row
  # @return [Integer]
  #--------------------------------------------------------------------------
  def top_row
    oy / item_height
  end
  #--------------------------------------------------------------------------
  # * Set Top Row
  # @param [Integer] row
  #--------------------------------------------------------------------------
  def top_row=(row)
    row = 0 if row < 0
    row = row_max - 1 if row > row_max - 1
    self.oy = row * item_height
  end
  #--------------------------------------------------------------------------
  # * Get Number of Rows Displayable on 1 Page
  # @return [Integer]
  #--------------------------------------------------------------------------
  def page_row_max
    (height - padding - padding_bottom) / item_height
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items Displayable on 1 Page
  # @return [Integer]
  #--------------------------------------------------------------------------
  def page_item_max
    page_row_max * col_max
  end
  #--------------------------------------------------------------------------
  # * Determine Horizontal Selection
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def horizontal?
    page_row_max == 1
  end
  #--------------------------------------------------------------------------
  # * Get Bottom Row
  # @return [Integer]
  #--------------------------------------------------------------------------
  def bottom_row
    top_row + page_row_max - 1
  end
  #--------------------------------------------------------------------------
  # * Set Bottom Row
  # @param [Integer] row
  #--------------------------------------------------------------------------
  def bottom_row=(row)
    self.top_row = row - (page_row_max - 1)
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  # @param [Integer] index
  # @return [Rect]
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items (for Text)
  # @param [Integer] rect
  # @return [Rect]
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    rect
  end
  #--------------------------------------------------------------------------
  # * Set Help Window
  # @param [Window_Help] help_window
  #--------------------------------------------------------------------------
  def help_window=(help_window)
    @help_window = help_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Set Handler Corresponding to Operation
  #     method : Method set as a handler (Method object)
  # @param [Symbol] symbol
  # @param [Method] method
  #--------------------------------------------------------------------------
  def set_handler(symbol, method)
    @handler[symbol] = method
  end
  #--------------------------------------------------------------------------
  # * Check for Handler Existence
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def handle?(symbol)
    @handler.include?(symbol)
  end
  #--------------------------------------------------------------------------
  # * Call Handler
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    @handler[symbol].call if handle?(symbol)
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    active && open? && !@cursor_fix && !@cursor_all && item_max > 0
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if index < item_max - col_max || (wrap && col_max == 1)
      select((index + col_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if index >= col_max || (wrap && col_max == 1)
      select((index - col_max + item_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if col_max >= 2 && (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown
    if top_row + page_row_max < row_max
      self.top_row += page_row_max
      select([@index + page_item_max, item_max - 1].min)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup
    if top_row > 0
      self.top_row -= page_row_max
      select([@index - page_item_max, 0].max)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    process_cursor_move
    process_handling
  end
  #--------------------------------------------------------------------------
  # * Cursor Movement Processing
  #--------------------------------------------------------------------------
  def process_cursor_move
    return unless cursor_movable?
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:DOWN)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:UP)
    cursor_right(Input.trigger?(:RIGHT)) if Input.repeat?(:RIGHT)
    cursor_left (Input.trigger?(:LEFT))  if Input.repeat?(:LEFT)
    cursor_pagedown   if !handle?(:pagedown) && Input.trigger?(:R)
    cursor_pageup     if !handle?(:pageup)   && Input.trigger?(:L)
    Sound.play_cursor if @index != last_index
  end
  #--------------------------------------------------------------------------
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
    return process_pagedown if handle?(:pagedown) && Input.trigger?(:R)
    return process_pageup   if handle?(:pageup)   && Input.trigger?(:L)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of OK Processing
  #--------------------------------------------------------------------------
  def ok_enabled?
    handle?(:ok)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Cancel Processing
  #--------------------------------------------------------------------------
  def cancel_enabled?
    handle?(:cancel)
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    if current_item_enabled?
      Sound.play_ok
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Call OK Handler
  #--------------------------------------------------------------------------
  def call_ok_handler
    call_handler(:ok)
  end
  #--------------------------------------------------------------------------
  # * Processing When Cancel Button Is Pressed
  #--------------------------------------------------------------------------
  def process_cancel
    Sound.play_cancel
    Input.update
    deactivate
    call_cancel_handler
  end
  #--------------------------------------------------------------------------
  # * Call Cancel Handler
  #--------------------------------------------------------------------------
  def call_cancel_handler
    call_handler(:cancel)
  end
  #--------------------------------------------------------------------------
  # * Processing When L Button (Page Up) Is Pressed
  #--------------------------------------------------------------------------
  def process_pageup
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pageup)
  end
  #--------------------------------------------------------------------------
  # * Processing When R Button (Page Down) Is Pressed
  #--------------------------------------------------------------------------
  def process_pagedown
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pagedown)
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_row = row if row < top_row
    self.bottom_row = row if row > bottom_row
  end
  #--------------------------------------------------------------------------
  # * Call Help Window Update Method
  #--------------------------------------------------------------------------
  def call_update_help
    update_help if active && @help_window
  end
  #--------------------------------------------------------------------------
  # * Update Help Window
  #--------------------------------------------------------------------------
  def update_help
    @help_window.clear
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return true
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    item_max.times {|i| draw_item(i) }
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
  end
  #--------------------------------------------------------------------------
  # * Erase Item
  #--------------------------------------------------------------------------
  def clear_item(index)
    contents.clear_rect(item_rect(index))
  end
  #--------------------------------------------------------------------------
  # * Redraw Item
  #--------------------------------------------------------------------------
  def redraw_item(index)
    clear_item(index) if index >= 0
    draw_item(index)  if index >= 0
  end
  #--------------------------------------------------------------------------
  # * Redraw Selection Item
  #--------------------------------------------------------------------------
  def redraw_current_item
    redraw_item(@index)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
end

#==============================================================================
# ** Window_Command
#------------------------------------------------------------------------------
#  This window deals with general command choices.
#==============================================================================

class Window_Command < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width = window_width, height = window_height)
    clear_command_list
    make_command_list
    super(x, y, width, height)
    refresh
    select(0)
    activate
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @list.size
  end
  #--------------------------------------------------------------------------
  # * Clear Command List
  #--------------------------------------------------------------------------
  def clear_command_list
    @list = []
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
  end
  #--------------------------------------------------------------------------
  # * Add Command
  #     name    : Command name
  #     symbol  : Corresponding symbol
  #     enabled : Activation state flag
  #     ext     : Arbitrary extended data
  #--------------------------------------------------------------------------
  def add_command(name, symbol, enabled = true, ext = nil)
    @list.push({:name=>name, :symbol=>symbol, :enabled=>enabled, :ext=>ext})
  end
  #--------------------------------------------------------------------------
  # * Get Command Name
  #--------------------------------------------------------------------------
  def command_name(index)
    @list[index][:name]
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Command
  #--------------------------------------------------------------------------
  def command_enabled?(index)
    @list[index][:enabled]
  end
  #--------------------------------------------------------------------------
  # * Get Command Data of Selection Item
  #--------------------------------------------------------------------------
  def current_data
    index >= 0 ? @list[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    current_data ? current_data[:enabled] : false
  end
  #--------------------------------------------------------------------------
  # * Get Symbol of Selection Item
  #--------------------------------------------------------------------------
  def current_symbol
    current_data ? current_data[:symbol] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Extended Data of Selected Item
  #--------------------------------------------------------------------------
  def current_ext
    current_data ? current_data[:ext] : nil
  end
  #--------------------------------------------------------------------------
  # * Move Cursor to Command with Specified Symbol
  #--------------------------------------------------------------------------
  def select_symbol(symbol)
    @list.each_index {|i| select(i) if @list[i][:symbol] == symbol }
  end
  #--------------------------------------------------------------------------
  # * Move Cursor to Command with Specified Extended Data
  #--------------------------------------------------------------------------
  def select_ext(ext)
    @list.each_index {|i| select(i) if @list[i][:ext] == ext }
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color, command_enabled?(index))
    draw_text(item_rect_for_text(index), command_name(index), alignment)
  end
  #--------------------------------------------------------------------------
  # * Get Alignment
  #--------------------------------------------------------------------------
  def alignment
    return 0
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of OK Processing
  #--------------------------------------------------------------------------
  def ok_enabled?
    return true
  end
  #--------------------------------------------------------------------------
  # * Call OK Handler
  #--------------------------------------------------------------------------
  def call_ok_handler
    if handle?(current_symbol)
      call_handler(current_symbol)
    elsif handle?(:ok)
      super
    else
      activate
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    clear_command_list
    make_command_list
    create_contents
    super
  end
end

#==============================================================================
# ** Window_ItemList
#------------------------------------------------------------------------------
#  This window displays a list of party items on the item screen.
#==============================================================================

class Window_ItemList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Set Category
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Include in Item List?
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
      when :item
        item.is_a?(RPG::Item) && !item.key_item?
      when :weapon
        item.is_a?(RPG::Weapon)
      when :armor
        item.is_a?(RPG::Armor)
      when :key_item
        item.is_a?(RPG::Item) && item.key_item?
      else
        false
    end
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    $game_party.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.all_items.select {|item| include?(item) }
    @data.push(nil) if include?(nil)
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Number of Items
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    draw_text(rect, sprintf(":%2d", $game_party.item_number(item)), 2)
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end

#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs the title screen processing.
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    SceneManager.clear
    Graphics.freeze
    create_background
    create_foreground
    create_command_window
    play_title_music
  end
  #--------------------------------------------------------------------------
  # * Get Transition Speed
  #--------------------------------------------------------------------------
  def transition_speed
    return 20
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    SceneManager.snapshot_for_background
    dispose_background
    dispose_foreground
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @sprite1 = Sprite.new
    @sprite1.bitmap = Cache.title1($data_system.title1_name)
    @sprite2 = Sprite.new
    @sprite2.bitmap = Cache.title2($data_system.title2_name)
    center_sprite(@sprite1)
    center_sprite(@sprite2)
  end
  #--------------------------------------------------------------------------
  # * Create Foreground
  #--------------------------------------------------------------------------
  def create_foreground
    @foreground_sprite = Sprite.new
    @foreground_sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @foreground_sprite.z = 100
    draw_game_title if $data_system.opt_draw_title
  end
  #--------------------------------------------------------------------------
  # * Draw Game Title
  #--------------------------------------------------------------------------
  def draw_game_title
    @foreground_sprite.bitmap.font.size = 48
    rect = Rect.new(0, 0, Graphics.width, Graphics.height / 2)
    @foreground_sprite.bitmap.draw_text(rect, $data_system.game_title, 1)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @sprite1.bitmap.dispose
    @sprite1.dispose
    @sprite2.bitmap.dispose
    @sprite2.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Foreground
  #--------------------------------------------------------------------------
  def dispose_foreground
    @foreground_sprite.bitmap.dispose
    @foreground_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Move Sprite to Screen Center
  #--------------------------------------------------------------------------
  def center_sprite(sprite)
    sprite.ox = sprite.bitmap.width / 2
    sprite.oy = sprite.bitmap.height / 2
    sprite.x = Graphics.width / 2
    sprite.y = Graphics.height / 2
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_TitleCommand.new
    @command_window.set_handler(:new_game, method(:command_new_game))
    @command_window.set_handler(:continue, method(:command_continue))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
  end
  #--------------------------------------------------------------------------
  # * Close Command Window
  #--------------------------------------------------------------------------
  def close_command_window
    @command_window.close
    update until @command_window.close?
  end
  #--------------------------------------------------------------------------
  # * [New Game] Command
  #--------------------------------------------------------------------------
  def command_new_game
    DataManager.setup_new_game
    close_command_window
    fadeout_all
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * [Continue] Command
  #--------------------------------------------------------------------------
  def command_continue
    close_command_window
    SceneManager.call(Scene_Load)
  end
  #--------------------------------------------------------------------------
  # * [Shut Down] Command
  #--------------------------------------------------------------------------
  def command_shutdown
    close_command_window
    fadeout_all
    SceneManager.exit
  end
  #--------------------------------------------------------------------------
  # * Play Title Screen Music
  #--------------------------------------------------------------------------
  def play_title_music
    $data_system.title_bgm.play
    RPG::BGS.stop
    RPG::ME.stop
  end
end


#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  This class performs the item screen processing.
#==============================================================================

class Scene_Item < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_category_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_ItemList.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.item_window = @item_window
  end
  #--------------------------------------------------------------------------
  # * Category [OK]
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate
    @item_window.select_last
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    $game_party.last_item.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_item
  end
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    super
    @item_window.redraw_current_item
  end
end

#==============================================================================
# ** Game_Unit
#------------------------------------------------------------------------------
#  This class handles units. It's used as a superclass of the Game_Party and
# Game_Troop classes.
#==============================================================================

class Game_Unit
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
  end
  #--------------------------------------------------------------------------
  # * Get Members (redefine as a subclass)
  #--------------------------------------------------------------------------
  def members
    return []
  end
  #--------------------------------------------------------------------------
  # * Get Array of Living Members
  #--------------------------------------------------------------------------
  def existing_members
    result = []
    for battler in members
      next unless battler.exist?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Get array of Incapacitated Members
  #--------------------------------------------------------------------------
  def dead_members
    result = []
    for battler in members
      next unless battler.dead?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Clear all Members' Battle Actions
  #--------------------------------------------------------------------------
  def clear_actions
    for battler in members
      battler.action.clear
    end
  end
  #--------------------------------------------------------------------------
  # * Random Selection of Target
  #--------------------------------------------------------------------------
  def random_target
    roulette = []
    for member in existing_members
      member.odds.times do
        roulette.push(member)
      end
    end
    return roulette.size > 0 ? roulette[rand(roulette.size)] : nil
  end
  #--------------------------------------------------------------------------
  # * Random Selection of Target (incapacitated)
  #--------------------------------------------------------------------------
  def random_dead_target
    roulette = []
    for member in dead_members
      roulette.push(member)
    end
    return roulette.size > 0 ? roulette[rand(roulette.size)] : nil
  end
  #--------------------------------------------------------------------------
  # * Smooth Selection of Target
  #     index : Index
  #--------------------------------------------------------------------------
  def smooth_target(index)
    member = members[index]
    return member if member != nil and member.exist?
    return existing_members[0]
  end
  #--------------------------------------------------------------------------
  # * Smooth Selection of Target (incapacitated)
  #     index : Index
  #--------------------------------------------------------------------------
  def smooth_dead_target(index)
    member = members[index]
    return member if member != nil and member.dead?
    return dead_members[0]
  end


  # @return [Array<RPG::BaseItem>]
  def all_items
    
  end
  #--------------------------------------------------------------------------
  # * Calculate Average Agility
  #--------------------------------------------------------------------------
  def average_agi
    result = 0
    n = 0
    for member in members
      result += member.agi
      n += 1
    end
    result /= n if n > 0
    result = 1 if result == 0
    return result
  end
  #--------------------------------------------------------------------------
  # * Application of Slip Damage Effects
  #--------------------------------------------------------------------------
  def slip_damage_effect
    for member in members
      member.slip_damage_effect
    end
  end
end

#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass of the
# Game_Player and Game_Event classes.
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :id                       # ID
  attr_reader   :x                        # map x-coordinate (logical)
  attr_reader   :y                        # map y-coordinate (logical)
  attr_reader   :real_x                   # map x-coordinate (actual-x * 256)
  attr_reader   :real_y                   # map y-coordinate (actual-y * 256)
  attr_reader   :tile_id                  # tile ID (invalid if 0)
  attr_reader   :character_name           # character graphic filename
  attr_reader   :character_index          # character graphic index
  attr_reader   :opacity                  # opacity level
  attr_reader   :blend_type               # blending method
  attr_reader   :direction                # direction
  attr_reader   :pattern                  # pattern
  attr_reader   :move_route_forcing       # forced move route flag
  attr_reader   :priority_type            # priority type
  attr_reader   :through                  # pass-through
  attr_reader   :bush_depth               # bush depth
  attr_accessor :animation_id             # animation ID
  attr_accessor :balloon_id               # balloon icon ID
  attr_accessor :transparent              # transparency flag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @id = 0
    @x = 0
    @y = 0
    @real_x = 0
    @real_y = 0
    @tile_id = 0
    @character_name = ""
    @character_index = 0
    @opacity = 255
    @blend_type = 0
    @direction = 2
    @pattern = 1
    @move_route_forcing = false
    @priority_type = 1
    @through = false
    @bush_depth = 0
    @animation_id = 0
    @balloon_id = 0
    @transparent = false
    @original_direction = 2               # Original direction
    @original_pattern = 1                 # Original pattern
    @move_type = 0                        # Movement type
    @move_speed = 4                       # Movement speed
    @move_frequency = 6                   # Movement frequency
    @move_route = nil                     # Move route
    @move_route_index = 0                 # Move route index
    @original_move_route = nil            # Original move route
    @original_move_route_index = 0        # Original move route index
    @walk_anime = true                    # Walking animation
    @step_anime = false                   # Stepping animation
    @direction_fix = false                # Fixed direction
    @anime_count = 0                      # Animation count
    @stop_count = 0                       # Stop count
    @jump_count = 0                       # Jump count
    @jump_peak = 0                        # Jump peak count
    @wait_count = 0                       # Wait count
    @locked = false                       # Locked flag
    @prelock_direction = 0                # Direction before lock
    @move_failed = false                  # Movement failed flag
  end
  #--------------------------------------------------------------------------
  # * Determine if Moving
  #    Compare with logical coordinates.
  #--------------------------------------------------------------------------
  def moving?
    return (@real_x != @x * 256 or @real_y != @y * 256)
  end
  #--------------------------------------------------------------------------
  # * Determine if Jumping
  #--------------------------------------------------------------------------
  def jumping?
    return @jump_count > 0
  end
  #--------------------------------------------------------------------------
  # * Determine if Stopping
  #--------------------------------------------------------------------------
  def stopping?
    return (not (moving? or jumping?))
  end
  #--------------------------------------------------------------------------
  # * Determine if Dashing
  #--------------------------------------------------------------------------
  def dash?
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine if Debug Pass-through State
  #--------------------------------------------------------------------------
  def debug_through?
    return false
  end
  #--------------------------------------------------------------------------
  # * Straighten Position
  #--------------------------------------------------------------------------
  def straighten
    @pattern = 1 if @walk_anime or @step_anime
    @anime_count = 0
  end
  #--------------------------------------------------------------------------
  # * Force Move Route
  #     move_route : new move route
  #--------------------------------------------------------------------------
  def force_move_route(move_route)
    if @original_move_route == nil
      @original_move_route = @move_route
      @original_move_route_index = @move_route_index
    end
    @move_route = move_route
    @move_route_index = 0
    @move_route_forcing = true
    @prelock_direction = 0
    @wait_count = 0
    move_type_custom
  end
  #--------------------------------------------------------------------------
  # * Determine Coordinate Match
  #     x : x-coordinate
  #     y : y-coordinate
  #--------------------------------------------------------------------------
  def pos?(x, y)
    return (@x == x and @y == y)
  end
  #--------------------------------------------------------------------------
  # * Coordinate Match and "Passage OFF" Determination (nt = No Through)
  #     x : x-coordinate
  #     y : y-coordinate
  #--------------------------------------------------------------------------
  def pos_nt?(x, y)
    return (pos?(x, y) and not @through)
  end
  #--------------------------------------------------------------------------
  # * Determine if Passable
  #     x : x-coordinate
  #     y : y-coordinate
  #--------------------------------------------------------------------------
  def passable?(x, y)
    x = $game_map.round_x(x)                        # Horizontal loop adj.
    y = $game_map.round_y(y)                        # Vertical loop adj.
    return false unless $game_map.valid?(x, y)      # Outside map?
    return true if @through or debug_through?       # Through ON?
    return false unless map_passable?(x, y)         # Map Impassable?
    return false if collide_with_characters?(x, y)  # Collide with character?
    return true                                     # Passable
  end
  #--------------------------------------------------------------------------
  # * Determine if Map is Passable
  #     x : x-coordinate
  #     y : y-coordinate
  #    Gets whether the tile at the designated coordinates is passable.
  #--------------------------------------------------------------------------
  def map_passable?(x, y)
    return $game_map.passable?(x, y)
  end
  #--------------------------------------------------------------------------
  # * Determine Character Collision
  #     x : x-coordinate
  #     y : y-coordinate
  #    Detects normal character collision, including the player and vehicles.
  #--------------------------------------------------------------------------
  def collide_with_characters?(x, y)
    for event in $game_map.events_xy(x, y)          # Matches event position
      unless event.through                          # Passage OFF?
        return true if self.is_a?(Game_Event)       # Self is event
        return true if event.priority_type == 1     # Target is normal char
      end
    end
    if @priority_type == 1                          # Self is normal char
      return true if $game_player.pos_nt?(x, y)     # Matches player position
      return true if $game_map.boat.pos_nt?(x, y)   # Matches boat position
      return true if $game_map.ship.pos_nt?(x, y)   # Matches ship position
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Lock (process for stopping event in progress)
  #--------------------------------------------------------------------------
  def lock
    unless @locked
      @prelock_direction = @direction
      turn_toward_player
      @locked = true
    end
  end
  #--------------------------------------------------------------------------
  # * Unlock
  #--------------------------------------------------------------------------
  def unlock
    if @locked
      @locked = false
      set_direction(@prelock_direction)
    end
  end
  #--------------------------------------------------------------------------
  # * Move to Designated Position
  #     x : x-coordinate
  #     y : y-coordinate
  #--------------------------------------------------------------------------
  def moveto(x, y)
    @x = x % $game_map.width
    @y = y % $game_map.height
    @real_x = @x * 256
    @real_y = @y * 256
    @prelock_direction = 0
    straighten
    update_bush_depth
  end
  #--------------------------------------------------------------------------
  # * Change Direction to Designated Direction
  #     direction : Direction
  #--------------------------------------------------------------------------
  def set_direction(direction)
    if not @direction_fix and direction != 0
      @direction = direction
      @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Object Type
  #--------------------------------------------------------------------------
  def object?
    return (@tile_id > 0 or @character_name[0, 1] == '!')
  end
  #--------------------------------------------------------------------------
  # * Get Screen X-Coordinates
  #--------------------------------------------------------------------------
  def screen_x
    return ($game_map.adjust_x(@real_x) + 8007) / 8 - 1000 + 16
  end
  #--------------------------------------------------------------------------
  # * Get Screen Y-Coordinates
  #--------------------------------------------------------------------------
  def screen_y
    y = ($game_map.adjust_y(@real_y) + 8007) / 8 - 1000 + 32
    y -= 4 unless object?
    if @jump_count >= @jump_peak
      n = @jump_count - @jump_peak
    else
      n = @jump_peak - @jump_count
    end
    return y - (@jump_peak * @jump_peak - n * n) / 2
  end
  #--------------------------------------------------------------------------
  # * Get Screen Z-Coordinates
  #--------------------------------------------------------------------------
  def screen_z
    if @priority_type == 2
      return 200
    elsif @priority_type == 0
      return 60
    elsif @tile_id > 0
      pass = $game_map.passages[@tile_id]
      if pass & 0x10 == 0x10    # [☆]
        return 160
      else
        return 40
      end
    else
      return 100
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if jumping?                 # Jumping
      update_jump
    elsif moving?               # Moving
      update_move
    else                        # Stopped
      update_stop
    end
    if @wait_count > 0          # Waiting
      @wait_count -= 1
    elsif @move_route_forcing   # Forced move route
      move_type_custom
    elsif not @locked           # Not locked
      update_self_movement
    end
    update_animation
  end
  #--------------------------------------------------------------------------
  # * Update While Jumping
  #--------------------------------------------------------------------------
  def update_jump
    @jump_count -= 1
    @real_x = (@real_x * @jump_count + @x * 256) / (@jump_count + 1)
    @real_y = (@real_y * @jump_count + @y * 256) / (@jump_count + 1)
    update_bush_depth
  end
  #--------------------------------------------------------------------------
  # * Update While Moving
  #--------------------------------------------------------------------------
  def update_move
    distance = 2 ** @move_speed   # Convert to movement distance
    distance *= 2 if dash?        # If dashing, double it
    @real_x = [@real_x - distance, @x * 256].max if @x * 256 < @real_x
    @real_x = [@real_x + distance, @x * 256].min if @x * 256 > @real_x
    @real_y = [@real_y - distance, @y * 256].max if @y * 256 < @real_y
    @real_y = [@real_y + distance, @y * 256].min if @y * 256 > @real_y
    update_bush_depth unless moving?
    if @walk_anime
      @anime_count += 1.5
    elsif @step_anime
      @anime_count += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Update While Stopped
  #--------------------------------------------------------------------------
  def update_stop
    if @step_anime
      @anime_count += 1
    elsif @pattern != @original_pattern
      @anime_count += 1.5
    end
    @stop_count += 1 unless @locked
  end
  #--------------------------------------------------------------------------
  # * Update During Self movement
  #--------------------------------------------------------------------------
  def update_self_movement
    if @stop_count > 30 * (5 - @move_frequency)
      case @move_type
        when 1;  move_type_random
        when 2;  move_type_toward_player
        when 3;  move_type_custom
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Animation Count
  #--------------------------------------------------------------------------
  def update_animation
    speed = @move_speed + (dash? ? 1 : 0)
    if @anime_count > 18 - speed * 2
      if not @step_anime and @stop_count > 0
        @pattern = @original_pattern
      else
        @pattern = (@pattern + 1) % 4
      end
      @anime_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Update Bush Depth
  #--------------------------------------------------------------------------
  def update_bush_depth
    if object? or @priority_type != 1 or @jump_count > 0
      @bush_depth = 0
    else
      bush = $game_map.bush?(@x, @y)
      if bush and not moving?
        @bush_depth = 8
      elsif not bush
        @bush_depth = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move Type : Random
  #--------------------------------------------------------------------------
  def move_type_random
    case rand(6)
      when 0..1;  move_random
      when 2..4;  move_forward
      when 5;     @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Move Type : Approach
  #--------------------------------------------------------------------------
  def move_type_toward_player
    sx = @x - $game_player.x
    sy = @y - $game_player.y
    if sx.abs + sy.abs >= 20
      move_random
    else
      case rand(6)
        when 0..3;  move_toward_player
        when 4;     move_random
        when 5;     move_forward
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move Type : Custom
  #--------------------------------------------------------------------------
  def move_type_custom
    if stopping?
      command = @move_route.list[@move_route_index]   # Get movement command
      @move_failed = false
      if command.code == 0                            # End of list
        if @move_route.repeat                         # [Repeat Action]
          @move_route_index = 0
        elsif @move_route_forcing                     # Forced move route
          @move_route_forcing = false                 # Cancel forcing
          @move_route = @original_move_route          # Restore original
          @move_route_index = @original_move_route_index
          @original_move_route = nil
        end
      else
        case command.code
          when 1    # Move Down
            move_down
          when 2    # Move Left
            move_left
          when 3    # Move Right
            move_right
          when 4    # Move Up
            move_up
          when 5    # Move Lower Left
            move_lower_left
          when 6    # Move Lower Right
            move_lower_right
          when 7    # Move Upper Left
            move_upper_left
          when 8    # Move Upper Right
            move_upper_right
          when 9    # Move at Random
            move_random
          when 10   # Move toward Player
            move_toward_player
          when 11   # Move away from Player
            move_away_from_player
          when 12   # 1 Step Forward
            move_forward
          when 13   # 1 Step Backwards
            move_backward
          when 14   # Jump
            jump(command.parameters[0], command.parameters[1])
          when 15   # Wait
            @wait_count = command.parameters[0] - 1
          when 16   # Turn Down
            turn_down
          when 17   # Turn Left
            turn_left
          when 18   # Turn Right
            turn_right
          when 19   # Turn Up
            turn_up
          when 20   # Turn 90° Right
            turn_right_90
          when 21   # Turn 90° Left
            turn_left_90
          when 22   # Turn 180°
            turn_180
          when 23   # Turn 90° Right or Left
            turn_right_or_left_90
          when 24   # Turn at Random
            turn_random
          when 25   # Turn toward Player
            turn_toward_player
          when 26   # Turn away from Player
            turn_away_from_player
          when 27   # Switch ON
            $game_switches[command.parameters[0]] = true
            $game_map.need_refresh = true
          when 28   # Switch OFF
            $game_switches[command.parameters[0]] = false
            $game_map.need_refresh = true
          when 29   # Change Speed
            @move_speed = command.parameters[0]
          when 30   # Change Frequency
            @move_frequency = command.parameters[0]
          when 31   # Walking Animation ON
            @walk_anime = true
          when 32   # Walking Animation OFF
            @walk_anime = false
          when 33   # Stepping Animation ON
            @step_anime = true
          when 34   # Stepping Animation OFF
            @step_anime = false
          when 35   # Direction Fix ON
            @direction_fix = true
          when 36   # Direction Fix OFF
            @direction_fix = false
          when 37   # Through ON
            @through = true
          when 38   # Through OFF
            @through = false
          when 39   # Transparent ON
            @transparent = true
          when 40   # Transparent OFF
            @transparent = false
          when 41   # Change Graphic
            set_graphic(command.parameters[0], command.parameters[1])
          when 42   # Change Opacity
            @opacity = command.parameters[0]
          when 43   # Change Blending
            @blend_type = command.parameters[0]
          when 44   # Play SE
            command.parameters[0].play
          when 45   # Script
            eval(command.parameters[0])
        end
        if not @move_route.skippable and @move_failed
          return  # [Skip if Cannot Move] OFF & movement failure
        end
        @move_route_index += 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    @stop_count = 0
    update_bush_depth
  end
  #--------------------------------------------------------------------------
  # * Calculate X Distance From Player
  #--------------------------------------------------------------------------
  def distance_x_from_player
    sx = @x - $game_player.x
    if $game_map.loop_horizontal?         # When looping horizontally
      if sx.abs > $game_map.width / 2     # Larger than half the map width?
        sx -= $game_map.width             # Subtract map width
      end
    end
    return sx
  end
  #--------------------------------------------------------------------------
  # * Calculate Y Distance From Player
  #--------------------------------------------------------------------------
  def distance_y_from_player
    sy = @y - $game_player.y
    if $game_map.loop_vertical?           # When looping vertically
      if sy.abs > $game_map.height / 2    # Larger than half the map height?
        sy -= $game_map.height            # Subtract map height
      end
    end
    return sy
  end
  #--------------------------------------------------------------------------
  # * Move Down
  #     turn_ok : Allows change of direction on the spot
  #--------------------------------------------------------------------------
  def move_down(turn_ok = true)
    if passable?(@x, @y+1)                  # Passable
      turn_down
      @y = $game_map.round_y(@y+1)
      @real_y = (@y-1)*256
      increase_steps
      @move_failed = false
    else                                    # Impassable
      turn_down if turn_ok
      check_event_trigger_touch(@x, @y+1)   # Touch event is triggered?
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Move Left
  #     turn_ok : Allows change of direction on the spot
  #--------------------------------------------------------------------------
  def move_left(turn_ok = true)
    if passable?(@x-1, @y)                  # Passable
      turn_left
      @x = $game_map.round_x(@x-1)
      @real_x = (@x+1)*256
      increase_steps
      @move_failed = false
    else                                    # Impassable
      turn_left if turn_ok
      check_event_trigger_touch(@x-1, @y)   # Touch event is triggered?
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Move Right
  #     turn_ok : Allows change of direction on the spot
  #--------------------------------------------------------------------------
  def move_right(turn_ok = true)
    if passable?(@x+1, @y)                  # Passable
      turn_right
      @x = $game_map.round_x(@x+1)
      @real_x = (@x-1)*256
      increase_steps
      @move_failed = false
    else                                    # Impassable
      turn_right if turn_ok
      check_event_trigger_touch(@x+1, @y)   # Touch event is triggered?
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Move up
  #     turn_ok : Allows change of direction on the spot
  #--------------------------------------------------------------------------
  def move_up(turn_ok = true)
    if passable?(@x, @y-1)                  # Passable
      turn_up
      @y = $game_map.round_y(@y-1)
      @real_y = (@y+1)*256
      increase_steps
      @move_failed = false
    else                                    # Impassable
      turn_up if turn_ok
      check_event_trigger_touch(@x, @y-1)   # Touch event is triggered?
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Move Lower Left
  #--------------------------------------------------------------------------
  def move_lower_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 8 ? 2 : @direction)
    end
    if (passable?(@x, @y+1) and passable?(@x-1, @y+1)) or
        (passable?(@x-1, @y) and passable?(@x-1, @y+1))
      @x -= 1
      @y += 1
      increase_steps
      @move_failed = false
    else
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Move Lower Right
  #--------------------------------------------------------------------------
  def move_lower_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 8 ? 2 : @direction)
    end
    if (passable?(@x, @y+1) and passable?(@x+1, @y+1)) or
        (passable?(@x+1, @y) and passable?(@x+1, @y+1))
      @x += 1
      @y += 1
      increase_steps
      @move_failed = false
    else
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Move Upper Left
  #--------------------------------------------------------------------------
  def move_upper_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 2 ? 8 : @direction)
    end
    if (passable?(@x, @y-1) and passable?(@x-1, @y-1)) or
        (passable?(@x-1, @y) and passable?(@x-1, @y-1))
      @x -= 1
      @y -= 1
      increase_steps
      @move_failed = false
    else
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Move Upper Right
  #--------------------------------------------------------------------------
  def move_upper_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 2 ? 8 : @direction)
    end
    if (passable?(@x, @y-1) and passable?(@x+1, @y-1)) or
        (passable?(@x+1, @y) and passable?(@x+1, @y-1))
      @x += 1
      @y -= 1
      increase_steps
      @move_failed = false
    else
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # * Move at Random
  #--------------------------------------------------------------------------
  def move_random
    case rand(4)
      when 0;  move_down(false)
      when 1;  move_left(false)
      when 2;  move_right(false)
      when 3;  move_up(false)
    end
  end
  #--------------------------------------------------------------------------
  # * Move toward Player
  #--------------------------------------------------------------------------
  def move_toward_player
    sx = distance_x_from_player
    sy = distance_y_from_player
    if sx != 0 or sy != 0
      if sx.abs > sy.abs                  # Horizontal distance is longer
        sx > 0 ? move_left : move_right   # Prioritize left-right
        if @move_failed and sy != 0
          sy > 0 ? move_up : move_down
        end
      else                                # Vertical distance is longer
        sy > 0 ? move_up : move_down      # Prioritize up-down
        if @move_failed and sx != 0
          sx > 0 ? move_left : move_right
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move away from Player
  #--------------------------------------------------------------------------
  def move_away_from_player
    sx = distance_x_from_player
    sy = distance_y_from_player
    if sx != 0 or sy != 0
      if sx.abs > sy.abs                  # Horizontal distance is longer
        sx > 0 ? move_right : move_left   # Prioritize left-right
        if @move_failed and sy != 0
          sy > 0 ? move_down : move_up
        end
      else                                # Vertical distance is longer
        sy > 0 ? move_down : move_up      # Prioritize up-down
        if @move_failed and sx != 0
          sx > 0 ? move_right : move_left
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * 1 Step Forward
  #--------------------------------------------------------------------------
  def move_forward
    case @direction
      when 2;  move_down(false)
      when 4;  move_left(false)
      when 6;  move_right(false)
      when 8;  move_up(false)
    end
  end
  #--------------------------------------------------------------------------
  # * 1 Step Backward
  #--------------------------------------------------------------------------
  def move_backward
    last_direction_fix = @direction_fix
    @direction_fix = true
    case @direction
      when 2;  move_up(false)
      when 4;  move_right(false)
      when 6;  move_left(false)
      when 8;  move_down(false)
    end
    @direction_fix = last_direction_fix
  end
  #--------------------------------------------------------------------------
  # * Jump
  #     x_plus : x-coordinate plus value
  #     y_plus : y-coordinate plus value
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    if x_plus.abs > y_plus.abs            # Horizontal distance is longer
      x_plus < 0 ? turn_left : turn_right
    elsif x_plus.abs > y_plus.abs         # Vertical distance is longer
      y_plus < 0 ? turn_up : turn_down
    end
    @x += x_plus
    @y += y_plus
    distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
    @jump_peak = 10 + distance - @move_speed
    @jump_count = @jump_peak * 2
    @stop_count = 0
    straighten
  end
  #--------------------------------------------------------------------------
  # * Turn Down
  #--------------------------------------------------------------------------
  def turn_down
    set_direction(2)
  end
  #--------------------------------------------------------------------------
  # * Turn Left
  #--------------------------------------------------------------------------
  def turn_left
    set_direction(4)
  end
  #--------------------------------------------------------------------------
  # * Turn Right
  #--------------------------------------------------------------------------
  def turn_right
    set_direction(6)
  end
  #--------------------------------------------------------------------------
  # * Turn Up
  #--------------------------------------------------------------------------
  def turn_up
    set_direction(8)
  end
  #--------------------------------------------------------------------------
  # * Turn 90° Right
  #--------------------------------------------------------------------------
  def turn_right_90
    case @direction
      when 2;  turn_left
      when 4;  turn_up
      when 6;  turn_down
      when 8;  turn_right
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 90° Left
  #--------------------------------------------------------------------------
  def turn_left_90
    case @direction
      when 2;  turn_right
      when 4;  turn_down
      when 6;  turn_up
      when 8;  turn_left
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 180°
  #--------------------------------------------------------------------------
  def turn_180
    case @direction
      when 2;  turn_up
      when 4;  turn_right
      when 6;  turn_left
      when 8;  turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 90° Right or Left
  #--------------------------------------------------------------------------
  def turn_right_or_left_90
    case rand(2)
      when 0;  turn_right_90
      when 1;  turn_left_90
    end
  end
  #--------------------------------------------------------------------------
  # * Turn at Random
  #--------------------------------------------------------------------------
  def turn_random
    case rand(4)
      when 0;  turn_up
      when 1;  turn_right
      when 2;  turn_left
      when 3;  turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn toward Player
  #--------------------------------------------------------------------------
  def turn_toward_player
    sx = distance_x_from_player
    sy = distance_y_from_player
    if sx.abs > sy.abs                    # Horizontal distance is longer
      sx > 0 ? turn_left : turn_right
    elsif sx.abs < sy.abs                 # Vertical distance is longer
      sy > 0 ? turn_up : turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn away from Player
  #--------------------------------------------------------------------------
  def turn_away_from_player
    sx = distance_x_from_player
    sy = distance_y_from_player
    if sx.abs > sy.abs                    # Horizontal distance is longer
      sx > 0 ? turn_right : turn_left
    elsif sx.abs < sy.abs                 # Vertical distance is longer
      sy > 0 ? turn_down : turn_up
    end
  end
  #--------------------------------------------------------------------------
  # * Change Graphic
  #     character_name  : new character graphic filename
  #     character_index : new character graphic index
  #--------------------------------------------------------------------------
  def set_graphic(character_name, character_index)
    @tile_id = 0
    @character_name = character_name
    @character_index = character_index
  end
end

#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. It includes event starting determinants and
# map scrolling functions. The instance of this class is referenced by
# $game_player.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :followers                # Followers (party members)
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    @vehicle_type = :walk           # Type of vehicle currently being ridden
    @vehicle_getting_on = false     # Boarding vehicle flag
    @vehicle_getting_off = false    # Getting off vehicle flag
    @followers = Game_Followers.new(self)
    @transparent = $data_system.opt_transparent
    clear_transfer_info
  end
  #--------------------------------------------------------------------------
  # * Clear Transfer Player Information
  #--------------------------------------------------------------------------
  def clear_transfer_info
    @transferring = false           # Player transfer flag
    @new_map_id = 0                 # Destination map ID
    @new_x = 0                      # Destination X coordinate
    @new_y = 0                      # Destination Y coordinate
    @new_direction = 0              # Post-movement direction
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @character_name = actor ? actor.character_name : ""
    @character_index = actor ? actor.character_index : 0
    @followers.refresh
  end
  #--------------------------------------------------------------------------
  # * Get Corresponding Actor
  #--------------------------------------------------------------------------
  def actor
    $game_party.battle_members[0]
  end
  #--------------------------------------------------------------------------
  # * Determine if Stopping
  #--------------------------------------------------------------------------
  def stopping?
    return false if @vehicle_getting_on || @vehicle_getting_off
    return super
  end
  #--------------------------------------------------------------------------
  # * Player Transfer Reservation
  #     d:  Post move direction (2,4,6,8)
  #--------------------------------------------------------------------------
  def reserve_transfer(map_id, x, y, d = 2)
    @transferring = true
    @new_map_id = map_id
    @new_x = x
    @new_y = y
    @new_direction = d
  end
  #--------------------------------------------------------------------------
  # * Determine if Player Transfer is Reserved
  #--------------------------------------------------------------------------
  def transfer?
    @transferring
  end
  #--------------------------------------------------------------------------
  # * Execute Player Transfer
  #--------------------------------------------------------------------------
  def perform_transfer
    if transfer?
      set_direction(@new_direction)
      if @new_map_id != $game_map.map_id
        $game_map.setup(@new_map_id)
        $game_map.autoplay
      end
      moveto(@new_x, @new_y)
      clear_transfer_info
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Map is Passable
  #     d:  Direction (2,4,6,8)
  #--------------------------------------------------------------------------
  def map_passable?(x, y, d)
    case @vehicle_type
      when :boat
        $game_map.boat_passable?(x, y)
      when :ship
        $game_map.ship_passable?(x, y)
      when :airship
        true
      else
        super
    end
  end
  #--------------------------------------------------------------------------
  # * Get Vehicle Currently Being Ridden
  #--------------------------------------------------------------------------
  def vehicle
    $game_map.vehicle(@vehicle_type)
  end
  #--------------------------------------------------------------------------
  # * Determine if on Boat
  #--------------------------------------------------------------------------
  def in_boat?
    @vehicle_type == :boat
  end
  #--------------------------------------------------------------------------
  # * Determine if on Ship
  #--------------------------------------------------------------------------
  def in_ship?
    @vehicle_type == :ship
  end
  #--------------------------------------------------------------------------
  # * Determine if Riding in Airship
  #--------------------------------------------------------------------------
  def in_airship?
    @vehicle_type == :airship
  end
  #--------------------------------------------------------------------------
  # * Determine if Walking Normally
  #--------------------------------------------------------------------------
  def normal_walk?
    @vehicle_type == :walk && !@move_route_forcing
  end
  #--------------------------------------------------------------------------
  # * Determine if Dashing
  #--------------------------------------------------------------------------
  def dash?
    return false if @move_route_forcing
    return false if $game_map.disable_dash?
    return false if vehicle
    return Input.press?(:A)
  end
  #--------------------------------------------------------------------------
  # * Determine if Debug Pass-through State
  #--------------------------------------------------------------------------
  def debug_through?
    $TEST && Input.press?(:CTRL)
  end
  #--------------------------------------------------------------------------
  # * Detect Collision (Including Followers)
  #--------------------------------------------------------------------------
  def collide?(x, y)
    !@through && (pos?(x, y) || followers.collide?(x, y))
  end
  #--------------------------------------------------------------------------
  # * X Coordinate of Screen Center
  #--------------------------------------------------------------------------
  def center_x
    (Graphics.width / 32 - 1) / 2.0
  end
  #--------------------------------------------------------------------------
  # * Y Coordinate of Screen Center
  #--------------------------------------------------------------------------
  def center_y
    (Graphics.height / 32 - 1) / 2.0
  end
  #--------------------------------------------------------------------------
  # * Set Map Display Position to Center of Screen
  #--------------------------------------------------------------------------
  def center(x, y)
    $game_map.set_display_pos(x - center_x, y - center_y)
  end
  #--------------------------------------------------------------------------
  # * Move to Designated Position
  #--------------------------------------------------------------------------
  def moveto(x, y)
    super
    center(x, y)
    make_encounter_count
    vehicle.refresh if vehicle
    @followers.synchronize(x, y, direction)
  end
  #--------------------------------------------------------------------------
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    super
    $game_party.increase_steps if normal_walk?
  end
  #--------------------------------------------------------------------------
  # * Create Encounter Count
  #--------------------------------------------------------------------------
  def make_encounter_count
    n = $game_map.encounter_step
    @encounter_count = rand(n) + rand(n) + 1
  end
  #--------------------------------------------------------------------------
  # * Create Group ID for Troop Encountered
  #--------------------------------------------------------------------------
  def make_encounter_troop_id
    encounter_list = []
    weight_sum = 0
    $game_map.encounter_list.each do |encounter|
      next unless encounter_ok?(encounter)
      encounter_list.push(encounter)
      weight_sum += encounter.weight
    end
    if weight_sum > 0
      value = rand(weight_sum)
      encounter_list.each do |encounter|
        value -= encounter.weight
        return encounter.troop_id if value < 0
      end
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # * Determine Usability of Encounter Item
  #--------------------------------------------------------------------------
  def encounter_ok?(encounter)
    return true if encounter.region_set.empty?
    return true if encounter.region_set.include?(region_id)
    return false
  end
  #--------------------------------------------------------------------------
  # * Execute Encounter Processing
  #--------------------------------------------------------------------------
  def encounter
    return false if $game_map.interpreter.running?
    return false if $game_system.encounter_disabled
    return false if @encounter_count > 0
    make_encounter_count
    troop_id = make_encounter_troop_id
    return false unless $data_troops[troop_id]
    BattleManager.setup(troop_id)
    BattleManager.on_encounter
    return true
  end
  #--------------------------------------------------------------------------
  # * Trigger Map Event
  #     triggers : Trigger array
  #     normal   : Is priority set to [Same as Characters] ?
  #--------------------------------------------------------------------------
  def start_map_event(x, y, triggers, normal)
    return if $game_map.interpreter.running?
    $game_map.events_xy(x, y).each do |event|
      if event.trigger_in?(triggers) && event.normal_priority? == normal
        event.start
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Same Position Event is Triggered
  #--------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    start_map_event(@x, @y, triggers, false)
  end
  #--------------------------------------------------------------------------
  # * Determine if Front Event is Triggered
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    x2 = $game_map.round_x_with_direction(@x, @direction)
    y2 = $game_map.round_y_with_direction(@y, @direction)
    start_map_event(x2, y2, triggers, true)
    return if $game_map.any_event_starting?
    return unless $game_map.counter?(x2, y2)
    x3 = $game_map.round_x_with_direction(x2, @direction)
    y3 = $game_map.round_y_with_direction(y2, @direction)
    start_map_event(x3, y3, triggers, true)
  end
  #--------------------------------------------------------------------------
  # * Determine if Touch Event is Triggered
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    start_map_event(x, y, [1,2], true)
  end
  #--------------------------------------------------------------------------
  # * Processing of Movement via Input from Directional Buttons
  #--------------------------------------------------------------------------
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    move_straight(Input.dir4) if Input.dir4 > 0
  end
  #--------------------------------------------------------------------------
  # * Determine if Movement is Possible
  #--------------------------------------------------------------------------
  def movable?
    return false if moving?
    return false if @move_route_forcing || @followers.gathering?
    return false if @vehicle_getting_on || @vehicle_getting_off
    return false if $game_message.busy? || $game_message.visible
    return false if vehicle && !vehicle.movable?
    return true
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    last_real_x = @real_x
    last_real_y = @real_y
    last_moving = moving?
    move_by_input
    super
    update_scroll(last_real_x, last_real_y)
    update_vehicle
    update_nonmoving(last_moving) unless moving?
    @followers.update
  end
  #--------------------------------------------------------------------------
  # * Scroll Processing
  #--------------------------------------------------------------------------
  def update_scroll(last_real_x, last_real_y)
    ax1 = $game_map.adjust_x(last_real_x)
    ay1 = $game_map.adjust_y(last_real_y)
    ax2 = $game_map.adjust_x(@real_x)
    ay2 = $game_map.adjust_y(@real_y)
    $game_map.scroll_down (ay2 - ay1) if ay2 > ay1 && ay2 > center_y
    $game_map.scroll_left (ax1 - ax2) if ax2 < ax1 && ax2 < center_x
    $game_map.scroll_right(ax2 - ax1) if ax2 > ax1 && ax2 > center_x
    $game_map.scroll_up   (ay1 - ay2) if ay2 < ay1 && ay2 < center_y
  end
  #--------------------------------------------------------------------------
  # * Vehicle Processing
  #--------------------------------------------------------------------------
  def update_vehicle
    return if @followers.gathering?
    return unless vehicle
    if @vehicle_getting_on
      update_vehicle_get_on
    elsif @vehicle_getting_off
      update_vehicle_get_off
    else
      vehicle.sync_with_player
    end
  end
  #--------------------------------------------------------------------------
  # * Update Boarding onto Vehicle
  #--------------------------------------------------------------------------
  def update_vehicle_get_on
    if !@followers.gathering? && !moving?
      @direction = vehicle.direction
      @move_speed = vehicle.speed
      @vehicle_getting_on = false
      @transparent = true
      @through = true if in_airship?
      vehicle.get_on
    end
  end
  #--------------------------------------------------------------------------
  # * Update Disembarking from Vehicle
  #--------------------------------------------------------------------------
  def update_vehicle_get_off
    if !@followers.gathering? && vehicle.altitude == 0
      @vehicle_getting_off = false
      @vehicle_type = :walk
      @transparent = false
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When Not Moving
  #     last_moving : Was it moving previously?
  #--------------------------------------------------------------------------
  def update_nonmoving(last_moving)
    return if $game_map.interpreter.running?
    if last_moving
      $game_party.on_player_walk
      return if check_touch_event
    end
    if movable? && Input.trigger?(:C)
      return if get_on_off_vehicle
      return if check_action_event
    end
    update_encounter if last_moving
  end
  #--------------------------------------------------------------------------
  # * Update Encounter
  #--------------------------------------------------------------------------
  def update_encounter
    return if $TEST && Input.press?(:CTRL)
    return if $game_party.encounter_none?
    return if in_airship?
    return if @move_route_forcing
    @encounter_count -= encounter_progress_value
  end
  #--------------------------------------------------------------------------
  # * Get Encounter Progress Value
  #--------------------------------------------------------------------------
  def encounter_progress_value
    value = $game_map.bush?(@x, @y) ? 2 : 1
    value *= 0.5 if $game_party.encounter_half?
    value *= 0.5 if in_ship?
    value
  end
  #--------------------------------------------------------------------------
  # * Determine if Event Start Caused by Touch (Overlap)
  #--------------------------------------------------------------------------
  def check_touch_event
    return false if in_airship?
    check_event_trigger_here([1,2])
    $game_map.setup_starting_event
  end
  #--------------------------------------------------------------------------
  # * Determine if Event Start Caused by [OK] Button
  #--------------------------------------------------------------------------
  def check_action_event
    return false if in_airship?
    check_event_trigger_here([0])
    return true if $game_map.setup_starting_event
    check_event_trigger_there([0,1,2])
    $game_map.setup_starting_event
  end
  #--------------------------------------------------------------------------
  # * Getting On and Off Vehicles
  #--------------------------------------------------------------------------
  def get_on_off_vehicle
    if vehicle
      get_off_vehicle
    else
      get_on_vehicle
    end
  end
  #--------------------------------------------------------------------------
  # * Board Vehicle
  #    Assumes that the player is not currently in a vehicle.
  #--------------------------------------------------------------------------
  def get_on_vehicle
    front_x = $game_map.round_x_with_direction(@x, @direction)
    front_y = $game_map.round_y_with_direction(@y, @direction)
    @vehicle_type = :boat    if $game_map.boat.pos?(front_x, front_y)
    @vehicle_type = :ship    if $game_map.ship.pos?(front_x, front_y)
    @vehicle_type = :airship if $game_map.airship.pos?(@x, @y)
    if vehicle
      @vehicle_getting_on = true
      force_move_forward unless in_airship?
      @followers.gather
    end
    @vehicle_getting_on
  end
  #--------------------------------------------------------------------------
  # * Get Off Vehicle
  #    Assumes that the player is currently riding in a vehicle.
  #--------------------------------------------------------------------------
  def get_off_vehicle
    if vehicle.land_ok?(@x, @y, @direction)
      set_direction(2) if in_airship?
      @followers.synchronize(@x, @y, @direction)
      vehicle.get_off
      unless in_airship?
        force_move_forward
        @transparent = false
      end
      @vehicle_getting_off = true
      @move_speed = 4
      @through = false
      make_encounter_count
      @followers.gather
    end
    @vehicle_getting_off
  end
  #--------------------------------------------------------------------------
  # * Force One Step Forward
  #--------------------------------------------------------------------------
  def force_move_forward
    @through = true
    move_forward
    @through = false
  end
  #--------------------------------------------------------------------------
  # * Determine if Damage Floor
  #--------------------------------------------------------------------------
  def on_damage_floor?
    $game_map.damage_floor?(@x, @y) && !in_airship?
  end
  #--------------------------------------------------------------------------
  # * Move Straight
  #--------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    @followers.move if passable?(@x, @y, d)
    super
  end
  #--------------------------------------------------------------------------
  # * Move Diagonally
  #--------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    @followers.move if diagonal_passable?(@x, @y, horz, vert)
    super
  end
end


#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  attr_reader :id_partita
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  MAX_MEMBERS = 4                         # Maximum number of party members
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :gold                     # amount of gold
  attr_reader   :steps                    # number of steps
  attr_accessor :last_item_id             # for cursor memory: Item
  attr_accessor :last_actor_index         # for cursor memory: Actor
  attr_accessor :last_target_index        # for cursor memory: Target
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    @gold = 0
    @steps = 0
    @last_item_id = 0
    @last_actor_index = 0
    @last_target_index = 0
    @actors = []      # Party member (actor ID)
    @items = {}       # Inventory item hash (item ID)
    @weapons = {}     # Inventory item hash (weapon ID)
    @armors = {}      # Inventory item hash (armor ID)
  end
  #--------------------------------------------------------------------------
  # * Get Members
  #--------------------------------------------------------------------------
  def members
    result = []
    for i in @actors
      result.push($game_actors[i])
    end
    return result
  end
  # @return[Array]
  def all_members; end
  # @return[Array]
  def battle_members; end
  #--------------------------------------------------------------------------
  # * Get Item Object Array (including weapons and armor)
  #--------------------------------------------------------------------------
  def items
    result = []
    for i in @items.keys.sort
      result.push($data_items[i]) if @items[i] > 0
    end
    for i in @weapons.keys.sort
      result.push($data_weapons[i]) if @weapons[i] > 0
    end
    for i in @armors.keys.sort
      result.push($data_armors[i]) if @armors[i] > 0
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Initial Party Setup
  #--------------------------------------------------------------------------
  def setup_starting_members
    @actors = []
    for i in $data_system.party_members
      @actors.push(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Party Name
  #    If there is only one, returns the actor's name. If there are more,
  #    returns "XX's Party".
  #--------------------------------------------------------------------------
  def name
    if @actors.size == 0
      return ''
    elsif @actors.size == 1
      return members[0].name
    else
      return sprintf(Vocab::PartyName, members[0].name)
    end
  end
  #--------------------------------------------------------------------------
  # * Battle Test Party Setup
  #--------------------------------------------------------------------------
  def setup_battle_test_members
    @actors = []
    for battler in $data_system.test_battlers
      actor = $game_actors[battler.actor_id]
      actor.change_level(battler.level, false)
      actor.change_equip_by_id(0, battler.weapon_id, true)
      actor.change_equip_by_id(1, battler.armor1_id, true)
      actor.change_equip_by_id(2, battler.armor2_id, true)
      actor.change_equip_by_id(3, battler.armor3_id, true)
      actor.change_equip_by_id(4, battler.armor4_id, true)
      actor.recover_all
      @actors.push(actor.id)
    end
    @items = {}
    for i in 1...$data_items.size
      if $data_items[i].battle_ok?
        @items[i] = 99 unless $data_items[i].name.empty?
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Level
  #--------------------------------------------------------------------------
  def max_level
    level = 0
    for i in @actors
      actor = $game_actors[i]
      level = actor.level if level < actor.level
    end
    return level
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    if @actors.size < MAX_MEMBERS and not @actors.include?(actor_id)
      @actors.push(actor_id)
      $game_player.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Remove Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    @actors.delete(actor_id)
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # * Gain Gold (or lose)
  #     n : amount of gold
  #--------------------------------------------------------------------------
  def gain_gold(n)
    @gold = [[@gold + n, 0].max, 9999999].min
  end
  #--------------------------------------------------------------------------
  # * Lose Gold
  #     n : amount of gold
  #--------------------------------------------------------------------------
  def lose_gold(n)
    gain_gold(-n)
  end
  #--------------------------------------------------------------------------
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    @steps += 1
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items Possessed
  #     item : item
  #--------------------------------------------------------------------------
  def item_number(item)
    case item
      when RPG::Item
        number = @items[item.id]
      when RPG::Weapon
        number = @weapons[item.id]
      when RPG::Armor
        number = @armors[item.id]
    end
    return number == nil ? 0 : number
  end
  #--------------------------------------------------------------------------
  # * Determine Item Possession Status
  #     item          : Item
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def has_item?(item, include_equip = false)
    if item_number(item) > 0
      return true
    end
    if include_equip
      for actor in members
        return true if actor.equips.include?(item)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Gain Items (or lose)
  #     item          : Item
  #     n             : Number
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def gain_item(item, n, include_equip = false)
    number = item_number(item)
    case item
      when RPG::Item
        @items[item.id] = [[number + n, 0].max, item.max_number].min
      when RPG::Weapon
        @weapons[item.id] = [[number + n, 0].max, item.max_number].min
      when RPG::Armor
        @armors[item.id] = [[number + n, 0].max, item.max_number].min
    end
    n += number
    if include_equip and n < 0
      for actor in members
        while n < 0 and actor.equips.include?(item)
          actor.discard_equip(item)
          n += 1
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Lose Items
  #     item          : Item
  #     n             : Number
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def lose_item(item, n, include_equip = false)
    gain_item(item, -n, include_equip)
  end
  #--------------------------------------------------------------------------
  # * Consume Items
  #     item : item
  #    If the specified object is a consumable item, the number in investory
  #    will be reduced by 1.
  #--------------------------------------------------------------------------
  def consume_item(item)
    if item.is_a?(RPG::Item) and item.consumable
      lose_item(item, 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Item is Usable
  #     item : item
  #--------------------------------------------------------------------------
  def item_can_use?(item)
    return false unless item.is_a?(RPG::Item)
    return false if item_number(item) == 0
    if $game_temp.in_battle
      return item.battle_ok?
    else
      return item.menu_ok?
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Command is Inputable
  #    Automatic battle is handled as inputable.
  #--------------------------------------------------------------------------
  def inputable?
    for actor in members
      return true if actor.inputable?
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine Everyone is Dead
  #--------------------------------------------------------------------------
  def all_dead?
    if @actors.size == 0 and not $game_temp.in_battle
      return false
    end
    return existing_members.empty?
  end
  #--------------------------------------------------------------------------
  # * Processing Performed When Player Takes 1 Step
  #--------------------------------------------------------------------------
  def on_player_walk
    for actor in members
      if actor.slip_damage?
        actor.hp -= 1 if actor.hp > 1   # Poison damage
        $game_map.screen.start_flash(Color.new(255,0,0,64), 4)
      end
      if actor.auto_hp_recover and actor.hp > 0
        actor.hp += 1                   # HP auto recovery
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Perform Automatic Recovery (called at end of turn)
  #--------------------------------------------------------------------------
  def do_auto_recovery
    for actor in members
      actor.do_auto_recovery
    end
  end

  def in_battle?; true; end
  #--------------------------------------------------------------------------
  # * Remove Battle States (called when battle ends)
  #--------------------------------------------------------------------------
  def remove_states_battle
    for actor in members
      actor.remove_states_battle
    end
  end
  #--------------------------------------------------------------------------
  # * Get Actor Selected on Menu Screen
  #--------------------------------------------------------------------------
  def menu_actor
    $game_actors[@menu_actor_id] || members[0]
  end
  #--------------------------------------------------------------------------
  # * Set Actor Selected on Menu Screen
  #--------------------------------------------------------------------------
  def menu_actor=(actor)
    @menu_actor_id = actor.id
  end
  #--------------------------------------------------------------------------
  # * Select Next Actor on Menu Screen
  #--------------------------------------------------------------------------
  def menu_actor_next
    index = members.index(menu_actor) || -1
    index = (index + 1) % members.size
    self.menu_actor = members[index]
  end
  #--------------------------------------------------------------------------
  # * Select Previous Actor on Menu Screen
  #--------------------------------------------------------------------------
  def menu_actor_prev
    index = members.index(menu_actor) || 1
    index = (index + members.size - 1) % members.size
    self.menu_actor = members[index]
  end
  #--------------------------------------------------------------------------
  # * Get Actor Targeted by Skill/Item Use
  #--------------------------------------------------------------------------
  def target_actor
    $game_actors[@target_actor_id] || members[0]
  end
  #--------------------------------------------------------------------------
  # * Set Actor Targeted by Skill/Item Use
  #--------------------------------------------------------------------------
  def target_actor=(actor)
    @target_actor_id = actor.id
  end
  #--------------------------------------------------------------------------
  # * Change Order
  #--------------------------------------------------------------------------
  def swap_order(index1, index2)
    @actors[index1], @actors[index2] = @actors[index2], @actors[index1]
    $game_player.refresh
  end
end

#==============================================================================
# ** Game_Troop
#------------------------------------------------------------------------------
#  This class handles enemy groups and battle-related data. Also performs
# battle events. The instance of this class is referenced by $game_troop.
#==============================================================================

class Game_Troop < Game_Unit
  #--------------------------------------------------------------------------
  # * Characters to be added to the end of enemy names
  #--------------------------------------------------------------------------
  LETTER_TABLE = [ ' A',' B',' C',' D',' E',' F',' G',' H',' I',' J',
                   ' K',' L',' M',' N',' O',' P',' Q',' R',' S',' T',
                   ' U',' V',' W',' X',' Y',' Z']
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :screen                   # battle screen state
  attr_reader   :interpreter              # battle event interpreter
  attr_reader   :event_flags              # battle event executed flag
  attr_reader   :turn_count               # number of turns
  attr_reader   :name_counts              # hash for enemy name appearance
  attr_accessor :can_escape               # can escape flag
  attr_accessor :can_lose                 # can lose flag
  attr_accessor :preemptive               # preemptive strike flag
  attr_accessor :surprise                 # surprise attack flag
  attr_accessor :turn_ending              # turn-end processing flag
  attr_accessor :forcing_battler          # target of forced battle action
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    @screen = Game_Screen.new
    @interpreter = Game_Interpreter.new
    @event_flags = {}
    @enemies = []       # Troop members (array of enemy objects)
    clear
  end
  #--------------------------------------------------------------------------
  # * Get Members
  #--------------------------------------------------------------------------
  # @return [Array<Enemy>]
  def members
    return @enemies
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    @screen.clear
    @interpreter.clear
    @event_flags.clear
    @enemies = []
    @turn_count = 0
    @names_count = {}
    @can_escape = false
    @can_lose = false
    @preemptive = false
    @surprise = false
    @turn_ending = false
    @forcing_battler = nil
  end
  #--------------------------------------------------------------------------
  # * Get Troop Members
  #--------------------------------------------------------------------------
  def troop
    return $data_troops[@troop_id]
  end
  #--------------------------------------------------------------------------
  # * Setup
  #     troop_id : troop ID
  #--------------------------------------------------------------------------
  def setup(troop_id)
    clear
    @troop_id = troop_id
    @enemies = []
    for member in troop.members
      next if $data_enemies[member.enemy_id] == nil
      enemy = Game_Enemy.new(@enemies.size, member.enemy_id)
      enemy.hidden = member.hidden
      enemy.immortal = member.immortal
      enemy.screen_x = member.x
      enemy.screen_y = member.y
      @enemies.push(enemy)
    end
    make_unique_names
  end
  #--------------------------------------------------------------------------
  # * Add letters (ABC, etc) to enemy characters with the same name
  #--------------------------------------------------------------------------
  def make_unique_names
    for enemy in members
      next unless enemy.exist?
      next unless enemy.letter.empty?
      n = @names_count[enemy.original_name]
      n = 0 if n == nil
      enemy.letter = LETTER_TABLE[n % LETTER_TABLE.size]
      @names_count[enemy.original_name] = n + 1
    end
    for enemy in members
      n = @names_count[enemy.original_name]
      n = 0 if n == nil
      enemy.plural = true if n >= 2
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    @screen.update
  end
  #--------------------------------------------------------------------------
  # * Get Enemy Name Array
  #    For display at start of battle. Overlapping names are removed.
  #--------------------------------------------------------------------------
  def enemy_names
    names = []
    for enemy in members
      next unless enemy.exist?
      next if names.include?(enemy.original_name)
      names.push(enemy.original_name)
    end
    return names
  end
  #--------------------------------------------------------------------------
  # * Determine if battle event (page) meets conditions
  #     page : battle event page
  #--------------------------------------------------------------------------
  def conditions_met?(page)
    c = page.condition
    if not c.turn_ending and not c.turn_valid and not c.enemy_valid and
        not c.actor_valid and not c.switch_valid
      return false      # Conditions not set: Not executed
    end
    if @event_flags[page]
      return false      # Executed
    end
    if c.turn_ending    # At turn end
      return false unless @turn_ending
    end
    if c.turn_valid     # Number of turns
      n = @turn_count
      a = c.turn_a
      b = c.turn_b
      return false if (b == 0 and n != a)
      return false if (b > 0 and (n < 1 or n < a or n % b != a % b))
    end
    if c.enemy_valid    # Enemy
      enemy = $game_troop.members[c.enemy_index]
      return false if enemy == nil
      return false if enemy.hp * 100.0 / enemy.maxhp > c.enemy_hp
    end
    if c.actor_valid    # Actor
      actor = $game_actors[c.actor_id]
      return false if actor == nil
      return false if actor.hp * 100.0 / actor.maxhp > c.actor_hp
    end
    if c.switch_valid   # Switch
      return false if $game_switches[c.switch_id] == false
    end
    return true         # Condition met
  end
  #--------------------------------------------------------------------------
  # * Battle Event Setup
  #--------------------------------------------------------------------------
  def setup_battle_event
    return if @interpreter.running?
    if $game_temp.common_event_id > 0
      common_event = $data_common_events[$game_temp.common_event_id]
      @interpreter.setup(common_event.list)
      $game_temp.common_event_id = 0
      return
    end
    for page in troop.pages
      next unless conditions_met?(page)
      @interpreter.setup(page.list)
      if page.span <= 1
        @event_flags[page] = true
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Increase Turns
  #--------------------------------------------------------------------------
  def increase_turn
    for page in troop.pages
      if page.span == 1
        @event_flags[page] = false
      end
    end
    @turn_count += 1
  end
  #--------------------------------------------------------------------------
  # * Create Battle Action
  #--------------------------------------------------------------------------
  def make_actions
    if @preemptive
      clear_actions
    else
      for enemy in members
        enemy.make_action
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Everyone is Dead
  #--------------------------------------------------------------------------
  # @return [Boolean]
  def all_dead?
    return existing_members.empty?
  end
  #--------------------------------------------------------------------------
  # * Calculate Total Experience
  #--------------------------------------------------------------------------
  def exp_total
    exp = 0
    for enemy in dead_members
      exp += enemy.exp unless enemy.hidden
    end
    return exp
  end
  #--------------------------------------------------------------------------
  # * Calculate Total Gold
  #--------------------------------------------------------------------------
  def gold_total
    gold = 0
    for enemy in dead_members
      gold += enemy.gold unless enemy.hidden
    end
    return gold
  end
  #--------------------------------------------------------------------------
  # * Create Array of Dropped Items
  #--------------------------------------------------------------------------
  def make_drop_items
    drop_items = []
    for enemy in dead_members
      for di in [enemy.drop_item1, enemy.drop_item2]
        next if di.kind == 0
        next if rand(di.denominator) != 0
        if di.kind == 1
          drop_items.push($data_items[di.item_id])
        elsif di.kind == 2
          drop_items.push($data_weapons[di.weapon_id])
        elsif di.kind == 3
          drop_items.push($data_armors[di.armor_id])
        end
      end
    end
    return drop_items
  end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  Questa classe si occupa dei nemici di battaglia. È usata come superclasse
#  di Game_Actor e Game_Enemy.
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_reader   :battler_name             # nome del file della grafica del battler
  attr_reader   :battler_hue              # tonalità dell'immagine
  attr_reader   :hp                       # HP
  attr_reader   :mp                       # MP
  attr_reader   :action                   # mosse del nemico
  attr_accessor :hidden                   # indicatore se nascosto
  attr_accessor :immortal                 # indicatore se immortale
  attr_accessor :animation_id             # ID animazione attacco
  attr_accessor :animation_mirror         # indicatore se l'animazione è a specchio
  attr_accessor :white_flash              # attivatore flash
  attr_accessor :blink                    # attivatore invisibile
  attr_accessor :collapse                 # indicatore morte nemico
  attr_reader   :skipped                  # risultati azione: turno saltato
  attr_reader   :missed                   # risultati azione: mancato
  attr_reader   :evaded                   # risultati azione: evasione
  attr_reader   :critical                 # risultati azione: critico
  attr_reader   :absorbed                 # risultati azione: assorbito
  attr_reader   :hp_damage                # risultati azione: danno HP
  attr_reader   :mp_damage                # risultati azione: danno MP
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    @battler_name = ""
    @battler_hue = 0
    @hp = 0
    @mp = 0
    @action = Game_BattleAction.new(self)
    @states = []                    # Stati inflitti (array con tutti gli ID)
    @state_turns = {}               # Turni rimanenti per gli stati (hash)
    @hidden = false
    @immortal = false
    clear_extra_values
    clear_sprite_effects
    clear_action_results
  end
  #--------------------------------------------------------------------------
  # * Pulisci cambiamenti di parametri
  #--------------------------------------------------------------------------
  def clear_extra_values
    @maxhp_plus = 0
    @maxmp_plus = 0
    @atk_plus = 0
    @def_plus = 0
    @spi_plus = 0
    @agi_plus = 0
  end
  #--------------------------------------------------------------------------
  # * Pulisci le variabili usate per gli effetti
  #--------------------------------------------------------------------------
  def clear_sprite_effects
    @animation_id = 0
    @animation_mirror = false
    @white_flash = false
    @blink = false
    @collapse = false
  end
  #--------------------------------------------------------------------------
  # * Pulisci le variabili usate per le azioni di battaglia
  #--------------------------------------------------------------------------
  def clear_action_results
    @skipped = false
    @missed = false
    @evaded = false
    @critical = false
    @absorbed = false
    @hp_damage = 0
    @mp_damage = 0
    @added_states = []              # Stati aggiunti (array con ID)
    @removed_states = []            # Stati rimossi (array con ID)
    @remained_states = []           # Stati non cambiati (array con ID)
  end
  #--------------------------------------------------------------------------
  # * Prende tutti gli stati correnti da un array
  #--------------------------------------------------------------------------
  def states
    result = []
    for i in @states
      result.push($data_states[i])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Prendi gli stati che sono stati aggiunti dall' azione precedente.
  #--------------------------------------------------------------------------
  def added_states
    result = []
    for i in @added_states
      result.push($data_states[i])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Prendi gli stati che sono stati rimossi dall' azione precedente.
  #--------------------------------------------------------------------------
  def removed_states
    result = []
    for i in @removed_states
      result.push($data_states[i])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Prendi gli stati che sono rimasti invariati dall'azione precedente,
  #   ad esempio quando si cerca di addormentare un nemico già dormiente.
  #--------------------------------------------------------------------------
  def remained_states
    result = []
    for i in @remained_states
      result.push($data_states[i])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Determina o no se ci sono degli effetti di stato nelle azioni precedenti
  #--------------------------------------------------------------------------
  def states_active?
    return true unless @added_states.empty?
    return true unless @removed_states.empty?
    return true unless @remained_states.empty?
    return false
  end
  #--------------------------------------------------------------------------
  # * Determina il limite di HP massimi
  #--------------------------------------------------------------------------
  def maxhp_limit
    return 999999
  end
  #--------------------------------------------------------------------------
  # * Prendi gli HP massimi
  #--------------------------------------------------------------------------
  def maxhp
    return [[base_maxhp + @maxhp_plus, 1].max, maxhp_limit].min
  end
  #--------------------------------------------------------------------------
  # * Prendi gli MP massimi
  #--------------------------------------------------------------------------
  def maxmp
    return [[base_maxmp + @maxmp_plus, 0].max, 9999].min
  end
  #--------------------------------------------------------------------------
  # * Ottieni l'attacco
  #--------------------------------------------------------------------------
  def atk
    n = [[base_atk + @atk_plus, 1].max, 999].min
    for state in states do n *= state.atk_rate / 100.0 end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # * Ottieni la difesa
  #--------------------------------------------------------------------------
  def def
    n = [[base_def + @def_plus, 1].max, 999].min
    for state in states do n *= state.def_rate / 100.0 end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # * Ottieni lo Spirito
  #--------------------------------------------------------------------------
  def spi
    n = [[base_spi + @spi_plus, 1].max, 999].min
    for state in states do n *= state.spi_rate / 100.0 end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # * Ottieni l'Agilità
  #--------------------------------------------------------------------------
  def agi
    n = [[base_agi + @agi_plus, 1].max, 999].min
    for state in states do n *= state.agi_rate / 100.0 end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # * Determina l'opzione "Forte Difesa"
  #--------------------------------------------------------------------------
  def super_guard
    return false
  end
  #--------------------------------------------------------------------------
  # * Ottieni l'opzione "Attacco Prioritario" sull'arma
  #--------------------------------------------------------------------------
  def fast_attack
    return false
  end
  #--------------------------------------------------------------------------
  # * Ottieni l'opzione "Due Armi" del personaggio
  #--------------------------------------------------------------------------
  def dual_attack
    return false
  end
  #--------------------------------------------------------------------------
  # * Ottieni "Previeni i Critici" dall'armatura
  #--------------------------------------------------------------------------
  def prevent_critical
    return false
  end
  #--------------------------------------------------------------------------
  # * Ottieni "Costo MP 1/2" dall'armatura
  #--------------------------------------------------------------------------
  def half_mp_cost
    return false
  end
  #--------------------------------------------------------------------------
  # * Setta gli HP massimi
  #     new_maxhp : nuovi HP massimi
  #--------------------------------------------------------------------------
  def maxhp=(new_maxhp)
    @maxhp_plus += new_maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -9999].max, 9999].min
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # * Setta gli MP massimi
  #     new_maxmp : nuovi MP massimi
  #--------------------------------------------------------------------------
  def maxmp=(new_maxmp)
    @maxmp_plus += new_maxmp - self.maxmp
    @maxmp_plus = [[@maxmp_plus, -9999].max, 9999].min
    @mp = [@mp, self.maxmp].min
  end
  #--------------------------------------------------------------------------
  # * Setta l'Attacco
  #     new_atk : nuovo attacco
  #--------------------------------------------------------------------------
  def atk=(new_atk)
    @atk_plus += new_atk - self.atk
    @atk_plus = [[@atk_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Setta la Difesa
  #     new_def : nuova Difesa
  #--------------------------------------------------------------------------
  def def=(new_def)
    @def_plus += new_def - self.def
    @def_plus = [[@def_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Setta Spirito
  #     new_spi : nnuovo spirito
  #--------------------------------------------------------------------------
  def spi=(new_spi)
    @spi_plus += new_spi - self.spi
    @spi_plus = [[@spi_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Setta l'Agilità
  #     new_agi : nuova agilità
  #--------------------------------------------------------------------------
  def agi=(new_agi)
    @agi_plus += new_agi - self.agi
    @agi_plus = [[@agi_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # * Cambia HP
  #     hp : nuovi HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    @hp = [[hp, maxhp].min, 0].max
    if @hp == 0 and not state?(1) and not @immortal
      add_state(1)                # Add incapacitated (state #1)
      @added_states.push(1)
    elsif @hp > 0 and state?(1)
      remove_state(1)             # Remove incapacitated (state #1)
      @removed_states.push(1)
    end
  end
  #--------------------------------------------------------------------------
  # * Cambia MP
  #     mp : nuovi MP
  #--------------------------------------------------------------------------
  def mp=(mp)
    @mp = [[mp, maxmp].min, 0].max
  end
  #--------------------------------------------------------------------------
  # * Ricovero Totale
  #--------------------------------------------------------------------------
  def recover_all
    @hp = maxhp
    @mp = maxmp
    for i in @states.clone do remove_state(i) end
  end
  #--------------------------------------------------------------------------
  # * Determina incapacità fisica
  #--------------------------------------------------------------------------
  def dead?
    return (not @hidden and @hp == 0 and not @immortal)
  end
  #--------------------------------------------------------------------------
  # * Determina Esistenza
  #--------------------------------------------------------------------------
  def exist?
    return (not @hidden and not dead?)
  end
  #--------------------------------------------------------------------------
  # * Determina se il comando è selezionabile
  #--------------------------------------------------------------------------
  def inputable?
    return (not @hidden and restriction <= 1)
  end
  #--------------------------------------------------------------------------
  # * Determina se l'Azione è possibile
  #--------------------------------------------------------------------------
  def movable?
    return (not @hidden and restriction < 4)
  end
  #--------------------------------------------------------------------------
  # * Determina se l'attacco è schivabile
  #--------------------------------------------------------------------------
  def parriable?
    return (not @hidden and restriction < 5)
  end
  #--------------------------------------------------------------------------
  # * Determina se il personaggio non può usare magie
  #--------------------------------------------------------------------------
  def silent?
    return (not @hidden and restriction == 1)
  end
  #--------------------------------------------------------------------------
  # * Determina se il personaggio è in stato "Berserk"
  #--------------------------------------------------------------------------
  def berserker?
    return (not @hidden and restriction == 2)
  end
  #--------------------------------------------------------------------------
  # * Determina se il personaggio è confuso
  #--------------------------------------------------------------------------
  def confusion?
    return (not @hidden and restriction == 3)
  end
  #--------------------------------------------------------------------------
  # * Determina se il personaggio si sta difendendo
  #--------------------------------------------------------------------------
  def guarding?
    return @action.guard?
  end
  #--------------------------------------------------------------------------
  # * Ottieni il cambio valori dell'elemento
  #     element_id : ID elemento
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    return 100
  end
  #--------------------------------------------------------------------------
  # * Ottieni le probabilità di successo di infliggere stati alterati
  #--------------------------------------------------------------------------
  def state_probability(state_id)
    return 0
  end
  #--------------------------------------------------------------------------
  # * Determina se il personaggio resiste allo stato
  #     state_id : ID stato
  #--------------------------------------------------------------------------
  def state_resist?(state_id)
    return false
  end
  #--------------------------------------------------------------------------
  # * Ottieni l'elemento dell'attacco normale
  #--------------------------------------------------------------------------
  def element_set
    return []
  end
  #--------------------------------------------------------------------------
  # * Ottieni cambiamenti di stato dell'attacco normale (+)
  #--------------------------------------------------------------------------
  def plus_state_set
    return []
  end
  #--------------------------------------------------------------------------
  # * Ottieni cambiamenti di stato dell'attacco normale (+)
  #--------------------------------------------------------------------------
  def minus_state_set
    return []
  end
  #--------------------------------------------------------------------------
  # * Controlla Stato
  #     state_id : ID stato
  #    Restituisce True se uno stato applicabile è aggiunto.
  #--------------------------------------------------------------------------
  def state?(state_id)
    return @states.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # * Determina se il personaggio ha raggiunto il n. massimo di stati possibili
  #     state_id : ID stato
  #    Restituisce true se il numero di turni dello stato in cui è
  #    afflitto è uguale al numero minimo di turni dopo il quale lo
  #    stato sarà rimosso da solo.
  #--------------------------------------------------------------------------
  def state_full?(state_id)
    return false unless state?(state_id)
    return @state_turns[state_id] == $data_states[state_id].hold_turn
  end
  #--------------------------------------------------------------------------
  # * Determina se lo stato dev'essere ignorato
  #     state_id : ID stato
  #    Restituisce true se sono soddisfatte le seguenti condizioni.
  #     * Se lo stato A che è stato aggiunto, è incluso nella lista
  #       [Cancella Stati] dello stato B.
  #     * Se lo Stato B non è incluso nella lista [Cancella Stati]
  #       del nuovo Stato A.
  #    Queste condizioni saranno applicate quando, per esempio, provi ad
  #    avvelenare un personaggio KO. Non si applica nel caso che metti
  #    Attacco Su quando il personaggio è affetto da Attacco Giù.
  #--------------------------------------------------------------------------
  def state_ignore?(state_id)
    for state in states
      if state.state_set.include?(state_id) and
          not $data_states[state_id].state_set.include?(state.id)
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Determina se c'è uno stato che dev'essere deviato
  #     state_id : ID stato
  #    Restituisce true se sono soddisfatte le seguenti condizioni.
  #     * Se è attivata l'opzione [Effetto Opposto] del nuovo stato.
  #     * La lista [Immunità Stati] del nuovo stato da aggiungere contiene
  #       almeno uno degli stati attuali.
  #    Questo potrebbe accadere quando, ad esempio, è applicato il nuovo stato
  #    Attacco Su quando è già in effetto Attacco Giù.
  #--------------------------------------------------------------------------
  def state_offset?(state_id)
    return false unless $data_states[state_id].offset_by_opposite
    for i in @states
      return true if $data_states[state_id].state_set.include?(i)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Ordinamento Stati
  #    Ordina il contenuto dell'array @states, in quanto lo stato con la
  #    priorità più alta verrà messo prima e così via.
  #--------------------------------------------------------------------------
  def sort_states
    @states.sort! do |a, b|
      state_a = $data_states[a]
      state_b = $data_states[b]
      if state_a.priority != state_b.priority
        state_b.priority <=> state_a.priority
      else
        a <=> b
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiunti Stato
  #     state_id : ID stato
  #--------------------------------------------------------------------------
  def add_state(state_id)
    state = $data_states[state_id]        # Ottieni i dati dello Stato
    return if state == nil                # I dati sono invalidi?
    return if state_ignore?(state_id)     # È uno stato da ignorare?
    unless state?(state_id)               # È uno stato non ancora inflitto?
      unless state_offset?(state_id)      # È uno stato da deviare?
        @states.push(state_id)            # Aggiungi l'ID all'array @states
      end
      if state_id == 1                    # Se è lo stato KO (stato 1)
        @hp = 0                           # Cambia HP a 0
      end
      unless inputable?                   # Se il personaggio non può combattere
        @action.clear                     # Pulisci le azioni di battaglia
      end
      for i in state.state_set            # Prendi [Immunità Stati]
        remove_state(i)                   # ...e rimuovili
        @removed_states.delete(i)         # Non sarà mostrato su display
      end
      sort_states                         # Ordina gli stati per priorità
    end
    @state_turns[state_id] = state.hold_turn    # Setta i numeri dei turni
  end
  #--------------------------------------------------------------------------
  # * Rimuovi Stato
  #     state_id : ID Stato
  #--------------------------------------------------------------------------
  def remove_state(state_id)
    return unless state?(state_id)        # Questo stato non è stato aggiunto?
    if state_id == 1 and @hp == 0         # Questo stato è il KO? (stato 1)
      @hp = 1                             # Cambia HP a 1
    end
    @states.delete(state_id)              # Rimuovi l'ID dall'array @states
    @state_turns.delete(state_id)         # Rimuovi l'ID dall'array @state_turns
  end
  #--------------------------------------------------------------------------
  # * Ottieni Restrizioni
  #    Ottiene le restrizioni più importanti da tutti gli stati inflitti
  #--------------------------------------------------------------------------
  def restriction
    restriction_max = 0
    for state in states
      if state.restriction >= restriction_max
        restriction_max = state.restriction
      end
    end
    return restriction_max
  end
  #--------------------------------------------------------------------------
  # * Determina gli stati con [Danno Continuo]
  #--------------------------------------------------------------------------
  def slip_damage?
    for state in states
      return true if state.slip_damage
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Determina se lo stato è [Riduci Mira]
  #--------------------------------------------------------------------------
  def reduce_hit_ratio?
    for state in states
      return true if state.reduce_hit_ratio
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Ottieni il messaggio di continuazione effetto dello stato più importante
  #--------------------------------------------------------------------------
  def most_important_state_text
    for state in states
      return state.message3 unless state.message3.empty?
    end
    return ""
  end
  #--------------------------------------------------------------------------
  # * Rimuovi gli stati non permanenti (Chiamato quando finisce la battaglia)
  #--------------------------------------------------------------------------
  def remove_states_battle
    for state in states
      remove_state(state.id) if state.battle_only
    end
  end
  #--------------------------------------------------------------------------
  # * Rimuovi gli stati naturalmente (Chiamato a ogni turno)
  #--------------------------------------------------------------------------
  def remove_states_auto
    clear_action_results
    for i in @state_turns.keys.clone
      if @state_turns[i] > 0
        @state_turns[i] -= 1
      elsif rand(100) < $data_states[i].auto_release_prob
        remove_state(i)
        @removed_states.push(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Stati da rimuovere per danno fisico (Come quando sei in Sonno)
  #--------------------------------------------------------------------------
  def remove_states_shock
    for state in states
      if state.release_by_damage
        remove_state(state.id)
        @removed_states.push(state.id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Colcolo degli MP consumati per le Abilità
  #     skill : Abilità
  #--------------------------------------------------------------------------
  def calc_mp_cost(skill)
    if half_mp_cost
      return skill.mp_cost / 2
    else
      return skill.mp_cost
    end
  end
  #--------------------------------------------------------------------------
  # * Determina le abilità utilizzabili
  #     skill : abilità
  #--------------------------------------------------------------------------
  def skill_can_use?(skill)
    return false unless skill.is_a?(RPG::Skill)
    return false unless movable?
    return false if silent? and skill.spi_f > 0
    return false if calc_mp_cost(skill) > mp
    if $game_temp.in_battle
      return skill.battle_ok?
    else
      return skill.menu_ok?
    end
  end
  #--------------------------------------------------------------------------
  # * Calcolo del danno finale
  #     user : Colui che esegue l'attacco, usa l'abilità o usa l'oggetto
  #     obj  : Potere o oggetto (Se è nil è un attacco normale)
  #--------------------------------------------------------------------------
  def calc_hit(user, obj = nil)
    if obj == nil                           # per un attacco normale
      hit = user.hit                        # ottieni la grandezza del colpo
      physical = true
    elsif obj.is_a?(RPG::Skill)             # per un'abilità
      hit = obj.hit                         # ottieni le probabilità di successo
      physical = obj.physical_attack
    else                                    # per un oggetto
      hit = 100                             # le probabilità di succ. sono al 100%
      physical = obj.physical_attack
    end
    if physical                             # per un attacco fisico
      hit /= 4 if user.reduce_hit_ratio?    # se colui che l'esegue è accecato
    end
    return hit
  end
  #--------------------------------------------------------------------------
  # * Calcola le probabilità di Evasione
  #     user : Colui che esegue l'attacco, usa l'abilità o usa l'oggetto
  #     obj  : Potere o oggetto (Se è nil è un attacco normale)
  #--------------------------------------------------------------------------
  def calc_eva(user, obj = nil)
    eva = self.eva
    unless obj == nil                       # se è un'abilità o un oggetto
      eva = 0 unless obj.physical_attack    # 0% se non è un attacco fisico
    end
    unless parriable?                       # Se non è parabile
      eva = 0                               # 0%
    end
    return eva
  end
  #--------------------------------------------------------------------------
  # * Calcolo del danno di un Attacco Normale
  #     attacker : Attaccante
  #    I risultati sono assegnati a @hp_damage
  #--------------------------------------------------------------------------
  def make_attack_damage_value(attacker)
    damage = attacker.atk * 4 - self.def * 2        # calcoli di base
    damage = 0 if damage < 0                        # se negativo assegna 0
    damage *= elements_max_rate(attacker.element_set)   # regolazione con l'elemento
    damage /= 100
    if damage == 0                                  # se il danno è 0,
      damage = rand(2)                              # metà delle volte, 1 danno
    elsif damage > 0                                # un numero positivo?
      @critical = (rand(100) < attacker.cri)        # attacco critico?
      @critical = false if prevent_critical         # previene dai critici?
      damage *= 3 if @critical                      # adattamento critico (ATTx3)
    end
    damage = apply_variance(damage, 20)             # variazione
    damage = apply_guard(damage)                    # adattamento difesa
    @hp_damage = damage                             # danno agli HP
  end
  #--------------------------------------------------------------------------
  # * Calcolo del danno di un'Abilità o Oggetto
  #     user : Chi usa l'oggetto o l'abilità
  #     obj  : Potere o oggetto (Se è nil è un attacco normale)
  #    I risultati sono assegnati a @hp_damage o @mp_damage.
  #--------------------------------------------------------------------------
  def make_obj_damage_value(user, obj)
    damage = obj.base_damage                        # calcoli di base
    if damage > 0                                   # numero positivo?
      damage += user.atk * 4 * obj.atk_f / 100      # Attaccco F del soggetto
      damage += user.spi * 2 * obj.spi_f / 100      # Spirito F dell'oggetto
      unless obj.ignore_defense                     # Se non c'è Ignora Difesa
        damage -= self.def * 2 * obj.atk_f / 100    # Difesa F del bersaglio
        damage -= self.spi * 1 * obj.spi_f / 100    # Spirito F del bersaglio
      end
      damage = 0 if damage < 0                      # Se negativo, assegna 0
    elsif damage < 0                                # numero negativo?
      damage -= user.atk * 4 * obj.atk_f / 100      # Attacco F del soggetto
      damage -= user.spi * 2 * obj.spi_f / 100      # Intelligenza F del sogg.
    end
    damage *= elements_max_rate(obj.element_set)    # regolazione elemento
    damage /= 100
    damage = apply_variance(damage, obj.variance)   # variazione
    damage = apply_guard(damage)                    # regolazione difesa
    if obj.damage_to_mp
      @mp_damage = damage                           # danno MP
    else
      @hp_damage = damage                           # danno HP
    end
  end
  #--------------------------------------------------------------------------
  # * Calcolo dell'Effetto del potere Assorbi
  #     user : Chi usa l'oggetto o l'abilità
  #     obj  : Potere o oggetto (Se è nil è un attacco normale)
  #    @hp_damage e  @mp_damage devono essere calcolati prima della chiamata
  #--------------------------------------------------------------------------
  def make_obj_absorb_effect(user, obj)
    if obj.absorb_damage                        # se assorbi danno
      @hp_damage = [self.hp, @hp_damage].min    # regola portata danno HP
      @mp_damage = [self.mp, @mp_damage].min    # regola portata danno MP
      if @hp_damage > 0 or @mp_damage > 0       # numero positivo?
        @absorbed = true                        # regola flag assorbimento ON
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Calcolo ammonto di recupero HP da un oggetto
  #--------------------------------------------------------------------------
  def calc_hp_recovery(user, item)
    result = maxhp * item.hp_recovery_rate / 100 + item.hp_recovery
    result *= 2 if user.pharmacology    # Effetto Pozioni X2 raddoppia l'effetto
    return result
  end
  #--------------------------------------------------------------------------
  # * Calcolo ammonto di recupero MP da un oggetto
  #--------------------------------------------------------------------------
  def calc_mp_recovery(user, item)
    result = maxmp * item.mp_recovery_rate / 100 + item.mp_recovery
    result *= 2 if user.pharmacology    # Effetto Pozioni X2 raddoppia l'effetto
    return result
  end
  #--------------------------------------------------------------------------
  # * Ottieni il massimo ammonto di regolazione elementale
  #     element_set : Affinità Elemento
  #    Restituisce l'effetto più potente di tutte le affinità.
  #--------------------------------------------------------------------------
  def elements_max_rate(element_set)
    return 100 if element_set.empty?                # Se non c'è nessun elemento
    rate_list = []
    for i in element_set
      rate_list.push(element_rate(i))
    end
    return rate_list.max
  end
  #--------------------------------------------------------------------------
  # * Applica Variazione
  #     damage   : Danno
  #     variance : Grado di variazione in percentuale
  #--------------------------------------------------------------------------
  def apply_variance(damage, variance)
    if damage != 0                                  # Se il danno non è 0
      amp = [damage.abs * variance / 100, 0].max    # Calcola portata
      damage += rand(amp+1) + rand(amp+1) - amp     # Esegui variazione
    end
    return damage
  end
  #--------------------------------------------------------------------------
  # * Applica regolazione Difesa
  #     damage : Damage
  #--------------------------------------------------------------------------
  def apply_guard(damage)
    if damage > 0 and guarding?                     # Determina se si sta difendendo
      damage /= super_guard ? 4 : 2                 # Riduci danno
    end
    return damage
  end
  #--------------------------------------------------------------------------
  # * Assorbi Danno
  #     user : Chi usa l'oggetto o l'abilità
  #    @hp_damage, @mp_damage, o @absorbed devono essere calcolati prima di
  #    richiamare questo metodo.
  #--------------------------------------------------------------------------
  def execute_damage(user)
    if @hp_damage > 0           # Il danno è un numero positivo
      remove_states_shock       # Rimuovi lo stato dovuto all'attacco
    end
    self.hp -= @hp_damage
    self.mp -= @mp_damage
    if @absorbed                # Se assorbito
      user.hp += @hp_damage
      user.mp += @mp_damage
    end
  end
  #--------------------------------------------------------------------------
  # * Applica Cambiamento di Stato
  #     obj : Abilità, oggetto, or attaccante
  #--------------------------------------------------------------------------
  def apply_state_changes(obj)
    plus = obj.plus_state_set             # ottieni cambiamento di stato(+)
    minus = obj.minus_state_set           # ottieni cambiamento di stato (-)
    for i in plus                         # cambia stato (+)
      next if state_resist?(i)            # ha resistito?
      next if dead?                       # è morto?
      next if i == 1 and @immortal        # sono immortali?
      if state?(i)                        # è già afflitto dallo stato?
        @remained_states.push(i)          # regista gli stati immutati
        next
      end
      if rand(100) < state_probability(i) # determina probabilità
        add_state(i)                      # aggiungi stato
        @added_states.push(i)             # registra gli stati aggiunti
      end
    end
    for i in minus                        # cambia stato (-)
      next unless state?(i)               # lo stato non è stato applicato?
      remove_state(i)                     # rimuovi stato
      @removed_states.push(i)             # registra gli stati rimossi
    end
    for i in @added_states & @removed_states  # se ci sono stati sia nelle
      @added_states.delete(i)                 # sezioni aggiunti e rimossi
      @removed_states.delete(i)               # eliminali entrambi
    end
  end
  #--------------------------------------------------------------------------
  # * Determina se applicare un attacco normale
  #     attacker : Attaccante
  #--------------------------------------------------------------------------
  def attack_effective?(attacker)
    if dead?
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Applica gli effetti dell'attacco normale
  #     attacker : Attaccante
  #--------------------------------------------------------------------------
  def attack_effect(attacker)
    clear_action_results
    unless attack_effective?(attacker)
      @skipped = true
      return
    end
    if rand(100) >= calc_hit(attacker)            # determina le prob. di colpo
      @missed = true
      return
    end
    if rand(100) < calc_eva(attacker)             # determina le prob. di evas.
      @evaded = true
      return
    end
    make_attack_damage_value(attacker)            # calcolo del danno
    execute_damage(attacker)                      # assorbimento danno
    if @hp_damage == 0                            # nessun danno fisico?
      return
    end
    apply_state_changes(attacker)                 # cambiamento di stato
  end
  #--------------------------------------------------------------------------
  # * Determina se può essere applicata un'Abilità
  #     user  : Soggetto che ha l'abilità
  #     skill : Abilità
  #--------------------------------------------------------------------------
  def skill_effective?(user, skill)
    if skill.for_dead_friend? != dead?
      return false
    end
    if not $game_temp.in_battle and skill.for_friend?
      return skill_test(user, skill)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Verifica l'applicazione dell'abilità
  #     user  : Soggetto che ha l'abilità
  #     skill : Abilità
  #    Usato per determinare, ad esempio, se un personaggio ha già il 100% di
  #    HP e non può essere curato più di così
  #--------------------------------------------------------------------------
  def skill_test(user, skill)
    tester = self.clone
    tester.make_obj_damage_value(user, skill)
    tester.apply_state_changes(skill)
    if tester.hp_damage < 0
      return true if tester.hp < tester.maxhp
    end
    if tester.mp_damage < 0
      return true if tester.mp < tester.maxmp
    end
    return true unless tester.added_states.empty?
    return true unless tester.removed_states.empty?
    return false
  end
  #--------------------------------------------------------------------------
  # * Applica effetti dell'abilità
  #     user  : Soggetto che ha l'abilità
  #     skill : Abilità
  #--------------------------------------------------------------------------
  def skill_effect(user, skill)
    clear_action_results
    unless skill_effective?(user, skill)
      @skipped = true
      return
    end
    if rand(100) >= calc_hit(user, skill)         # determina le prob. di colpo
      @missed = true
      return
    end
    if rand(100) < calc_eva(user, skill)          # determina le prob. di evas.
      @evaded = true
      return
    end
    make_obj_damage_value(user, skill)            # calcola il danno
    make_obj_absorb_effect(user, skill)           # calcola effetti di assorbim.
    execute_damage(user)                          # assorbi danno
    if skill.physical_attack and @hp_damage == 0  # nessun danno fisico?
      return
    end
    apply_state_changes(skill)                    # cambia stato
  end
  #--------------------------------------------------------------------------
  # * Determina se un oggetto può essere usato
  #     user : Soggetto che ha l'oggetto (giochi di parole a parte)
  #     item : oggetto
  #--------------------------------------------------------------------------
  def item_effective?(user, item)
    if item.for_dead_friend? != dead?
      return false
    end
    if not $game_temp.in_battle and item.for_friend?
      return item_test(user, item)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Verifica l'applicazione dell'oggetto
  #     user : Colui che usa l'oggetto (vabbè? Così non ridi)
  #     item : oggetto
  #    Usato per determinare, ad esempio, se un personaggio ha già il 100% di
  #    HP e non può essere curato più di così
  #--------------------------------------------------------------------------
  def item_test(user, item)
    tester = self.clone
    tester.make_obj_damage_value(user, item)
    tester.apply_state_changes(item)
    if tester.hp_damage < 0 or tester.calc_hp_recovery(user, item) > 0
      return true if tester.hp < tester.maxhp
    end
    if tester.mp_damage < 0 or tester.calc_mp_recovery(user, item) > 0
      return true if tester.mp < tester.maxmp
    end
    return true unless tester.added_states.empty?
    return true unless tester.removed_states.empty?
    return true if item.parameter_type > 0
    return false
  end
  #--------------------------------------------------------------------------
  # * Applica effetti dell'oggetto
  #     user : Colui che usa l'oggetto
  #     item : oggetto
  #--------------------------------------------------------------------------
  def item_effect(user, item)
    clear_action_results
    unless item_effective?(user, item)
      @skipped = true
      return
    end
    if rand(100) >= calc_hit(user, item)          # determina le prob. di colpire
      @missed = true
      return
    end
    if rand(100) < calc_eva(user, item)           # determina le prob. di evas.
      @evaded = true
      return
    end
    hp_recovery = calc_hp_recovery(user, item)    # calcola l'ammonto di rec. HP
    mp_recovery = calc_mp_recovery(user, item)    # calcola l'ammonto di rec. MP
    make_obj_damage_value(user, item)             # calcola danno
    @hp_damage -= hp_recovery                     # sottrai l'ammonto di rec. HP
    @mp_damage -= mp_recovery                     # sottrai l'ammonto di rec. MP
    make_obj_absorb_effect(user, item)            # calcola effetti di assorbim.
    execute_damage(user)                          # rifletti danno
    item_growth_effect(user, item)                # applica effetto di potenziam.
    if item.physical_attack and @hp_damage == 0   # nessun danno fisico?
      return
    end
    apply_state_changes(item)                     # cambia stato
  end
  #--------------------------------------------------------------------------
  # * Applica effetto di potenziamento
  #     user : Chi usa l'oggetto
  #     item : oggetto
  #--------------------------------------------------------------------------
  def item_growth_effect(user, item)
    if item.parameter_type > 0 and item.parameter_points != 0
      case item.parameter_type
        when 1  # HP Massimi
          @maxhp_plus += item.parameter_points
        when 2  # MP Massimi
          @maxmp_plus += item.parameter_points
        when 3  # Attacco
          @atk_plus += item.parameter_points
        when 4  # Difesa
          @def_plus += item.parameter_points
        when 5  # Intelligenza
          @spi_plus += item.parameter_points
        when 6  # Agilità
          @agi_plus += item.parameter_points
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Applicazione del Danno Continuo (Veleno)
  #--------------------------------------------------------------------------
  def slip_damage_effect
    if slip_damage? and @hp > 0
      @hp_damage = apply_variance(maxhp / 10, 10)
      @hp_damage = @hp - 1 if @hp_damage >= @hp
      self.hp -= @hp_damage
    end
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :name                     # name
  attr_reader   :character_name           # character graphic filename
  attr_reader   :character_index          # character graphic index
  attr_reader   :face_name                # face graphic filename
  attr_reader   :face_index               # face graphic index
  attr_reader   :class_id                 # class ID
  attr_reader   :weapon_id                # weapon ID
  attr_reader   :armor1_id                # shield ID
  attr_reader   :armor2_id                # helmet ID
  attr_reader   :armor3_id                # body armor ID
  attr_reader   :armor4_id                # accessory ID
  attr_reader   :level                    # level
  attr_reader   :exp                      # experience
  attr_accessor :last_skill_id            # for cursor memory: Skill
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
    @last_skill_id = 0
  end
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    actor = $data_actors[actor_id]
    @actor_id = actor_id
    @name = actor.name
    @character_name = actor.character_name
    @character_index = actor.character_index
    @face_name = actor.face_name
    @face_index = actor.face_index
    @class_id = actor.class_id
    @weapon_id = actor.weapon_id
    @armor1_id = actor.armor1_id
    @armor2_id = actor.armor2_id
    @armor3_id = actor.armor3_id
    @armor4_id = actor.armor4_id
    @level = actor.initial_level
    @exp_list = Array.new(101)
    make_exp_list
    @exp = @exp_list[@level]
    @skills = []
    for i in self.class.learnings
      learn_skill(i.skill_id) if i.level <= @level
    end
    clear_extra_values
    recover_all
  end
  #--------------------------------------------------------------------------
  # * Determine if Actor or Not
  #--------------------------------------------------------------------------
  def actor?
    return true
  end
  #--------------------------------------------------------------------------
  # * Get Actor ID
  #--------------------------------------------------------------------------
  def id
    return @actor_id
  end
  #--------------------------------------------------------------------------
  # * Get Index
  #--------------------------------------------------------------------------
  def index
    return $game_party.members.index(self)
  end
  #--------------------------------------------------------------------------
  # * Get Actor Object
  #--------------------------------------------------------------------------
  def actor
    return $data_actors[@actor_id]
  end
  #--------------------------------------------------------------------------
  # * Get Class Object
  #--------------------------------------------------------------------------
  def class
    return $data_classes[@class_id]
  end
  #--------------------------------------------------------------------------
  # * Get Skill Object Array
  #--------------------------------------------------------------------------
  def skills
    result = []
    for i in @skills
      result.push($data_skills[i])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Get Weapon Object Array
  #--------------------------------------------------------------------------
  def weapons
    result = []
    result.push($data_weapons[@weapon_id])
    if two_swords_style
      result.push($data_weapons[@armor1_id])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Get Armor Object Array
  #--------------------------------------------------------------------------
  def armors
    result = []
    unless two_swords_style
      result.push($data_armors[@armor1_id])
    end
    result.push($data_armors[@armor2_id])
    result.push($data_armors[@armor3_id])
    result.push($data_armors[@armor4_id])
    return result
  end
  #--------------------------------------------------------------------------
  # * Get Equipped Item Object Array
  #--------------------------------------------------------------------------
  def equips
    return weapons + armors
  end
  #--------------------------------------------------------------------------
  # * Calculate Experience
  #--------------------------------------------------------------------------
  def make_exp_list
    @exp_list[1] = @exp_list[100] = 0
    m = actor.exp_basis
    n = 0.75 + actor.exp_inflation / 200.0;
    for i in 2..99
      @exp_list[i] = @exp_list[i-1] + Integer(m)
      m *= 1 + n;
      n *= 0.9;
    end
  end
  #--------------------------------------------------------------------------
  # * Get Element Change Value
  #     element_id : element ID
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    rank = self.class.element_ranks[element_id]
    result = [0,200,150,100,50,0,-100][rank]
    for armor in armors.compact
      result /= 2 if armor.element_set.include?(element_id)
    end
    for state in states
      result /= 2 if state.element_set.include?(element_id)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Get Added State Success Rate
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_probability(state_id)
    if $data_states[state_id].nonresistance
      return 100
    else
      rank = self.class.state_ranks[state_id]
      return [0,100,80,60,40,20,0][rank]
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if State is Resisted
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state_resist?(state_id)
    for armor in armors.compact
      return true if armor.state_set.include?(state_id)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack Element
  #--------------------------------------------------------------------------
  def element_set
    result = []
    if weapons.compact == []
      return [1]                  # Unarmed: melee attribute
    end
    for weapon in weapons.compact
      result |= weapon == nil ? [] : weapon.element_set
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Get Additional Effect of Normal Attack (state change)
  #--------------------------------------------------------------------------
  def plus_state_set
    result = []
    for weapon in weapons.compact
      result |= weapon == nil ? [] : weapon.state_set
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Get Maximum HP Limit
  #--------------------------------------------------------------------------
  def maxhp_limit
    return 9999
  end
  #--------------------------------------------------------------------------
  # * Get Basic Maximum HP
  #--------------------------------------------------------------------------
  def base_maxhp
    return actor.parameters[0, @level]
  end
  #--------------------------------------------------------------------------
  # * Get basic Maximum MP
  #--------------------------------------------------------------------------
  def base_maxmp
    return actor.parameters[1, @level]
  end
  #--------------------------------------------------------------------------
  # * Get Basic Attack
  #--------------------------------------------------------------------------
  def base_atk
    n = actor.parameters[2, @level]
    for item in equips.compact do n += item.atk end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Defense
  #--------------------------------------------------------------------------
  def base_def
    n = actor.parameters[3, @level]
    for item in equips.compact do n += item.def end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Spirit
  #--------------------------------------------------------------------------
  def base_spi
    n = actor.parameters[4, @level]
    for item in equips.compact do n += item.spi end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Basic Agility
  #--------------------------------------------------------------------------
  def base_agi
    n = actor.parameters[5, @level]
    for item in equips.compact do n += item.agi end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Hit Rate
  #--------------------------------------------------------------------------
  def hit
    if two_swords_style
      n1 = weapons[0] == nil ? 95 : weapons[0].hit
      n2 = weapons[1] == nil ? 95 : weapons[1].hit
      n = [n1, n2].min
    else
      n = weapons[0] == nil ? 95 : weapons[0].hit
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Evasion Rate
  #--------------------------------------------------------------------------
  def eva
    n = 5
    for item in armors.compact do n += item.eva end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Critical Ratio
  #--------------------------------------------------------------------------
  def cri
    n = 4
    n += 4 if actor.critical_bonus
    for weapon in weapons.compact
      n += 4 if weapon.critical_bonus
    end
    return n
  end
  #--------------------------------------------------------------------------
  # * Get Ease of Hitting
  #--------------------------------------------------------------------------
  def odds
    return 4 - self.class.position
  end
  #--------------------------------------------------------------------------
  # * Get [Dual Wield] Option
  #--------------------------------------------------------------------------
  def two_swords_style
    return actor.two_swords_style
  end
  #--------------------------------------------------------------------------
  # * Get [Fixed Equipment] Option
  #--------------------------------------------------------------------------
  def fix_equipment
    return actor.fix_equipment
  end
  #--------------------------------------------------------------------------
  # * Get [Automatic Battle] Option
  #--------------------------------------------------------------------------
  def auto_battle
    return actor.auto_battle
  end
  #--------------------------------------------------------------------------
  # * Get [Super Guard] Option
  #--------------------------------------------------------------------------
  def super_guard
    return actor.super_guard
  end
  #--------------------------------------------------------------------------
  # * Get [Pharmocology] Option
  #--------------------------------------------------------------------------
  def pharmacology
    return actor.pharmacology
  end
  #--------------------------------------------------------------------------
  # * Get [First attack within turn] weapon option
  #--------------------------------------------------------------------------
  def fast_attack
    for weapon in weapons.compact
      return true if weapon.fast_attack
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get [Chain attack] weapon option
  #--------------------------------------------------------------------------
  def dual_attack
    for weapon in weapons.compact
      return true if weapon.dual_attack
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get [Prevent critical] armor option
  #--------------------------------------------------------------------------
  def prevent_critical
    for armor in armors.compact
      return true if armor.prevent_critical
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get [half MP cost] armor option
  #--------------------------------------------------------------------------
  def half_mp_cost
    for armor in armors.compact
      return true if armor.half_mp_cost
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get [Double Experience] Armor Option
  #--------------------------------------------------------------------------
  def double_exp_gain
    for armor in armors.compact
      return true if armor.double_exp_gain
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get [Auto HP Recovery] Armor Option
  #--------------------------------------------------------------------------
  def auto_hp_recover
    for armor in armors.compact
      return true if armor.auto_hp_recover
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack Animation ID
  #--------------------------------------------------------------------------
  def atk_animation_id
    if two_swords_style
      return weapons[0].animation_id if weapons[0] != nil
      return weapons[1] == nil ? 1 : 0
    else
      return weapons[0] == nil ? 1 : weapons[0].animation_id
    end
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack Animation ID (Dual Wield: Weapon 2)
  #--------------------------------------------------------------------------
  def atk_animation_id2
    if two_swords_style
      return weapons[1] == nil ? 0 : weapons[1].animation_id
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # * Get Experience String
  #--------------------------------------------------------------------------
  def exp_s
    return @exp_list[@level+1] > 0 ? @exp : "-------"
  end
  #--------------------------------------------------------------------------
  # * Get String for Next Level Experience
  #--------------------------------------------------------------------------
  def next_exp_s
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] : "-------"
  end
  #--------------------------------------------------------------------------
  # * Get String for Experience to Next Level
  #--------------------------------------------------------------------------
  def next_rest_exp_s
    return @exp_list[@level+1] > 0 ?
        (@exp_list[@level+1] - @exp) : "-------"
  end
  #--------------------------------------------------------------------------
  # * Change Equipment (designate ID)
  #     equip_type : Equip region (0..4)
  #     item_id    : Weapon ID or armor ID
  #     test       : Test flag (for battle test or temporary equipment)
  #    Used by event commands or battle test preparation.
  #--------------------------------------------------------------------------
  def change_equip_by_id(equip_type, item_id, test = false)
    if equip_type == 0 or (equip_type == 1 and two_swords_style)
      change_equip(equip_type, $data_weapons[item_id], test)
    else
      change_equip(equip_type, $data_armors[item_id], test)
    end
  end
  #--------------------------------------------------------------------------
  # * Change Equipment (designate object)
  #     equip_type : Equip region (0..4)
  #     item       : Weapon or armor (nil is used to unequip)
  #     test       : Test flag (for battle test or temporary equipment)
  #--------------------------------------------------------------------------
  def change_equip(equip_type, item, test = false)
    last_item = equips[equip_type]
    unless test
      return if $game_party.item_number(item) == 0 if item != nil
      $game_party.gain_item(last_item, 1)
      $game_party.lose_item(item, 1)
    end
    item_id = item == nil ? 0 : item.id
    case equip_type
      when 0  # Weapon
        @weapon_id = item_id
        unless two_hands_legal?             # If two hands is not allowed
          change_equip(1, nil, test)        # Unequip from other hand
        end
      when 1  # Shield
        @armor1_id = item_id
        unless two_hands_legal?             # If two hands is not allowed
          change_equip(0, nil, test)        # Unequip from other hand
        end
      when 2  # Head
        @armor2_id = item_id
      when 3  # Body
        @armor3_id = item_id
      when 4  # Accessory
        @armor4_id = item_id
    end
  end
  #--------------------------------------------------------------------------
  # * Discard Equipment
  #     item : Weapon or armor to be discarded.
  #    Used when the "Include Equipment" option is enabled.
  #--------------------------------------------------------------------------
  def discard_equip(item)
    if item.is_a?(RPG::Weapon)
      if @weapon_id == item.id
        @weapon_id = 0
      elsif two_swords_style and @armor1_id == item.id
        @armor1_id = 0
      end
    elsif item.is_a?(RPG::Armor)
      if not two_swords_style and @armor1_id == item.id
        @armor1_id = 0
      elsif @armor2_id == item.id
        @armor2_id = 0
      elsif @armor3_id == item.id
        @armor3_id = 0
      elsif @armor4_id == item.id
        @armor4_id = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Two handed Equipment
  #--------------------------------------------------------------------------
  def two_hands_legal?
    if weapons[0] != nil and weapons[0].two_handed
      return false if @armor1_id != 0
    end
    if weapons[1] != nil and weapons[1].two_handed
      return false if @weapon_id != 0
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Equippable
  #     item : item
  #--------------------------------------------------------------------------
  def equippable?(item)
    if item.is_a?(RPG::Weapon)
      return self.class.weapon_set.include?(item.id)
    elsif item.is_a?(RPG::Armor)
      return false if two_swords_style and item.kind == 0
      return self.class.armor_set.include?(item.id)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Change Experience
  #     exp  : New experience
  #     show : Level up display flag
  #--------------------------------------------------------------------------
  def change_exp(exp, show)
    last_level = @level
    last_skills = skills
    @exp = [[exp, 9999999].min, 0].max
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      level_up
    end
    while @exp < @exp_list[@level]
      level_down
    end
    @hp = [@hp, maxhp].min
    @mp = [@mp, maxmp].min
    if show and @level > last_level
      display_level_up(skills - last_skills)
    end
  end
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  def level_up
    @level += 1
    for learning in self.class.learnings
      learn_skill(learning.skill_id) if learning.level <= @level
    end
  end
  #--------------------------------------------------------------------------
  # * Level Down
  #--------------------------------------------------------------------------
  def level_down
    @level -= 1
  end
  #--------------------------------------------------------------------------
  # * Show Level Up Message
  #     new_skills : Array of newly learned skills
  #--------------------------------------------------------------------------
  def display_level_up(new_skills)
    $game_message.new_page
    text = sprintf(Vocab::LevelUp, @name, Vocab::level, @level)
    $game_message.texts.push(text)
    for skill in new_skills
      text = sprintf(Vocab::ObtainSkill, skill.name)
      $game_message.texts.push(text)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Experience (for the double experience point option)
  #     exp  : Amount to increase experience.
  #     show : Level up display flag
  #--------------------------------------------------------------------------
  def gain_exp(exp, show)
    if double_exp_gain
      change_exp(@exp + exp * 2, show)
    else
      change_exp(@exp + exp, show)
    end
  end
  #--------------------------------------------------------------------------
  # * Change Level
  #     level : new level
  #     show  : Level up display flag
  #--------------------------------------------------------------------------
  def change_level(level, show)
    level = [[level, 99].min, 1].max
    change_exp(@exp_list[level], show)
  end
  #--------------------------------------------------------------------------
  # * Learn Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    unless skill_learn?($data_skills[skill_id])
      @skills.push(skill_id)
      @skills.sort!
    end
  end
  #--------------------------------------------------------------------------
  # * Forget Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def forget_skill(skill_id)
    @skills.delete(skill_id)
  end
  #--------------------------------------------------------------------------
  # * Determine if Finished Learning Skill
  #     skill : skill
  #--------------------------------------------------------------------------
  def skill_learn?(skill)
    return @skills.include?(skill.id)
  end
  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill : skill
  #--------------------------------------------------------------------------
  def skill_can_use?(skill)
    return false unless skill_learn?(skill)
    return super
  end
  #--------------------------------------------------------------------------
  # * Change Name
  #     name : new name
  #--------------------------------------------------------------------------
  def name=(name)
    @name = name
  end
  #--------------------------------------------------------------------------
  # * Change Class ID
  #     class_id : New class ID
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    @class_id = class_id
    for i in 0..4     # Remove unequippable items
      change_equip(i, nil) unless equippable?(equips[i])
    end
  end
  #--------------------------------------------------------------------------
  # * Change Graphics
  #     character_name  : new character graphic filename
  #     character_index : new character graphic index
  #     face_name       : new face graphic filename
  #     face_index      : new face graphic index
  #--------------------------------------------------------------------------
  def set_graphic(character_name, character_index, face_name, face_index)
    @character_name = character_name
    @character_index = character_index
    @face_name = face_name
    @face_index = face_index
  end
  #--------------------------------------------------------------------------
  # * Use Sprites?
  #--------------------------------------------------------------------------
  def use_sprite?
    return false
  end
  #--------------------------------------------------------------------------
  # * Perform Collapse
  #--------------------------------------------------------------------------
  def perform_collapse
    if $game_temp.in_battle and dead?
      @collapse = true
      Sound.play_actor_collapse
    end
  end
  #--------------------------------------------------------------------------
  # * Perform Automatic Recovery (called at end of turn)
  #--------------------------------------------------------------------------
  def do_auto_recovery
    if auto_hp_recover and not dead?
      self.hp += maxhp / 20
    end
  end
  #--------------------------------------------------------------------------
  # * Create Battle Action (for automatic battle)
  #--------------------------------------------------------------------------
  def make_action
    @action.clear
    return unless movable?
    action_list = []
    action = Game_BattleAction.new(self)
    action.set_attack
    action.evaluate
    action_list.push(action)
    for skill in skills
      action = Game_BattleAction.new(self)
      action.set_skill(skill.id)
      action.evaluate
      action_list.push(action)
    end
    max_value = 0
    for action in action_list
      if action.value > max_value
        @action = action
        max_value = action.value
      end
    end
  end
end
#@return [String]
def sprintf(*args); end
def safe_clone; self; end

class RPG::Animation
  def initialize
    @id = 0
    @name = ''
    @animation1_name = ''
    @animation1_hue = 0
    @animation2_name = ''
    @animation2_hue = 0
    @position = 1
    @frame_max = 1
    @frames = [RPG::Animation::Frame.new]
    @timings = []
  end
  def to_screen?
    @position == 3
  end
  attr_accessor :id
  attr_accessor :name
  attr_accessor :animation1_name
  attr_accessor :animation1_hue
  attr_accessor :animation2_name
  attr_accessor :animation2_hue
  attr_accessor :position
  attr_accessor :frame_max
  attr_accessor :frames
  attr_accessor :timings
end

class RPG::Animation::Frame
  def initialize
    @cell_max = 0
    @cell_data = Table.new(0, 0)
  end
  attr_accessor :cell_max
  attr_accessor :cell_data
end

class RPG::Animation::Timing
  def initialize
    @frame = 0
    @se = RPG::SE.new('', 80)
    @flash_scope = 0
    @flash_color = Color.new(255,255,255,255)
    @flash_duration = 5
  end
  attr_accessor :frame
  attr_accessor :se
  attr_accessor :flash_scope
  attr_accessor :flash_color
  attr_accessor :flash_duration
end




#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within the
# Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    create_viewports
    #create_sfondobattaglia
    create_battleback
    create_battlefloor
    create_enemies
    create_actors
    create_pictures
    create_timer
    update
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewports
    w = Graphics.width
    h = Graphics.heigth
    @viewport1 = Viewport.new(0, 0, w, h)
    @viewport2 = Viewport.new(0, 0, w, h)
    @viewport3 = Viewport.new(0, 0, w, h)
    @viewport2.z = 50
    @viewport3.z = 100
  end
  #--------------------------------------------------------------------------
  # * Create Battleback Sprite
  #--------------------------------------------------------------------------
  def create_battleback
    source = $game_temp.background_bitmap
    bitmap = Bitmap.new((Graphics.width.to_f*1.15).to_i, (Graphics.height.to_f*1.15).to_i)
    bitmap.stretch_blt(bitmap.rect, source, source.rect)
    bitmap.radial_blur(90, 12)
    @battleback_sprite = Sprite.new(@viewport1)
    @battleback_sprite.bitmap = bitmap
    @battleback_sprite.ox = bitmap.width/2
    @battleback_sprite.oy = bitmap.height/2
    @battleback_sprite.x = Graphics.width/2
    @battleback_sprite.y = Graphics.height/2
    @battleback_sprite.wave_amp = 8
    @battleback_sprite.wave_length = 240
    @battleback_sprite.wave_speed = 120
  end
  #--------------------------------------------------------------------------
  # * Create Battlefloor Sprite
  #--------------------------------------------------------------------------
  def create_battlefloor
    @battlefloor_sprite = Sprite.new(@viewport1)
    #@battlefloor_sprite.bitmap = Cache.system("Battlefloor")
    @battlefloor_sprite.x = 0
    @battlefloor_sprite.y = 192
    @battlefloor_sprite.z = 1
    @battlefloor_sprite.opacity = 128
  end

  #--------------------------------------------------------------------------
  # * Create Enemy Sprite
  #--------------------------------------------------------------------------
  def create_enemies
    @enemy_sprites = []
    for enemy in $game_troop.members.reverse
      @enemy_sprites.push(Sprite_Battler.new(@viewport1, enemy))
    end
  end
  #--------------------------------------------------------------------------
  # * Create Actor Sprite
  #    By default, the actor image is not displayed, but a dummy sprite is
  #    created for treating enemies and allies the same, if required.
  #--------------------------------------------------------------------------
  def create_actors
    @actor_sprites = []
    @actor_sprites.push(Sprite_Battler.new(@viewport1))
    @actor_sprites.push(Sprite_Battler.new(@viewport1))
    @actor_sprites.push(Sprite_Battler.new(@viewport1))
    @actor_sprites.push(Sprite_Battler.new(@viewport1))
  end
  #--------------------------------------------------------------------------
  # * Create Picture Sprite
  #--------------------------------------------------------------------------
  def create_pictures
    @picture_sprites = []
    for i in 1..20
      @picture_sprites.push(Sprite_Picture.new(@viewport2,
                                               $game_troop.screen.pictures[i]))
    end
  end
  #--------------------------------------------------------------------------
  # * Create Timer Sprite
  #--------------------------------------------------------------------------
  def create_timer
    @timer_sprite = Sprite_Timer.new(@viewport2)
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    dispose_battleback_bitmap
    dispose_battleback
    dispose_battlefloor
    dispose_enemies
    dispose_actors
    dispose_pictures
    dispose_timer
    dispose_viewports
  end
  #--------------------------------------------------------------------------
  # * Dispose of Battleback Bitmap
  #--------------------------------------------------------------------------
  def dispose_battleback_bitmap
    @battleback_sprite.bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Dispose of Battleback Sprite
  #--------------------------------------------------------------------------
  def dispose_battleback
    @battleback_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Dispose of Battlefloor Sprite
  #--------------------------------------------------------------------------
  def dispose_battlefloor
    @battlefloor_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Dispose of Enemy Sprite
  #--------------------------------------------------------------------------
  def dispose_enemies
    for sprite in @enemy_sprites
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose of Actor Sprite
  #--------------------------------------------------------------------------
  def dispose_actors
    for sprite in @actor_sprites
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose of Picture Sprite
  #--------------------------------------------------------------------------
  def dispose_pictures
    for sprite in @picture_sprites
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose of Timer Sprite
  #--------------------------------------------------------------------------
  def dispose_timer
    @timer_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Dispose of Viewport
  #--------------------------------------------------------------------------
  def dispose_viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_battleback
    update_battlefloor
    update_enemies
    update_actors
    update_pictures
    update_timer
    update_viewports
  end
  #--------------------------------------------------------------------------
  # * Update Battleback
  #--------------------------------------------------------------------------
  def update_battleback
    @battleback_sprite.update
  end
  #--------------------------------------------------------------------------
  # * Update Battlefloor
  #--------------------------------------------------------------------------
  def update_battlefloor
    @battlefloor_sprite.update
  end
  #--------------------------------------------------------------------------
  # * Update Enemy Sprite
  #--------------------------------------------------------------------------
  def update_enemies
    for sprite in @enemy_sprites
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # * Update Actor Sprite
  #--------------------------------------------------------------------------
  def update_actors
    @actor_sprites[0].battler = $game_party.members[0]
    @actor_sprites[1].battler = $game_party.members[1]
    @actor_sprites[2].battler = $game_party.members[2]
    @actor_sprites[3].battler = $game_party.members[3]
    for sprite in @actor_sprites
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # *Update Picture Sprite
  #--------------------------------------------------------------------------
  def update_pictures
    for sprite in @picture_sprites
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # * Update Timer Sprite
  #--------------------------------------------------------------------------
  def update_timer
    @timer_sprite.update
  end
  #--------------------------------------------------------------------------
  # * Update Viewport
  #--------------------------------------------------------------------------
  def update_viewports
    @viewport1.tone = $game_troop.screen.tone
    @viewport1.ox = $game_troop.screen.shake
    @viewport2.color = $game_troop.screen.flash_color
    @viewport3.color.set(0, 0, 0, 255 - $game_troop.screen.brightness)
    @viewport1.update
    @viewport2.update
    @viewport3.update
  end
  #--------------------------------------------------------------------------
  # * Determine if animation is being displayed
  #--------------------------------------------------------------------------
  def animation?
    for sprite in @enemy_sprites + @actor_sprites
      return true if sprite.animation?
    end
    return false
  end
end

#==============================================================================
# ** Sprite_Base
#------------------------------------------------------------------------------
#  A sprite class with animation display processing added.
#==============================================================================

class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  # * Class Variable
  #--------------------------------------------------------------------------
  @@ani_checker = []
  @@ani_spr_checker = []
  @@_reference_count = {}
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @use_sprite = true        # Sprite use flag
    @ani_duration = 0         # Remaining time of animation
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_animation
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_animation
    @@ani_checker.clear
    @@ani_spr_checker.clear
  end
  #--------------------------------------------------------------------------
  # * Determine if animation is being displayed
  #--------------------------------------------------------------------------
  def animation?
    @animation != nil
  end
  #--------------------------------------------------------------------------
  # * Start Animation
  #--------------------------------------------------------------------------
  def start_animation(animation, mirror = false)
    dispose_animation
    @animation = animation
    if @animation
      @ani_mirror = mirror
      set_animation_rate
      @ani_duration = @animation.frame_max * @ani_rate + 1
      load_animation_bitmap
      make_animation_sprites
      set_animation_origin
    end
  end
  #--------------------------------------------------------------------------
  # * Set Animation Speed
  #--------------------------------------------------------------------------
  def set_animation_rate
    @ani_rate = 4     # Fixed value by default
  end
  #--------------------------------------------------------------------------
  # * Read (Load) Animation Graphics
  #--------------------------------------------------------------------------
  def load_animation_bitmap
    animation1_name = @animation.animation1_name
    animation1_hue = @animation.animation1_hue
    animation2_name = @animation.animation2_name
    animation2_hue = @animation.animation2_hue
    @ani_bitmap1 = Cache.animation(animation1_name, animation1_hue)
    @ani_bitmap2 = Cache.animation(animation2_name, animation2_hue)
    if @@_reference_count.include?(@ani_bitmap1)
      @@_reference_count[@ani_bitmap1] += 1
    else
      @@_reference_count[@ani_bitmap1] = 1
    end
    if @@_reference_count.include?(@ani_bitmap2)
      @@_reference_count[@ani_bitmap2] += 1
    else
      @@_reference_count[@ani_bitmap2] = 1
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # * Create Animation Spirtes
  #--------------------------------------------------------------------------
  def make_animation_sprites
    @ani_sprites = []
    if @use_sprite && !@@ani_spr_checker.include?(@animation)
      16.times do
        sprite = ::Sprite.new(viewport)
        sprite.visible = false
        @ani_sprites.push(sprite)
      end
      if @animation.position == 3
        @@ani_spr_checker.push(@animation)
      end
    end
    @ani_duplicated = @@ani_checker.include?(@animation)
    if !@ani_duplicated && @animation.position == 3
      @@ani_checker.push(@animation)
    end
  end
  #--------------------------------------------------------------------------
  # * Set Animation Origin
  #--------------------------------------------------------------------------
  def set_animation_origin
    if @animation.position == 3
      if viewport == nil
        @ani_ox = Graphics.width / 2
        @ani_oy = Graphics.height / 2
      else
        @ani_ox = viewport.rect.width / 2
        @ani_oy = viewport.rect.height / 2
      end
    else
      @ani_ox = x - ox + width / 2
      @ani_oy = y - oy + height / 2
      if @animation.position == 0
        @ani_oy -= height / 2
      elsif @animation.position == 2
        @ani_oy += height / 2
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Free Animation
  #--------------------------------------------------------------------------
  def dispose_animation
    if @ani_bitmap1
      @@_reference_count[@ani_bitmap1] -= 1
      if @@_reference_count[@ani_bitmap1] == 0
        @ani_bitmap1.dispose
      end
    end
    if @ani_bitmap2
      @@_reference_count[@ani_bitmap2] -= 1
      if @@_reference_count[@ani_bitmap2] == 0
        @ani_bitmap2.dispose
      end
    end
    if @ani_sprites
      @ani_sprites.each {|sprite| sprite.dispose }
      @ani_sprites = nil
      @animation = nil
    end
    @ani_bitmap1 = nil
    @ani_bitmap2 = nil
  end
  #--------------------------------------------------------------------------
  # * Update Animation
  #--------------------------------------------------------------------------
  def update_animation
    return unless animation?
    @ani_duration -= 1
    if @ani_duration % @ani_rate == 0
      if @ani_duration > 0
        frame_index = @animation.frame_max
        frame_index -= (@ani_duration + @ani_rate - 1) / @ani_rate
        animation_set_sprites(@animation.frames[frame_index])
        @animation.timings.each do |timing|
          animation_process_timing(timing) if timing.frame == frame_index
        end
      else
        end_animation
      end
    end
  end
  #--------------------------------------------------------------------------
  # * End Animation
  #--------------------------------------------------------------------------
  def end_animation
    dispose_animation
  end
  #--------------------------------------------------------------------------
  # * Set Animation Sprite
  #     frame : Frame data (RPG::Animation::Frame)
  #--------------------------------------------------------------------------
  def animation_set_sprites(frame)
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @ani_bitmap1 : @ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
                          pattern % 100 / 5 * 192, 192, 192)
      if @ani_mirror
        sprite.x = @ani_ox - cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 300 + i
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  #--------------------------------------------------------------------------
  # * SE and Flash Timing Processing
  #     timing : Timing data (RPG::Animation::Timing)
  #--------------------------------------------------------------------------
  def animation_process_timing(timing)
    timing.se.play unless @ani_duplicated
    case timing.flash_scope
      when 1
        self.flash(timing.flash_color, timing.flash_duration * @ani_rate)
      when 2
        if viewport && !@ani_duplicated
          viewport.flash(timing.flash_color, timing.flash_duration * @ani_rate)
        end
      when 3
        self.flash(nil, timing.flash_duration * @ani_rate)
    end
  end
end


#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  Questa classe contiene le mappe. Include i termini di scrolling e passaggio.
#  L'istanza di questa classe fa riferimento a $game_map.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  #--------------------------------------------------------------------------
  attr_reader   :screen                   # stato dello schermo su mappa
  attr_reader   :interpreter              # interprete dell'evento
  attr_reader   :display_x                # coordinata X schermo * 256
  attr_reader   :display_y                # coordinata Y schermo * 256
  attr_reader   :parallax_name            # nome del file di parallasse
  attr_reader   :passages                 # tavola dei passaggi
  attr_reader   :events                   # eventi
  attr_reader   :vehicles                 # veicoli
  attr_accessor :need_refresh             # flag di refresh mappa
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    @screen = Game_Screen.new
    @interpreter = Game_Interpreter.new(0, true)
    @map_id = 0
    @display_x = 0
    @display_y = 0
    create_vehicles
  end
  #--------------------------------------------------------------------------
  # * Settaggio
  #     map_id : ID mappa
  #--------------------------------------------------------------------------
  def setup(map_id)
    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rvdata", @map_id))
    @display_x = 0
    @display_y = 0
    @passages = $data_system.passages
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    @need_refresh = false
  end
  #--------------------------------------------------------------------------
  # * Crea Veicoli
  #--------------------------------------------------------------------------
  def create_vehicles
    @vehicles = []
    @vehicles[0] = Game_Vehicle.new(0)    # Barca
    @vehicles[1] = Game_Vehicle.new(1)    # Nave
    @vehicles[2] = Game_Vehicle.new(2)    # Eereonave
  end
  #--------------------------------------------------------------------------
  # * Refresh Veicoli
  #--------------------------------------------------------------------------
  def referesh_vehicles
    for vehicle in @vehicles
      vehicle.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Ottieni Barca
  #--------------------------------------------------------------------------
  def boat
    return @vehicles[0]
  end
  #--------------------------------------------------------------------------
  # * Ottieni Nave
  #--------------------------------------------------------------------------
  def ship
    return @vehicles[1]
  end
  #--------------------------------------------------------------------------
  # * Ottieni Aereonave
  #--------------------------------------------------------------------------
  def airship
    return @vehicles[2]
  end
  #--------------------------------------------------------------------------
  # * Settaggio Eventi
  #--------------------------------------------------------------------------
  def setup_events
    @events = {}          # Eventi su mappa
    for i in @map.events.keys
      @events[i] = Game_Event.new(@map_id, @map.events[i])
    end
    @common_events = {}   # Eventi comuni
    for i in 1...$data_common_events.size
      @common_events[i] = Game_CommonEvent.new(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Settaggi Scrolling
  #--------------------------------------------------------------------------
  def setup_scroll
    @scroll_direction = 2
    @scroll_rest = 0
    @scroll_speed = 4
    @margin_x = (width - 17) * 256 / 2      # Margine di larghezza /2
    @margin_y = (height - 13) * 256 / 2     # Margine di altezza /2
  end
  #--------------------------------------------------------------------------
  # * Settaggi di sfondo di parallasse
  #--------------------------------------------------------------------------
  def setup_parallax
    @parallax_name = @map.parallax_name
    @parallax_loop_x = @map.parallax_loop_x
    @parallax_loop_y = @map.parallax_loop_y
    @parallax_sx = @map.parallax_sx
    @parallax_sy = @map.parallax_sy
    @parallax_x = 0
    @parallax_y = 0
  end
  #--------------------------------------------------------------------------
  # * Setta la posizione dello schermo
  #     x : Nuova coordinata X dello schermo (*256)
  #     y : Nuova coordinata Y dello schermo (*256)
  #--------------------------------------------------------------------------
  def set_display_pos(x, y)
    @display_x = (x + @map.width * 256) % (@map.width * 256)
    @display_y = (y + @map.height * 256) % (@map.height * 256)
    @parallax_x = x
    @parallax_y = y
  end
  #--------------------------------------------------------------------------
  # * Calcola la coordinata X per il parallasse
  #     bitmap : immagine di parallasse
  #--------------------------------------------------------------------------
  def calc_parallax_x(bitmap)
    if bitmap == nil
      return 0
    elsif @parallax_loop_x
      return @parallax_x / 16
    elsif loop_horizontal?
      return 0
    else
      w1 = bitmap.width - 544
      w2 = @map.width * 32 - 544
      if w1 <= 0 or w2 <= 0
        return 0
      else
        return @parallax_x * w1 / w2 / 8
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Calcola la coordinata Y per il parallasse
  #     bitmap : immagine di parallasse
  #--------------------------------------------------------------------------
  def calc_parallax_y(bitmap)
    if bitmap == nil
      return 0
    elsif @parallax_loop_y
      return @parallax_y / 16
    elsif loop_vertical?
      return 0
    else
      h1 = bitmap.height - 416
      h2 = @map.height * 32 - 416
      if h1 <= 0 or h2 <= 0
        return 0
      else
        return @parallax_y * h1 / h2 / 8
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Ottieni ID Mappa
  #--------------------------------------------------------------------------
  def map_id; @map_id; end
  #--------------------------------------------------------------------------
  # * Ottieni Larghezza Mappa
  #--------------------------------------------------------------------------
  def width; @map.width; end
  #--------------------------------------------------------------------------
  # * Ottieni Altezza Mappa
  #--------------------------------------------------------------------------
  def height; @map.height; end
  #--------------------------------------------------------------------------
  # * Loop orizzontale?
  #--------------------------------------------------------------------------
  def loop_horizontal?
    return (@map.scroll_type == 2 or @map.scroll_type == 3)
  end
  #--------------------------------------------------------------------------
  # * Loop verticale?
  #--------------------------------------------------------------------------
  def loop_vertical?
    return (@map.scroll_type == 1 or @map.scroll_type == 3)
  end
  #--------------------------------------------------------------------------
  # * Condizione se la Corsa è disabilitata
  #--------------------------------------------------------------------------
  def disable_dash?
    return @map.disable_dashing
  end
  #--------------------------------------------------------------------------
  # * Ottieni la lista degli incontri casuali
  #--------------------------------------------------------------------------
  def encounter_list
    return @map.encounter_list
  end
  #--------------------------------------------------------------------------
  # * Ottieni la probabilità degli incontri
  #--------------------------------------------------------------------------
  def encounter_step
    return @map.encounter_step
  end
  #--------------------------------------------------------------------------
  # * Ottieni i dati Mappa
  #--------------------------------------------------------------------------
  def data
    return @map.data
  end
  #--------------------------------------------------------------------------
  # * Calcola la coordinata X meno la coordinata del Display
  #     x : coordinata-x
  #--------------------------------------------------------------------------
  def adjust_x(x)
    if loop_horizontal? and x < @display_x - @margin_x
      return x - @display_x + @map.width * 256
    else
      return x - @display_x
    end
  end
  #--------------------------------------------------------------------------
  # * Calcola la coordinata Y meno la coordinata del Display
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def adjust_y(y)
    if loop_vertical? and y < @display_y - @margin_y
      return y - @display_y + @map.height * 256
    else
      return y - @display_y
    end
  end
  #--------------------------------------------------------------------------
  # * Calcola la coordinata X dopo la regolazione del loop
  #     x : coordinata-x
  #--------------------------------------------------------------------------
  def round_x(x)
    if loop_horizontal?
      return (x + width) % width
    else
      return x
    end
  end
  #--------------------------------------------------------------------------
  # * Calcola la coordinata Y dopo la regolazione del loop
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def round_y(y)
    if loop_vertical?
      return (y + height) % height
    else
      return y
    end
  end
  #--------------------------------------------------------------------------
  # * Calcola la coordinata X di un tile in una particolare direzione
  #     x         : coordinata-x
  #     direction : direzione  (2,4,6,8)
  #--------------------------------------------------------------------------
  def x_with_direction(x, direction)
    return round_x(x + (direction == 6 ? 1 : direction == 4 ? -1 : 0))
  end
  #--------------------------------------------------------------------------
  # * Calcola la coordinata Y di un tile in una particolare direzione
  #     y         : coordinata-y
  #     direction : direzione  (2,4,6,8)
  #--------------------------------------------------------------------------
  def y_with_direction(y, direction)
    return round_y(y + (direction == 2 ? 1 : direction == 8 ? -1 : 0))
  end
  #--------------------------------------------------------------------------
  # * Ottieni l'array degli eventi alla coordinata designata.
  #     x : coordinata-x
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def events_xy(x, y)
    result = []
    for event in $game_map.events.values
      result.push(event) if event.pos?(x, y)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Cambia automaticamente BGM e BGS
  #--------------------------------------------------------------------------
  def autoplay
    @map.bgm.play if @map.autoplay_bgm
    @map.bgs.play if @map.autoplay_bgs
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if @map_id > 0
      for event in @events.values
        event.refresh
      end
      for common_event in @common_events.values
        common_event.refresh
      end
    end
    @need_refresh = false
  end
  #--------------------------------------------------------------------------
  # * Scorri Giù
  #     distance : distanza di scorrimento
  #--------------------------------------------------------------------------
  def scroll_down(distance)
    if loop_vertical?
      @display_y += distance
      @display_y %= @map.height * 256
      @parallax_y += distance
    else
      last_y = @display_y
      @display_y = [@display_y + distance, (height - 13) * 256].min
      @parallax_y += @display_y - last_y
    end
  end
  #--------------------------------------------------------------------------
  # * Scorri Sinistra
  #     distance : distanza di scorrimento
  #--------------------------------------------------------------------------
  def scroll_left(distance)
    if loop_horizontal?
      @display_x += @map.width * 256 - distance
      @display_x %= @map.width * 256
      @parallax_x -= distance
    else
      last_x = @display_x
      @display_x = [@display_x - distance, 0].max
      @parallax_x += @display_x - last_x
    end
  end
  #--------------------------------------------------------------------------
  # * Scorri Destra
  #     distance : distanza di scorrimento
  #--------------------------------------------------------------------------
  def scroll_right(distance)
    if loop_horizontal?
      @display_x += distance
      @display_x %= @map.width * 256
      @parallax_x += distance
    else
      last_x = @display_x
      @display_x = [@display_x + distance, (width - 17) * 256].min
      @parallax_x += @display_x - last_x
    end
  end
  #--------------------------------------------------------------------------
  # * Scorri Su
  #     distance : distanza di scorrimento
  #--------------------------------------------------------------------------
  def scroll_up(distance)
    if loop_vertical?
      @display_y += @map.height * 256 - distance
      @display_y %= @map.height * 256
      @parallax_y -= distance
    else
      last_y = @display_y
      @display_y = [@display_y - distance, 0].max
      @parallax_y += @display_y - last_y
    end
  end
  #--------------------------------------------------------------------------
  # * Determina coordinate valide
  #     x : coordinata-x
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def valid?(x, y)
    return (x >= 0 and x < width and y >= 0 and y < height)
  end
  #--------------------------------------------------------------------------
  # * Determina se passabile
  #     x    : coordinata x
  #     y    : coordinata y
  #     flag : determina se il tile è passabile o no
  #            (normalmente è 0x01, cambia solo con i veicoli)
  #--------------------------------------------------------------------------
  def passable?(x, y, flag = 0x01)
    for event in events_xy(x, y)            # eventi con le stesse coordinate
      next if event.tile_id == 0            # non sono assegnati tile grafici
      next if event.priority_type > 0       # passabile (sotto l'eroe)
      next if event.through                 # attraversabile
      pass = @passages[event.tile_id]       # ottieni l'attributo passabile
      next if pass & 0x10 == 0x10           # *: Non influisce sul passaggio
      return true if pass & flag == 0x00    # o: Passabile
      return false if pass & flag == flag   # x: Non passabile
    end
    for i in [2, 1, 0]                      # in ordine dal livello più alto
      tile_id = @map.data[x, y, i]          # ottieni l'ID del tile
      return false if tile_id == nil        # fallito di ottenere il tile: non passabile
      pass = @passages[tile_id]             # ottieni l'attributo passabile
      next if pass & 0x10 == 0x10           # *: Non influisce sul passaggio
      return true if pass & flag == 0x00    # o: Passabile
      return false if pass & flag == flag   # x: Non passabile
    end
    return false                            # Non passabile
  end
  #--------------------------------------------------------------------------
  # * Determina se la Barca può passare
  #     x : coordinata-x
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def boat_passable?(x, y)
    return passable?(x, y, 0x02)
  end
  #--------------------------------------------------------------------------
  # * Determina se la Nave può passare
  #     x : coordinata-x
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def ship_passable?(x, y)
    return passable?(x, y, 0x04)
  end
  #--------------------------------------------------------------------------
  # * Determina se l'Aereonave può atterrare
  #     x : coordinata-x
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def airship_land_ok?(x, y)
    return passable?(x, y, 0x08)
  end
  #--------------------------------------------------------------------------
  # * Determina la boscaglia (copre una parte del personaggio)
  #     x : coordinata-x
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def bush?(x, y)
    return false unless valid?(x, y)
    return @passages[@map.data[x, y, 1]] & 0x40 == 0x40
  end
  #--------------------------------------------------------------------------
  # * Conta Passi
  #     x : coordinata-x
  #     y : coordinata-y
  #--------------------------------------------------------------------------
  def counter?(x, y)
    return false unless valid?(x, y)
    return @passages[@map.data[x, y, 0]] & 0x80 == 0x80
  end
  #--------------------------------------------------------------------------
  # * Inizio scorrimento schermo
  #     direction : direzione scorrimento
  #     distance  : distanza scorrimento
  #     speed     : velocità scorrimento
  #--------------------------------------------------------------------------
  def start_scroll(direction, distance, speed)
    @scroll_direction = direction
    @scroll_rest = distance * 256
    @scroll_speed = speed
  end
  #--------------------------------------------------------------------------
  # * Determina se si sta muovendo lo schermo
  #--------------------------------------------------------------------------
  def scrolling?
    return @scroll_rest > 0
  end
  #--------------------------------------------------------------------------
  # * Aggiorna Frame
  #--------------------------------------------------------------------------
  def update
    refresh if $game_map.need_refresh
    update_scroll
    update_events
    update_vehicles
    update_parallax
    @screen.update
  end
  #--------------------------------------------------------------------------
  # * Aggiorna Scorrimento
  #--------------------------------------------------------------------------
  def update_scroll
    if @scroll_rest > 0                 # Se si sta muovendo
      distance = 2 ** @scroll_speed     # Converti in distanza
      case @scroll_direction
        when 2  # Giù
          scroll_down(distance)
        when 4  # Sinistra
          scroll_left(distance)
        when 6  # Destra
          scroll_right(distance)
        when 8  # Su
          scroll_up(distance)
      end
      @scroll_rest -= distance          # Sottrai la distanza di scorrimento
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna Eventi
  #--------------------------------------------------------------------------
  def update_events
    for event in @events.values
      event.update
    end
    for common_event in @common_events.values
      common_event.update
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna Veicoli
  #--------------------------------------------------------------------------
  def update_vehicles
    for vehicle in @vehicles
      vehicle.update
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna Parallasse
  #--------------------------------------------------------------------------
  def update_parallax
    @parallax_x += @parallax_sx * 4 if @parallax_loop_x
    @parallax_y += @parallax_sy * 4 if @parallax_loop_y
  end
end

#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  This class performs the item screen processing.
#==============================================================================

class Scene_Item < Scene_Base
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @viewport = Viewport.new(0, 0, 640, 480)
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
    @item_window = Window_Item.new(0, 56, 640, 424)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.active = false
    @target_window = Window_MenuStatus.new(0, 0)
    hide_target_window
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @viewport.dispose
    @help_window.dispose
    @item_window.dispose
    @target_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Return to Original Screen
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Menu.new(0)
  end
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @help_window.update
    @item_window.update
    @target_window.update
    if @item_window.active
      update_item_selection
    elsif @target_window.active
      update_target_selection
    end
  end
  #--------------------------------------------------------------------------
  # * Update Item Selection
  #--------------------------------------------------------------------------
  def update_item_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      return_scene
    elsif Input.trigger?(Input::C)
      @item = @item_window.item
      if @item != nil
        $game_party.last_item_id = @item.id
      end
      if $game_party.item_can_use?(@item)
        Sound.play_decision
        determine_item
      else
        Sound.play_buzzer
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Confirm Item
  #--------------------------------------------------------------------------
  def determine_item
    if @item.for_friend?
      show_target_window(@item_window.index % 2 == 0)
      if @item.for_all?
        @target_window.index = 99
      else
        if $game_party.last_target_index < @target_window.item_max
          @target_window.index = $game_party.last_target_index
        else
          @target_window.index = 0
        end
      end
    else
      use_item_nontarget
    end
  end
  #--------------------------------------------------------------------------
  # * Update Target Selection
  #--------------------------------------------------------------------------
  def update_target_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      if $game_party.item_number(@item) == 0    # If item is used up
        @item_window.refresh                    # Recreate the window contents
      end
      hide_target_window
    elsif Input.trigger?(Input::C)
      if not $game_party.item_can_use?(@item)
        Sound.play_buzzer
      else
        determine_target
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Confirm Target
  #    If there is no effect (such as using a potion on an incapacitated
  #    character), play a buzzer SE.
  #--------------------------------------------------------------------------
  def determine_target
    used = false
    if @item.for_all?
      for target in $game_party.members
        target.item_effect(target, @item)
        used = true unless target.skipped
      end
    else
      $game_party.last_target_index = @target_window.index
      target = $game_party.members[@target_window.index]
      target.item_effect(target, @item)
      used = true unless target.skipped
    end
    if used
      use_item_nontarget
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Show Target Window
  #     right : Right justification flag (if false, left justification)
  #--------------------------------------------------------------------------
  def show_target_window(right)
    @item_window.active = false
    width_remain = 544 - @target_window.width
    @target_window.x = right ? width_remain : 0
    @target_window.visible = true
    @target_window.active = true
    #if right
    #  @viewport.rect.set(0, 0, width_remain, 416)
    #  @viewport.ox = 0
    #else
    #  @viewport.rect.set(@target_window.width, 0, width_remain, 416)
    #  @viewport.ox = @target_window.width
    #end
  end
  #--------------------------------------------------------------------------
  # * Hide Target Window
  #--------------------------------------------------------------------------
  def hide_target_window
    @item_window.active = true
    @target_window.visible = false
    @target_window.active = false
    @viewport.rect.set(0, 0, 640, 480)
    @viewport.ox = 0
  end
  #--------------------------------------------------------------------------
  # * Use Item (apply effects to non-ally targets)
  #--------------------------------------------------------------------------
  def use_item_nontarget
    Sound.play_use_item
    $game_party.consume_item(@item)
    @item_window.draw_item(@item_window.index)
    @target_window.refresh
    if $game_party.all_dead?
      $scene = Scene_Gameover.new
    elsif @item.common_event_id > 0
      $game_temp.common_event_id = @item.common_event_id
      $scene = Scene_Map.new
    end
  end
end

#==============================================================================
# ** Scene_Save
#------------------------------------------------------------------------------
#  This class performs save screen processing.
#==============================================================================

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Get Help Window Text
  #--------------------------------------------------------------------------
  def help_window_text
    Vocab::SaveMessage
  end
  #--------------------------------------------------------------------------
  # * Get File Index to Select First
  #--------------------------------------------------------------------------
  def first_savefile_index
    DataManager.last_savefile_index
  end
  #--------------------------------------------------------------------------
  # * Confirm Save File
  #--------------------------------------------------------------------------
  def on_savefile_ok
    super
    if DataManager.save_game(@index)
      on_save_success
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When Save Is Successful
  #--------------------------------------------------------------------------
  def on_save_success
    Sound.play_save
    return_scene
  end
end

#==============================================================================
# ** Scene_Load
#------------------------------------------------------------------------------
#  This class performs load screen processing.
#==============================================================================

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Get Help Window Text
  #--------------------------------------------------------------------------
  def help_window_text
    Vocab::LoadMessage
  end
  #--------------------------------------------------------------------------
  # * Get File Index to Select First
  #--------------------------------------------------------------------------
  def first_savefile_index
    DataManager.latest_savefile_index
  end
  #--------------------------------------------------------------------------
  # * Confirm Save File
  #--------------------------------------------------------------------------
  def on_savefile_ok
    super
    if DataManager.load_game(@index)
      on_load_success
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When Load Is Successful
  #--------------------------------------------------------------------------
  def on_load_success
    Sound.play_load
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
end

#==============================================================================
# ** Scene_End
#------------------------------------------------------------------------------
#  This class performs game over screen processing.
#==============================================================================

class Scene_End < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
  end
  #--------------------------------------------------------------------------
  # * Pre-Termination Processing
  #--------------------------------------------------------------------------
  def pre_terminate
    super
    close_command_window
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    super
    @background_sprite.tone.set(0, 0, 0, 128)
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_GameEnd.new
    @command_window.set_handler(:to_title, method(:command_to_title))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
    @command_window.set_handler(:cancel,   method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Close Command Window
  #--------------------------------------------------------------------------
  def close_command_window
    @command_window.close
    update until @command_window.close?
  end
  #--------------------------------------------------------------------------
  # * [Go to Title] Command
  #--------------------------------------------------------------------------
  def command_to_title
    close_command_window
    fadeout_all
    SceneManager.goto(Scene_Title)
  end
  #--------------------------------------------------------------------------
  # * [Shut Down] Command
  #--------------------------------------------------------------------------
  def command_shutdown
    close_command_window
    fadeout_all
    SceneManager.exit
  end
end


class Game_System
  def on_after_load

  end
end

$game_party = Game_Party.new
$data_items = []
$data_armors = []
$data_weapons = []
$data_actors = []
$data_system = RPG::Data.new
$data_states = []
$data_actors = []
$game_system = Game_System.new
$game_troop = Game_Troop.new
$game_map = Game_Map.new
$scene = Scene_Base.new
$TEST = false
$BTEST = false

require File.expand_path('universal_module')
require File.expand_path('script_updater')
require File.expand_path('Localization')
require File.expand_path('system.rb')
require File.expand_path('Online.rb')
require File.expand_path('element_attack')
require File.expand_path('sinergia')
require File.expand_path('support_windows')
require File.expand_path('PlayerInfo')
require File.expand_path('DialogWindow')
require File.expand_path('Options')
require File.expand_path('FaceCache.rb')
require File.expand_path('window_emoji')
require File.expand_path('equip_enchant')
require File.expand_path('yem_equip')
require File.expand_path('yem_skill')
require File.expand_path('window_enanchement')
require File.expand_path('EnhancedSprite')
require File.expand_path('smooth_movements')
require File.expand_path('bitmap')
require File.expand_path('Attributi')
require File.expand_path('Skill_Requirements')
require File.expand_path('item_rarity')
require File.expand_path('battle_hud')
require File.expand_path('new_items')
require File.expand_path('item_expand')
require File.expand_path('new_equip')
require File.expand_path('achievements')
require File.expand_path('controller')


