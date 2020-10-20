#==============================================================================
# ** Window_PopUp
#------------------------------------------------------------------------------
#  PopUp richiamabile
#==============================================================================
class Window_PopUp < Window_Selectable
  def initialize
    super(0,0,0,0)
    self.index = -1
    self.active = false
    self.openness = 0
  end

  def open(text = nil)
    set_text(text) unless text.nil?
    self.active = true
    super()
  end

  def close
    self.active = false
    super
  end

  def set_text(text)
    @text = text
    @paragraphs = text.split("/[\n\r]+/")
    @lines = @paragraphs.size
    self.height = @lines * line_height + 32
    self.width = max_paragraph + 32
    center_window
    create_contents
    refresh
  end

  def center_window
    self.x = Graphics.width/2 - self.width/2
    self.y = Graphics.height/2 - self.height/2
  end

  def max_paragraph
    max = 0
    @paragraphs.each do |paragraph|
      width = contents.text_size(paragraph).width
      max = width if width > max
    end
    max
  end

  def refresh
    for i in 0..@lines-1
      draw_text(0, line_height * i, contents_width, line_height, @paragraphs[i])
    end
  end
end

#==============================================================================
# ** ListWindow
#------------------------------------------------------------------------------
#  Modulo da integrare nelle finestre
#==============================================================================
module ListWindow
  #--------------------------------------------------------------------------
  # * Imposta la categoria
  #     category: la categoria da impostare
  #--------------------------------------------------------------------------
  def set_list(category)
    return if @category == category
    @category = category
    self.index = 0
    get_items
    create_contents
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la finestra delle informazioni
  #--------------------------------------------------------------------------
  def update_info_window
    return if @info_window.nil?
    @info_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Tasto indietro
  #--------------------------------------------------------------------------
  def back
    return if $game_temp.in_battle
    return unless active
    Sound.play_cancel
    @category_window != nil ? go_down : go_back
  end
  #--------------------------------------------------------------------------
  # * Fa scendere giù la schermata
  #--------------------------------------------------------------------------
  def go_down
    self.active = false
    @category_window.open
    @category_window.active = true
    if $imported["H87_SmoothMovements"]#.nil? && $imported["H87_SmoothMovements"] >= 1.1
      self.viewport.smooth_move(view_x, @category_window.height + @category_window.y)
    else
      self.viewport.rect.y = @category_window.height + @category_window.y
    end
  end
  #--------------------------------------------------------------------------
  # * Fa risalire la schermata
  #--------------------------------------------------------------------------
  def go_up
    if !self.viewport.nil?
      if $imported["H87_SmoothMovements"]#.nil? && $imported["H87_SmoothMovements"] >= 1.1
        self.viewport.smooth_move(view_x, view_y)
      else
        self.viewport.rect.y = view_y
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Imposta la finestra della categoria
  #--------------------------------------------------------------------------
  def set_category_window(window)
    @category_window = window
  end
  #--------------------------------------------------------------------------
  # * Imposta la finestra delle informazioni del nemico
  #--------------------------------------------------------------------------
  def set_info_window(window)
    @info_window = window
  end
  #--------------------------------------------------------------------------
  # * Imposta lo stato di attivazione
  #--------------------------------------------------------------------------
  def active=(value)
    super(value)
    @info_window.active = value unless @info_window.nil?
    go_up if value
  end
  #--------------------------------------------------------------------------
  # * Ottiene gli oggetti
  #--------------------------------------------------------------------------
  def get_items
    get_data
    @item_max = @data.size
  end
  #--------------------------------------------------------------------------
  # * Metodo astratto per l'ottenimento dei dati
  #--------------------------------------------------------------------------
  def get_data
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Restituisce la coordinata X iniziale del viewport
  #--------------------------------------------------------------------------
  def view_x
    return 0 if @viewport.nil? || @view_x.nil?
    return @view_x
  end
  #--------------------------------------------------------------------------
  # * Restituisce la coordinata Y iniziale del viewport
  #--------------------------------------------------------------------------
  def view_y
    return 0 if @viewport.nil? || @view_y.nil?
    return @view_y
  end
end

#==============================================================================
# ** Item_Category
#------------------------------------------------------------------------------
#  Una classe di supporto per la categoria dei nemici/oggetti
#==============================================================================
class Item_Category
  attr_reader :symbol   #simbolo
  attr_reader :name     #nome
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(symbol, name)
    @symbol = symbol
    @name = name
  end
end #item_category

#==============================================================================
# ** Window_Category
#------------------------------------------------------------------------------
#  Finestra che mostra le categorie del bestiario
#==============================================================================
class Window_Category < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #     x: pos x iniziale
  #     y: pos y iniziale
  #--------------------------------------------------------------------------
  def initialize(x, y, spacing = 32)
    @spacing = spacing
    super(x,y, Graphics.width, fitting_height(1))
    @index = 0
    self.active = false
    self.openness = 0
    refresh
  end

  def spacing
    @spacing
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    create_items
    create_contents
    draw_items
  end
  #--------------------------------------------------------------------------
  # * Creazione degli oggetti
  #--------------------------------------------------------------------------
  def create_items
    @data = default_data
    @item_max = @data.size
    @column_max = @data.size
  end
  #--------------------------------------------------------------------------
  # * Metodo astratto per i dati
  #--------------------------------------------------------------------------
  def default_data
  end
  #--------------------------------------------------------------------------
  # * Disegna gli oggetti
  #--------------------------------------------------------------------------
  def draw_items
    (0..@data.size - 1).each { |i|
      next if @data[i].nil?
      draw_item(i)
    }
  end
  #--------------------------------------------------------------------------
  # * Restituisce un array di categorie
  #--------------------------------------------------------------------------
  def categories_from_hash(hash)
    cat = []
    (1..hash.size).each { |i|
      cat.push(Item_Category.new(hash[i][0], hash[i][1]))
    }
    cat
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  #     index: indice dell'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    item = @data[index]
    self.draw_text(rect.x, rect.y, rect.width, WLH, item.name)
  end
  #--------------------------------------------------------------------------
  # * Ottiene l'oggetto
  #--------------------------------------------------------------------------
  def item
    @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Imposta la finestra degli oggetti da aggiornare
  #--------------------------------------------------------------------------
  def set_list(list)
    @item_list = list
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    if self.active
      update_list if Input.trigger?(Input::C)
      return_scene if Input.trigger?(Input::B)
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento della lista
  #--------------------------------------------------------------------------
  def update_list
    Sound.play_ok
    @item_list.set_list(item.symbol)
    self.active = false
    @item_list.active = true
    self.close
  end
  #--------------------------------------------------------------------------
  # * Torna al menu precedente
  #--------------------------------------------------------------------------
  def return_scene
    return if self.openness < 255
    Sound.play_cancel
    previous_scene
  end
  #--------------------------------------------------------------------------
  # * Chiama la scena precedente
  #--------------------------------------------------------------------------
  def previous_scene
    SceneManager.return
  end
end #window_category

#==============================================================================
# ** Window_List
#------------------------------------------------------------------------------
#  Mostra una lista da categoria
#==============================================================================
class Window_List < Window_Selectable
  include ListWindow #modulo per la finestra della lista
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #     x: pos x iniziale
  #     y: pos y iniziale
  #     width: larghezza
  #     height: altezza
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    self.index = 0
    self.active = true
    @category = :all
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    draw_items
  end
  #--------------------------------------------------------------------------
  # * Disegna gli oggetti
  #--------------------------------------------------------------------------
  def draw_items
    return if @data.nil?
    (0..@data.size - 1).each { |i|
      draw_item(i)
    }
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  #     index: indice dell'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    #disegno l'oggetto
  end
  #--------------------------------------------------------------------------
  # * Ottiene l'oggetto
  #--------------------------------------------------------------------------
  def item
    return [] if @data.nil?
    @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Aggiunge i metodi di x e y iniziali del viewport
  #--------------------------------------------------------------------------
  def viewport=(viewport)
    super(viewport)
    @view_x = viewport.rect.x
    @view_y = viewport.rect.y
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_info_window
    back if Input.trigger?(Input::B)
  end
end #list

class Window_DataInfo < Window_Base
  attr_accessor :active
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    super
    @pages = []
    @index = 0
    self.active = true
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    return if @item.nil?
    draw_page_index if @pages.size > 1
    draw_content
  end
  #--------------------------------------------------------------------------
  # * Restituisce il massimo numero di righe nella finestra
  #--------------------------------------------------------------------------
  def max_lines
    (contents.width / line_height) - 1
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'indice di pagina
  #--------------------------------------------------------------------------
  def index; @index; end
  #--------------------------------------------------------------------------
  # * Restituisce il nemico impostato
  #--------------------------------------------------------------------------
  def item; @item; end
  #--------------------------------------------------------------------------
  # * Imposta l'oggetto da visualizzare
  #     item: oggetto
  #--------------------------------------------------------------------------
  def set_item(item)
    return if @item == item
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Imposta l'indice di pagina
  #     new_index: nuovo indice
  #--------------------------------------------------------------------------
  def index=(new_index)
    @index = new_index
    @index = @pages.size-1 if @index < 0
    @index = 0 if @index > @pages.size-1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Restituisce la pagina selezionata
  #--------------------------------------------------------------------------
  def selected_page; @pages[index]; end
  #--------------------------------------------------------------------------
  # * Restituisce lo stato di attivazione di una pagina
  #     symbol: simbolo della pagina
  #--------------------------------------------------------------------------
  def page_active?(symbol); selected_page == symbol; end
  #--------------------------------------------------------------------------
  # * Colore di sfondo 1
  #--------------------------------------------------------------------------
  def sc1
    c = gauge_back_color
    c.alpha = 75
    c
  end
  #--------------------------------------------------------------------------
  # * Colore di sfondo 2
  #--------------------------------------------------------------------------
  def sc2
    c = gauge_back_color
    c.alpha = 150
    c
  end
  #--------------------------------------------------------------------------
  # * Disegna l'indice della pagina
  #--------------------------------------------------------------------------
  def draw_page_index
    self.contents.gradient_fill_rect(0,0,contents.width, WLH, sc1, sc2, true)
    contents.clear_rect(0,0,1,1)
    contents.clear_rect(contents.width-1, 0,1,1)
    contents.clear_rect(0,WLH-1,1,1)
    contents.clear_rect(contents.width-1,WLH-1,1,1)
    draw_page_state
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se è la prima pagina
  #--------------------------------------------------------------------------
  def fp?; @index == 0; end
  #--------------------------------------------------------------------------
  # * Restituisce true se è l'ultima pagina
  #--------------------------------------------------------------------------
  def lp?; @index == @pages.size-1; end
  #--------------------------------------------------------------------------
  # * Disegna l'indice della pagina
  #--------------------------------------------------------------------------
  def draw_page_state
    return if @pages.size <= 1
    x = 0
    w = contents.width/2
    contents.font.color.alpha = fp? ? 128 : 255
    self.draw_text(x, 0, w, WLH, "<")
    x += contents.text_size("<").width + 5
    for i in 0..@pages.size-1
      x += draw_page_name(x, @pages[i])
    end
    contents.font.color.alpha = lp? ? 128 : 255
    self.draw_text(x, 0, w, WLH, ">")
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # * Disegna il nome della pagina
  #     x: posizione x
  #     symbol: simbolo
  #--------------------------------------------------------------------------
  def draw_page_name(x, symbol)
    name = page_name(symbol)
    if page_active?(symbol)
      contents.font.color.alpha = 255
      contents.gradient_fill_rect(x-2,0,contents.text_size(name).width+4,WLH,sc2,sc1,true)
    else
      contents.font.color.alpha = 128
    end
    self.draw_text(x, 0, contents.width/2, WLH, name)
    contents.text_size(name).width + 5
  end
  #--------------------------------------------------------------------------
  # * Ottiene il nome della pagina
  #--------------------------------------------------------------------------
  def page_name(symbol)
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_input if self.active
  end
  #--------------------------------------------------------------------------
  # * Aggiorna gli input
  #--------------------------------------------------------------------------
  def update_input
    return if item.nil?
    return if @pages.size <= 1
    c_page(1) if Input.repeat?(Input::RIGHT)
    c_page(-1) if Input.repeat?(Input::LEFT)
  end
  #--------------------------------------------------------------------------
  # * Cambia la pagina
  #     n: numero di pagina
  #--------------------------------------------------------------------------
  def c_page(n)
    BestiaryConfig::PAGEFX.play
    self.index += n
  end
  #--------------------------------------------------------------------------
  # * Disegna la barra di sfondo al parametro
  #     x: coordinata X
  #     y: coordinata Y
  #     width: larghezza
  #     height: altezza
  #--------------------------------------------------------------------------
  def draw_bg_rect(x, y, width, height, color = sc1)
    contents.fill_rect(x+1, y+1, width-2, height-2, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  #     item: oggetto
  #     x: posizione X
  #     y: posizione Y
  #--------------------------------------------------------------------------
  def draw_item(item, x, y)
    draw_icon(item.icon_index, x, y, width = contents.width - 24)
    draw_text(x + 24, y, width, line_height, item.name)
  end
end

class Game_Temp
  attr_accessor :last_menu_index
end

class Window_PopupSelect < Window_Selectable
  def initialize(x, y, width = 300, height = 80)
    super(x,y,width,height)
    @index = 0
    self.active = false
    self.openness = 0
    refresh
  end
end