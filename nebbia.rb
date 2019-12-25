# script per la generazione di nebbia
# sostituisce quello scaricato da internet (Miget) che faceva davvero schifo.
#
# ISTRUZIONI:
# Inserire nell'Hash FOGS le configurazioni delle nebbie nelle varie mappe.
# Tecnicamente è stato fatto un copia-incolla dal vecchio script perché mi
# scocciavo di riconfigurarle tutte da zero.
# L'elemento dell'hash è così definito:
# ID_MAPPA => ['Nome panorama', Opacità(0..255), Blend(0,1,2), Zoom, MovX, MovY]
# Nome panorama è l'immagine che verrà presa dalla cartella Panorama.
# Opacità non ha bisogno di spiegazioni.
# Blend: 0-Normale, 1-Add, 2-Sub
# Zoom: 1 significa che è grandezza naturale, 0.5 grande la metà, 2 grande il doppio.
# MovX: movimento automatico in pixel lungo l'asse delle X.
# MovY: uguale ma sull'asse delle Y.
#
# Nei comandi evento:
# set_fogs([...]) imposta le nebbie nella mappa corrente
# set_fog(index, [...]) sostituisce o aggiunge una nebbia nella mappa corrente
#
module FOG_SETUP
  FOGS = {
      1 => ["Nuvolecielo",250,0,1,2,2],
      2 => ["NuvoleBig",40,0,2,2,1], # world map

      # bosco misterioso
      # MAP | Graphic   | Opacity | Blend | Zoom | +x | +y
      3 => ["Pini Frizz", 50,       0,      1,      0,  0],
      9 => ["Pini Frizz", 50,       0,      1,      0,  0],
      13 => ["Pini Frizz",30,       0,      1,      0,  0],
      10 => ["Pini Frizz",30,       0,      1,      0,  0],
      12 => ["Pini Frizz",60,       0,      1,      0,  0],
      14 => ["Pini Frizz",50,       0,      1,      0,  0],
      15 => ["Pini Frizz",40,       0,      1,      0,  0],
      16 => ["Pini Frizz",70,       0,      1,      0,  0],
      17 => ["Pini Frizz",70,       0,      1,      0,  0],
      18 => ["Pini Frizz",50,       0,      1,      0,  0],
      19 => ["Pini Frizz",50,       0,      1,      0,  0],
      # Ponte di Baltimora
      30 => [["NuvoleBig",40,0,2.5,2,1],["Fasci",200,1,1,0,0]],

      #Caverne di Baltimora
      7  => ["Nebbia",50,0,1,1,1],
      8  => ["Nebbia",50,0,1,1,1],
      37 => ["Nebbia",50,0,1,1,1],
      38 => ["Nebbia",50,0,1,1,1],
      39 => ["Nebbia",50,0,1,1,1],
      40 => ["Nebbia",50,0,1,1,1],
      41 => ["Nebbia",50,0,1,1,1],
      42 => ["Nebbia",50,0,1,1,1],
      43 => ["Nebbia",50,0,1,1,1],
      44 => ["Nebbia",50,0,1,1,1],
      45 => ["Nebbia",50,0,1,1,1],

      #Bosco di Salici
      73  => ["Nebbia",100,0,1,1,0],
      74  => ["Nebbia",100,0,1,1,0],
      75  => ["Nebbia",100,0,1,1,0],
      76  => ["Nebbia",100,0,1,1,0],
      77  => ["Nebbia",100,0,1,1,0],
      78  => ["Nebbia",100,0,1,1,0],
      79  => ["Nebbia",100,0,1,1,0],

      #Faide Eiba
      115 => ["Fasci",200,1,1,0,0],
      116 => ["Fasci",200,1,1,0,0],
      117 => ["Fasci",200,1,1,0,0],
      118 => ["Fasci",200,1,1,0,0],
      119 => ["Fasci",200,1,1,0,0],
      120 => ["Fasci",200,1,1,0,0],
      121 => ["Fasci",200,1,1,0,0],
      122 => ["Fasci",200,1,1,0,0],
      123 => ["Fasci",200,1,1,0,0],
      124 => ["Fasci",200,1,1,0,0],
      126 => ["Fasci",200,1,1,0,0],
      127 => ["Fasci",200,1,1,0,0],
      133 => ["Fasci",200,1,1,0,0],

      154 => ["Nuvole",60,0,5,0,-1], #Nave
      158 => ["Nebbia",120,0,1,1,1], #Vampiro

      #Grotte del deserto
      185 => ["Nebbia",100,2,2,0,0],
      186 => ["Nebbia",100,2,2,0,0],
      187 => ["Nebbia",100,2,2,0,0],
      194 => ["Nebbia",100,2,2,0,0],
      195 => ["Nebbia",100,2,2,0,0],

      #Aereonave
      196 => [["Velocity",100,1,1,-20,0],["Velocity",100,1,2,-40,0]],
      200 => [["Velocity",100,1,1,-20,0],["Velocity",100,1,2,-40,0]],

      #Miniere
      214 => ["Tempesta di Sabbia",100,2,2,0,0],
      215 => ["Tempesta di Sabbia",100,2,2,0,0],
      235 => ["Tempesta di Sabbia",100,2,2,0,0],
      239 => ["Tempesta di Sabbia",100,2,2,0,0],

      230 => [["Pini Frizz",60,0,1,0,0],["NuvoleBig",40,0,2.5,2,1]],
      240 => ["Nebbia",50,1,2,2,1], # fogne
      270 => ["Nebbia",100,0,1,1,0], # Diamantica Vecchia

      273 => ["Acqua2",40,1,1,1,1], #Rovine di Adele
      272 => [["Acqua2",40,1,1,1,1],["Acqua2",40,1,1,-1,-1]],
      284 => [["Acqua2",40,1,1,1,1],["Acqua2",40,2,1,-1,-1]],
      285 => [["Acqua2",40,1,1,1,1],["Acqua2",40,1,1,-1,-1]],
      286 => [["Acqua2",50,1,1,1,1],["Acqua2",30,2,1,-1,-1]],
      287 => [["Acqua2",40,1,1,1,1],["Acqua2",40,2,1,-1,-1]],
      288 => [["Acqua2",40,1,1,1,1],["Acqua2",40,2,1,-1,-1]],
      289 => [["Acqua2",40,1,1,1,1],["Acqua2",40,2,1,-1,-1]],

      # Yugure
      290 => [["Nebbia",50,1,1,1,1],["Nebbia",50,0,1.5,2,0]],

      # Monte Kumo
      302 => [["NuvoleBig",40,0,2.5,2,1],["Fasci",200,1,1,0,0]],
      303 => [["NuvoleBig",40,0,2.5,2,1],["Fasci",200,1,1,0,0]],
      309 => [["NuvoleBig",40,0,2.5,2,1],["Fasci",200,1,1,0,0]],
      321 => [["NuvoleBig",40,0,2.5,2,1],["Fasci",200,1,1,0,0]],
      304 => ["Nebbia",100,2,2,0,0],
      305 => ["Nebbia",100,2,2,0,0],
      306 => ["Nebbia",100,2,2,0,0],
      307 => ["Nebbia",100,2,2,0,0],
      308 => ["Nebbia",100,2,2,0,0],
      318 => ["Nebbia",100,2,2,0,0],
      319 => ["Nebbia",100,2,2,0,0],

      #Vulcano
      310 => [["Nebbia",100,2,2,0,0],["Nebbia",20,0,1,1,1]],
      311 => [["Nebbia",100,2,2,0,0],["Nebbia",25,0,1,1,1]],
      427 => [["Nebbia",100,2,2,0,0],["Nebbia",25,0,1,1,1]],
      312 => [["Nebbia",100,2,2,0,0],["Nebbia",30,0,1,1,1]],
      313 => [["Nebbia",100,2,2,0,0],["Nebbia",30,0,1,1,1]],
      314 => [["Nebbia",50,2,2,0,0],["Nebbia",50,0,1,1,1]],
      315 => ["Nebbia",30,1,2,1,0],
      316 => ["Nebbia",30,1,2,1,0],
      317 => ["Nebbia",35,1,2,1,0],
      426 => ["Nebbia",35,1,2,1,0],

      # Dominazioni (?)
      327 => [["StarlitSky",50,1,1,0,-1],["StarlitSky",40,1,1.5,0,-2],["StarlitSky",30,1,2,0,-4]],
      330 => ["Nebbia",100,2,2,0,0], # Ladri
      342 => [["Nebbia",25,2,1,1,0],["Nebbia",25,2,1,-1,0]],
      352 => [["Nebbia",25,2,1,1,0],["Nebbia",25,2,1,-1,0]], # labirinto viola
      371 => ["Nebbia",100,2,2,0,0], # bosco di Nevandra

      #Diamantica
      369 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      373 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      374 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      375 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      376 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      377 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      378 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      379 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      380 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],
      413 => [["NuvoleBlu",200,0,1,-3,0],["NuvoleBlu",200,0,2,-2,0],["NuvoleBlu",200,0,3,-1,0],["StarlitSky",50,1,1,-1,-1],["StarlitSky",50,1,1.5,0,-1]],

      409 => ["Nebbia",100,2,2,0,0], # pozzo di Sirenas
  }
end

#===============================================================================
# ** Spriteset_Fogs
#-------------------------------------------------------------------------------
# Classe che gestisce le nebbie sulla mappa.
#===============================================================================
class Spriteset_Fogs
  # @return [Array<Sprite_Fog>]
  attr_reader :fogs

  # @param [Viewport] viewport
  # @param [Array] fog_data
  def initialize(viewport, fog_data)
    @viewport = viewport
    setup_fogs(fog_data)
    @scroll_x = $game_map.display_x
    @scroll_y = $game_map.display_y
  end

  # imposta le nebbie
  # @param [Array] fog_data
  def setup_fogs(fog_data)
    @fogs = []
    return if fog_data.nil?
    if fog_data[0].is_a?(Array)
      fog_data.each { |data| setup_fog(data) }
    else
      setup_fog(fog_data)
    end
  end

  # crea un elemento nebbia
  # @param [Array] fog_data
  def setup_fog(fog_data)
    fog = Sprite_Fog.new(@viewport)
    set_fog_data(fog, fog_data)
    @fogs.push(fog)
  end

  # imposta i dati della nebbia sullo sprite
  # @param [Sprite_Fog] fog
  # @param [Array] fog_data
  def set_fog_data(fog, fog_data)
    fog.bitmap = Cache.parallax(fog_data[0])
    fog.opacity = fog_data[1] || 255
    fog.blend_type = fog_data[2] || 0
    fog.zoom_x = fog_data[3] || 1
    fog.zoom_y = fog_data[3] || 1
    fog.x_speed = fog_data[4] || 0
    fog.y_speed = fog_data[5] || 0
  end

  # aggiorna la posizione della nebbia sulla mappa
  def update_scrolling_maps
    @fogs.each { |fog| fog.update }
  end

  # aggiornamento
  def update
    update_scrolling_maps
  end

  # eliminazione
  def dispose
    @fogs.each { |fog| fog.dispose }
  end

  # elimina una nebbia
  def delete_fog(index)
    to_delete = @fogs.delete_at index
    to_delete.opacity = 0
    to_delete.dispose
  end

  # reimposta o aggiunge una nebbia
  # @param [Integer] index
  # @param [Array] data
  def reset_fog(index, data)
    if data.nil? || data.empty?
      delete_fog(index)
    elsif @fogs[index].nil?
      setup_fog(data)
    else
      set_fog_data(@fogs[index], data)
    end
  end

  # cancella e reinizializza tutta la nebbia
  # @param [Array] new_fog_data
  def reset_fogs(new_fog_data)
    @fogs.each { |fog| fog.opacity = 0; fog.dispose }
    setup_fogs(new_fog_data)
  end
end

#===============================================================================
# ** Sprite_Fog
#-------------------------------------------------------------------------------
# Lo sprite della nebbia, sottoclasse di Plane.
#===============================================================================
class Sprite_Fog < Plane
  attr_accessor :cum_x # ox cumulativo (per movimento auto)
  attr_accessor :cum_y # oy cumulativo (per movimento auto)

  def initialize(viewport)
    super(viewport)
    @cum_x = 0
    @cum_y = 0
    @fading = false
  end

  # aggiornamento
  def update
    @cum_x += @x_speed
    @cum_y += @y_speed
    self.ox = ($game_map.display_x + @cum_x) / 8.0
    self.oy = ($game_map.display_y + @cum_y) / 8.0
    fade_engine_update
  end
end

#===============================================================================
# ** Spriteset_Map
#===============================================================================
class Spriteset_Map
  alias create_true_timer create_timer unless $@
  alias h87fog_update update unless $@
  alias h87fog_dispose dispose unless $@

  # creazione della nebbia e del viewport
  def create_fogs
    @fog_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @fog_viewport.z = 150
    initial_fog_data = $game_map.fog_data
    @fogs = Spriteset_Fogs.new(@fog_viewport, initial_fog_data)
  end

  # creazione della nebbia dopo il timer
  def create_timer
    create_true_timer
    create_fogs
  end

  # aggiornamento
  def update
    h87fog_update
    @fogs.update
  end

  # eliminazione
  def dispose
    h87fog_dispose
    @fogs.dispose
  end

  # risetta i dati di una nebbia
  def setup_fog(index, data)
    @fogs.reset_fog(index, data)
  end

  # resetta tutte le nebbie con nuovi dati
  def reset_fogs(data)
    @fogs.reset_fogs(data)
  end
end

#===============================================================================
# ** Scene_Map
#===============================================================================
class Scene_Map
  attr_reader :spriteset
end

#===============================================================================
# ** Game_Map
#===============================================================================
class Game_Map
  # @return [Array] i dati della nebbia
  attr_reader :fog_data

  alias h87fog_setup setup unless $@

  def setup(map_id)
    h87fog_setup(map_id)
    @fog_data = FOG_SETUP::FOGS[$game_map.map_id]
  end

  # reimposta una nebbia (o la aggiunge, se assente)
  # @param [Integer] index
  # @param [Array] data
  def set_fog(index, data)
    @fog_data[index] = data
    @fog_data.compact!
    if SceneManager.is_a?(Scene_Map)
      SceneManager.scene.spriteset.setup_fog(index, data)
    end
  end

  # sostituisce i dati della nebbia
  def set_fog_data(data)
    @fog_data = data
    if SceneManager.scene_is?(Scene_Map)
      SceneManager.scene.spriteset.reset_fogs(data)
    end
  end
end

#===============================================================================
# ** Game_Interpreter
#===============================================================================
class Game_Interpreter
  # imposta le nebbie della mappa con nuovi dati
  def set_fogs(data)
    $game_map.set_fog_data(data)
  end

  # cambia i dati di una nebbia
  def set_fog(index, data)
    $game_map.set_fog(index, data)
  end
end