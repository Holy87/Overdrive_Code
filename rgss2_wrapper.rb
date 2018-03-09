class Window_Base < Window
  def initialize(x, y, width = 0, height = 0); end
end

class Window_Selectable < Window_Base
  def initialize(x, y, width = 0, height = 0); end
  @data = []
end

# noinspection ALL
class Game_Battler
  attr_reader   :battler_name             # nome del file della grafica del battler
  attr_reader   :battler_hue              # tonalità dell'immagine
  attr_reader   :hp                       # HP
  attr_reader   :mp                       # MP
  attr_reader   :action                   # mosse del nemico
  attr_accessor :hidden                   # indicatore se nascosto
  attr_accessor :immortal                 # indicatore se immortale
  attr_accessor :animation_id             # ID animazione attacco
  attr_accessor :animation_mirror         # indicatore se l'animazione è a specchio
  attr_accessor :white_flash              # attivatore flash
  attr_accessor :blink                    # attivatore invisibile
  attr_accessor :collapse                 # indicatore morte nemico
  attr_reader   :skipped                  # risultati azione: turno saltato
  attr_reader   :missed                   # risultati azione: mancato
  attr_reader   :evaded                   # risultati azione: evasione
  attr_reader   :critical                 # risultati azione: critico
  attr_reader   :absorbed                 # risultati azione: assorbito
  attr_reader   :hp_damage                # risultati azione: danno HP
  attr_reader   :mp_damage                # risultati azione: danno MP
  def initialize_a
    @evaded = false
    @critical = false
    @added_states = []
  end
end

class Scene_Battle < Scene_Base
  def update_basic(main = false)

  end
end