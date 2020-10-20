class Window_Screenshot
  def initialize(viewport)
    @x = viewport.rect.x
    @y = viewport.rect.y
    @width = viewport.rect.width
    @height = viewport.rect.height
    @viewport = viewport
    @save_number = 0
    @screenshot = Sprite.new(viewport)
    @screenshot.opacity = 0
  end

  def set_save(new_slot)
    return if new_slot == @save_number
    @save_number = new_slot
    change_bitmap
  end

  def change_bitmap
    @new_bitmap = DataManager.load_screenshot(@save_number)
    @fade_old_bitmap = true
  end

  def update
    update_screenshot if !@screenshot.bitmap.nil?
  end

  def update_screenshot
    if @fade_old_bitmap
      fade_screenshot
    else
      show_screenshot
    end
  end

  def fade_screenshot
    @screenshot.opacity -= 50
    if @screenshot.opacity == 0
      @screenshot.bitmap = @new_bitmap.clone
      @screenshot.x = @x
      @screenshot.y = @y
      @screenshot.zoom_x = @width.to_f/@screenshot.width
      @screenshot.zoom_y = @screenshot.zoom_x
      @new_bitmap.dispose
      @new_bitmap = nil
      @fade_old_bitmap = false
    end
  end

  def show_screenshot
    @screenshot.opacity += 50
  end

  def dispose
    if !@screenshot.bitmap.nil?
      @screenshot.bitmap.dispose
    end
    @screenshot.dispose
    if !@new_bitmap.nil?
      @new_bitmap.dispose
    end
  end
end