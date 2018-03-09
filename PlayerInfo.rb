require File.expand_path('rm_vx_data')

#===============================================================================
# ** Window_PlayerInfo
#-------------------------------------------------------------------------------
# Finestra che mostra le informazioni su un giocatore
#===============================================================================
class Window_PlayerInfo < Window_Base
	#--------------------------------------------------------------------------
	# * Inizializzazione
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] w  larghezza della finestra
	#--------------------------------------------------------------------------
	def initialize(x, y, w)
		super(x, y, w, fitting_height(5))
		refresh
	end
	#--------------------------------------------------------------------------
	# * Refresh
	#--------------------------------------------------------------------------
	def refresh
		contents.clear
		return unless player
		draw_avatar(player.avatar, 0, 0)
		draw_basic_info(100, 0, contents.width - 100)
		draw_play_data(100, line_height * 2, contents.width - 100)
		draw_fame_data(0, line_height * 4, contents.width)
	end
	#--------------------------------------------------------------------------
	# * Disegna le informazioni principali
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
	#--------------------------------------------------------------------------
	def draw_basic_info(x, y, width)
		change_color(system_color)
		xx = width/2
		draw_data(x, y, xx, 'Nome', player.name)
		draw_data(x+xx, y, xx, 'Livello', player.level)
		draw_data(x, y+line_height, xx, 'Punteggio', player.points)
		draw_data(x+xx, y+line_height, xx, 'Classifica', 'Non class.')
	end
	#--------------------------------------------------------------------------
	# * Disegna i dati di gioco principali
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
	#--------------------------------------------------------------------------
	def draw_play_data(x, y, width)
		draw_playtime(x, y, width)
		max_story = $game_system.max_story
		draw_data_gauge(x,y+line_height,width/2,'Storia',player.storymode,max_story)
		x2 = x + width/2
		w2 = width/2
		draw_data_gauge(x2,y+line_height,w2,'Missioni',player.quests, 50, true)
	end
	#--------------------------------------------------------------------------
	# * Disegna il tempo di gioco
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
	#--------------------------------------------------------------------------
	def draw_playtime(x, y, width)
		draw_bg_rect(x, y, width, line_height)
		desc = 'Giocato per un totale di %d ore e %d minuti.'
		text = sprintf(desc, player.playtime[:h], player.playtime[:m])
		draw_text(x, y, width, line_height, text, 1)
	end
	#--------------------------------------------------------------------------
	# * Disegna i dati di fama e infamia
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
	#--------------------------------------------------------------------------
	def draw_fame_data(x, y, width)
		draw_fame(x, y, width/2-5)
		draw_infame(x + width/2+5, y, width/2)
	end
	#--------------------------------------------------------------------------
	# * Disegna la fama del giocatore
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
	#--------------------------------------------------------------------------
	def draw_fame(x, y, width)
		draw_bg_rect(x, y, width, line_height)
		tx = 'Fama'; color = mp_gauge_color1
		draw_gauge_b(x+5, y, width-10, line_height, player.fame, 100,
							 color, color)
		draw_text(x+5, y, text_width(tx), line_height, tx)
		draw_text(x+5, y, width-5, line_height, player.fame, 1)
	end
	#--------------------------------------------------------------------------
	# * Disegna l'infamia del giocatore
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
	#--------------------------------------------------------------------------
  def draw_infame(x, y, width)
		draw_bg_rect(x, y, width, line_height)
		tx = 'Infamia'; color = hp_gauge_color1
		draw_gauge_b(x+5, y, width-10, line_height, player.infame, 100,
							 color, color)
		draw_text(x+5, y, text_width(tx), line_height, tx)
		draw_text(x+5, y, width-5, line_height, player.infame, 1)
	end
	#--------------------------------------------------------------------------
	# * Disegna la barra di completamento per i dati
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [String] header  # titolo del parametro
  # @param [Number] value   # valore del parametro
  # @param [Number] max     # valore massimo del parametro
  # @param [Boolean] divsr  # se è mostrato in percentuale
	#--------------------------------------------------------------------------
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
	#--------------------------------------------------------------------------
	# * Disegna la barra di sfondo al parametro
	#     x: coordinata X
	#     y: coordinata Y
	#     width: larghezza
	#     height: altezza
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Color] color
	#--------------------------------------------------------------------------
  def draw_bg_rect(x, y, width, height, color = sc1)
		contents.fill_rect(x+1, y+1, width-2, height-2, color)
	end
	#--------------------------------------------------------------------------
	# * Colore di sfondo 1
  # @return [Color]
	#--------------------------------------------------------------------------
  def sc1
		c = gauge_back_color
		c.alpha = 75
		c
	end
	#--------------------------------------------------------------------------
	# * Colore di sfondo 2
  # @return [Color]
	#--------------------------------------------------------------------------
	def sc2
		c = gauge_back_color
		c.alpha = 150
		c
	end
	#--------------------------------------------------------------------------
	# * Disegna i dati di un determinato parametro
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [String] header      # titolo
  # @param [String] text        # testo
	#--------------------------------------------------------------------------
  def draw_data(x, y, width, header, text)
		draw_bg_rect(x, y, width, line_height)
		change_color(system_color)
		draw_text(x+5, y, width-10, line_height, header)
		change_color(normal_color)
		draw_text(x+5, y, width-10, line_height, text, 2)
	end
	#--------------------------------------------------------------------------
	# * Imposta il giocatore
  # @param [Online_Player] new_player
	#--------------------------------------------------------------------------
  def player=(new_player)
		@player = new_player
		refresh
	end
	#--------------------------------------------------------------------------
	# * Restituisce il giocatore
  # @return [Online_Player]
	#--------------------------------------------------------------------------
  def player; @player; end
end