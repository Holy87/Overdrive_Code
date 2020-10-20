class Scene_Base
  def create_item_emphasys
    @emphasis_background_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @emphasis_background_sprite = Sprite.new(@emphasis_background_viewport)
    @emphasis_background_sprite.bitmap = SceneManager.background_bitmap.clone.blur.blur
    @emphasis_background_sprite.opacity = 0
    @emphasis_background_viewport.z = 600
  end
end

