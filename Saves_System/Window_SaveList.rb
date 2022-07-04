#===============================================================================
# ** Window_SaveList
#-------------------------------------------------------------------------------
# Viene gestita all'interno di Scene_File, contiene la lista dei salvataggi.
#===============================================================================
class Window_SaveList < Window_Selectable
  # inizializzazione
  def initialize(x, y, width, height, saving = false)
    make_item_list
    super(x, y, width, height)
    @savin = saving
    refresh
    self.index = DataManager.last_savefile_index
  end

  def col_max
    3
  end

  def item_max
    @data ? @data.size : 0
  end

  def refresh
    make_item_list
    super
  end

  # aggiornamento
  def update
    super
    update_detail_window
  end

  # ottieni i salvataggi
  def make_item_list
    @data = []
    (0..DataManager.savefile_max - 1).each { |i|
      header = DataManager.load_header(i)
      @data.push(Save_Data.new(i, header))
    }
  end

  # determina se l'oggetto selezionato dal cursore è cliccabile
  def current_item_enabled?
    return true if SceneManager.scene_is? Scene_Save
    enable?(@data[@index])
  end

  # Ottieni oggetto
  # @return [Save_Data]
  def item
    @data[self.index]
  end

  # Ottieni se attivato
  def enable?(item)
    for_save? or !item.header.nil?
  end

  def for_save?
    @savin
  end

  def for_load?
    !@savin
  end

  # Disegna l'oggetto
  #     index : indice dell'oggetto
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect_for_text(index)
    draw_save_name(item, rect)
  end

  # Aggiornamento della finestra dei dettagli
  def update_detail_window
    return if item.nil? || @detail_window.nil? || self.active == false
    @detail_window.update_header(item.header, item.slot)
  end

  # Assegnazione di una nuova finestra di dettagli
  def detail_window=(dw)
    @detail_window = dw
    update_detail_window
  end

  # Disegna il nome del salvataggio
  # @param [Save_Data] item
  # @param [Rect] rect
  # @param [Boolean] enabled
  def draw_save_name(item, rect, enabled = true)
    return if item.nil?
    enabled = enable? item
    change_color normal_color, enabled
    icon = item.present? ? SaveConfig::FULLSLOT_ICON : SaveConfig::EMPTYSLOT_ICON
    draw_icon(icon, rect.x, rect.y)
    rect.x += 24
    rect.width -= 24
    draw_text(rect, item.name)
  end
end

#window_savelist

#===============================================================================
# ** Save_Data
#-------------------------------------------------------------------------------
# Viene gestita all'interno di Window_SaveList, contiene header e numero salvat.
#===============================================================================
class Save_Data
  attr_reader :slot #numero slot
  attr_reader :header #dati del salvataggio
  # Inizializzazione
  def initialize(save_slot, save_header = nil)
    @slot = save_slot
    @header = save_header
  end

  # determina se un salvataggio è presente nello slot
  def present?
    @header != nil
  end

  # @return [String]
  def name
    slot_number = sprintf(Vocab.slot, @slot + 1)
    return slot_number if @header.nil?
    return slot_number if @header[:save_name].empty?
    @header[:save_name]
  end
end

#save_storer