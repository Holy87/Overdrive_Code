=begin
 ==============================================================================
  ■ Barra di scorrimento di Holy87
      versione 1.0
      Difficoltà utente: ★
      Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
      lo script nei propri progetti, sia amatoriali che commerciali. Vietata
      l'attribuzione impropria.
 ==============================================================================
    Questo script mostra una barra di scorrimento alle finestre con cursore
    quando il numero degli oggetti presente supera quello visualizzabile.
 ==============================================================================
  ■ Installazione e istruzioni
    Installare questo script sotto Materials e prima del Main.
    In basso è possibile configurare colore e dimensioni.
=end

#==============================================================================
# ** CONFIGURAZIONE
#==============================================================================
module Scrollbar_Settings
  # Colore della barra. Va inserito l'indice del colore del testo,
  # quello sulla Windowskin.
  SCROLLBAR_FOREGROUND_COLOR = 0
  # colore di sfondo della barra.
  SCROLLBAR_BACKGROUND_COLOR = 19
  # spessore della barra, in pixel
  BAR_THICKNESS = 4
  # lo spostamento a destra rispetto alla fine del testo
  BAR_SPACING = 1
  # Scegli se vuoi mostrare la barra solo sulle finestre attive
  SHOW_ONLY_ON_ACTIVE = false
end

# ~ ~ ~ ~ ~ ~ ~ ATTENZIONE: NON MODIFICARE DA QUI ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~






#==============================================================================
# ** Window_Selectable
#==============================================================================
class Window_Selectable < Window_Base
  attr_accessor :scrollbar_visible

  include Scrollbar_Settings

  alias window_scrollbar_initialize initialize unless $@
  alias window_scrollbar_dispose dispose unless $@
  alias window_scrollbar_update update unless $@
  alias window_scrollbar_viewport viewport= unless $@

  def initialize(x, y, width, height)
    window_scrollbar_initialize(x, y, width, height)
    init_scrollbar
  end

  def dispose
    window_scrollbar_dispose
    dispose_scrollbar
  end

  def update
    window_scrollbar_update
    update_scrollbar
  end

  # @param [Viewport] new_viewport
  def viewport=(new_viewport)
    window_scrollbar_viewport(new_viewport)
    set_scrollbar_viewport(new_viewport)
  end

  def init_scrollbar
    return if @vert_scrollbar_background != nil
    @scrollbar_visible = true
    @vert_scrollbar_background = Sprite.new(@viewport)
    @vert_scrollbar_foreground = Sprite.new(@viewport)
    @vert_scrollbar_background.bitmap = scrollbar_background_bitmap
    @vert_scrollbar_foreground.bitmap = scrollbar_foreground_bitmap
    update_scrollbar
  end

  def set_scrollbar_viewport(viewport)
    @vert_scrollbar_background.viewport = viewport
    @vert_scrollbar_foreground.viewport = viewport
  end

  # free scrollbar graphic
  def dispose_scrollbar
    @vert_scrollbar_foreground.dispose
    @vert_scrollbar_background.dispose
  end

  def scrollbar_visible=(value)
    @scrollbar_visible = value
    update_scrollbar
  end

  # update the scrollbar position
  def update_scrollbar
    @vert_scrollbar_background.visible = scrollbar_visible?
    @vert_scrollbar_foreground.visible = scrollbar_visible?
    return unless scrollbar_visible?
    @vert_scrollbar_foreground.x = vert_scrollbar_x
    @vert_scrollbar_background.x = vert_scrollbar_x
    @vert_scrollbar_background.y = vert_scrollbar_y
    @vert_scrollbar_foreground.y = vert_scrollbar_y
    @vert_scrollbar_background.z = self.z + 10
    @vert_scrollbar_foreground.z = self.z + 12
    @vert_scrollbar_background.opacity = self.contents_opacity / 2
    @vert_scrollbar_foreground.opacity = self.contents_opacity
    @vert_scrollbar_foreground.zoom_y = scrollbar_height * vert_scrollbar_rate
    @vert_scrollbar_background.zoom_y = scrollbar_height
    @vert_scrollbar_foreground.y += vert_scrollbar_position
  end

  # @return [Fixnum, Float]
  def vert_scrollbar_rate
    return 1 if contents.nil? or contents.height == 0
    #noinspection RubyYardReturnMatch
    [[0, scrollbar_height.to_f / contents.height.to_f].max, 1].min
  end

  def vert_scrollbar_x
    self.x + self.width - padding + BAR_SPACING
  end

  def vert_scrollbar_y
    self.y + padding
  end

  def scrollbar_height
    self.height - padding * 2
  end

  def vert_scrollbar_position
    self.oy * vert_scrollbar_rate
  end

  def scrollbar_visible?
    return false unless self.visible
    return false unless self.open?
    return false if self.index < 0
    return false if SHOW_ONLY_ON_ACTIVE and !active
    return false if contents.height <= scrollbar_height
    @scrollbar_visible
  end

  # @return [Bitmap]
  def scrollbar_background_bitmap
    bitmap = Bitmap.new(BAR_THICKNESS, 1)
    bitmap.fill_rect(0, 0, BAR_THICKNESS, 1, scrollbar_background_color)
    bitmap
  end

  # @return [Bitmap]
  def scrollbar_foreground_bitmap
    bitmap = Bitmap.new(BAR_THICKNESS, 1)
    bitmap.fill_rect(0, 0, BAR_THICKNESS, 1, scrollbar_color)
    bitmap
  end

  # Il colore della barra
  # @return [Color]
  def scrollbar_color
    text_color(SCROLLBAR_FOREGROUND_COLOR)
  end

  # Il colore dello sfondo della barra
  # @return [Color]
  def scrollbar_background_color
    text_color(SCROLLBAR_BACKGROUND_COLOR)
  end

  if $imported['H87_Windowskins']
    def refresh_windowskin(need_refresh = false)
      super
      init_scrollbar if @vert_scrollbar_foreground.nil?
      @vert_scrollbar_background.bitmap = scrollbar_background_bitmap
      @vert_scrollbar_foreground.bitmap = scrollbar_foreground_bitmap
    end
  end
end