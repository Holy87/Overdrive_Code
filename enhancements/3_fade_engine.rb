#===============================================================================
# ** Fade_Engine
#-------------------------------------------------------------------------------
# Modulo per le funzioni di fade e pulsazione
#===============================================================================
module Fade_Engine
  # Variabili d'istanza pubbliche
  attr_accessor :fade_speed   #velocità di dissolvenza
  attr_accessor :pulse_state  #stato della pulsazione (hash, nil di default)
  # Inizializzazione delle variabili
  def fade_engine_init
    @fade_speed = 0
  end

  # Aggiornamento
  def fade_engine_update
    update_fading
    update_pulse
  end

  # Comando di cambio trasparenza
  # @param [Integer] opacity opacità finale
  # @param [Integer] speed velocità di fade
  # @param [Boolean] pulse
  def fade(opacity = 0, speed = 1, pulse = false)
    pulse_stop unless pulse
    @new_opacity = opacity
    @fade_speed = speed
  end

  # Aggiorna il fade
  def update_fading
    return if @new_opacity.nil?
    speed = @fade_speed
    distance = (self.opacity - @new_opacity).abs
    if distance <= speed
      self.opacity = @new_opacity
      @new_opacity = nil
    else
      state = @new_opacity <=> self.opacity 
      self.opacity += speed * state
    end
  end

  # Aggiorna la pulsazione
  def update_pulse
    return if @pulse_state.nil?
    if @pulse_state[:defading] and self.opacity >= @pulse_state[:max]
      @pulse_state[:defading] = false
      fade(@pulse_state[:min], @pulse_state[:speed], true)
    elsif self.opacity <= @pulse_state[:min]
      @pulse_state[:defading] = true
      fade(@pulse_state[:max], @pulse_state[:speed], true)
    end
  end

  # Avvia la pulsazione
  #   min_opacity:  opacità minima
  #   max_opacity:  opacità massima
  #   speed:        velocità
  def pulse(min_opacity, max_opacity, speed = 10)
    @pulse_state = {:min => min_opacity, :max => max_opacity,
    :speed => [[speed, 1].max, 255].min, :defading => false, :init => self.opacity}
    fade(min_opacity, speed, true)
  end

  # Ferma la pulsazione
  def pulse_stop
    return if @pulse_state.nil?
    init = @pulse_state[:init]
    speed = @pulse_state[:speed]
    @pulse_state = nil
    fade(init, speed)
  end

  # Restituisce true se l'oggetto sta cambiando trasparenza
  def fading?
    @new_opacity != nil
  end
end #fade engine