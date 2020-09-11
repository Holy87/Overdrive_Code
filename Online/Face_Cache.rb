#===============================================================================
# * Window_Base
#===============================================================================
class Window_Base < Window

  # Disegna l'avatar di un giocatore online.
  # @param [Integer] avatar_id
  # @param [Integer] x
  # @param [Integer] y
  def draw_avatar(avatar_id, x, y)
    contents.blt(x, y, $game_temp.avatars[avatar_id], Rect.new(0,0,96,96))
  end
end

#===============================================================================
# ** Game_Temp
#===============================================================================
class Game_Temp

  # ottiene gli avatar caricati
  # @return [Face_Cache]
  def avatars
    @avatars ||= Face_Cache.new
  end
end

#===============================================================================
# ** Face_Cache
#-------------------------------------------------------------------------------
# Una classe che si occupa di caricare e restituire gli avatar giocatore
#===============================================================================
class Face_Cache
  attr_reader :images
  AVAILABLE_FACES = %w(Actor1_o Actor2_o Actor3_o Actor4 Actor5 Evil J_Actor1 J_Actor3)

  def initialize
    @images = AVAILABLE_FACES
    @cache = {}
  end

  # determina il numero di avatar selezionabili
  # @return [Integer]
  def item_max
    @images.size * 8
  end

  # Restituisce la bitmap con in ID cercato
  # @param [Integer] avatar_id
  # @return [Bitmap]
  def [](avatar_id)
    face(avatar_id)
  end

  # Restituisce la bitmap del face con ID
  # @param [Integer] avatar_id
  # @param [Integer] size
  # @return [Bitmap]
  def face(avatar_id, size = 96)
    return no_face if avatar_id.nil?
    return no_face if @images[avatar_id/8].nil?
    return @cache[avatar_id] if @cache[avatar_id]
    load_face(avatar_id, size)
  end

  # Restituisce tutte le bitmap degli avatar in un array
  # @return [Array<Bitmap>]
  def all_faces
    item_max.times.map { |i| face(i) }
  end

  # Restituisce un volto generico oscurato
  # @return [Bitmap]
  def no_face
    Cache.face("Noface")
  end

  private

  # Carica in cache una bitmap e la restituisce
  # @param [Integer] avatar_id
  # @param [Integer] size
  # @return [Bitmap]
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
    face_bitmap
  end
end