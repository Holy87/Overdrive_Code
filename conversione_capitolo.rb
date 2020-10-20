# SCRIPT DI AGGIORNAMENTO DEI SALVATAGGI AL NUOVO CAPITOLO


#rimuovere skill 5074 e 508 ad angelo
#rimuovere skill da 480 a 489
#se c'è Volcan o var 175>2, aggiungi :kaji;
#se c'è Fuffi, aggiungi :piramid;
#se la missione 177>3 o kora < var_kora, aggiungi :erm
#

#==============================================================================
# ** SC_Mod
#------------------------------------------------------------------------------
#  Una serie di informazioni chiave per convertire i salvataggi
#==============================================================================
module SC_Mod

  # ID switch attivato quando aggiornato dal cap. 3 al 4
  FROM_OLD_CHAPTER_SW = 620

  TELEPORTS = {
      [309, 286] => [79, 85], #baduelle
      [310, 286] => [79, 85], #baduelle
      [319, 284] => [79, 85], #baduelle
      [125, 275] => [21, 95], #bejed
      [260, 270] => [58, 85], #caverne est
      [253, 267] => [48, 85],
      [258, 291] => [59, 89], #ponte w
      [260, 291] => [61, 89], #ponte e
      [184, 297] => [44, 96], #billy
      [198, 223] => [50, 69], #ponte g
      [164, 225] => [42, 76], #selva
      [147, 264] => [20, 85], #sirenas
      [173, 85] => [42, 33], #cast flore
      [174, 85] => [42, 33],
      [164, 94] => [30, 36],
      [111, 107] => [22, 24], #entr cicla
      [106, 103] => [20, 21], #uscita
      [107, 97] => [23, 19], #pigw
      [131, 327] => [36, 106], #vamp
      [137, 331] => [44, 105], #carpia
      [138, 331] => [44, 105],
      [148, 341] => [46, 106], #molo n
      [159, 346] => [51, 109], #modo s
      [137, 392] => [24, 123], #f-e
      [138, 392] => [25, 123], #f-e
      [174, 402] => [47, 142], #porto
      [429, 382] => [145, 151], #yugup
      [435, 375] => [147, 145], #yugu
      [452, 315] => [145, 131], #kaji
      [320, 120] => [115, 36], #porto elm
      [387, 124] => [138, 44], #adele
      [459, 226] => [125, 88], #eremita
      [453, 173] => [157, 71], #torre
      [440, 171] => [145, 67], #miniera
      [439, 167] => [138, 62], #farse
      [430, 112] => [155, 40], #balthazar
      [403, 100] => [143, 34], #for
      [403, 101] => [143, 34], #for
      [403, 102] => [143, 34], #for
      [403, 103] => [143, 34], #for
      [403, 104] => [143, 34], #for
      [400, 100] => [143, 34], #for
      [400, 101] => [143, 34], #for
      [400, 102] => [143, 34], #for
      [400, 103] => [143, 34], #for
      [400, 104] => [143, 34], #for
      [365, 87] => [130, 26], #doga
      [365, 85] => [130, 24],
      [330, 83] => [120, 26], #grotta
      [329, 70] => [123, 21],
      [322, 51] => [121, 16], #neva
      [317, 46] => [119, 11], #porton
      [286, 56] => [98, 20], #jarva
      [366, 58] => [141, 21], #bosco
      [368, 58] => [143, 21],
      [391, 73] => [157, 20]
  }

  HASH = {
      2 => [:baduelle],
      5 => [:sirenas],
      6 => [:bejed, :selva],
      10 => [:monferras],
      12 => [:florea, :ciclam],
      15 => [:pigwarts],
      20 => [:molosud, :carpia],
      26 => [:piramid, :faide],
      31 => [:fasbury],
      32 => [:elminer],
      33 => [:farse],
      34 => [:elporto, :adele, :balthaz],
      36 => [:balthacast],
      43 => [:kumo, :yugure],
      47 => [:dogan],
      48 => [:neve],
      49 => [:nevandra, :northur],
      50 => [:boscnev],
      51 => [:diamant]
  }

  MODDED_WEAPONS = {
      212 => 8.0001,
      215 => 9.0064,
      202 => 11.0098,
      203 => 11.0097,
      204 => 11.0099,
      234 => 13.0013,
      235 => 13.0037,
      251 => 15.0051,
      252 => 15.0059,
      253 => 15.0005,
      243 => 17.0016,
      244 => 17.0041,
      263 => 18.0049,
      264 => 18.0052,
      205 => 19.0020,
      206 => 19.0022,
      207 => 19.0042,
      190 => 22.0011,
      248 => 24.0056,
      249 => 24.0065,
      250 => 24.0042,
      208 => 28.0010,
      209 => 29.0010,
      210 => 30.0010,
      211 => 35.0001,
      223 => 36.0011,
      224 => 36.0016,
      225 => 36.0029,
      232 => 40.0037,
      233 => 40.0008,
      216 => 50.0002,
      191 => 53.0071,
      192 => 53.0072,
      193 => 53.0073,
      236 => 54.0038,
      237 => 54.0065,
      254 => 55.0057,
      255 => 55.0051,
      199 => 73.0017,
      200 => 73.0053,
      201 => 73.0027,
      229 => 74.0013,
      230 => 74.0014,
      261 => 74.0056,
      262 => 75.0065,
      231 => 90.0075,
      238 => 91.0064,
      239 => 91.0038,
      265 => 92.0041,
      266 => 92.0036,
      242 => 105.0033,
      198 => 106.0009,
      217 => 107.0009,
      218 => 107.0018,
      226 => 110.0030,
      227 => 110.0059,
      228 => 110.0052,
      245 => 111.0036,
      246 => 111.0059,
      247 => 111.0056,
      194 => 129.0002,
      195 => 129.0007,
      196 => 129.0025,
      214 => 150,
      221 => 130.0002,
      222 => 130.0022,
      256 => 133.0045,
      257 => 133.0046,
      258 => 133.0079,
      197 => 154.0010,
      219 => 156.0015,
      220 => 156.0079,
      259 => 157.0058,
      260 => 157.0041,
      240 => 176.0014,
      241 => 176.0004,
      213 => 76
  }

  #abilità da rimuovere ripristinando i PA
  REMOVED_SKILLS = {
      1 => 2000,
      2 => 1000,
      3 => 2000,
      4 => 200,
      5 => 1000,
      6 => 5000,
      7 => 500,
      8 => 4000,
      9 => 1600,
      10 => 1800,
      11 => 2630,
      12 => 2630,
      13 => 2630,
      14 => 2630,
      15 => 2930,
      16 => 2930,
      17 => 3030,
      18 => 3030,
      19 => 500,
      20 => 5000,
      21 => 1000,
      22 => 2360,
      23 => 4000,
      24 => 2000,
      25 => 3500,
      26 => 7000,
      27 => 7000,
      28 => 6350,
      29 => 8000,
      30 => 8000,
      31 => 4500,
      32 => 4500,
      33 => 400,
      34 => 2000,
      35 => 7000,
      36 => 1200,
      37 => 8000,
      38 => 6500,
      39 => 300,
      40 => 1300,
      41 => 1000,
      42 => 8000,
      43 => 370,
      44 => 750,
      45 => 1000,
      46 => 4000,
      47 => 2000,
      48 => 3000,
      49 => 700,
      50 => 700,
      51 => 700,
      52 => 700,
      53 => 700,
      54 => 700,
      55 => 700,
      56 => 500,
      57 => 3000,
      58 => 4000,
      59 => 350,
      60 => 2500,
      61 => 1700,
      62 => 5000,
      63 => 350,
      64 => 2500,
      65 => 1700,
      66 => 5000,
      67 => 450,
      68 => 3000,
      69 => 1900,
      70 => 6500,
      71 => 700,
      72 => 3000,
      73 => 800,
      74 => 3000,
      75 => 800,
      76 => 3000,
      77 => 3000,
      78 => 7000,
      79 => 3000,
      80 => 7000,
      81 => 4000,
      82 => 7000,
      83 => 10000,
      84 => 100,
      86 => 700,
      87 => 3500,
      88 => 8000,
      89 => 1000,
      90 => 2700,
      91 => 5000,
      92 => 5000,
      93 => 8000,
      94 => 2630,
      95 => 2836,
      96 => 5000,
      97 => 10000,
      98 => 4000,
      99 => 1500,
      100 => 5000,
      102 => 250,
      103 => 300,
      104 => 5550,
      105 => 6500,
      106 => 3200,
      107 => 6000,
      108 => 3500,
      109 => 3000,
      110 => 7000,
      111 => 4000,
      112 => 8000,
      113 => 3000,
      114 => 5000,
      115 => 5560,
      116 => 3560,
      117 => 9000,
      118 => 3000,
      119 => 800,
      121 => 2600,
      122 => 1200,
      123 => 3500,
      124 => 1200,
      125 => 1000,
      126 => 8000,
      127 => 4000,
      128 => 4000,
      129 => 4000,
      130 => 3250,
      131 => 8000,
      132 => 18000,
      133 => 3500,
      134 => 5000,
      135 => 3040,
      136 => 5000,
      137 => 15000,
      138 => 6000,
      139 => 6000,
      144 => 2000,
      145 => 200,
      146 => 4500,
      147 => 3000,
      148 => 8000,
      149 => 8000,
      150 => 3000,
      151 => 3000,
      152 => 4000,
      153 => 6500,
      154 => 700,
      155 => 1200,
      156 => 2000,
      157 => 3000,
      158 => 5000,
      161 => 7000,
      162 => 3200,
      163 => 3000,
      164 => 7000,
      165 => 7000,
      166 => 6000,
      167 => 7000,
      168 => 3000,
      171 => 2000,
      172 => 3000,
      173 => 3000,
      174 => 2000,
      175 => 4000,
      176 => 5000,
      177 => 3000,
      180 => 1000,
      181 => 1000,
      182 => 1000,
      183 => 2000,
      184 => 2500,
      185 => 2500,
      186 => 4000,
      187 => 5500,
      188 => 3000,
      189 => 3300,
      190 => 1500,
      191 => 4000,
      192 => 8000,
      193 => 6000,
      194 => 8000,
      195 => 2500,
      196 => 7000,
      204 => 6000,
      205 => 2000,
      206 => 2000,
      207 => 3000,
      208 => 3000,
      209 => 4500,
      210 => 4500,
      211 => 700,
      212 => 700,
      213 => 700,
      214 => 700,
      215 => 700,
      216 => 700,
      219 => 300,
      220 => 1600,
      221 => 3000,
      222 => 1200,
      223 => 5000,
      224 => 1200,
      225 => 7000,
      226 => 5500,
      227 => 3200,
      228 => 9500,
      229 => 1000,
      231 => 7256,
      232 => 5500,
      233 => 4800,
      234 => 9000,
      235 => 25000,
      236 => 10000,
      237 => 11000,
      238 => 8000,
      245 => 4000,
      246 => 2500,
      248 => 3000,
      249 => 7000,
      250 => 3000,
      251 => 4000,
      252 => 3000,
      253 => 4000,
      254 => 5000,
      255 => 6500,
      256 => 6000,
      257 => 3000,
      258 => 8500,
      259 => 8000,
      260 => 5650,
      261 => 5650,
      262 => 5650,
      263 => 5650,
      264 => 5650,
      265 => 6500,
      266 => 10000,
      267 => 8000,
      269 => 2500,
      270 => 1600,
      271 => 3000,
      272 => 800,
      273 => 2100,
      274 => 2500,
      275 => 750,
      276 => 7400,
      277 => 5600,
      278 => 5000,
      279 => 1000,
      280 => 3500,
      281 => 25000,
      282 => 6650,
      283 => 7800,
      284 => 8000,
      285 => 3400,
      301 => 50,
      302 => 1000,
      303 => 500,
      304 => 8500,
      306 => 2000,
      307 => 3000,
      310 => 7000,
      312 => 5000,
      314 => 5000,
      315 => 2000,
      316 => 2200,
      317 => 1000,
      318 => 500,
      319 => 2000,
      320 => 2000,
      321 => 1000,
      322 => 1000,
      323 => 2500,
      324 => 4000,
      325 => 4000,
      326 => 3000,
      327 => 5000,
      328 => 3000,
      329 => 1000,
      330 => 50,
      337 => 2000,
      338 => 2000,
      339 => 5000,
      340 => 2000,
      341 => 1200,
      342 => 6000,
      343 => 3000,
      344 => 3000,
      345 => 3000,
      346 => 3000,
      347 => 1200,
      348 => 5000,
      349 => 4000,
      350 => 4000,
      351 => 4000,
      352 => 2500,
      353 => 4000,
      354 => 5500,
      355 => 7500,
      356 => 5000,
      357 => 800,
      358 => 4000,
      365 => 2700,
      366 => 2700,
      367 => 2700,
      368 => 2700,
      371 => 500,
      372 => 1000,
      374 => 200,
      375 => 1000,
      376 => 5000,
      377 => 1200,
      378 => 3000,
      379 => 500,
      380 => 1000,
      381 => 6250,
      382 => 1000,
      383 => 1300,
      384 => 12500,
      385 => 12500,
      386 => 2000,
      417 => 8000,
      418 => 5000,
      419 => 10000,
      420 => 7000,
      421 => 2500,
      422 => 2500,
      423 => 9500,
      424 => 12500,
      425 => 12500,
      426 => 4500,
      427 => 8000,
      428 => 7560,
      429 => 1000,
      449 => 1000,
      450 => 3000,
      451 => 3000,
      452 => 3000,
      453 => 3000,
      454 => 3000,
      455 => 4000,
      456 => 6000,
      457 => 5000,
      458 => 4000,
      459 => 5000,
      460 => 2000,
      461 => 5000,
      462 => 2000,
      463 => 2000,
      464 => 2000,
      465 => 2000,
      466 => 2000,
      467 => 2000,
      468 => 2000,
      469 => 3000,
      470 => 3000,
      477 => 2000,
      478 => 3000,
  }

  REMOVED_PASSIVES = {
      38 => 600,
      39 => 1800,
      40 => 1800,
      41 => 10000,
      42 => 10000,
      43 => 2000,
      44 => 2000,
      45 => 2000,
      46 => 2000,
      47 => 1500,
      48 => 2000,
      49 => 2000,
      50 => 2000,
      51 => 3000,
      52 => 3000,
      53 => 3000,
      54 => 3000,
      55 => 3000,
      56 => 5000,
      57 => 2000,
      58 => 2300,
      59 => 2300,
      60 => 2000,
      61 => 1300,
      62 => 40000,
      63 => 50000,
      64 => 5000,
      65 => 100,
      66 => 1200,
      67 => 8000,
      68 => 8000,
      69 => 8000,
      70 => 8000,
      71 => 2000,
      72 => 7000,
      73 => 2000,
      74 => 5000,
      84 => 3500,
      86 => 15000,
      89 => 3000,
      90 => 6000,
      91 => 6000,
      92 => 4000,
      104 => 2000,
      147 => 2500,
      148 => 4500,
      149 => 1800,
      150 => 1800,
      151 => 800,
      152 => 900,
      153 => 7000,
      154 => 7000,
      155 => 7000,
      156 => 7000,
      157 => 7000,
      158 => 7000,
      159 => 7000,
      160 => 7000,
      161 => 7000,
      162 => 5000,
      164 => 2000,
      165 => 6000,
      168 => 20000,
      208 => 3000,
      218 => 9000,
      219 => 9000,
      226 => 5500,
      237 => 2000,
  }
  #abilità spostate
  SHIFTED_SKILLS = {
      #vecchio ID => nuovo ID
      137 => 140,
      470 => 472,
      469 => 471,
      468 => 470,
      467 => 469,
      466 => 468,
      465 => 467,
      464 => 466,
      463 => 465,
      231 => 232,
      220 => 231,
      237 => 234,
      235 => 236,
      238 => 235,
      194 => 192,
      186 => 194,
      188 => 187,
      473 => 475,
      472 => 474,
      471 => 473
  }

  SHIFTED_WEAPONS = {
      30 => 13,
      8 => 30,
      22 => 128,
      20 => 9,
      9 => 22,
      19 => 10,
      10 => 39,
      14 => 34,
      36 => 14,
      23 => 36,
      28 => 11,
      11 => 23,
      33 => 137,
      12 => 33,
      26 => 8,
      24 => 26,
      13 => 24,
      17 => 41,
      15 => 16,
      32 => 136,
      16 => 32,
      18 => 42,
      21 => 127,
      27 => 21,
      29 => 12,
      31 => 135,
      40 => 15,
      35 => 40,
      38 => 41,
      111 => 112,
  }

  REMOVED_WEAPONS = {
      163 => 0,
      164 => 0,
      165 => 0,
      166 => 0,
      167 => 0,
      168 => 0,
      169 => 0,
      170 => 0,
      171 => 0,
      173 => 400,
      174 => 800,
      175 => 1500,
      176 => 6200,
      25 => 9000,
      39 => 0,
      181 => 0,
      182 => 0,
      183 => 0
  }

  SHIFTED_ARMORS = {
      201 => 211,
      214 => 201, # SIGILLO DEL VESPRO -> GRIMORIO ANTICO
      204 => 203,
      205 => 204,
      206 => 205,
      207 => 206,
      208 => 207,
      209 => 208,
      199 => 209,
      200 => 209,
      219 => 202,
      202 => 265,
      212 => 262,
      213 => 201,
      215 => 262,
      216 => 203,
      217 => 263,
      218 => 261,
      220 => 218,
      30 => 25,
      24 => 31,
      23 => 24,
      26 => 29,
      31 => 26,
      32 => 25,
      33 => 27,
      34 => 32,
      35 => 29,
      36 => 29,
      37 => 28,
      39 => 30,
      67 => 76,
      77 => 74,
      68 => 77,
      72 => 67,
      73 => 68,
      75 => 67,
      79 => 69,
  }

  REMOVED_ARMORS = {
      210 => 4000,
      211 => 4000,
      221 => 4000,
      # guanti
      242 => 700,
      243 => 1000,
      244 => 1500,
      245 => 3000,
      246 => 5000,
      25 => 5500,
      29 => 2600,
      38 => 4000,
      74 => 1500,
      78 => 3500,
      80 => 4000
  }

  ELEMENTAL_STONES = {
      # element_id => item_id
      9 => 133, 10 => 134, 11 => 135, 12 => 136, 13 => 137, 14 => 138
  }

  # Aggiunge i luoghi visitati alla mappa leggendo le informazioni sul gioco.
  def self.add_places
    v = $game_variables[72]
    (2..v).each do |i|
      next if HASH[i].nil?
      (0..HASH[i].size - 1).each { |j|
        $game_system.unlock_place(HASH[i][j])
      }
    end
    if $game_switches[425] || $game_variables[175] > 2
      $game_system.unlock_place(:kaji)
    end
    if $game_switches[326] || $game_variables[156] > 2 || $game_variables[189] > 2
      $game_system.unlock_place(:piramid)
    end
    if $game_party.total_items(132) > $game_party.item_number($data_items[132]) || $game_variables[177] > 3
      $game_system.unlock_place(:erm)
    end
  end
end #sc_mod

module SceneManager
  class << self
    alias default_scene_class first_scene_class
  end

  # determina la prima schermata del gioco.
  # se ci sono salvataggi da convertire, li converte
  def self.first_scene_class
    #return Scene_Conversion if DataManager.need_convert_for_4?
    default_scene_class
  end
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  Aggiunge un'altra gestione
#==============================================================================
module DataManager

  # Restituisce true se il gioco ha bisogno di essere convertito al cap 4
  def self.need_convert_for_4?
    return true if old_exists_and_not_new
    load_h87settings
    $game_settings["chapter4"].nil?
  end

  # controlla se non esiste il file settings nella cartella documenti, ma
  # esiste il file settings nella cartella di gioco (vecchio percorso)
  def self.old_exists_and_not_new
    File.exist?('game_settings.rvdata') && !File.exist?(settings_path)
  end

  def self.old_saved_settings
    return nil unless File.exist?('game_settings.rvdata')
    load_data('game_settings.rvdata')
  end

  def self.save_number_to_convert
    Dir.glob('Salvataggio*.rvdata').size
  end

end #datamanager

class Scene_Title < Scene_Base
  # Avvia la conversione se necessaria
  alias pgspg_start start unless $@

  def start
    need_conversion = DataManager.need_convert_for_4?
    pgspg_start
    if need_conversion
      $scene = Scene_Conversion.new
    end
  end
end

#scene_title

#==============================================================================
# ** Scene_Conversion
#------------------------------------------------------------------------------
#  Schermata di conversione del database
#==============================================================================
class Scene_Conversion < Scene_MenuBase

  # Inizio
  def start
    Logger.info 'carica'
    load_title_database
    #DataManager.load_database
    Logger.info 'caricato'
    super
    create_status_window
    create_conversion_scheduler
  end

  def load_title_database
    Scene_Title.new.load_database
  end

  #def create_background
  #  @background_sprite = Sprite.new
  #  @background_sprite.bitmap = Cache.picture 'Online Back'
  #end

  def create_status_window
    @status_window = Window_Conversion.new(DataManager.save_number_to_convert)
  end

  def create_conversion_scheduler
    @conversion_scheduler = Conversion_Scheduler.new
    #@conversion_scheduler.set_window(@status_window)
    #@conversion_scheduler.set_bar(@bar)
  end

  def update_window_save_state
    @status_window.save_state = @conversion_scheduler.save_state
    @status_window.save_processed = @conversion_scheduler.process_state
    @status_window.errors = @conversion_scheduler.errors
    sleep(0.01)
  end

  def achievement_popup_enabled?
    false
  end

  def check_conversion_terminated
    unless @done
      Sound.play_save
      @status_window.complete
      @done = true
    end
    SceneManager.goto(Scene_Title) if Input.trigger?(Input::C) && @done
  end

  def update
    super
    return start_conversion unless @conversion_scheduler.started?
    if @conversion_scheduler.terminated?
      check_conversion_terminated
    else
      update_window_save_state
    end
  end

  # inizia la conversione
  def start_conversion
    Thread.start { @conversion_scheduler.start_process }
  end
end

#scene_conversion

#===============================================================================
# ** Window_Conversion
#-------------------------------------------------------------------------------
# Finestra che mostra lo stato di conversione dei capitoli
#===============================================================================
class Window_Conversion < Window_Base
  def initialize(save_number)
    super(0, 0, 450, fitting_height(5))
    update_placement
    @save_number = save_number
    @save_state = 0
    @save_processed = 0
    @save_error = 0
    @completed = false
    refresh
  end

  # Update Window Position
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end

  def line_1_text
    with_errors = @save_error > 0 ? ' con errori' : ''
    @completed ? "Conversione completata#{with_errors}." : "Conversione dei salvataggi"
  end

  def line_2_text
    t1 = "Tutti i tuoi savataggi sono stati spostati in"
    t2 = "Sto adattando i salvataggi al nuovo capitolo."
    @completed ? t1 : t2
  end

  def line_3_text
    Homesave.saves_path
  end

  def draw_continue_info
    change_color crisis_color
    text = 'Premi il tasto        per continuare.'
    rect = line_rect(3)
    contents.draw_text(rect, text, 1)
    tw = text_size(text).width
    tx = (contents_width - tw) / 2
    ix = tx + text_size('Premi il tasto').width + 3
    draw_key_icon(:C, ix, rect.y)
  end

  def draw_save_status_info
    contents.clear_rect(line_rect(3))
    text = sprintf("Aggiornamento salvataggio %d di %d", @save_processed, @save_number)
    draw_text(line_rect(3), text, 1)
  end

  def draw_fourth_line
    if @completed
      draw_continue_info
      draw_save_error_info
    else
      draw_save_state_bar
      draw_save_status_info
    end
  end

  def refresh
    contents.clear
    draw_text(line_rect(0), line_1_text, 1)
    draw_text(line_rect(1), line_2_text, 1)
    draw_text(line_rect(2), line_3_text, 1)
    draw_fourth_line
  end

  def save_state=(new_save_state)
    return if @completed
    return if @save_state == new_save_state
    @save_state = new_save_state
    draw_save_state_bar
  end

  def save_processed=(new_save_processed)
    return if @completed
    return if @save_processed == new_save_processed
    @save_processed = new_save_processed
    draw_save_status_info
  end

  def errors=(errors)
    return if @save_error == errors
    @save_error = errors
    draw_save_error_info
  end

  def draw_save_state_bar
    contents.clear_rect(line_rect(2))
    rate = @save_state.to_f / 58.0
    draw_gauge(0, line_height * 2, contents_width, rate, Color::WHITE, Color::WHITE)
  end

  def draw_save_error_info
    rect = line_rect(4)
    contents.clear_rect(rect)
    return if @save_error == 0
    change_color knockout_color
    text = sprintf("%d salvataggi non sono stati convertiti correttamente.", @save_error)
    draw_text(rect, text, 1)
  end

  def complete
    @completed = true
    refresh
  end
end

#==============================================================================
# ** Conversion_Scheduler
#------------------------------------------------------------------------------
#  Questa classe si occupa della conversione di ogni salvataggio.
#==============================================================================
class Conversion_Scheduler
  attr_reader :process_state
  attr_reader :save_state
  attr_reader :errors
  # @return [Window_Conversion]
  attr_reader :window
  # Inizializzazione
  def initialize
    @process_started = false
    @process_executing = false
    @process_terminated = false
    @process_state = 0
    @save_state = 0
    @errors = 0
    @players = {}
    @window = nil
  end

  # imposta la barra di avanzamento
  def set_window(window)
    @window = window
  end

  # Restituisce true se la conversione è iniziata
  def started?
    @process_started
  end

  # Restituisce true se il processo sta avvenendo
  def executing?
    @process_executing
  end

  # Restituisce true se la conversione è terminata
  def terminated?
    @process_terminated
  end

  # Read Save Data
  #     file : file object for reading (opened)
  #noinspection RubyResolve
  def read_save_data(file)
    #noinspection RubyUnusedLocalVariable
    Logger.info 'leggo i dati di gioco...'
    characters = Marshal.load(file)
    Graphics.frame_count = Marshal.load(file)
    @last_bgm = Marshal.load(file)
    @last_bgs = Marshal.load(file)
    $game_system = Marshal.load(file)
    $game_message = Marshal.load(file)
    $game_switches = Marshal.load(file)
    $game_variables = Marshal.load(file)
    $game_self_switches = Marshal.load(file)
    $game_actors = Marshal.load(file)
    $game_party = Marshal.load(file)
    $game_troop = Marshal.load(file)
    $game_map = Marshal.load(file)
    $game_player = Marshal.load(file)
    if $game_system.version_id != $data_system.version_id
      $game_map.setup($game_map.map_id)
      $game_player.center($game_player.x, $game_player.y)
    end
    Logger.info 'file di gioco caricati.'
  end

  # Chiama l'inizio del processo
  def start_process
    @process_started = true
    @process_executing = true
    begin
      process_move_game_settings
      check_old_achievements_compatibility
      $game_settings["chapter4"] = true
    rescue => exception
      Logger.error("Errore #{exception.class} su conversione data settings")
      Logger.error(exception.message)
      @process_executing = false
      @process_terminated = true
      return
    end
    Dir.glob('Salvataggio*.rvdata').each_with_index do |file, index|
      @process_state = index
      process_save_data(file)
    end
    Logger.info('Salvataggi processati.')
    @process_executing = false
    @process_terminated = true
  end

  def process_move_game_settings
    settings = load_data("game_settings.rvdata")
    legacy_data = settings.legacy
    $game_settings = H87_Settings.new
    $game_settings.settings = legacy_data
    $game_settings.save
  end

  def savefile_index(savename)
    regexp = /Salvataggio (\d+).rvdata/
    regexp.match(savename)[1].to_i
  end

  # Processa il salvataggio
  # @param [String] savename
  # @param [Integer] index
  def process_save_data(savename)
    index = savefile_index(savename)
    @save_state = 0
    Logger.info sprintf('processo il salvataggio %s', savename)
    file = File.open(savename, "rb") rescue return
    read_save_data(file)
    file.close
    return if $game_system.save_version >= 4
    begin
      change_savedata(index)
    rescue
      @errors += 1
      Logger.error($!.class)
      Logger.error $!.message
      Logger.error $!.backtrace
    end
    $game_system.default_save_version
    $game_system.conversion_bgm = @last_bgm
    $game_system.conversion_bgs = @last_bgs
    advance_step
    unless check_and_save_folder(index)
      Logger.error("Errore nel salvare allo slot #{index}")
      @errors += 1
    end
    advance_step
    Logger.info sprintf('step %d completato', @save_state)
  end

  # Prende l'immagine vuota
  def process_image(scrname)
    Cache.load_bitmap("", scrname, 0)
  end

  # Cambia i parametri del salvataggio.
  def change_savedata(index)
    $game_switches[Online::ACTIVATION_SWITCH] = false
    $game_map.erase_events
    advance_step
    $game_party.check_weapon_sa
    advance_step
    discover_items_for_itempedia
    advance_step
    check_dangerous_save_points
    advance_step
    $game_system.saved_bgm = @last_bgm
    change_position(index)
    advance_step
    process_dominations
    advance_step
    unlock_places
    update_fog
    advance_step
    change_party_info
    process_actors
    advance_step
    change_settings
    advance_step
    rimuovi_oggetti_eliminati
    advance_step
    handle_old_equips
    advance_step
    update_shop_states
    advance_step
    unlock_titles
    recover_all
    update_new_data
    continue_chapter4 if $game_variables[72] >= 57
  end

  # aggiorna il menu opzioni
  def change_settings
    Logger.info 'cambio le impostazioni di gioco'
    $game_switches[267] = true
    $game_switches[268] = true
    $game_switches[269] = true
    $game_switches[598] = true
    $game_switches[Gameplay_Settings::BATTLE_ANIM_SW] = false
    $game_switches[Sprite_MiniMap::MINIMAP_SWITCH] = true
    $game_switches[Sprite_MiniMap::MINIMAP_SIZE_SW] = false
    $game_switches[ActorCommandOptions::POSITION_SW] = true
    $game_switches[H87HUD_SETTINGS::BEEP_ON_CRITICAL_SW] = true
    $game_switches[Online::ACTIVATION_SWITCH] = true
    $game_system.autosave_setting = true
    case $game_party.total_max_level
    when 1..20
      value = 3
    when 21..40
      value = 2
    else
      value = 1
    end
    $game_variables[H87HUD_SETTINGS::HP_WIDTH_VAR] = value
    #noinspection RubyResolve
    $game_switches[121] = $game_party.atb_custom[1]
  end

  # Converte le informazioni degli obiettivi sbloccati sulla nuova versione.
  def check_old_achievements_compatibility
    return if $game_settings[:achievements]
    $game_settings[:achievements] = {}
    $game_settings.settings.each_pair do |key, value|
      if /Ach[ ]*(\d+)/i.match(key.to_s)
        $game_settings[:achievements][$1.to_i] = value
      end
    end
    $game_settings.save
  end

  def update_new_data
    Logger.info 'aggiorno i nuovi dati'
    $game_switches[SC_Mod::FROM_OLD_CHAPTER_SW] = true
    $game_system.is_legacy_save = true
    if $game_party.nome_giocatore != nil
      $game_system.player_name = $game_party.nome_giocatore[0,Settings::MAX_NICKNAME_LEN]
    end
  end

  def recover_all
    Logger.info 'curo tutti'
    $game_party.all_members.each { |member| member.recover_all }
  end

  # fa avanzare lo stato della conversione di 1
  def advance_step
    @save_state += 1
  end

  def unlock_titles
    Logger.info 'sblocco i titoli...'
    $game_system.unlock_title(11, false) if $game_variables[67] <= 0 and $game_switches[215]
    $game_system.unlock_title(22, false)
    $game_system.unlock_title(23, false) if $game_switches[34]
    $game_system.unlock_title(26, false) if $game_switches[369]
    $game_system.unlock_title(27, false) if $game_switches[106]
    $game_system.unlock_title(29, false) if $game_system.story_progress > 37
    $game_system.unlock_title(30, false) if $game_party.total_battles >= 100
    $game_system.unlock_title(31, false) if $game_party.total_battles >= 1000
    $game_system.unlock_title(32, false) if $game_party.total_battles >= 10000
    Player_Titles::BINDED_ACHIEVEMENTS.each_pair do |achievement_id, title_id|
      $game_system.unlock_title(title_id, false) if H87_Achievements.get_achievement(achievement_id).unlocked?
    end
  end

  def change_new_character_names
    actors_to_reset = [9, 12]
    actors_to_reset.each do |actor_id|
      actor = $game_actors[actor_id]
      actor.name = actor.actor.name
    end
  end

  # Scopri gli oggetti per l'oggettario
  def discover_items_for_itempedia
    Logger.info 'sblocco gli oggetti oggettario'
    $game_party.discovered_items
  end

  def update_shop_states
    Logger.info 'aggiorno i negozi'
    update_balthazar_shop
  end

  def update_balthazar_shop
    state = $game_variables[80]
    return if state <= 0
    Roba_Personale.riempi_shop_balth(1)
    Roba_Personale.riempi_shop_balth(2) if $game_switches[433]
    Roba_Personale.riempi_shop_balth(3) if $game_variables[165] >= 5
  end

  # scambia gli oggetti per la nuova posizione
  def exchange_items(id1, id2)
    number = $game_party.item_number($data_items[id1])
    return if number == 0
    $game_party.lose_item($data_items[id1], number)
    $game_party.gain_item($data_items[id2], number)
  end

  # scambia le skill
  def exchange_skills(actor, id1, id2)
    if actor.skills.include?(id1)
      actor.forget_skill(id1)
      actor.learn_skill(id2)
    end
  end

  # rimuove gli oggetti non più esistenti
  def rimuovi_oggetti_eliminati
    Logger.info 'rimuovo oggetti eliminati'
    (201..206).each { |i| $game_party.lose_item($data_items[i], 99) }
    $game_party.lose_item($data_items[211], 99)
    exchange_items(90, 209)
    exchange_items(91, 210)
    exchange_items(92, 211)
    if $game_switches[519]
      $game_party.gain_item($data_armors[38])
      $game_party.gain_item($data_armors[191])
    else
      $game_actors[14].change_equip(2, $data_armors[38])
      $game_actors[14].change_equip(4, $data_armors[191])
    end
  end

  # @param [RPG::Weapon] weapon
  # @return [RPG::Weapon]
  def process_weapon(weapon)
    # per le armi modificate
    if SC_Mod::MODDED_WEAPONS[weapon.id] != nil
      weapon = $data_weapons[SC_Mod::MODDED_WEAPONS[weapon.id]]
    end
    if SC_Mod::REMOVED_WEAPONS.keys.include?(weapon.real_id)
      $game_party.gain_gold SC_Mod::REMOVED_WEAPONS[weapon.real_id]
      return nil
    end
    if SC_Mod::SHIFTED_WEAPONS.keys.include?(weapon.real_id)
      power_up = weapon.power_up_id || 0
      weapon = $data_weapons[SC_Mod::SHIFTED_WEAPONS[weapon.real_id]]
      weapon.power_up = power_up
    end
    weapon
  end

  # @param [RPG::Armor] armor
  # @return [RPG::Armor]
  def process_armor(armor)
    if SC_Mod::REMOVED_ARMORS.keys.include?(armor.id)
      $game_party.gain_gold SC_Mod::REMOVED_ARMORS[armor.id]
      return nil
    end
    if SC_Mod::SHIFTED_ARMORS.keys.include?(armor.id)
      return $data_armors[SC_Mod::SHIFTED_ARMORS[armor.id]]
    end
    armor
  end

  def handle_old_equips
    Logger.info 'elimino gli equipaggiamenti non usati'

    $game_party.weapons.each do |weapon|
      n = $game_party.item_number(weapon)
      $game_party.lose_item(weapon, n, true)
      new_weapon = process_weapon(weapon)
      if weapon != nil
        $game_party.gain_item(new_weapon, n)
      end
    end

    $game_party.armors.each do |armor|
      n = $game_party.item_number armor
      $game_party.lose_item(armor, n, true)
      new_armor = process_armor(armor)
      if armor != nil
        $game_party.gain_item(new_armor, n)
      end
    end

    #SC_Mod::REMOVED_WEAPONS.each_pair do |weapon_id, cost|
    #  remove_item_and_get_refund($data_weapons[weapon_id], cost)
    #end

    #SC_Mod::SHIFTED_ARMORS.each_pair do |old_id, new_id|
    #  remove_item_and_replace($data_armors[old_id], $data_armors[new_id])
    #end

    #SC_Mod::REMOVED_ARMORS.each_pair do |armor_id, cost|
    #  remove_item_and_get_refund($data_weapons[armor_id], cost)
    #end
  end

  # @param [RPG::Item,RPG::Armor,RPG::Weapon] item
  # non più usato
  def remove_item_and_get_refund(item, cost)
    number = $game_party.item_number(item, true)
    return if number == 0
    $game_party.lose_item(item, number, true)
    $game_party.gain_gold(cost * number)
  end

  # @param [RPG::Item,RPG::Armor,RPG::Weapon] old_item
  # @param [RPG::Item,RPG::Armor,RPG::Weapon] new_item
  # non più usato
  def remove_item_and_replace(old_item, new_item)
    number = $game_party.item_number(old_item, true)
    return if number == 0
    $game_party.lose_item(old_item, number, true)
    $game_party.gain_item(new_item, number)
  end

  # Gestisce i punti di salvataggio cambiati sulla mappa
  def check_dangerous_save_points
    Logger.info 'controllo i punti di salvataggio pericolosi'
    if $game_map.map_id == 144 #pigwarts P2
      $game_map.setup(412)
      $game_player.moveto(3, 7)
      $game_player.refresh
    end
  end

  # Cambia le abilità
  def change_skills(actor)
    advance_step
    forget_skills(actor, SC_Mod::REMOVED_SKILLS)
    advance_step
    forget_passives(actor, SC_Mod::REMOVED_PASSIVES)
    # non usato più perché le skill vengono tutte cancellate
    #shift_skills(actor, SC_Mod::SHIFTED_SKILLS)

    # se è Reinard, impara
    set_reinard_skills(actor) if actor.id == 4
    # se è Van, impara
    set_van_skills(van) if actor.id == 16
  end

  def set_reinard_skills(actor)
    actor.learn_skill 22
    actor.learn_skill 24
    actor.learn_skill 227
    actor.learn_skill 423
  end

  def set_van_skills(actor)
    actor.learn_skill 21
    actor.learn_skill 64
    actor.learn_skill 101
    actor.learn_skill 106
  end


  # @param [Game_Actor] actor
  # @param [Hash<Integer,Integer>] skills
  def forget_skills(actor, skills)
    skills.each_pair { |skill_id, jp|
      next unless actor.skill_learn?($data_skills[skill_id])
      actor.forget_skill(skill_id)
      actor.earn_jp(jp)
    }
  end

  def forget_passives(actor, states)
    states.each_pair { |state_id, jp|
      next unless actor.passive_learn?($data_states[state_id])
      actor.forget_passive(state_id)
      actor.earn_jp(jp)
    }
  end

  # sposta le skill sulla nuova posizione
  def shift_skills(actor, skills)
    skills.each_pair { |skill_id, new_id|
      next unless actor.skill_learn?($data_skills[skill_id])
      actor.forget_skill(skill_id)
      actor.learn_skill(new_id)
    }
  end

  # Cambia le informazioni sul party
  def change_party_info
    Logger.info 'cambio le informazioni del gruppo'
    $game_party.monsters_defeated.each_pair do |id, number|
      $game_party.add_enemy_defeated(id, number)
    end
  end

  # SALVA
  def check_and_save_folder(index)
    Logger.info sprintf('salvo il gioco allo slot %d', index)
    result = DataManager.save_game(index - 1)
    Logger.info 'salvato.'
    result
  end

  # Imposta il nome della cartella di salvataggio a seconda del giocatore.
  #   È ricorsivo.
  def set_player_name(player_name, found = 0)
    found > 0 ? name = player_name + " " + found : name = player_name
    @players.each do |player|
      return set_player_name(player_name, found + 1) if player == name
    end
    name
  end

  # Aggiorna l'ultimo posto visitato per il teletrasporto
  #   Adatta per la nuova mappa del mondo
  def update_last_place(index)
    x = $game_variables[51]
    y = $game_variables[52]
    return if x == 0
    $game_variables[50] = 1
    pos = [x, y]
    if SC_Mod::TELEPORTS.include?(pos)
      $game_variables[51] = SC_Mod::TELEPORTS[pos][0]
      $game_variables[52] = SC_Mod::TELEPORTS[pos][1]
    else
      newpos = nearest_checkpoint(pos)
      $game_variables[51] = newpos[0]
      $game_variables[52] = newpos[1]
    end
  end

  # Trova il punto di teletrasporto più vicino
  # Serve nel caso la posizione non venga trovata
  def nearest_checkpoint(pos)
    teleports = []
    SC_Mod::TELEPORTS.each_key do |teleport|
      teleports.push(teleport)
    end
    min = 9999
    minpos = [0, 0]
    x1 = pos[0]
    y1 = pos[1]
    (0..teleports.size - 1).each do |i|
      x2 = teleports[i][0]
      y2 = teleports[i][1]
      dist = Geo.distanza(x1, y1, x2, y2)
      if dist < min
        min = dist
        minpos = teleports[i]
      end
    end
    SC_Mod::TELEPORTS[minpos]
  end

  # Cambia la posizione dell'eroe nel caso si trovi nella vecchia mappa del
  #   mondo.
  def change_position(index)
    Logger.info 'aggiorno la posizione del gruppo'
    update_last_place(index)
    if $game_map.map_id == 2
      (5..8).each do |i|
        $game_map.screen.pictures[i].erase
      end
      $game_map.setup(1)
      $game_player.moveto($game_variables[51], $game_variables[52])
      $game_player.refresh
    end
  end

  # aggiorna le statistiche dei personaggi
  def process_actors
    Logger.info 'aggiorno gli eroi'
    change_new_character_names
    (1..15).each do |i|
      next if i == 4
      process_actor $game_actors[i]
    end
    advance_step
  end

  # processa i dati dell'eroe
  # @param [Game_Actor] actor
  def process_actor(actor)
    if actor.level > 50
      # riduce il livello dell'eroe se sopra il livello 50
      margin = actor.level - 50
      margin /= 3
      actor.level = 50 + margin
    end
    (118..123).each do |j|
      actor.remove_state(j)
    end

    change_skills(actor)
    actor.check_weapon_sa
    actor.process_old_element_affinity
    advance_step
  end

  # Aggiorna le dominazioni
  def process_dominations
    Logger.info 'processo le evocazioni'
    EsperConfig::SW_Dom.each_key do |esp|
      $game_party.unlock_domination(esp) if $game_switches[EsperConfig::SW_Dom[esp]]
    end
    $game_switches[590] = true if $game_variables[72] >= 17
    (17..27).each do |i|
      next if i == 26
      actor = $game_actors[i]
      passives = actor.passives.clone
      actor.setup(i)
      if passives.size > 0
        (0..passives.size - 1).each { |j|
          actor.learn_passive(passives[j])
        }
      end
      update_invocation(i)
      actor.requery_skills
      actor.check_boosts
    end
  end

  # aggiorna le statistiche dell'evocazione
  def update_invocation(index)
    return unless $game_party.domination_unlocked?(index)
    level = $game_party.max_level
    domination = $game_actors[index]
    case index
    when 17
      domination.summon_times = level / 3 + 2
    when 18
      domination.summon_times = level / 4
    when 19
      domination.summon_times = level / 3
    when 20
      domination.summon_times = level / 6 + 1
    when 21
      domination.summon_times = level / 5
    when 22
      domination.summon_times = level / 6
    when 23
      domination.summon_times = level / 4
    when 24
      domination.summon_times = level / 6
    when 25
      domination.summon_times = level / 5
    when 27
      domination.summon_times = level / 7
    else
      # type code here
    end
  end

  # continua per il capitolo 4
  def continue_chapter4
    $game_player.transparent = true
    $game_map.setup(11)
    $game_player.moveto(1, 1)
    $game_system.conversion_bgm = nil
    $game_system.conversion_bgs = nil
  end

  # Aggiorna la nebbia
  def update_fog
    $game_map.set_fog_data(FOG_SETUP::FOGS[$game_map.map_id])
  end

  # Sblocca alla mappa i posti visitati
  def unlock_places
    SC_Mod.add_places
  end

  def update_settings
    $game_switches[MapPopup_Options::MINIMAP_SWITCH] = true
    $game_switches[H87HUD_SETTINGS::BEEP_ON_CRITICAL_SW] = true
    $game_switches[ActorCommandOptions::POSITION_SW] = false
  end
end

#conversion_scheduler

#==============================================================================
# ** H87_Settings
#==============================================================================
class H87_Settings
  # Imposta il nuovo gioco sul capitolo 4
  alias definit initialize unless $@

  def initialize
    definit
    @settings["chapter4"] = true
  end

  # usato per ottenere i vecchi salvataggi
  def legacy
    @type
  end
end

#h87_settings

class Game_Actor < Game_Battler
  def check_weapon_sa
    @weapon_id = check_weapon_sa_id(@weapon_id)
    @armor1_id = check_weapon_sa_id(@armor1_id) if two_swords_style
  end

  # azzera le affinità elementali e restituisce gli oggetti
  def process_old_element_affinity
    return if @bonus_element_affinity.nil?
    @bonus_element_affinity.each do |element_id, value|
      next if element_id.nil?
      next if value == 0
      next if value.nil?
      next if SC_Mod::ELEMENTAL_STONES[element_id].nil?
      $game_party.gain_item($data_items[SC_Mod::ELEMENTAL_STONES[element_id]], value)
    end
  end

  def check_weapon_sa_id(id)
    SC_Mod::MODDED_WEAPONS[id].nil? ? id : SC_Mod::MODDED_WEAPONS[id]
  end

  def reset_stats
    actor.parameters[1, @level]
  end
end

class Game_System
  attr_accessor :is_legacy_save
  attr_accessor :new_chapter_introduction
end

class Game_Map
  def erase_events
    #noinspection RubyArgCount
    @interpreter = Game_Interpreter.new(0, true)
  end
end

class Game_Party < Game_Unit
  def check_weapon_sa
    Logger.info 'modifico le abilità speciali delle armi...'
    @weapons.each_key do |weap_id|
      if SC_Mod::MODDED_WEAPONS[weap_id] != nil
        number = @weapons[weap_id]
        @weapons.delete(weap_id)
        @weapons[SC_Mod::MODDED_WEAPONS[weap_id]] = number
      end
    end
  end
end