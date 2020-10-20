#==============================================================================
# ** Window_SingleLineInput
#------------------------------------------------------------------------------
#  Finestra multiuso per input di testo a riga singola
#==============================================================================
class Window_SingleLineInput < Window_TextInput
  # @param [Integer] x
  # @param [Integer] y
  # @param [Hash] options
  def initialize(x, y, options = nil)
    super(x, y, 100, fitting_height(2), options)
    @title = options[:title]
    adjust_width
  end

  def text_input_rect
    Rect.new(0, line_height, contents_width - 24, line_height)
  end

  def refresh
    contents.clear
    super
    change_color system_color
    draw_text(0, 0, contents_width, line_height, @title)
    change_color normal_color
    draw_keyboard_icon(:VK_RETURN, contents_width - 24, line_height)
  end

  def adjust_width
    width = [
        text_size(@title).width,
        text_size('O' * @max_characters).width + 24
    ].max + padding * 2
    self.width = width
    create_contents
    refresh
  end
end