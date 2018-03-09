require 'rm_vx_data'

module H87Item
  module Settings
    CATEGORIES = [:usable, :resource, :weapon, :armor, :key, :battle]
    CAT_NAMES = {
        :usable => 'Utilizzabili',
        :resource => 'Materiali',
        :weapon => 'Armi',
        :armor => 'Armature',
        :key => 'Importanti',
        :battle => 'Battaglia'
    }
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.categories; Settings::CATEGORIES; end
end

module Vocab
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.item_category(symbol); H87Item::Settings::CAT_NAMES[symbol]; end
end

class Window_NewItems < Window_Selectable
  # attr [Array<RPG::Item>] data
  # attr [Window_ItemInfo] info_window
  attr_accessor :info_window
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @info_window = nil
    self.index = 0
    set_category(:usable)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def deep_refresh
    make_item_list
    create_contents
    refresh
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def set_category(category_name)
    return if @category == category_name
    @category = category_name
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def make_item_list
    if @category == :all
      @data = $game_party.items
    else
      @data = []
      $game_party.items.each{|item|
        next if item.nil?
        next unless item.category == @category
        @data.push(item)
        if item.is_a?(RPG::Item) and item.id == $game_party.last_item_id
          self.index = @data.size - 1
        end
      }
    end
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto singolo alla riga
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    enabled = enable?(index)
    draw_item_name(item.item, rect.x, rect.y, enabled, rect.width)
    draw_item_number(item, rect)
  end
  #--------------------------------------------------------------------------
  # * disegna il numero degli oggetti prodotti dalla forgiatura
  # @param [Forge_Product] item
  # @param [Rect] rect
  #--------------------------------------------------------------------------
  def draw_item_number(item, rect)
    return if item.result_n == 1
    num = sprintf('x%d', item.result_n)
    draw_text(rect, num, 2)
  end
  #--------------------------------------------------------------------------
  # * restituisce il prodotto della forgiatura
  # @return [RPG::Item]
  #--------------------------------------------------------------------------
  def item; @data[@index]; end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto nell'index è craftabile
  # @param [RPG::Item] item
  #--------------------------------------------------------------------------
  def enable?(item)
    $game_party.item_can_use?(item)
  end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto selezionato dal cursore è cliccabile
  #--------------------------------------------------------------------------
  def current_item_enabled?; enable?(@data[@index]); end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def update_help
    super
    @help_window.set_item(item) if @help_window
    info_window.set_item(item) if info_window
  end
end

class Window_ItemCategory < Window_HorzCommand
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super
    self.openness = 0
    deactivate
    select_symbol(:usable)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(1)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def make_command_list
    categories = H87Item.categories
    categories.each{|category|
      add_command(Vocab.item_category(category), :category)
    }
  end
end

class Window_ItemActors < Window_Selectable
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    refresh
  end
  #--------------------------------------------------------------------------
  # * ottiene l'altezza dell'elemento
  #--------------------------------------------------------------------------
  def item_height
    (height - standard_padding * 2) / 4
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = true
    rect = item_rect(index)
    draw_actor_face(actor, rect.x + 1, rect.y + 1, enabled)
    draw_actor_simple_status(actor, rect.x + 108, rect.y + line_height / 2)
  end
end

class Scene_NewItem < Scene_MenuBase
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    #TODO: crea altri comandi
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_command_window
    @category_window = Window_ItemCategory.new(0, 0)
    @category_window.set_handler(:ok, method(:category_choice))
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_item_window
    y = @help_window.height
    height = Graphics.height - y
    width = Graphics.width / 2
    @item_window = Window_NewItems.new(0, y, width, height)
    @item_window.set_handler(:ok, method(:item_ok))
    @item_window.set_handler(:cancel, method(:category_selection))
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_status_window
    y = @help_window.height
    x = Graphics.width
    width = Graphics.width / 2
    height = Graphics.height - y

  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_details_window

  end
  #--------------------------------------------------------------------------
  # * Category [OK]
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate
    @item_window.select_last
    @category_window.close
    @item_window.smooth_move(0, @help_window.height)
    @help_window.smooth_move(0, 0)
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
    @category_window.open
    @item_window.smooth_move(0, @help_window.height + @category_window.height)
    @help_window.smooth_move(0, @category_window.height)
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