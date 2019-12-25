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
	V_NOTT = 'Nessuno'
end

#===============================================================================
# ** Vocab
#===============================================================================
module Vocab
	def self.pi_name; PlayerInfo_Settings::V_NAME; end
	def self.pi_points; PlayerInfo_Settings::V_PNTS; end
	def self.pi_board; PlayerInfo_Settings::V_BORD; end
	def self.pi_not_classified; PlayerInfo_Settings::V_NO_C; end
	def self.pi_playtime; PlayerInfo_Settings::V_PTME; end
	def self.pi_storyboard; PlayerInfo_Settings::V_STOR; end
	def self.pi_quests; PlayerInfo_Settings::V_QUES; end
	def self.fame; PlayerInfo_Settings::V_FAME; end
	def self.infame; PlayerInfo_Settings::V_INFM; end
	def self.player_title; PlayerInfo_Settings::V_TITL; end
	def self.player_notitle; PlayerInfo_Settings::V_NOTT; end
end

#===============================================================================
# ** Window_PlayerInf
#===============================================================================
class Window_PlayerInfo < Window_Base
	
  # Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] w  larghezza della finestra
	def initialize(x, y, w)
		super(x, y, w, fitting_height(6))
		refresh
	end
	
	# Refresh
	def refresh
		contents.clear
		return unless player
		draw_avatar(player.avatar, 0, 0)
		draw_basic_info(100, 0, contents.width - 100)
		draw_player_title(0, line_height * 2)
		draw_play_data(100, line_height * 3, contents.width - 100)
		draw_fame_data(0, line_height * 5, contents.width)
	end
	
	# Disegna le informazioni principali
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
	def draw_basic_info(x, y, width)
		change_color(system_color)
		xx = width/2
		draw_data(x, y, xx, Vocab::pi_name, player.name)
		draw_data(x+xx, y, xx, Vocab::level, player.level)
		draw_data(x, y+line_height, xx, Vocab::pi_points, player.points)
		draw_data(x+xx, y+line_height, xx, Vocab::pi_board, Vocab::pi_not_classified)
	end
	
	# Disegna il titolo dell'eroe
	def draw_player_title(x, y, width = contents_width)
		change_color(system_color)
		draw_text(x, y, width, line_height, Vocab::player_title)
		xx = text_width(Vocab::player_title) + 10
		ww = width - xx
		xx += x
		if player.title.nil?
			change_color(normal_color, false)
			text = Vocab::player_notitle
		else
			text = player.title.name
			case player.title.type
			when 1; change_color(normal_color)
			when 2; change_color(crisis_color)
			when 3; change_color(knockout_color)
			when 4; change_color(power_up_color)
			else;		change_color(normal_color)
			end
		end
		draw_text(xx, y, ww, line_height, text)
	end

	# Disegna i dati di gioco principali
	# @param [Integer] x
	# @param [Integer] y
	# @param [Integer] width
	def draw_play_data(x, y, width)
		draw_playtime(x, y, width)
		max_story = $game_system.max_story
		draw_data_gauge(x,y+line_height,width/2,Vocab::pi_storyboard,player.storymode,max_story)
		x2 = x + width/2
		w2 = width/2
		draw_data_gauge(x2,y+line_height,w2,Vocab::pi_quests,player.quests, 50, true)
	end

	# Disegna il tempo di gioco
	# @param [Integer] x
	# @param [Integer] y
	# @param [Integer] width
	def draw_playtime(x, y, width)
		draw_bg_rect(x, y, width, line_height)
		desc = Vocab::pi_playtime
		text = sprintf(desc, player.playtime[:h], player.playtime[:m])
		draw_text(x, y, width, line_height, text, 1)
	end
	
	# Disegna i dati di fama e infamia
	# @param [Integer] x
	# @param [Integer] y
	# @param [Integer] width
	def draw_fame_data(x, y, width)
		draw_fame(x, y, width/2-5)
		draw_infame(x + width/2+5, y, width/2)
	end
	
	# Disegna la fama del giocatore
	# @param [Integer] x
	# @param [Integer] y
	# @param [Integer] width
	def draw_fame(x, y, width)
		draw_bg_rect(x, y, width, line_height)
		tx = Vocab::fame; color = mp_gauge_color1
		draw_gauge_b(x+5, y, width-10, line_height, player.fame, 100,
							 color, color)
		draw_text(x+5, y, text_width(tx), line_height, tx)
		draw_text(x+5, y, width-5, line_height, player.fame, 1)
	end
	
	# Disegna l'infamia del giocatore
	# @param [Integer] x
	# @param [Integer] y
	# @param [Integer] width
  def draw_infame(x, y, width)
		draw_bg_rect(x, y, width, line_height)
		tx = Vocab::infame; color = hp_gauge_color1
		draw_gauge_b(x+5, y, width-10, line_height, player.infame, 100,
							 color, color)
		draw_text(x+5, y, text_width(tx), line_height, tx)
		draw_text(x+5, y, width-5, line_height, player.infame, 1)
	end
	
	# Disegna la barra di completamento per i dati
  # @param [Integer] x			coordinata Y
  # @param [Integer] y			coordinata X
  # @param [Integer] width	larghezza
  # @param [String] header  titolo del parametro
  # @param [Number] value   valore del parametro
  # @param [Number] max     valore massimo del parametro
  # @param [Boolean] divsr  se è mostrato in percentuale
  def draw_data_gauge(x, y, width, header, value, max, divsr = false)
		draw_bg_rect(x, y, width, line_height)
		change_color(system_color)
		draw_text(x, y, width, line_height, header)
		change_color(normal_color)
		if divsr
			text = sprintf('%d/%d', value, max)
		else
			text = sprintf('%02d%%', value.to_f/max.to_f*100)
		end
		x2 = x + width/2
		w2 = width/2
		draw_gauge(x2+5, y+5, w2-10, line_height-10, value, max)
		draw_text(x2+5, y, w2-10, line_height, text, 1)
	end
	
	# Disegna la barra di sfondo al parametro
	#     x: coordinata X
	#     y: coordinata Y
	#     width: larghezza
	#     height: altezza
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Color] color
  def draw_bg_rect(x, y, width, height, color = sc1)
		contents.fill_rect(x+1, y+1, width-2, height-2, color)
	end
	
	# Colore di sfondo 1
  # @return [Color]
  def sc1
		c = gauge_back_color
		c.alpha = 75
		c
	end
	
	# Colore di sfondo 2
  # @return [Color]
	def sc2
		c = gauge_back_color
		c.alpha = 150
		c
	end
	
	# Disegna i dati di un determinato parametro
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [String] header      # titolo
  # @param [String] text        # testo
  def draw_data(x, y, width, header, text)
		draw_bg_rect(x, y, width, line_height)
		change_color(system_color)
		draw_text(x+5, y, width-10, line_height, header)
		change_color(normal_color)
		draw_text(x+5, y, width-10, line_height, text, 2)
	end
	
	# Imposta il giocatore
  # @param [Online_Player] new_player
  def player=(new_player)
		@player = new_player
		refresh
	end
	
	# Restituisce il giocatore
  # @return [Online_Player]
  def player; @player; end
end