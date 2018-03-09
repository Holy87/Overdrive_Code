require File.expand_path('rm_vx_data')

class Window_Hybrid < Window_Command
  #--------------------------------------------------------------------------
  # * Restituisce le linee di testo descrittivo (va implementato nelle subcl)
  # @return [Integer]
  #--------------------------------------------------------------------------
  def text_lines
    0
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def text_height
    text_lines * line_height
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def contents_height
    text_height + super
  end
  #--------------------------------------------------------------------------
  # * Restituisce il rettangolo del cursore
  # @param [Integer] index
  # @return [Rect]
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super(index)
    rect.y += text_height
    rect
  end

  def window_width
    return 0 if @text.nil?
    [text.split(/[\r\n]+/).max_by{|str| str.size} + self.padding * 2, 160].max
  end
end

class Window_AskPopUp < Window_Hybrid
  def initialize
    super(0,0)
    add_command("OK", :ok)
    add_command("Annulla", :cancel)
    self.openness = 0
  end

  def call(text, ok_method, cancel_method)
    @text = text
    set_handler(:ok, ok_method)
    set_handler(:cancel, cancel_method)
    create_contents
    refresh
    open
  end

  def refresh
    contents.clear
    draw_paragraph_text
    draw_all_items
  end

  def text_lines
    return 0 if @text.nil?
    text.split(/[\r\n]+/).size
  end

  def col_max; 2; end

  def top_row
    super + text_height
  end

  def page_row_max
    super - text_lines
  end
end