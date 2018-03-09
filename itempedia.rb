require 'rm_vx_data'

module ItemPedia
  module_function

  CATEGORIES = {
      :all => "Tutti",
      :potion => "Oggetti",
      :ingredient => "Ingredienti",
      :other => "Altro",
      #:weapon = "Armi",
      #:armor = "Armature",
  } #NON RIMUOVERE LA PARENTESI

  V_DROP = "Drop"
  V_STEAL= "Da rubare"
  #--------------------------------------------------------------------------
  # * Restituisce le categorie dei nemici
  # @return [Array<Item_Category>]
  #--------------------------------------------------------------------------
  def categories
    categories = []
    CATEGORIES.each do |item|
      categories.push(Item_Category.new(item[0], item[1]))
    end
    categories
  end
end

#==============================================================================
# ** EnemyDrop
#==============================================================================
class EnemyDrop
  attr_accessor :enemy
  attr_accessor :probability
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [RPG::Enemy] enemy
  # @param [Object] probability
  #--------------------------------------------------------------------------
  def initialize(enemy, probability)
    @enemy = enemy
    @probability = probability
  end
end

#==============================================================================
# ** RPG::Item
#==============================================================================
class RPG::Item
  #--------------------------------------------------------------------------
  # * determina se l'oggetto è listabile nella itempedia
  #--------------------------------------------------------------------------
  def in_list?
    @in_list ||= initialize_in_list
  end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto è un ingrediente
  #--------------------------------------------------------------------------
  def ingredient?
    @ingredient ||= initialize_ingredient
  end
  #--------------------------------------------------------------------------
  # * determina a quale categoria appartiene
  # @return [Symbol]
  #--------------------------------------------------------------------------
  def wiki_category
    return :potion if menu_ok?
    return :ingredient if ingredient?
    :other
  end
  #--------------------------------------------------------------------------
  # * inizializza l'informazione della lista
  #--------------------------------------------------------------------------
  def initialize_in_list
    self.note.split(/[\n\r]+/).each do |line|
      return false if line =~ /<nascondi>/i
    end
    true
  end
  #--------------------------------------------------------------------------
  # * inzizializza l'informazione dell'ingrediente
  #--------------------------------------------------------------------------
  def initialize_ingredient
    self.note.split(/[\n\r]+/).each do |line|
      return true if line =~ /<ingrediente>/i
    end
    false
  end
end

#==============================================================================
# ** RPG::Weapon
#==============================================================================
class RPG::Weapon
  #--------------------------------------------------------------------------
  # * restituisce la categoria
  #--------------------------------------------------------------------------
  def category; :weapon; end
end

#==============================================================================
# ** RPG::Armor
#==============================================================================
class RPG::Armor
  #--------------------------------------------------------------------------
  # * restituisce la categoria
  #--------------------------------------------------------------------------
  def category; :armor; end
end

#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party
  alias wiki_i_gain_item gain_item unless $@
  #--------------------------------------------------------------------------
  # * restituisce l'array degli ID degli oggetti scoperti
  # @return [Array]
  #--------------------------------------------------------------------------
  def discovered_items
    @discovered_items ||= initial_discovered_items
  end
  #--------------------------------------------------------------------------
  # * genera l'array iniziale degli ID degli oggetti scoperti
  #--------------------------------------------------------------------------
  def initial_discovered_items
    @discovered_items = @items.keys
  end
  #--------------------------------------------------------------------------
  # * aggiunge un oggetto scoperto all'array (se assente)
  #--------------------------------------------------------------------------
  def item_discovered(item_id)
    discovered_items |= [item_id]
  end
  #--------------------------------------------------------------------------
  # * determina se un determinato oggetto è scoperto
  #--------------------------------------------------------------------------
  def item_discovered?(item_id)
    discovered_items.include?(item_id)
  end
  #--------------------------------------------------------------------------
  # * alias del metodo gain_item
  #--------------------------------------------------------------------------
  def gain_item(item, n = 1, include_equip = false)
    wiki_i_gain_item(item, n, include_equip )
    if item != nil
      item_discovered(item.id) if item.is_a?(RPG::Item)
    end
  end
end

#==============================================================================
# ** Scene_Itempedia
#------------------------------------------------------------------------------
# la schermata dell'oggettario
#==============================================================================
class Scene_Itempedia < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_viewport
    create_windows
  end
  #--------------------------------------------------------------------------
  # * crea il viewport
  #--------------------------------------------------------------------------
  def create_viewport
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  end
  #--------------------------------------------------------------------------
  # * crea le finestre
  #--------------------------------------------------------------------------
  def create_windows
    create_items_window
    create_category_window
    create_drop_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra degli oggetti
  #--------------------------------------------------------------------------
  def create_items_window
    @items_window = Window_Item_WikiList.new(0, 0, 200, Graphics.height)
    @items_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * crea la finestra delle categorie
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemCategoryW.new(0, 0)
    @category_window.set_list(@items_window)
    @items_window.set_category_window(@category_window)
    @items_window.set_list(@category_window.item.symbol)
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    @viewport.update
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei drop
  #--------------------------------------------------------------------------
  def create_drop_window
    x = @items_window.width
    y = @items_window.y
    w = Graphics.width - x
    h = Graphics.height
    @drop_window = Window_DropInfo.new(x, y, w, h)
    @items_window.set_info_window(@drop_window)
    @category_window.z = 9999
    @drop_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Chiusura
  #--------------------------------------------------------------------------
  def terminate
    super
    @viewport.dispose
  end
end

#==============================================================================
# ** Window_Item_WikiList
#------------------------------------------------------------------------------
#  Mostra l'elenco dei nemici visti
#==============================================================================
class Window_Item_WikiList < Window_List
  #--------------------------------------------------------------------------
  # * Ottiene gli oggetti
  #--------------------------------------------------------------------------
  def get_data
    @data = []
    # @param [RPG::Item] item
    $data_items.each {|item|
      next if item.nil?
      next if item.name.size == 0
      next unless $game_party.item_discovered?(item.id)
      next if item.key_item
      next unless item.in_list?
      next if no_item_drops(item)
      if @category == :all
        @data.push(item)
      else
        @data.push(item) if item.wiki_category == @category
      end
    }
    @data.sort!{|a, b| a.name <=> b.name}
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se non ci sono nemici che droppano l'oggetto
  #     item: oggetto
  # noinspection RubyResolve
  # @param [RPG::Item] item
  #--------------------------------------------------------------------------
  def no_item_drops(item)
    Bestiary.unlocked_enemies.each {|enemy|
      return false if enemy.has_item?(item)
    }
    true
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  #     index: indice dell'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    item = @data[index]
    draw_icon(item.icon_index, rect.x, rect.y)
    draw_text(rect.x + 24, rect.y, rect.width - 24, rect.height, item.name)
  end
end #enemy_list

#==============================================================================
# ** Window_ItemCategoryW
#------------------------------------------------------------------------------
#  Mostra la categoria degli oggetti
#==============================================================================
class Window_ItemCategoryW < Window_Category
  include ItemPedia
  #--------------------------------------------------------------------------
  # * Metodo astratto per i dati
  #--------------------------------------------------------------------------
  def default_data; categories; end
end

#==============================================================================
# ** Window_DropInfo
#------------------------------------------------------------------------------
#  Mostra la categoria degli oggetti
#==============================================================================
class Window_DropInfo < Window_DataInfo
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] w
  # @param [Integer] h
  # noinspection RubyResolve
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    @enemies = Bestiary.unlocked_enemies
    super(x, y, w, h)
    @pages = [:drops, :steals]
  end
  #--------------------------------------------------------------------------
  # * Disegna il contenuto delle informazioni a seconda della pagina
  #--------------------------------------------------------------------------
  def draw_content
    case selected_page
      when :drops; draw_drops(0, contents.width)
      when :steals; draw_steals(0,contents.width)
      else #nothing
    end
  end
  #--------------------------------------------------------------------------
  # * Ottiene il nome della pagina
  #--------------------------------------------------------------------------
  def page_name(symbol)
    case symbol
      when :drops; return ItemPedia::V_DROP
      when :steals; return ItemPedia::V_STEAL
      else #nothing
    end
  end
  #--------------------------------------------------------------------------
  # * disegna i drop
  #--------------------------------------------------------------------------
  def draw_drops(x, width)
    droplist = get_drop_list
    y = line_height
    return if droplist.size == 0
    (0..droplist.size-1).each {|i|
      draw_drop(x, y + (line_height*i), width, droplist[i])
      break if i >= max_lines
    }
  end
  #--------------------------------------------------------------------------
  # * disegna dove può essere rubato
  #--------------------------------------------------------------------------
  def draw_steals(x, width)
    steallist = get_steal_list
    y = line_height
    return if steallist.size == 0
    (0..steallist.size-1).each {|i|
      draw_drop(x, y + (line_height*i), width, steallist[i])
      break if i >= max_lines
    }
  end
  #--------------------------------------------------------------------------
  # * disegna il drop
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [EnemyDrop] drop
  #--------------------------------------------------------------------------
  def draw_drop(x, y, width, drop)
    draw_bg_rect(x, y, width, line_height)
    draw_enemy(x, y, width, drop.enemy)
    draw_text(x, y, width, line_height, sprintf('%10.2f%%', drop.probability), 2)
  end
  #--------------------------------------------------------------------------
  # * disegna il nemico
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [RPG::Enemy] enemy
  #--------------------------------------------------------------------------
  def draw_enemy(x, y, width, enemy)
    draw_text(x, y, width, line_height, enemy.name)
  end
  #--------------------------------------------------------------------------
  # * ottiene la lista dei nemici che possono droppare l'oggetto
  # @return [Array<EnemyDrop>]
  #--------------------------------------------------------------------------
  def get_drop_list
    drops = []
    @enemies.each {|enemy|
      drops.push(get_drop(enemy)) if enemy.drops_item?(item)
    }
    drops.sort{|b,a| a.probability <=> b.probability }
  end
  #--------------------------------------------------------------------------
  # * restituisce la lista dei nemici a cui puoi rubare l'oggetto
  # @return [Array<EnemyDrop>]
  #--------------------------------------------------------------------------
  def get_steal_list
    steals = []
    @enemies.each {|enemy|
      steals.push(get_steals(enemy)) if enemy.can_steal_item?(item)
    }
    steals.sort{|b,a| a.probability <=> b.probability }
  end
  #--------------------------------------------------------------------------
  # * restituisce la probabilità di rubare del nemico
  # @param [RPG::Enemy] enemy
  # @return [EnemyDrop]
  #--------------------------------------------------------------------------
  def get_steals(enemy)
    steals = Bestiary.obtain_steals(enemy)
    item_drop(enemy, steals)
  end
  #--------------------------------------------------------------------------
  # * restituisce la probabilità di drop del nemico
  # @return [EnemyDrop]
  #--------------------------------------------------------------------------
  def get_drop(enemy)
    drops = Bestiary.obtain_drops(enemy)
    item_drop(enemy, drops)
  end
  #--------------------------------------------------------------------------
  # * restituisce il drop nemico
  # @param [RPG::Enemy] enemy
  # @param [Array<ItemDrop>] drops
  # @return [EnemyDrop]
  #--------------------------------------------------------------------------
  def item_drop(enemy, drops)
    item_array = drops.select{ |drop| drop.item == item }
    prob = 0
    item_array.each do |drop|
      prob += drop.probability
    end
    EnemyDrop.new(enemy, prob)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def item; @item; end
end