class Game_Mail
  include Comparable
  attr_reader :sender
  attr_reader :sender_face
  attr_reader :subject
  attr_reader :message
  attr_reader :date

  # @param [String] sender
  # @param [Object] sender_face
  # @param [String] subject
  # @param [String] message
  # @param [Time,String] date
  # @param [Boolean] important
  def initialize(sender, sender_face, subject, message, date = Time.new, important = false)
    @read = false
    @archived = false
    @sender = sender
    @sender_face = sender_face
    @subject = subject
    @message = message
    #noinspection RubyYardParamTypeMatch
    @date = date.is_a?(String) ? date_from_string(date) : date
    @important = important
  end

  def read?
    @read
  end

  def set_read
    @read = true
  end

  def set_unread
    @read = false
  end

  def is_important?
    @important
  end

  def archived?
    @archived
  end

  def archive
    @archived = true
  end

  # Restituisce la data formattata come stringa
  def time
    return '' if @date.nil?
    sprintf('%d/%d/%d alle %d:%d', @date.day, @date.month, @date.year,
            @date.hour, @date.min)
  end

  # @param [Game_Mail] other
  def <=>(other)
    self.date <=> other.date
  end

  private

  # @param [String] date_str
  def date_from_string(date_str)
    if date_str =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/
      Time.local($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
    end
  end
end

class Game_System
  attr_accessor :need_notification

  # @return [Array<Game_Mail>]
  def mails
    @mails ||= []
  end

  # @param [String] sender
  # @param [Object] sender_face
  # @param [String] subject
  # @param [String] message
  # @param [Time,String] date
  # @param [Boolean] important
  def add_mail(sender, sender_face, subject, message, date = Time.new, important = false)
    mails.push(Game_Mail.new(sender, sender_face, subject, message, date, important))
    @need_notification = true
  end

  def need_mail_notification?
    @need_notification
  end
end