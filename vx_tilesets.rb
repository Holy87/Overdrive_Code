#Tilesets Aggiuntivi (semplice)
#creato da Holy87
# 03/04/2020 -> Rimodellato per cambio passabilità
# 11/03/2012 -> Script iniziato e finito

#Questo script ti permette di creare raccolte di tilesets da poter usare
#semplicemente e velocemente.
#INSTALLAZIONE: Installa sotto Materials, prima del Main.
#Attenzione: questo script non visualizza il tileset personalizzato nell'editor
#mappa, ma solo nel gioco.
#Questo script ora cambia anche la passabilità.


module H87_TLS
  Tilesets = {

      :default => {
          # Nome         Acqua  Terra  Muri-Est Muri-Int Matton.  Ogg1     Ogg2    Ogg3    Ogg4
          :graphic => %w(TileA1 TileA2 TileA3   TileA4   TileA5   TileB    TileC   TileD   TileE)
      },
      :default2 => {
          :graphic => %w(TileA1_T TileA2 TileA3 TileA4 TileA5 TileB TileC TileD TileE)
      },
      :dungeon => {
          :graphic => %w(TileA1_D TileA2_D TileA3 TileA4_D TileA5_D TileB_D TileC TileD TileE)
      },
      :inner => %w(TileA1_I TileA2_I TileA3 TileA4_I TileA5_I TileB_D TileC TileD TileE),
      :outdoor => %w(TileA1_O TileA2_O TileA3_O TileA4_O TileA5_O TileB_O TileC_O TileD TileE),
      :outdoor2 => %w(TileA1_OT TileA2_O TileA3_O TileA4_O TileA5_O TileB_O TileC_O TileD TileE),
      :diamantica => %w(TileA1_A TileA2_A TileA3_O TileA4_O TileA5_O TileB_A TileC_O TileD TileE),
      :world => %w(TileA1_W TileA2_W TileA3 TileA4 TileA5 TileB_W TileC TileD TileE),
      :samurai => %w(TileA1_J TileA2_J TileA3_J TileA4_J TileA5_J TileB_J TileC_J TileD_J TileE),
      :future => %w(TileA1_F TileA2_F TileA3_F TileA4_F TileA5_F TileB_F TileC_F TileD TileE_F),
      :modern => %w(TileA1_M TileA2_M TileA3_M TileA4_M TileA5_M TileB_F TileC_M TileD_M TileE_M),
      :ship => %w(TileA1_O TileA2 TileA3 TileA4 TileA5 TileB TileC TileD TileE),
      :deva => %w(TileA1_E TileA2_E TileA3 TileA4_E TileA5_E TileB TileC TileD_E TileE),
      :merchant_city => {
          :graphic => %w(TileA1_O TileA2_O TileA3_C TileA4_O TileA5_C TileB_C TileC_C TileD_C TileE),
          :passages => 'city'
      },
      :inner_ace => {
          :graphic => %w(Inside_A1 Inside_A2 TileA3 Inside_A4 Inside_A5 Inside_B Inside_C TileB_Lunarea TileE),
          :passages => 'inner_ace'
      }
  }


  def self.setup(id)
    case id
      #Setta l'ID Mappa
    when 888
      :default
    when 209, 86, 206, 237, 271..275, 117..119, 20, 230
      :default2
    when 134, 136, 137, 139, 141..144, 146, 250, 248, 277, 278..289, 322..328, 339..350, 357, 359, 363..366, 410..412, 422
      :inner
    when 10, 14, 49, 244, 85, 135, 303, 309, 321, 362, 176, 178, 30, 150, 12, 13, 30, 367, 370, 369, 372..380, 413
      :outdoor
    when 33, 150, 302, 337, 338, 351, 353, 356
      :outdoor2
    when 1, 2
      :world
    when 290..299, 300, 301, 331, 332
      :samurai
    when 39..42, 73..79, 304..308, 310..319, 330, 333..336, 352, 354, 355, 371, 409, 415, 426, 427
      :dungeon
    when 196..203, 381..386, 388..407
      :future
    when 154
      :ship
    when 416..419, 428, 429, 430
      :deva
    when 222
      :merchant_city
    when 223, 224
      :inner_ace
    else
      :default
    end
  end

end

class Custom_Tilesets
  # @return[Array<String>]
  attr_reader :tile_graphics
  # @return[Symbol]
  attr_reader :tag

  def initialize(map_id)
    @tag = H87_TLS::setup(map_id)
    data = H87_TLS::Tilesets[@tag]
    if data.is_a?(Array)
      @tile_graphics = data
      @passability = :default
    else
      @tile_graphics = data[:graphic]
      @passability = data[:passages] || :default
    end
  end

  # @return [Table]
  def passability
    load_data("Data/Passages/#{@passability}.rvdata")
  end
end

class Game_Map
  alias normal_map_setup setup unless $@
  # @return[Custom_Tilesets]
  attr_reader :tileset_data

  def setup(map_id)
    normal_map_setup(map_id)
    @tileset_data = Custom_Tilesets.new(map_id)
    @passages = @tileset_data.passability
  end
end

class Spriteset_Map
  alias create_basic_tilemap create_tilemap unless $@

  def create_tilemap
    create_basic_tilemap
    graphic = $game_map.tileset_data.tile_graphics
    (0..8).each { |i|
      @tilemap.bitmaps[i] = Cache.tileset(graphic[i])
    }
  end
end

class Sprite_Character < Sprite_Base

  def tileset_bitmap(tile_id)
    set_number = tile_id / 256
    graphic = $game_map.tileset_data.tile_graphics
    (5..8).each { |i|
      return Cache.tileset(graphic[i]) if set_number == (i - 5)
    }
    nil
  end
end

module Cache
  #--------------------------------------------------------------------------
  # * Get System Graphic
  #     filename : Filename
  #--------------------------------------------------------------------------
  def self.tileset(filename)
    load_bitmap("Graphics/Tilesets/", filename)
  end
end