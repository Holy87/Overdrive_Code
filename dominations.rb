require 'rm_vx_data' if false

#===============================================================================
# ** modulo Vocab (per le scritte)
#===============================================================================
module Vocab
  def self.rec_dom;"In ricarica... (%d/%d)";end
  def self.ready_dom;"Pronto alla battaglia";end
  def self.dominations;"Dominazioni";end
  def self.bon_dom;"Bonus";end
  def self.boost;"Turbo";end
  def self.milky;"Oggetti";end
  def self.elements;"Elementi";end
  def self.element_desc;"Visualizza le resistenze elementali.";end
  def self.new_boost;"%s ha sbloccato %s!";end
  def self.skill_desc;"Vedi e attiva/disattiva le abilità della dominazione.";end
  def self.milky_desc;"Usa le scorte di latte per ricaricare le dominazioni.";end
  def self.in_use_by;"In uso da";end
  def self.esper_duration;"Durata:";end
  def self.no_user;"nessuno";end
  def self.actBonus;"Bonus";end
  def self.bonus_desc;"Visualizza i potenziamenti attivati dal tempio delle|Dominazioni.";end
  def self.summon_number;"Evocato:";end
  def self.summon_times;"%d volte.";end
  def self.boost_desc;"Attivando i Turbo l'evocazione sarà più potente, ma resterà|per minor tempo in campo.";end
  def self.domination_ready;"%s è pronto a combattere.";end
end

#===============================================================================
# ** CONFIGURAZIONE DELLE DOMINAZIONI
#===============================================================================
module EsperConfig
  module_function #può essere integrato

  DomiActSw = 590 #switch che attiva il menu dominazioni
  BarL = 200 #lunghezzza della barra
  BarH = 3 #altezza della barra

  SW_Dom = {
      #ID    SWITCH
      17 => 106,#Nymeria
      18 => 326,#Fuffi
      19 => 109,
      20 => 433,
      21 => 430,
      22 => 425,
      23 => 214,
      24 => 432,
      25 => 436,
      27 => 583, #juggernaut
  }

  #--------------------------------------------------------------------------
  # * Descrizione delle evocazioni
  #--------------------------------------------------------------------------
  Ds_Dom = {
      17 => "Un gatto delle nevi molto bravo nell'uso delle magie del ghiaccio.",
      18 => "Un mastino infernale di terra utile nel corpo a corpo.",
      19 => "Una fata che sosterrà i suoi amici con le sue magie curative.",
      20 => "Leoncino di peluche che potenzierà il gruppo con i suoi canti.",
      21 => "Una tartaruga corazzata che proteggerà gli alleati con il suo scudo.",
      22 => "Toro fiammeggiante e furioso che lancia attacchi devastanti.",
      23 => "Velocissimo con i suoi attacchi e magie del fulmine.",
      24 => "Lancia magie oscure e assorbe la vita dei nemici.",
      25 => "Indebolisce i nemici con i suoi numerosi stati alterati.",
      27 => "Un carro robotizzato che bersaglia i nemici con colpi a ripetizione.",
  }

  #--------------------------------------------------------------------------
  # * Abilità e potenziamenti delle dominazioni
  #--------------------------------------------------------------------------
  BonusStates = {#abilità passive delle evocazioni
                 #ID    Descrizione
                 39 => "Max PV +20%",
                 40 => "Max PM +20%",
                 43 => "Attacco +20%",
                 44 => "Difesa +20%",
                 45 => "Spirito +20%",
                 46 => "Velocità +20%",
                 61 => "Odio +10%",
                 71 => "Acutezza +20%",
                 73 => "Evasione +4%",
                 74 => "Critici +4%",
                 91 => "Sinergia +15%",
                 239=> "Durata +20%",
  }

  #--------------------------------------------------------------------------
  # * Oggetti magnetite associati alla dominazione
  #--------------------------------------------------------------------------
  Magnetite = {
      #ID magnetite con ID dominazione
      17 => 224,
      18 => 225,
      19 => 226,
      20 => 227,
      21 => 228,
      22 => 229,
      23 => 230,
      24 => 231,
      25 => 232,
      27 => 233
  }

  #--------------------------------------------------------------------------
  # * Turbo sbloccabili
  #--------------------------------------------------------------------------
  Boosts = {
      #Nymeria: Antispirito, dif. freddo, att. freddo, spir+, autoenergia
      17 => {253 => 6, 275 => 12, 261 => 20, 245 => 35, 252 => 50},
      #Fuffi: Dif. terra, Cri+4, At. Terra, contrattacco
      18 => {278 => 6, 248 => 12, 264 => 23, 256 => 40},
      #miyu: odio-, fort, rigenera, cura
      19 => {250 => 7, 271 => 14, 251 => 25, 257=> 50},
      #kon: eva+, pm, mira, costo-
      20 => {247 => 6, 242 => 14, 268 => 28, 258 => 43},
      #thartaros: acqua++, odio+, acqua+, barriera
      21 => { 263 => 6, 249 => 14, 277 => 28, 254 => 43},
      #volc: dif. fuoco, forza, att. fuoco, grinta
      22 => {274 => 6, 243 => 12, 260 => 24, 266 => 40},
      #rakurai: dif t, vel, at t, ricarica rapida
      23 => {276 => 6,  246 => 10, 262 => 22, 267 => 40},
      #ogard: dif o, antigrav, pv+, divoratore
      24 => {281 => 10, 259 => 20, 241 => 35, 255 => 50},
      #bufos = dif+, salvezza, dur. sin
      25 => {244=> 5, 272 => 10, 269 => 20},
      #juggernaut
      27 => {},}

  #--------------------------------------------------------------------------
  # * Mostra il numero predefinito di battaglie da ricaricare
  #--------------------------------------------------------------------------
  def time_recharge(domination_id)
    Espers::Esper_List[domination_id][2]
  end
  #--------------------------------------------------------------------------
  # * Mostra quante battaglie si è ricaricato
  #--------------------------------------------------------------------------
  def recharged(domid)
    time_recharge(domid) + $game_variables[Espers::Esper_List[domid][0]]
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se la dominazione è stata sbloccata
  #--------------------------------------------------------------------------
  def domination_unlocked?(domination_id)
    $game_party.domination_unlocked?(domination_id)
    #$game_switches[SW_Dom[domination_id]]
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se il menu è stato sbloccato
  #--------------------------------------------------------------------------
  def self.menu_unlocked?
    $game_switches[DomiActSw]
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'ID della magnetite della dominazione
  #--------------------------------------------------------------------------
  def proper_mag(domid)
    Magnetite[domid]
  end
end #esperconfig

#===============================================================================
# ** schermata dominazioni
#===============================================================================
class Scene_DomiList < Scene_MenuBase
  include EsperConfig
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_windows
    bind_windows
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    back if Input.trigger?(Input::B)
    selection if Input.trigger?(Input::C)
    @domination_list.update
    @choice.update
    @boost_window.update
    @skill_window.update
    @milky_window.update
    @boost_bar_window.update
    set_window_visibility if @choice.changed?
  end
  #--------------------------------------------------------------------------
  # * Comando torna indietro
  #--------------------------------------------------------------------------
  def back
    Sound.play_cancel
    if @domination_list.active
      $scene = Scene_Menu.new(@index)
    elsif @choice.active
      @choice.active = false
      @choice.index = -1
      @domination_list.active = true
      @domination_list.index = @last_index
    elsif @skill_window.active
      @skill_window.active = false
      @choice.active = true
    elsif @boost_window.active
      @boost_window.active = false
      @choice.active = true
      @boost_bar_window.close#.visible = false
    elsif @milky_window.active
      @milky_window.active = false
      @choice.active = true
    elsif @bonus_window.active
      @bonus_window.active = false
      @choice.active = true
    end
  end
  #--------------------------------------------------------------------------
  # * Comando di selezione
  #--------------------------------------------------------------------------
  def selection
    if @domination_list.active
      Sound.play_decision
      @last_index = @domination_list.index
      @domination_list.active = false
      #@domination_list.index = -1
      @choice.active = true
      @choice.index = 0
    elsif @choice.active
      Sound.play_decision
      enter_command
    elsif @boost_window.active
      @boost_window.change_state
      @domination_window.refresh
    elsif @skill_window.active
      @skill_window.change_state
    elsif @milky_window.active
      @milky_window.ok
      @domination_window.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Evento quando premuto il tasto invio
  #--------------------------------------------------------------------------
  def enter_command
    @choice.active = false
    case @choice.index
      when 0
        @boost_window.active = true
        @boost_window.index = 0
        @boost_bar_window.open#.visible = true
      when 1
        @skill_window.active = true
        @skill_window.index = 0
      when 2
        @milky_window.active = true
        @milky_window.index = 0
      when 3
        @choice.active = true
        Sound.play_buzzer
      when 4
        @choice.active = true
        Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Imposta la visibilità della finestra selezionata
  #--------------------------------------------------------------------------
  def set_window_visibility
    return if @choice.active == false
    case @choice.index
      when -1
        @boost_window.select_this
        @skill_window.unselect_this
        @milky_window.unselect_this
        @element_window.unselect_this
        @bonus_window.unselect_this
      when 0
        @boost_window.select_this
        @skill_window.unselect_this
        @milky_window.unselect_this
        @element_window.unselect_this
        @bonus_window.unselect_this
      when 1
        @boost_window.unselect_this
        @skill_window.select_this
        @milky_window.unselect_this
        @element_window.unselect_this
        @bonus_window.unselect_this
      when 2
        @boost_window.unselect_this
        @skill_window.unselect_this
        @milky_window.select_this
        @element_window.unselect_this
        @bonus_window.unselect_this
      when 3
        @boost_window.unselect_this
        @skill_window.unselect_this
        @milky_window.unselect_this
        @element_window.select_this
        @bonus_window.unselect_this
      when 4
        @boost_window.unselect_this
        @skill_window.unselect_this
        @milky_window.unselect_this
        @element_window.unselect_this
        @bonus_window.select_this
    end
  end
  #--------------------------------------------------------------------------
  # * Collega le finestre ai rispettivi comandi del menu
  #--------------------------------------------------------------------------
  def bind_windows
    @domination_window.bind(@boost_window,@skill_window,@milky_window,@element_window,@bonus_window)
  end
  #--------------------------------------------------------------------------
  # * Ottiene la lista delle dominazioni sbloccate
  #--------------------------------------------------------------------------
  def get_evocation_list
    @domi = []
    DW_Dom.each_key do |dom|
      @domi.push($game_actors[dom]) if domination_unlocked?(dom)
    end
  end
  #--------------------------------------------------------------------------
  # * Crea tutte le finestre della schermata
  #--------------------------------------------------------------------------
  def create_windows
    create_help_window
    create_domination_stats
    create_domination_list
    create_choice_list
    create_domination_skills
    create_domination_boosts
    create_domination_milks
    create_element_window
    create_bonus_window
    @domination_list.update_help
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra delle abilità della Dominazione
  #--------------------------------------------------------------------------
  def create_domination_skills
    x = @choice.width
    y = @choice.y
    w = @domination_list.x - @choice.width
    h = Graphics.height - y
    @skill_window = Window_Domination_Skill.new(x,y,w,h)
    @skill_window.unselect_this
    @skill_window.set_help(@help_window)
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra degli elementi
  #--------------------------------------------------------------------------
  def create_element_window
    x = @choice.width
    y = @choice.y
    w = @domination_list.x - @choice.width
    h = Graphics.height - y
    @element_window = Window_Dom_Elements.new(x,y,w,h)
    @element_window.unselect_this
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra dei potenziamenti
  #--------------------------------------------------------------------------
  def create_bonus_window
    x = @choice.width
    y = @choice.y
    w = @domination_list.x - @choice.width
    h = Graphics.height - y
    @bonus_window = Window_Dom_PowerUps.new(x,y,w,h)
    @bonus_window.unselect_this
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra dei turbo della Dominazione
  #--------------------------------------------------------------------------
  def create_domination_boosts
    x = @choice.width
    y = @choice.y
    w = @domination_list.x - @choice.width
    h = Graphics.height - y
    @boost_window = Window_Domination_Boosts.new(x,y,w,h)
    @boost_window.active = false
    @boost_window.index = -1
    @boost_window.set_help(@help_window)
    @boost_bar_window = Window_Boosts_Effect.new(x,y-Window_Base::WLH-32,w)
    @boost_window.set_bar(@boost_bar_window)
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra degli oggetti per la Dominazione
  #--------------------------------------------------------------------------
  def create_domination_milks
    x = @choice.width
    y = @choice.y
    w = @domination_list.x - @choice.width
    h = Graphics.height - y
    @milky_window = Window_Milk.new(x,y,w,h)
    @milky_window.unselect_this
    @milky_window.set_help(@help_window)
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra del menu di selezione
  #--------------------------------------------------------------------------
  def create_choice_list
    @choice = Window_DSelect.new(@domination_window.width/4,@help_window)
    @choice.y = @domination_window.y+@domination_window.height
    @choice.height = Graphics.height-@choice.y
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra d'aiuto
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra delle statistiche della dominazione
  #--------------------------------------------------------------------------
  def create_domination_stats
    @domination_window = Window_Dom_Stats.new(0,@help_window.height,500,248)
  end
  #--------------------------------------------------------------------------
  # * Crea la finestra della lista delle dominazioni sbloccate
  #--------------------------------------------------------------------------
  def create_domination_list
    @domination_list = ListDWindow.new(Graphics.width-@domination_window.width)
    @domination_list.set_link(@help_window,@domination_window)
    @domination_list.x = @domination_window.width
    @domination_list.y = @help_window.height
    @domination_list.height = Graphics.height - @help_window.height
  end

end #scene_domlist



#===============================================================================
# ** classe ListWindow (finestra del menu di selezione)
#===============================================================================
class ListDWindow < Window_Command
  include EsperConfig
  #--------------------------------------------------------------------------
  # * inizializzazione
  # width: larghezza della finestra
  #--------------------------------------------------------------------------
  def initialize(width)
    create_list
    super(width,@contents)
    setup
  end
  #--------------------------------------------------------------------------
  # * imposta le finestre collegate
  # helpwindow: finestra d'aiuto
  # domiwindow: finestra delle opzioni della dominazione
  #--------------------------------------------------------------------------
  def set_link(helpwindow,domwindow)
    @help_window = helpwindow
    @dom_window = domwindow
    update_help
  end
  #--------------------------------------------------------------------------
  # * creazione della lista generica
  #--------------------------------------------------------------------------
  def create_list
    @contents = []
    @objects = {}
    SW_Dom.each_key do |dom|
      next if SW_Dom[dom].nil?
      next unless domination_unlocked?(dom)
      domination = $game_actors[dom]
      next if domination.nil?
      @contents.push(domination.name)
      @objects[domination.name] = domination
    end
  end
  #--------------------------------------------------------------------------
  # * impostazione iniziale
  #--------------------------------------------------------------------------
  def setup
    self.index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * aggiornamento help
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(@contents == nil ? "" : help_text)
    update_domination
  end
  #--------------------------------------------------------------------------
  # * cammbio della dominazione nella finestra collegata
  #--------------------------------------------------------------------------
  def update_domination
    @dom_window.domination = domination
  end
  #--------------------------------------------------------------------------
  # * restituisce il testo d'aiuto dell'oggetto
  #--------------------------------------------------------------------------
  def help_text
    return Ds_Dom[domination.id]
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto
  #--------------------------------------------------------------------------
  def item
    return @contents[self.index]
  end
  #--------------------------------------------------------------------------
  # * restituisce la dominazione selezionata
  #--------------------------------------------------------------------------
  def domination
    return @objects[item]
  end
end #listwindow

#===============================================================================
# ** classe Window_Dom_Stats (finestra delle statistiche)
#===============================================================================
class Window_Dom_Stats < Window_Base
  include EsperConfig
  #--------------------------------------------------------------------------
  # * inizializzazione
  # x, y, w, h: rispettive posizioni e dimensioni
  #--------------------------------------------------------------------------
  def initialize(x,y,w,h)
    super(x,y,w,h)
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def refresh
    return if @dom.nil?
    $riserve = false
    @dom.change_level($game_party.max_level,false) if @dom.level < $game_party.max_level
    @dom.requery_skills
    $riserve = true
    @dom.recover_all
    x = 16; y = 16
    self.contents.clear
    lefts = self.contents.width - 220
    draw_actor_graphic(@dom,x+62,y+WLH+100)
    draw_actor_name(@dom,x,y)
    draw_actor_level(@dom,x+lefts,y)
    draw_actor_hpmp(@dom,x+100,y)
    draw_recharge_gauge(@dom,x+lefts,y+WLH)
    draw_parameters(@dom,x+lefts,y+WLH*3)
    #draw_actor_bonuses(@dom,x+lefts,y+WLH*3)
    ds = self.contents.height - (WLH*2)-8
    draw_proper_user(@dom,x,ds)
    draw_evocated_times(@dom,x+100,ds)
  end
  #--------------------------------------------------------------------------
  # * scrittura dei parametri
  # actor: dominazione
  # x, y: posizione del parametro
  #--------------------------------------------------------------------------
  def draw_parameters(actor,x,y)
    for i in 0..7
      draw_icon_param(actor,x+(100*(i%2)),y,i)
      y += WLH if i%2 != 0
    end
  end
  #--------------------------------------------------------------------------
  # * disegna l'icona del parametro
  # actor: eroe
  # x, y: posizione dell'icona
  #--------------------------------------------------------------------------
  def draw_icon_param(actor,x,y,i)
    param = param_infos(actor,i)
    draw_icon(param[1],x,y)
    self.contents.draw_text(x+24,y,100,WLH,param[0])
  end
  #--------------------------------------------------------------------------
  # * restituisce l'icona del parametro
  # param: tipo di parametro
  #--------------------------------------------------------------------------
  def param_icon(param)
    return unless $imported["Y6-Iconview"]
    Y6::ICON[:stats][param]
  end
  #--------------------------------------------------------------------------
  # * ottiene le informazioni del parametro
  # actor: dominazione
  # param: id del parametro
  #--------------------------------------------------------------------------
  def param_infos(actor,param)
    case param
      when 0
        value = actor.atk
        icon = param_icon(:atk)
      when 1
        value = actor.def
        icon = param_icon(:def)
      when 2
        value = actor.spi
        icon = param_icon(:spi)
      when 3
        value = actor.agi
        icon = param_icon(:agi)
      when 4
        value = actor.hit
        icon = param_icon(:hit)
      when 5
        value = actor.cri
        icon = param_icon(:cri)
      when 6
        value = actor.eva
        icon = param_icon(:eva)
      when 7
        value = actor.odds
        icon = param_icon(:odd)
    end
    return [value,icon]
  end
  #--------------------------------------------------------------------------
  # * imposta la dominazione selezionata
  #--------------------------------------------------------------------------
  def domination=(dom)
    return if @dom == dom
    @dom = dom
    @boostw.reflow_contents(dom) unless @boostw.nil?
    @skillw.reflow_contents(dom) unless @skillw.nil?
    @milkyw.recalc(dom)          unless @milkyw.nil?
    @elewind.refresh(dom)        unless @elewind.nil?
    @bonwind.refresh(dom)        unless @bonwind.nil?
    refresh
  end
  #--------------------------------------------------------------------------
  # * collega le finestre al menu in modo da attivarle al passaggio
  # boostw: finestra dei turbo
  # skillw: finestra delle abilità
  # milkyw: finestra del latte
  # elewind: finestra degli elementi
  # bonwind: finestra dei bonus
  #--------------------------------------------------------------------------
  def bind(boostw, skillw, milkyw, elewind, bonwind)
    @boostw = boostw
    @skillw = skillw
    @milkyw = milkyw
    @elewind = elewind
    @bonwind = bonwind
    @boostw.reflow_contents(@dom)
    @skillw.reflow_contents(@dom)
    @milkyw.recalc(@dom)
    @elewind.refresh(@dom)
    @bonwind.refresh(@dom)
  end
  #--------------------------------------------------------------------------
  # * disegna gli hp e mp della dominazione
  # actor: dominazione
  # x, y: posizione
  #--------------------------------------------------------------------------
  def draw_actor_hpmp(actor,x,y)
    ts = contents.text_size(Vocab::hp_a).width+7
    self.contents.font.color = system_color
    self.contents.draw_text(x,y,100,WLH,Vocab::hp_a)
    self.contents.draw_text(x,y+WLH,100,WLH,Vocab::mp_a)
    self.contents.font.color = normal_color
    self.contents.draw_text(x+ts,y,100,WLH,actor.maxhp)
    self.contents.draw_text(x+ts,y+WLH,100,WLH,actor.maxmp)
  end
  #--------------------------------------------------------------------------
  # * disegna la barra di ricarica della dominazione
  #--------------------------------------------------------------------------
  def draw_recharge_gauge(actor, x, y)
    rmax = actor.recharge_max
    rec = actor.recharge_status
    width = rec*BarL/rmax
    if rec >= rmax
      c1 = power_up_color
      c2 = power_up_color
      text = Vocab.ready_dom
    else
      c1 = mp_gauge_color1
      c2 = mp_gauge_color2
      text = sprintf(Vocab.rec_dom,rec,rmax)
    end
    self.contents.draw_text(x,y,self.width-x-16,WLH,text)
    self.contents.fill_rect(x,y+WLH,BarL,BarH,gauge_back_color)
    self.contents.gradient_fill_rect(x,y+WLH,width,BarH,c1,c2)
  end
  #--------------------------------------------------------------------------
  # * disegna l'utilizzatore attuale della dominazione
  #--------------------------------------------------------------------------
  def draw_proper_user(actor,x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x,y,100,WLH,Vocab.in_use_by)
    self.contents.font.color = normal_color
    using_actor = user(actor)
    if using_actor.nil?
      self.contents.font.color.alpha = 128
      text = Vocab.no_user
    else
      text = using_actor.name
    end
    self.contents.draw_text(x,y+WLH,100,WLH,text)
    self.contents.font.color.alpha = 255
  end
  #--------------------------------------------------------------------------
  # * restituisce l'utilizzatore
  #--------------------------------------------------------------------------
  def user(actor)
    for member in $game_party.members
      next if member.nil?
      if member.equips.include?($data_armors[proper_mag(actor.id)])
        return member
      end
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * mostra il numero di volte che è stato evocato
  #--------------------------------------------------------------------------
  def draw_evocated_times(actor,x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x,y,100,WLH,Vocab.summon_number)
    self.contents.font.color = normal_color
    text = sprintf(Vocab.summon_times,actor.summon_times)
    self.contents.draw_text(x,y+WLH,100,WLH,text)
  end
end
=begin
#===============================================================================
# ** classe Scene_Menu
#===============================================================================
class Scene_Menu < Scene_Base
  #--------------------------------------------------------------------------
  # alias create command window
  #--------------------------------------------------------------------------
  alias create_command_window_domi create_command_window unless $@
  def create_command_window
    create_command_window_domi
    return if $imported["CustomMenuCommand"]
    if EsperConfig.menu_unlocked?
      #@command_domination = @command_window.add_command(Vocab.dominations)
      if @command_window.oy > 0
        @command_window.oy -= Window_Base::WLH
      end
    end
    @command_window.index = @menu_index
  end
  #--------------------------------------------------------------------------
  # alias update command selection
  #--------------------------------------------------------------------------
  alias update_command_selection_domi update_command_selection unless $@
  def update_command_selection
    call_yerd_command = 0
    if Input.trigger?(Input::C)
      case @command_window.index
      when @command_domination
        Sound.play_decision
        $scene = Scene_DomiList.new(@command_window.index)
      end
    end
    update_command_selection_domi
  end
end # Scene Menu
=end
#===============================================================================
# ** classe Window_DSelect (finestra della selezione dei comandi)
#===============================================================================
class Window_DSelect < Window_Command
  #--------------------------------------------------------------------------
  # * inizializzazione
  # w: larghezza
  # hw: finestra d'aiuto
  #--------------------------------------------------------------------------
  def initialize(w,hw)
    @help_window = hw
    commands = [Vocab.boost,Vocab::skill,Vocab.milky,Vocab.elements,Vocab.actBonus]
    super(w,commands)
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * aggiornamento help
  #--------------------------------------------------------------------------
  def update_help
    case @index
      when 0
        text = Vocab.boost_desc
      when 1
        text = Vocab.skill_desc
      when 2
        text = Vocab.milky_desc
      when 3
        text = Vocab.element_desc
      when 4
        text = Vocab.bonus_desc
    end
    @help_window.set_text(text)
    @changed = true
  end
  #--------------------------------------------------------------------------
  # * restituisce true se la selezione è cambiata
  #--------------------------------------------------------------------------
  def changed?
    ch = @changed
    @changed = false
    return ch
  end
end #window_dselect

#===============================================================================
# ** classe Window_DominationSelection (superclasse delle varie selezioni)
#===============================================================================
class Window_DominationSelection < Window_Selectable
  include EsperConfig
  #--------------------------------------------------------------------------
  # * inizializzazione
  # x, y, w, h: inutile che lo spiego
  #--------------------------------------------------------------------------
  def initialize(x,y,w,h)
    super(x,y,w,h)
  end
  #--------------------------------------------------------------------------
  # * imposta la finestra selezionata a se stessa
  #--------------------------------------------------------------------------
  def select_this
    self.visible = true
    self.active = false
    self.index = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * deseleziona se stessa
  #--------------------------------------------------------------------------
  def unselect_this
    self.visible = false
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(item.nil? ? "" : item.description)
  end
  #--------------------------------------------------------------------------
  # * imposta la finestra d'aiuto
  # hw: nuova finestra d'aiuto
  #--------------------------------------------------------------------------
  def help_window=(hw)
    @help_window = hw
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto selezionato
  #--------------------------------------------------------------------------
  def item
    return if @item.nil?
    return @item[self.index]
  end
  #--------------------------------------------------------------------------
  # * ridondante ma non fa male, altro metodo per impostare la finestra d'aiuto
  #--------------------------------------------------------------------------
  def set_help(wh)
    @help_window = wh
  end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto nella lista
  # index: indice dell'oggetto
  # enabled: false se disattivato, true se attivato
  #--------------------------------------------------------------------------
  def draw_item(index, enabled = true)
    item = @item[index]
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    self.contents.clear_rect(rect)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    draw_icon(item.icon_index,rect.x,rect.y,enabled)
    rect.x += 24; rect.width -= 24
    self.contents.draw_text(rect, item.name)
  end
end

#===============================================================================
# ** classe Window_Domination_Skill (finestra delle abilità della Dominazione)
#===============================================================================
class Window_Domination_Skill < Window_DominationSelection
  #--------------------------------------------------------------------------
  # * riempie il contenuto della finestra
  #--------------------------------------------------------------------------
  def reflow_contents(actor)
    @index = -1
    @actor = actor
    @item_max = actor.skills.size
    create_skills_array
    refresh
    #self.index = 0
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * crea l'array delle abilità della dominazione
  #--------------------------------------------------------------------------
  def create_skills_array
    @item = []
    for skill in @actor.skills
      next if skill.name == ""
      @item.push(skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    #self.index = [[self.index, @item_max-1].min, 0].max
    create_contents
    #self.contents.clear
    for i in 0...@item_max
      draw_item(i,!@actor.skill_hidden?(skill_id(i)))
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce l'id dell'abilità
  #--------------------------------------------------------------------------
  def skill_id(index)
    return @item[index].id
  end
  #--------------------------------------------------------------------------
  # * cambia lo stato dell'attivazione dell'abilità
  #--------------------------------------------------------------------------
  def change_state
    Sound.play_decision
    return if item.nil?
    if @actor.skill_hidden?(item.id)
      @actor.remove_hidden_skill(item.id)
    else
      @actor.add_hidden_skill(item.id)
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index, enabled = true)
    return if @actor.nil?
    item = @item[index]
    super(index,enabled)
    rect = item_rect(index)
    posizione = 4
    gfont = H87_SKILL_COSTS::Spazio
    if @actor.calc_hp_cost(item) > 0
      self.contents.font.color = hp_cost_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      costo = @actor.calc_hp_cost(item)
      costo = costo.to_s+Vocab.hp_a
      self.contents.draw_text(rect, costo, 2)
      posizione += gfont*costo.size
    end
    if @actor.calc_mp_cost(item) > 0
      self.contents.font.color = mp_cost_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      costo = @actor.calc_mp_cost(item)
      costo = costo.to_s+Vocab.mp_a
      self.contents.draw_text(rect.x,rect.y,rect.width-posizione,rect.height, costo, 2)
      posizione += gfont*costo.size
    end
    if @actor.calc_var_cost(item) > 0
      self.contents.font.color = var_cost_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      costo = @actor.calc_var_cost(item)
      costo = costo.to_s+Vocab.var_skill
      self.contents.draw_text(rect.x,rect.y,rect.width-posizione,rect.height, costo, 2)
      posizione += gfont*costo.size
    end
  end
end

#===============================================================================
# ** classe Window_Domination_Boosts (finestra dei turbo)
#===============================================================================
class Window_Domination_Boosts < Window_DominationSelection
  #--------------------------------------------------------------------------
  # * riempie la finestra di contenuti
  # actor: dominazione attiva
  #--------------------------------------------------------------------------
  def reflow_contents(actor)
    return if actor.nil?
    @index = -1
    @actor = actor
    @item_max = actor.dom_boosts.size
    create_boosts_array
    refresh
  end
  #--------------------------------------------------------------------------
  # * crea l'array dei turbo disponibili
  #--------------------------------------------------------------------------
  def create_boosts_array
    @item = []
    for boost in @actor.dom_boosts
      @item.push($data_states[boost])
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    #self.index = [[self.index, @item_max-1].min, 0].max
    create_contents
    #self.contents.clear
    for i in 0...@item_max
      draw_item(i,@actor.boost_activated?(boost_id(i)))
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce l'id del turbo
  #--------------------------------------------------------------------------
  def boost_id(index)
    return @item[index].id
  end
  #--------------------------------------------------------------------------
  # * imposta la finestra della barra del turbo
  #--------------------------------------------------------------------------
  def set_bar(window)
    @bar_window = window
  end
  #--------------------------------------------------------------------------
  # * aggiorna le informazioni della finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    super
    if item != nil
      owned = !@actor.boost_activated?(item.id)
      @bar_window.refresh(@actor.domination_duration_malus,item.boost_malus,owned)
    end
  end
  #--------------------------------------------------------------------------
  # * cambia lo stato del turbo
  #--------------------------------------------------------------------------
  def change_state
    return if item.nil?
    if @actor.boost_activated?(item.id)
      @actor.deactivate_boost(item.id)
      Sound.play_equip
    else
      if item.boost_malus + @actor.domination_duration_malus - 1 > 1.75
        Sound.play_buzzer
      else
        Sound.play_equip
        @actor.activate_boost(item.id)
      end
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto della lista
  #-------------------------0-------------------------------------------------
  def draw_item(index, enabled = true)
    super(index,enabled)
    item = @item[index]
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    rect.x += 24; rect.width -= 24
    self.contents.font.color = knockout_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    malus = sprintf("-%d%",(item.boost_malus-1)*100)
    self.contents.draw_text(rect, malus,2)
  end
end

#===============================================================================
# ** classe Window_Boosts_Effect (finestra che mostra i malus dei turbo)
#===============================================================================
class Window_Boosts_Effect < Window_Base
  include EsperConfig

  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x,y,w)
    super(x,y,w,WLH+32)
    refresh(0,0,false)
    #self.visible = false
    self.openness = 0
  end

  #--------------------------------------------------------------------------
  # * aggiorna la finestra
  # value1: valore dei turbo attualmente attivi
  # value2: valore del turbo selezionato
  # active: booleano, se è attivo sottrae, se è false aggiunge
  #--------------------------------------------------------------------------
  def refresh(value1,value2,active)
    self.contents.clear
    x = 4#contents.text_size(Vocab.esper_duration).width+10
    self.contents.draw_text(4,0,contents.width-8,WLH,Vocab.esper_duration)
    barwidth = contents.width-x
    y = WLH-BarH
    self.contents.fill_rect(x,y,barwidth,BarH,Color.new(0,255,0))
    swidth = barwidth/4
    #colorr = Color.new(0,0,0,100)
    x2 = contents.width-swidth
    oc_w = calc_width(value1,barwidth)
    plusw = calc_width(value2,barwidth)
    if oc_w > 0
      self.contents.fill_rect(x,y,oc_w,BarH,Color.new(255,0,0))
    end
    if active
      if plusw > 0
        plusw = barwidth-oc_w if plusw > barwidth-oc_w
        self.contents.fill_rect(x+oc_w,y,plusw,BarH,Color.new(255,128,0))
      end
    end
    #self.contents.fill_rect(x2,y,1,BarH,colorr)
    self.contents.clear_rect(x2,y,2,BarH)
  end
  #--------------------------------------------------------------------------
  # * Calcola la larghezza
  #--------------------------------------------------------------------------
  def calc_width(value,width)
    v1 = width*value
    return v1-width
  end
end #window_boost_effect

#===============================================================================
# ** classe Window_Milk (finestra dell'elenco del latte)
#===============================================================================
class Window_Milk < Window_DominationSelection
  #--------------------------------------------------------------------------
  # * Ricalcola (non ricordo a che serve)
  #--------------------------------------------------------------------------
  def recalc(actor)
    @index = -1
    @actor = actor
    @item_max = 1
    select_item
    refresh
  end

  #--------------------------------------------------------------------------
  # * imposta l'oggetto
  #--------------------------------------------------------------------------
  def select_item
    @item = $data_items[25]
  end

  #--------------------------------------------------------------------------
  # * restituisce l'oggetto
  #--------------------------------------------------------------------------
  def item
    return @item
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.index = [[self.index, @item_max-1].min, 0].max
    create_contents
    #self.contents.clear
    for i in 0...@item_max
      draw_item(i,item_can_use?)
    end
  end

  #--------------------------------------------------------------------------
  # * disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index, enabled = true)
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    self.contents.clear_rect(rect)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    draw_icon(item.icon_index,rect.x,rect.y)
    rect.x += 24; rect.width -= 24
    self.contents.draw_text(rect, item.name)
    tn = sprintf("x%d",$game_party.item_number(item))
    self.contents.draw_text(rect,tn,2)
  end

  #--------------------------------------------------------------------------
  # * true se è possibile usarlo
  #--------------------------------------------------------------------------
  def item_can_use?
    return false if $game_party.item_number(item) == 0
    return false if recharged(actor.id) >= time_recharge(actor.id)
    return true
  end

  #--------------------------------------------------------------------------
  # * restituisce l'eroe
  #--------------------------------------------------------------------------
  def actor;@actor;end

  #--------------------------------------------------------------------------
  # * inutile dire a che serve
  #--------------------------------------------------------------------------
  def ok
    if item_can_use?
      use_item
    else
      Sound.play_buzzer
    end
  end

  #--------------------------------------------------------------------------
  # * sequenza d'utilizzo dell'oggetto
  #--------------------------------------------------------------------------
  def use_item
    RPG::SE.new("Heal7").play
    @actor.recharge_domination
    $game_party.lose_item(item,1)
    refresh
  end
end #window_milk

#===============================================================================
# ** classe Game_Actor
#===============================================================================
class Game_Actor < Game_Battler

  #--------------------------------------------------------------------------
  # * aggiunge il messaggio di nuovo turbo sbloccato per mostrarlo su mappa
  #--------------------------------------------------------------------------
  def push_message(stateid)
    state = $data_states[stateid]
    text = sprintf(Vocab.new_boost,self.name,state.name)
    $game_party.push_pop_message(text,state.icon_index)
  end
  #--------------------------------------------------------------------------
  # * restituisce i turbo sbloccati
  #--------------------------------------------------------------------------
  def dom_boosts
    #@boosts = [] if @boosts.nil?
    #return @boosts
    return $game_party.unlocked_boosts
  end
  #--------------------------------------------------------------------------
  # * aggiunge un turbo sbloccato
  #--------------------------------------------------------------------------
  def add_boost(stateid)
    #@boosts = [] if @boosts.nil?
    #@boosts.push(stateid) unless @boosts.include?(stateid)
    unless $game_party.unlocked_boosts.include?(stateid)
      $game_party.add_boost(stateid)
      push_message(stateid)
    end
  end
  #--------------------------------------------------------------------------
  # * rimuove un turbo (al momento è inutile, vuoto)
  #--------------------------------------------------------------------------
  def remove_boost(stateid)
    #@boosts = [] if @boosts.nil?
    #@boost.delete(stateid)
  end
  #--------------------------------------------------------------------------
  # * restituisce true se... vabbè, lo sai.
  #--------------------------------------------------------------------------
  def has_boost?(stateid)
    #@boosts = [] if @boosts.nil?
    return $game_party.unlocked_boosts.include?(stateid)#@boosts.include?(stateid)
  end
  #--------------------------------------------------------------------------
  # * tempo di ricarica massimo della dominazione
  #--------------------------------------------------------------------------
  def recharge_max
    @recharge_max = default_recharge if @recharge_max.nil?
    return @recharge_max
  end
  #--------------------------------------------------------------------------
  # * Tempo di ricarica predefinito
  #--------------------------------------------------------------------------
  def default_recharge
    return EsperConfig.time_recharge(self.id)
  end
  #--------------------------------------------------------------------------
  # * imposta il tempo di ricarica
  #--------------------------------------------------------------------------
  def set_recharge_max(value, dead = false)
    @recharge_max = value
    @recharge_max *= 2 if dead && !save_domination?
    @recharge_max = (@recharge_max * (1 - fast_ready_bonus)).to_i
    @charge_state = 0
  end
  #--------------------------------------------------------------------------
  # * restituisce lo stato di ricarica
  #--------------------------------------------------------------------------
  def recharge_status
    @charge_state = recharge_max if @charge_state.nil?
    return @charge_state
    #return EsperConfig.recharged(self.id)
  end
  #--------------------------------------------------------------------------
  # * restituisce lo stato di ricarica
  #--------------------------------------------------------------------------
  def charge_state
    @charge_state = recharge_max if @charge_state.nil?
    return @charge_state
    #return EsperConfig.recharged(self.id)
  end
  #--------------------------------------------------------------------------
  # * Imposta lo stato della ricarica
  #--------------------------------------------------------------------------
  def charge_state=(value)
    @charge_state = recharge_max if @charge_state.nil?
    @charge_state = value
  end
  #--------------------------------------------------------------------------
  # * Carica la dominazione di una battaglia
  #--------------------------------------------------------------------------
  def battle_add_recharge
    return if recharged?
    @charge_state = recharge_max if @charge_state.nil?
    @charge_state += 1
    if recharged?
      $game_party.push_pop_message(sprintf(Vocab.dom_ready, self.name))
    end
#~     return if $game_variables[Espers::Esper_List[self.id][0]] >= 0
#~     $game_variables[Espers::Esper_List[self.id][0]] += 1
#~     $game_party.push_pop_message(sprintf(Vocab.dom_ready, self.name))
  end
  #--------------------------------------------------------------------------
  # * restituisce true se la dominazione è pronta
  #--------------------------------------------------------------------------
  def recharged?
    return recharge_status >= recharge_max
    #return EsperConfig.time_recharge(self.id) == EsperConfig.recharge(self.id)
  end
  #--------------------------------------------------------------------------
  # * rende subito disponibile la dominazione
  #--------------------------------------------------------------------------
  def recharge_domination
    $game_variables[Espers::Esper_List[self.id][0]] = 0
  end
  #--------------------------------------------------------------------------
  # * restituisce i turbo attivati sulla dominazione
  #--------------------------------------------------------------------------
  def activated_boosts
    @act_boosts = [] if @act_boosts.nil?
    @act_boosts
  end
  #--------------------------------------------------------------------------
  # * disattiva il turbo sulla dominazione
  #--------------------------------------------------------------------------
  def deactivate_boost(stateid)
    @act_boosts = [] if @act_boosts.nil?
    @act_boosts.delete(stateid)
  end
  #--------------------------------------------------------------------------
  # * attiva il turbo alla dominazione
  #--------------------------------------------------------------------------
  def activate_boost(stateid)
    @act_boosts = [] if @act_boosts.nil?
    @act_boosts.push(stateid) unless @act_boosts.include?(stateid)
  end
  #--------------------------------------------------------------------------
  # * restituisce true se la dominazione ha Grinta
  #--------------------------------------------------------------------------
  def rech_bonus?
    return boost_activated?(266)
  end
  #--------------------------------------------------------------------------
  # * restituisce true se il turbo stateid è attivato sulla dominazione
  #--------------------------------------------------------------------------
  def boost_activated?(stateid)
    @act_boosts = [] if @act_boosts.nil?
    return @act_boosts.include?(stateid)
  end
  #--------------------------------------------------------------------------
  # * restituisce il malus causato dai turbo attivati
  #--------------------------------------------------------------------------
  def domination_duration_malus
    duration_malus = 1.0
    activated_boosts.each do |boostid|
      boost = $data_states[boostid]
      duration_malus += boost.boost_malus-1
    end
    return duration_malus
  end
  #--------------------------------------------------------------------------
  # * imposta il malus della dominazione
  #--------------------------------------------------------------------------
  def domination_duration_malus=(new_malus)
    @duration_malus = 1.0 if @duration_malus.nil?
    @duration_malus = new_malus
  end
  #--------------------------------------------------------------------------
  # * restituisce il numero di volte che è stato evocato
  #--------------------------------------------------------------------------
  def summon_times
    @summoned = 0 if @summoned.nil?
    return @summoned
  end
  #--------------------------------------------------------------------------
  # * imposta il numero di volte che è stato evocato
  #--------------------------------------------------------------------------
  def summon_times=(value)
    @summoned = 0 if @summoned.nil?
    @summoned = value
    check_boosts
  end
  #--------------------------------------------------------------------------
  # * restituisce tutti i turbo che può apprendere la dominazione
  #--------------------------------------------------------------------------
  def boosts_toLearn
    return EsperConfig::Boosts[self.id]
  end
  #--------------------------------------------------------------------------
  # * imposta i turbo che ha appreso la dominazione
  #--------------------------------------------------------------------------
  def check_boosts
    return if boosts_toLearn == nil
    self.boosts_toLearn.each_key do |boost|
      if summon_times >= boosts_toLearn[boost] and !dom_boosts.include?(boost)
        add_boost(boost)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce i bonus set attivati
  #--------------------------------------------------------------------------
  def boost_states
    bonus_states = []
    for state_id in activated_boosts
      state = $data_states[state_id]
      next if state == nil
      bonus_states.push(state)
    end
    return bonus_states
  end
  #--------------------------------------------------------------------------
  # * Ricalcola le skill apprese
  #--------------------------------------------------------------------------
  def requery_skills
    for learning in self.class.learnings
      learn_skill(learning.skill_id) if learning.level <= @level
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce i turni massimi della Dominazione
  #--------------------------------------------------------------------------
  def base_duration
    return unless domination?
    Espers::Esper_List[self.id][3]
  end
  #--------------------------------------------------------------------------
  # * Restituisce i turni massimi della Dominazione calcolando il malus
  #--------------------------------------------------------------------------
  def duration
    begin
      return ((base_duration+duration_bonus)/domination_duration_malus).to_i
    rescue
      print $!.backtrace
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce il bonus di livello della dominazione
  #--------------------------------------------------------------------------
  def duration_bonus
    return self.level*0.15
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se è una dominazione
  #--------------------------------------------------------------------------
  def domination?
    return false if Espers::Esper_List[self.id].nil?
    return Espers::Esper_List[self.id][4]
  end
end

#===============================================================================
# ** classe Game_Battler
#===============================================================================
class Game_Battler
  #--------------------------------------------------------------------------
  # * restituisce gli status attuali + bonus attivati
  #--------------------------------------------------------------------------
  alias add_boost_states states unless $@
  # @return [Array<RPG::State>]
  def states
    all_states = add_boost_states
    all_states |= self.boost_states if self.actor?
    all_states
  end
end

#===============================================================================
# ** classe RPG::State
#===============================================================================
class RPG::State
  #--------------------------------------------------------------------------
  # * restituisce il malus del turbo
  #--------------------------------------------------------------------------
  def boost_malus
    if @boost_malus.nil?
      self.note.split(/[\r\n]+/).each { |line|
        case line
          when /<(?:BOOST MALUS|boost malus):[ ]*(\d+)>/i
            @boost_malus = ($1.to_f/100)+1
        end
      }
    end
    @boost_malus
  end

  #--------------------------------------------------------------------------
  # * restituisce il testo di descrizione del turbo
  #--------------------------------------------------------------------------
  def description
    message1
  end
end #RPG::State

#===============================================================================
# ** classe Game_Party
#===============================================================================
class Game_Party < Game_Unit

  #--------------------------------------------------------------------------
  # * aggiunge il messaggio di popup da mostrare una volta uscito dalla battaglia
  #--------------------------------------------------------------------------
  def push_pop_message(text, icon_index)
    if $scene.is_a?(Scene_Map)
      show_pop_message(text,icon_index)
    else
      @pop_messages = [] if @pop_messages.nil?
      @pop_messages.push([text,icon_index])
    end
  end
  #--------------------------------------------------------------------------
  # * mostra il messaggio memorizzato del popup
  #--------------------------------------------------------------------------
  def show_pop_message(text,icon_index)
    Sound.play_load
    Popup.show(text,icon_index,[200,255,0,50])
  end
  #--------------------------------------------------------------------------
  # * controlla se ci sono messaggi memorizzati
  #--------------------------------------------------------------------------
  def check_pop_messages
    @pop_messages = [] if @pop_messages.nil?
    for message in @pop_messages
      show_pop_message(message[0],message[1])
    end
    @pop_messages.clear
  end
  #--------------------------------------------------------------------------
  # * restituisce i turbo sbloccati
  #--------------------------------------------------------------------------
  def unlocked_boosts
    @unlocked_boosts = [] if @unlocked_boosts.nil?
    @unlocked_boosts
  end
  #--------------------------------------------------------------------------
  # * aggiunge un turbo sbloccato al gruppo
  #--------------------------------------------------------------------------
  def add_boost(boost)
    @unlocked_boosts = [] if @unlocked_boosts.nil?
    @unlocked_boosts.push(boost) unless @unlocked_boosts.include?(boost)
  end
  #--------------------------------------------------------------------------
  # * Restituisce le dominazioni sbloccate
  #--------------------------------------------------------------------------
  def unlocked_dominations
    @unlocked_espers = [] if @unlocked_espers.nil?
    @unlocked_espers
  end
  #--------------------------------------------------------------------------
  # * Sblocca una dominazione
  #--------------------------------------------------------------------------
  def unlock_domination(esper_id)
    @unlocked_espers = [] if @unlocked_espers.nil?
    @unlocked_espers.push(esper_id) unless @unlocked_espers.include?(esper_id)
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se la dominazione è sbloccata
  #   esper_id: id dell'evocazione
  #--------------------------------------------------------------------------
  def domination_unlocked?(esper_id)
    self.unlocked_dominations.include?(esper_id)
  end
end #game_party

#===============================================================================
# ** classe Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  alias add_t_pop_s start unless $@
  def start
    add_t_pop_s
    $game_party.check_pop_messages
  end
end #scene_map

#===============================================================================
# ** classe Window_Dom_Elements (finestra delle resistenze elementali)
#===============================================================================
class Window_Dom_Elements < Window_DominationSelection
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x,y,w,h)
    super(x,y,w,h)
    unselect_this
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def refresh(actor = @actor)
    self.contents.clear
    @actor = actor
    create_elements
  end
  #--------------------------------------------------------------------------
  # * creazione degli elementi
  #--------------------------------------------------------------------------
  def create_elements
    y = 0
    for i in 7..16
      x = 4+((i-1)%2)*(contents.width/2)
      draw_element_config(x,y,i)
      y += WLH if i%2 == 0
    end
  end
  #--------------------------------------------------------------------------
  # * disegna l'elemento con il valore appropriato
  #--------------------------------------------------------------------------
  def draw_element_config(x,y,ele_id)
    if $imported["Y6-Iconview"]
      icon = Y6::ICON[:element_icons][ele_id]
      draw_icon(icon,x,y)
    end
    value = @actor.element_rate(ele_id) - 100
    if value == 0
      self.contents.font.color = normal_color
    elsif value < 0
      self.contents.font.color = power_up_color
    else
      self.contents.font.color = power_down_color
    end
    self.contents.draw_text(x+24,y,100,WLH,sprintf("%+d%",value))
  end
end #window_dom_elements

#===============================================================================
# ** classe Window_Dom_PowerUps (finestra dei potenziamenti della dominazione)
#===============================================================================
class Window_Dom_PowerUps < Window_DominationSelection
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x,y,w,h)
    super(x,y,w,h)
    unselect_this
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def refresh(actor = @actor)
    return if @actor == actor
    self.contents.clear
    @actor = actor
    create_elements
  end
  #--------------------------------------------------------------------------
  # * creazione degli elementi
  #--------------------------------------------------------------------------
  def create_elements
    for i in 0..4
      draw_actor_bonuses(@actor,4,WLH*i)
    end
  end
  #--------------------------------------------------------------------------
  # * disegno i bonus
  #--------------------------------------------------------------------------
  def draw_actor_bonuses(actor,x,y)
    self.contents.font.color = normal_color
    for i in 0..4
      self.contents.fill_rect(x+1,y+1+WLH*i,contents.width-2,WLH-2,Color.new(0,0,0,128))
    end
    bonuses = check_bonuses(actor)
    #print bonuses
    for i in 0..bonuses.size-1
      self.contents.draw_text(x,y+WLH*i,contents.width,WLH,bonuses[i])
    end
  end
  #--------------------------------------------------------------------------
  # * controllo dei bonus
  #--------------------------------------------------------------------------
  def check_bonuses(actor)
    bon = []
    for state in actor.states
      bon.push(BonusStates[state.id]) if BonusStates.include?(state.id)
    end
    return bon
  end
end #window_dom_powerups