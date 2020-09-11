require 'rm_vx_data'

#===============================================================================
# ** Impostazioni popup danno
#===============================================================================
module Damage_Settings
  RANDOM_RANGE = 20 # in pixel, il margine di comparsa del danno dalla posizione
end

#==============================================================================
# ** classe Damage_Container
#------------------------------------------------------------------------------
#  È una classe wrapper che si sostituisce a Sprite_Damage nel Sideview,
#  serve per mostrare più sprite di danno contemporaneamente se ci sono attacchi
#  multipli e il danno precedente non è ancora scomparso.
#==============================================================================
class Damage_Container
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  # @attr[Game_Battler] battler
  # @attr[Viewport] viewport
  # @attr[Sprite_Damage] damage_sprite
  #--------------------------------------------------------------------------
  attr_accessor :battler
  attr_accessor :viewport
  attr_accessor :damage_sprites
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Game_Battler] battler
  # @param [Viewport] viewport
  #--------------------------------------------------------------------------
  def initialize(battler, viewport)
    @battler = battler
    @viewport = viewport
    @damage_sprites = []
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def update; @damage_sprites.each {|sprite| sprite.update}; end
  #--------------------------------------------------------------------------
  # * eliminazione
  #--------------------------------------------------------------------------
  def dispose
    return if @damage_sprites.size == 0
    @damage_sprites.each {|sprite| sprite.dispose}
  end
  #--------------------------------------------------------------------------
  # * mostra il danno
  # @param [Number] damage
  #--------------------------------------------------------------------------
  def damage_pop(damage = nil)
    sprite = Sprite_Damage.new(@viewport, @battler)
    sprite.set_end_handler(method(:check_pops))
    sprite.damage_pop(damage)
    @damage_sprites.push(sprite)
  end
  #--------------------------------------------------------------------------
  # * controlla tutti gli sprite di danno
  #--------------------------------------------------------------------------
  def check_pops
    sprites = @damage_sprites.delete_if {|sprite| sprite.cancellable?}
  end
end

#===============================================================================
# ** Sprite_Damage
#===============================================================================
class Sprite_Damage < Sprite_Base
  alias h87_update update unless $@
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def update
    return if @num6.disposed?
    h87_update
    remove
  end
  #--------------------------------------------------------------------------
  # * calcola la posizione nel raggio random
  #--------------------------------------------------------------------------
  def calc_rand_range
    range = Damage_Settings::RANDOM_RANGE
    rand(range)-range/2
  end
  #--------------------------------------------------------------------------
  # * imposta l'evento di fine danno
  #--------------------------------------------------------------------------
  def set_end_handler(handler)
    @end_handler = handler
  end
  #--------------------------------------------------------------------------
  # * rimuovi danno
  #--------------------------------------------------------------------------
  def remove
    return unless @end_handler
    return if @duration > 0
    @cancellable = true
    @window.visible = false if @window
    @end_handler.call
    dispose
  end
  #--------------------------------------------------------------------------
  # * determina se si può rimuovere
  #--------------------------------------------------------------------------
  def cancellable?; @cancellable; end
end