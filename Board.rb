require File.expand_path('rm_vx_data')

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# Vocaboli principali
#===============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Testo mostrato quando scarica i messaggi
  # @return [String]
  #--------------------------------------------------------------------------
  def self.mess_download; 'Download dei messaggi in corso...'; end
  #--------------------------------------------------------------------------
  # * Quando non ci sono messaggi nella sfera
  # @return [String]
  #--------------------------------------------------------------------------
  def self.no_messages
    'Non ci sono messaggi in questa sfera. Vuoi essere il primo?'
  end
  #--------------------------------------------------------------------------
  # * Quando non si ricevono i dati
  # @return [String]
  #--------------------------------------------------------------------------
  def self.data_error; 'Errore nella ricezione dei dati.'; end
  #--------------------------------------------------------------------------
  # * Quando c'è un errore di connessione
  # @return [String]
  #--------------------------------------------------------------------------
  def self.connection_error; 'Impossibile collegarsi al server del gioco.'; end
  #--------------------------------------------------------------------------
  # * Il numero di messaggi
  # @return [String]
  #--------------------------------------------------------------------------
  def self.message_number; '%d messaggi'; end
  #--------------------------------------------------------------------------
  # * Aiuto della bacheca
  # @return [String]
  #--------------------------------------------------------------------------
  def self.board_help; 'Premi Azione per inserire un messaggio.'; end
  #--------------------------------------------------------------------------
  # * Aiuto nell'inserimento del testo
  # @return [String]
  #--------------------------------------------------------------------------
  def self.writing_help; 'Invio per spedire, F5 per inserire una emoji.'; end
  #--------------------------------------------------------------------------
  # * Aiuto durante l'invio del messaggio
  # @return [String]
  #--------------------------------------------------------------------------
  def self.send_help; 'Invio in corso, attendere...'; end
  #--------------------------------------------------------------------------
  # * Testo d'errore invio
  # @return [String]
  #--------------------------------------------------------------------------
  def self.send_error; 'Errore nell\'inviare il messaggio. Riprova.'; end
  #--------------------------------------------------------------------------
  # * Testo d'errore invio
  # @return [String]
  #--------------------------------------------------------------------------
  def self.auth_error; 'Errore di autenticazione.'; end
  #--------------------------------------------------------------------------
  # * Testo mostrato se bannato
  # @return [String]
  #--------------------------------------------------------------------------
  def self.ban_error
    'ATTENZIONE: Sei stato bannato. Non puoi inviare altri messaggi.'
  end
  #--------------------------------------------------------------------------
  # * Comandi della bacheca
  #--------------------------------------------------------------------------
  def self.board_write;'Scrivi';end
  def self.board_reply;'Rispondi';end
  def self.board_alert;'Segnala';end
  def self.board_stats;'Informazioni';end
  def self.update_board;'Aggiorna';end
  def self.banned;'BANNATO';end
end

#===============================================================================
# ** DashSettings
#-------------------------------------------------------------------------------
# Impostazioni della sfera dimensionale
#===============================================================================
module DashSettings
  #--------------------------------------------------------------------------
  # * Nomi delle sfere sparse per il mondo
  #--------------------------------------------------------------------------
  PLACES = {
      :badupub      => ['Baduelle',' di '],
      :entrabalti   => ['Caverne di Baltimora',' delle '],
      :baltimora    => ['Caverne di Baltimora',' delle '],
      :sirenas      => ['Sirenas',' di '],
      :sirepub      => ['Pub di Sirenas',' del '],
      :monfepub     => ['Pub di Monferras',' del '],
      :cerantopos   => ['Tana del Cerantopos',' della '],
      :florea       => ['Castello di Florea',' del '],
      :villa        => ['Villa Stregata',' della '],
      :bejed        => ['Torre di Bejed',' della '],
      :bejed2       => ['Torre di Bejed',' della '],
      :scalabejed   => ['Torre di Bejed',' della '],
      :ciclamini1   => ['Monti Ciclamini',' dei '],
      :ciclamini2   => ['Monti Ciclamini',' dei '],
      :ciclamini3   => ['Monti Ciclamini',' dei '],
      :ciclamini4   => ['Monti Ciclamini',' dei '],
      :pigwarts     => ['Accademia di Pigwarts',' dell\''],
      :labirinto    => ['Villa Stregata - Labirinto',' della '],
      :labirinto2   => ['Villa Stregata - Labirinto',' della '],
      :vampiro      => ['Dimora del vampiro',' della '],
      :carpia       => ['Carpia',' di '],
      :fasbury      => ['Porto di Fasbury',' del '],
      :sotterraneo  => ['Stanza segreta',' della '],
      :piramide     => ['Piramide Gassosa - P1',' della '],
      :piramide2    => ['Piramide Gassosa - P3',' della '],
      :piramide3    => ['Piramide Gassosa - P5',' della '],
      :faideeiba    => ['Faide-Eiba',' di '],
      :deserto      => ['Deserto Yascha',' del '],
      #:farse => ['Farse',' di '],
      :miniere10    => ['Miniere di Elmore',' delle '],
      :miniere1     => ['Miniere di Elmore',' delle '],
      :minierecarr  => ['Profondità di Elmore',' della '],
      :minierenigma => ['Enigma su binari',' dell\''],
      :farse        => ['Sotterranei di Farse',' dei '],
      :casaforesta  => ['Foresta di Elmore',' della '],
      :fogne1       => ['Fogne di Balthazar',' delle '],
      :fogne2       => ['Fogne di Balthazar',' delle '],
      :tempiofuori  => ['Esterno dell\'antico Tempio',' dell\''],
      :stanzatempio => ['Tempio perduto',' del '],
      :tempiototem  => ['Tempio perduto - piani inf.',' del '],
      :preogre      => ['Rovine di Adele',' delle '],
      :kumog        => ['Monte Kumo',' del '],
      :kumogr2      => ['Grotta di Kumo',' della '],
      :kaji         => ['Vulcano Kaji',' del '],
      :kajie        => ['Grotta Kaji',' della '],
      :cavaneve     => ['Monti innevati',' dei '],
      :cavaneve2    => ['Monti innevati',' dei '],
      :diamantica   => ['Diamantica',' di '],
      :havbase1     => ['Base di Havoc 1F',' della '],
      :havbase2     => ['Base di Havoc 3F',' della '],
      :yugureporto  => ['Porto di Yugure',' del '],
      :selvas       => ['Selva di salici',' della '],
      :balthazar    => ['Città di Balthazar',' della '],
      :balthapub    => ['Pub di Balthazar',' del '],
      :balthac1     => ['Castello in guerra',' del '],
      :balthac2     => ['Castello di Balthazar',' del '],
      :adele        => ['Pub di Adele',' del '],
      :yugupub      => ['Pub di Yugure',' del '],
      :nevandrapub  => ['Pub di Nevandra',' del '],
      :nevandracast => ['Castello di Nevandra',' del '],
      :northur      => ['Porto di Northur',' del '],
      :casamonica   => ['Villa di Monica',' della '],
      :prova        => ['prova','di'],
  }

  NOTIFY_SOUND = 'Chime2'
end

#===============================================================================
# ** BoardMessage
#-------------------------------------------------------------------------------
# Messaggio della dashboard
#===============================================================================
class BoardMessage
  # @attr[Integer] avatar
  # @attr[String] name
  # @attr[Integer] level
  # @attr[Time] date
  # @attr[String] message
  attr_reader :avatar       # ID dell'Avatar
  attr_reader :name         # Nome del giocatore
  attr_reader :level        # Livello del giocatore
  attr_reader :date         # Data del messaggio
  attr_reader :message      # Messaggio
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # text_string: stringa che contiene le informazioni
  # @param [String] text_string
  #--------------------------------------------------------------------------
  def initialize(text_string)
    params = text_string.split('|')
    @name = params[0].empty? ? params[3] : params[0]
    @avatar = params[1].empty? ? nil : params[1].to_i
    @level = params[2].to_i if params[2]
    @date = get_date(params[4])
    @message = params[5]
    @banned = params[6] == '1'
    #@message = params[5..params.size] * ','
    @registered = !params[0].empty?
  end
  #--------------------------------------------------------------------------
  # * Restituisce un formato Time da una data in stringa
  # @param [String] date_string
  #--------------------------------------------------------------------------
  def get_date(date_string)
    if date_string =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/
      Time.local($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se è un utente registrato o fa parte del Cap 3
  #--------------------------------------------------------------------------
  def registered?; @registered; end
  #--------------------------------------------------------------------------
  # * Restituisce true se è stato bannato
  #--------------------------------------------------------------------------
  def banned?; @banned; end
  #--------------------------------------------------------------------------
  # * Restituisce la data formattata come stringa
  # @return [String]
  #--------------------------------------------------------------------------
  def time
    return '' if @date.nil?
    sprintf('%d/%d/%d alle %d:%d',@date.day, @date.month, @date.year,
            @date.hour, @date.min)
  end
end

#===============================================================================
# ** Scene_MessageBoard
#-------------------------------------------------------------------------------
# Schermata della sfera dimensionale
#===============================================================================
class Scene_MessageBoard < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def start
    super
    create_info_window
    create_messages_window
    create_writing_window
    create_command_window
    create_emoji_window
    create_player_window
    download_messages
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra delle informazioni
  #--------------------------------------------------------------------------
  def create_info_window
    @info_window = Window_BoardInfo.new
    @info_window.set_name($game_temp.sphere_id)
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra dei messaggi
  #--------------------------------------------------------------------------
  def create_messages_window
    @message_window = Window_BoardMessage.new(@info_window.height)
    @message_window.y = @info_window.height
    @message_window.set_handler(:cancel, method(:return_scene))
    @message_window.set_handler(:ok, method(:message_handling))
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra di scrittura del messaggio
  #--------------------------------------------------------------------------
  def create_writing_window
    @writing_window = Window_BoardWriter.new(0, @info_window.height)
    @writing_window.set_handlers(method(:cancel_message), method(:do_send), method(:open_emoji))
    @writing_window.max_char = 200
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra dei comandi
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_BoardChoice.new(@info_window.height)
    @command_window.set_handler(:write, method(:do_write))
    @command_window.set_handler(:reply, method(:do_reply))
    @command_window.set_handler(:alert, method(:do_alert))
    @command_window.set_handler(:stats, method(:do_stats))
    @command_window.set_handler(:cancel, method(:do_back))
    @command_window.set_handler(:update, method(:do_update))
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra delle emoji
  #--------------------------------------------------------------------------
  def create_emoji_window
    y = @info_window.height + @writing_window.height
    @emoji_window = Window_Emoji.new(0, y)
    @emoji_window.set_handler(:ok, method(:add_emoji))
    @emoji_window.set_handler(:cancel, method(:close_emoji))
    @writing_window.emoji_window = @emoji_window
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_player_window
    y = @info_window.height
    @player_window = Window_PlayerInfo.new(0,y,Graphics.width)
    #@player_window.set_handler(:cancel, method(:close_player_info))
    @player_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Scrive il messaggio
  #--------------------------------------------------------------------------
  def do_write(initial_text = '')
    @old_help = @info_window.help
    @info_window.set_help(:writing)
    @command_window.unselect_start
    y = @message_window.y + @writing_window.height
    @message_window.smooth_move(0,y)
    @writing_window.text = initial_text
    @writing_window.x = 0 - @writing_window.width
    @writing_window.visible = true
    @writing_window.smooth_move(0, @writing_window.y)
    @writing_window.active = true
  end
  #--------------------------------------------------------------------------
  # * Apertura delle emoji
  #--------------------------------------------------------------------------
  def open_emoji
    @emoji_window.open
    @emoji_window.activate
    y = @info_window.height + @writing_window.height + @emoji_window.height
    @message_window.smooth_move(0, y)
  end
  #--------------------------------------------------------------------------
  # * Aggiunta dell'emoji al testo
  #--------------------------------------------------------------------------
  def add_emoji
    if @writing_window.rem > 0
      @writing_window.text += @emoji_window.item.char
    else
      NOTIFY_SOUND.play_buzzer
    end
    @emoji_window.activate
  end
  #--------------------------------------------------------------------------
  # * Chiude la finestra delle emoji
  #--------------------------------------------------------------------------
  def close_emoji
    @emoji_window.deactivate
    @emoji_window.close
    y = @info_window.height + @writing_window.height
    @message_window.smooth_move(0,y)
    @writing_window.active = true
  end
  #--------------------------------------------------------------------------
  # * Scrive il messaggio con risposta
  #--------------------------------------------------------------------------
  def do_reply
    do_write("[@#{@message_window.item.name}] ")
  end
  #--------------------------------------------------------------------------
  # * Segnala un messaggio
  #--------------------------------------------------------------------------
  def do_alert
  end
  #--------------------------------------------------------------------------
  # * Visualizza le statistiche
  #--------------------------------------------------------------------------
  def do_stats
    begin
      player = Online.get_player_info(@message_window.item.name)
    rescue ConnectionException
      print $!.message
      @command_window.activate
      return
    end
    @player_window.player = player
    @command_window.unselect_start
    @message_window.smooth_move(0, Graphics.height)
    @player_window.y = Graphics.height
    @player_window.visible = true
    @player_window.smooth_move(0, @info_window.height)
    @player_window.activate
  end
  #--------------------------------------------------------------------------
  # * Chide la finestra delle informazioni
  #--------------------------------------------------------------------------
  def close_player_info
    @player_window.smooth_move(0, Graphics.height)
    @message_window.smooth_move(0, @info_window.height)
    @message_window.activate
  end
  #--------------------------------------------------------------------------
  # * Invia il messaggio
  #--------------------------------------------------------------------------
  def do_send
    @writing_window.active = false
    @info_window.set_help(:sending)
    Graphics.update
    @message_window.smooth_move(0,@info_window.height)
    @message_window.activate
    #str = HTTP.domain + '/post_messaggio.php?mess=' + post_string
    url = Online.api_path + '/post_messaggio.php'
    #result = Base64.decode(await_response(str))
    begin
      result = base64_decode(submit_post_request(url, post_string))
    rescue InternetConnectionException
      result = 0
    end
    case result.to_i
      when -1
        NOTIFY_SOUND.play_buzzer
        @info_window.set_help(:auth_error)
      when 0
        Sound.play_buzzer
        @info_window.set_help(:send_error)
      when -2
        NOTIFY_SOUND.play_buzzer
        @info_window.set_help(:ban_error)
      else
        download_messages
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la sfera
  #--------------------------------------------------------------------------
  def do_update
    @message_window.smooth_move(0,@info_window.height)
    @command_window.unselect_start
    download_messages
    @message_window.activate
  end
  #--------------------------------------------------------------------------
  # * Annulla l'invio del messaggio
  #--------------------------------------------------------------------------
  def cancel_message
    @info_window.set_help(@old_help)
    @message_window.smooth_move(0,@info_window.height)
    @message_window.activate
  end
  #--------------------------------------------------------------------------
  # * Scarica i messaggi
  #--------------------------------------------------------------------------
  def download_messages
    #show_dialog_waiting(Vocab.mess_download)
    @info_window.set_help(:connecting)
    data = get_response_async("#{HTTP.domain}board.php?sphere=#{params}&t=#{rand}", method(:downloaded))
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'ID della sfera per la richiesta
  #--------------------------------------------------------------------------
  def params; base64_encode($game_temp.sphere_id); end
  #--------------------------------------------------------------------------
  # * Restituisce la stringa di risposta per l'invio del messaggio
  #--------------------------------------------------------------------------
  def post_string
    #name = $game_system.player.name
    #id = $game_party.id_partita
    #message = @writing_window.text
    #sphere = $game_temp.sphere_id
    #base64_encode(sprintf('%s|%s|%s|%s', name, id, message, sphere))
    {
        :player_name  => $game_system.player.name,
        :game_id      => $game_party.id_partita,
        :message      => @writing_window.text,
        :sphere       => $game_temp.sphere_id
    }
  end
  #--------------------------------------------------------------------------
  # * Metodo che viene chiamato quando la risposta è ricevuta
  #--------------------------------------------------------------------------
  def downloaded(response)
    data = Base64.decode(response)
    case data
      when '-1'; @info_window.set_help(:data_error)#show_dialog(Vocab.data_error)
      when '0'; @info_window.set_help(:downloaded)#show_dialog(Vocab.no_messages)
      when /[.]*<br>[.]*/i
        @info_window.set_help(:downloaded)
        elaborate_data(data)
      else; @info_window.set_help(:connection_error)#show_dialog(Vocab.connection_error)
    end
  end
  #--------------------------------------------------------------------------
  # * Elabora la risposta e trasforma i dati in messaggi
  #--------------------------------------------------------------------------
  def elaborate_data(data_string)
    messages = data_string.split('<br>')
    message_collection = []
    messages.each do |message|
      next if message.empty?
      message_collection.push(BoardMessage.new(message))
    end
    @message_window.set_messages(message_collection)
    @message_window.activate
    @info_window.set_number(messages.size)
    #close_dialog
  end
  #--------------------------------------------------------------------------
  # * Gestisce cosa fanno i messaggi
  #--------------------------------------------------------------------------
  def message_handling
    @command_window.select_start(@message_window.item)
    @message_window.smooth_move(@command_window.width, @message_window.y)
  end
  #--------------------------------------------------------------------------
  # * Annulla l'operazione delle opzioni
  #--------------------------------------------------------------------------
  def do_back
    @message_window.smooth_move(0, @message_window.y)
    @message_window.activate
    @command_window.unselect_start
  end
end

#===============================================================================
# ** Window_BoardInfo
#-------------------------------------------------------------------------------
# Piccola finestra sulle informazioni della sfera dimensionale
#===============================================================================
class Window_BoardInfo < Window_Base
  ALERT_ICON = 644
  INFO_ICON = 612
  LOADING_ICONS = [1216,1217,1218,1219,1220,1221,1222,1223]
  attr_reader :help
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    super(0,0,Graphics.width, fitting_height(2))
    @loading_state = 0
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_title
    draw_help
  end
  #--------------------------------------------------------------------------
  # * Aggiorna il rettangolo dell'icona
  #--------------------------------------------------------------------------
  def refresh_square
    contents.clear_rect(0,line_height,24,24)
    draw_icon(loading_icon, 0, line_height)
  end
  #--------------------------------------------------------------------------
  # * Disegna il titolo della sfera
  #--------------------------------------------------------------------------
  def draw_title
    if @name != nil
      draw_text(0,0,contents_width, line_height, @name)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna la stringa d'aiuto
  #--------------------------------------------------------------------------
  def draw_help
    return if @help.nil?
    case @help
      when :connecting
        icon = loading_icon;  text = Vocab.mess_download; color = crisis_color
      when :downloaded
        icon = INFO_ICON; text = Vocab.board_help; color = normal_color
      when :connection_error
        icon = ALERT_ICON; text = Vocab.connection_error; color = knockout_color
      when :data_error
        icon = ALERT_ICON; text = Vocab.data_error; color = knockout_color
      when :writing
        icon = INFO_ICON; text = Vocab.writing_help; color = normal_color
      when :sending
        icon = loading_icon; text = Vocab.send_help; color = crisis_color
      when :error_banned
        icon = ALERT_ICON; text = Vocab.ban_error; color = knockout_color
      when :send_error
        icon = ALERT_ICON; text = Vocab.send_error; color = knockout_color
      when :auth_error
        icon = ALERT_ICON; text = Vocab.auth_error; color = knockout_color
      else
        icon = 0; text = ''; color = normal_color
    end
    draw_icon(icon, 0, line_height)
    change_color(color)
    draw_text(24, line_height, contents_width, line_height, text)
    change_color(normal_color)
    if @number != nil
      text = sprintf(Vocab.message_number, @number)
      draw_text(0,0,contents_width, line_height, text,2)
    end
  end
  #--------------------------------------------------------------------------
  # * imposta il nome della sfera
  #   value: ID della sfera
  #--------------------------------------------------------------------------
  def set_name(value)
    place = DashSettings::PLACES[value.to_sym]
    @name = sprintf('Sfera %s %s',place[1], place[0])
    refresh
  end
  #--------------------------------------------------------------------------
  # * imposta il numero di messaggi
  #   value: numero
  #--------------------------------------------------------------------------
  def set_number(value)
    @number = value
    refresh
  end
  #--------------------------------------------------------------------------
  # * imposta il tipo d'aiuto
  #   symbol: simbolo del tipo
  #--------------------------------------------------------------------------
  def set_help(symbol)
    @help = symbol
    @loading_state = 0 if @help == :connecting
    refresh
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_loading if @help == :connecting
  end
  #--------------------------------------------------------------------------
  # * aggiorna il caricamento della finestra
  #--------------------------------------------------------------------------
  def update_loading
    return unless Graphics.frame_count%4==0
    @loading_state += 1
    refresh_square
  end
  #--------------------------------------------------------------------------
  # * restituisce l'icona adatta del caricamento
  #--------------------------------------------------------------------------
  def loading_icon
    LOADING_ICONS[@loading_state%LOADING_ICONS.size]
  end
end

#===============================================================================
# ** Window_BoardMessage
#-------------------------------------------------------------------------------
# Finestra che mostra tutti i messaggi della sfera dimensionale
#===============================================================================
class Window_BoardMessage < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(y)
    super(0,Graphics.height,Graphics.width,Graphics.height - y)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    super
  end
  #--------------------------------------------------------------------------
  # * Crea i contenuti della finestra
  #--------------------------------------------------------------------------
  def create_contents
    contents.dispose
    if contents_width > 0 && contents_height > 0
      self.contents = Bitmap.new(contents_width, contents_height)
    else
      self.contents = Bitmap.new(1, 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Altezza della riga
  #--------------------------------------------------------------------------
  def item_height; 120; end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    rect.width -= 4
    draw_page_index(rect.x + 100, rect.y, rect.width - 100, line_height)
    change_color(system_color)
    draw_text(rect.x + 105, rect.y,rect.width-100,line_height,item.name)
    change_color(normal_color)
    draw_text(rect.x + 100, rect.y,rect.width-105,line_height,item.time,2)
    draw_avatar(item.avatar, rect.x, rect.y)
    m_x = rect.x + 100; m_y = rect.y + line_height
    m_w = rect.width - m_x; m_h = rect.height - line_height
    draw_text(rect.x, rect.y+line_height*4,96,line_height,sprintf('%s %d',Vocab.level_a, item.level))
    draw_bg_rect(m_x-1, m_y-1, m_w+2, m_h+2)
    cl = Color_Rule.new(/\[/, /\]/, crisis_color)
    contents.draw_formatted_text(m_x+1, m_y+1, m_w-1, item.message, nil, cl)
    if item.banned?
      old_size = contents.font.size
      old_shadow = contents.font.shadow
      old_bold = contents.font.bold
      contents.font.size = 60
      contents.font.color = knockout_color
      contents.font.shadow = false
      contents.font.bold = true
      draw_text(rect, Vocab.banned, 1)
      contents.font.color = normal_color
      contents.font.size = old_size
      contents.font.shadow = old_shadow
      contents.font.bold = old_bold
    end
    draw_arrow(m_x-25, rect.y+96)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'indice del messaggio
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] w
  # @param [Integer] h
  #--------------------------------------------------------------------------
  def draw_page_index(x, y, w, h)
    self.contents.gradient_fill_rect(x, y, w, h, sc1, sc2, true)
    contents.clear_rect(0,0,1,1)
    contents.clear_rect(contents.width-1, 0,1,1)
    contents.clear_rect(0,line_height-1,1,1)
    contents.clear_rect(contents.width-1,line_height-1,1,1)
  end
  #--------------------------------------------------------------------------
  # * Disegna la freccia del fumetto
  #--------------------------------------------------------------------------
  def draw_arrow(x, y)
    for i in 0..23
      contents.fill_rect(x+i,y+i,x-i,1,sc1)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna la barra di sfondo al parametro
  #     x: coordinata X
  #     y: coordinata Y
  #     width: larghezza
  #     height: altezza
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Color] color
  #--------------------------------------------------------------------------
  def draw_bg_rect(x, y, width, height, color = sc1)
    contents.fill_rect(x+1, y+1, width-2, height-2, color)
  end
  #--------------------------------------------------------------------------
  # * Colore di sfondo 1
  # @return [Color]
  #--------------------------------------------------------------------------
  def sc1
    c = gauge_back_color
    c.alpha = 75
    c
  end
  #--------------------------------------------------------------------------
  # * Colore di sfondo 2
  # @return [Color]
  #--------------------------------------------------------------------------
  def sc2
    c = gauge_back_color
    c.alpha = 150
    c
  end
  #--------------------------------------------------------------------------
  # * Numero massimo di oggetti
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * Imposta i dati
  #   data: array di messaggi
  #--------------------------------------------------------------------------
  def set_messages(data)
    @data = data
    self.index = 0 if @data.size > 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto
  #--------------------------------------------------------------------------
  def item; @data[self.index];end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Caricamento della sfera
  #   scene_code: codice della sfera
  #--------------------------------------------------------------------------
  def load_board(scene_code)
    $game_temp.sphere_id = scene_code
    SceneManager.call(Scene_MessageBoard)
  end
end

#===============================================================================
# ** Game_Temp
#-------------------------------------------------------------------------------
# Aggiunta dell'ID della sfera che si sta visualizzando
#===============================================================================
class Game_Temp; attr_accessor :sphere_id; end

#===============================================================================
# ** Window_BoardChoice
#-------------------------------------------------------------------------------
# Finestra di comandi selezionando un messaggio
#===============================================================================
class Window_BoardChoice < Window_Command
  #--------------------------------------------------------------------------
  # * inizializzazione
  #   y: posizione y
  #--------------------------------------------------------------------------
  def initialize(y)
    super(Graphics.width, y)
    deactivate
    self.visible = false
    self.height = Graphics.height - y
  end
  #--------------------------------------------------------------------------
  # * restituisce la larghezza della finestra
  #--------------------------------------------------------------------------
  def window_width; 150; end
  #--------------------------------------------------------------------------
  # * restituisce l'altezza della finestra
  #--------------------------------------------------------------------------
  def window_height; Graphics.width - fitting_height(2); end
  #--------------------------------------------------------------------------
  # * crea la finestra dei comandi
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab.board_write, :write, write_check)
    add_command(Vocab.board_reply, :reply, reply_check)
    add_command(Vocab.board_alert, :alert, alert_check)
    add_command(Vocab.board_stats, :stats, stats_check)
    add_command(Vocab.update_board,:update)
  end
  #--------------------------------------------------------------------------
  # * Apparizione della finestra
  #--------------------------------------------------------------------------
  def select_start(item)
    activate
    self.x = 0 - self.width
    smooth_move(0, self.y)
    self.index = 0
    self.visible = true
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Scomparsa della finestra
  #--------------------------------------------------------------------------
  def unselect_start
    deactivate
    smooth_move(0-self.width, self.y)
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'utente può scrivere un messaggio
  #--------------------------------------------------------------------------
  def write_check
    return false unless $game_system.user_registered?
    return false if $game_system.user_banned?
    true
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'utente può rispondere ad un giocatore
  #--------------------------------------------------------------------------
  def reply_check
    return false unless item
    return false unless write_check
    return false unless item.registered?
    return false if item.banned?
    return false if item.name == $game_system.player.name
    true
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto
  #--------------------------------------------------------------------------
  def item; @item; end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'utente può segnalare un messaggio
  #--------------------------------------------------------------------------
  def alert_check; !reply_check; end
  #--------------------------------------------------------------------------
  # * Restituisce true se è possibile vedere le informazioni sul giocatore
  #--------------------------------------------------------------------------
  def stats_check; !reply_check; end
end