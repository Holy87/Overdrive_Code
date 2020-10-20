#===============================================================================
# ** Window_BoardMessage
#-------------------------------------------------------------------------------
# Finestra che mostra tutti i messaggi della sfera dimensionale
#===============================================================================
class Window_BoardMessage < Window_Selectable
  # Inizializzazione
  def initialize(y)
    super(0, Graphics.height, Graphics.width, Graphics.height - y)
  end

  # Refresh
  def refresh
    self.index = -1
    return if @data.nil?
    self.index = 0
    create_contents
    super
  end

  # @param [Array<Board_Message>] messages
  def set_messages(messages)
    @data = messages
    refresh
  end

  # @return [Board_Message]
  def message(index = @index)
    @data[index]
  end


  # Altezza della riga
  def item_height
    line_height * 5;
  end

  # Disegna l'oggetto
  def draw_item(index)
    item = message(index)
    rect = item_rect(index)

    draw_author_section(rect, item)
    draw_content_section(rect, item)
  end

  # @param [Rect] rect
  # @param [Board_Message] message
  def draw_author_section(rect, message)
    draw_page_index(rect.x + 100, rect.y, rect.width - 100, line_height)
    draw_author_name(rect.x + 105, rect.y, rect.width - 100, message)
    draw_message_date(rect.x + 100, rect.y, rect.width - 105, message)
    draw_avatar(message.registered? ? message.author.avatar : nil, rect.x, rect.y)
    return unless message.registered?
    draw_author_level(rect.x, rect.y + line_height * 4, 96, message.author)
    draw_author_title(rect.x + 105 + text_size(message.author_name + ' - ').width, rect.y, message.author)
  end

  # @param [Rect] rect
  # @param [Board_Message] item
  def draw_content_section(rect, item)
    m_x = rect.x + 100; m_y = rect.y + line_height
    m_w = rect.width - m_x; m_h = rect.height - line_height
    #draw_bg_rect(m_x - 1, m_y - 1, m_w + 2, m_h + 2)
    text = convert_tag_text(item.message)
    draw_text_wrapped(m_x + 1, m_y + 1, text, m_w - 1)
    draw_banned_message(rect) if item.banned?
    #draw_arrow(m_x - 25, rect.y + 96)
  end

  # @param [Board_Message] message
  def draw_author_name(x, y, width, message)
    change_color(system_color)
    draw_text(x, y, width, line_height, message.author_name)
    change_color(normal_color)
  end

  # @param [Online_Player] author
  def draw_author_title(x, y, author)
    title = author.title
    return if title.nil?
    change_color(title_color(title.type))
    draw_text(x, y, contents_width, line_height, title.name)
    change_color normal_color
  end

  # @param [Board_Message] item
  def draw_message_date(x, y, width, item)
    draw_text(x, y, width, line_height, item.time, 2)
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Online_Player] author
  def draw_author_level(x, y, width, author)
    draw_text(x, y, width, line_height, sprintf('%s %d', Vocab.level_a, author.level))
  end

  # se è presente un tag nel testo, aggiunge \c[x] e \c[0] all'inizio e alla fine
  # @param [String] text
  # @return [String]
  def convert_tag_text(text)
    color = Overdrive_Board_Settings::TAG_COLOR_CODE # crisis color di default
    text.gsub(Overdrive_Board_Settings::PLAYER_TAG_PATTERN) {"\\C[#{color}]#{$1}\\C[0]"}
  end

  # Disegna l'indice del messaggio
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] w
  # @param [Integer] h
  def draw_page_index(x, y, w, h)
    self.contents.gradient_fill_rect(x, y, w, h, sc1, sc2, true)
    contents.clear_rect(0, 0, 1, 1)
    contents.clear_rect(contents.width - 1, 0, 1, 1)
    contents.clear_rect(0, line_height - 1, 1, 1)
    contents.clear_rect(contents.width - 1, line_height - 1, 1, 1)
  end

  # disegna una grande scritta rossa con BANNATO
  # @param [Rect] rect
  def draw_banned_message(rect)
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

  # Disegna la freccia del fumetto
  def draw_arrow(x, y)
    (0..23).each { |i| contents.fill_rect(x + i, y + i, x - i, 1, sc1) }
  end

  # Disegna la barra di sfondo al parametro
  #     x: coordinata X
  #     y: coordinata Y
  #     width: larghezza
  #     height: altezza
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Color] color
  def draw_bg_rect(x, y, width, height, color = sc1)
    contents.fill_rect(x + 1, y + 1, width - 2, height - 2, color)
  end

  # Numero massimo di oggetti
  def item_max
    @data ? @data.size : 0;
  end

  # Imposta la sfera dimensionale
  # @param [Dimensional_Sphere] online_board
  def set_board(online_board)
    return if @online_board == online_board
    @online_board = online_board
    refresh
  end

  # restituisce l'oggetto
  def item
    @data[self.index];
  end
end