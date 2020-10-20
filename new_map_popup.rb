
#===============================================================================
# * Impostazioni Popup
#===============================================================================
module Popup_Settings
  # Impostazioni generali
  SHOW_ITEMS = true
  SHOW_GOLD = true
  SHOW_LOST = true
  SHOW_LEVEL_UP = true
  SHOW_OBTAINED_SKILLS = true
  #Imposta lo switch che verrà usato per attivare e disattivare i popup
  #automatici, nel caso tu voglia cambiare denaro e oggetti al giocatore senza
  #che se ne accorga.
  POPUP_SWITCH_DISABLE = 429

  # Impostazioni di grafica
  POPUP_FONTS = ['VL PGothic']
  POPUP_CONTENT_SIZE = 22
  POPUP_TITLE_SIZE = 11
  POPUP_BOLD = 'False'
  POPUP_COLOR = Color::WHITE
  POPUP_ITALIC = false
  POPUP_SHADOW = false
  POPUP_OUTLINE = false
  POPUP_BACKGROUND_IMAGE = "BarraPopup"

  SCREEN_X = 5
  SCREEN_Y = 300
  DISTANCE = 3
  PADDING = 4
  LIFE = 240 #frame, tempo di vita del popup
  SPEED = 4 # più è alto e più è lento a far comparire i popup
  POP_TIMING = 30 # in frame, la distanza tra un popup e l'altro se escono contemporaneamente

  ITEM_TONE = Tone.new(-40,20,50,10)
  GOLD_TONE = Tone.new(-50,70,0,10)
  LOST_TONE = Tone.new(70,0,-50,50)
  LVUP_TONE = Tone.new(50, 50,100,0)
  SKLL_TONE = Tone.new(50, 50,50,0)
  DEFAULT_TONE = Tone.new(0, 0, 0, 0)

  # Impostazione Vocaboli
  VOCAB_OBTAINED = 'Ottieni '
  VOCAB_LOST = 'Hai perso '
  LEVEL_UP = '%s sale al livello %d!'
  NEW_SKILL = ' impara '

  ITEM_SOUND = 'Item1'
  GOLD_SOUND = 'Shop'
  LEVEL_UP_SOUND = 'Chime2'

end

$imported = {} if $imported == nil
$imported["H87_Popup"] = 2.0

#===============================================================================
# * Classe Game_System
#===============================================================================
class Game_System
  alias h87_popup_oal on_after_load unless $@

  def popup_disabled?
    $game_switches[Popup_Settings::POPUP_SWITCH_DISABLE]
  end

  # cancella tutti i popup al caricamento della partita.
  def on_after_load
    h87_popup_oal
    $game_map.init_popups
  end
end

#===============================================================================
# * Vocab
#===============================================================================
module Vocab
  def self.item_obtained_popup
    Popup_Settings::VOCAB_OBTAINED
  end

  def self.item_lost_popup
    Popup_Settings::VOCAB_LOST
  end
end

#===============================================================================
# * Classe Map_Popup_Data
# Contiene le informazioni (posizione, immagine, opacità) dello sprite popup in
# mappa
#===============================================================================
class Map_Popup_Data
  include Smooth_Movements
  include Popup_Settings
  include Fade_Engine

  attr_accessor :x
  attr_accessor :y
  attr_accessor :opacity
  attr_accessor :tone

  attr_reader :id
  attr_reader :width
  attr_reader :height
  attr_accessor :opacity

  # @param [Integer] id
  # @param [Array<String,Integer>] data
  # @param [Tone] tone
  def initialize(id, data, tone = nil)
    @opacity = 255
    @id = id
    @data = data
    @tone = tone ? tone : DEFAULT_TONE
    @width = Cache.picture(POPUP_BACKGROUND_IMAGE).width
    @height = Cache.picture(POPUP_BACKGROUND_IMAGE).height
    @x = 0 - width
    @y = SCREEN_Y
    @life = LIFE
    fade_engine_init
    @speed = SPEED
  end

  # @return [Bitmap]
  def generate_bitmap
    height = Cache.picture(POPUP_BACKGROUND_IMAGE).height
    bitmap = Bitmap.new(Graphics.width, height)
    bitmap.font.name = POPUP_FONTS
    bitmap.font.color = POPUP_COLOR
    bitmap.font.shadow = POPUP_SHADOW
    bitmap.font.outline = POPUP_OUTLINE
    bitmap.font.italic = POPUP_ITALIC
    bitmap.font.bold = POPUP_BOLD
    bitmap.font.size = POPUP_CONTENT_SIZE
    draw_data(bitmap)
    bitmap
  end

  def padding
    PADDING
  end

  def distance
    DISTANCE
  end

  def pop_in
    smooth_move(SCREEN_X, SCREEN_Y)
  end

  def slide
    new_x = SCREEN_X
    new_y = @new_y - @height - distance
    smooth_move(new_x, new_y)
  end

  def update
    update_smooth_movements
    fade_engine_update
    update_life
  end

  def transparent?
    @opacity <= 0
  end

  private

  def update_life
    @life -= 1
    return if @life > 0
    fade 0,2
  end

  # @param [Bitmap] bitmap
  def draw_data(bitmap)
    x = PADDING
    y = PADDING
    h = bitmap.height - PADDING * 2
    w = bitmap.width - PADDING * 2

    @data.each do |data|
      spacing = fetch_and_write(x, y, w, h, bitmap, data)
      x += spacing
      w -= spacing
    end
  end

  # se il dato è intero, disegna un'icona, altrimenti il testo
  # restituisce lo spazio consumato
  # @param [Integer] x
  # @param [Integer] width
  # @param [Bitmap] bitmap
  # @param [String,Integer] data
  # @return [Integer]
  def fetch_and_write(x, y, width, height, bitmap, data)
    if data.is_a?(String)
      bitmap.draw_text(x, y, width, height, data)
      bitmap.text_size(data.to_s).width
    elsif data.is_a?(Integer)
      bitmap.draw_icon(data.to_i, x, (y + height - 24) / 2)
      24
    end
  end
end

#===============================================================================
# * Classe Game_Map
#===============================================================================
class Game_Map
  alias h87_popup_initialize initialize unless $@
  alias h87_popup_update update unless $@
  # @return [Array<Hash>]
  attr_accessor :popup_stack
  # @return [Hash{Integer->Map_Popup_Data}]
  attr_accessor :popups

  def initialize
    h87_popup_initialize
    init_popups
  end

  def update
    h87_popup_update
    update_popups
    update_stack
  end

  def update_popups
    @popups.each_value { |popup| popup.update}
    #noinspection RubyUnusedLocalVariable
    @popups.delete_if {|_id, popup| popup.transparent?}
  end

  def update_stack
    init_popups if @popup_stack_timer.nil?
    @popup_stack_timer -= 1
    return if @popup_stack_timer > 0
    return if @popup_stack.empty?
    data = @popup_stack.shift
    add_popup data[:data], data[:tone]
    RPG::SE.new(data[:sound]).play if data[:sound] != nil
  end

  def init_popups
    @popup_stack = []
    @popups = {}
    @popup_counter = 0
    @popup_stack_timer = 0
  end

  # @param [Array<String,Integer> or String] data
  # @param [Tone] tone
  def stack_popup(data, tone = nil, sound = nil)
    data = [data] if data.is_a?(String)
    init_popups if @popup_stack.nil?
    @popup_stack.push({:data => data, :tone => tone, :sound => sound})
  end

  # @param [Array<String,Integer>] data
  # @param [Tone] tone
  def add_popup(data, tone = nil)
    @popups.each_value { |popup| popup.slide}
    @popup_counter += 1
    @popup_stack_timer = Popup_Settings::POP_TIMING
    @popups[@popup_counter] = Map_Popup_Data.new(@popup_counter, data, tone)
    @popups[@popup_counter].pop_in
    if SceneManager.scene.is_a?(Scene_Map)
      SceneManager.scene.trigger_popup_graphic(@popup_counter)
    end
  end
end

#===============================================================================
# * Classe Sprite_Popup
# Contiene sfondo e testo del popup
#===============================================================================
class Sprite_Popup < Sprite_Container
  attr_accessor :popup_id
  # @param [Viewport] viewport
  # @param [Integer] popup_id
  def initialize(viewport, popup_id)
    super(viewport)
    @popup_id = popup_id
    copy_popup_bitmap
    copy_popup_data
  end

  def update
    return if disposed?
    super
    copy_popup_data
  end

  def copy_popup_bitmap
    popup = $game_map.popups[@popup_id]
    return if popup.nil?
    add_bitmap Cache.picture(Popup_Settings::POPUP_BACKGROUND_IMAGE)
    add_bitmap popup.generate_bitmap
    sprites.first.tone = popup.tone
  end

  def copy_popup_data
    popup = $game_map.popups[@popup_id]
    if popup.nil?
      dispose
      return
    end
    self.x = popup.x
    self.y = popup.y
    self.opacity = popup.opacity
  end
end

#===============================================================================
# * Classe Spriteset_Map
#===============================================================================
class Spriteset_Map
  alias h87_popup_initialize initialize unless $@
  alias h87_popup_update update unless $@
  alias h87_popup_dispose dispose unless $@
  def initialize
    create_popups
    h87_popup_initialize
  end

  def update
    h87_popup_update
    update_popups
  end

  def dispose
    h87_popup_dispose
    dispose_popups
  end

  def trigger_popup(popup_id)
    @popups.add(popup_id)
  end

  def create_popups
    @popups = Spriteset_Popups.new
    @popups.update
  end

  def update_popups
    @popups.update
  end

  def dispose_popups
    @popups.dispose
  end
end

#===============================================================================
# * Classe Spriteset_Popups
# Contiene gli Sprite_Popup
#===============================================================================
class Spriteset_Popups
  # @return [Array<Sprite_Popup>]
  attr_accessor :sprites

  # @param [Viewport] viewport
  def initialize(viewport = nil)
    @viewport = viewport
    @sprites = generate_sprites
  end

  def viewport=(new_viewport)
    @viewport = new_viewport
    @sprites.each { |sprite| sprite.viewport = new_viewport }
  end

  # @return [Array<Sprite_Popup>]
  def generate_sprites
    $game_map.init_popups if $game_map.popups.nil?
    @sprites = $game_map.popups.values.map { |popup| Sprite_Popup.new(@viewport, popup.id) }
  end

  def add(popup_id)
    @sprites.push(Sprite_Popup.new(@viewport, popup_id))
  end

  def update
    @sprites.each { |sprite| sprite.update }
    @sprites.delete_if { |sprite| sprite.disposed? }
  end

  def dispose
    @sprites.each { |sprite| sprite.dispose }
  end
end

#===============================================================================
# * Classe Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  def trigger_popup_graphic(popup_id)
    return if @spriteset.nil?
    @spriteset.trigger_popup(popup_id)
  end
end

#===============================================================================
# * Classe Game_Party
#===============================================================================
class Game_Party < Game_Unit
  alias h87_popup_gain_item gain_item unless $@
  alias h87_popup_gain_gold gain_gold unless $@

  def gain_item(item, n, include_equip = false)
    process_popup_item(item, n)
    h87_popup_gain_item(item, n, include_equip)
  end

  def gain_gold(n)
    process_popup_gold(n)
    h87_popup_gain_gold(n)
  end

  # mostra il popup di oggetto ottenuto o rimosso
  # @param [RPG::Item, RPG::Armor, RPG::Weapon] item
  # @param [Integer] n
  def process_popup_item(item, n)
    return if item.nil?
    return if n == 0
    return if $game_system.popup_disabled?
    return unless SceneManager.scene.is_a?(Scene_Map)
    if n > 0
      tone = Popup_Settings::ITEM_TONE
      text = Vocab.item_obtained_popup
    else
      tone = Popup_Settings::LOST_TONE
      text = Vocab.item_lost_popup
    end
    data = [text, item.icon_index, item.name]
    if n.abs > 1
      data.push(sprintf(' x%d', n.abs))
    end
    RPG::SE.new(Popup_Settings::ITEM_SOUND).play
    $game_map.add_popup(data, tone)
  end

  def process_popup_gold(n)
    return if n == 0
    return if $game_system.popup_disabled?
    return unless SceneManager.scene.is_a?(Scene_Map)
    if n > 0
      tone = Popup_Settings::GOLD_TONE
      text = Vocab.item_obtained_popup
    else
      tone = Popup_Settings::LOST_TONE
      text = Vocab.item_lost_popup
    end
    data = [sprintf('%s%d %s', text, n.abs, Vocab.currency_unit)]
    RPG::SE.new(Popup_Settings::GOLD_SOUND).play
    $game_map.add_popup(data, tone)
  end
end

#===============================================================================
# * Classe Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  alias display_level_up_wo_popup display_level_up unless $@

  # @param [Array<RPG::Skill>] new_skills
  def display_level_up(new_skills)
    if SceneManager.scene.is_a?(Scene_Map) and !$game_system.popup_disabled?
      show_level_up_popup(new_skills)
    else
      display_level_up_wo_popup(new_skills)
    end
  end

  # @param [Array<RPG::Skill>] new_skills
  def show_level_up_popup(new_skills)
    text = sprintf(Popup_Settings::LEVEL_UP, self.name, self.level)
    $game_map.stack_popup([text], Popup_Settings::LVUP_TONE, Popup_Settings::LEVEL_UP_SOUND)
    new_skills.each do |skill|
      data = [self.name, Popup_Settings::NEW_SKILL, skill.icon_index, skill.name, '!']
      $game_map.stack_popup(data, Popup_Settings::SKLL_TONE)
    end
  end
end

#===============================================================================
# Modulo Popup (per compatibilità precedente)
#===============================================================================
module Popup
  # @param [String] text
  # @param [Integer] icon_index
  # @param [Array<Integer>] tone
  def self.show(text, icon_index = 0, tone = nil)
    tone_obj = tone.nil? ? nil : Tone.new(tone[0],tone[1],tone[2],tone[3])
    $game_map.add_popup([icon_index, text], tone_obj)
  end
end

