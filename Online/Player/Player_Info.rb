module PlayerInfo_Settings
  V_NAME = 'Nome'
  V_PNTS = 'Punti'
  V_BORD = 'Classifica'
  V_NO_C = 'Non class.'
  V_PTME = 'Giocato per un totale di %d ore e %d minuti.'
  V_STOR = 'Storia'
  V_QUES = 'Missioni'
  V_FAME = 'Fama'
  V_INFM = 'Infamia'
  V_TITL = 'Titolo'
  V_NOTT = 'Nessun titolo'
end

#===============================================================================
# ** Vocab
#===============================================================================
module Vocab
  def self.pi_name
    PlayerInfo_Settings::V_NAME
  end

  def self.pi_points
    PlayerInfo_Settings::V_PNTS
  end

  def self.pi_board
    PlayerInfo_Settings::V_BORD
  end

  def self.pi_not_classified
    PlayerInfo_Settings::V_NO_C
  end

  def self.pi_playtime
    PlayerInfo_Settings::V_PTME
  end

  def self.pi_storyboard
    PlayerInfo_Settings::V_STOR
  end

  def self.pi_quests
    PlayerInfo_Settings::V_QUES
  end

  def self.fame
    PlayerInfo_Settings::V_FAME
  end

  def self.infame
    PlayerInfo_Settings::V_INFM
  end

  def self.player_title
    PlayerInfo_Settings::V_TITL
  end

  def self.player_notitle
    PlayerInfo_Settings::V_NOTT
  end
end

#===============================================================================
# ** Window_PlayerInfo
#===============================================================================
class Window_PlayerInfo < Window_Base

  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] w  larghezza della finestra
  def initialize(x, y, w)
    super(x, y, w, fitting_height(5))
    refresh
  end

  # Refresh
  def refresh
    contents.clear
    return unless player
    draw_avatar(player.avatar, 0, 0)
    draw_actor_level(player, 0, line_height * 4)
    draw_basic_info(100, 0, contents.width - 100)
    draw_play_data(100, 1, contents.width - 100)
    draw_exp_and_gold(100, 3, contents_width - 100)
    draw_fame_data(100, 4, contents.width - 100)
  end

  def update
    super
    update_cancel_handler
  end

  # Disegna le informazioni principali
  # @param [Integer] x
  # @param [Integer] line
  # @param [Integer] width
  def draw_basic_info(x, line, width)
    draw_player_name(x, line)
    draw_player_title(x, line, width)
  end

  def draw_player_name(x, line)
    change_color normal_color
    draw_text(x, line_height * line, contents_width, line_height, player.name)
  end

  # Disegna il titolo dell'eroe
  def draw_player_title(x, line, width = contents_width)
    return if player.title.nil?
    y = line_height * line
    x += text_size(player.name).width
    draw_text(x, y, width, line_height, ' - ')
    x += text_size(' - ').width
    if player.title.nil?
      change_color(normal_color, false)
      text = Vocab::player_notitle
    else
      text = player.title.name
      change_color(title_color(player.title.type))
    end
    draw_text(x, y, width, line_height, text)
    change_color normal_color
  end

  # Disegna i dati di gioco principali
  # @param [Integer] x
  # @param [Integer] line
  # @param [Integer] width
  def draw_play_data(x, line, width)
    y = line * line_height
    draw_playtime(x, y, width)
    max_story = $game_system.max_story
    draw_data_gauge(x, y + line_height, width / 2, Vocab::pi_storyboard, player.storymode, max_story, :percentage)
    x2 = x + width / 2
    w2 = width / 2
    #TODO: impostare il numero massimo di quest come da scritpt delle missioni
    draw_data_gauge(x2, y + line_height, w2, Vocab::pi_quests, player.quests, 50, :divisor)
  end

  def draw_exp_and_gold(x, line, width)
    y = line * line_height
    x2 = x + width / 2
    w2 = width / 2
    #noinspection RubyResolve
    draw_data(x, y, width / 2, Vocab.exp_a, player.exp)
    draw_data(x2, y, w2, Icon.gold, player.gold)
  end

  # @param [Method] method
  def set_cancel_handler(method)
    @cancel_handler = method
  end

  def update_cancel_handler
    return unless open?
    return unless @cancel_handler
    call_cancel_handler if Input.trigger?(:B)
  end

  def call_cancel_handler
    close
    Sound.play_cancel
    Input.update
    @cancel_handler.call
  end

  # Disegna il tempo di gioco
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_playtime(x, y, width)
    #draw_bg_rect(x, y, width, line_height)
    desc = Vocab::pi_playtime
    text = sprintf(desc, player.hours, player.minutes)
    draw_text(x, y, width, line_height, text, 1)
  end

  # Disegna i dati di fama e infamia
  # @param [Integer] x
  # @param [Integer] line
  # @param [Integer] width
  def draw_fame_data(x, line, width)
    y = line * line_height
    draw_fame(x, y, width / 2)
    draw_infame(x + width / 2, y, width / 2)
  end

  # Disegna la fama del giocatore
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_fame(x, y, width)
    draw_data_gauge(x + 1, y, width - 2, Vocab::fame, player.fame, 100, :number)
  end

  # Disegna l'infamia del giocatore
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  def draw_infame(x, y, width)
    draw_data_gauge(x, y, width, Vocab::infame, player.infame, 100, :number)
  end

  # Disegna la barra di completamento per i dati
  # @param [Integer] x			coordinata Y
  # @param [Integer] y			coordinata X
  # @param [Integer] width	larghezza
  # @param [String] header  titolo del parametro
  # @param [Number] value   valore del parametro
  # @param [Number] max     valore massimo del parametro
  # @param [Symbol] type  se è mostrato in percentuale
  def draw_data_gauge(x, y, width, header, value, max = 1, type = :divisor)
    x += 5
    width -= 10
    #draw_bg_rect(x + 1, y - 2, width, line_height)
    draw_line(x, y + line_height - 1, width)
    change_color(system_color)
    draw_text(x, y, width, line_height, header)
    change_color(normal_color)
    case type
    when :divisor
      text = sprintf('%d/%d', value, max)
    when :percentage
      text = sprintf('%02d%%', value.to_f / max.to_f * 100)
    when :number
      text = value
    else
      text = value
    end
    x2 = x + width / 2
    w2 = width / 2
    draw_gauge_b(x2, y - 1, w2, 10, value, max)
    draw_text(x2, y, w2, line_height, text, 1)
  end

  # Disegna i dati di un determinato parametro
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [String, Fixnum] header      # titolo
  # @param [String,Integer,Number] text # testo
  def draw_data(x, y, width, header, text)
    x += 5
    width -= 5
    draw_line(x, y + line_height - 1, width)
    #draw_bg_rect(x + 1 , y, width - 2, line_height)
    if header.is_a? String
      change_color(system_color)
      draw_text(x, y, width, line_height, header)
    else
      draw_icon(header, x, y)
    end
    change_color(normal_color)
    draw_text(x, y, width, line_height, text, 2)
  end

  # @param [Fixnum] x
  # @param [Fixnum] y
  # @param [Fixnum] width
  # @param [Fixnum] thickness
  # @param [Color] color
  def draw_line(x, y, width, thickness = 1, color = sc1)
    contents.fill_rect(x, y, width, thickness, color)
  end

  # Imposta il giocatore
  # @param [Online_Player] new_player
  def player=(new_player)
    @player = new_player
    refresh
  end

  # Restituisce il giocatore
  # @return [Online_Player]
  def player
    @player
  end
end