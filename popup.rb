$imported = {} if $imported == nil
$imported["H87_Popup"] = true
#===============================================================================
# Sistema Popup di Holy87
# Difficoltà utente: ★★
# Versione 1.1
#===============================================================================
# Questo script permette di mostrare in modo dinamico popup multipli per
# l'acquisizione o lo smarrimento di oro e oggetti, quando si ottiene unleve
# up, e inoltre può aiutare il debugging del gioco mostrando in tempo reale
# cambiamenti a switch e variabili.
# Non solo, ma è possibile anche creare popup personalizzati per le più
# svariate situazioni. Basta mettere semplicemente in un evento, un Chiama
# Script con:
# Popup.show("messaggio")
# Oppure
# Popup.show("Messaggio",x) dove x sta all'id dell'icona
# oppure ancora
# Popup.show("Messaggio",x,[R,G,B,S]) dove RGB sono le tonalità, S la saturazione.
#-------------------------------------------------------------------------------
# INSTALLAZIONE
# Installare sotto Materials, prima del Main. Importare una immagine come barra
# per i popup. Non ha importanza la grandezza, lo script adatterà il popup a
# seconda delle dimesioni dell'immagine.
# INFO compatibilità:
# *Classe Scene_Map
#  Alias: update, start, terminate
# *Classe Game_Party
#  Alias: gain_gold, gain_item
# *Classe Game_Interpreter
#  Alias: command_121
#  Sovrascrive: command_122
# *Classe Game_Actor
#  Sovrascrive: show_level_up
#===============================================================================
module H87_Popup
#-------------------------------------------------------------------------------
# CONFIGURAZIONE GENERALE
# Configura lo script nelle opzioni generiche.
#-------------------------------------------------------------------------------
#Velocità di comparsa del popup. Numeri piccoli aumentano la velocità.
  Speed = 3
  #-----------------------------------------------------------------------------
  #Tempo in secondi, prima che il popup cominci a sparire.
  PTime = 4
  #-----------------------------------------------------------------------------
  #Velocità di sparizione del popup una volta che scade il tempo
  Fade = 3
  #-----------------------------------------------------------------------------
  #Coordinata Y del popup quando apparirà.
  #Se viene impostato in basso allo schermo, popup consecutivi creeranno una
  #pila che sale, altrimenti scenderà.
  Altezza = 300
  #-----------------------------------------------------------------------------
  #Grafica dell'immagine dello sfondo del popup
  Grafica = "BarraPopup"
  #-----------------------------------------------------------------------------
  #Distanza in pixel dal bordo sinistro dello schermo quando spunta il popup
  Distanzax = 5
  #Distanza in pixel dei popup consecutivi quando vengono messi in fila
  Distanzay = 3
  #-----------------------------------------------------------------------------
  #Imposta lo switch che verrà usato per attivare e disattivare i popup
  #automatici, nel caso tu voglia cambiare denaro e oggetti al giocatore senza
  #che se ne accorga.
  Switch = 429
  #-----------------------------------------------------------------------------
  #Vuoi mostrare i cambiamenti di switch e variabili in tempo reale, quando
  #avvi il gioco in modalità test?
  ShowInTest = false
  #-------------------------------------------------------------------------------
  # CONFIGURAZIONE SPECIFICA
  # Configurazione specifica di attivazione, suono e colore di ogni tipo di popup
  #-------------------------------------------------------------------------------
  # *Configurazione Oggetti
  #Seleziona il suono che verrà eseguito all'ottenimento dell'oggetto
  SuonoOggetto = "Item1"
  #Imposta la tonalità di colore del popup (Rosso, Verde, Blu e Saturazione)
  ItemPreso= [-40,20,50,10]
  #-----------------------------------------------------------------------------
  # *Configura l'ottenimento del denaro
  #Seleziona l'icona che verrà mostrata quando otterrai del denaro
  Iconaoro = 298
  #Seleziona il suono che verrà eseguito all'ottenimento del denaro
  SuonoOro = "Shop"
  #Mostrare il popup quando si ottiene denaro?
  Mostra_OroU = true
  #Mostrare il popup quando si perde denaro?
  Mostra_OroD = true
  #Seleziona la tonalità di colore del popup quando si ottiene denaro
  GoldTone = [-50,70,0,10]
  #Seleziona la tonalità di colore del popup quando si perde denaro
  GoldPerso= [70,0,-50,50]
  #-----------------------------------------------------------------------------
  # *Configura il livello superiore (Funziona solo se selezioni Mostra Level Up)
  # Mostrare il livello superiore con un popup, o con il metodo classico?
  MostraLevel = true
  # Mostrare i poteri appresi quando si sale di livello su mappa?
  MostraPoteri = true
  #Icona del livello superiore
  IconaLevel = 62
  #Tonalità che viene mostrata al livello superiore
  LivSup      = [ 50, 50,100,0]
  #Tonalità che viene mostrata per i nuovi poteri appresi
  NuoveSkill  = [ 50, 50,50,0]
  #Suono che viene eseguito al livello superiore
  SuonoLevel = "Up"
  #Testo dell'abilità appresa
  Learn = "appresa!"
  #-----------------------------------------------------------------------------
  # *Configura popup per switch e variabili (funziona solo in modalità Test)
  #Seleziona l'icona di switch e variabili
  Iconaswitch = 80
  #Seleziona la tonalità di colore
  SwitchTone = [0,0,0,255]
#-----------------------------------------------------------------------------
#===============================================================================
# FINE CONFIGURAZIONE
# Modificare tutto ciò che c'è sotto può compromettere il corretto funzionamento
# dello script. Agisci a tuo rischio e pericolo!
#===============================================================================
end
#===============================================================================
# Modulo Popup
#===============================================================================
module Popup
  def self.show(testo, icona=0, tone=nil)
    $scene.mostra_popup(testo, icona, tone) if $scene.is_a?(Scene_Map)
  end

  def self.esegui(suono)
    RPG::SE.new(suono,80,100).play if $scene.is_a?(Scene_Map)
  end
end

#===============================================================================
# Classe Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  include H87_Popup

  #-----------------------------------------------------------------------------
  # * Start
  #-----------------------------------------------------------------------------
  alias h87_pstart start
  def start
    h87_pstart
    @popups = []
  end

  #-----------------------------------------------------------------------------
  # * Update
  #-----------------------------------------------------------------------------
  alias h87_pupdate update
  def update
    h87_pupdate
    aggiorna_popups
  end

  #-----------------------------------------------------------------------------
  # * Aggiunge un nuovo popup
  #-----------------------------------------------------------------------------
  def mostra_popup(testo, icona=0, tone=nil)
    immagine = Sprite.new(@viewport3)
    immagine.bitmap = Cache.picture(Grafica)
    immagine.tone = Tone.new(tone[0],tone[1],tone[2],tone[3]) if tone != nil
    finestra = Window_Map_Popup.new(immagine.width,testo, icona)
    finestra.opacity = 0
    finestra.x = 0-finestra.width
    finestra.y = Altezza
    immagine.x = riposizionax(finestra,immagine)
    immagine.y = riposizionay(finestra,immagine)
    immagine.z = 999
    finestra.z = 1000
    popup = [finestra,immagine,0,0]
    sposta_popup_su #sposta sopra tutti i popup già presenti
    @popups.push(popup)
  end

  #-----------------------------------------------------------------------------
  # * Calcola la posizione dell'immagine
  #-----------------------------------------------------------------------------
  def riposizionax(finestra,immagine)
    larg=(finestra.width-immagine.width)/2
    return finestra.x+larg
  end

  #-----------------------------------------------------------------------------
  # * Calcola la posizione dell'immagine
  #-----------------------------------------------------------------------------
  def riposizionay(finestra,immagine)
    alt=(finestra.height-immagine.height)/2
    return finestra.y+alt
  end

  #-----------------------------------------------------------------------------
  # * Aggiornamento
  #-----------------------------------------------------------------------------
  def aggiorna_popups
    muovi_popup
    fade_popup
  end

  #-----------------------------------------------------------------------------
  # * Muove i popup
  #-----------------------------------------------------------------------------
  def muovi_popup
    for i in 0..@popups.size-1
      break if @popups[i] == nil
      barra = @popups[i]
      finestra = barra[0]
      next if finestra.disposed?
      immagine = barra[1]
      tempo    = barra[2]
      prossimay= barra[3]
      x = finestra.x
      y = finestra.y
      metax = Distanzax
      if Altezza > Graphics.height/2
        metay = Altezza - Distanzay - prossimay
      else
        metay = Altezza + Distanzay + prossimay
      end
      finestra.x += (metax-x)/Speed
      finestra.y += (metay-y)/Speed
      tempo += 1
      immagine.x = riposizionax(finestra,immagine)
      immagine.y = riposizionay(finestra,immagine)
      if tempo > PTime*Graphics.frame_rate
        finestra.contents_opacity -= Fade
        immagine.opacity -= Fade
      end
      @popups[i] = [finestra,immagine,tempo, prossimay] #riassemblamento
    end
  end

  #-----------------------------------------------------------------------------
  # * Assegna la prossima coordinata Y
  #-----------------------------------------------------------------------------
  def sposta_popup_su
    for i in 0..@popups.size-1
      next if @popups[i][1].disposed?
      @popups[i][3]+=@popups[i][1].height+Distanzay
    end
  end

  #-----------------------------------------------------------------------------
  # * Terminate
  #-----------------------------------------------------------------------------
  alias h87_pterminate terminate
  def terminate
    h87_pterminate
    for i in 0..@popups.size-1
      elimina_elemento(i)
    end
  end

  #-----------------------------------------------------------------------------
  # *Elimina i popup non più presenti
  #-----------------------------------------------------------------------------
  def fade_popup
    for i in 0..@popups.size-1
      next if @popups[i][1].disposed?
      if @popups[i][1].opacity == 0
        elimina_elemento(i)
      end
    end
  end

  #-----------------------------------------------------------------------------
  # *Dispone finestre e picture
  #-----------------------------------------------------------------------------
  def elimina_elemento(i)
    @popups[i][0].dispose unless @popups[i][0].disposed?
    @popups[i][1].dispose unless @popups[i][1].disposed?
  end

end

#===============================================================================
# Classe Window_Map_Popup
#===============================================================================
class Window_Map_Popup < Window_Base
  def initialize(larghezza,testo, icona=0)
    super(0,0,larghezza,WLH+32)
    @testo = testo
    @icona = icona
    refresh
  end

  def refresh
    self.contents.clear
    unless @icona == 0
      draw_icon(@icona,0,0)
      dist = 24
    else
      dist = 0
    end
    self.contents.draw_text(dist,0,self.width-(32+dist),WLH,@testo)
  end
end #Scene_Map

#===============================================================================
# Classe Game_Party
#===============================================================================
class Game_Party < Game_Unit
  alias ottieni_oro gain_gold
  #-----------------------------------------------------------------------------
  # * Ottieni Oro
  #-----------------------------------------------------------------------------
  def gain_gold(n)
    if $game_switches[H87_Popup::Switch] == false
      if n> 0 and H87_Popup::Mostra_OroU
        Popup.show("+"+n.to_s+Vocab.gold,H87_Popup::Iconaoro,H87_Popup::GoldTone)
        Popup.esegui(H87_Popup::SuonoOro)
      end
      if n < 0 and H87_Popup::Mostra_OroD
        Popup.show(n.to_s+Vocab.gold,H87_Popup::Iconaoro,H87_Popup::GoldPerso)
        Popup.esegui(H87_Popup::SuonoOro)
      end
    end
    ottieni_oro(n)
  end

  #-----------------------------------------------------------------------------
  # * Ottieni Oggetto
  #-----------------------------------------------------------------------------
  alias prendi_oggetto gain_item unless $@
  def gain_item(item, n, include_equip = false)
    oggetto = item
    if n > 0 and $game_switches[H87_Popup::Switch] == false and item != nil and $scene.is_a?(Scene_Map)
      nome = oggetto.name
      icona = oggetto.icon_index
      testo = sprintf("%s x%d",nome,n)
      Popup.show(testo,icona,H87_Popup::ItemPreso)
      Popup.esegui(H87_Popup::SuonoOggetto)
    end
    prendi_oggetto(item, n, include_equip)
  end

end # Game_Party

class Game_Actor < Game_Battler

  #-----------------------------------------------------------------------------
  # * Mostra Lv. Up
  #-----------------------------------------------------------------------------
  def display_level_up(new_skills)
    if $scene.is_a?(Scene_Map) and H87_Popup::MostraLevel
      testo = sprintf("%s %s %d!",@name,Vocab::level,@level)
      Popup.show(testo,H87_Popup::IconaLevel,H87_Popup::LivSup)
      Popup.esegui(H87_Popup::SuonoLevel)
      if H87_Popup::MostraPoteri
        for skill in new_skills
          testo = sprintf("%s %s",skill.name,H87_Popup::Learn)
          Popup.show(testo,skill.icon_index,H87_Popup::NuoveSkill)
        end
      end
    else
      $game_message.new_page
      text = sprintf(Vocab::LevelUp, @name, Vocab::level, @level)
      $game_message.texts.push(text)
      for skill in new_skills
        text = sprintf(Vocab::ObtainSkill, skill.name)
        $game_message.texts.push(text)
      end
    end
  end
end # Game_Actor