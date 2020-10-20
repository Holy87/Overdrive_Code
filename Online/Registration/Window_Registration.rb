#===============================================================================
# ** Window_RegistrationInfo
#-------------------------------------------------------------------------------
# Finestra di informazioni sulla registrazione
#===============================================================================
class Window_RegistrationInfo < Window_Base
  # Informazioni sulla registrazione
  attr_accessor :command_window # finestra di comando
  attr_reader :name # nome
  attr_reader :avatar # avatar
  attr_reader :status
  # @return [Player_Title]
  attr_reader :title

  # Inizializzazione
  # @param [Fixnum] x
  # @param [Fixnum] y
  # @param [Fixnum] width
  def initialize(x, y, width)
    height = fitting_height(4)
    super(x, y, width, height)
    @name = $game_party.nome_giocatore ? $game_party.nome_giocatore : Win.username
    @avatar = nil
    @title = Player_Titles.no_title
    refresh
  end

  # @return [Rect]
  def avatar_rect
    Rect.new(0, 0, 96, 96)
  end

  # @return [Rect]
  def name_rect
    Rect.new(100, 0, contents_width - 100, line_height)
  end

  # @return [Rect]
  def title_rect
    Rect.new(100, line_height * 2, contents_width - 100, line_height)
  end

  # @return [Rect]
  def name_validation_rect
    Rect.new(100, line_height, contents_width - 100, line_height)
  end

  def data_ok?
    @status == Online::NAME_VALID and @avatar != nil
  end

  def set_name_status(new_status)
    return if new_status == @status
    @status = new_status
    refresh_name_status
  end

  # Cambia nome (avviato alla conferma del nome digitato)
  # @param [String] new_name
  def set_player_name(new_name)
    return if new_name == @name
    @name = new_name
    refresh_name
  end

  # Cambio avatar
  # @param [Integer] new_avatar
  def change_avatar(new_avatar)
    return if @avatar == new_avatar
    @avatar = new_avatar
    refresh_avatar
  end

  def change_title(new_title)
    return if @title == new_title
    @title = new_title
    refresh_title
  end

  # Refresh
  def refresh
    refresh_avatar
    refresh_name
    refresh_name_status
    refresh_title
  end

  def refresh_avatar
    rect = avatar_rect
    contents.clear_rect(rect)
    draw_avatar(@avatar, rect.x, rect.y)
  end

  def refresh_name
    rect = name_rect
    contents.clear_rect(rect)
    change_color(system_color)
    draw_text(rect, Vocab.username + ':')
    change_color normal_color
    draw_text(rect, @name, 2)
  end

  def refresh_title
    rect = title_rect
    contents.clear_rect(rect)
    change_color(system_color)
    draw_text(rect, Vocab.player_title)
    change_color title_color(@title.type)
    draw_text(rect, @title.name, 2)
  end

  def refresh_name_status
    rect = name_validation_rect
    contents.clear_rect rect
    case @status
    when Online::NAME_VALID
      change_color power_up_color
      text = Vocab.name_available
    when Online::NAME_ALREADY_PRESENT
      change_color crisis_color
      text = Vocab.name_used
    when Online::NAME_WORD_FORBIDDEN
      change_color power_down_color
      text = Vocab.name_wrong
    when Online::CREATION_ERROR
      change_color power_down_color
      text = Vocab.name_error
    when Online::NAME_TOO_SHORT
      change_color crisis_color
      text = Vocab.name_too_short
    when Online::NO_CONNECTION_ERROR
      change_color power_down_color
      text = Online::CONN_ERROR_VOCAB
    when Online::SPECIAL_CHARACTER_NOT_ALLOWED
      change_color crisis_color
      text = Vocab.name_symbol_not_allowed
    else
      text = ''
    end
    draw_text(rect, text, 1)
  end
end