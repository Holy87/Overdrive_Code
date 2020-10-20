module Vocab
  No_Player_Connection = 'Non riesco ad ottenere le informazioni online. Controlla la connessione.'
  Player_Connected = 'Tutto OK, sei online!'
  Player_Banned = 'Il tuo profilo è stato disattivato.'
  Player_Disabled = 'Hai disabilitato l\'online.'
  Maintenance = "I server di gioco sono in manutenzione. Per favore, riprova più tardi."
end

class Window_OnlineDashboard < Window_Base
  def initialize(x, y, width, height)
    super
    @player = nil
    refresh
  end

  def refresh
    contents.clear
    return draw_no_connection if player.nil?
    draw_player_state
    draw_current_events(line_height)
    draw_active_bonuses
  end

  # @return [Online_Player]
  def player
    @player
  end

  def set_player(player)
    @player = player
    refresh
  end

  def draw_no_connection
    change_color crisis_color
    status = Online.service_status
    if status == :maintenance
      draw_text_wrapped(0, 0, Vocab::Maintenance)
    else
      draw_text_wrapped(0, 0, Vocab::No_Player_Connection)
    end
    change_color normal_color
  end

  def draw_player_state
    if player.banned?
      change_color power_down_color
      text = Vocab::Player_Banned
    elsif !$game_system.can_upload?
      change_color crisis_color
      text = Vocab::Player_Disabled
    else
      change_color power_up_color
      text = Vocab::Player_Connected
    end
    draw_text(0, 0, contents_width, line_height, text, 1)
    change_color normal_color
  end

  def draw_current_events(y)
    change_color system_color
    draw_text(0, y, contents_width, line_height, Vocab::Current_Events)
    change_color normal_color
    if Event_Service.current_events.size > 0
      draw_event_list(y + line_height)
    else
      draw_text(0, y + line_height, contents_width, line_height, Vocab::No_Events)
    end
  end

  def draw_event_list(y)
    Event_Service.current_events.each_with_index do |event, index|
      _y = y + line_height * index
      draw_bg_rect(0, _y, contents_width, line_height)
      draw_text(0, _y, contents_width, line_height, event.name)
      text = sprintf(Vocab::Event_Dates, event.start_date_s, event.end_date_s)
      draw_text(0, _y, contents_width, line_height, text, 2)
    end
  end

  def draw_active_bonuses
    events = Event_Service.current_events
    exp = events.inject(1) { |sum, event| sum + (event.exp_rate / 100.0) - 1 }
    gold = events.inject(1) { |sum, event| sum + (event.gold_rate / 100.0) - 1 }
    drop = events.inject(1) { |sum, event| sum + (event.drop_rate / 100.0) - 1 }
    jp = events.inject(1) { |sum, event| sum + (event.jp_rate / 100.0) - 1 }

    bonus = [:exp, :gold, :jp, :drop].select { |bonus| eval(bonus.to_s) != 1}
    bonus_vocabs = {
        :exp => 'Punti esperienza',
        :gold => 'Monete ottenute',
        :drop => 'Probabilità di drop',
        :jp => 'PA guadagnati'
    }

    return if bonus.size == 0
    width = contents_width / 2
    y = contents_height - line_height * 2

    change_color system_color
    draw_text(0, y, contents_width, line_height, Vocab::Current_Events)
    bonus.each_with_index do |rate, index|
      x = width * (index % 2)
      yy = y + (line_height * (index / 2))
      draw_bg_rect(x + 1, yy + 1, width - 2, line_height - 2)
      change_color crisis_color
      draw_text(x + 2, yy, width, line_height, bonus_vocabs[rate])
      change_color normal_color
      draw_text(x, yy, width - 2, line_height, sprintf('x%.02g', eval(rate.to_s)), 2)
    end
  end
end