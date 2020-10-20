#===============================================================================
# ** Window_EsperStatus
#-------------------------------------------------------------------------------
# mostra una panoramica dello stato di tutti gli esper ottenuti
#===============================================================================
class Window_EsperStatus < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Fixnum] x
  # @param [Fixnum] y
  # @param [Fixnum] width
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, Graphics.height - fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    espers.each_index{|index| draw_esper_info(index, espers[index])}
  end
  #--------------------------------------------------------------------------
  # * disegna le informazioni sull'esper
  # @param [Fixnum] index
  # @param [Game_Actor] esper
  #--------------------------------------------------------------------------
  def draw_esper_info(index, esper)
    y = index * line_height
    draw_bg_srect(0, y, contents_width)
    aw = arrow_rect(:right).width
    if esper.esper_master
      draw_actor_little_face(esper.esper_master, 0, y)
    end
    x = 32 + aw + 4
    draw_arrow(:right, 34, y)
    draw_actor_name(esper, x, y)
    draw_esper_state(esper, x + 108, y, 108)
    x = x + (108*2)
    draw_esper_charge(esper, x, y, contents_width - x - 4)
  end
  #--------------------------------------------------------------------------
  # * disegna lo stato di carica dell'esper
  # @param [Game_Actor] esper
  # @param [Fixnum] x
  # @param [Fixnum] y
  #--------------------------------------------------------------------------
  def draw_esper_state(esper, x, y, width = 100)
    if esper.recharged?
      change_color(power_up_color)
      text = Vocab.ready_dom
    else
      change_color(crisis_color)
      text = Vocab.rec_dom
    end
    draw_text(x, y, width, line_height, text)
  end
  #--------------------------------------------------------------------------
  # * disegna la barra di ricarica dell'esper
  # @param [Game_Actor] esper
  # @param [Fixnum] x
  # @param [Fixnum] y
  #--------------------------------------------------------------------------
  def draw_esper_charge(esper, x, y, width = contents_width - x)
    rate = esper.charge_state_rate
    draw_gauge(x, y, width, rate, mp_gauge_color1, mp_gauge_color2)
    text = sprintf('%d/%d', esper.recharge_status, esper.recharge_max)
    change_color(normal_color)
    draw_text(x, y, width, line_height, text, 1)
  end
  #--------------------------------------------------------------------------
  # * restituisce le dominazioni sbloccate
  # @return [Array<Game_Actor>]
  #--------------------------------------------------------------------------
  def espers; $game_party.unlocked_dominations; end
end

#===============================================================================
# ** Scene_Menu
#-------------------------------------------------------------------------------
# aggiunta della finestra dello status esper
#===============================================================================
class Scene_Menu < Scene_Base
  alias h87_esp_win_start start unless $@
  alias h87_esp_win_update update unless $@
  alias h87_esp_win_terminate terminate unless $@
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  def start
    h87_esp_win_start
    create_esper_status_window
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def update
    h87_esp_win_update
    update_esper_status_window
  end
  #--------------------------------------------------------------------------
  # * fine
  #--------------------------------------------------------------------------
  def terminate
    h87_esp_win_terminate
    delete_esper_status_window
  end
  #--------------------------------------------------------------------------
  # * crera la finestr adegli status evocazione
  #--------------------------------------------------------------------------
  def create_esper_status_window
    @esper_window = Window_EsperStatus.new(Graphics.width, 0, @status_window.width)
    @esper_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra evocazioni
  #--------------------------------------------------------------------------
  def update_esper_status_window
    @esper_window.update
  end
  #--------------------------------------------------------------------------
  # * elimina la finestra esper
  #--------------------------------------------------------------------------
  def delete_esper_status_window
    @esper_window.dispose
  end
end