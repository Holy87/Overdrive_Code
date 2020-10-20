module Player_Titles

  NO_TITLE = 'Nessun titolo'
  NO_TITLE_DESCR = 'Non selezionare alcun titolo'
  TITLE_OBTAINED = 'Hai ottenuto il titolo di %s!'
  POPUP_TONE = Tone.new(100, 0, 80, 50)

  LIST = {
      1  => ['Giramondo','Ottenuto per aver viaggiato molto.'],
      2  => ['Cacciatore','Ottenuto per aver ucciso più di 100 volatili e belve.'],
      3  => ['Esorcista','Ottenuto per aver ucciso più di 100 non-morti.'],
      4  => ['Ammazzadraghi','Ottenuto per aver ucciso più di 100 draghi.',2],
      5  => ['Incantatore estremo','Ottenuto per aver potenziato un\'arma al livello 10'],
      6  => ['Spendaccione','Ottenuto per aver speso più di 1.000.000 ai negozi.'],
      7  => ['Collezionista','Ottenuto per aver trovato tutti i gettoni kora-kora',2],
      8  => ['RPG2S Staff','Fai parte dello staff di RPG2S! Wow!',4],
      9  => ['Devastatore','Ottenuto perché sei riuscito ad infliggere|99.999 danni in un solo colpo!',3],
      10 => ['Fantallenatore','Ottenuto per aver conquistato tutte le Dominazioni.|Gotta catch\'em all!',2],
      11 => ['Serpente Solido','Ottenuto per essere riuscito ad infiltrarti nell\'aereonave|senza essere stato scoperto.',2, true],
      12 => ['Alchimista d\'acciaio','Ottenuto per aver elaborato|oltre 1000 oggetti con l\'alchimia.',2],
      13 => ['Hitman','Ottenuto per aver ucciso il Ronin invece di reclutarlo.',3, true],
      14 => ['Creatore di Overdrive','Sei il mitico creatore Overdrive!',4],
      15 => ['Spaccatutto','Ottenuto per aver fatto fallire 10 incantamenti',2],
      16 => ['Stermina uccelli','Ottenuto per aver ucciso 1000 volatili e belve',2],
      17 => ['Ecatombe','Ottenuto per aver ucciso 500 non morti',2],
      18 => ['Sterminatore di draghi','Ottenuto per aver ucciso 500 draghi',3],
      19 => ['Eroe','Ottenuto per aver concluso la storia',2, true],
      20 => ['Distruttore','Ottenuto per aver ucciso 6 nemici|in un sol colpo.',2],
      21 => ['Speedrunner','Titolo conferito a chi riesce a completare|il gioco in meno di 20 ore.',3, true],
      22 => ['Pivello','Per chi è alle prime armi'],
      23 => ['Avventuriero','Titolo conferito a chi esplora almeno un dungeon'],
      24 => ['Ammazzaslime','Titolo conferito a chi uccide almeno 200 Slime'],
      26 => ['Protettore','Titolo conferito a chi ha protetto la città da un\'invasione'],
      27 => ['Evocatore','Titolo conferito a chi ha ottenuto la sua prima Dominazione'],
      28 => ['Guru delle personalizzazioni','Titolo conferito a chi ha applicato abilità speciali ad|almeno 10 equipaggiamenti.'],
      29 => ['Giocatore di vecchia data', 'Titolo conferito ha chi giocava da prima del Capitolo 4!',3],
      30 => ['Combattente','Titolo conferito a chi ha affrontato più|di 100 battaglie.'],
      31 => ['Veterano','Titolo conferito a chi ha affrontato più|di 1000 battaglie.',2],
      32 => ['Leggenda','Titolo conferito a chi ha affrontato più|di 10.000 battaglie.',3],
      33 => ['Mangiamorte',"Titolo conferito a chi trasforma i nemici in non-morti|per poi distruggerli con abilità specifiche.",2],
      34 => ['Maestro della Sinergia',"Titolo conferito a chi riempie 4 volte la Sinergia|in una singola battaglia."],
      35 => ['Cacciatore di taglie', "Titolo conferito a chi ha sconfitto più di 100 umani."],
      36 => ['Serial killer', "Titolo conferito agli psicopatici che hanno sconfitto|più di 1000 umani.", 2],
      37 => ['Beta Tester', "Titolo conferito a chi ha partecipato al beta test.", 3],
      38 => ['Cuore impavido', "Titolo conferito a chi ha sconfitto nemici molto|più forti di lui.", 2],
      39 => ['Supporter Overdrive', "Titolo conferito a chi ha donato per supportare|lo sviluppo del gioco. Grazie!",4, true],
      40 => ['Pantofolaio', "Titolo conferito per aver completato i lavori alla casa."],
      41 => ['Fabbro in erba', "Titolo conferito per aver forgiato più di 40 equipaggiamenti.",1],
      42 => ['Milionario',"Titolo conferito per essere riuscito ad arrivare|a 1.000.000 di monete."],
      43 => ['Coniglio', "Titolo conferito per essere fuggito spess dalle battaglie.|La ritirata tattica non è mai una vergogna!"],
      44 => ['Nerd', "Conferito per aver raggiunto le 80 ore di gioco!"],
      45 => ['Festaiolo',"Conferito per aver partecipato ad almeno un evento.",2]
  }

  # alcuni titoli possono essere sbloccati quando si conquista un nuovo obiettivo.
  BINDED_ACHIEVEMENTS = {
    #ID obiettivo -> ID titolo
    14 => 13, 21 => 40, 24 => 7, 25 => 41, 2 => 26, 12 => 42, 28 => 1, 8 => 43, 20 => 44
  }

  # @return [Player_Title]
  def self.no_title
    Player_Title.new(0, NO_TITLE, NO_TITLE_DESCR, 0)
  end

  # crea il titolo dall'ID
  # @return [Player_Title]
  def self.get_title(title_id)
    return no_title if title_id.nil? or !LIST.include?(title_id)
    desc = LIST[title_id]
    type = desc[2] != nil ? desc[2] : 1
    multi_save = desc[3].nil? ? false : desc[3]
    Player_Title.new(title_id, desc[0], desc[1], type, multi_save)
  end
end

#===============================================================================
# ** Player_Title
#-------------------------------------------------------------------------------
# Classe che mostra le informazioni sul titolo del giocatore
#===============================================================================
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
  # @param [Fixnum] type
  def initialize(id, name, description, type = 1, multi_save = false)
    @id = id
    @name = name
    @description = description
    @type = type
    @multi_save = multi_save
  end

  def global?
    @multi_save
  end
end

#===============================================================================
# ** Game_System
#===============================================================================
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
    @titles.collect{|title_id| Player_Titles.get_title(title_id)}.sort{|a, b| a.name <=> b.name}
  end

  # sblocca il titolo al giocatore
  def unlock_title(title_id, show_popup = true)
    @titles ||= []
    @cached_titles ||= []
    return if @titles.include?(title_id)
    @titles.push(title_id)
    @cached_titles.push(title_id)
    add_global_title(title_id) if Player_Titles.get_title(title_id).global?
    add_title_popup(title_id) if show_popup
  end

  def add_title_popup(title_id)
    title = Player_Titles.get_title title_id
    text = sprintf(Player_Titles::TITLE_OBTAINED, title.name)
    $game_map.stack_popup(text, Player_Titles::POPUP_TONE)
  end

  # ottiene i titoli sbloccati online
  # @return [Array<Integer>]
  def online_titles
    return [] unless can_upload?
    return [] unless Online.logged_in?
    begin
      response = Online.get(:player, :titles, {:player_id => @player_id})
    rescue
      return []
    end
    return [] unless response.ok?
    return [] unless response.json?
    response.decode_json.map{|title_id| title_id.to_i }
  end

  def global_titles
    return [] if $game_settings.nil?
    return [] if $game_settings[:titles].nil?
    $game_settings[:titles]
  end

  def refresh_titles
    online_titles.each { |title_id| unlock_title(title_id) }
    global_titles.each { |title_id| unlock_title(title_id, false) }
  end

  def upload_titles
    return unless can_upload?
    @cached_titles ||= {}
    return if @cached_titles.empty?
    params = {:title_ids => @cached_titles * ','}
    operation = Online.upload(:player, :titles, params)
    @cached_titles.clear if operation.success?
  end

  def add_global_title(title_id)
    $game_settings[:titles] = [] if $game_settings[:titles].nil?
    $game_settings[:titles].push(title_id) unless $game_settings[:titles].include?(title_id)
    $game_settings.save
  end
end

#===============================================================================
# ** Window_Base
#===============================================================================
class Window_Base < Window
  def title_color(title_type)
    case title_type
    when 0
      normal_color.deopacize
    when 1
      normal_color
    when 2
      crisis_color
    when 3
      hp_gauge_color2
    when 4
      power_down_color
    else
      normal_color
    end
  end
end

#===============================================================================
# ** Window_PlayerTitles
#-------------------------------------------------------------------------------
# Finestra che elenca i titoli sbloccati dal giocatore
#===============================================================================
class Window_PlayerTitles < Window_Selectable
  def initialize(x, y, width, height)
    super(x, y, width, height)
    refresh
  end

  def refresh
    super
    contents.clear
    make_item_list
    create_contents
    draw_all_items
  end

  def make_item_list
    @data = $game_system.titles + [Player_Titles.no_title]
  end

  def item_max
    @data ? @data.size : 0
  end

  # @return [Player_Title]
  def title
    @data[@index]
  end

  def set_index(title_id)
    self.index = find_index(title_id)
  end

  def find_index(title_id)
    @data.each_with_index do |title, index|
      return index if title.id == title_id
    end
    0
  end

  def col_max
    1
  end

  def update_help
    return unless @help_window
    @help_window.set_text('') if title.nil?
    #noinspection RubyYardParamTypeMatch
    @help_window.set_item(title)
  end

  def draw_item(index)
    title = @data[index]
    rect = item_rect(index)
    change_color title_color(title.type)
    draw_text(rect, title.name)
  end
end

#===============================================================================
# ** Game_Party
#===============================================================================
class Game_Party < Game_Unit
  alias h87_titles_add_defeated_enemy_type add_defeated_enemy_type unless $@

  def add_defeated_enemy_type(type, number = 1)
    h87_titles_add_defeated_enemy_type(type, number)
    $game_system.unlock_title(2) if defeated_enemies_type_count(22) + defeated_enemies_type_count(19) >= 100
    $game_system.unlock_title(3) if defeated_enemies_type_count(21) >= 100
    $game_system.unlock_title(4) if defeated_enemies_type_count(20) >= 100
    $game_system.unlock_title(16) if defeated_enemies_type_count(22) + defeated_enemies_type_count(19) >= 1000
    $game_system.unlock_title(17) if defeated_enemies_type_count(21) >= 500
    $game_system.unlock_title(18) if defeated_enemies_type_count(20) >= 500
    $game_system.unlock_title(35) if defeated_enemies_type_count(17) >= 100
    $game_system.unlock_title(35) if defeated_enemies_type_count(18) >= 1000
  end
end

module H87_Achievements
  class << self
    alias title_unlock_achievement unlock_achievement
  end

  def self.unlock_achievement(id)
    title_unlock_achievement(id)
    if Player_Titles::BINDED_ACHIEVEMENTS[id] != nil
      $game_system.unlock_title(Player_Titles::BINDED_ACHIEVEMENTS[id], false)
    end
  end
end

class Game_Battler
  alias h87_title_system_execute_damage execute_damage unless $@

  # @param [Game_Battler] user
  def execute_damage(user, no_action = false)
    h87_title_system_execute_damage(user, no_action)
    return if no_action
    if self.enemy? and user.actor?
      $game_system.unlock_title(9) if @hp_damage >= 99999
    end
  end
end