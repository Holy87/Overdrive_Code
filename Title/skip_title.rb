#===============================================================================
# Skkipa Titolo di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script fa in modo che il gioco cominci subito senza passare per la
# schermata del titolo QUANDO NON SONO PRESENTI SALVATAGGI.
#===============================================================================
# ** Istruzioni:
# Copiare lo script sotto Materials e prima del Main.
#===============================================================================
$imported = {} if $imported == nil
$imported['H87_Skip_Title'] = 1.0

#===============================================================================
# ** SceneManager
#===============================================================================
module SceneManager
  class << self
    alias skip_scene_class first_scene_class
  end

  # @return [Class<Scene_Map>, Scene_Base]
  def self.first_scene_class
    return skip_scene_class if DataManager.save_file_exists? or $BTEST
    start_new_game
    Scene_Map
  end

  # setup and start on Scene_Map
  def self.start_new_game
    DataManager.setup_new_game
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
  end
end