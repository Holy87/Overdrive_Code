module Notification_Service
  GET_FAME_TYPE = 0
  GET_INFAME_TYPE = 1
  BANNED_TYPE = 2
  BOARD_REPLY_TYPE = 3
  AUCTION_SELL_TYPE = 4
  EVENT_TYPE_STARTED_TYPE = 5
  SERVICE_TYPE = 6
  CUSTOM_TYPE = 10

  UNREAD_ICON = 148
  READ_ICON = 149

  NOTIFICATION_TONE = Tone.new(20, 200, 180, 100)
  NOTIFICATION_SE = 'Chime1'

  # Intervallo (in numero di secondi) per controllare
  # se ci sono nuovi messaggi
  CHECK_INTERVAL = 60 * 10
end

module Vocab
  def self.notification_title(notification_type)
    {
        :fame => 'Fama acquisita',
        :infame => 'Hai ricevuto infamia',
        :banned => 'Profilo bloccato',
        :reply => 'Hai ricevuto una risposta',
        :auction => 'Oggetto venduto'
    }[notification_type]
  end

  def self.notification_message(notification_type)
    {
        :fame => "%s ti ringrazia per l'oggetto che hai lasciato nello scrigno\ndimensionale. Sii orgoglioso della tua buona azione!",
        :infame => "Il tuo mostro trappola ha sconfitto %s in una sanguinosa battaglia.\nLa tua infamia sale!",
        :banned => "Il tuo comportamento ha violato le regole della comunità ed abbiamo deciso\ndi escluderti dalle funzionalità online. Contatta il supporto per maggiori informazioni.",
        :reply => "%s ha risposto ad un tuo messaggio nella %s.\nSe passi, prova a dargli un'occhiata!",
        :auction => "L'articolo %s è stato venduto ad un giocatore ed hai guadagnato %d %s. Passa alla casa d'aste per riscuotere il denaro!",
        :event => "",
        :service => "",
        :custom => "",
    }[notification_type]


  end

  New_Message = 'Nuovo'
  New_Messages_Popup = "Hai nuovi messaggi non letti. Controlla il menu Online."

end

module Notification_Service
  NOTIFICATION_TYPES = {
      GET_FAME_TYPE => :fame,
      GET_INFAME_TYPE => :infame,
      BANNED_TYPE => :banned,
      BOARD_REPLY_TYPE => :reply,
      AUCTION_SELL_TYPE => :auction,
      EVENT_TYPE_STARTED_TYPE => :event,
      SERVICE_TYPE => :service,
      CUSTOM_TYPE => :custom
  }

  # mostra il numero di notifiche non lette
  # @return [Fixnum]
  def self.unread_count
    @unread_count ||= 0
  end

  # @return [Array<Online_Notification>]
  def self.download_and_set_read
    begin
      response = Online.get :notifications, :read
      response.decode_json.map { |notification| Online_Notification.new(notification) }
    rescue => error
      Logger.error(error.message)
      []
    end
  end

  # dice se ci sono messaggi non letti
  # @return [TrueClass, FalseClass]
  def self.has_unread_notifications?
    unread_count > 0
  end

  def self.trigger_new_notification
    @last_unread_count = -1
    @unread_count = -1
  end

  # ti dice se dall'ultima volta che è stato
  # chiamato il metodo ci sono nuove notifiche
  # non lette. Una volta chiamato, si resetta
  # @return [TrueClass, FalseClass]
  def self.new_unread_notifications?
    unread = unread_count > (@last_unread_count || 0)
    @last_unread_count = unread_count
    unread
  end

  # aggiorna il conteggio notifiche non lette
  def self.refresh_unread_count
    @last_unread_count = unread_count
    @last_check = Time.new
    Online.login unless Online.logged_in?
    @unread_count = Online.get(:notifications, :count).body.to_i rescue 0
  end

  # determina se sono state controllate le notifiche almeno una volta
  # @return [TrueClass, FalseClass]
  def self.first_check?
    @unread_count != nil
  end

  # mostra il frame count dell'ultimo controllo di nuovi messaggi
  # @return [Time]
  def self.last_check
    @last_check ||= Time.local(2000)
  end

  def self.clear_unread_count
    @unread_count = 0
  end
end

#===============================================================================
# ** Online_Notification
#-------------------------------------------------------------------------------
# Oggetto contenente le informazioni della notifica
#===============================================================================
class Online_Notification
  include Comparable

  # @return [Symbol] il tipo di notifica
  attr_accessor :type
  # @return [String] informazioni aggiuntive
  attr_accessor :info
  # @return [Time] la data della notifica
  attr_reader :date
  attr_reader :id

  def initialize(data)
    @id = data['notification_id']
    @type = Notification_Service::NOTIFICATION_TYPES[data['type']]
    @data = data['additional_info']
    @read = (data['is_read'] || 0) == 1
    date = data['date']
    if date != nil
      @date = date.is_a?(String) ? date_from_string(date) : date
    else
      @date = Time.new
    end
  end

  # imposta un titolo personalizzato
  # @param [String] title
  def set_title(title)
    @title = title
  end

  # imposta un messaggio personalizzato
  # @param [String] message
  def set_message(message)
    @message = message
  end

  # @param [String] date_str
  def date_from_string(date_str)
    if date_str =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/
      Time.local($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
    end
  end

  # Restituisce la data formattata come stringa
  # @return [String]
  def time
    return '' if @date.nil?
    sprintf('%d/%d/%d alle %d:%02d', @date.day, @date.month, @date.year,
            @date.hour, @date.min)
  end

  # Il titolo della notifica
  # @return [String]
  def title
    return @title if @title != nil
    if Vocab.notification_title(@type) != nil
      Vocab.notification_title(@type)
    else
      @data.split(',').first
    end
  end

  # determina se il messaggio è stato letto
  def read?
    @read
  end

  # imposta il messaggio come letto
  def set_read
    @read = true
  end

  # Il contenuto della notifica
  # @return [String]
  def message
    return @message if @message != nil
    data = @data.split(',')
    text = Vocab.notification_message @type
    case @type
    when :fame, :infame
      sprintf(text, data[0])
    when :banned
      text
    when :auction
      item = [$data_items, $data_weapons, $data_armors][data[1].to_i][data[0].to_i]
      item_name = item ? item.name : 'ERROR'
      sprintf(text, item_name, data[2].to_i, Vocab.currency_unit)
    when :reply
      sphere = Dimensional_Sphere.new(data[0].to_sym)
      sprintf(text, data[1], sphere.name)
    when :event, :service, :custom
      base64_decode(data[1])
    else
      data[1] || data[0] || ''
    end
  end

  def <=>(other)
    self.date <=> other.date
  end

end

class Game_System
  # aggiunge una notifica dal gioco in locale
  # @param [String,Fixnum,Symbol] id
  # @param [String] title
  # @param [String] description
  # @param [Time] date
  def add_local_notification(id, title, description, date = Time.now)
    return if saved_notifications.select { |notification| notification.id == id }.any?
    notification = Online_Notification.new({
                                               'notification_id' => id,
                                               'type' => Notification_Service::CUSTOM_TYPE,
                                               'date' => date})
    notification.set_title(title)
    notification.set_message(description)
    $game_system.save_notifications [notification]
    Notification_Service.trigger_new_notification
  end

  # determina se è il momento di controllare le nuove
  # notifiche, se ce ne sono mostra un popup.
  def check_new_notifications
    return unless online_enabled?
    return unless need_refresh_notifications?
    Notification_Service.refresh_unread_count
    if Notification_Service.new_unread_notifications?
      icon = Notification_Service::UNREAD_ICON
      text = Vocab::New_Messages_Popup
      tone = Notification_Service::NOTIFICATION_TONE
      $game_map.stack_popup([icon, text], tone, Notification_Service::NOTIFICATION_SE)
    end
  end

  # @return [Array<Online_Notification>]
  def saved_notifications
    @saved_notifications ||= []
  end

  # @return [TrueClass, FalseClass]
  def unread_notifications?
    unread_count > 0
  end

  # Mostra il numero di messaggi non letti, sia locali che online
  # @return [Fixnum]
  def unread_count
    saved_unread_count + Notification_Service.unread_count
  end

  # restituisce le notifiche salvate ma non lette
  # @return [Fixnum]
  def saved_unread_count
    saved_notifications.select{|n| !n.read?}.size
  end

  # @param [Array<Online_Notification>] notifications
  def save_notifications(notifications)
    @saved_notifications ||= []
    @saved_notifications += notifications
  end

  # Imposta tutti i messaggi come letti
  def set_all_read_notifications
    saved_notifications.each { |notification| notification.set_read }
    Notification_Service.clear_unread_count
  end

  # Scarica le notifiche online e le salva in locale.
  # La funzione imposta le notifiche come lette sul server.
  def download_online_notifications
    new_notifications = Notification_Service.download_and_set_read
    save_notifications(new_notifications)
  end

  # determina se è il momento di controllare la presenza di nuovi
  # messaggi dal server
  def need_refresh_notifications?
    return true if Notification_Service.first_check?
    Notification_Service.last_check.to_i + Notification_Service::CHECK_INTERVAL < Time.new.to_i
  end
end

#===============================================================================
# ** Window_NotificationMessages
#-------------------------------------------------------------------------------
# Finestra contenente le notifiche scaricate
#===============================================================================
class Window_NotificationMessages < Window_Selectable
  # l'altezza del contenuto dell'elemento
  def item_height
    line_height * 3
  end

  # aggiorna la grafica
  def refresh
    contents.clear
    return if @data.nil?
    create_contents
    super
  end

  # @param [Array<Online_Notification>] messages
  def set_messages(messages)
    @data = messages.sort.reverse
    refresh
  end

  # @param [Online_Notification] index
  def message(index = @index)
    @data[index]
  end

  # restituisce l'oggetto
  def item
    @data[self.index];
  end

  def item_max
    @data ? @data.size : 0;
  end

  def draw_item(index)
    item = message index
    rect = item_rect index
    draw_message_title(rect, item)
    draw_message_text(rect, item)
  end

  # @param [Rect] rect
  # @param [Notfication] message
  def draw_message_title(rect, message)
    icon = message.read? ? Notification_Service::READ_ICON : Notification_Service::UNREAD_ICON
    draw_icon(icon, rect.x, rect.y)
    change_color system_color
    draw_text(rect.x + 24, rect.y, contents_width - 24, line_height, message.title)
    unless message.read?
      x = rect.x + text_size(message.title + ' ').width + 24
      draw_icon(Settings::NEW_ADVICE_ICON, x, rect.y)
      #change_color crisis_color
      #draw_text(x, rect.y, contents_width, line_height, " - #{Vocab::New_Message}")
    end
    change_color normal_color
    draw_text(rect.x, rect.y, contents_width, line_height, message.time, 2)
  end

  # @param [Rect] rect
  # @param [Notfication] notification
  def draw_message_text(rect, notification)
    y = rect.y + line_height
    change_color normal_color
    draw_text_wrapped(rect.x, y, notification.message, rect.width)
  end
end

#===============================================================================
# ** Game_Map
#===============================================================================
class Game_Map

  alias h87_notifications_setup setup unless $@
  def setup(map_id)
    h87_notifications_setup(map_id)
    $game_system.check_new_notifications
  end
end

#===============================================================================
# ** Scene_Map
#===============================================================================
class Scene_Map < Scene_Base

  alias h87_notifications_start start unless $@
  def start
    h87_notifications_start
    $game_system.check_new_notifications
  end
end