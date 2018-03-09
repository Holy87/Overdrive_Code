require File.expand_path('rm_vx_data')
#===============================================================================
# BARRA GENERICA SU MAPPA
#===============================================================================
# Autore: Holy87
# Versione: 1.2
# Difficoltà utente: ★★
# Changelog 1.2:
# - Possibilità di assegnare una variabile ad una barra, in modo da aggiornarsi
#   automaticamente ad ogni modifica del valore
# - Bugfix generali
# Changelog 1.1:
# - Passaggio di gestione da Game_Party a Game_System
# - Possibilità di inserire un numero illimitato di barre
# - Effetti speciali! Tremolio e flash alla barra
#-------------------------------------------------------------------------------
# Con questo script potrai mostrare una barra su mappa che indichi una qualsiasi
# cosa. È possibile, tramite comandi script, impostare posizione, descrizione e
# colore della barra, e, ovviamente, il valore.
# Non è volutamente personalizzabilissimo per renderlo facile da usare.
#-------------------------------------------------------------------------------
# Istruzioni:
# Copiare lo script sotto Materials, prima del Main. Puoi impostare la descri-
# zione della barra con un Chiama Script:
# ★ set_genbar("Testo"), ad esempio Vita, Magia ecc...
# una volta impostata, puoi mostrarla con il comando
# ★ show_bar
# puoi impostare il valore della barra con un numero da 0 a 100, chiamando lo
# script
# ★ bar_value(x), dove x è il valore.
# per chiudere la finestraq quando non serve più
# ★ hide_bar
#
# CONTROLLI AVANZATI:
# ★ set_genbar("Testo",colore,x,y)
# dove colore è Color.new(R,G,B) (R, G e B) sono le tonalità da 0 a 255, e
# rappresenta il colore della barra
# x e y sono rispettivamente le coordinate x e y del riquadro
# ★ bar_resize(lunghezza, altezza)
# ridimensiona l'aspetto del riquadro della barra
# ★ get_bar_value o get_bar_value(nome_barra) restituisce il valore della barra
#
# PER PIU' BARRE:
# ★ add_bar("nome_barra") aggiunge una nuova barra generica
# ★ remove_bar("nome_barra") elimina una barra dalla mappa
# ★ set_custom_bar("Testo",colore,x,y, "nome_barra")
#    aggiunge e imposta una nuova barra sullo schermo. La variabile nome_barra
#    la identifica (ad esempio "fame")
# ★ bar_resize(lunghezza, altezza, "nome_barra")
#    ridimensiona l'aspetto del riquadro della barra identificata da nome_barra
# ★ show_bar("nome_barra") mostra una barra specifica sullo schermo
# ★ bar_value(x, "nome_barra") imposta il valore di una barra specifica
# ★ hide_bar("nome_barra") nasconde una barra
#
# USARE EFFETTI SPECIALI
# ★ snooze_bar o snooze_bar(nome_barra) fa tremare la barra (ad esempio per
#    simulare un colpo ricevuto)
#    altre opzioni: snooze_bar(nome_barra, tempo, forza)
#    tempo: il tempo di tremata (predefinito è 15)
#    forza: la forza della tremata(predefinito è 5)
# ★ flash_bar o flash_bar(nome_barra) emette un flash sulla barra
#    altre opzioni: flash_bar(nome_barra, tempo, colore)
#    tempo: il tempo del flash (prefefinito è 30, ½ secondo)
#    colore (predefinito è bianco) mettere Color.new(R, G, B)
#-------------------------------------------------------------------------------
# Compatibilità:
# classe Spriteset_Map -> alias di update, initialize, terminate
#-------------------------------------------------------------------------------

#===============================================================================
# ** Impostazioni
#===============================================================================
module H87_GBSettings
  #R, G,  B
  Default_Color = [0,120,250]           #Colore predefinito
  DefaultX = 10                         #Posizione X predefinita
  DefaultY = 10                         #Posizione Y predefinita
  DefaultWidth = 200                    #Larghezza predefinita
  DefaultHeight = 40                    #Altezza predefinita

  BarHeight = 10                        #Altezza della barra

end
#============================================================================
# ** FINE CONFIGURAZIONE **
# Modificare da questo punto in poi è rischioso.
#============================================================================



$imported = {} if $imported == nil
$imported["h87_Genericbar"] = true
#===============================================================================
# ** Classe Game_System
#===============================================================================
class Game_System
  include H87_GBSettings          #Inclusione del modulo
  #-----------------------------------------------------------------------------
  # * Restituisce lo stato della barra generica
  #-----------------------------------------------------------------------------
  def generic_bar_settings(bar = :default)
    @barsettings = {} if @barsettings.nil?
    reset_bar_h(bar) if @barsettings[bar] == nil
    @barsettings[bar]
  end
  #-----------------------------------------------------------------------------
  # * Resetta le impostazioni della barra
  #-----------------------------------------------------------------------------
  def reset_bar_h(bar = :default)
    @barsettings[bar] = [
        bar_defaultx, #PosX
        bar_defaulty, #PosY
        bar_defaultw, #Larghezza
        bar_defaulth, #Altezza
        "",           #Nome
        bar_def_colr, #Colore Barra
        false,        #Visibile?
        0,            #Percentuale
        false,        #Cambiato?
        false         #aggiorna lung_barra
    ]
  end
  #-----------------------------------------------------------------------------
  # * Restituisce la schermata corrente (VX o VX Ace)
  #-----------------------------------------------------------------------------
  def current_scene
    begin
      return SceneManager.scene
    rescue
      return $scene
    end
  end
  #-----------------------------------------------------------------------------
  # * Restituisce il colore predefinito della barra
  #-----------------------------------------------------------------------------
  def bar_def_colr
    c = Default_Color
    Color.new(c[0],c[1],c[2])
  end
  #-----------------------------------------------------------------------------
  # * Restituisce la coordinata predefinita
  #-----------------------------------------------------------------------------
  def bar_defaultx
    DefaultX
  end
  #-----------------------------------------------------------------------------
  # * Restituisce la coordinata predefinita
  #-----------------------------------------------------------------------------
  def bar_defaulty
    DefaultY
  end
  #-----------------------------------------------------------------------------
  # * Restituisce la larghezza predefinita
  #-----------------------------------------------------------------------------
  def bar_defaultw
    DefaultWidth
  end
  #-----------------------------------------------------------------------------
  # * Restituisce l'altezza predefinita
  #-----------------------------------------------------------------------------
  def bar_defaulth
    DefaultHeight
  end
  #-----------------------------------------------------------------------------
  # * Reimposta le proprietà della finestra della barra. Aggiunge una nuova se
  #   il nome non è compreso
  #-----------------------------------------------------------------------------
  def generic_bar_set(letter, colore = bar_def_colr, x = nil, y = nil, bar = :default)
    @barsettings = {} if @barsettings.nil?
    if @barsettings[bar] == nil
      reset_bar_h
      add_active_bar(bar)
    end
    @barsettings[bar][0] = x if x != nil
    @barsettings[bar][1] = y if y != nil
    @barsettings[bar][4] = letter
    @barsettings[bar][5] = colore
    @barsettings[bar][8] = true #flag di modifica per refresh
  end
  #-----------------------------------------------------------------------------
  # * Metodo alternativo per impostare la barra
  #-----------------------------------------------------------------------------
  def set_bar(bar, text, colore = bar_def_colr, x = nil, y = nil)
    generic_bar_set(text, colore, x, y, bar)
  end
  #-----------------------------------------------------------------------------
  # * Restituisce il colore predefinito della barra
  #-----------------------------------------------------------------------------
  def active_bars
    @barsettings ||= {}
    return @barsettings
  end
  #-----------------------------------------------------------------------------
  # * Aggiunge una nuova barra
  #-----------------------------------------------------------------------------
  def add_active_bar(bar_name)
    return if bar_name == :default
    return if active_bars.keys.include?(bar_name)
    @barsettings[bar_name] = reset_bar_h(bar_name)
    current_scene.add_genbar(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Rimuove una barra
  #-----------------------------------------------------------------------------
  def remove_active_bar(bar_name)
    return if bar_name == :default
    return unless active_bars.keys.include?(bar_name)
    self.active_bars.delete(bar_name)
    current_scene.remove_genbar(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Mostra la finestra della barra
  #-----------------------------------------------------------------------------
  def show_generic_bar(bar = :default)
    @barsettings ||= {}
    reset_bar_h(bar) if @barsettings[bar] == nil
    return unless @barsettings[bar][6]
    @barsettings[bar][6] = true
    @barsettings[bar][8] = true
  end
  #-----------------------------------------------------------------------------
  # * Nasconde la finestra della barra
  #-----------------------------------------------------------------------------
  def hide_generic_bar(bar = :default)
    @barsettings ||= {}
    reset_bar_h(bar) if @barsettings[bar] == nil
    return unless @barsettings[bar][6]
    @barsettings[bar][6] = false
    @barsettings[bar][8] = true
  end
  #-----------------------------------------------------------------------------
  # * Assegna un valore da 0 a 100 per la percentuale della barra
  #-----------------------------------------------------------------------------
  def bar_percentage(value, bar = :default)
    @barsettings = {} if @barsettings.nil?
    reset_bar_h(bar) if @barsettings[bar].nil?
    max = @barsettings[bar][10] ? @barsettings[bar][10] : 100
    value = [[0, value].max, max].min
    @barsettings[bar][7] = value
    @barsettings[bar][9] = false
  end
  #-----------------------------------------------------------------------------
  # * restituisce il valore della barra
  #-----------------------------------------------------------------------------
  def get_bar_percentage(bar = :default)
    @barsettings = {} if @barsettings.nil?
    @barsettings[bar][7] = 0 if @barsettings[bar][7] == nil
    @barsettings[bar][7]
  end
  #-----------------------------------------------------------------------------
  # * Ridimensiona la finestra della barra
  #-----------------------------------------------------------------------------
  def bar_resize(w,h, bar = :default)
    @barsettings[bar][2] = w
    @barsettings[bar][3] = h
    @barsettings[bar][8] = true
  end
  #-----------------------------------------------------------------------------
  # *  Returns an assigned bars array
  #-----------------------------------------------------------------------------
  def assigned_bars; @assigned_bars ||= {}; end
  #-----------------------------------------------------------------------------
  # * Assegna il valore di una variabile ad una barra
  # @param [Integer] variable_id
  # @param [Object] bar_id
  #-----------------------------------------------------------------------------
  def assign_bar(variable_id, bar_id = :default)
    if assigned_bars[variable_id].nil?
      assigned_bars[variable_id] = [bar_id]
    else
      unless assigned_bars[variable_id].include?(bar_id)
        assigned_bars[variable_id].push(bar_id)
      end
    end
  end
  #-----------------------------------------------------------------------------
  # * Unassign bar from variable
  # @param [Integer] variable_id
  # @param [Object] bar_id
  #-----------------------------------------------------------------------------
  def unassign_bar(variable_id, bar_id = :default)
    assigned_bars[variable_id].delete(bar_id)
  end
  #-----------------------------------------------------------------------------
  # * Handle assigned bars
  # @param [Integer] variable_id
  # @param [Object] bar_id
  #-----------------------------------------------------------------------------
  def handle_bars(variable_id, value)
    return unless assigned_bars[variable_id]
    if assigned_bars[variable_id].size > 0
      assigned_bars[variable_id].each {|x| bar_percentage(value, x)}
    end
  end
end #game_system

#===============================================================================
# ** Classe Barra_Generica
#===============================================================================
class Barra_Generica
  attr_reader   :visible    # if the bar is visible
  attr_reader   :x          # x coord
  attr_reader   :y          # y coord
  attr_reader   :width      # bar frame width
  attr_reader   :height     # bar frame height
  attr_reader   :max_value  # max value
  #-----------------------------------------------------------------------------
  # * Inizializzazione
  #-----------------------------------------------------------------------------
  def initialize(viewport, bar_name = :default)
    @bar_name = bar_name
    @lb = H87_GBSettings::BarHeight #altezza barra
    @sp = 5                         #spaziatura
    @viewport = viewport
    @snooze_time = 0
    reset_settings
  end
  #-----------------------------------------------------------------------------
  # * Assegna (o reimposta) le proprietà
  #-----------------------------------------------------------------------------
  def reset_settings(update = false)
    set = $game_system.generic_bar_settings(@bar_name)
    @x = set[0]
    @y = set[1]
    @width = set[2]
    @height = set[3]
    @letter = set[4]
    @color = set[5]
    @visible = set[6]
    @max_value = set[10] ? set[10] : 100
    start(update)
  end
  #-----------------------------------------------------------------------------
  # * Comincia a creare la grafica
  #   update: true se è già stata creata
  #-----------------------------------------------------------------------------
  def start(update=false)
    create_main_graphic(update)
    create_bar(update)
  end
  #-----------------------------------------------------------------------------
  # * Crea la grafica di sfondo
  #-----------------------------------------------------------------------------
  def create_main_graphic(update)
    @sprite_rect.bitmap.clear if update
    barback_color = Color.new(@color.red/2,@color.green/2,@color.blue/2)
    bitmap = Bitmap.new(@width+4, @height+4)
    bitmap.fill_rect(2,2,@width,@height,Color.new(0,0,0,150))
    bitmap.blur
    bitmap.fill_rect(@sp,@height-(@sp+@lb),@width-(@sp*2),@lb,barback_color)
    bitmap.draw_text(@sp,@sp,@width-@sp,24,@letter)
    @sprite_rect = Sprite.new(@viewport)
    @sprite_rect.bitmap = bitmap
    @sprite_rect.x = @x-2
    @sprite_rect.y = @y-2
    @visible ? @sprite_rect.opacity = 255 : @sprite_rect.opacity = 0
  end
  #-----------------------------------------------------------------------------
  # * Crea la grafica della barra
  #-----------------------------------------------------------------------------
  def create_bar(update)
    @bar.bitmap.clear if update                       #pulisci se si deve agg.
    bitmap = Bitmap.new(1,@lb)
    @color = $game_system.generic_bar_settings(@bar_name)[5]
    bitmap.fill_rect(0,0,1,@lb,@color)
    @bar = Sprite.new(@viewport)
    @bar.x = @sprite_rect.x + @sp
    @bar.y = @sprite_rect.y + @sprite_rect.height - @sp-@lb -4
    @bar.bitmap = bitmap
    @bar.zoom_x = 1
    @visible ? @bar.opacity = 255 : @bar.opacity = 0
    $game_system.generic_bar_settings(@bar_name)[9] = false
  end
  #-----------------------------------------------------------------------------
  # * Imposta se mostrare o nascondere la finestra della barra
  #-----------------------------------------------------------------------------
  def visible=(vis)
    @visible = vis
    @visible ? @sprite_rect.opacity = 255 : @sprite_rect.opacity = 0
    @visible ? @bar.opacity = 255 : @bar.opacity = 0
  end
  #-----------------------------------------------------------------------------
  # * Effetto del flash
  #-----------------------------------------------------------------------------
  def flash(time = 30, color = Color.new(255,255,255))
    @bar.flash(color, time)
    @sprite_rect.flash(color, time)
  end
  #-----------------------------------------------------------------------------
  # * Effetto tremolio
  #-----------------------------------------------------------------------------
  def snooze(time = 20, str = 5)
    str = 0 if str < 0
    time = 0 if time < 0
    str = 20 if str > 20
    @snooze_str = str
    @snooze_time = time
  end
  #-----------------------------------------------------------------------------
  # * Aggiornamento
  #-----------------------------------------------------------------------------
  def update
    if $game_system.generic_bar_settings(@bar_name)[8] #controllo refresh
      reset_settings(true)
      $game_system.generic_bar_settings(@bar_name)[8] = false
      return
    end
    if @visible #aggiorna se la finestra è visibile
      bar_update
      snooze_update
      effects_update
    end
  end
  #-----------------------------------------------------------------------------
  # * Aggiornamento del tremolio
  #-----------------------------------------------------------------------------
  def snooze_update
    return if @snooze_time <= 0
    if @snooze_time % 2 == 0
      randx = rand(@snooze_str)-(@snooze_str/2)
      randy = rand(@snooze_str)-(@snooze_str/2)
      @bar.ox = randx
      @bar.oy = randy
      @sprite_rect.ox = randx
      @sprite_rect.oy = randy
    else
      @bar.ox = 0
      @bar.oy = 0
      @sprite_rect.ox = 0
      @sprite_rect.oy = 0
    end
    @snooze_time -= 1
    if @snooze_time == 0
      @bar.ox = 0
      @bar.oy = 0
      @sprite_rect.ox = 0
      @sprite_rect.oy = 0
    end
  end
  #-----------------------------------------------------------------------------
  # * Aggiornamento del flash
  #-----------------------------------------------------------------------------
  def effects_update
    @bar.update
    @sprite_rect.update
  end
  #-----------------------------------------------------------------------------
  # * Aggiornamento dell'animazione della barra
  #-----------------------------------------------------------------------------
  def bar_update
    return if $game_system.generic_bar_settings(@bar_name)[9]
    percent = $game_system.generic_bar_settings(@bar_name)[7]
    width = @width-(@sp*2)
    larg = width.to_f * percent / @max_value
    distanza = larg - @bar.zoom_x
    @bar.zoom_x += distanza/2
    $game_system.generic_bar_settings(@bar_name)[9] = true if distanza <1 and distanza > -1
  end
  #-----------------------------------------------------------------------------
  # * Assegnazione del valore massimo
  #-----------------------------------------------------------------------------
  def max_value=(value); @max_value = [1, value].max; end
  #-----------------------------------------------------------------------------
  # * Eliminazione
  #-----------------------------------------------------------------------------
  def dispose
    @bar.bitmap.dispose
    @bar.dispose
    @sprite_rect.bitmap.dispose
    @sprite_rect.dispose
  end
end #barra

#===============================================================================
# ** Classe Spriteset_Map
#===============================================================================
class Spriteset_Map
  alias bgen_initialize initialize unless $@
  alias bgen_dispose dispose unless $@
  alias bgen_update update unless $@
  #-----------------------------------------------------------------------------
  # * Alias Inizializzazione
  #-----------------------------------------------------------------------------
  def initialize
    create_generic_bars
    bgen_initialize
  end
  #-----------------------------------------------------------------------------
  # * Alias Uscita
  #-----------------------------------------------------------------------------
  def dispose
    bgen_dispose
    dispose_generic_bars
  end
  #-----------------------------------------------------------------------------
  # * Alias Aggiornamento
  #-----------------------------------------------------------------------------
  def update
    bgen_update
    update_generic_bars
  end
  #-----------------------------------------------------------------------------
  # * Creazione finestra con barra
  #-----------------------------------------------------------------------------
  def create_generic_bars
    @generic_bars = {}
    @generic_bars[:default] = Barra_Generica.new(@viewport2)
    $game_system.active_bars.each_key do |name|
      next if name == :default or name.nil?
      @generic_bars[name]=Barra_Generica.new(@viewport2, name)
    end
  end
  #-----------------------------------------------------------------------------
  # * Eliminazione
  #-----------------------------------------------------------------------------
  def dispose_generic_bars
    @generic_bars.each do |bar|
      bar[1].dispose
    end
  end
  #-----------------------------------------------------------------------------
  # * Aggiornamento
  #-----------------------------------------------------------------------------
  def update_generic_bars
    @generic_bars.each do |gbar|
      gbar[1].update
    end
  end
  #-----------------------------------------------------------------------------
  # * Aggiunge una barra
  #-----------------------------------------------------------------------------
  def add_gen_bar(bar_name)
    @generic_bars[bar_name] = Barra_Generica.new(@viewport2, bar_name)
    print @generic_bars.size
  end
  #-----------------------------------------------------------------------------
  # * Rimuove una barra
  #-----------------------------------------------------------------------------
  def remove_gen_bar(bar_name)
    bar = @generic_bars[bar_name]
    bar.visible = false
    bar.dispose
    @generic_bars.delete(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Flash alla barra
  #-----------------------------------------------------------------------------
  def bar_flash(time, color, bar)
    return if @generic_bars[bar].nil?
    @generic_bars[bar].flash(time, color)
  end
  #-----------------------------------------------------------------------------
  # * Tremolio della barra
  #-----------------------------------------------------------------------------
  def bar_snooze(time, str, bar)
    return if @generic_bars[bar].nil?
    @generic_bars[bar].snooze(time, str)
  end
end #spriteset_map

#===============================================================================
# ** Classe Game_Interpreter
#===============================================================================
class Game_Interpreter
  #-----------------------------------------------------------------------------
  # * Reimposta le proprietà della barra
  #-----------------------------------------------------------------------------
  def set_genbar(letter, color = bar_def_colr, x = nil, y = nil)
    $game_system.generic_bar_set(letter, color, x, y)
  end
  #-----------------------------------------------------------------------------
  # * Reimposta una barra generica
  #-----------------------------------------------------------------------------
  def set_custom_bar(bar_name, letter, color = bar_def_colr, x = nil, y = nil)
    $game_system.generic_bar_set(letter, color, x, y, bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Nascondi barra
  #-----------------------------------------------------------------------------
  def hide_bar(bar_name = :default)
    $game_system.hide_generic_bar(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Mostra barra
  #-----------------------------------------------------------------------------
  def show_bar(bar_name = :default)
    $game_system.show_generic_bar(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Assegna valore barra
  #-----------------------------------------------------------------------------
  def bar_value(value, bar_name = :default)
    $game_system.bar_percentage(value, bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Ridimensiona finestra
  #-----------------------------------------------------------------------------
  def bar_resize(width,height,bar_name = :default)
    $game_system.bar_resize(width,height,bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Aggiunge una barra personalizzata
  #-----------------------------------------------------------------------------
  def add_bar(bar_name)
    $game_system.add_active_bar(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Rimuove una barra personalizzata
  #-----------------------------------------------------------------------------
  def remove_bar(bar_name)
    $game_system.remove_active_bar(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Flash alla barra
  #-----------------------------------------------------------------------------
  def flash_bar(bar = :default, time = 30, color = Color.new(255,255,255))
    $game_system.current_scene.bar_flash(time, color, bar)
  end
  #-----------------------------------------------------------------------------
  # * Tremolio
  #-----------------------------------------------------------------------------
  def snooze_bar(bar = :default, time = 15, str = 5)
    $game_system.current_scene.bar_snooze(time, str, bar)
  end
  #-----------------------------------------------------------------------------
  # * Assign a bar to a variable change
  # @param [Integer] variable_id
  # @param [Object] bar_id
  #-----------------------------------------------------------------------------
  def assign_bar(variable_id, bar_id = :default)
    $game_system.assign_bar(variable_id, bar_id)
  end
  #-----------------------------------------------------------------------------
  # * Unassign a bar from a variable
  # @param [Integer] variable_id
  # @param [Object] bar_id
  #-----------------------------------------------------------------------------
  def unassign_bar(variable_id, bar_id = :default)
    $game_system.unassign_bar(variable_id, bar_id)
  end
  #-----------------------------------------------------------------------------
  # * Set a new max (100 default)
  # @param [Integer] max
  # @param [Object] bar_id
  #-----------------------------------------------------------------------------
  def set_bar_max(max = 100, bar_id = :default)
    $game_system.set_bar_max(max, bar_id)
  end
  #-----------------------------------------------------------------------------
  # * Assegnazione colore
  #-----------------------------------------------------------------------------
  def bar_def_colr
    c = H87_GBSettings::Default_Color
    Color.new(c[0],c[1],c[2])
  end
end #game_interpreter

#===============================================================================
# ** Classe Scene_Base
#===============================================================================
class Scene_Base
  #-----------------------------------------------------------------------------
  # * Metodi vuoti, servono per non generare errori se non si è sulla mappa.
  #-----------------------------------------------------------------------------
  def add_genbar(bar_name);end
  def remove_genbar(bar_name);end
  def bar_flash(time, color, bar);end
  def bar_snooze(time, str, bar);end
end #scene_base

#===============================================================================
# ** Classe Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  #-----------------------------------------------------------------------------
  # * Aggiunge una barra allo spriteset
  #-----------------------------------------------------------------------------
  def add_genbar(bar_name)
    @spriteset.add_gen_bar(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Rimuove una barra dallo spriteset
  #-----------------------------------------------------------------------------
  def remove_genbar(bar_name)
    @spriteset.remove_gen_bar(bar_name)
  end
  #-----------------------------------------------------------------------------
  # * Flash barra dello spriteset
  #-----------------------------------------------------------------------------
  def bar_flash(time, color, bar)
    @spriteset.bar_flash(time, color, bar)
  end
  #-----------------------------------------------------------------------------
  # * Tremolio alla barra dello spriteset
  #-----------------------------------------------------------------------------
  def bar_snooze(time, str, bar)
    @spriteset.bar_snooze(time,str,bar)
  end
end #scene_map

#===============================================================================
# ** Game_Variables
#===============================================================================
class Game_Variables
  alias old_set []= unless $@
  #-----------------------------------------------------------------------------
  # * Adding bar handle on value change
  # @param [Integer] variable_id
  # @param [Integer] value
  #-----------------------------------------------------------------------------
  def []=(variable_id, value)
    old_set(variable_id, value)
    $game_system.handle_bars(variable_id, value)
  end
end