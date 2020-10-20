
class Window_BoardWriter < Window_TextInput

  def initialize(x, y)
    @emoji_window = nil
    @tag_present = false
    super(x, y, Graphics.width, fitting_height(4) + 12, Overdrive_Board_Settings::BOARD_WINDOW_SETTINGS)
    self.openness = 0
  end

  def update
    super
    update_emoji_call
  end

  def update_emoji_call
    return unless active?
    return if @emoji_handler.nil?
    return unless Input.trigger?(Overdrive_Board_Settings::EMOJI_KEY)
    deactivate
    @emoji_handler.call
  end

  # @param [Method] method
  def set_emoji_handler(method)
    @emoji_handler = method
  end

  # @return [Rect]
  def text_input_rect
    Rect.new(100, 0, contents_width - 104, line_height * 4)
  end

  # @return [Rect]
  def remaining_characters_rect
    @chr_rect ||= Rect.new(0, contents_height - 12, contents_width - 10, 12)
  end

  def clear
    clear_text
    refresh
  end

  def refresh
    contents.clear
    return unless active?
    return unless $game_system.user_registered?
    draw_avatar($game_system.player_face, 0, 0)
    draw_remaining_characters
  end

  def add_character(character)
    super
    draw_remaining_characters
  end

  def remove_character
    return if remove_player_quote
    super
    draw_remaining_characters
  end

  # @param [String] character
  def write_character(character)
    return super unless contents.emoji?(character)
    draw_emoji(Emoji.get(character), text_x, line_height * text_y)
  end

  # aggiunge il validatore di inizio e fine stringa al tag pattern
  # @return [Regexp]
  def tag_pattern
    rgx = Overdrive_Board_Settings::PLAYER_TAG_PATTERN
    Regexp.new('^' + rgx.source + '$', rgx.options)
  end

  def remove_player_quote
    return false unless @text =~ tag_pattern
    clear_text
    @tag_present = false
    true
  end

  # @param [String] player_name
  def set_player_quote(player_name)
    clear_text
    change_color crisis_color
    @text = sprintf('@{%s}', player_name)
    rect = text_input_rect
    draw_text(rect.x, rect.y, rect.width, line_height, player_name)
    @line_x[0] = text_size(player_name).width
    change_color normal_color
    @tag_present = true
    add_character SPACE_CHARACTER
  end

  # cancella e ridisegna i caratteri rimanenti
  def draw_remaining_characters
    contents.clear_rect(remaining_characters_rect)
    old_size = contents.font.size
    contents.font.size = 12
    draw_text(remaining_characters_rect, remaining_characters, 2)
    contents.font.size = old_size
  end

  # i caratteri rimanenti non devono tenere conto dei tre
  # invisibili usati per taggare
  def remaining_characters
    super + (@tag_present ? 3 : 0)
  end

  def char_width(character)
    Emoji.has?(character) ? 24 : super
  end
end