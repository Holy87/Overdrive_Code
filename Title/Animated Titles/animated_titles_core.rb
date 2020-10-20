#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  Aggiunta del caricamento della grafica dei titoli nella nuova cartella
#==============================================================================
module Cache
  def self.title(filename)
    begin
      load_bitmap("Graphics/System/Title/", filename)
    rescue
      load_bitmap("Graphics/Pictures/", filename)
    end
  end
end

module Animated_Titles
  # @return [Array<Class>]
  def self.available_animated_titles
    @animated_titles ||= []
  end

  def self.add_animated_title(animated_title)
    return if available_animated_titles.include?(animated_title)
    available_animated_titles.push(animated_title)
  end

  # @return [AnimatedTitle]
  def self.animated_title
    @animated_title ||= create_animated_title
  end

  def self.animated_title_exist?
    @animated_title != nil
  end

  # @return [AnimatedTitle]
  def self.create_animated_title
    Animated_Titles.available_animated_titles.sample.new
  end

  def self.delete_animated_title
    @animated_title = nil
  end
end

#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  Modifica dell'avvio della schermata del titolo
#==============================================================================
class Scene_Title < Scene_Base
  alias animated_title_update update
  alias animated_title_continue command_continue

  def create_background
    @background = Animated_Titles.animated_title
  end

  # Alias aggiornamento

  def update
    animated_title_update
    @background.update
  end

  # Elimina la grafica del titolo
  def dispose_background
    @background.dispose
  end

  def command_continue
    @background.prepare_for_pass
    animated_title_continue
    @background.hide_title
  end
end

#==============================================================================
# ** AnimatedTitle
#------------------------------------------------------------------------------
#  Viene ereditata dalle varie schermate del titolo
#==============================================================================
class AnimatedTitle
  attr_reader :z #posizione z degli elementi
  attr_accessor :viewport #viewport del titolo (se presente)
  attr_reader :components #immagini che compongono la schermata
  attr_reader :darken #valore che specifica se il titolo è scurito o no

  # Inizializzazione
  def initialize(new_viewport = nil)
    @z = 1
    @components = []
    @darken = false
    @hide_title = false
    @viewport = new_viewport
    title_initialize
    create_dark_graphic
  end

  def last_z
    @components.collect { |sprite| sprite.z }.max { |a, b| a <=> b }
  end

  # Aggiornamento
  def update
    graphics_update
    dark_update
  end

  # Creazione della patina per scurire il titolo
  def create_dark_graphic
    @dark = Sprite.new
    @dark.bitmap = dark_bitmap
    @dark.opacity = 0
    @components.push(@dark)
  end

  # Restituisce una bitmap nera grande quanto lo schermo
  # @return [Bitmap]
  def dark_bitmap
    bitmap = Bitmap.new(Graphics.width, Graphics.height)
    bitmap.fill_rect(0, 0, bitmap.width, bitmap.height, Color.new(0, 0, 0, 128))
    bitmap
  end

  # Imposta l'ordine
  def z=(dim_z)
    @components.each_with_index { |component, index| component.z = dim_z + index }
  end

  # Aggiorna lo scurimento
  def dark_update
    @darken ? @dark.opacity += 25 : @dark.opacity -= 25
  end

  # Azione di scurimento dello schermo
  def go_dark
    @darken = true
    @dark.z = last_z + 1
  end

  # Azione di ripristino della luminosità
  def fade_dark
    @darken = false
  end

  # Imposta un nuovo viewport alle componenti
  def viewport=(new_viewport)
    @viewport = new_viewport
    all_sprites.each { |sprite| sprite.viewport = new_viewport }
  end

  # restituisce tutti gli sprite del titolo
  # @return [Array<Sprite>]
  def all_sprites
    instance_variables.collect{|varname| instance_variable_get(varname)}.select{|component| component.is_a?(Sprite)}
  end

  # Elimina le componenti
  def dispose
    if @passing
      @passing = false
      return
    end
    all_sprites.each { |sprite| sprite.dispose }
    @viewport.dispose unless @viewport.nil?
    Animated_Titles.delete_animated_title
  end

  # Forza a non essere disposto il titolo, nel caso in cui verrà passato ad
  #   un'altra schermata.
  def prepare_for_pass
    @passing = true
  end

  def hide_title
    @hide_title = true
  end

  def show_title
    @hide_title = false
  end
end