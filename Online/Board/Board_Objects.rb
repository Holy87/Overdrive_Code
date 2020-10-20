#===============================================================================
# ** Dimensional_Sphere
#-------------------------------------------------------------------------------
# Oggetto che contiene le informazioni sulla sfera dimensionale
#===============================================================================
class Dimensional_Sphere
  # @param [Symbol,String] board_id
  def initialize(board_id)
    @board_id = board_id.to_sym
  end

  # @return [String]
  def name
    place = Overdrive_Board_Settings::PLACES[@board_id]
    return sprintf('%s: name not found', @board_id) if place.nil?
    sprintf('Sfera %s %s', place[1] || 'di', place[0])
  end

  # restituisce i messaggi della sfera (o li scarica)
  # @return [Array<Board_Message>]
  def messages
    @messages ||= refresh
  end

  # scarica i messaggi ordinati per data decrescente.
  # @raise [ConnectionException]
  # @return [Array<Board_Message>]
  def refresh
    response = Online.get(:board, :messages, {:board_id => @board_id.to_s})
    raise InternetConnectionException.new(response.body, Vocab.data_error) unless response.json?
    @messages = JSON.decode(response.body).map {|obj| Board_Message.new(obj)}.sort{|a, b| b.date <=> a.date}
  end

  # invia il messaggio della sfera dimensionale al server.
  # @param [String] message
  # @return [Online::Operation_Result]
  def post(message)
    params = {
        :board_id => @board_id,
        :message => base64_encode(message)
    }
    Online.upload(:board, :message, params)
  end
end

#===============================================================================
# ** Board_Message
#-------------------------------------------------------------------------------
# Messaggio della sfera dimensionale
#===============================================================================
class Board_Message
  attr_reader :date # Data del messaggio
  attr_reader :message # Messaggio
  attr_reader :message_id # ID del messaggio nel database
  attr_reader :old_player_name # nome del vecchio giocatore
  # Inizializzazione
  # @param [Hash{String->Object}] data
  def initialize(data)
    @old_player_name = data['old_name']
    @date = get_date(data['date'])
    @message = base64_decode(data['message'])
    @message_id = data['message_id']
    @author = Online_Player.new(data['author']) if data['author']
  end

  # Ottiene l'autore del messaggio
  # @return [Online_Player]
  def author
    @author
  end

  # restituisce il nome dell'autore
  # @return [String]
  def author_name
    registered? ? author.name : @old_player_name
  end

  def author_id
    registered? ? author.player_id : 0
  end

  # Restituisce un formato Time da una data in stringa
  # @param [Time] date_string
  def get_date(date_string)
    if date_string =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/
      Time.local($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
    end
  end

  # Restituisce true se è un utente registrato o fa parte del Cap 3
  def registered?
    @author != nil
  end

  # Restituisce true se è stato bannato
  def banned?
    return false unless registered?
    author.banned?
  end

  # Restituisce la data formattata come stringa
  def time
    return '' if @date.nil?
    sprintf('%d/%d/%d %d:%d', @date.day, @date.month, @date.year,
            @date.hour, @date.min)
  end
end