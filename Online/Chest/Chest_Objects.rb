#===============================================================================
# ** Online_Chest
#-------------------------------------------------------------------------------
# Classe che contiene le informazioni online dello scrigno.
#===============================================================================
class Online_Chest
  attr_reader :item_type #tipo oggetto
  # @return [Online_Player]
  attr_reader :player #giocatore online
  attr_reader :item_id #ID dell'oggetto
  attr_reader :token #token per il feedback
  attr_reader :id
  attr_reader :chest_name
  # Inizializzazione
  # @param [Hash, Fixnum] data
  def initialize(data)
    @id = 0
    @item_id = 0
    @data_ok = false
    @chest_name = ''
    if data.is_a?(Hash)
      @id = data['chest_id']
      @chest_name = data['chest_name']
      @item_id = data['item']['item_id']
      @item_type = data['item']['item_type']
      @token = data['token']
      #noinspection RubyYardParamTypeMatch
      @player = Online_Player.new(data['owner'])
      @data_ok = true
    elsif data.is_a?(Integer)
      @item_type = data
    end
  end

  # Restituisce l'oggetto
  # @return [RPG::Item, RPG::Armor, RPG::Weapon, nil]
  def item
    case @item_type
    when 1
      $data_items[@item_id]
    when 2
      $data_weapons[@item_id]
    when 3
      $data_armors[@item_id]
    else
      nil
    end
  end

  # Restituisce l'ID del gruppo di mostri
  def troop
    return 0 if @item_type != 1
    item.troop_id
  end

  # Restituisce true se l'oggetto è un mostro
  def monster?
    troop > 0
  end

  # @return [String]
  def player_name
    return '' if @player.nil?
    self.player.name
  end

  def of_same_player?
    @item_type == Chest_Service::PLAYER_SAME
  end

  # determina se lo scrigno contiene qualcosa
  def full?
    !empty?
  end

  def empty?
    @item_type == Chest_Service::CHEST_EMPTY
  end

  def ok?
    @data_ok
  end
end

#===============================================================================
# ** Local_Chest
#-------------------------------------------------------------------------------
# Classe che contiene le informazioni dell'evento dello scrigno.
#===============================================================================
class Local_Chest
  attr_reader :name #nome dello scrigno
  attr_reader :level #livello dello scrigno
  attr_accessor :response #risposta dello scrigno
  attr_accessor :item #oggetto da scalare
  # Inizializzazione
  #     name: nome dello scrigno
  #     level: livello dello scrigno (per limitare gli oggetti)
  def initialize(name, level)
    @name = name
    @level = level
    @response = nil
  end

  # Restituisce true se l'utente non è registrato
  def not_reg
    self.response.to_i == Online::PLAYER_UNREGISTERED;
  end

  # Restituisce true se è stato bannato
  def banned?
    self.response.to_i == Online::PLAYER_BANNED;
  end

  # Restituisce true se l'oggetto è stato inserito nello scrigno
  def fill_ok?
    self.response == Chest_Service::FILLED
  end

  # Restituisce true se l'oggetto non è stato riempito (perché pieno)
  def not_filled?
    self.response == Chest_Service::NOT_FILLED;
  end
end