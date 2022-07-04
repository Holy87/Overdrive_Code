module Vocab
  Current_Events = 'Eventi in corso'
  Event_Dates = 'Dal  %s  al  %s'
  No_Events = 'Non ci sono eventi in corso.'
  Event_Rates = 'Bonus attivi:'
  Event_Started_Notification = "L'evento %s è iniziato!"
end

module Event_Service

  # Ottiene gli eventi attivi
  # Nel caso ci siano errori nel downlod, riprova a scaricare
  # la prossima volta che si ottengono gli eventi
  # @return [Array<Online::Event>]
  def self.current_events
    return [] unless $game_system.can_upload?
    @events ||= get_current_events
  end

  # @return [Array<Online::Event>]
  def self.get_current_events
    @events_loaded = true
    begin
      response = Online.get :events, :list
      response.decode_json.map { |data| Online::Event.new(data) }
    rescue => error
      Logger.error(error.message)
      @events_loaded = false
      []
    end
  end

  def self.events_loaded?
    @events_loaded
  end
end

class Online::Event
  attr_reader :id
  # @return [String]
  attr_accessor :name
  # @return [Time]
  attr_accessor :start_date
  # @return [Time]
  attr_accessor :end_date
  attr_accessor :switch_id
  attr_accessor :drop_rate
  attr_accessor :gold_rate
  attr_accessor :exp_rate
  attr_accessor :ap_rate
  attr_accessor :description

  def initialize(data)
    @name = data['event_name']
    @start_date = Time.from_string(data['start_date'])
    @end_date = Time.from_string(data['end_date'])
    @description = data['description']
    @switch_id = data['switch_id']
    @drop_rate = data['drop_rate']
    @gold_rate = data['gold_rate']
    @exp_rate = data['exp_rate']
    @ap_rate = data['ap_rate']
    @id = data['event_id']
  end

  def start_date_s
    sprintf('%d/%d/%d', @start_date.day, @start_date.mon, @start_date.year)
  end

  def end_date_s
    sprintf('%d/%d/%d', @end_date.day, @end_date.mon, @end_date.year)
  end
end

class Game_System

  # Procedura che reimposta tutti gli switch attivi grazie agli eventi.
  # Viene chiamata al caricamento del gioco.
  def refresh_active_events
    event_switches.each { |switch_id| $game_switches[switch_id] = false }
    Event_Service.current_events.each { |event| activate_event(event) }

  end

  private

  # @return [Array<Integer>]
  def event_switches
    @event_switches ||= []
  end

  # @param [Online::Event] event
  def activate_event(event)
    trigger_event_notification(event)
    trigger_event_switches(event)
  end

  # @param [Online::Event] event
  def trigger_event_notification(event)
    notification_id = sprintf('evt_%d', event.id)
    title = sprintf(Vocab::Event_Started_Notification, event.name)
    $game_system.add_local_notification(notification_id, title, event.description, event.start_date)
  end

  # @param [Online::Event] event
  def trigger_event_switches(event)
    return if event.switch_id.nil?
    event_switches.push(event.switch_id) unless event_switches.include?(event.switch_id)
    $game_switches[event.switch_id] = true
  end
end