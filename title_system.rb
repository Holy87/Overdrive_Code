module Titles
  LIST = {
      1 => ['Vagabondo','Ottenuto per aver viaggiato molto.'],
      2 => ['Cacciatore','Ottenuto per aver ucciso più di 100 volatili.'],
      3 => ['Esorcista','Ottenuto per aver ucciso più di 100 non-morti.'],
      4 => ['Ammazzadraghi','Ottenuto per aver ucciso più di 100 draghi.',2],
      5 => ['Incantatore estremo','Ottenuto per aver potenziato un\'arma al livello 10'],
      6 => ['Spendaccione','Ottenuto per aver speso più di X ai negozi.'],
      7 => ['Cercatore','Ottenuto per aver trovato tutti i gettoni kora-kora',2],
      8 => ['RPG2S Staff','Fai parte dello staff di RPG2S! Wow!',4],
      9 => ['Il devastatore','Ottenuto perché sei riuscito ad infliggere|99999 danni in un solo colpo!',3],
      10=> ['Fantallenatore','Ottenuto per aver conquistato tutte le Dominazioni.|Gotta catch\'em all!',2],
      11=> ['Solid Snake','Ottenuto per essere riuscito ad infiltrarti nell\'aereonave|senza essere stato scoperto.',2],
      12=> ['Alchimista d\'acciaio','Ottenuto per aver elaborato|oltre 1000 oggetti con l\'alchimia.',2],
      13=> ['Hitman','Ottenuto per aver ucciso il Ronin invece di reclutarlo.',3],
      14=> ['Creatore di Overdrive','Sei il mitico creatore Overdrive!',4],
      15=> ['Spaccatutto','Ottenuto per aver fatto fallire 10 incantamenti',2],
      16=> ['Stermina uccelli','Ottenuto per aver ucciso 500 volatili',2],
      17=> ['Ecatombe','Ottenuto per aver ucciso 500 non morti',2],
      18=> ['Sterminatore di draghi','Ottenuto per aver ucciso 500 draghi',3],
      19=> ['Eroe','Ottenuto per aver concluso la storia',2],
      20=> ['Distruttore','Ottenuto per aver ucciso 6 nemici|in un sol colpo.',2],
      21=> ['Speedrunner','Titolo conferito a chi riesce a completare|il gioco in meno di 20 ore.',3],
      22 => ['Pivello','Per chi è alle prime armi'],
      23 => ['Avventuriero','Titolo conferito a chi esplora almeno un dungeon'],
      24 => ['Ammazzaslime','Titolo conferito a chi uccide almeno 200 Slime'],
      26 => ['Protettore','Titolo conferito a chi ha protetto la città da un\'invasione'],
      27 => ['Evocatore','Titolo conferito a chi ha ottenuto la sua prima Dominazione'],
  }

  def self.get_title(title_id)
    return nil if title_id.nil? or !LIST.include?(title_id)
    desc = LIST[title_id]
    type = desk[2] ? desc[2] : 1
    Player_Title.new(title_id, desc[0], desc[1], type)
  end
end

class Player_Title
  attr_reader :name
  attr_reader :description
  attr_reader :id
  attr_reader :type
  # @param [Integer] id
  # @param [String] name
  # @param [String] description
  # @param [Symbol] type
  def initialize(id, name, description, type)
    @id = id
    @name = name
    @description = description
    @type = type
  end
end