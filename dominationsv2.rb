require 'rm_vx_data' if false

#===============================================================================
# ** Schermata Dominazioni
#===============================================================================
class Scene_Dominations < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_dominations_window
    create_details_window
    create_command_window
    create_boosts_window
    create_boost_effect_window
    create_skills_window
    create_milks_window
    create_elements_window
    create_powerups_window
    create_powerup_effect_window
    all_windows_invisible
  end
  #--------------------------------------------------------------------------
  # * crea la finestra delle dominazioni
  #--------------------------------------------------------------------------
  def create_dominations_window
    height = Graphics.height - @help_window.height
    @dominations_window = Window_DominationList.new(height)
    @dominations_window.x = Graphics.width - @dominations_window.width
    @dominations_window.y = @help_window.height
    @dominations_window.help_window = @help_window
    @dominations_window.activate
    @dominations_window.index = 0
    @dominations_window.activate
    @dominations_window.set_handler(:ok, method(:esper_selection))
    @dominations_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei dettagli
  #--------------------------------------------------------------------------
  def create_details_window
    @detail_window = Window_DominationInfo.new(0, @help_window.height)
    @dominations_window.set_domination_window(@detail_window)
    @detail_window.x = 0
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei comandi
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_DominationCommand.new(@help_window)
    @command_window.y = @detail_window.bottom_corner
    @command_window.set_handler(:boosts, method(:boosts_selection))
    @command_window.set_handler(:skills, method(:skill_selection))
    @command_window.set_handler(:milks, method(:milk_selection))
    @command_window.set_handler(:cancel, method(:back_selection))
    @command_window.set_handler(:empowers, method(:empower_selection))
    @command_window.set_handler(:cursor_move, method(:update_vista))
    @command_window.deactivate
    @command_window.index = -1
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei turbo
  #--------------------------------------------------------------------------
  def create_boosts_window
    rec = subwindows_position
    y = Graphics.height
    @boosts_window = Window_DominationBoosts.new(rec.x, y, rec.width, rec.height)
    @detail_window.bind(@boosts_window)
    @boosts_window.help_window = @help_window
    @boosts_window.set_handler(:ok, method(:boost_choice))
    @boosts_window.set_handler(:cancel, method(:back_to_command))
  end
  #--------------------------------------------------------------------------
  # * crea la finestra degli effetti della turbo
  #--------------------------------------------------------------------------
  def create_boost_effect_window
    x = @boosts_window.x
    width = @boosts_window.width
    @boost_window = Window_BoostsEffect.new(x, 0, width)
    @boost_window.y = @command_window.y - @boost_window.height
    @boosts_window.set_bar(@boost_window)
  end
  #--------------------------------------------------------------------------
  # * crea la finestra delle abilità
  #--------------------------------------------------------------------------
  def create_skills_window
    rec = subwindows_position
    y = Graphics.height
    @skills_window = Window_DominationSkills.new(rec.x, y, rec.width, rec.height)
    @detail_window.bind(@skills_window)
    @skills_window.help_window = @help_window
    @skills_window.set_handler(:ok, method(:skill_choice))
    @skills_window.set_handler(:cancel, method(:back_to_command))
    @sk_help_window = Window_CommandEsperHelp.new(rec.x, 0, rec.width)
    @sk_help_window.y = @command_window.y - @sk_help_window.height
  end
  #--------------------------------------------------------------------------
  # * crea la finestra del latte
  #--------------------------------------------------------------------------
  def create_milks_window
    rec = subwindows_position
    y = Graphics.height
    @milks_window = Window_DominationMilk.new(rec.x, y, rec.width, rec.height)
    @detail_window.bind(@milks_window)
    @milks_window.help_window = @help_window
    @milks_window.set_handler(:ok, method(:use_milk))
    @milks_window.set_handler(:cancel, method(:back_to_command))
  end
  #--------------------------------------------------------------------------
  # * crea la finestra elementale
  #--------------------------------------------------------------------------
  def create_elements_window
    rec = subwindows_position
    y = Graphics.height
    @elements_window = Window_DominationElements.new(rec.x, y, rec.width, rec.height)
    @detail_window.bind(@elements_window)
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei power up
  #--------------------------------------------------------------------------
  def create_powerups_window
    rec = subwindows_position
    y = Graphics.height
    @power_window = Window_DominationEmpowerments.new(rec.x, y, rec.width, rec.height)
    @detail_window.bind(@power_window)
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei PA della dominazione
  #--------------------------------------------------------------------------
  def create_powerup_effect_window
    x = @power_window.x
    width = @power_window.y
    @emp_effect_window = Window_DominationJP.new(x, 0, width)
    @emp_effect_window.y = @command_window.y - @emp_effect_window.height
  end
  #--------------------------------------------------------------------------
  # * evento di selezione dominazione (attivazione menu comandi)
  #--------------------------------------------------------------------------
  def esper_selection
    @detail_window.domination = @dominations_window.item
    @command_window.activate
    @command_window.index = 0
  end
  #--------------------------------------------------------------------------
  # * evento di selezione turbo
  #--------------------------------------------------------------------------
  def boosts_selection
    @boosts_window.activate
    @boost_window.open
    @boosts_window.index = 0
  end
  #--------------------------------------------------------------------------
  # * evento di ritorno al menu comandi
  #--------------------------------------------------------------------------
  def back_to_command
    @boost_window.close
    @sk_help_window.close
    @emp_effect_window.close
    @command_window.activate
    @boosts_window.index = -1
    @skills_window.index = -1
    @milks_window.index = -1
  end
  #--------------------------------------------------------------------------
  # * evento di selezione della finestra latte
  #--------------------------------------------------------------------------
  def milk_selection
    @milks_window.activate
    @milks_window.index = 0
  end
  #--------------------------------------------------------------------------
  # * evento di selezione della finestra skills
  #--------------------------------------------------------------------------
  def skill_selection
    @skills_window.activate
    @skills_window.index = 0
    @sk_help_window.open
  end
  #--------------------------------------------------------------------------
  # * evento di selezione della finestra potenziamenti
  #--------------------------------------------------------------------------
  def empower_selection
    @power_window.activate
    @emp_effect_window.open
  end
  #--------------------------------------------------------------------------
  # * restituisce il rettangolo delle dimensioni delle finestre a lista
  # @return [Rect]
  #--------------------------------------------------------------------------
  def subwindows_position
    x = @command_window.right_corner
    y = @command_window.y
    width = Graphics.width - x - @dominations_window.width
    height = Graphics.height - y
    Rect.new(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * usa il latte
  #--------------------------------------------------------------------------
  def use_milk
    milk = @milks_window.item
    domination = @milks_window.domination
    domination.apply_domination_recharge(milk.milk_power)
    $game_party.consume_item(milk)
    Sound.play_use_item
    @detail_window.refresh
    @milks_window.refresh
    @milks_window.activate
  end
  #--------------------------------------------------------------------------
  # * cambia stato della skill
  #--------------------------------------------------------------------------
  def skill_choice
    domination = @skills_window.domination
    domination.toggle_skill(@skills_window.item)
    @skills_window.redraw_current_item
    @skills_window.activate
  end
  #--------------------------------------------------------------------------
  # * cambia stato turbo
  #--------------------------------------------------------------------------
  def boost_choice
    domination = @boosts_window.domination
    boost = @boosts_window.item
    domination.toggle_boost(boost)
    @boosts_window.refresh
    @boosts_window.activate
    Sound.play_equip
  end
  #--------------------------------------------------------------------------
  # * potenzia il parametro della dominazione
  #--------------------------------------------------------------------------
  def empower_param
    domination = @power_window.domination
    domination.esper_up_param(@power_window.item[0])
    @power_window.redraw_current_item
    @emp_effect_window.refresh
    @detail_window.refresh
  end
  #--------------------------------------------------------------------------
  # * torna alla selezione dei comandi
  #--------------------------------------------------------------------------
  def back_selection
    @dominations_window.activate
    @command_window.deactivate
    @command_window.index = -1
  end
  #--------------------------------------------------------------------------
  # * aggiorna la vista delle finestre legate al comando
  #--------------------------------------------------------------------------
  def update_vista(jump = false)
    hide_windows unless jump
    show_selected_window
  end
  #--------------------------------------------------------------------------
  # * mostra la finestra del comando evidenziato
  #--------------------------------------------------------------------------
  def show_selected_window
    x = @command_window.right_corner
    y = subwindows_position.y
    case @command_window.current_symbol
      when :boosts
        @boosts_window.smooth_move(x, y)
      when :skills
        @skills_window.visible = true
        @skills_window.smooth_move(x, y)
      when :milks
        @milks_window.visible = true
        @milks_window.smooth_move(x, y)
      when :elements
        @elements_window.visible = true
        @elements_window.smooth_move(x, y)
      when :bonuses
        @power_window.visible = true
        @power_window.smooth_move(x, y)
      else
        @boosts_window.smooth_move(x, y)
    end
  end
  #--------------------------------------------------------------------------
  # * nascondi tutte le finestre
  #--------------------------------------------------------------------------
  def hide_windows
    x = @boosts_window.x
    y = Graphics.height
    @boosts_window.smooth_move(x, y)
    @skills_window.smooth_move(x, y)
    @milks_window.smooth_move(x, y)
    @elements_window.smooth_move(x, y)
    @power_window.smooth_move(x, y)
  end
  #--------------------------------------------------------------------------
  # * rende tutte le finestre invisibili (tranne quella dei boost)
  #--------------------------------------------------------------------------
  def all_windows_invisible
    @milks_window.visible = false
    @skills_window.visible = false
    @power_window.visible = false
    @elements_window.visible = false
  end
end

#===============================================================================
# ** classe Window_Dom_Stats (finestra delle statistiche)
#===============================================================================
class Window_DominationInfo < Window_Base
  include EsperConfig
  #--------------------------------------------------------------------------
  # * inizializzazione
  # x, y, w, h: rispettive posizioni e dimensioni
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @windows_to_update = []
    super(x, y, window_width, window_height)
    refresh
  end
  #--------------------------------------------------------------------------
  # * restituisce la larghezza della finestra
  #--------------------------------------------------------------------------
  def window_width; 500; end
  #--------------------------------------------------------------------------
  # * restituisce l'altezza della finestra
  #--------------------------------------------------------------------------
  def window_height; 248; end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def refresh
    return if domination.nil?
    @dom.recover_all
    x = 16; y = 16
    self.contents.clear
    lefts = self.contents.width - 220
    draw_actor_graphic(@dom,x+62,y+line_height+100)
    draw_actor_name(@dom,x,y)
    draw_actor_level(@dom,x+lefts,y)
    draw_actor_hpmp(@dom,x+100,y)
    draw_recharge_gauge(@dom,x+lefts,y+line_height)
    draw_parameters(@dom,x+lefts,y+line_height*3)
    ds = self.contents.height - (line_height*2)-8
    draw_proper_user(@dom,x,ds)
    draw_evocated_times(@dom,x+100,ds)
  end
  #--------------------------------------------------------------------------
  # * scrittura dei parametri
  # actor: dominazione
  # x, y: posizione del parametro
  #--------------------------------------------------------------------------
  def draw_parameters(actor,x,y)
    (0..7).each {|i|
      draw_icon_param(actor, x+(100*(i%2)), y, i)
      y += line_height if i%2 != 0
    }
  end
  #--------------------------------------------------------------------------
  # * disegna l'icona del parametro
  # actor: eroe
  # x, y: posizione dell'icona
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] i
  #--------------------------------------------------------------------------
  def draw_icon_param(actor, x, y, i)
    param = param_infos(actor,i)
    draw_icon(param[1], x, y)
    self.contents.draw_text(x + 24, y, 100, line_height, param[0])
  end
  #--------------------------------------------------------------------------
  # * restituisce l'icona del parametro
  # param: tipo di parametro
  # noinspection RubyResolve
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
      else
        value = 0
        icon = 0
    end
    [value,icon]
  end
  #--------------------------------------------------------------------------
  # * imposta la dominazione selezionata
  #--------------------------------------------------------------------------
  def domination=(dom)
    return if @dom == dom
    @dom = dom
    adjust_level
    @windows_to_update.each{|window|
      window.domination = dom
    }
    refresh
  end
  #--------------------------------------------------------------------------
  # * aggiorna il livello della dominazione
  #--------------------------------------------------------------------------
  def adjust_level
    domination.adjust_level if domination != nil
  end
  #--------------------------------------------------------------------------
  # * restituisce la dominazione
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def domination; @dom; end
  #--------------------------------------------------------------------------
  # * collega le finestre al menu in modo da attivarle al passaggio
  # @param [Window_Base] window
  #--------------------------------------------------------------------------
  def bind(window)
    @windows_to_update.push(window)
    window.domination = domination
  end
  #--------------------------------------------------------------------------
  # * disegna gli hp e mp della dominazione
  # actor: dominazione
  # x, y: posizione
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_actor_hpmp(actor, x, y)
    ts = contents.text_size(Vocab::hp_a).width+7
    change_color(system_color)
    draw_text(x, y, 100, line_height, Vocab::hp_a)
    draw_text(x, y + line_height, 100, line_height, Vocab::mp_a)
    change_color(normal_color)
    self.contents.draw_text(x + ts, y, 100, line_height, actor.maxhp)
    self.contents.draw_text(x + ts, y + line_height, 100, line_height, actor.maxmp)
  end
  #--------------------------------------------------------------------------
  # * disegna la barra di ricarica della dominazione
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
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
    draw_text(x,y,self.width-x-16,line_height,text)
    contents.fill_rect(x,y+line_height,BarL,BarH,gauge_back_color)
    contents.gradient_fill_rect(x,y+line_height,width,BarH,c1,c2)
  end
  #--------------------------------------------------------------------------
  # * disegna l'utilizzatore attuale della dominazione
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_proper_user(actor,x,y)
    self.contents.font.color = system_color
    self.contents.draw_text(x,y,100,line_height,Vocab.in_use_by)
    self.contents.font.color = normal_color
    using_actor = actor.esper_master
    if using_actor.nil?
      self.contents.font.color.alpha = 128
      text = Vocab.no_user
    else
      text = using_actor.name
    end
    self.contents.draw_text(x,y+line_height,100,line_height,text)
    self.contents.font.color.alpha = 255
  end
  #--------------------------------------------------------------------------
  # * mostra il numero di volte che è stato evocato
  # @param [Game_Actor] actor
  # @param [Integer] x
  # @param [Integer] y
  #--------------------------------------------------------------------------
  def draw_evocated_times(actor,x,y)
    change_color(system_color)
    draw_text(x,y,100,line_height,Vocab.summon_number)
    change_color(normal_color)
    text = sprintf(Vocab.summon_times,actor.summon_times)
    draw_text(x,y+line_height,100,line_height,text)
  end
end

#===============================================================================
# ** classe Window_DSelect
#===============================================================================
class Window_DominationCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Window_Help] help_w
  #--------------------------------------------------------------------------
  def initialize(help_w)
    @help_window = help_w
    super(0,0)
    self.index = -1
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Crea la lista dei comandi
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab.boost, :boosts)
    add_command(Vocab.skill, :skills)
    add_command(Vocab.milky, :milks)
    add_command(Vocab.elements, :elements)
    add_command(Vocab.act_bonus, :empowers)
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width; 160; end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la finestra d'aiuto
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
      else
        text = ''
    end
    @help_window.set_text(text)
  end
  #--------------------------------------------------------------------------
  # * Ridefinizione del metodo select per aggiornare la schermata
  #--------------------------------------------------------------------------
  def update_cursor; super; check_cursor_handler; end
end

#===============================================================================
# ** classe Window_DominationList
#===============================================================================
class Window_DominationList < Window_Selectable
  include EsperConfig
  def initialize(height)
    make_item_list
    super(0, 0, window_width, height)
    refresh
  end
  #--------------------------------------------------------------------------
  # * La lista dei parametri
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.unlocked_dominations
  end
  #--------------------------------------------------------------------------
  # * ottiene la larghezza della finestra
  #--------------------------------------------------------------------------
  def window_width; 140; end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto selezionato dal cursore
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def item(i = index)
    @data ? @data[i] : nil
  end
  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di colonne
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # * restituisce il testo d'aiuto dell'oggetto
  #--------------------------------------------------------------------------
  def help_text; Ds_Dom[item.id]; end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    esper = item(index)
    rect = item_rect(index)
    change_color(normal_color)
    draw_text(rect, esper.name)
  end
  #--------------------------------------------------------------------------
  # * Imposta la finestra di dominazione
  # @param [Window_DominationInfo] window
  #--------------------------------------------------------------------------
  def set_domination_window(window); @domination_window = window; end
  #--------------------------------------------------------------------------
  # * Aggiorna l'help
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(help_text)
    update_domination_window
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la finestra dei dettagli della dominazione
  #--------------------------------------------------------------------------
  def update_domination_window
    return if @domination_window.nil?
    @domination_window.domination = item
  end
end

#===============================================================================
# ** classe Window_DominationSkills
#===============================================================================
class Window_DominationSkills < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
    def initialize(x, y, width, height)
    super
    self.index = -1
    deactivate
  end
  #--------------------------------------------------------------------------
  # * La lista dei parametri
  #--------------------------------------------------------------------------
  def make_item_list
    @data = domination.nil? ? [] : domination.skills
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto selezionato dal cursore
  # @return [RPG::Skill]
  #--------------------------------------------------------------------------
  def item(i = index)
    @data && i >= 0 ? @data[i] : nil
  end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = item(index)
    rect = item_rect(index)
    enabled = skill_enabled?(skill)
    draw_icon(skill.icon_index, rect.x, rect.y, enabled)
    rect.x += 24; rect.width -= 24
    change_color(normal_color, enabled)
    draw_text(rect, skill.name)
    draw_skill_cost(skill, rect, enabled)
  end
  #--------------------------------------------------------------------------
  # * disegna il costo dell'abilità
  # @param [RPG::Skill] skill
  # @param [Rect] rect
  # @param [Object] enabled
  # noinspection RubyResolve
  #--------------------------------------------------------------------------
  def draw_skill_cost(skill, rect, enabled = true)
    posizione = 4
    gfont = Skill_Costs::Spazio
    if domination.calc_hp_cost(skill) > 0
      change_color(crisis_color, enabled)
      costo = domination.calc_hp_cost(skill)
      costo = costo.to_s+Vocab.hp_a
      draw_text(rect, costo, 2)
      posizione += gfont*costo.size
    end
    if domination.calc_mp_cost(skill) > 0
      change_color(mp_cost_color, enabled)
      costo = domination.calc_mp_cost(skill)
      costo = costo.to_s+Vocab.mp_a
      draw_text(rect.x,rect.y,rect.width-posizione,rect.height, costo, 2)
      posizione += gfont*costo.size
    end
    if domination.calc_var_cost(skill) > 0
      change_color(colore_var, enabled)
      costo = domination.calc_var_cost(skill)
      costo = costo.to_s+Vocab.var_skill
      draw_text(rect.x,rect.y,rect.width-posizione,rect.height, costo, 2)
      posizione += gfont*costo.size
    end
    posizione
  end
  #--------------------------------------------------------------------------
  # * restituisce la skill selezionata
  # noinspection RubyResolve
  # @param [RPG::Skill] skill
  #--------------------------------------------------------------------------
  def skill_enabled?(skill); !domination.skill_hidden?(skill.id); end
  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di colonne
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # * restituisce la dominazione
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def domination; @domination; end
  #--------------------------------------------------------------------------
  # * assegna una nuova dominazione
  # @param [Game_Actor] new_dom
  #--------------------------------------------------------------------------
  def domination=(new_dom)
    return if new_dom == @domination
    @domination = new_dom
    make_item_list
    create_contents
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    return if @help_window.nil?
    @help_window.set_text(item(@index).description)
  end
end

#===============================================================================
# ** classe Window_DominationBoosts
#===============================================================================
class Window_DominationBoosts < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.index = -1
    deactivate
  end
  #--------------------------------------------------------------------------
  # * ottiene la lista degli oggetti
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    domination.dom_boosts.each{|boost_id| @data.push($data_states[boost_id])}
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    boost = item(index)
    rect = item_rect(index)
    rect.x += 4; rect.width -= 8
    boost_active = domination.boost_activated?(boost.id)
    enabled = enable?(boost)
    boost_malus_color = crisis_color
    change_color(normal_color, enabled)
    if boost_active
      change_color(power_up_color)
      boost_malus_color = knockout_color
      bg_color = gauge_back_color
      bg_color.alpha = 50
      draw_bg_rect(rect.x, rect.y, rect.width, rect.height, bg_color)
    end
    draw_icon(boost.icon_index, rect.x, rect.y, enabled)
    rect.x += 24; rect.width -= 24
    draw_text(rect, boost.name)
    change_color(boost_malus_color, enabled)
    malus = sprintf('-%d%', (boost.boost_malus) * 100)
    draw_text(rect, malus, 2)
  end
  #--------------------------------------------------------------------------
  # *
  # @return [RPG::State]
  #--------------------------------------------------------------------------
  def item(index = self.index)
    @data ? @data[index] : nil
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
    @help_window.set_text(item ? item.message1 : '')
    if item
      owned = !domination.boost_activated?(item.id)
      malus = domination.domination_duration_malus
      @bar_window.refresh(malus, item.boost_malus + 1, owned)
    end
  end
  #--------------------------------------------------------------------------
  # * determina se il boost è utilizzabile
  # @param [RPG::State] item
  # @return [Integer]
  #--------------------------------------------------------------------------
  def enable?(item)
    return true if domination.boost_activated?(item.id)
    (item.boost_malus + domination.domination_duration_malus) <= 1.75
  end
  #--------------------------------------------------------------------------
  # * determina se si può attivare il boost
  #--------------------------------------------------------------------------
  def current_item_enabled?; enable?(@data[@index]); end
  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di colonne
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # * restituisce la dominazione
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def domination; @domination; end
  #--------------------------------------------------------------------------
  # * assegna la dominazione
  # @param [Game_Actor] new_dom
  #--------------------------------------------------------------------------
  def domination=(new_dom)
    return if new_dom == @domination
    @domination = new_dom
    make_item_list
    create_contents
    refresh
  end
end

#===============================================================================
# ** classe Window_BoostEffect
#===============================================================================
class Window_BoostsEffect < Window_Base
  include EsperConfig
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, fitting_height(1))
    refresh(0, 0, false)
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * riscrive i dati
  # @param [Integer] value1
  # @param [Integer] value2
  # @param [Object] active
  #--------------------------------------------------------------------------
  def refresh(value1, value2, active)
    contents.clear
    x = 4
    draw_text(x, 0, contents_width - 8, line_height, Vocab.esper_duration)
    barwidth = contents_width - x
    y = line_height - BarH
    contents.fill_rect(x, y, barwidth, BarH, power_up_color)
    swidth = barwidth / 4
    x2 = contents_width - swidth
    oc_w = calc_width(value1, barwidth)
    plusw = calc_width(value2, barwidth)
    contents.fill_rect(x, y, oc_w, BarH, power_down_color) if oc_w > 0
    if active and plusw > 0
      plusw = [plusw, barwidth - oc_w].min
      contents.fill_rect(x + oc_w, y, plusw, BarH, crisis_color)
    end
    contents.clear_rect(x2, y, 2, BarH)
  end
  #--------------------------------------------------------------------------
  # * ottiene la larghezza della barra
  # @param [Integer] value
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def calc_width(value, width)
    (width * value) - width
  end
end

#===============================================================================
# ** classe Window_DominationMilk
#===============================================================================
class Window_DominationMilk < Window_Selectable
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    make_item_list
    super
    deactivate
    self.index = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * crea la lista degli oggetti
  #--------------------------------------------------------------------------
  def make_item_list; @data = $game_party.milks; end
  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di colonne
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # * Restituisce la dominazione attuale
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def domination; @domination; end
  #--------------------------------------------------------------------------
  # * Imposta la dominazione
  # @param [Game_Actor] new_dom
  #--------------------------------------------------------------------------
  def domination=(new_dom)
    return if new_dom == @domination
    @domination = new_dom
    make_item_list
    create_contents
    refresh
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto
  # @return [RPG::Item]
  #--------------------------------------------------------------------------
  def item(index = self.index)
    @data[index]
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto nella riga
  # @param [Integer] index l'indice
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = item(index)
    rect = item_rect(index)
    enabled = enable?(item)
    draw_item_name(item, rect.x, rect.y, enabled)
    draw_item_number(item, rect)
  end
  #--------------------------------------------------------------------------
  # * Disegna il numero degli oggetti posseduti
  # @param [RPG::Item] item
  # @param [Rect] rect
  #--------------------------------------------------------------------------
  def draw_item_number(item, rect)
    text = sprintf('x%d', $game_party.item_number(item))
    draw_text(rect, text, 2)
  end
  #--------------------------------------------------------------------------
  # * true se è possibile usare l'oggetto
  # @param [RPG::Item] item
  #--------------------------------------------------------------------------
  def enable?(item)
    return false unless domination
    $game_party.item_number(item) > 0 and !domination.recharged?
  end
  #--------------------------------------------------------------------------
  # * true se è possibile usarlo
  #--------------------------------------------------------------------------
  def item_can_use?
    $game_party.item_number(item) > 0 and !domination.recharged?
  end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    return if @help_window.nil?
    @help_window.set_item(item)
  end
end

#===============================================================================
# ** Window_CommandEsperHelp (mostra aiuto skill)
#===============================================================================
class Window_CommandEsperHelp < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, fitting_height(1))
    refresh
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_key_icon(:C, 0, 0)
    draw_text(26, 0, contents_width - 26, line_height, Vocab.activate_skill)
  end
end

#===============================================================================
# ** classe Window_DominationElements (finestra delle resistenze elementali)
#===============================================================================
class Window_DominationElements < Window_Base
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if domination.nil?
    create_elements
  end
  #--------------------------------------------------------------------------
  # * creazione degli elementi
  #--------------------------------------------------------------------------
  def create_elements
    y = 0
    (7..16).each {|i|
      x = 4 + ((i - 1) % 2) * (contents_width / 2)
      draw_element_config(x, y, i)
      y += line_height if i % 2 == 0
    }
  end
  #--------------------------------------------------------------------------
  # * disegna l'elemento con il valore appropriato
  #--------------------------------------------------------------------------
  def draw_element_config(x, y, ele_id)
    width = contents_width / 2
    if $imported["Y6-Iconview"]
      # noinspection RubyResolve
      icon = Y6::ICON[:element_icons][ele_id]
      draw_icon(icon,x,y)
    end
    value = domination.element_rate(ele_id) - 100
    if value == 0
      change_color(normal_color)
    elsif value < 0
      change_color(power_up_color)
    else
      change_color(power_down_color)
    end
    draw_text(x + 24, y, width, line_height,sprintf('%+d%',value))
  end
  #--------------------------------------------------------------------------
  # * Restituisce la dominazione
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def domination; @domination; end
  #--------------------------------------------------------------------------
  # * Imposta la dominazione
  # @param [Game_Actor] new_dom
  #--------------------------------------------------------------------------
  def domination=(new_dom)
    return if new_dom == @domination
    @domination = new_dom
    refresh
  end
end

class Window_DominationEmpowerments < Window_Selectable
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    make_item_list
    super
    deactivate
    self.index = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * crea la lista degli oggetti
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    domination.esper_ups.each_pair { pair
      @data.push(pair)
    }
  end
  #--------------------------------------------------------------------------
  # * Restituisce il numero massimo di colonne
  # @return [Integer]
  #--------------------------------------------------------------------------
  def col_max; 1; end
  #--------------------------------------------------------------------------
  # * Restituisce la dominazione attuale
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def domination; @domination; end
  #--------------------------------------------------------------------------
  # * Imposta la dominazione
  # @param [Game_Actor] new_dom
  #--------------------------------------------------------------------------
  def domination=(new_dom)
    return if new_dom == @domination
    @domination = new_dom
    make_item_list
    create_contents
    refresh
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto come array [simbolo, valore]
  # @return [Array]
  #--------------------------------------------------------------------------
  def item(index = self.index)
    @data[index]
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Disegna l'oggetto nella riga
  # @param [Integer] index l'indice
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = item(index)
    rect = item_rect(index)
    enabled = enable?(item)
    draw_item_name(item, rect.x, rect.y, enabled)
    draw_item_cost(item, rect, enabled)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled)
    change_color(normal_color, enabled)
    param_name = Vocab.status_param(item[0])
    param_incr = Espers::ESPER_UPS_INCREMENTS[item[0]]
    text = sprintf('%s + %d', param_name, param_incr)
    draw_text(x, y, contents_width - x, line_height, text)
  end
  #--------------------------------------------------------------------------
  # *
  # @param [Array] item
  # @param [Rect] rect
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def draw_item_cost(item, rect, enabled)
    cost = domination.get_cost_esper_up(item[0])
    change_color(crisis_color, enabled)
    text = sprintf('%d %s', cost, Vocab.jp)
    draw_text(rect, text, 2)
  end
  #--------------------------------------------------------------------------
  # * true se è possibile usare l'oggetto
  # @param [Array] item
  #--------------------------------------------------------------------------
  def enable?(item)
    return false unless domination
    domination.esper_can_up?(item[0])
  end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra d'aiuto
  #--------------------------------------------------------------------------
  def update_help
    return if @help_window.nil?
    sym = item[0]
    increment = Espers::ESPER_UPS_INCREMENTS[sym]
    text = sprintf(Vocab.power_up_incr, Vocab.status_param(sym), increment)
    @help_window.set_text(text)
  end
end

class Window_DominationJP < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, fitting_height(1))
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * aggiorna la finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @domination.nil?
    change_color(normal_color)
    draw_text(0, 0, contents_width, line_height, Vocab.esper_jp_help)
    change_color(crisis_color)
    draw_text(0, 0, contents_width, line_height, domination.jp)
  end
  #--------------------------------------------------------------------------
  # * restituisce la dominazione
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def domination; @domination; end
  #--------------------------------------------------------------------------
  # * imposta la dominazione
  # @param [Game_Actor] new_domination
  #--------------------------------------------------------------------------
  def set_domination(new_domination)
    return if @domination == new_domination
    @domination = new_domination
    refresh
  end
end

#===============================================================================
# ** classe Window_DominationPowerUps
# @deprecated
#===============================================================================
class Window_DominationPowerUps < Window_Base
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if domination.nil?
    check_bonuses
    draw_bonuses
  end
  #--------------------------------------------------------------------------
  # * disegna i bonus
  #--------------------------------------------------------------------------
  def draw_bonuses
    (0..4).each{|i| draw_domination_bonus(i)}
  end
  #--------------------------------------------------------------------------
  # * disegna il bonus della dominazione
  #--------------------------------------------------------------------------
  def draw_domination_bonus(i)
    change_color(normal_color)
    y = i * line_height
    draw_bg_rect(0, y, contents_width, line_height)
    draw_text(0, y, contents_width, line_height, @bonuses[i].name)
  end
  #--------------------------------------------------------------------------
  # * ottiene i bonus della dominazione
  #--------------------------------------------------------------------------
  def check_bonuses
    @bonuses = domination.states.select{
        |state| EsperConfig::BonusStates.include?(state.id)
    }
  end
  #--------------------------------------------------------------------------
  # * Restituisce la dominazione
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def domination; @domination; end
  #--------------------------------------------------------------------------
  # * Imposta la dominazione
  # @param [Game_Actor] new_dom
  #--------------------------------------------------------------------------
  def domination=(new_dom)
    return if new_dom == @domination
    @domination = new_dom
    refresh
  end
end