require File.expand_path('rm_vx_data')
=begin
 ==============================================================================
  ■ Movimenti fluidi di Holy87
      versione 1.1
      Difficoltà utente: ★
      Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
      lo script nei propri progetti, sia amatoriali che commerciali. Vietata
      l'attribuzione impropria.
 ==============================================================================
    Questo script aggiunge a finestre e sprite un movimento automatico e
    fluido che
 ==============================================================================
  ■ Compatibilità
    Window_Base -> alias update
    Sprite -> alias update
 ==============================================================================
  ■ Installazione e istruzioni
    Installare questo script sotto Materials e prima del Main. Per muovere
    finestre e sprite usa i seguenti metodi:

    ● oggetto.smooth_move(x, y[, speed, method])
      per muovere l'oggetto alle coordinate x, y.
      speed ha un valore tra 1 e 5, e può essere omesso. Rappresenta la velocità
      di movimento. Il parametro method specifica il metodo che viene chiamato
      quando il movimento termina.

    ● oggetto.move_speed = x
      imposta la velocità di movimento ad un valore compreso tra 1 e 5 della x

    ● oggetto.move_end?
      restituisce true se ha completato il movimento, false altrimenti
 ==============================================================================
=end
$imported = {} if $imported == nil
$imported['H87_SmoothMovements'] = 1.2
#==============================================================================
# ** Modulo Smooth_Movements
#------------------------------------------------------------------------------
#  Questo modulo, se integrato in finestre e sprite, aggiunge nuovi tipi di
#  animazioni in movimento.
#==============================================================================
module Smooth_Movements
  #--------------------------------------------------------------------------
  # * Avvia il movimento fluido
  # @param [Integer] new_x        nuova coordinata x
  # @param [Integer] new_y        nuova coordinata y
  # @param [Integer] speed        velocità (2 di default)
  # @param [Method] move_hanlder  metodo che viene chiamato alla fine
  #--------------------------------------------------------------------------
  def smooth_move(new_x, new_y, speed = nil, move_hanlder = nil)
    self.move_speed = speed unless speed.nil?
    @move_handler = move_hanlder
    @new_x = new_x
    @new_y = new_y
    @start_move = true
    @move_end = false
  end
  #--------------------------------------------------------------------------
  # * Aggiorna il movimento fluido
  #--------------------------------------------------------------------------
  def update_smooth_movements
    return unless @start_move
    update_smooth_x
    update_smooth_y
    check_move_end
  end
  #--------------------------------------------------------------------------
  # * Restituisce la velocità di movimento preconfigurata
  #--------------------------------------------------------------------------
  def move_speed
    @speed = 2 if @speed.nil?
    @speed
  end
  #--------------------------------------------------------------------------
  # * Imposta la velocità di movimento
  #     new_speed: valore da 1 a 5
  #--------------------------------------------------------------------------
  def move_speed=(new_speed)
    @speed = 20/([[new_speed,1].max,5].min*2)
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la posizione X del movimento
  #     speed: velocità di movimento
  #--------------------------------------------------------------------------
  def update_smooth_x(speed = move_speed)
    return if @new_x.nil?
    dist = @new_x - self.x
    if dist.abs < speed
      self.x = update_smooth_x(speed/2)
    else
      self.x += dist / speed rescue self.x += dist
    end
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la posizione Y del movimento
  #     speed: velocità di movimento
  #--------------------------------------------------------------------------
  def update_smooth_y(speed = move_speed)
    return if @new_y.nil?
    dist = @new_y - self.y
    if dist.abs < speed
      self.y = update_smooth_y(speed/2)
    else
      self.y += dist / speed rescue self.y += dist
    end
  end
  #--------------------------------------------------------------------------
  # * Controlla se il movimento è terminato
  #--------------------------------------------------------------------------
  def check_move_end
    if self.x == @new_x && self.y == @new_y
      @move_end = true
      @start_move = false
      call_move_handler
    end
  end
  #--------------------------------------------------------------------------
  # * Chiama l'evento di fine movimento
  #--------------------------------------------------------------------------
  def call_move_handler
    return if @move_handler.nil?
    @move_handler.call
    @move_handler = nil
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'oggetto ha compiuto il suo movimento
  #--------------------------------------------------------------------------
  def move_end?
    @move_end || !@start_move
  end
end #modulo smooth

#==============================================================================
# ** Classe Window_Base
#------------------------------------------------------------------------------
#  Inclusione del modulo smooth_movement
#==============================================================================
class Window_Base < Window
  include Smooth_Movements  #incusione del modulo del movimento fluido
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  alias smooth_udpate update unless $@
  def update
    smooth_udpate
    update_smooth_movements if SceneManager.scene.is_a?(Scene_MenuBase)
  end
end #window_base

#==============================================================================
# ** Classe Sprite
#------------------------------------------------------------------------------
#  Inclusione del modulo smooth_movement
#==============================================================================
class Sprite
  include Smooth_Movements  #incusione del modulo del movimento fluido
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  alias smooth_udpate update unless $@
  def update
    smooth_udpate
    update_smooth_movements
  end
end #sprite

#==============================================================================
# ** Classe Viewport
#------------------------------------------------------------------------------
#  Inclusione del modulo smooth_movement
# noinspection RubyInstanceMethodNamingConvention
#==============================================================================
class Viewport
  include Smooth_Movements  #incusione del modulo del movimento fluido
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  alias smooth_udpate update unless $@
  def update
    smooth_udpate
    update_smooth_movements
  end
  #--------------------------------------------------------------------------
  # * Restituisce la posizione X
  #--------------------------------------------------------------------------
  def x; rect.x; end
  #--------------------------------------------------------------------------
  # * Restituisce la posizione Y
  #--------------------------------------------------------------------------
  def y; rect.y; end
  #--------------------------------------------------------------------------
  # * Modifica la posizione X
  #--------------------------------------------------------------------------
  def x=(value)
    rect.x = value
  end
  #--------------------------------------------------------------------------
  # * Modifica la posizione Y
  #--------------------------------------------------------------------------
  def y=(value)
    rect.y = value
  end
end #fine dello script