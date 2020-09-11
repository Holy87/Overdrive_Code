module Online
  module Settings
    NO_PLAYER_VOCAB = 'Giocatore non trovato.'
    WRONG_DATA_VOCAB = 'Errore del server.'
    CONN_ERROR_VOCAB = 'Errore di connessione. Potrebbe essere un problema di server o della tua linea.'
    ACTIVATION_SWITCH = 426
  end

  NO_CONNECTION = 'NOCONN'

  WRONG_DATA = '-1'
  NO_PLAYER = '0'
  CONN_ERROR = ''
  SUCCESS = '1'

  # Costanti per registrazione personaggio
  VALID = '0'
  NAME_ALREADY_PRESENT = '1'
  NAME_WORD_FORBIDDEN = '2'
  SPECIAL_CHARACTER_NOT_ALLOWED = '3'
  CREATION_ERROR = '5'

  # Percorso directory contenenti le chiamate alle azioni
  def self.api_path
    HTTP.domain + '/api/'
  end

  # ottiene la risposta dal server di Overdrive
  # @param [Symbol] resource
  # @param [Symbol] action
  # @param [Hash] params
  # @return [HTTP::Response]
  def self.get(resource, action, params = {})
    HTTP.get(HTTP.domain + "#{resource}/#{action}.json", params)
  end

  # carica dati sul server di Overdrive
  # @param [Symbol] resource
  # @param [Symbol] action
  # @param [Hash] params
  # @return [HTTP::Response]
  def self.upload(resource, action, params = {})
    HTTP.post(HTTP.domain + "#{resource}/#{action}.json", params)
  end

  # determina se la componente online è abilitata
  def self.enabled?
    $game_variables[Online::Settings::ACTIVATION_SWITCH]
  end

  # determina se il nome è valido per la registrazione. Lancia ConnectionException
  # se non c'è connessione.
  # @param [String] name
  # @return [String]
  def self.check_name_valid(name)
    response = get :player, :check_name_valid, {:name => name}
    raise ConnectionException(response.code) unless response.ok?
    response.body
  end

  # Registra il giocatore e restituisce un hash con questi attributi:
  # * status: true se registrato, false altrimenti
  # * motive: solo se status è false, il motivo del rifiuto
  # * message: solo se status è false, un messaggio aggiuntivo
  # * player_id: solo se status è true, l'ID del giocatore creato
  # @param [String] name
  # @param [Integer] face
  # @return [Hash]
  def self.register_new_player(name, face)
    return if $game_system.user_registered?
    data = {:name => name, :face_id => face, :game_token => $game_system.game_token}
    response = upload :player, :create, data
    return JSON.decode(response.body) if response.ok?
    raise ConnectionException(NO_CONNECTION) if response.body == 0
    raise ConnectionException(JSON.decode(response.body))
  end
end

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# Stringhe necessarie al gioco
#===============================================================================
module Vocab
  def self.no_player
    Online::Settings::NO_PLAYER_VOCAB
  end

  def self.wrong_player_data
    Online::Settings::WRONG_DATA_VOCAB
  end

  def self.connection_error
    Online::Settings::CONN_ERROR_VOCAB
  end
end
# - SCRIPT DI BASE PER L'ONLINE


class ConnectionException < Exception
end