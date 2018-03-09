$imported = {} if $imported == nil
$imported["H87_DBDetails"] = true
require 'rm_vx_data' if false
#===============================================================================
# DETTAGLI OGGETTI/ABILITÀ/EQUIP
#===============================================================================
# Autore: Holy87
# Versione: 1.0
# Difficoltà utente: ★
#-------------------------------------------------------------------------------
# Questo script mostrerà descrizioni dettagliate sull'abilità, oggetto e equip
# a fianco alla lista delle abilità dell'eroe.
#-------------------------------------------------------------------------------
# Istruzioni:
# Copiare lo script sotto Materials, prima del Main. Lo script non ha bisogno
# di ulteriori configurazioni, ma più in basso puoi modificare i testi delle
# descrizioni e l'ordine e la disattivazione di alcuni dettagli.
#
# Puoi assegnare delle descrizioni personalizzate scrivendo nelle
# note dell'abilità o dell'oggetto del database i seguenti tag:
# <attr tipo_parametro: parametro>
# ad esempio: <attr Forte contro: Insetti>
# oppure, se si vuole aggiungere un'icona alla descrizione:
# <attr tipo_parametro: parametro[id_icona]>
# oppure, se vuoi una semplice descrizione
# <tip: descrizione>
# ad esempio: <tip: Può uccidere con un colpo>
#
# Puoi nascondere la visualizzazione del danno dell'abilità scrivendo la tag
# <nascondi danno>
# Puoi nascondere del tutto le visualizzazioni automatiche di un oggetto/skill
# e visualizzare solo quelle personalizzate con
# <nessuna descrizione>
#-------------------------------------------------------------------------------
# PER CHI FA SCRIPT, ISTRUZIONI PER INTEGRARE I PROPRI A QUESTO
# ● Alias del metodo draw_script_details in Window_DetailsBase
#   inserisci i comandi per stampare dettagli aggiuntivi qui. @item richiama
#   l'oggetto attuale (può essere una skill, item o equip).
# ● Usa il metodo draw_detail per mostrare il valore automaticamente nella sua
#   riga. I parametri sono questi:
#   draw_detail(value[, descr, icon_index, color])
#   Se c'è solo value, il testo viene scritto al centro
#   Se c'è anche icon_index, viene mostrata un'icona vicino al valore
#   color può essere :special (giallo), :up (verde), :down (rosso) e :disabled
#-------------------------------------------------------------------------------
# Compatibilità:
# classe Scene_Skill      ->   alias di start
# classe Scene_Item       ->   alias di start
# classe Window_SkillList ->   alias di initialize
#                              override di col_max
#                              overload di index=()
# classe Window_ItemList  ->   alias di initialize
#                              override di col_max
#                              overload di index=()
# modulo DataManager      ->   alias di load_normal_database
#-------------------------------------------------------------------------------

#===============================================================================
# ** Impostazioni
#
# ** Vocab
#------------------------------------------------------------------------------
#  Puoi modificare i vari testi per i dettagli
#==============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Parametri extra
  #--------------------------------------------------------------------------
  HIT = "Mira:"
  EVA = "Evasione:"
  CRI = "Critici:"
  CEV = "Ev. Critici:"
  MEV = "Ev. Magica:"
  MRF = "Prob. Riflesso:"
  CNT = "Prob. Contrattacco:"
  HRG = "Rigenerazione PV:"
  MRG = "Rigenerazione PM:"
  TRG = "Recupero PT:"
  #--------------------------------------------------------------------------
  # * Parametri speciali
  #--------------------------------------------------------------------------
  TGR = "Prob. bersaglio:"
  GRD = "Prob. guardia:"
  REC = "Bonus cura:"
  PHA = "Efficacia pozioni:"
  MCR = "Costo PM:"
  TCR = "Costo PT:"
  PDR = "Danno Fisico:"
  MDR = "Danno Magico:"
  FDR = "Danno da Terreno:"
  EXR = "Esperienza:"
  #--------------------------------------------------------------------------
  # * Effetti dell'abilità o dell'oggetto utilizzabile
  #--------------------------------------------------------------------------
  SK_TARGET =     "Bersaglio:"
  SK_ELEMENT =    "Elemento:"
  SK_STATUS =     ""
  SK_NOSTAT =     "Rimuove:"
  SK_BUFF =       "Aumenta %s per %d turni"
  SK_DEBUFF =     "Riduce %s per %d turni"
  SK_REM_BUFF =   "Normalizza %s"
  SK_SPEED =      "Velocità:"
  SK_SUCCESS =    "Prob. Succ.:"
  SK_REPEAT =     "N° colpi:"
  SK_DAMAGE =     "Danno %s:"
  SK_HEAL =       "Cura %s:"
  SK_ABS  =       "Assorbe %s:"
  SK_MENU =       "Utilizzabile dal menu"
  SK_TYPE =       "Tipo:"
  SK_GUARANTED =  "Colpo sicuro"
  SK_MAGIC =      "Magia"
  SK_ATTACK =     "Fisico"
  SK_TP =         "Incremento PT:"
  SK_TG_1E =      "Un nemico"
  SK_TG_AE =      "Tutti nem."
  SK_TG_1RE =     "A caso"
  SK_TG_2RE =     "2 a caso"
  SK_TG_3RE =     "3 a caso"
  SK_TG_4RE =     "4 a caso"
  SK_TG_1A =      "Un alleato"
  SK_TG_AA =      "Party"
  SK_TG_DA =      "Alleato KO"
  SK_TG_AD =      "Alleati KO"
  SK_TG_SF =      "Se stessi"
  SK_TG_NO =      "Nessuno"
  SK_CRITICAL =   "Critici possibili"
  SK_REQUIRE =    "Richiede:"
  EF_REC =        "Cura %s:"
  SP_RUN      =   "Fuga"
  EF_GROW     =   "Incremento %s:"
  #--------------------------------------------------------------------------
  # * Info delle abilità
  #--------------------------------------------------------------------------
  SK_COST =       "Costo %s:"
  SK_REQ =        "Richiede:"
  #--------------------------------------------------------------------------
  # * Info dell'oggetto
  #--------------------------------------------------------------------------
  IT_CONSUMABLE = "Scompare dopo l'uso"
  IT_KEY        = "Oggetto importante"
  #--------------------------------------------------------------------------
  # * Attributi dell'equipaggiamento
  #--------------------------------------------------------------------------
  EQ_ELDEF =      "Difesa %s:"
  EQ_STDEF =      "Dif. Stato:"
  EQ_DEBUFF =     "Difesa debuff %s:"
  EQ_IMMUNE =     "Previene:"
  EQ_ELEMENT =    "Elem. Att.:"
  EQ_STATE =      "Stato Att.:"
  EQ_SPEED =      "Bonus vel. attacco:"
  EQ_ATK_T =      "Attacchi extra:"
  EQ_SKILL_SLOT = "Sblocca %s"
  EQ_SKILL_ADD  = "Apprendi:"
  EQ_SKILL_REM  = "Blocca:"
  EQ_STYPE_SEAL = "Blocca %s"
  EQ_EQUIP_WTYPE= "Permette l'uso di %s"
  EQ_EQUIP_ATYPE= "Permette l'uso di %s"
  EQ_EQUIP_FIX  = "Blocca il cambio di %s"
  EQ_EQUIP_SEAL = "%s non equipaggiabile"
  EQ_DUAL_WIELD = "Permette di equipaggiare due armi"
  EQ_ACTION_PLS = "Prob. azione extra:"
  EQ_AUTO		    = "Battaglia automatica"
  EQ_GUARD		  = "Super Difesa"
  EQ_SUBST		  = "Protegge gli alleati"
  EQ_PRESERVE	  = "Conserva i PT dopo la battaglia"
  EQ_PARTY_ENC	= "Incontri casuali dimezzati"
  EQ_PARTY_ENC2	= "Impedisce gli incontri casuali"
  EQ_PARTY_AMB	= "Previene le imboscate"
  EQ_PARTY_PRE	= "Cogli tutti i nemici di sorpresa"
  EQ_PARTY_GOLD	= "Raddoppia l'oro ottenuto"
  EQ_PARTY_DROP = "Raddoppia la prob. di ottenere oggetti"
  EQ_TYPE       = "Tipo:"
  WP_TYPE       = "Tipo arma:"
  AR_TYPE       = "Tipo armatura:"
  SP_AUTO     =   "Battaglia automatica"
  SP_DEF      =   "1/4 danni in difesa"
  SP_FARMACOL =   "Effetto pozioni raddoppiato"
  SP_PROT     =   "Protegge i compagni"
  SP_TP_RES   =   "Conserva i PT"
  #--------------------------------------------------------------------------
  # * Info comuni all'oggetto ed equip
  #--------------------------------------------------------------------------
  IT_SELL     =   "Prezzo vendita:"
  IT_UNSELL   =   "Non vendibile"
end #vocab

# ** Det_Config
#------------------------------------------------------------------------------
#  Configurazione della finestra dei dettagli
#==============================================================================
module Det_Config

  # PERSONALIZZAZIONE DETTAGLI
  # PUOI CAMBIARE L'ORDINE DEI DETTAGLI MOSTRATI CAMBIANDO L'ORDINE DEGLI ELEMENTI
  # QUI SOTTO. PUOI ANCHE RIMUOVERLI SE NON VUOI CHE VENGANO MOSTRATE CERTE
  # INFORMAZIONI.

  #--------------------------------------------------------------------------
  # * Info comuni ad oggetti e skill
  #--------------------------------------------------------------------------
  OBJECT_DETAILS = [
      :status,      #stato alterato (aggiunge e rimuove)
      :buff,        #buff e debuff
      :hp_recover,  #ricovero hp
      :mp_recover,  #ricovero mp
      :special,     #speciale
      :grow,        #incremento
      :learn,       #effetto
  ]
  #--------------------------------------------------------------------------
  # * Info sull'abilità
  #--------------------------------------------------------------------------
  SKILL_DETAILS = [
      :cost,        #costi
      :target,      #bersaglio
      :repeat,      #ripetizioni
      :element,     #elemento
      :success_r,   #prob. successo
      :type,        #tipo abilità
      :speed,       #velocità
      :damage,      #tipo danno
      :critical,    #possibilità di critico
      :tp_gain,     #incremento PT
      :required_w,  #arma richiesta
      :map_using,   #utilizzo su mappa
  ]
  #--------------------------------------------------------------------------
  # * Info sull'oggetto
  #--------------------------------------------------------------------------
  ITEM_DETAILS = [
      :target,      #bersaglio
      :consumable,  #si consuma?
      :key_item,    #oggetto chiave
      :repeat,      #ripetizioni
      :element,     #elemento
      :success_r,   #prob. successo
      :speed,       #velocità
      :damage,      #tipo danno
      :critical,    #possibilità di critico
      :tp_gain,     #incremento PT
      :map_using,   #utilizzo su mappa
      :sellprice,   #prezzo di vendita
  ]
  #--------------------------------------------------------------------------
  # * Info sull'equipaggiamento
  #--------------------------------------------------------------------------
  EQUIP_DETAILS = [
      :type,        #tipo (arma, scudo ec...)
      :awtype,      #tipo di arma o armatura (spada, lancia... o armatura leggera)
      :params,      #modificatori di parametri
      :sellprice,   #prezzo di vendita
      :features,    #proprietà aggiuntive
  ]

  # Larghezza della finestra delle skill
  # Decidi quanto spazio vuoi per la finestra delle skill e quella dei dettagli
  LIST_WIDTH = 300

  # Nemico su cui si basa il calcolo probabilistico del danno
  # Serve per mostrare il danno inflitto su una skill o oggetto d'attacco
  SAMPLE_ENEMY = 1 #ID del nemico

  # Se gli stati che infligge o rimuove sono maggiori del valore sottostante, lo
  # script non li mostra.
  STATE_MAX = 4

  # Imposta la grandezza del font (per far entrare più cose)
  FONT_REDUCTION = 18

end # Det_Config

#==============================================================================
# *** FINE CONFIGURAZIONE ***
# Modificare le righe in basso potrebbe compromettere il funzionamento dello
# script!
#==============================================================================



#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  Tipo arma
#==============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Tipo arma
  #--------------------------------------------------------------------------
  def self.wtype(wtype_id)
    return $data_system.weapon_types[wtype_id]
  end
  #--------------------------------------------------------------------------
  # * Tipo armatura
  #--------------------------------------------------------------------------
  def self.atype(atype_id)
    return $data_system.armor_types[atype_id]
  end
  #--------------------------------------------------------------------------
  # * Tipo elemento
  #--------------------------------------------------------------------------
  def self.eltype(element_id)
    return $data_system.elements[element_id]
  end
  #--------------------------------------------------------------------------
  # * Restituisce il nome del parametro extra
  #     param_id: id del parametro
  #--------------------------------------------------------------------------
  def self.ex_param(param_id)
    params = [HIT, EVA, CRI, CEV, MEV, MRF, CNT, HRG, MRG, TRG]
    return params[param_id]
  end
  #--------------------------------------------------------------------------
  # * Restituisce il nome del parametro speciale
  #     param_id: id del parametro
  #--------------------------------------------------------------------------
  def self.sp_param(param_id)
    params = [TGR, GRD, REC, PHA, MCR, TCR, PDR, MDR, FDR, EXR]
    return params[param_id]
  end
  #--------------------------------------------------------------------------
  # * Restituisce il nome del tipo dell'abilità
  #     stype_id: id del tipo
  #--------------------------------------------------------------------------
  def self.skill_type(stype_id)
    return $data_system.skill_types[stype_id]
  end
end #vocab 2

#==============================================================================
# ** Skill
#------------------------------------------------------------------------------
#  Aggiunge gli elementi di RPG::Skill
#==============================================================================
class RPG::BaseItem
  attr_reader :custom_dets      #dettaglio personalizzato con categoria
  attr_reader :custom_desc      #dettaglio con sola descrizione
  attr_reader :show_damage      #mostra o nascondi il danno
  attr_reader :no_description   #nasconde la descrizione automatica se true
  #--------------------------------------------------------------------------
  # * caricamento dei dettagli personalizzati
  #--------------------------------------------------------------------------
  def load_custom_details
    return if @det_loaded
    @det_loaded = true
    @no_description = false
    @custom_dets = []
    @custom_desc = []
    @show_damage = true
    self.note.split(/[\r\n]+/).each { |line|
      case line
        #---
        when /<nessuna descrizione>/i
          @no_description = true
        when /<attr[ ]+(.*):[ ](.*)\[(\d+)\]>/i
          @custom_dets.push([$1,$2,$3.to_i])
        when /<attr[ ]+(.*):[ ](.*)>/i
          @custom_dets.push([$1,$2])
        when /<tip:[ ]*(.*)>/i
          @custom_desc.push($1)
        when /<(?:NASCONDI_DANNO|nascondi danno)>/i
          @show_damage = false
      end
    }
  end
end #baseitem

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  Aggiunta del caricamento dellle descrizioni personalizzate
#==============================================================================
module DataManager
  class << self
    alias descr_norm_db load_normal_database
  end
  #--------------------------------------------------------------------------
  # * alias di load_normal_database
  #--------------------------------------------------------------------------
  def self.load_normal_database
    descr_norm_db
    load_object_description
  end
  #--------------------------------------------------------------------------
  # * carica le descrizioni personalizzate di tutte le skill
  #--------------------------------------------------------------------------
  def self.load_object_description
    for skill in $data_skills
      next if skill.nil?
      skill.load_custom_details
    end
    for item in $data_items
      next if item.nil?
      item.load_custom_details
    end
    for weapon in $data_weapons
      next if weapon.nil?
      weapon.load_custom_details
    end
    for armor in $data_armors
      next if armor.nil?
      armor.load_custom_details
    end
  end
end #datamanager

#==============================================================================
# ** Scene_Skill
#------------------------------------------------------------------------------
#  Modifica di Scene_Skill
#==============================================================================
class Scene_Skill < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * alias metodo start
  #--------------------------------------------------------------------------
  alias ski_det_start start unless $@
  def start
    ski_det_start
    create_detail_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei dettagli e la assegna alla lista delle abilità
  #--------------------------------------------------------------------------
  def create_detail_window
    x = @item_window.width
    y = @item_window.y
    w = Graphics.width - @item_window.width
    h = @item_window.height
    @window_skill_detail = Window_SkillDetails.new(x, y, w, h)
    @window_skill_detail.viewport = @viewport
    @item_window.detail_window = @window_skill_detail
  end
end #scene_skill

#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  Modifica di Scene_Item
#==============================================================================
class Scene_Item < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * alias metodo start
  #--------------------------------------------------------------------------
  alias ski_det_start start unless $@
  def start
    ski_det_start
    create_detail_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei dettagli e la assegna alla lista delle abilità
  #--------------------------------------------------------------------------
  def create_detail_window
    x = @item_window.width
    y = @item_window.y
    w = Graphics.width - @item_window.width
    h = @item_window.height
    @window_item_detail = Window_ItemDetails.new(x, y, w, h)
    @window_item_detail.viewport = @viewport
    @item_window.detail_window = @window_item_detail
  end
end #scene_skill

#==============================================================================
# ** Window_SkillList
#------------------------------------------------------------------------------
#  Modifica della lista delle abilità
#==============================================================================
class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # * alias metodo initialize
  #--------------------------------------------------------------------------
  alias dim_init_sel initialize unless $@
  def initialize (x, y, width, height)
    w = details_avaiable? ? Det_Config::LIST_WIDTH : width
    dim_init_sel(x, y, w, height)
  end
  #--------------------------------------------------------------------------
  # * sovrascrive il metodo col_max per una sola colonna
  #--------------------------------------------------------------------------
  alias det_col_max col_max unless $@
  def col_max
    return details_avaiable? ? 1 : det_col_max
  end
  #--------------------------------------------------------------------------
  # * metodo index per aggiungere l'aggiornamento della finestra dettagli
  #--------------------------------------------------------------------------
  def index=(index)
    super
    update_detail_window
  end
  #--------------------------------------------------------------------------
  # * imposta la finestra dei dettagli
  #--------------------------------------------------------------------------
  def detail_window=(detail_window)
    @detail_window = detail_window
    update_detail_window
  end
  #--------------------------------------------------------------------------
  # * aggiorna oggetto ed eroe della finestra dei dettagli
  #--------------------------------------------------------------------------
  def update_detail_window
    return if @detail_window.nil?
    return if self.item.nil?
    @detail_window.set_item(self.item, @actor)
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se si può mostrare la finestra di dettagli
  #--------------------------------------------------------------------------
  def details_avaiable?
    return !SceneManager.scene_is?(Scene_Battle)
  end
end #window_skilllist

#==============================================================================
# ** Window_SkillList
#------------------------------------------------------------------------------
#  Modifica della lista delle abilità
#==============================================================================
class Window_ItemList < Window_Selectable
  #--------------------------------------------------------------------------
  # * alias metodo initialize
  #--------------------------------------------------------------------------
  alias dim_init_sel initialize unless $@
  def initialize (x, y, width, height)
    w = details_avaiable? ? Det_Config::LIST_WIDTH : width
    dim_init_sel(x, y, w, height)
  end
  #--------------------------------------------------------------------------
  # * sovrascrive il metodo col_max per una sola colonna
  #--------------------------------------------------------------------------
  alias det_col_max col_max unless $@
  def col_max
    return details_avaiable? ? 1 : det_col_max
  end
  #--------------------------------------------------------------------------
  # * metodo index per aggiungere l'aggiornamento della finestra dettagli
  #--------------------------------------------------------------------------
  def index=(index)
    super
    update_detail_window
  end
  #--------------------------------------------------------------------------
  # * imposta la finestra dei dettagli
  #--------------------------------------------------------------------------
  def detail_window=(detail_window)
    @detail_window = detail_window
    update_detail_window
  end
  #--------------------------------------------------------------------------
  # * aggiorna oggetto ed eroe della finestra dei dettagli
  #--------------------------------------------------------------------------
  def update_detail_window
    return if @detail_window.nil?
    return if self.item.nil?
    @detail_window.set_item(self.item, @actor)
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se si può mostrare la finestra di dettagli
  #--------------------------------------------------------------------------
  def details_avaiable?
    return SceneManager.scene_is?(Scene_Item)
  end
end #window_itemlist

#==============================================================================
# ** Window_DetailBase
#------------------------------------------------------------------------------
#  Finestra base delle descrizioni che viene usata come superlcasse
#==============================================================================
class Window_DetailsBase < Window_Base
  #--------------------------------------------------------------------------
  # * Costanti (Effects)
  #--------------------------------------------------------------------------
  EFFECT_RECOVER_HP     = 11              # Ricovero HP
  EFFECT_RECOVER_MP     = 12              # Ricovero MP
  EFFECT_GAIN_TP        = 13              # Ricarica TP
  EFFECT_ADD_STATE      = 21              # Aggiunti Stato
  EFFECT_REMOVE_STATE   = 22              # Rimuovi Stato
  EFFECT_ADD_BUFF       = 31              # Aggiungi Buff
  EFFECT_ADD_DEBUFF     = 32              # Aggiungi Debuff
  EFFECT_REMOVE_BUFF    = 33              # Rimuovi Buff
  EFFECT_REMOVE_DEBUFF  = 34              # Rimuovi Debuff
  EFFECT_SPECIAL        = 41              # Effetto speciale
  EFFECT_GROW           = 42              # Incrementa parametro
  EFFECT_LEARN_SKILL    = 43              # Impara abilità
  SPECIAL_EFFECT_ESCAPE = 0               # Effetto speciale: fuga
  #--------------------------------------------------------------------------
  # * Costanti (Features)
  #--------------------------------------------------------------------------
  FEATURE_ELEMENT_RATE  = 11              # Rateo Elemento
  FEATURE_DEBUFF_RATE   = 12              # Rateo Debuff
  FEATURE_STATE_RATE    = 13              # Rateo Stato
  FEATURE_STATE_RESIST  = 14              # Immunità Stato
  FEATURE_PARAM         = 21              # Parametro
  FEATURE_XPARAM        = 22              # Parametro Extra
  FEATURE_SPARAM        = 23              # Parametro Speciale
  FEATURE_ATK_ELEMENT   = 31              # Elemento all'attacco
  FEATURE_ATK_STATE     = 32              # Stato all'attacco
  FEATURE_ATK_SPEED     = 33              # Velocità Attacco
  FEATURE_ATK_TIMES     = 34              # Numero attacchi +
  FEATURE_STYPE_ADD     = 41              # Aggiungi tipo Abilità
  FEATURE_STYPE_SEAL    = 42              # Disabilità tipo Abiltà
  FEATURE_SKILL_ADD     = 43              # Aggiungi Abilità
  FEATURE_SKILL_SEAL    = 44              # Disabilità Abilità
  FEATURE_EQUIP_WTYPE   = 51              # Equipaggia Arma
  FEATURE_EQUIP_ATYPE   = 52              # Equipaggia Armatura
  FEATURE_EQUIP_FIX     = 53              # Blocca Equip
  FEATURE_EQUIP_SEAL    = 54              # Proibisci Equip
  FEATURE_SLOT_TYPE     = 55              # Tipo Slot
  FEATURE_ACTION_PLUS   = 61              # Azioni+
  FEATURE_SPECIAL_FLAG  = 62              # Effetto speciale
  FEATURE_PARTY_ABILITY = 64              # Abilità Gruppo
  #--------------------------------------------------------------------------
  # * Costanti (Feature Flags)
  #--------------------------------------------------------------------------
  FLAG_ID_AUTO_BATTLE   = 0               # battaglia automatica
  FLAG_ID_GUARD         = 1               # super difesa
  FLAG_ID_SUBSTITUTE    = 2               # sostituto
  FLAG_ID_PRESERVE_TP   = 3               # preserva PT
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
  end
  #--------------------------------------------------------------------------
  # * aggiornamento della finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    contents.font.size = Det_Config::FONT_REDUCTION if Det_Config::FONT_REDUCTION != 0
    return if @item.nil?
    @line = 0
    write_object_data
  end
  #--------------------------------------------------------------------------
  # * Scrive i dati
  #--------------------------------------------------------------------------
  def write_object_data
    unless @item.no_description
      draw_object_effects
      draw_specific_details
      draw_features
      draw_script_details
    end
    draw_custom_details
  end
  #--------------------------------------------------------------------------
  # * Scrive dettagli per altri script (va aliasato da altri script)
  #--------------------------------------------------------------------------
  def draw_script_details
  end
  #--------------------------------------------------------------------------
  # * Scrive i dati specifici (va specificato nelle sottoclassi)
  #--------------------------------------------------------------------------
  def draw_specific_details
  end
  #--------------------------------------------------------------------------
  # * Aggiorna l'oggetto da mostrare
  #     item: oggetto
  #     actor: eroe che la possiede
  #--------------------------------------------------------------------------
  def set_item(item, actor = nil)
    @item = item
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'eroe
  #--------------------------------------------------------------------------
  def actor
    return @actor.nil? ? $game_party.members[0] : @actor
  end
  #--------------------------------------------------------------------------
  # * Disegna un'icona stretchata
  #--------------------------------------------------------------------------
  def draw_icon_stretched(icon_index, x, y, enabled = true)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    dest_rect = Rect.new(x,y,line_height,line_height)
    contents.stretch_blt(dest_rect, bitmap, rect, enabled ? 255 : translucent_alpha)
  end
  #--------------------------------------------------------------------------
  # * Modifica della line_height
  #--------------------------------------------------------------------------
  def line_height
    super if Det_Config::FONT_REDUCTION == 0
    return contents.text_size("A").height + 2
  end
  #--------------------------------------------------------------------------
  # * scrive un dettaglio nella finestra e aggiunge una riga
  #--------------------------------------------------------------------------
  def draw_detail(text, detail = nil, icon = nil, color = :default)
    y = @line * line_height
    cw = contents.width - 2
    lh = line_height
    if !detail.nil?
      change_color(system_color)
      contents.draw_text(0, y, cw, lh, detail)
      al = 2 #allineamento a destra
    else
      al = 1 #allineamento al centro
    end
    case color
      when :default
        change_color(normal_color)
      when :down
        change_color(power_down_color)
      when :up
        change_color(power_up_color)
      when :special
        change_color(crisis_color)
      when :disabled
        change_color(pending_color)
    end
    contents.draw_text(0, y, cw, lh, text.to_s.gsub(/\\[a-z]+\[[\d]+\]/i,""), al)
    if !icon.nil?
      tw = cw - (line_height + 2) - contents.text_size(text.to_s.gsub(/\\[a-z]+\[[\d]+\]/i,"")).width
      draw_icon_stretched(icon, tw, y)
    end
    @line += 1
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # * Scrittura degli effetti universali per tutti gli oggetti
  #--------------------------------------------------------------------------
  def draw_object_effects
    for i in 0..Det_Config::OBJECT_DETAILS.size-1
      draw_effects(Det_Config::OBJECT_DETAILS[i])
    end
  end
  #--------------------------------------------------------------------------
  # * Chiama il metodo desiderato
  #   effect: effetto desiderato
  #--------------------------------------------------------------------------
  def draw_effects(effect)
    return unless @item.is_a?(RPG::UsableItem)
    case effect#Det_Config::OBJECT_DETAILS[effect]
      when :status      #stato alterato (aggiunge e rimuove)
        draw_status_detail
      when :buff        #buff e debuff
        draw_buff_detail
      when :hp_recover  #ricovero hp
        draw_hp_recover_detail
      when :mp_recover  #ricovero mp
        draw_mp_recover_detail
      when :special     #speciale
        draw_special_detail
      when :grow        #incremento
        draw_grow_detail
      when :learn       #apprendimento abilità
        draw_learn_detail
    end
  end
  #--------------------------------------------------------------------------
  # * Dettagli speciali (feature) va specificato nelle sottoclassi.
  #--------------------------------------------------------------------------
  def draw_special_detail
  end
  #--------------------------------------------------------------------------
  # * mostra gli stati alterati dell'abilità
  #--------------------------------------------------------------------------
  def draw_status_detail
    return if @item.effects.size > Det_Config::STATE_MAX
    for effect in @item.effects
      if effect.code == EFFECT_ADD_STATE
        state = $data_states[effect.data_id]
        return if state.nil?
        prob = (effect.value1 * 100).to_i
        text = sprintf("%s (%d%%)", state.name, prob)
        draw_detail(text, Vocab::SK_STATUS, state.icon_index)
      elsif effect.code == EFFECT_REMOVE_STATE
        state = $data_states[effect.data_id]
        return if state.nil?
        prob = (effect.value1 * 100).to_i
        text = sprintf("%s (%d%%)", state.name, prob)
        draw_detail(text, Vocab::SK_NOSTAT, state.icon_index)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * mostra i buff e debuff dell'abilità
  #--------------------------------------------------------------------------
  def draw_buff_detail
    for effect in @item.effects
      type = effect.code
      buff = [EFFECT_ADD_BUFF, EFFECT_ADD_DEBUFF, EFFECT_REMOVE_BUFF, EFFECT_REMOVE_DEBUFF]
      if buff.include?(type)
        draw_detail(get_buff_bonus(effect))
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Mostra il ricovero PV
  #--------------------------------------------------------------------------
  def draw_hp_recover_detail
    for effect in @item.effects
      type = effect.code
      next if type != EFFECT_RECOVER_HP
      desc = sprintf(Vocab::EF_REC, Vocab.hp_a)
      text = recover_value(effect.value1, effect.value2)
      draw_detail(text, desc)
    end
  end
  #--------------------------------------------------------------------------
  # * Mostra il ricovero PM
  #--------------------------------------------------------------------------
  def draw_mp_recover_detail
    for effect in @item.effects
      type = effect.code
      next if type != EFFECT_RECOVER_MP
      desc = sprintf(Vocab::EF_REC, Vocab.mp_a)
      text = recover_value(effect.value1, effect.value2)
      draw_detail(text, desc)
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce il testo di recupero
  #--------------------------------------------------------------------------
  def recover_value(val1, val2)
    t1 = t2 = ""
    if val1 != 0
      t1 = sprintf("%d%%", val1*100)
    end
    if val2 != 0
      t2 = sprintf(" %+d", val2)
    end
    return t1+t2
  end
  #--------------------------------------------------------------------------
  # * Mostra i dettagli dell'incremento
  #--------------------------------------------------------------------------
  def draw_grow_detail
    for effect in @item.effects
      next if effect.code != EFFECT_GROW
      desc = sprintf(Vocab::EF_GROW,Vocab.param(effect.data_id))
      text = effect.value1
      draw_detail(text, desc)
    end
  end
  #--------------------------------------------------------------------------
  # * Mostra i dettagli dell'apprendimento abilità
  #--------------------------------------------------------------------------
  def draw_learn_detail
    for effect in @item.effects
      next if effect.code != EFFECT_LEARN_SKILL
      desc = Vocab::EQ_SKILL_ADD
      skill = $data_skills[effect.data_id]
      draw_detail(skill.name, desc, skill.icon_index)
    end
  end
  #--------------------------------------------------------------------------
  # * scrittura dei dettagli personalizzati
  #--------------------------------------------------------------------------
  def draw_custom_details
    @item.custom_dets.each do |det|
      if det[2].nil?
        draw_detail(det[1], det[0]+":")
      else
        draw_detail(det[1], det[0]+":", det[2])
      end
    end
    for det in @item.custom_desc
      draw_detail(det)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna le proprietà dell'oggetto
  #--------------------------------------------------------------------------
  def draw_features
    features = @item.features
    for feature in features
      draw_feature(feature)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna una proprietà specifica
  #     feature: ID proprietà
  #--------------------------------------------------------------------------
  def draw_feature(feature)
    case feature.code
      when FEATURE_ELEMENT_RATE
        draw_elem_rate(feature.data_id, feature.value)
      when FEATURE_DEBUFF_RATE
        draw_debuff_rate(feature.data_id, feature.value)
      when FEATURE_STATE_RATE
        draw_state_rate(feature.data_id, feature.value)
      when FEATURE_STATE_RESIST
        draw_state_resist(feature.data_id)
      when FEATURE_PARAM
        draw_feature_param(feature.data_id, feature.value)
      when FEATURE_XPARAM
        draw_feature_xparam(feature.data_id, feature.value)
      when FEATURE_SPARAM
        draw_feature_sparam(feature.data_id, feature.value)
      when FEATURE_ATK_ELEMENT
        draw_feature_atk_element(feature.data_id)
      when FEATURE_ATK_STATE
        draw_feature_atk_state(feature.data_id, feature.value)
      when FEATURE_ATK_SPEED
        draw_feature_atk_speed(feature.value)
      when FEATURE_ATK_TIMES
        draw_feature_atk_times(feature.value)
      when FEATURE_STYPE_ADD
        draw_feature_sk_type(feature.data_id)
      when FEATURE_STYPE_SEAL
        draw_feature_skt_seal(feature.data_id)
      when FEATURE_SKILL_ADD
        draw_feature_sk_add(feature.data_id)
      when FEATURE_SKILL_SEAL
        draw_feature_sk_seal(feature.data_id)
      when FEATURE_EQUIP_WTYPE
        draw_feature_eqt_add(feature.data_id)
      when FEATURE_EQUIP_ATYPE
        draw_feature_art_add(feature.data_id)
      when FEATURE_EQUIP_FIX
        draw_feature_eq_fix(feature.data_id)
      when FEATURE_EQUIP_SEAL
        draw_feature_eq_seal(feature.data_id)
      when FEATURE_SLOT_TYPE
        draw_feature_eq_slot_type(feature.data_id)
      when FEATURE_ACTION_PLUS
        draw_feature_action_plus(feature.value)
      when FEATURE_SPECIAL_FLAG
        draw_feature_special_flag(feature.data_id)
      when FEATURE_PARTY_ABILITY
        draw_feature_party_ability(feature.data_id)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna il bonus difesa elementale
  #     element: ID elemento
  #     value:   valore della modifica
  #--------------------------------------------------------------------------
  def draw_elem_rate(element, value)
    text = sprintf(Vocab::EQ_ELDEF, Vocab.eltype(element))
    color = value > 1.0 ? :down : :up
    rate = sprintf("%+d%%", 100-value*100)
    draw_detail(rate, text, nil, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna il modificatore della probabilità di debuff
  #     debuff: ID del debuff
  #     value:  Difesa al debuff
  #--------------------------------------------------------------------------
  def draw_debuff_rate(debuff, value)
    text = sprintf(Vocab::EQ_DEBUFF, Vocab.param(debuff))
    color = value > 1.0 ? :down : :up
    rate = sprintf("%+d%%", 100-value*100)
    draw_detail(rate, text, nil, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna il modificatore probabilità di stati alterati
  #     state_id: ID dello stato
  #     value:    Valore della modifica
  #--------------------------------------------------------------------------
  def draw_state_rate(state_id, value)
    state = $data_states[state_id]
    color = value > 1.0 ? :down : :up
    text = Vocab::EQ_STDEF
    rate = sprintf("%s %+d%%", state.name, 100-value*100)
    draw_detail(rate, text, state.icon_index, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'immunità a uno stato alterato
  #   state_id: ID dello stato
  #--------------------------------------------------------------------------
  def draw_state_resist(state_id)
    state = $data_states[state_id]
    draw_detail(state.name, Vocab::EQ_IMMUNE, state.icon_index)
  end
  #--------------------------------------------------------------------------
  # * Disegna il modificatore di un parametro normale
  #     param: ID del parametro
  #     value: valore della modifica
  #--------------------------------------------------------------------------
  def draw_feature_param(param, value)
    text = Vocab.param(param)
    color = value <= 1.0 ? :down : :up
    rate = sprintf("%+d%%", (value-1.0)*100)
    draw_detail(rate, text, nil, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna il modificatore di un parametro extra
  #     param: ID del parametro
  #     value: valore della modifica
  #--------------------------------------------------------------------------
  def draw_feature_xparam(param, value)
    return if value == 0
    text = Vocab.ex_param(param)
    color = value <= 0.0 ? :down : :up
    rate = sprintf("%+d%%", value*100)
    draw_detail(rate, text, nil, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna il modificatore di un parametro speciale
  #     param: ID del parametro
  #     value: valore della modifica
  #--------------------------------------------------------------------------
  def draw_feature_sparam(param, value)
    text = Vocab.sp_param(param)
    case param
      when 1, 2, 3, 5, 9
        color = value <= 1.0 ? :down : :up
      when 4, 6, 7, 8
        color = value > 1.0 ? :down : :up
      else
        color = :default
    end
    rate = sprintf("%+d%%", (value-1)*100)
    draw_detail(rate, text, nil, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'elemento aggiunto all'attacco
  #     element:id: ID dell'elemento
  #--------------------------------------------------------------------------
  def draw_feature_atk_element(element_id)
    draw_detail(Vocab.eltype(element_id), Vocab::EQ_ELEMENT)
  end
  #--------------------------------------------------------------------------
  # * Disegna lo stato aggiunto all'attacco
  #     state_id: ID dello stato
  #     value:    Probabilità di aggiunta
  #--------------------------------------------------------------------------
  def draw_feature_atk_state(state_id, value)
    state = $data_states[state_id]
    return if state.nil?
    text = sprintf("%s (%d%%)", state.name, value*100)
    draw_detail(text, Vocab::EQ_STATE, state.icon_index)
  end
  #--------------------------------------------------------------------------
  # * Disegna il modificatore della velocità d'attacco
  #     value:  valore della modifica
  #--------------------------------------------------------------------------
  def draw_feature_atk_speed(value)
    color = value > 0 ? :down : :up
    draw_detail(sprintf("%+d", value), Vocab::EQ_SPEED, nil, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna il modificatore del numero di attacchi
  #     value:  numero di attacchi aggiuntivi
  #--------------------------------------------------------------------------
  def draw_feature_atk_times(value)
    color = value <= 0 ? :down : :up
    draw_detail(sprintf("%+d", value), Vocab::EQ_ATK_T, nil, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo di abilità aggiunto
  #     type: tipo di abilità
  #--------------------------------------------------------------------------
  def draw_feature_sk_type(type)
    text = sprintf(Vocab::EQ_SKILL_SLOT, Vocab.skill_type(type))
    draw_detail(text, nil, nil, :special)
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo di abilità bloccato
  #     type: tipo di abilità
  #--------------------------------------------------------------------------
  def draw_feature_skt_seal(type)
    text = sprintf(Vocab::EQ_STYPE_SEAL, Vocab.skill_type(type))
    draw_detail(text, nil, nil, :down)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'abilità che aggiunge l'oggetto
  #     skill_id: ID dell'abilità
  #--------------------------------------------------------------------------
  def draw_feature_sk_add(skill_id)
    text = Vocab::EQ_SKILL_ADD
    skill = $data_skills[skill_id]
    return if skill.nil?
    draw_detail(skill.name, text, skill.icon_index)
  end
  #--------------------------------------------------------------------------
  # * Disegna l'abilità che rimuove l'oggetto
  #     skill_id: ID dell'abilità
  #--------------------------------------------------------------------------
  def draw_feature_sk_seal(skill_id)
    text = Vocab::EQ_SKILL_REM
    skill = $data_skills[skill_id]
    return if skill.nil?
    draw_detail(skill.name, text, skill.icon_index, :down)
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo di arma che l'equip può aggiungere
  #     wtype_id: ID del tipo d'arma
  #--------------------------------------------------------------------------
  def draw_feature_eqt_add(wtype_id)
    text = sprintf(Vocab::EQ_EQUIP_WTYPE, Vocab.wtype(wtype_id))
    draw_detail(text, nil, nil, :special)
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo di armatura che l'oggetto può aggiungere
  #     atype_id: ID del tipo d'armatura
  #--------------------------------------------------------------------------
  def draw_feature_art_add(atype_id)
    text = sprintf(Vocab::EQ_EQUIP_ATYPE, Vocab.atype(atype_id))
    draw_detail(text, nil, nil, :special)
  end
  #--------------------------------------------------------------------------
  # * Disegna lo slot equipaggiamento che viene blocato dall'oggetto
  #     etype_id: ID dello slot
  #--------------------------------------------------------------------------
  def draw_feature_eq_fix(etype_id)
    text = sprintf(Vocab::EQ_EQUIP_FIX, Vocab.etype(etype_id))
    draw_detail(text)
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo di equipaggiamento che viene rimosso dall'oggetto
  #     etype_id: ID dello slot
  #--------------------------------------------------------------------------
  def draw_feature_eq_seal(etype_id)
    text = sprintf(Vocab::EQ_EQUIP_SEAL, Vocab.etype(etype_id))
    draw_detail(text)
  end
  #--------------------------------------------------------------------------
  # * Disegna il modificatore di slot equip (due armi o no)
  #     st: tipo di modifica (è sempre 1)
  #--------------------------------------------------------------------------
  def draw_feature_eq_slot_type(st)
    return if st != 1
    draw_detail(Vocab::EQ_DUAL_WIELD, nil, nil, :special)
  end
  #--------------------------------------------------------------------------
  # * Disegna la probabilità di eseguire più azioni in un turno
  #     value: probabilità dell'azione extra
  #--------------------------------------------------------------------------
  def draw_feature_action_plus(value)
    text = Vocab::EQ_ACTION_PLS
    value = sprintf("%+d%%",value*100)
    draw_detail(value, text)
  end
  #--------------------------------------------------------------------------
  # * Disegna un effetto speciale dell'oggetto
  #     flag_id: ID dell'effetto speciale
  #--------------------------------------------------------------------------
  def draw_feature_special_flag(flag_id)
    case flag_id
      when FLAG_ID_AUTO_BATTLE
        draw_detail(Vocab::EQ_AUTO, nil, nil, :special)
      when FLAG_ID_GUARD
        draw_detail(Vocab::EQ_GUARD, nil, nil, :special)
      when FLAG_ID_SUBSTITUTE
        draw_detail(Vocab::EQ_SUBST, nil, nil, :special)
      when FLAG_ID_PRESERVE_TP
        draw_detail(Vocab::EQ_PRESERVE, nil, nil, :special)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna un'abilità speciale che l'oggetto conferisce al gruppo
  #     flag_id: ID dell'abilità
  #--------------------------------------------------------------------------
  def draw_feature_party_ability(flag_id)
    case flag_id
      when 0
        draw_detail(Vocab::EQ_PARTY_ENC, nil, nil, :special)
      when 1
        draw_detail(Vocab::EQ_PARTY_ENC2, nil, nil, :special)
      when 2
        draw_detail(Vocab::EQ_PARTY_AMB, nil, nil, :special)
      when 3
        draw_detail(Vocab::EQ_PARTY_ENC, nil, nil, :special)
      when 4
        draw_detail(Vocab::EQ_PARTY_PRE, nil, nil, :special)
      when 5
        draw_detail(Vocab::EQ_PARTY_GOLD, nil, nil, :special)
      when 6
        draw_detail(Vocab::EQ_PARTY_DROP, nil, nil, :special)
    end
  end
end #window_detail

#==============================================================================
# ** Window_UsableItemDetails
#------------------------------------------------------------------------------
#  Questa classe contiene la finestra unica per oggetti e abilità
#==============================================================================
class Window_UsableItemDetails < Window_DetailsBase
  #--------------------------------------------------------------------------
  # * scrive il dettaglio secondo l'ordine delle impostazioni
  #--------------------------------------------------------------------------
  def draw_item_details(detail_type)
    case detail_type
      when :target
        draw_target_detail
      when :repeat
        draw_repeat_detail
      when :element
        draw_element_detail
      when :status
        draw_status_detail
      when :success_r
        draw_success_rate_detail
      when :type        #tipo abilità
        draw_type_detail
      when :speed       #velocità
        draw_speed_detail
      when :damage
        draw_damage_detail
      when :tp_gain
        draw_tp_detail
      when :map_using
        draw_mapUsing_detail
      when :critical
        draw_critical
      when :buff
        draw_buff_detail
    end
  end
  #--------------------------------------------------------------------------
  # * disegna il tipo di obiettivo dell'abilità
  #--------------------------------------------------------------------------
  def draw_target_detail
    return if @item.scope == 0
    draw_detail(get_target, Vocab::SK_TARGET)
  end
  #--------------------------------------------------------------------------
  # * mostra i colpi multipli se superiori a 1
  #--------------------------------------------------------------------------
  def draw_repeat_detail
    return if @item.repeats <= 1
    draw_detail(@item.repeats, Vocab::SK_REPEAT)
  end
  #--------------------------------------------------------------------------
  # * mostra l'elemento dell'abilità
  #--------------------------------------------------------------------------
  def draw_element_detail
    return if @item.damage.element_id <= 0
    draw_detail(Vocab.eltype(@item.damage.element_id), Vocab::SK_ELEMENT)
  end
  #--------------------------------------------------------------------------
  # * mostra la probabilità di successo dell'abilità
  #--------------------------------------------------------------------------
  def draw_success_rate_detail
    return if @item.success_rate == 0 || @item.success_rate == 100
    draw_detail(@item.success_rate.to_s + "%", Vocab::SK_SUCCESS)
  end
  #--------------------------------------------------------------------------
  # * mostra il tipo di colpo (sicuro, fisico o magico)
  #--------------------------------------------------------------------------
  def draw_type_detail
    draw_detail(get_hit_type, Vocab::SK_TYPE)
  end
  #--------------------------------------------------------------------------
  # * mostra l'influenza dell'abilità sulla velocità
  #--------------------------------------------------------------------------
  def draw_speed_detail
    return if @item.speed == 0
    draw_detail(@item.speed, Vocab::SK_SPEED)
  end
  #--------------------------------------------------------------------------
  # * mostra una previsione del danno inflitto dall'abilità
  #--------------------------------------------------------------------------
  def draw_damage_detail
    return if @item.show_damage == false
    damage = @item.damage
    return if @item.damage.type == 0
    damage_power = get_damage_power
    return if damage_power == 0
    draw_detail(damage_power, get_damage_type)
  end
  #--------------------------------------------------------------------------
  # * mostra i tp che dona l'abilità
  #--------------------------------------------------------------------------
  def draw_tp_detail
    return if @item.tp_gain == 0
    draw_detail(@item.tp_gain, Vocab::SK_TP)
  end
  #--------------------------------------------------------------------------
  # * mostra l'informazione se può essere usata su mappa
  #--------------------------------------------------------------------------
  def draw_mapUsing_detail
    draw_detail(Vocab::SK_MENU) if @item.menu_ok?
  end
  #--------------------------------------------------------------------------
  # * mostra se l'abilità consente colpi critici
  #--------------------------------------------------------------------------
  def draw_critical
    draw_detail(Vocab::SK_CRITICAL) if @item.damage.critical
  end
  #--------------------------------------------------------------------------
  # * ottiene l'effetto dell'abilità
  #--------------------------------------------------------------------------
  def get_damage_type
    case @item.damage.type
      when 1
        sprintf(Vocab::SK_DAMAGE, Vocab::hp_a)
      when 2
        sprintf(Vocab::SK_DAMAGE, Vocab::mp_a)
      when 3
        sprintf(Vocab::SK_HEAL, Vocab::hp_a)
      when 4
        sprintf(Vocab::SK_HEAL, Vocab::mp_a)
      when 5
        sprintf(Vocab::SK_ABS, Vocab::hp_a)
      when 6
        sprintf(Vocab::SK_ABS, Vocab::mp_a)
    end
  end
  #--------------------------------------------------------------------------
  # * ottiene il tipo di buff dell'abilità come testo
  #--------------------------------------------------------------------------
  def get_buff_bonus(effect)
    case effect.code
      when EFFECT_ADD_BUFF
        type = Vocab::SK_BUFF
      when EFFECT_ADD_DEBUFF
        type = Vocab::SK_DEBUFF
      when EFFECT_REMOVE_BUFF, EFFECT_REMOVE_DEBUFF
        noturns = true
        type = Vocab::SK_REM_BUFF
    end
    param = Vocab.param(effect.data_id)
    turns = effect.value1
    return noturns ? sprintf(type, param) : sprintf(type, param, turns)
  end
  #--------------------------------------------------------------------------
  # * ottiene lo scope dell'abilità (selezione dell'obiettivo)
  #--------------------------------------------------------------------------
  def get_target
    case @item.scope
      when 1
        Vocab::SK_TG_1E
      when 2
        Vocab::SK_TG_AE
      when 3
        Vocab::SK_TG_1RE
      when 4
        Vocab::SK_TG_2RE
      when 5
        Vocab::SK_TG_3RE
      when 6
        Vocab::SK_TG_4RE
      when 7
        Vocab::SK_TG_1A
      when 8
        Vocab::SK_TG_AA
      when 9
        Vocab::SK_TG_DA
      when 10
        Vocab::SK_TG_AD
      when 11
        Vocab::SK_TG_SF
    end
  end
  #--------------------------------------------------------------------------
  # * ottiene il tipo di colpo dell'abilità
  #--------------------------------------------------------------------------
  def get_hit_type
    case @item.hit_type
      when 0
        Vocab::SK_GUARANTED
      when 1
        Vocab::SK_ATTACK
      when 2
        Vocab::SK_MAGIC
    end
  end
  #--------------------------------------------------------------------------
  # * ottiene la potenza del danno dell'abilità sperimentandola su un nemico
  #   o su se stessi se è una abilità su alleato
  #--------------------------------------------------------------------------
  def get_damage_power
    if @item.for_opponent?
      enemy = Game_Enemy.new(1, Det_Config::SAMPLE_ENEMY)
      damage = @item.damage.eval(actor.clone, enemy, $game_variables.clone)
    else
      damage = @item.damage.eval(actor.clone, actor.clone, $game_variables.clone)
    end
    damage *= -1 if damage < 0
    return damage
  end
end #usableitem

#==============================================================================
# ** Window_SkillDetails
#------------------------------------------------------------------------------
#  Questa classe contiene la finestra che mostra i dettagli dell'abilità
#==============================================================================
class Window_SkillDetails < Window_UsableItemDetails
  #--------------------------------------------------------------------------
  # * scrive i dati dell'abilità
  #--------------------------------------------------------------------------
  def draw_specific_details
    super
    for i in 0..Det_Config::SKILL_DETAILS.size-1
      draw_item_details(Det_Config::SKILL_DETAILS[i])
    end
  end
  #--------------------------------------------------------------------------
  # * scrive il dettaglio secondo l'ordine delle impostazioni
  #--------------------------------------------------------------------------
  def draw_item_details(detail_type)
    super
    case detail_type
      when :cost
        draw_cost_detail
      when :required_w
        draw_required_weapons
    end
  end
  #--------------------------------------------------------------------------
  # * disegna il costo dell'abilità
  #--------------------------------------------------------------------------
  def draw_cost_detail
    if @item.mp_cost > 0
      draw_detail(@item.mp_cost, sprintf(Vocab::SK_COST,Vocab::mp_a))
    end
    if @item.tp_cost > 0
      draw_detail(@item.tp_cost, sprintf(Vocab::SK_COST,Vocab::tp_a))
    end
  end
  #--------------------------------------------------------------------------
  # * mostra le armi richieste
  #--------------------------------------------------------------------------
  def draw_required_weapons
    draw_required_weapon(@item.required_wtype_id1)
    draw_required_weapon(@item.required_wtype_id2)
  end
  #--------------------------------------------------------------------------
  # * disegna l'arma
  #--------------------------------------------------------------------------
  def draw_required_weapon(weapon_type_id)
    return if weapon_type_id == 0
    weapon = Vocab.wtype(weapon_type_id)
    draw_detail(weapon, Vocab::SK_REQUIRE)
  end
end #vindow_skilldetail

#==============================================================================
# ** Window_ItemDetails
#------------------------------------------------------------------------------
#  Questa classe contiene la finestra che mostra i dettagli degli oggetti
#==============================================================================
class Window_ItemDetails < Window_UsableItemDetails
  #--------------------------------------------------------------------------
  # * scrive i dati dell'oggetto
  #--------------------------------------------------------------------------
  def draw_specific_details
    super
    case @item
      when RPG::Item
        details_item
      when RPG::EquipItem
        details_equip
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna i dettagli dell'oggetto
  #--------------------------------------------------------------------------
  def details_item
    for i in 0..Det_Config::ITEM_DETAILS.size-1
      draw_item_details(Det_Config::ITEM_DETAILS[i])
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna i dettagli dell'equipaggiamento
  #--------------------------------------------------------------------------
  def details_equip
    for i in 0..Det_Config::EQUIP_DETAILS.size-1
      draw_equip_details(Det_Config::EQUIP_DETAILS[i])
    end
  end
  #--------------------------------------------------------------------------
  # * scrive il dettaglio secondo l'ordine delle impostazioni
  #     detail_type: tipo del dettaglio
  #--------------------------------------------------------------------------
  def draw_item_details(detail_type)
    super
    case detail_type
      when :consumable
        draw_consumable_detail
      when :key_item
        draw_key_detail
      when :sellprice
        draw_sell_detail
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna i dettagli dell'equipaggiamento secondo l'ordine delle impost.
  #     detail_type: tipo del dettaglio
  #--------------------------------------------------------------------------
  def draw_equip_details(detail_type)
    case detail_type
      when :sellprice
        draw_sell_detail
      when :params
        draw_params_detail
      when :type
        draw_type_detail
      when :awtype
        draw_etype_detail
    end
  end
  #--------------------------------------------------------------------------
  # * scrive se consumabile
  #--------------------------------------------------------------------------
  def draw_consumable_detail
    draw_detail(Vocab::IT_CONSUMABLE) if @item.consumable
  end
  #--------------------------------------------------------------------------
  # * scrive se è un oggetto chiave
  #--------------------------------------------------------------------------
  def draw_key_detail
    draw_detail(Vocab::IT_KEY) if @item.key_item?
  end
  #--------------------------------------------------------------------------
  # * scrive il prezzo di vendita
  #--------------------------------------------------------------------------
  def draw_sell_detail
    if @item.price == 0
      text = Vocab::IT_UNSELL
      col_type = :disabled
    else
      text = item_price + Vocab.currency_unit
      col_type = :default
    end
    draw_detail(text, Vocab::IT_SELL, nil, col_type)
  end

  #--------------------------------------------------------------------------
  # * restituisce il prezzo dell'oggetto/equip
  #--------------------------------------------------------------------------
  def item_price
    return (@item.price/2).to_s
  end
  #--------------------------------------------------------------------------
  # * Disegna il parametro che viene modificato
  #--------------------------------------------------------------------------
  def draw_params_detail
    for i in 0..@item.params.size-1
      draw_param(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna il parametro
  #     param_index: ID del parametro
  #--------------------------------------------------------------------------
  def draw_param(param_index)
    param_name = Vocab.param(param_index)
    value = @item.params[param_index]
    return if value == 0
    color = value > 0 ? :up : :down
    draw_detail(sprintf("%+d",value), param_name, nil, color)
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo d'equipaggiamento secondo lo slot
  #--------------------------------------------------------------------------
  def draw_type_detail
    name = Vocab::EQ_TYPE
    type = Vocab::etype(@item.etype_id)
    draw_detail(type, name)
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo di equipaggiamento secondo la categoria
  #--------------------------------------------------------------------------
  def draw_etype_detail
    @item.is_a?(RPG::Weapon) ? draw_weapon_type : draw_armor_type
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo d'arma
  #--------------------------------------------------------------------------
  def draw_weapon_type
    name = Vocab::WP_TYPE
    value = $data_system.weapon_types[@item.wtype_id]
    draw_detail(value, name)
  end
  #--------------------------------------------------------------------------
  # * Disegna il tipo d'armatura
  #--------------------------------------------------------------------------
  def draw_armor_type
    name = Vocab::EQ_TYPE
    value = $data_system.armor_types[@item.atype_id]
    draw_detail(value, name)
  end
end #vindow_itemdetail