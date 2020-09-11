module Player_Titles
  LIST = {
      1  => ['Vagabondo','Ottenuto per aver viaggiato molto.'],
      2  => ['Cacciatore','Ottenuto per aver ucciso più di 100 volatili.'],
      3  => ['Esorcista','Ottenuto per aver ucciso più di 100 non-morti.'],
      4  => ['Ammazzadraghi','Ottenuto per aver ucciso più di 100 draghi.',2],
      5  => ['Incantatore estremo','Ottenuto per aver potenziato un\'arma al livello 10'],
      6  => ['Spendaccione','Ottenuto per aver speso più di 1.000.000 ai negozi.'],
      7  => ['Cercatore','Ottenuto per aver trovato tutti i gettoni kora-kora',2],
      8  => ['RPG2S Staff','Fai parte dello staff di RPG2S! Wow!',4],
      9  => ['Devastatore','Ottenuto perché sei riuscito ad infliggere|99.999 danni in un solo colpo!',3],
      10 => ['Fantallenatore','Ottenuto per aver conquistato tutte le Dominazioni.|Gotta catch\'em all!',2],
      11 => ['Serpente Solido','Ottenuto per essere riuscito ad infiltrarti nell\'aereonave|senza essere stato scoperto.',2],
      12 => ['Alchimista d\'acciaio','Ottenuto per aver elaborato|oltre 1000 oggetti con l\'alchimia.',2],
      13 => ['Hitman','Ottenuto per aver ucciso il Ronin invece di reclutarlo.',3],
      14 => ['Creatore di Overdrive','Sei il mitico creatore Overdrive!',4],
      15 => ['Spaccatutto','Ottenuto per aver fatto fallire 10 incantamenti',2],
      16 => ['Stermina uccelli','Ottenuto per aver ucciso 500 volatili',2],
      17 => ['Ecatombe','Ottenuto per aver ucciso 500 non morti',2],
      18 => ['Sterminatore di draghi','Ottenuto per aver ucciso 500 draghi',3],
      19 => ['Eroe','Ottenuto per aver concluso la storia',2],
      20 => ['Distruttore','Ottenuto per aver ucciso 6 nemici|in un sol colpo.',2],
      21 => ['Speedrunner','Titolo conferito a chi riesce a completare|il gioco in meno di 20 ore.',3],
      22 => ['Pivello','Per chi è alle prime armi'],
      23 => ['Avventuriero','Titolo conferito a chi esplora almeno un dungeon'],
      24 => ['Ammazzaslime','Titolo conferito a chi uccide almeno 200 Slime'],
      26 => ['Protettore','Titolo conferito a chi ha protetto la città da un\'invasione'],
      27 => ['Evocatore','Titolo conferito a chi ha ottenuto la sua prima Dominazione'],
      28 => ['Guru delle personalizzazioni','Titolo conferito a chi ha applicato abilità speciali ad|almeno 10 equipaggiamenti.'],

  }

  # crea il titolo dall'ID
  # @return [Player_Title]
  def self.get_title(title_id)
    return nil if title_id.nil? or !LIST.include?(title_id)
    desc = LIST[title_id]
    type = desc[2] ? desc[2] : 1
    Player_Title.new(title_id, desc[0], desc[1], type)
  end
end

class Player_Title
  # @return [String]
  attr_reader :name
  # @return [String]
  attr_reader :description
  # @return [Integer]
  attr_reader :id
  # @return [Integer]
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

class Game_System
  attr_accessor :current_title_id

  # restituisce il titolo selezionato
  # @return [nil,Player_Title]
  def current_title
    return nil if @current_title_id.nil?
    Player_Titles.get_title @current_title_id
  end

  # restituisce i titoli sbloccati
  # @return [Array<Player_Title>]
  def titles
    @titles ||= []
    @cached_titles ||= []
    @titles.collect{|title_id| Player_Titles.get_title(title_id)}
  end

  # sblocca il titolo al giocatore
  def unlock_title(title_id)
    @titles ||= []
    @cached_titles ||= []
    return if @titles.include?(title_id)
    @titles.push(title_id)
    @cached_titles.push(title_id)
  end

  # @return [Array<Integer>]
  def online_titles
    response = Online.get(:player, :titles, {:player_id => @player_id})
    return [] unless response.ok?
    JSON.decode(response.body).map{|title_id| title_id.to_i }
  end

  def refresh_titles
    return unless can_upload?
    @titles |= online_titles
  end

  def upload_titles
    return unless can_upload?
    @cached_titles ||= {}
    return if @cached_titles.empty?
    params = {
        :player_id => @player_id,
        :game_token => game_token,
        :title_ids => @cached_titles * ','
    }
    response = Online.upload(:player, :titles, params)
    @cached_titles.clear if response.ok?
  end
end

class Window_PlayerTitles < Window_Selectable
  def initialize(x, y, width, height)
    super(x, y, width, height)
    refresh
  end

  def refresh
    super
    contents.clear
    make_item_list
    draw_all_items
  end

  def make_item_list
    @data = $game_system.titles
  end

  def item_max
    @data ? @data.size : 0
  end

  def col_max
    1
  end

  def title_color(title_type)
    case title_type
    when 1
      normal_color
    when 3
      crisis_color
    when 4
      power_down_color
    else
      normal_color
    end
  end

  def update_help
    @help_window.set_item(@data[index])
  end

  def draw_item(index)
    title = @data[index]
    rect = item_rect(index)
    change_color title_color(title.type)
    draw_text(rect, title.name)
  end
end