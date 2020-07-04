#===============================================================================
# Forgiatura di Holy87
# Difficoltà utente: ★
# Versione 1.0
# Licenza: CC. Chiunque può scaricare, modificare, distribuire e utilizzare
# lo script nei propri progetti, sia amatoriali che commerciali. Vietata
# l'attribuzione impropria.
#===============================================================================
# È il mio sistema di forgiatura ideato per Overdrive: sebbene non sia molto
# diverso da quello classico, è personale e con una grafica molto più
# accattivante.
# Funzioni:
# ● Puoi creare fabbri con liste definite di oggetti da forgiare
# ● Facile configurazione di fabbri e oggetti da forgiare
# ● Puoi creare oggetti che forgiati restituiscono più quantità
# ● Animazioni gagliarde
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main.
# RICHIEDE UNA SERIE DI SCRIPT INCLUSI NEL GIOCO.
# Non dico che è vietato usarlo per il vostro gioco, ma necessita di adattamenti.

#===============================================================================
# ** CONFIGURAZIONE
#===============================================================================
module Forge_Settings
  #--------------------------------------------------------------------------
  # * vocaboli
  #--------------------------------------------------------------------------
  MASTERWORK_V = 'Capolavoro'
  MATERIALS = 'Materiali richiesti'
  GOLD_REQ = 'Oro richiesto'
  GOLD_OBT = 'Oro posseduto'
  FORGE_START = 'Forgia'
  FORGE_CANCEL = 'Annulla'
  #--------------------------------------------------------------------------
  # * suoni
  #--------------------------------------------------------------------------
  FORGE_SE_ITEM = 'Item3'
  FORGE_SE_WEAP = 'Sword2'
  FORGE_SE_ARMOR = 'Equip'
  FORGE_SE_START = 'Equip3'
  #--------------------------------------------------------------------------
  # * altre opzioni
  #--------------------------------------------------------------------------
  DEFAULT_M_RATE = 5 # % di probabilità l'oggetto sia un masterpiece
  GOLD_ICON = 147    # index icona dell'oro
  # Calcolo dell'oro richiesto per la fabbricazione se non è stato impostato
  # alcun costo. Se inserito 0, ha costo nullo. Con N > 0 ha costo dell'
  # oggetto / N.
  GOLD_DIVISOR = 8
  # Questo parametro riguarda l'animazione di forgiatura (gli oggetti che
  # cadono). Determina ogni quanti frame fa cadere un oggetto. Tieni in
  # considerazione che se ci sono troppi oggetti, questo viene ridotto
  # proporzionalmente per non far durare troppo l'animazione.
  FREQUENCY = 30
  #--------------------------------------------------------------------------
  # * qui si crea la lista dei fabbri con i loro oggetti.
  # Parametri:
  # - name: nome del fabbro (compare in alto nella schermata, sopra l'help)
  # - items: array degli oggetti che può craftare (definiti in basso)
  # - m_rate: probabilità masterwork (non funziona, facoltativo)
  # - g_rate: costo del fabbro (facoltativo)
  #--------------------------------------------------------------------------
  BLACKSMITHS = {
      :faide => {
          :name => 'Gino, il fabbro di Faide-Eiba',
          :items => [:iron_shield, :iron_helmet, :leather_hat, :buckler,
                     :elf_hat, :iron_armor, :leather_jacket, :elf_mantle,
                     :claymore, :peaked_mace, :sabre, :harpoon, :hard_bow,
                     :onyx_staff, :battle_gloves]
      },
      :balthazar => {
          :name => 'Pino, il fabbro di Balthazar',
          :items => [:iron_shield, :iron_helmet, :leather_hat, :buckler,
                     :elf_hat, :iron_armor, :leather_jacket, :elf_mantle,
                     :claymore, :iron_mace, :killer_sword, :harpoon, :hard_bow,
                     :onyx_staff, :battle_gloves]
      },
      :jugure => {
          :name => 'Kanou, maestro fabbro di Yugure',
          :items => [:nodachi, :war_axe, :katana, :naginata, :peaked_mace,
                     :yumi_bow, :khakkhara, :sai, :silver_glow,
                     :imperial_shield, :armguard,
                     :imperial_helmet, :rogue_hat, :mystic_diadem, :imperial_armor,
                     :rogue_shirt, :mystic_dress]
      },
      :yugure_jr => {
          :name => 'Apprendista del maestro Kanou',
          :items => [:steel,:bone_powder,:crafted_leather,:vortex,:power_brick,
                     :mithril_alloy,:varnish_of_purity,:dimensional_core,:fine_silk]
      },
      :nevandra => {
          :name => 'Edoardo, il fabbro di Nevandra',
          :items => [:mugen, :golden_sword, :dwarf_axe, :dragon_slayer,
                     :javelin, :crimson_bow, :quantic_line, :crystal_dagger,
                     :shocker, :nemesis_shield, :warden_shield, :magnet_buckler,
                     :nemesis_helmet, :warden_helm, :elven_hat,
                     :blessed_diadem, :elven_cap, :wind_helmet],
      },
      :nevandra_jr => {
          :name => 'Taddeo, il volenteroso figlio di Edoardo',
          :items => [:steel,:bone_powder,:crafted_leather,:vortex,:power_brick,
                     :mithril_alloy,:varnish_of_purity,:dimensional_core,:fine_silk]
      }
  }
  #--------------------------------------------------------------------------
  # * qui si crea la lista degli oggetti forgiabili. Funziona in questo modo
  # - item: l'oggetto craftato. Definire con tipo, id, quantità così:
  #   carattere iniziale: i = item, w = weapon, a = armor
  #   successivamente si aggiunge l'ID dell'oggetto
  #   facoltativamente, il numero di oggetti prodotti con xN. Esempio:
  #   i12x3 significa che produrrà 3 unità dell'oggetto 12
  #   w35 significa che produrrà un'arma con ID 35
  # - mats: array dei materiali richiesti. Si usa la stessa logica di item
  #   per definire i materiali. Ad esempio, i76x3 significa che ha bisogno
  #   di 3 item con ID 76.
  # - gold: facoltativo. Il costo della forgiatura. Se è omesso, viene
  #   calcolato il costo di default.
  #--------------------------------------------------------------------------
  FORGE_ITEMS = {
      # materiali avanzati
      :steel =>             {:item => 'i75', :mats => %w(i76x3 i50x2),    :gold => 200},
      :bone_powder =>       {:item => 'i81', :mats => %w(i53x3),          :gold => 80},
      :crafted_leather =>   {:item => 'i82', :mats => %w(i56x4),          :gold => 80},
      :vortex =>            {:item => 'i83', :mats => %w(i61 i62 i63),    :gold => 100},
      :power_brick =>       {:item => 'i84', :mats => %w(i57x5 i71 i80x2),:gold => 200},
      :mithril_alloy =>     {:item => 'i85', :mats => %w(i75 i78 i86),    :gold => 300},
      :varnish_of_purity => {:item => 'i86', :mats => %w(i49 i50x2 i81),  :gold => 120},
      :dimensional_core =>  {:item => 'i87', :mats => %w(i84 i73x2 i79),  :gold => 400},
      :fine_silk =>         {:item => 'i88', :mats => %w(i82 i52x2),      :gold => 50},

      # armi
      :sabre => {:item => 'w9', :mats => %w(i77, i56x3, i64)},
      :killer_sword => {:item => 'w10', :mats => %w(i85 i73), :gold => 650},
      :katana => {:item => 'w14', :mats => %w(i76x2 i71x3 i77x3), :gold => 1500},
      :golden_sword => {:item => 'w16', :mats => %w(i75 i71x3 i77x3), :gold => 3000},

      :claymore => {:item => 'w23', :mats => %w(i76, i60x3, i64), :gold => 700},
      :nodachi => {:item => 'w24', :mats => %w(i76x2 i71x2 i77x3), :gold => 1600},
      :dragon_slayer => {:item => 'w26', :mats => %w(i75x2 i69x2 i82x2), :gold => 3200},

      :iron_mace => {:item => 'w32', :mats => %w(i76, i64x3), :gold => 650},
      :peaked_mace => {:item => 'w33', :mats => %w(i76x2, i77x2), :gold => 1500},

      :war_axe => {:item => 'w41', :mats => %w(i76x2 i71x2 i64x3), :gold => 1500},
      :dwarf_axe => {:item => 'w42', :mats => %w(i75 i69x2 i82x2), :gold => 3200},

      :harpoon => {:item => 'w53', :mats => %w(i77 i53x4)},
      :naginata => {:item => 'w54', :mats => %w(i77x4 i71x2 i80x3), :gold => 1500},
      :javelin => {:item => 'w55', :mats => %w(i75 i81 i86), :gold => 3200},

      :hard_bow => {:item => 'w73', :mats => %w(i64x3 i56x2 i51)},
      :yumi_bow => {:item => 'w74', :mats => %w(i51x2 i64x3 i80x3), :gold => 1500},
      :crimson_bow => {:item => 'w75', :mats => %w(i81 i62x3 i71 i74x2), :gold => 3200},

      :onyx_staff => {:item => 'w107', :mats => %w(i72 i64x2)},
      :khakkhara => {:item => 'w110', :mats => %w(i53 i71x2 i73x2), :gold => 1500},
      :quantic_line => {:item => 'w111', :mats => %w(i72x2 i84 i83x2), :gold => 3200},

      :sai => {:item => 'w130', :mats => %w(i76x2 i74x2 i77x3), :gold=> 1500},
      :crystal_dagger => {:item => 'w133', :mats => %w(i75 i72 i60x2), :gold => 3200},

      :battle_gloves => {:item => 'w155', :mats => %w(i56x2 i53x2 i55x2)},
      :silver_glow => {:item => 'w156', :mats => %w(i78 i67 i76x2), :gold => 1500},
      :shocker => {:item => 'w157', :mats => %w(i75x2 i50x3 i67x2)},

      # armature
      :iron_shield => {:item => 'a6', :mats => %w(i76 i59x2)},
      :imperial_shield => {:item => 'a9', :mats => %w(i77x3 i56x3 i71x2)},
      :nemesis_shield => {:item => 'a10', :mats => %w(i75 i73x2 i63)},
      :warden_shield => {:item => 'a11', :mats => %w(i75 i74x2 i67x2)},
      :leather_hat => {:item => 'a29', :mats => %w(i56 i52)},
      :iron_helmet => {:item => 'a31', :mats => %w(i76 i60x2 i77)},
      :elf_hat => {:item => 'a39', :mats => %w(i52 i55x2 i63)},
      :imperial_helmet => {:item => 'a40', :mats => %w(i75 i71)},
      :rogue_hat => {:item => 'a41', :mats => %w(i82 i60x2)},
      :mystic_diadem => {:item => 'a42', :mats => %w(i75 i73)},
      :nemesis_helmet => {:item => 'a43', :mats => %w(i42 i40 i59x2)},
      :warden_helm => {:item => 'a44', :mats => %w(i75 i71 i67x3)},
      :blessed_diadem => {:item => 'a45', :mats => %w(i76 i68 i71)},
      :elven_cap => {:item => 'a46', :mats => %w(i88 i73 i74),},
      :wind_helmet => {:item => 'a47', :mats => %w(i77x2 i60x2 i71)},
      :elven_hat => {:item => 'a48', :mats => %w(i82 i60x2 i77x2)},
      :leather_jacket => {:item => 'a69', :mats => %w(i56x2 i59x2 i53x2)},
      :elf_mantle => {:item => 'a76', :mats => %w(i52x2 i55x3 i63x2)},
      :iron_armor => {:item => 'a77', :mats => %w(i76x2 i60x3 i77x2)},
      :imperial_armor => {:item => 'a81', :mats => %w(i75 i77x3 i71)},
      :rogue_shirt => {:item => 'a82', :mats => %w(i77x3 i75)},
      :mystic_dress => {:item => 'a83', :mats => %w(i52 i51x2 i77)},
      :nemesis_armor => {:item => 'a84', :mats => %w(i75 i82 i71)},
      :warden_armor => {:item => 'a85', :mats => %w(i75 i82 i72x2)},
      :blessed_dress => {:item => 'a86', :mats => %w(i88x2 i68x2 i86)},
      :elven_dress => {:item => 'a87', :mats => %w(i88x2 i73x2 i83)},
      :elven_cloak => {:item => 'a88', :mats => %w(i82x2 i65x2 i61x2)},
      :wind_shell => {:item => 'a89', :mats => %w(i77x4 i71x2 i55x4)},

      # supporti
      :buckler => {:item => 'a244', :mats => %w(i56x2 i53x2)},
      :armguard => {:item => 'a245', :mats => %w(i82 i60x3)},
      :magnet_buckler => {:item => 'a246', :mats => %w(i82x2 i71 i77x2)},
  }
end


# ---------ATTENZIONE: MODIFICARE SOTTO QUESTO PARAGRAFO COMPORTA SERI RISCHI
#               PER IL CORRETTO FUNZIONAMENTO DELLO SCRIPT! -------------




#===============================================================================
# ** Forge_Core
#-------------------------------------------------------------------------------
# contiene i comandi necessari al funzionamento della forgiatura.
#===============================================================================
module Forge_Core
  REGXP_PRODUCT = /([iwa])(\d+)(x(\d+))?/i
  REGXP_MATS = /([iwa])(\d+)(x(\d+))?/i
  #--------------------------------------------------------------------------
  # * prosegue con la forgiatura e restituisce il risultato
  # @param [Forge_Product] product
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def self.forge(product, number = 1)
    # Masterwork non ancora funzionante
    $game_party.gain_item(product.item, product.result_n * number)
    $game_party.lose_gold(product.gold * number)
    product.materials.each{|material|
      $game_party.lose_item(material.item, material.quantity * number)
    }
  end
  #--------------------------------------------------------------------------
  # * prova a forgiare, restituisce true o false se la forgiatura è riuscita
  #   o meno
  # @param [Forge_Product] product
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def self.forge_safe(product, number = 1)
    if $game_party.can_forge?(product, number)
      forge(product, number)
      true
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * carica tutti i fabbri
  # @return [Hash<Forge_Shop>]
  #--------------------------------------------------------------------------
  def self.load_blacksmiths
    bs = Forge_Settings::BLACKSMITHS
    blacksmists = {}
    bs.each_pair{|key, value|
      blacksmith = create_bs_from_hash(value)
      blacksmists[key] = blacksmith
    }
    blacksmists
  end
  #--------------------------------------------------------------------------
  # * crea il fabbro dall'hash
  # @param [Hash] hash
  # @return [Forge_Shop]
  #--------------------------------------------------------------------------
  def self.create_bs_from_hash(hash)
    name = hash[:name]
    products = get_items(hash[:items])
    p_rate = hash[:price_rate]
    m_rate = hash[:masterwork_rate]
    shop = Forge_Shop.new(products, name)
    shop.price_rate = p_rate if p_rate != nil
    shop.m_rate = m_rate if m_rate != nil
    shop
  end
  #--------------------------------------------------------------------------
  # * ottiene l'array dei prodoti dall'array degli hash
  # @param [Array<Hash>] items_array
  # @return [Array<Forge_Product>]
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
  # @return [Forge_Product]
  #--------------------------------------------------------------------------
  def self.create_product_from_hash(item_index)
    hash = Forge_Settings::FORGE_ITEMS[item_index]
    if hash.nil?
      puts 'Item not found for ' + item_index.to_s
      return nil
    end
    if hash[:item] =~ REGXP_PRODUCT
      item_type = item_type($1)
      item_id = $2.to_i
      result_n = $3 != nil ? $4.to_i : 1
      materials = get_materials(hash[:mats])
      gold = hash[:gold] ? hash[:gold] : nil
      return Forge_Product.new(item_id, item_type, materials, gold, result_n)
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
  def self.masterwork; Forge_Settings::MASTERWORK_V; end
  def self.materials_needed; Forge_Settings::MATERIALS; end
  def self.required_gold; Forge_Settings::GOLD_REQ; end
  def self.obtained_gold; Forge_Settings::GOLD_OBT; end
  def self.forge_start; Forge_Settings::FORGE_START; end
  def self.forge_cancel; Forge_Settings::FORGE_CANCEL; end
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
# contiene le informazioni su tutti i fabbri e sul fabbro selezionato.
#===============================================================================
class Game_Temp
  # @return [Forge_Shop] forge_shop
  attr_accessor :forge_shop #negozio forgia
  #--------------------------------------------------------------------------
  # * ottiene l'array dei fabbri
  # @return [Hash<Forge_Shop>]
  #--------------------------------------------------------------------------
  def blacksmiths
    @blacksmiths ||= initialize_forge
  end
  #--------------------------------------------------------------------------
  # * crea l'array dei fabbri quando il gioco è stato appena avviato
  # @return [Hash<Forge_Shop>]
  #--------------------------------------------------------------------------
  def initialize_forge
    Forge_Core.load_blacksmiths
  end
end

#===============================================================================
# ** Game_Party
#-------------------------------------------------------------------------------
# aggiunge controllo per vedere se il gruppo può forgiare l'oggetto
#===============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * determina se il gruppo può forgiare l'oggetto
  # @param [Forge_Product] product
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def can_forge?(product, number = 1)
    return false if product.nil?
    return false if self.gold < product.gold * number
    return false if product.result_n * number + item_number(product.item) > max_item_number(product.item)
    gathered_materials?(product.materials, number)
  end
  #--------------------------------------------------------------------------
  # * determina se il gruppo ha materiali a sufficienza
  # @param [Array<Forge_Material>] materials
  # @param [Integer] number
  #--------------------------------------------------------------------------
  def gathered_materials?(materials, number = 1)
    materials.each{|material|
      return false if item_number(material.item) < material.quantity * number
    }
    true
  end
  #--------------------------------------------------------------------------
  # * Restituisce il bonus masterwork del gruppo
  #--------------------------------------------------------------------------
  def masterwork_prob_bonus; 0; end
end

#===============================================================================
# ** Forge_Product
#-------------------------------------------------------------------------------
# contiene le informazioni sull'oggetto da forgiare
#===============================================================================
class Forge_Product
  #--------------------------------------------------------------------------
  # * variabili di istanza pubblici
  # @return [Fixnum] item_id
  # @return [Fixnum] item_type
  # @return [Fixnum] result_n
  # @return [Array<Forge_Material>] materials
  # @return [Fxnum] gold
  # @return [Fixnum] masterwork_r
  #--------------------------------------------------------------------------
  attr_reader :item_id      #id del prodotto
  attr_reader :item_type    #tipo del prodotto
  attr_reader :result_n     #quantità risultante
  attr_reader :gold         #oro richiesto
  attr_reader :materials    #materiali richiesti
  attr_reader :masterwork_r #probabilità capolavoro
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Fixnum] item_id
  # @param [Fixnum] item_type
  # @param [Fixnum] result_n
  # @param [Array<Forge_Material>] materials
  # @param [Fixnum] gold (se nil, calcola da solo)
  # @param [Fixnum] m_rate
  #--------------------------------------------------------------------------
  def initialize(item_id, item_type, materials, gold = 0, result_n = 1, m_rate = 0)
    @item_id = item_id
    @item_type = item_type
    @result_n = result_n
    @materials = materials
    @masterwork_r = m_rate
    @gold = gold ? gold : calc_gold
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
  def gold_div; Forge_Settings::GOLD_DIVISOR; end
  #--------------------------------------------------------------------------
  # * restituisce il calcolo del prezzo automatico
  #--------------------------------------------------------------------------
  def calc_gold; gold_div > 0 ? item.price / gold_div : 0; end
end

#===============================================================================
# ** Forge_Material
#-------------------------------------------------------------------------------
# contiene le informazioni sui materiali necessari per la forgiatura.
#===============================================================================
class Forge_Material
  #--------------------------------------------------------------------------
  # * variabili d'istanza pubblici
  #--------------------------------------------------------------------------
  attr_reader :item_id      #id dell'oggetto
  attr_reader :item_type    #tipo dell'oggetto
  attr_reader :quantity     #quantità di oggetti necessari
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] item_id
  # @param [Integer] item_type
  # @param [Integer] quantity
  #--------------------------------------------------------------------------
  def initialize(item_id, item_type, quantity = 1)
    @item_id = item_id
    @item_type = item_type
    @quantity = quantity
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto materiale
  # @return [RPG::BaseItem]
  #--------------------------------------------------------------------------
  def item
    case @item_type
      when 1; $data_items[@item_id]
      when 2; $data_weapons[@item_id]
      when 3; $data_armors[@item_id]
      else; nil
    end
  end
end

#===============================================================================
# ** Forge_Shop
#-------------------------------------------------------------------------------
# contiene le informazioni sul fabbro e gli oggetti forgiabili.
#===============================================================================
class Forge_Shop
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubbliche
  # @return [Array<Forge_Product>] products
  # @return [String] name
  # @return [Float] price_rate
  # @return [Float] m_rate
  #--------------------------------------------------------------------------
  attr_reader :products
  attr_reader :name
  attr_reader :price_rate
  attr_reader :m_rate
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Array<Forge_Product>] products
  # @param [String] name
  # @param [Float] price_rate
  # @param [Float] m_rate
  #--------------------------------------------------------------------------
  def initialize(products, name, price_rate = 1.0, m_rate = 1.0)
    @name = name
    @products = products
    @price_rate = price_rate
    @m_rate = m_rate
  end
end

#===============================================================================
# ** Scene_Forge
#-------------------------------------------------------------------------------
# mostra la schermata di forgiatura.
#===============================================================================
class Scene_Forge < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_bs_window
    create_help_window
    create_gold_window
    create_materials_window
    create_item_window
    create_details_window
    create_confirm_window
    create_forge_animator
  end
  #--------------------------------------------------------------------------
  # * crea la finestra d'aiuto (la sposta in basso)
  #--------------------------------------------------------------------------
  def create_help_window
    super
    @help_window.y = @blacksmith_window.height
  end
  #--------------------------------------------------------------------------
  # * crea la finestra del nome del fabbro
  #--------------------------------------------------------------------------
  def create_bs_window
    @blacksmith_window = Window_ForgeBlacksmith.new(0, 0, Graphics.width)
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dell'elenco degli oggetti craftabili
  #--------------------------------------------------------------------------
  def create_item_window
    y = @help_window.bottom_corner
    width = Graphics.width / 2
    height = @materials_window.y - y
    @items_window = Window_ForgeList.new(0, y, width, height)
    @items_window.set_handler(:ok, method(:command_select))
    @items_window.set_handler(:cancel, method(:return_scene))
    @items_window.help_window = @help_window
    @items_window.mat_window = @materials_window
    @items_window.gold_window = @gold_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei dettagli
  #--------------------------------------------------------------------------
  def create_details_window
    x = @items_window.right_corner
    y = @items_window.y
    width = Graphics.width / 2
    height = Graphics.height - y
    @details_window = Window_ItemInfo.new(x, y, width, height)
    @items_window.info_window = @details_window
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dei materiali richiesti
  #--------------------------------------------------------------------------
  def create_materials_window
    width = @gold_window.width
    @materials_window = Window_ForgeMaterials.new(0, 0, width)
    y = @gold_window.y - @materials_window.height
    @materials_window.y = y
  end
  #--------------------------------------------------------------------------
  # * crea la finestra dell'oro richiesto
  #--------------------------------------------------------------------------
  def create_gold_window
    width = Graphics.width / 2
    @gold_window = Window_ForgeGold_Restricted.new(0, 0, width)
    @gold_window.y = Graphics.height - @gold_window.height
  end
  #--------------------------------------------------------------------------
  # * crea la finestra delle conferme
  #--------------------------------------------------------------------------
  def create_confirm_window
    @confirm_window = Window_ForgeConfirm.new
    @confirm_window.set_handler(:ok, method(:command_forge))
    @confirm_window.set_handler(:cancel, method(:command_back))
  end
  #--------------------------------------------------------------------------
  # * crea l'oggetto che gestisce le animazioni della forgiatura
  #--------------------------------------------------------------------------
  def create_forge_animator
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 100
    @forge_animator = Forge_SpritesHandler.new(@viewport, @confirm_window)
    @forge_animator.set_end_handler(method(:forge_end))
  end
  #--------------------------------------------------------------------------
  # * selezione dell'oggetto da craftare
  #--------------------------------------------------------------------------
  def command_select
    @items_window.smooth_move(0 - @items_window.width, @items_window.y)
    @materials_window.smooth_move(0 - @materials_window.width, @materials_window.y)
    @gold_window.smooth_move(0 - @gold_window.width, @gold_window.y)
    @details_window.smooth_move(Graphics.width, @details_window.y)
    @confirm_window.set_item(@items_window.item)
    @confirm_window.open
  end
  #--------------------------------------------------------------------------
  # * torna indietro alla selezione dell'oggetto
  #--------------------------------------------------------------------------
  def command_back
    @confirm_window.close
    @items_window.smooth_move(0, @items_window.y)
    @materials_window.smooth_move(0, @materials_window.y)
    @gold_window.smooth_move(0, @gold_window.y)
    @details_window.smooth_move(Graphics.width/2, @details_window.y)
    @items_window.activate
  end
  #--------------------------------------------------------------------------
  # * forgia l'oggetto e lo aggiunge al party
  #--------------------------------------------------------------------------
  def command_forge
    make_item
    play_animation
  end
  #--------------------------------------------------------------------------
  # * avvia la procedura di creazione dell'oggetto (e la mette nell'invent.)
  #--------------------------------------------------------------------------
  def make_item
    Forge_Core.forge(@items_window.item, @confirm_window.quantity)
    Sound.play_forge_start
    @materials_window.refresh
    @gold_window.refresh
    @items_window.refresh
  end
  #--------------------------------------------------------------------------
  # * esegue l'animazione di forgiatura
  #--------------------------------------------------------------------------
  def play_animation
    @forge_animator.play
  end
  #--------------------------------------------------------------------------
  # * aggiornamento. Aggiunge l'aggiornamento dell'animaizone
  #--------------------------------------------------------------------------
  def update
    super
    @forge_animator.update
  end
  #--------------------------------------------------------------------------
  # * fine. Aggiunge l'eliminazione delle animazioni
  #--------------------------------------------------------------------------
  def terminate
    super
    @forge_animator.dispose
  end
  #--------------------------------------------------------------------------
  # * viene chiamato quando finisce l'animazione di forgiatura
  #--------------------------------------------------------------------------
  def forge_end
    command_back
  end
end

#===============================================================================
# ** Window_ForgeList
#-------------------------------------------------------------------------------
# contiene la lista degli oggetti che possono essere forgiate dal fabbro.
#===============================================================================
class Window_ForgeList < Window_Selectable
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
    @data = $game_temp.forge_shop.products
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
    draw_item_name(item.item, rect.x, rect.y, enabled)
    draw_item_number(item, rect)
  end
  #--------------------------------------------------------------------------
  # * disegna il numero degli oggetti prodotti dalla forgiatura
  # @param [Forge_Product] item
  # @param [Rect] rect
  #--------------------------------------------------------------------------
  def draw_item_number(item, rect)
    return if item.result_n == 1
    num = sprintf('x%d', item.result_n)
    draw_text(rect, num, 2)
  end
  #--------------------------------------------------------------------------
  # * restituisce il prodotto della forgiatura
  # @return [Forge_Product]
  #--------------------------------------------------------------------------
  def item; @data[@index]; end
  #--------------------------------------------------------------------------
  # * determina se l'oggetto nell'index è craftabile
  # @param [Forge_Product] item
  #--------------------------------------------------------------------------
  def enable?(item)
    $game_party.can_forge?(item)
  end
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
  # * imposta la finestra dell'oro
  #--------------------------------------------------------------------------
  def gold_window=(window); @gold_window = window; end
  #--------------------------------------------------------------------------
  # * restituisce la finestra dell'oro
  # @return [Window_ForgeGold]
  #--------------------------------------------------------------------------
  def gold_window; @gold_window; end
  #--------------------------------------------------------------------------
  # * aggiorna l'aiuto al cambio di cursore
  #--------------------------------------------------------------------------
  def update_help
    super
    @help_window.set_item(item.item) if @help_window
    mat_window.set_item(item) if mat_window
    info_window.set_item(item.item) if info_window
    gold_window.set_item(item) if gold_window
  end
end

#===============================================================================
# ** Window_ForgeMaterials
#-------------------------------------------------------------------------------
# mostra gli ingredienti richiesti per forgiare l'oggetto.
#===============================================================================
class Window_ForgeMaterials < Window_Base
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def initialize(x, y, width)
    super(x, y, width, fitting_height(5))
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(system_color)
    draw_bg_rect(line_rect.x, line_rect.y)
    draw_text(line_rect, Vocab.materials_needed)
    draw_materials if item
  end
  #--------------------------------------------------------------------------
  # * imposta l'oggetto da cui prendere i materiali richiesti
  # @param [Forge_Product, Alchemy_Product] item
  #--------------------------------------------------------------------------
  def set_item(item)
    return if @item == item
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto dei materiali
  # @return [Forge_Product]
  #--------------------------------------------------------------------------
  def item; @item; end
  #--------------------------------------------------------------------------
  # * disegna gli ingredienti
  #--------------------------------------------------------------------------
  def draw_materials
    item.materials.each_index{|i|
      draw_material(item.materials[i], i + 1)
    }
  end
  #--------------------------------------------------------------------------
  # * disegna l'ingrediente
  # @param [Forge_Material] material
  # @param [Integer] line
  #--------------------------------------------------------------------------
  def draw_material(material, line)
    p_number = $game_party.item_number(material.item)
    enabled = p_number >= material.quantity
    rect = line_rect(line)
    draw_item_name(material.item, rect.x, rect.y, enabled)
    draw_item_number(material.quantity, p_number, rect, enabled)
  end
  #--------------------------------------------------------------------------
  # * disegna il numero di oggetti richiesti/posseduti
  # @param [Integer] quantity
  # @param [Integer] p_quantity
  # @param [Rect] rect
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def draw_item_number(quantity, p_quantity, rect, enabled)
    text = sprintf('[%d/%d]', quantity, p_quantity)
    change_color(normal_color, enabled)
    draw_text(rect, text, 2)
  end
end

#===============================================================================
# ** Window_ForgeGold
#-------------------------------------------------------------------------------
# mostra l'oro richiesto e l'oro posseduto per forgiare l'oggetto
#===============================================================================
class Window_ForgeGold < Window_Base
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height = fitting_height(4))
    super(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * aggiorna il contenuto della finestra
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless item
    enabled = $game_party.gold >= item.gold
    change_color(system_color, enabled)
    draw_text(line_rect(0), Vocab.required_gold)
    change_color(normal_color, enabled)
    # draw_icon(Forge_Settings::GOLD_ICON, 0, line_height)
    draw_text(line_rect(1), text, item.gold)
    change_color(system_color)
    draw_text(line_rect(2), Vocab.obtained_gold)
    change_color(normal_color)
    draw_text(line_rect(3), $game_party.gold)
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'oggetto
  # @return [Forge_Product]
  #--------------------------------------------------------------------------
  def item; @item; end
  #--------------------------------------------------------------------------
  # * imposta l'oro di un nuovo oggetto
  # @param [Forge_Product] new_item
  #--------------------------------------------------------------------------
  def set_item(new_item)
    return if @item == new_item
    @item = new_item
    refresh
  end
end

#===============================================================================
# ** Window_ForgeBlacksmith
#-------------------------------------------------------------------------------
# mostra semplicemente il nome del fabbro.
#===============================================================================
class Window_ForgeBlacksmith < Window_Base
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
    change_color(normal_color)
    draw_text(line_rect, $game_temp.forge_shop.name, 1)
  end
end

#===============================================================================
# ** Window_ForgeGold_Restricted
#-------------------------------------------------------------------------------
# come la finestra ForgeGold, ma ristretto in 2 sole righe.
#===============================================================================
class Window_ForgeGold_Restricted < Window_ForgeGold
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  def initialize(x, y, width, height = fitting_height(1))
    super
    refresh
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if item.nil?
    enabled = $game_party.can_forge?(item)
    #change_color(system_color, enabled)
    #draw_text(line_rect, Vocab.required_gold)
    change_color(normal_color, enabled)
    text = sprintf('%d%s / %d%s', item.gold, Vocab.currency_unit, $game_party.gold, Vocab.currency_unit)
    icon_index = Forge_Settings::GOLD_ICON
    draw_icon(icon_index, 0, 0, enabled)
    draw_text(line_rect, text, 2)
  end
end

#===============================================================================
# ** Window_ForgeConfirm
#-------------------------------------------------------------------------------
# viene aperta quando si seleziona un oggetto da craftare. Puoi scegliere il
# numero di oggetti da forgiare o annullare. Serve anche per mostrare
# l'animazione quando la forgiatura è in corso.
#===============================================================================
class Window_ForgeConfirm < Window_Base
  attr_reader :quantity
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 250, fitting_height(3))
    self.openness = 0
    @quantity = 0
    @item = nil
    @handler = {}
    @mode = :select
    @dummy_num = 0
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    @mode == :select ? normal_refresh : take_refresh
  end
  #--------------------------------------------------------------------------
  # * refresh normale
  #--------------------------------------------------------------------------
  def normal_refresh
    contents.clear
    return if product.nil?
    draw_item_name(product.item, 0, 0)
    draw_item_arrows(number_width)
    line = draw_required_materials
    draw_gold(line)
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
  # * disegna l'oro richiesto
  #--------------------------------------------------------------------------
  def draw_gold(line_number)
    gold = product.gold * @quantity
    p_gold = $game_party.gold
    curr = Vocab.currency_unit
    rect = line_rect(line_number)
    text = sprintf('%d%s/%d%s', gold, curr, p_gold, curr)
    draw_icon(Forge_Settings::GOLD_ICON, rect.x, rect.y)
    draw_text(rect, text, 2)
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
  def can_add?; $game_party.can_forge?(product, @quantity + 1); end
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
    if @mode == :select
      update_arrows
      process_handling
    else
      update_change_height
    end
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
  def ok_enabled?; handle?(:ok); end
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
    #close
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
    @mode = :select
    @quantity = 1
    deep_refresh
  end
  #--------------------------------------------------------------------------
  # * restituisce l'oggetto
  # @return [Forge_Product]
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
  # * prende un oggetto dalla finestra (per ridurre il numero mostrato)
  #--------------------------------------------------------------------------
  def take
    @dummy_num -= 1
    refresh
  end
  #--------------------------------------------------------------------------
  # * cambia la modalità in take e restituisce una bitmap dell'icona
  #   dell'oggetto
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def change_mode
    @mode = :take
    @dummy_num = total_item_number
    item_bitmap
  end
  #--------------------------------------------------------------------------
  # * restituisce il numero totale degli oggetti
  #--------------------------------------------------------------------------
  def total_item_number
    @quantity * product.result_n
  end
  #--------------------------------------------------------------------------
  # * restituisce la bitmap dell'icona dell'oggetto
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def item_bitmap
    bitmap = Bitmap.new(24, 24)
    rect = line_rect
    rect.width = 24
    bitmap.blt(0, 0, contents, rect)
    bitmap
  end
  #--------------------------------------------------------------------------
  # * aggiorna il cambio di altezza
  #--------------------------------------------------------------------------
  def update_change_height
    return unless @mode == :take
    return unless open?
    optimal_h = fitting_height(1)
    return if self.height == optimal_h
    if self.height < optimal_h
      self.height = optimal_h
    elsif self.height > optimal_h
      self.height -= 5
    end
  end
end

#===============================================================================
# ** Forge_SpritesHandler
#-------------------------------------------------------------------------------
# gestisce l'animazione della forgiatura
#===============================================================================
class Forge_SpritesHandler
  # @attr[Array<Forged_Sprite>] sprites
  # @attr[Viewport] viewport
  attr_accessor :sprites
  attr_accessor :viewport
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Viewport] viewport
  # @param [Window_ForgeConfirm] item_window
  #--------------------------------------------------------------------------
  def initialize(viewport, item_window)
    @viewport = viewport
    reset
    @item_window = item_window
  end
  #--------------------------------------------------------------------------
  # * esegue l'animazione
  #--------------------------------------------------------------------------
  def play
    @bitmap = @item_window.change_mode
    @number = @item_window.total_item_number
    @type = @item_window.product.item_type
    @frequency = calc_frequency
    @counter = 0
    @sprites = []
    @play = true
  end
  #--------------------------------------------------------------------------
  # * Calcola la frequenza di pop. Se il tempo totale è maggiore ai 3
  # secondi, vengono suddivisi i 3 secondi per il numero di oggetti.
  #--------------------------------------------------------------------------
  def calc_frequency
    if @number * Forge_Settings::FREQUENCY >= 180 # 3 secondi
      180 / @number
    else
      Forge_Settings::FREQUENCY
    end
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def update
    return unless @play
    update_creation
    update_all_sprites
    update_input
    update_ending
  end
  #--------------------------------------------------------------------------
  # * eliminazione
  #--------------------------------------------------------------------------
  def dispose
    delete_all_sprites
    @bitmap.dispose if @bitmap
  end
  #--------------------------------------------------------------------------
  # * reset
  #--------------------------------------------------------------------------
  def reset
    @sprites = []
    @play = false
    @number = 0
    @counter = 0
    @frequency = 0
    @bitmap = nil
  end
  #--------------------------------------------------------------------------
  # * ferma l'animazione
  #--------------------------------------------------------------------------
  def stop
    @play = false
    delete_all_sprites
    call_end_handler
  end
  #--------------------------------------------------------------------------
  # *
  # @param [Forged_Sprite] sprite
  #--------------------------------------------------------------------------
  def update_sprite(sprite)
    sprite.update
    delete_sprite(sprite) if sprite.out_of_screen?
  end
  #--------------------------------------------------------------------------
  # * controlla la creazione di nuovi sprite
  #--------------------------------------------------------------------------
  def update_creation
    return if @number == 0
    @counter += 1
    if @counter >= @frequency
      create_new_sprite
      play_sound
      @counter = 0
      @number -= 1
    end
  end
  #--------------------------------------------------------------------------
  # * riproduce il suono di forgiatura
  #--------------------------------------------------------------------------
  def play_sound
    case @type
      when 1; Sound.play_forge_item
      when 2; Sound.play_forge_weapon
      when 3; Sound.play_forge_armor
      else; Sound.play_use_item
    end
  end
  #--------------------------------------------------------------------------
  # * crea il nuovo sprite
  #--------------------------------------------------------------------------
  def create_new_sprite
    @item_window.take
    sprite = Forged_Sprite.new(@viewport)
    sprite.bitmap = @bitmap
    sprite.x = @item_window.x + @item_window.padding
    sprite.y = @item_window.y + @item_window.padding
    sprite.flash(Color::WHITE, 10)
    sprite.spark_active = true
    @sprites.push(sprite)
  end
  #--------------------------------------------------------------------------
  # * aggiorna la condizione per far finire l'animazione. Viene chiamato
  #   dopo ogni eliminazione dello sprite
  #--------------------------------------------------------------------------
  def update_ending
    return unless @play
    if @number <= 0 and @sprites.size == 0
      stop
    end
  end
  #--------------------------------------------------------------------------
  # * forza la fine dell'animazione
  #--------------------------------------------------------------------------
  def force_end
    stop
  end
  #--------------------------------------------------------------------------
  # * cancella uno sprite dalla lista
  # @param [Forged_Sprite] sprite
  #--------------------------------------------------------------------------
  def delete_sprite(sprite)
    sprite.visible = false
    #sprite.delete_sparks
    sprite.dispose
    @sprites.delete(sprite)
  end
  #--------------------------------------------------------------------------
  # * cancella tutti gli sprite (quando viene fermato)
  #--------------------------------------------------------------------------
  def delete_all_sprites
    self.sprites.each{|sprite|
      sprite.visible = false
      sprite.dispose
    }
    @sprites = []
  end
  #--------------------------------------------------------------------------
  # * aggiorna tutti gli sprite
  #--------------------------------------------------------------------------
  def update_all_sprites
    sprites.each{|sprite|
      update_sprite(sprite)
    }
  end
  #--------------------------------------------------------------------------
  # * imposta l'evento di fine animazione
  #--------------------------------------------------------------------------
  def set_end_handler(method)
    @end_handler = method
  end
  #--------------------------------------------------------------------------
  # * aggiorna l'input
  #--------------------------------------------------------------------------
  def update_input
    return unless @play
    if Input.trigger?(:C) or Input.trigger?(:B)
      Input.update
      Sound.play_cancel
      force_end
    end
  end
  #--------------------------------------------------------------------------
  # * chiama l'evento di fine animazione
  #--------------------------------------------------------------------------
  def call_end_handler
    return unless @end_handler
    @end_handler.call
  end
end

#===============================================================================
# ** Forged_Sprite
#-------------------------------------------------------------------------------
# uno Sprite speciale che rimbalza quando creato.
#===============================================================================
class Forged_Sprite < Sprite
  #--------------------------------------------------------------------------
  # * costanti per configurare il movimento
  #--------------------------------------------------------------------------
  GRAVITY = 2
  SPEED_ZERO = 10
  #--------------------------------------------------------------------------
  # * inizializzazione
  # @param [Viewport] viewport
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super
    @direction = rand(5) - 2
    @speed = SPEED_ZERO
    self.spark_bitmap = Cache.picture('Spark2')
  end
  #--------------------------------------------------------------------------
  # * aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_fall
  end
  #--------------------------------------------------------------------------
  # * aggiorna il movimento di caduta
  #--------------------------------------------------------------------------
  def update_fall
    self.x += @direction
    self.y -= @speed
    @speed -= GRAVITY
  end
  #--------------------------------------------------------------------------
  # * determina se è uscito fuori dallo schermo
  #--------------------------------------------------------------------------
  def out_of_screen?; self.y > Graphics.height + 50; end
end

#===============================================================================
# ** Game_Interpreter
#-------------------------------------------------------------------------------
# inclusione di metodi facili per chiamare il fabbro da call script.
#===============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * apre il negozio del fabbro
  # @param [Symbol] blacksmith_name
  #--------------------------------------------------------------------------
  def open_forge(blacksmith_name)
    $game_temp.forge_shop = $game_temp.blacksmiths[blacksmith_name]
    SceneManager.call(Scene_Forge)
  end
end