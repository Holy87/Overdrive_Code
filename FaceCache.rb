#===============================================================================
# ** 
#-------------------------------------------------------------------------------
# 
#===============================================================================
class Window_Base < Window
  def draw_avatar(avatar_id, x, y)
    contents.blt(x, y, $game_temp.avatars[avatar_id], Rect.new(0,0,96,96))
  end
end

#===============================================================================
# ** 
#-------------------------------------------------------------------------------
# 
#===============================================================================
class Game_Temp
  def avatars
    @avatars = Face_Cache.new unless @avatars
    return @avatars
  end
end

#===============================================================================
# ** 
#-------------------------------------------------------------------------------
# 
#===============================================================================
class Face_Cache
  attr_reader :images
  def initialize
    @images = ["Actor1_o", "Actor2_o", "Actor3_o", "Actor4", "Actor5", "Evil",
    "J_Actor1", "J_Actor3"]
    @cache = {}
  end
  
  def item_max
    return @images.size * 8
  end
  
  def [](avatar_id)
    return face(avatar_id)
  end
  
  def face(avatar_id, size = 96)
    return no_face if avatar_id.nil?
    return no_face if @images[avatar_id/8].nil?
    return @cache[avatar_id] if @cache[avatar_id]
    return load_face(avatar_id, size)
  end
  
  def load_face(avatar_id, size)
    faceset_bitmap = Cache.face(@images[avatar_id/8])
    face_bitmap = Bitmap.new(96,96)
    face_index = avatar_id%8
    rect = Rect.new(0, 0, 0, 0)
    rect.x = face_index % 4 * 96 + (96 - size) / 2
    rect.y = face_index / 4 * 96 + (96 - size) / 2
    rect.width = size
    rect.height = size
    face_bitmap.blt(0, 0, faceset_bitmap, rect)
    faceset_bitmap.dispose
    @cache[avatar_id] = face_bitmap
    return face_bitmap
  end
  
  def all_faces
    faces = []
    for i in 0..item_max-1
      faces.push(face(i))
    end
    return faces
  end
  
  def no_face
    return Cache.face("Noface")
  end
end