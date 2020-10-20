#===============================================================================
# ** Scene_Chest
#-------------------------------------------------------------------------------
# Viene chiamata per selezionare l'oggetto da mettere nello scrigno.
#===============================================================================
class Scene_Chest < Scene_MenuBase
  include Chest_Service
  # Inizio
  def start
    super
    create_help_window
    create_item_list_window
    create_info_window
    $game_temp.chest.item = nil
  end

  # Creazione della finestra degli oggetti
  def create_item_list_window
    x = 0; y = @help_window.height
    w = Graphics.width / 2; h = Graphics.height - y
    @item_window = Window_ItemC.new(x, y, w, h)
    @item_window.set_handler(:ok, method(:select_item))
    @item_window.set_handler(:cancel, method(:return_scene))
    @item_window.help_window = @help_window
    @item_window.set_list(:all)
    @item_window.activate
    @item_window.index = 0
  end

  # Creazione della finestra delle informazioni
  def create_info_window
    x = @item_window.width; y = @help_window.height
    w = Graphics.width - x; h = Graphics.height - y
    @info_window = Window_ItemInfo.new(x, y, w, h)
    @item_window.set_info_window(@info_window)
  end

  # Seleziona l'oggetto da inserire nello scrigno
  def select_item
    begin
      Chest_Service.request_fill(@item_window.item)
      SceneManager.return
    rescue InternetConnectionException
      show_dialog('Errore di connessione.', @item_window)
    end
  end
end

#===============================================================================
# ** Window_ItemC
#-------------------------------------------------------------------------------
# Finestra degli oggetti modificata per mostrare abilitati gli oggetti che puoi
# mettere negli scrigni.
#===============================================================================
class Window_ItemC < Window_Item
  # Restituisce se l'oggetto è attivo
  # @param [RPG::Item] item
  def enable?(item)
    return false unless item.traddable?
    item.tier <= $game_temp.chest.level
  end
end
