#===============================================================================
# ** Chest_Core
#-------------------------------------------------------------------------------
# Contiene i metodi di collegamento base con il server.
#===============================================================================
module Chest_Service
  # Regola del nome dello scrigno
  CHEST_REGX = /<mc:[ ]+(.+),(\d+)>/i

  # stato dello scrigno
  CHEST_EMPTY = 100
  CHEST_FULL = 101
  FILLED = 105
  NOT_FILLED = 106
  PLAYER_SAME = 107
  TOKEN_ERROR = 108
  DATA_ERROR = 110

  NORMAL_CHEST = -2
  FAME = 0
  INFAME = 1
  # Controllo online dello stato (vuoto o pieno)
  #    chest_key: ID dello scrigno
  # @param [String] chest_key
  # @return [Integer]: CHEST_FULL, CHEST_EMPTY o DATA_ERROR se errore
  def self.get_online_state_chest(chest_key)
    return DATA_ERROR unless $game_system.can_upload?
    begin
      response = Online.get(:chest, :check, {:chest => chest_key})
      if [CHEST_FULL, CHEST_EMPTY].include?(response.body.to_i)
        return response.body.to_i
      else
        return DATA_ERROR
      end
    rescue => error
      Logger.error(error.class, error.message)
      return DATA_ERROR
    end
  end

  # Tenta di prendere l'oggetto dallo scrigno online.
  # @param [String] chest_id ID dello scrigno
  # @return [Online_Chest]
  def self.loot_chest(chest_id)
    open = Online.upload(:chest, :open, {:chest => chest_id})
    if open.success?
      begin
        Online_Chest.new(open.result)
      rescue => exception
        Logger.error(exception.class)
        Logger.error(exception.message)
        Online_Chest.new(Online::DATA_ERROR)
      end
    else
      Online_Chest.new(open.error_code)
    end
  end

  # Restituisce le informazioni dell'evento dello scrigno magico.
  #    event_name: nome dell'evento
  # Restituisce nil se è uno crigno normale
  # @return [Local_Chest, nil]
  def self.map_chest_info(event_name)
    return Local_Chest.new($1, $2.to_i) if event_name =~ CHEST_REGX
    nil
  end

  # Invia un feedback al giocatore che ha messo l'oggetto nello srigno.
  #    type: tipo di feedback (0: fama, 1: infamia)
  #    chest: scrigno che contiene nome e token. Il token è una stringa di
  #     20 caratteri generata casualmente dal server per fare in modo che
  #     non possa ricevere feedback infiniti.
  # @param [Integer] type
  # @param [Online_Chest] chest
  def self.send_feedback(type, chest)
    params = {
        :token => chest.token,
        :type => type
    }
    operation = Online.upload(:chest, :feedback, params)
    unless operation.success?
      Logger.warning sprintf('Send Feedback failed. Reason: %d', operation.error_code)
    end
    operation.success?
  end

  # Richiede al server di aggiungere un oggetto allo scrigno.
  #    item: ogggetto
  #    la risposta viene memorizzata in $game_temp.chest.response,
  # ed è una delle costanti di risposta
  # @param [RPG::BaseItem] item
  # @throws [InternetConnectionException]
  # @return [Fixnum]
  def self.request_fill(item)
    params = {
        :item_type => get_type(item),
        :item_id => item.id,
        :chest => $game_temp.chest.name
    }
    fill = Online.upload(:chest, :fill, params)
    if fill.success?
      $game_temp.chest.response = fill.result
      $game_temp.chest.item = item
      fill.result
    else
      $game_temp.chest.response = fill.error_code
      fill.error_code
    end
  end

  # Ottiene un valore da 1 a 3 a seconda del tipo di oggetto
  # @param [RPG::BaseItem] item
  # @return [Integer]
  def self.get_type(item)
    case item
    when RPG::Item;
      type = 1
    when RPG::Weapon;
      type = 2
    when RPG::Armor;
      type = 3
    else
      type = 0
    end
    type
  end
end