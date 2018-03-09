require File.expand_path('rm_vx_data')

#===============================================================================
# ** Alchemy_Settings
#-------------------------------------------------------------------------------
# impostazioni dello script dell'alchimia
#===============================================================================
module Alchemy_Settings
  #--------------------------------------------------------------------------
  # * ID dell'eroe che usa l'alchimia
  #--------------------------------------------------------------------------
  ALCHEMIST_ID = 11
  #--------------------------------------------------------------------------
  # * vocaboli
  #--------------------------------------------------------------------------
  MASTERWORK_V = 'Capolavoro'
  MATERIALS = 'Materiali richiesti'
  REQ_MP = 'Consumo PM'
  TRANSMUTATION_START = 'Trasmuta'
  TRANSMUTATION_CANCEL = 'Annulla'
  REQUIRED_MP = '%s richiesti'
  #--------------------------------------------------------------------------
  # * suoni
  #--------------------------------------------------------------------------
  TRANSMUTATION_DONE_SE = 'Item3'
  TRANSMUTATION_STRT_SE = 'Sword2'
  #--------------------------------------------------------------------------
  # * altre opzioni
  #--------------------------------------------------------------------------
  DEFAULT_M_RATE = 5 # % di probabilità l'oggetto sia un masterpiece
  # Calcolo degli MP richiesti per la fabbricazione se non è stato impostato
  # alcun costo. Se inserito 0, ha costo nullo. Con N > 0 ha costo dell'
  # oggetto / N.
  MP_DIVISOR = 6
  # Questo parametro riguarda l'animazione di trasmutazione (gli oggetti che
  # cadono). Determina ogni quanti frame fa cadere un oggetto. Tieni in
  # considerazione che se ci sono troppi oggetti, questo viene ridotto
  # proporzionalmente per non far durare troppo l'animazione.
  FREQUENCY = 30
  # se true, disattiva le animazioni di trasmutazione
  QUICK_OPERATION = false
  # se true, disegna i PM richiesti anche nella finestra dei materiali
  DRAW_MP_IN_MATS = false
  # Icona PM (se disegna PM nei materiali)
  MP_ICON = 1009
  # Animazione dell'oggetto creato con l'alchimia
  ANIM_ID = 456
  #--------------------------------------------------------------------------
  # * qui si crea la lista degli oggetti trasmutabili. Funziona in questo modo
  # - item: l'oggetto creato. Definire con tipo, id, quantità così:
  #   carattere iniziale: i = item, w = weapon, a = armor
  #   successivamente si aggiunge l'ID dell'oggetto
  #   facoltativamente, il numero di oggetti prodotti con xN. Esempio:
  #   i12x3 significa che produrrà 3 unità dell'oggetto 12
  #   w35 significa che produrrà un'arma con ID 35
  # - mats: array dei materiali richiesti. Si usa la stessa logica di item
  #   per definire i materiali. Ad esempio, i76x3 significa che ha bisogno
  #   di 3 item con ID 76.
  # - mp: facoltativo. Il costo in MP della forgiatura. Se è omesso, viene
  #   calcolato il costo di default.
  #--------------------------------------------------------------------------
  ALCHEMY_ITEMS = {
      #41 Carota, 42 Cipolla, 43 Patata, 44 Carne, 45 bulbo oculare, 46 Fungo, 47 Estratto di tossine,
      #48 Arancia, 49 Gemma dp, 50 Vernice, 51 Acqua pura, 52 Tessuto, 53 Ossa, 54 Ala di P.,
      #55 Piuma ucc, 56 Pelle Animale, 57 Essenza B, 58 Interiora Zombie,
      #59 Guscio Animale, 60 Corno Belva, 61 Acqua Cristallizzata, 62 Fuoco Solido,
      #63 Cenere El, 64 Legno, 65 Radici, 66 Betulla, 67 P. Runica, 68 Acqua S,
      #69 Sc.Drago, 70 Zolfo, 71 Indurente, 72 Quarzo, 73 Ametista, 74 Lubrificante, 75 Acciaio,
      #76 Ferro, 77 Alluminio, 78 Mithril, 79 Oliacro, 80 Resina, 81 P. Ossa,
      #82 P. Lavorata, 83 Gel elementale, 84 P. Energetica, 85 L. Mithril,
      #86 V. Purezza, 87 Nucleo, 88 Seta, 89 Antimateria, 90 polvere da sparo, 91 Vitralfrutto
      #116 bottiglia vuota, 151 Cianfrusaglie
      :potion => {:item => 'i1', :mats => %w(i57x2 i65 i116), :mp => 3},
      :h_potn => {:item => 'i2', :mats => %w(i1x2 i51 i65x2), :mp => 5},
      :x_potn => {:item => 'i3', :mats => %w(i2x4 i63x2 i51x2), :mp => 12},
      :magicw => {:item => 'i4', :mats => %w(i73x4 i45x5 i116), :mp => 8},
      :life_j => {:item => 'i5', :mats => %w(i91 i41x3 i116), :mp => 6},
      :antido => {:item => 'i6x2', :mats => %w(i47 i46), :mp => 2},
      :med_he => {:item => 'i7', :mats => %w(i65x5 i60), :mp => 7},
      :elixir => {:item => 'i8', :mats => %w(i3x2 i19 i68 i51x3), :mp => 50},
      :tonic  => {:item => 'i15',:mats => %w(i65 i42x3 i45), :mp => 5},
      :colony => {:item => 'i16',:mats => %w(i1x5 i65x5 i66), :mp => 12},
      :nectar => {:item => 'i17',:mats => %w(i8x4 i89), :mp => 150},
      :hero_d => {:item => 'i18',:mats => %w(i81 i58x2 i42x3 i60), :mp => 20},
      :ether  => {:item => 'i19',:mats => %w(i4 i73x3), :mp => 15},
      :bourbn => {:item => 'i20',:mats => %w(i44x20 i43x30 i57x10 i58x16), :mp => 100},
      :poison => {:item => 'i21',:mats => %w(i47x2 i54 i116), :mp => 9},
      :stun_g => {:item => 'i22x3',:mats => %w(i42x3 i63 i70), :mp => 8},
      :bomb   => {:item => 'i23x3',:mats => %w(i60x5 i90), :mp => 10},
      :shurik => {:item => 'i24x2',:mats => %w(i76x2 i61x2), :mp => 12},
      :milk   => {:item => 'i25',:mats => %w(i44x10 i53x15), :mp => 60},
      :picnic => {:item => 'i26',:mats => %w(i48x5 i43x8), :mp => 11},
      :speedr => {:item => 'i27',:mats => %w(i57x5 i63x2 55x3), :mp => 20},
      :magicl => {:item => 'i28',:mats => %w(i66x2 i54x3), :mp => 8},
      :smokeb => {:item => 'i30',:mats => %w(i45x2 i58x3), :mp => 8},
      :pepper => {:item => 'i37',:mats => %w(i42x8 i62x2), :mp => 7},
      :varnis => {:item => 'i50',:mats => %w(i151x3), :mp => 2},
      :textur => {:item => 'i52',:mats => %w(i151x2), :mp => 2},
      :iron   => {:item => 'i76',:mats => %w(i151x5), :mp => 4},
      :alloy  => {:item => 'i77',:mats => %w(i151x4), :mp => 4},
      :mithrl => {:item => 'i78',:mats => %w(i151x7 i49x2), :mp => 10},
      :gunpow => {:item => 'i90',:mats => %w(i70x2 i81), :mp => 9},
      :crunch => {:item => 'i109',:mats => %w(i44 i45 i41 i57), :mp => 9},
      :chryst => {:item => 'i152',:mats => %w(i151x4 i170 i73x2 i49), :mp => 35},
      :repell => {:item => 'i160', :mats => %w(i42x3 i47 i48), :mp => 13},
      # pistole
      :gun    => {:item => 'w89',:mats => %w(i76 i62), :mp => 15},
      :revolv => {:item => 'w90',:mats => %w(i77x2 i76x2), :mp => 30},
      :dandee => {:item => 'w91',:mats => %w(i76x5 i62x3), :mp => 50},
      :falcon => {:item => 'w92',:mats => %w(i75 i71 i72x3), :mp => 80},
      :rigel  => {:item => 'w93',:mats => %w(i85 i87 i89), :mp => 150},
      # proiettili
      :exp_bullet => {:item => 'i163x5', :mats => %w(i90 i62x2), :mp => 8},
      :ice_bullet => {:item => 'i164x5', :mats => %w(i90 i61x2), :mp => 8},
      :acd_bullet => {:item => 'i165x5', :mats => %w(i90 i50x2 i47), :mp => 10},
      :arm_bullet => {:item => 'i166x5', :mats => %w(i90 i60x2), :mp => 9},
      :stn_bullet => {:item => 'i167x5', :mats => %w(i90 i42x4), :mp => 8},
      :ele_bullet => {:item => 'i168x5', :mats => %w(i90 i63x2), :mp => 8},
      # oggetti craftabili
      :spilla_fat => {:item => 'a141', :mats => %w(i241 i78 i70), :mp => 180},

  }
  #--------------------------------------------------------------------------
  # * ricette alchemiche disponibili da subito
  #--------------------------------------------------------------------------
  DEFAULT_ALCHEMY_RECIPES = [:potion, :antido, :smokeb, :gun, :magicl]
  #--------------------------------------------------------------------------
  # * ricette alchemiche sbloccabili da oggetti
  #--------------------------------------------------------------------------
  ALCHEMY_BOOKS = {
      # Libri sull'alchimia
      144 => [:life_j, :med_he, :stun_g, :alloy, :poison, :textur, :revolv, :gunpow],
      145 => [:h_potn, :tonic, :colony, :bomb, :picnic, :varnis, :dandee],
      146 => [:magicw, :x_potn, :crunch, :shurik, :speedr, :iron, :falcon],
      147 => [:elixir, :milk, :hero_d, :pepper, :repell, :rigel],
      148 => [:nectar, :ether, :chryst, :bourbn, :mithrl],
      # Materiali
      241 => [:spilla_fat],
  }
  #--------------------------------------------------------------------------
  # * ricette alchemiche sbloccabili ottenendo skills
  #--------------------------------------------------------------------------
  ALCHEMY_SKILLS = {
      346 => [:exp_bullet],
      347 => [:ice_bullet],
      348 => [:acd_bullet],
      349 => [:arm_bullet],
      350 => [:stn_bullet],
      351 => [:ele_bullet],
  }
end



# ---------ATTENZIONE: MODIFICARE SOTTO QUESTO PARAGRAFO COMPORTA SERI RISCHI
#               PER IL CORRETTO FUNZIONAMENTO DELLO SCRIPT! -------------



#===============================================================================
# ** Alchemy_Core
#-------------------------------------------------------------------------------
# contiene i comandi necessari al funzionamento dell'alchimia.
#===============================================================================
module Alchemy_Core
  REGXP_PRODUCT = /([iwa])(\d+)(x(\d+))?/i
  REGXP_MATS = /([iwa])(\d+)(x(\d+))?/i
  #--------------------------------------------------------------------------
  # * prosegue con l'alchimia e restituisce il risultato
  # @param [Alchemy_Product] product
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def self.transmutate(product, number = 1)
    # Masterwork non ancora funzionante
    $game_party.gain_item(product.item, product.result_n * number)
    $game_party.alchemist.mp -= product.mp_cost * number
    product.materials.each{|material|
      $game_party.lose_item(material.item, material.quantity * number)
    }
  end
  #--------------------------------------------------------------------------
  # * prova a forgiare, restituisce true o false se la forgiatura è riuscita
  #   o meno
  # @param [Alchemy_Product] product
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def self.transmutate_safe(product, number = 1)
    if $game_party.can_transmutate?(product, number)
      forge(product, number)
      true
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * ottiene l'array dei prodoti dall'array degli hash
  # @param [Array<Hash>] items_array
  # @return [Array<Alchemy_Product>]
  #--------------------------------------------------------------------------
  def self.get_items(items_array)
    items = []
    items_array.each{|item| items.push(create_product_from_hash(item))}
    items.compact
  end
  #--------------------------------------------------------------------------
  # * ottiene l'array dei materiali dall'array degli hash
  # @param [Array<Hash>] mat_array
  # @return [Array<Forge_Material>]
  #--------------------------------------------------------------------------
  def self.get_materials(mat_array)
    materials = []
    mat_array.each{|mat| materials.push(create_mat_from_string(mat))}
    materials.compact
  end
  #--------------------------------------------------------------------------
  # * crea il prodotto della forgiatura
  # @param [symbol] item_index
  # @return [Alchemy_Product]
  #--------------------------------------------------------------------------
  def self.create_product_from_hash(item_index)
    hash = Alchemy_Settings::ALCHEMY_ITEMS[item_index]
    if hash.nil?
      puts 'Item not found for ' + item_index.to_s
      return nil
    end
    if hash[:item] =~ REGXP_PRODUCT
      item_type = item_type($1)
      item_id = $2.to_i
      result_n = $3 != nil ? $4.to_i : 1
      materials = get_materials(hash[:mats])
      mp = hash[:mp] ? hash[:mp] : nil
      return Alchemy_Product.new(item_id, item_type, materials, mp, result_n)
    else
      puts 'Incorrect item string for ' + hash[:item].to_s
      nil
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce il numero del tipo oggetto dalla stringa
  # noinspection RubyStringKeysInHashInspection
  #--------------------------------------------------------------------------
  def self.item_type(char); {'i'=>1,'w'=>2,'a'=>3}[char]; end
  #--------------------------------------------------------------------------
  # * restituisce il materiale richiesto per la forgiatura dell'oggetto
  # @param [Hash] hash
  # @return [Forge_Material]
  #--------------------------------------------------------------------------
  def self.create_mat_from_string(str)
    if str =~ REGXP_MATS
      item_type = item_type($1)
      item_id = $2.to_i
      quantity = $3 != nil ? $4.to_i : 1
      Forge_Material.new(item_id, item_type, quantity)
    else
      puts 'Incorrect mat string for ' + str.to_s
      nil
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce l'alchimista
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def self.alchemist; $game_actors[Alchemy_Settings::ALCHEMIST_ID]; end
end

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# aggiunge vocaboli comuni mostrati nella finestra dello script
#===============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * vocaboli dello script
  #--------------------------------------------------------------------------
  def self.required_alchemy_mp; Alchemy_Settings::REQ_MP; end
  def self.alchemy_start; Alchemy_Settings::TRANSMUTATION_START; end
  def self.alchemy_cancel; Alchemy_Settings::TRANSMUTATION_CANCEL; end
end

#===============================================================================
# ** Sound
#-------------------------------------------------------------------------------
# aggiunge metodi per chiamare i suoni dello script
#===============================================================================
module Sound
  #--------------------------------------------------------------------------
  # * esegue il suono di forgiatura
  #--------------------------------------------------------------------------
  def self.play_forge_item; RPG::SE.new(Forge_Settings::FORGE_SE_ITEM).play; end
  def self.play_forge_weapon; RPG::SE.new(Forge_Settings::FORGE_SE_WEAP).play; end
  def self.play_forge_armor; RPG::SE.new(Forge_Settings::FORGE_SE_ARMOR).play; end
  def self.play_forge_start; RPG::SE.new(Forge_Settings::FORGE_SE_START).play; end
end

#===============================================================================
# ** Game_Temp
#-------------------------------------------------------------------------------
# contiene le informazioni su tutti gli oggetti creabili con l'alchimia
#===============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # * genera il prodotto o lo prende dalla lista temporanea per non
  #   rigenerarlo
  # @param [Symbol] symbol
  # @return [Alchemy_Product]
  #--------------------------------------------------------------------------
    def get_alchemy_product(symbol)
    @recipes ||= {}
    @recipes[symbol] ||= Alchemy_Core.create_product_from_hash(symbol)
  end
end

#===============================================================================
# ** Game_Party
#-------------------------------------------------------------------------------
# aggiunge controllo per vedere se il gruppo può creare l'oggetto
#===============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * determina se il gruppo può forgiare l'oggetto
  # @param [Alchemy_Product] product
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def can_transmutate?(product, number = 1)
    return false if product.nil?
    return false if product.result_n * number + item_number(product.item) > max_item_number(product.item)
    gathered_materials?(product.materials, number)
  end
  #--------------------------------------------------------------------------
  # * determina se l'alchimista è presente nel gruppo
  #--------------------------------------------------------------------------
  def alchemist_present?
    all_members.include?(Alchemy_Core.alchemist)
  end
  #--------------------------------------------------------------------------
  # * restituisce l'alchimista del gruppo
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def alchemist; alchemist_present? ? Alchemy_Core.alchemist : nil; end
  #--------------------------------------------------------------------------
  # * restituisce le ricette apprese dall'alchimia
  # @return [Array<Alchemy_Product>]
  #--------------------------------------------------------------------------
  def unlocked_alchemy_recipes
    recipes = Alchemy_Settings::DEFAULT_ALCHEMY_RECIPES
    Alchemy_Settings::ALCHEMY_BOOKS.each_pair{|index, array|
      recipes += array if has_item?($data_items[index])
    }
    Alchemy_Settings::ALCHEMY_SKILLS.each_pair{|index, array|
      recipes += array if alchemist.skill_learn?($data_skills[index])
    }
    products = []
    recipes.each {|recipe| products.push($game_temp.get_alchemy_product(recipe))}
    products.compact!
    products.sort!{|a, b| a.item_id <=> b.item_id}
    products.sort!{|a, b| a.item_type <=> b.item_type}
    products
  end
end

#===============================================================================
# ** Alchemy_Product
#-------------------------------------------------------------------------------
# contiene le informazioni sull'oggetto da forgiare
#===============================================================================
class Alchemy_Product
  #--------------------------------------------------------------------------
  # * variabili di istanza pubblici
  # @attr [Fixnum] item_id
  # @attr [Fixnum] item_type
  # @attr [Fixnum] result_n
  # @attr [Array<Forge_Material>] materials
  # @attr [Fxnum] mp_cost
  # @attr [Fixnum] masterwork_r
  #--------------------------------------------------------------------------
  attr_reader :item_id      #id del prodotto
  attr_reader :item_type    #tipo del prodotto
  attr_reader :result_n     #quantità risultante
  attr_reader :mp_cost      #MP richiesti
  attr_reader :materials    #materiali richiesti
  attr_reader :masterwork_r #probabilità capolavoro
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Fixnum] item_id
  # @param [Fixnum] item_type
  # @param [Fixnum] result_n
  # @param [Array<Forge_Material>] materials
  # @param [Fixnum] mp (se nil, calcola da solo)
  # @param [Fixnum] m_rate
  #--------------------------------------------------------------------------
  def initialize(item_id, item_type, materials, mp = 0, result_n = 1, m_rate = 0)
    @item_id = item_id
    @item_type = item_type
    @result_n = result_n
    @materials = materials
    @masterwork_r = m_rate
    @mp_cost = mp ? mp : calc_mp
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto risultante
  # @return [RPG::Item]
  #--------------------------------------------------------------------------
  def item
    case @item_type
      when 1; $data_items[@item_id]
      when 2; $data_weapons[@item_id]
      when 3; $data_armors[@item_id]
      else; nil
    end
  end
  #--------------------------------------------------------------------------
  # * restituisce il divisore costo impostato
  #--------------------------------------------------------------------------
  def mp_div; Alchemy_Settings::MP_DIVISOR; end
  #--------------------------------------------------------------------------
  # * restituisce il calcolo del prezzo automatico
  #--------------------------------------------------------------------------
  def calc_mp; mp_div > 0 ? item.price / mp_div : 0; end
end

#===============================================================================
# ** Window_AlchemyList
#-------------------------------------------------------------------------------
# contiene la lista degli oggetti che possono essere create con l'alchimia.
#===============================================================================
class Window_AlchemyList < Window_Selectable
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
    refresh
    @index = 0
  end
  #--------------------------------------------------------------------------
  # * ottiene la lista degli oggetti
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.unlocked_alchemy_recipes
  end
  #--------------------------------------------------------------------------
  # * Ottiene il numero di elementi
  # @return [Integer]
  #--------------------------------------------------------------------------
  def item_max; @data ? @data.size : 0; end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto singolo alla riga
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    enabled = enable?(item)
    draw_item_name(item.item, rect.x + 32, rect.y, enabled, rect.width - 32)
    draw_item_number(item, rect)
    draw_mp_cost(item ,rect)
  end
  #--------------------------------------------------------------------------
  # * disegna il numero degli oggetti prodotti dall'alchimia
  # @param [Alchemy_Product] item
  # @param [Rect] rect
  #--------------------------------------------------------------------------
  def draw_item_number(item, rect)
    #return if item.result_n == 1
    num = sprintf('%dx', item.result_n)
    draw_text(0, rect.y, 32, rect.height, num, 2)
  end
  #--------------------------------------------------------------------------
  # * disegna il costo in PM della trasmutazione
  # @param [Alchemy_Product] item
  # @param [Rect] rect
  #--------------------------------------------------------------------------
  def draw_mp_cost(item, rect)
    change_color(mp_cost_color, enable?(item))
    draw_text(rect, sprintf('%d%s', item.mp_cost, Vocab::mp_a), 2)
  end
  #--------------------------------------------------------------------------
  # * restituisce il prodotto dell'alchimia
  # @return [Alchemy_Product]
  #--------------------------------------------------------------------------
  def item; @data[@index]; end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto nell'index è creabile
  # @param [Alchemy_Product] item
  #--------------------------------------------------------------------------
  def enable?(item)
    $game_party.can_transmutate?(item) and alchemist.mp >= item.mp_cost
  end
  #--------------------------------------------------------------------------
  # * restituisce l'alchimista del gruppo
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def alchemist; $game_party.alchemist; end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto selezionato dal cursore è cliccabile
  #--------------------------------------------------------------------------
  def current_item_enabled?; enable?(@data[@index]); end
  #--------------------------------------------------------------------------
  # * imposta la finestra dei materiali
  #--------------------------------------------------------------------------
  def mat_window=(window); @materials_window = window; end
  #--------------------------------------------------------------------------
  # * restituisce la finestra dei materiali
  # @return [Window_ForgeMaterials]
  #--------------------------------------------------------------------------
  def mat_window; @materials_window; end
  #--------------------------------------------------------------------------
  # * imposta la finestra dei dettagli oggetto
  #--------------------------------------------------------------------------
  def info_window=(window); @info_window = window; end
  #--------------------------------------------------------------------------
  # * restituisce la finestra dei dettagli oggetto
  # @return [Window_ItemInfo]
  #--------------------------------------------------------------------------
  def info_window; @info_window; end
  #--------------------------------------------------------------------------
  # * aggiorna l'aiuto al cambio di cursore
  #--------------------------------------------------------------------------
  def update_help
    super
    @help_window.set_item(item.item) if @help_window
    mat_window.set_item(item) if mat_window
    info_window.set_item(item.item) if info_window
  end
end

#===============================================================================
# ** Window_AlchemyMP
#-------------------------------------------------------------------------------
# finestra che mostra i PM dell'alchimista
#===============================================================================
class Window_AlchemyMP < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_actor_little_face(alchemist, 0, 0)
    draw_actor_mp(alchemist, 32, 0, contents_width - 32)
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'alchimista
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def alchemist; $game_party.alchemist; end
end

#===============================================================================
# ** Window_AlchemyMaterials
#-------------------------------------------------------------------------------
# finestra che mostra i materiali richiesti dall'alchimia
#===============================================================================
class Window_AlchemyMaterials < Window_ForgeMaterials
  #--------------------------------------------------------------------------
  # * disegna i materiali richiesti
  #--------------------------------------------------------------------------
  def draw_materials
    line = 0
    item.materials.each_index{|i|
      draw_material(item.materials[i], i + 1)
      line = i
    }
    draw_required_mp(line + 2) if Alchemy_Settings::DRAW_MP_IN_MATS
  end
  #--------------------------------------------------------------------------
  # * restituisce l'alchimista
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def alchemist; $game_party.alchemist; end
  #--------------------------------------------------------------------------
  # * disegna i PM richiesti per la trasmutazione
  #--------------------------------------------------------------------------
  def draw_required_mp(line)
    mp = alchemy_product.mp_cost
    enabled = alchemist.mp >= mp
    rect = line_rect(line)
    change_color(normal_color, enabled)
    draw_icon(Alchemy_Settings::MP_ICON, 0, rect.y)
    rect.x += 24; rect.width -= 24
    draw_text(rect, Vocab::mp_a)
    draw_text(rect, sprintf('[%d/%d]',mp, alchemist.mhp), 2)
  end
  #--------------------------------------------------------------------------
  # * restituisce il prodotto dell'alchimia
  # @return [Alchemy_Product]
  #--------------------------------------------------------------------------
  def alchemy_product; @item; end
  #--------------------------------------------------------------------------
  # * ridefinizione del metodo fitting_height per mettere i PM
  #--------------------------------------------------------------------------
  def fitting_height(line_number)
    super(line_number + (Alchemy_Settings::DRAW_MP_IN_MATS ? 1 : 0))
  end
end

#===============================================================================
# ** Window_ForgeConfirm
#-------------------------------------------------------------------------------
# viene aperta quando si seleziona un oggetto da craftare. Puoi scegliere il
# numero di oggetti da forgiare o annullare. Serve anche per mostrare
# l'animazione quando la forgiatura è in corso.
#===============================================================================
class Window_AlchemyConfirm < Window_Base
  attr_reader :quantity
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 300, fitting_height(3))
    self.openness = 0
    @quantity = 0
    @item = nil
    @handler = {}
    @active = false
    @dummy_num = 0
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if product.nil?
    draw_item_name(product.item, 0, 0)
    draw_item_arrows(number_width)
    line = draw_required_materials
    draw_mp(line)
    draw_separator(line + 1)
    draw_commands(line + 1)
  end
  #--------------------------------------------------------------------------
  # * refresh in stato take.
  #--------------------------------------------------------------------------
  def take_refresh
    rect = line_rect
    contents.clear_rect(rect)
    return if @dummy_num == 0
    draw_item_name(product.item, 0, 0)
    w = number_width
    x = contents_width - number_width
    draw_text(x, 0, w, line_height, @dummy_num)
  end
  #--------------------------------------------------------------------------
  # * disegna le frecce
  #--------------------------------------------------------------------------
  def draw_item_arrows(width)
    change_color(normal_color)
    x = contents_width - width
    r_w = arrow_rect(:right).width
    draw_arrow(:left, x, 0, can_sub?)
    draw_text(x, 0, width, line_height, @quantity * product.result_n, 1)
    draw_arrow(:right, contents_width - r_w, 0, can_add?)
  end
  #--------------------------------------------------------------------------
  # * larghezza dei numeri
  #--------------------------------------------------------------------------
  def number_width
    l_w = arrow_rect(:left).width
    r_w = arrow_rect(:right).width
    t_w = text_size('00').width
    l_w + r_w + t_w + 4
  end
  #--------------------------------------------------------------------------
  # * disegna i materiali richiesti
  #--------------------------------------------------------------------------
  def draw_required_materials
    draw_bg_rect(0, line_rect(1).y)
    change_color(system_color)
    draw_text(line_rect(1), Vocab.materials_needed)
    (0..product.materials.size-1).each{|i|
      draw_material(product.materials[i], i + 2)
    }
    product.materials.size + 2
  end
  #--------------------------------------------------------------------------
  # * mostra i materiali richiesti moltiplicato per il numero di oggetti da
  # forgiare.
  # @param [Forge_Material] material
  # @param [Integer] index
  #--------------------------------------------------------------------------
  def draw_material(material, index)
    rect = line_rect(index)
    draw_item_name(material.item, rect.x, rect.y)
    r_num = material.quantity * @quantity
    p_num = $game_party.item_number(material.item)
    text = sprintf('x%d/%d', r_num, p_num)
    draw_text(rect, text, 2)
  end
  #--------------------------------------------------------------------------
  # * disegna i PM richiesti
  #--------------------------------------------------------------------------
  def draw_mp(line_number)
    rect = line_rect(line_number)
    draw_actor_little_face(alchemist, rect.x, rect.y)
    rect.x += 32
    rect.width -= 32
    draw_mp_gauge(rect.x, rect.y + 14, rect.width, 10)
    change_color(system_color)
    draw_text(rect, sprintf(Alchemy_Settings::REQ_MP, Vocab::mp_a))
    change_color(normal_color)
    text = sprintf('%d/%d', product.mp_cost * @quantity, alchemist.mp)
    draw_text(rect, text, 2)
  end
  #--------------------------------------------------------------------------
  # * disegna la barra degli MP richiesti
  #--------------------------------------------------------------------------
  def draw_mp_gauge(x, y, width, height)
    contents.fill_rect(x, y, width, height, gauge_back_color)
    mp_rate = alchemist.mp_rate
    cs_rate = (product.mp_cost.to_f * @quantity) / alchemist.mmp
    contents.fill_rect(x, y, width, height, gauge_back_color)
    contents.fill_rect(x, y, mp_rate * width, height, mp_gauge_color2)
    contents.fill_rect(x, y, cs_rate * width, height, knockout_color)
  end
  #--------------------------------------------------------------------------
  # * disegna un separatore
  #--------------------------------------------------------------------------
  def draw_separator(line_number)
    rect = line_rect(line_number)
    rect.y += 1
    rect.height = 1
    self.contents.fill_rect(rect.x, rect.y, rect.width, rect.height, gauge_back_color)
  end
  #--------------------------------------------------------------------------
  # * disegna i comandi della finestra
  #--------------------------------------------------------------------------
  def draw_commands(line_number)
    rect = line_rect(line_number)
    rect.y += 3; rect.width = (rect.width - 24) / 2
    draw_key_icon(:C, rect.x, rect.y)
    rect.x += 24
    draw_text(rect, Vocab.forge_start)
    rect.x += rect.width
    draw_key_icon(:B, rect.x, rect.y)
    rect.x += 24
    draw_text(rect, Vocab.forge_cancel)
  end
  #--------------------------------------------------------------------------
  # * determina se si può diminuire la quantità
  #--------------------------------------------------------------------------
  def can_sub?; @quantity > 1; end
  #--------------------------------------------------------------------------
  # * determina se si può aumentare la quantità
  #--------------------------------------------------------------------------
  def can_add?
    return false unless $game_party.can_transmutate?(product, @quantity + 1)
    alchemist.mp >= product.mp_cost * @quantity
  end
  #--------------------------------------------------------------------------
  # * restituisce l'alchimista del gruppo
  # @return [Game_Actor]
  #--------------------------------------------------------------------------
  def alchemist; $game_party.alchemist; end
  #--------------------------------------------------------------------------
  # * aggiorna l'input delle frecce
  #--------------------------------------------------------------------------
  def update_arrows
    return unless product
    return unless open?
    reduce if Input.repeat?(:LEFT) and can_sub?
    add if Input.repeat?(:RIGHT) and can_add?
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_arrows
    process_handling
  end
  #--------------------------------------------------------------------------
  # * riduce di 1 unità
  #--------------------------------------------------------------------------
  def reduce
    @quantity -= 1
    Sound.play_cursor
    Input.update
    refresh
  end
  #--------------------------------------------------------------------------
  # * aggiunge di 1 unità
  #--------------------------------------------------------------------------
  def add
    @quantity += 1
    Sound.play_cursor
    Input.update
    refresh
  end
  #--------------------------------------------------------------------------
  # * aggiorna l'handler per Ok e Esc
  # noinspection RubyUnnecessaryReturnStatement
  #--------------------------------------------------------------------------
  def process_handling
    return unless open?
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  # * ottiene lo stato di attivazione dell'Ok
  #--------------------------------------------------------------------------
  def ok_enabled?; handle?(:ok) and @active; end
  #--------------------------------------------------------------------------
  # * ottiene lo stato di attivazione di Esc
  #--------------------------------------------------------------------------
  def cancel_enabled?; handle?(:cancel); end
  #--------------------------------------------------------------------------
  # * processo che viene eseguito quando è premuto Ok
  #--------------------------------------------------------------------------
  def process_ok
    Sound.play_ok
    Input.update
    @active = false
    call_ok_handler
  end
  #--------------------------------------------------------------------------
  # * chiama l'handler di Ok
  #--------------------------------------------------------------------------
  def call_ok_handler; call_handler(:ok); end
  #--------------------------------------------------------------------------
  # * processo che viene eseguito quando è premuto Esc
  #--------------------------------------------------------------------------
  def process_cancel
    Sound.play_cancel
    Input.update
    close
    call_cancel_handler
  end
  #--------------------------------------------------------------------------
  # * chiama l'handler di annullamento
  #--------------------------------------------------------------------------
  def call_cancel_handler; call_handler(:cancel); end
  #--------------------------------------------------------------------------
  # * imposta un handler
  #--------------------------------------------------------------------------
  def set_handler(symbol, method)
    @handler[symbol] = method
  end
  #--------------------------------------------------------------------------
  # * controlla l'esistenza di un handler
  #--------------------------------------------------------------------------
  def handle?(symbol); @handler.include?(symbol); end
  #--------------------------------------------------------------------------
  # * chiama un handler
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    @handler[symbol].call if handle?(symbol)
  end
  #--------------------------------------------------------------------------
  # * imposta un oggetto
  # @param [Forge_Product] item
  #--------------------------------------------------------------------------
  def set_item(item)
    @item = item
    @quantity = 1
    @active = true
    deep_refresh
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto
  # @return [Alchemy_Product]
  #--------------------------------------------------------------------------
  def product; @item; end
  #--------------------------------------------------------------------------
  # * fa un refresh modificando l'altezza della finestra
  #--------------------------------------------------------------------------
  def deep_refresh
    recalc_height
    update_placement
    create_contents
    refresh
  end
  #--------------------------------------------------------------------------
  # * ricalcola l'altezza dovuta alla finestra
  #--------------------------------------------------------------------------
  def recalc_height
    line_number = 4 + product.materials.size
    self.height = fitting_height(line_number) + 3
  end
  #--------------------------------------------------------------------------
  # * aggiorna la disposizione della finestra
  #--------------------------------------------------------------------------
  def update_placement
    self.x = (Graphics.width - self.width) / 2
    self.y = (Graphics.height - self.height) / 2
  end
  #--------------------------------------------------------------------------
  # * restituisce il numero totale degli oggetti
  #--------------------------------------------------------------------------
  def total_item_number
    @quantity * product.result_n
  end
end

#===============================================================================
# ** Alchemy_Animator
#-------------------------------------------------------------------------------
# sprite speciale che viene animato quando un oggetto viene trasmutato.
#===============================================================================
class Alchemy_Animator < Sprite_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Viewport] viewport
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super
    @animation_started = false
    self.bitmap = Bitmap.new(24, 24)
    self.ox = 12
    self.oy = 12
  end
  #--------------------------------------------------------------------------
  # * imposta l'icona dell'oggetto
  # @param [RPG::Item] item
  #--------------------------------------------------------------------------
  def set_item(item)
    self.x = Graphics.width / 2
    self.y = Graphics.height / 2
    self.zoom_x = 0.05
    self.zoom_y = 0.05
    self.opacity = 0
    bitmap.clear
    self.bitmap.draw_icon(item.icon_index, 0, 0)
    @animation_started = false
  end
  #--------------------------------------------------------------------------
  # * inizia l'animazione
  #--------------------------------------------------------------------------
  def animate
    self.opacity = 255
    start_animation($data_animations[Alchemy_Settings::ANIM_ID])
    @animation_started = true
  end
  #--------------------------------------------------------------------------
  # * aggiornamento dello sprite
  #--------------------------------------------------------------------------
  def update
    super
    return unless @animation_started
    update_zoom
    update_input
    update_animation_end
  end
  #--------------------------------------------------------------------------
  # * ferma l'animazione
  #--------------------------------------------------------------------------
  def stop_animation
    @animation_started = false
    start_animation(nil)
    self.spark_active = true
    smooth_move(self.x, Graphics.height + 48, 1, method(:stop_sparks))
    call_handler
  end
  #--------------------------------------------------------------------------
  # * aggiorna la fine dell'animazione
  #--------------------------------------------------------------------------
  def update_animation_end
    stop_animation unless animation?
  end
  #--------------------------------------------------------------------------
  # * imposta il metodo che verrà eseguito alla fine dell'animazione
  # @param [Method] new_handler
  #--------------------------------------------------------------------------
  def set_handler(new_handler)
    @handler = new_handler
  end
  #--------------------------------------------------------------------------
  # * chiama il metodo impostato per la fine dell'animazione
  #--------------------------------------------------------------------------
  def call_handler; @handler.call if @handler; end
  #--------------------------------------------------------------------------
  # * controlla se un tasto è premuto durante l'animazione
  #--------------------------------------------------------------------------
  def update_input
    stop_animation if Input.trigger?(:C) or Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  # * aggiorna lo zoom dell'immagine
  #--------------------------------------------------------------------------
  def update_zoom
    if self.zoom_x < 2
      self.zoom_x += 0.05
      self.zoom_y += 0.05
    end
  end
end

#===============================================================================
# ** Scene_Alchemy
#-------------------------------------------------------------------------------
# schermata di alchimia
#===============================================================================
class Scene_Alchemy < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_mats_window
    create_details_window
    create_mp_window
    create_item_window
    create_alchemy_window
    create_animation_sprite
  end
  #--------------------------------------------------------------------------
  # * crea la finestra degli oggetti
  #--------------------------------------------------------------------------
  def create_item_window
    y = @mp_window.bottom_corner
    width = Graphics.width / 2
    height = Graphics.height - y
    @item_window = Window_AlchemyList.new(0, y, width, height)
    @item_window.mat_window = @mats_window
    @item_window.help_window = @help_window
    @item_window.info_window = @details_window
    @item_window.set_handler(:ok, method(:command_select))
    @item_window.set_handler(:cancel, method(:return_scene))
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * crea la finestra degli mp
  #--------------------------------------------------------------------------
  def create_mp_window
    x = 0#Graphics.width
    y = @help_window.bottom_corner
    width = Graphics.width / 2
    @mp_window = Window_AlchemyMP.new(x, y, width)
    #@mp_window.y = Graphics.height - @mp_window.height
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei dettagli
  #--------------------------------------------------------------------------
  def create_details_window
    x = @mats_window.x
    y = @mats_window.bottom_corner
    width = @mats_window.width
    height = Graphics.height - y
    @details_window = Window_ItemInfo.new(x, y, width, height)
    @details_window.see_possessed = true
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei materiali
  #--------------------------------------------------------------------------
  def create_mats_window
    x = Graphics.width / 2
    y = @help_window.bottom_corner
    width = Graphics.width - x
    @mats_window = Window_AlchemyMaterials.new(x, y ,width)
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dell'alchimia
  #--------------------------------------------------------------------------
  def create_alchemy_window
    @alchemy_window = Window_AlchemyConfirm.new
    @alchemy_window.set_handler(:ok, method(:command_transmutate))
    @alchemy_window.set_handler(:cancel, method(:cancel_select))
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def create_animation_sprite
    @anim_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @anim_viewport.z = 200
    @anim_sprite = Alchemy_Animator.new(@anim_viewport)
    @anim_sprite.set_handler(method(:hide_confirm_window))
  end
  #--------------------------------------------------------------------------
  # * quando viene selezionato un oggetto
  #--------------------------------------------------------------------------
  def command_select
    @alchemy_window.set_item(@item_window.item)
    show_confirm_window
  end
  #--------------------------------------------------------------------------
  # * quando si annulla la selezione di un oggetto
  #--------------------------------------------------------------------------
  def cancel_select
    hide_confirm_window
  end
  #--------------------------------------------------------------------------
  # * comando di trasmutazione
  #--------------------------------------------------------------------------
  def command_transmutate
    process_alchemy
    @item_window.refresh
    @mats_window.refresh
    @mp_window.refresh
    if Alchemy_Settings::QUICK_OPERATION
      hide_confirm_window
    else
      @alchemy_window.close
      @anim_sprite.set_item(@alchemy_window.product.item)
      @anim_sprite.animate
    end
  end
  #--------------------------------------------------------------------------
  # * consuma gli oggetti e restituisce il prodotto
  #--------------------------------------------------------------------------
  def process_alchemy
    product = @alchemy_window.product
    quantity = @alchemy_window.quantity
    Alchemy_Core.transmutate(product, quantity)
  end
  #--------------------------------------------------------------------------
  # * mostra la finestra di conferma di trasmutazione
  #--------------------------------------------------------------------------
  def show_confirm_window
    @alchemy_window.open
    @item_window.smooth_move(0 - @item_window.width, @item_window.y)
    @mp_window.smooth_move(0 - @mp_window.width, @mp_window.y)
    @mats_window.smooth_move(Graphics.width, @mats_window.y)
    @details_window.smooth_move(Graphics.width, Graphics.height / 2)
  end
  #--------------------------------------------------------------------------
  # * nasconde la finestra di conferma di trasmutazione
  #--------------------------------------------------------------------------
  def hide_confirm_window
    @alchemy_window.close
    @item_window.smooth_move(0, @item_window.y)
    @mp_window.smooth_move(0, @mp_window.y)
    @mats_window.smooth_move(Graphics.width / 2, @mats_window.y)
    @details_window.smooth_move(Graphics.width / 2, @mats_window.bottom_corner)
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    @anim_sprite.update
  end
  #--------------------------------------------------------------------------
  # * fine
  #--------------------------------------------------------------------------
  def terminate
    super
    @anim_sprite.dispose
    @anim_viewport.dispose
  end
end