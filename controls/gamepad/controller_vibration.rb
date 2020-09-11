require File.expand_path('rm_vx_data') if false
#===============================================================================
# Vibrazione in battaglia di Holy87
# Difficoltà utente: ★
# Versione 1.1
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# Questo script farà vibrare automaticamente il controller con attacchi critici
# in battaglia o attraverso animazioni con un determinato timing.
#===============================================================================
# Istruzioni: inserire lo script sotto Materials prima del Main.
#
# Se si vuole assegnare un effetto speciale all'animazione, aggiungere una
# nuova voce in Tempismo SE e Flash dell'animazione, selezionare il frame
# desiderato, impostare flash su bersaglio e COLORE ROSSO A 1.
# Quindi, modificare Forza (del colore) per modificare la forza della vibrazione
# e durata per la durata.
# Novità della versione 1.1:
# Puoi impostare separatamente la forza della vibrazione destra o sinistra!
# Regola il colore verde nell'FX per la vibrazione sinistra e il colore blu
# per la vibrazione destra!
#
# Sotto è possibile configurare i testi per le voci e i comandi personalizzabili.
#===============================================================================


#===============================================================================
# ** IMPOSTAZIONI SCRIPT
#===============================================================================
module VibrationConfig
  # Vibrazione con critico su nemico | Forza SX | Forza DX | Durata
  CRITICAL_ENEMY                  = [    100,       100,       30   ]
  # Vibrazione con critico su alleato
  CRITICAL_ALLY                   = [     75,        75,       30   ]
  #--------------------------------------------------------------------------
  # * Valore di rosso che determinerà il timing della vibrazione nella
  #   sequenza di animazione
  #--------------------------------------------------------------------------
  VIBRATION_ACTIVATE = 1
end

#===============================================================================
# ** ATTENZIONE: NON MODIFICARE SOTTO QUESTO SCRIPT SE NON SAI COSA TOCCARE! **
#===============================================================================



$imported = {} if $imported == nil
$imported['H87-Vibration'] = 1.1
#===============================================================================
# ** RPG::Animation
#-------------------------------------------------------------------------------
# Vibration info
#===============================================================================
module RPG
  class Animation
    #===============================================================================
    # ** RPG::Animation::Vibration_Info
    #-------------------------------------------------------------------------------
    # Vibration info
    #===============================================================================
    class Vibration_Info
      attr_accessor :left_force
      attr_accessor :right_force
      attr_accessor :neutral_force
      #---------------------------------------------------------------------
      # * Object initialization
      # @param [Color] color
      #---------------------------------------------------------------------
      def initialize(color = nil)
        @left_force = 0
        @right_force = 0
        @neutral_force = 0
        set_vibration(color) if color
      end
      #---------------------------------------------------------------------
      # * Set vibration info
      # @param [Color] color
      #---------------------------------------------------------------------
      def set_vibration(color)
        self.left_force = color.green * 100 / 255
        self.right_force = color.blue * 100 / 255
        self.neutral_force = color.alpha * 100 / 255
      end
      #---------------------------------------------------------------------
      # * Returns the total amount of vibration
      #---------------------------------------------------------------------
      def total_vibration; @right_force + @left_force + @neutral_force; end
    end

    #===============================================================================
    # ** RPG::Animation::Timing
    #-------------------------------------------------------------------------------
    # adding vibration method
    #===============================================================================
    class Timing
      #---------------------------------------------------------------------
      # * Returns vibration strenght and cancels the flash target
      # @return [Vibration_Info]
      #---------------------------------------------------------------------
      def vibration
        if @vibration.nil?
          @vibration = Vibration_Info.new
          if @flash_scope == 1 && @flash_color.red == VibrationConfig::VIBRATION_ACTIVATE
            @vibration.set_vibration(@flash_color)
            @flash_scope = 0
          end
        end
        @vibration
      end
    end
  end
end

#===============================================================================
# ** Game_Battler
#-------------------------------------------------------------------------------
# Vibration on critical damage
#===============================================================================
class Game_Battler < Game_BattlerBase
  alias h87vib_apply_critical apply_critical unless $@
  #--------------------------------------------------------------------------
  # * Apply critical
  #--------------------------------------------------------------------------
  def apply_critical(damage)
    apply_vibration
    h87vib_apply_critical(damage)
  end
  #--------------------------------------------------------------------------
  # * Apply vibration on critical damage
  #--------------------------------------------------------------------------
  def apply_vibration
    str = actor? ? VibrationConfig::CRITICAL_ALLY : VibrationConfig::CRITICAL_ENEMY
    Input.vibrate(str[0], str[1], str[2])
  end
end

#===============================================================================
# ** Sprite_Base
#-------------------------------------------------------------------------------
# Vibration on animation timing
#===============================================================================
class Sprite_Base < Sprite
  alias h87vibr_apt animation_process_timing unless $@
  #--------------------------------------------------------------------------
  # * Adds vibration check to the animation
  # @param [RPG::Animation::Timing] timing
  #--------------------------------------------------------------------------
  def animation_process_timing(timing)
    if timing && timing.vibration.total_vibration > 0
      left_v = timing.vibration.left_force + timing.vibration.neutral_force
      right_v = timing.vibration.right_force + timing.vibration.neutral_force
      left_v, right_v = right_v, left_v if @ani_mirror
      Input.vibrate(left_v, right_v, timing.flash_duration * @ani_rate)
    end
    h87vibr_apt(timing)
  end
end