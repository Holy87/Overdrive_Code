require 'rm_vx_data'
#===============================================================================
# ** Opzioni Overdrive
#===============================================================================

# Cambia velocità battaglia
H87Options.push_game_option(
    { :type => :variable,   #tipo variabile
      :text => "Velocità battaglia",#testo mostrato
      :help => "Modifica la velocità di Battaglia. Valori grandi fanno|caricare l'ATB più velocemente.", #descrizione
      :var  => 121,          #variabile
      :values => [1,2,3,4,5,6,7,8],
      :method => :update_atb_speed,
      :default => 6
    }
)

# Cambia modalità di battaglia
H87Options.push_game_option({
    :type => :switch,
    :text => 'Modalità Battaglia',
    :help => 'Attesa: I nemici attenderanno la tua mossa|Azione: Il tempo scorre senza sosta.',
    :sw => 584,
    :on => 'Azione',
    :off => 'Attesa',
    :default => false,
    :method => :update_atb

                            })

H87Options.push_game_option({
    :type => :switch,
    :text => 'Info battaglia',
    :help => 'Mostra o nascondi il popup delle azioni in battaglia.',
    :on => 'Mostra',
    :off => 'Nascondi',
    :sw => 598
                            })

# Attivare o disattivare invio dati di gioco
H87Options.push_internet_option({
    :type => :switch,
    :text => 'Invia dati di gioco',
    :help => 'Attiva o disattiva la funzionalità online. Se disattivi questa opzione,|non potrai ricevere assistenza remota.',
    :on => 'Invia',
    :off => 'Non inviare',
    :sw => 426
                                })

# Attivare o disattivare popup messaggi sfera dimensionale
H87Options.push_internet_option({
    :type => :switch,
    :text => 'Notifiche nuovi messaggi',
    :help => 'Se questa funzione viene attivata, ti verrà mostrato un avviso quando|viene aggiunto un messaggio a una sfera su cui hai scritto di recente.',
    :on => 'Notifica',
    :off => 'Nascondi',
    :sw => 579,
    :condition => '$game_switches[426]'
                                })

# Effetti di rendering
H87Options.push_graphic_option({
    :type => :switch,
    :text => 'Effetti rendering',
    :help => 'Attiva gli effetti HDR stile "anime" e motion blur. Influisce molto|sulle prestazioni del gioco.',
    :on => 'Attiva',
    :off => 'Disattiva',
    :sw => 353,
    :default => false
                               })


#===============================================================================
# ** Classe Option
#===============================================================================
class Option
  #--------------------------------------------------------------------------
  # * Aggiornamento modalità battaglia
  #--------------------------------------------------------------------------
  def update_atb(value)
    $game_party.atb_custom[0] = value ? 0 : 2
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento velocità battaglia
  #--------------------------------------------------------------------------
  def update_atb_speed(value)
    $game_party.atb_custom[1] = value
  end
end

#===============================================================================
# ** Classe Game_System
#===============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Help battaglia attivato?
  #--------------------------------------------------------------------------
  def self.show_skill_popup?; $game_switches[598]; end
end

#===============================================================================
# ** Classe Scene_Battle
#===============================================================================
class Scene_Battle < Scene_Base
  alias ov_help pop_help unless $@
  #--------------------------------------------------------------------------
  # * Mostra help battaglia
  #--------------------------------------------------------------------------
  def pop_help(obj)
    return unless $game_system.show_skill_popup?
    ov_help(obj)
  end
end