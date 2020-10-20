#===============================================================================
# ** Window_Save_Details
#-------------------------------------------------------------------------------
# Mostra i dettagli del salvataggio e viene gestita all'interno di Scene_File.
#===============================================================================
class Window_SaveDetails < Window_Base
  # Inizializzazione
  def initialize(x, y, width)
    super(x, y, width, 200)
  end

  # Cambio delle informazioni del salvataggio
  def update_header(header, save_number)
    return if @save_number == save_number
    @save_number = save_number
    @header = header
    extract_contents if @header
    refresh
  end

  # Restituisce le informazioni del salvataggio
  def header
    @header
  end

  # Aggiornamento
  def refresh
    self.contents.clear
    if @header.nil?
      write_clear_save
    else
      write_save_data
    end
  end
  
  def extract_contents
    @play_time = header[:playtime_s]
    @gold = header[:gold]
    @map_name = header[:map_name]
    @actors = header[:characters]
    @player = header[:player_name]
    @story = header[:story]
  end

  # Scrive il testo di un salvataggio vuoto
  def write_clear_save
    texts = Vocab.slot_empty_info.split("|")
    texts.each_with_index do |text, line|
      draw_text(0, line_height * line, contents_width, line_height, text)
    end
  end

  # Mostra i dati del salvataggio
  def write_save_data
    draw_player_name(0, 0)
    draw_save_date(contents_width / 2, 0)
    draw_gold(0, line_height)
    draw_story(0, line_height * 6)
    draw_missions(0, line_height * 5)
    draw_play_time(contents_width / 2, line_height)
    draw_party_members(0, line_height * 2)
    draw_location(0, line_height * 6)
  end

  # Disegna i membri del gruppo
  def draw_party_members(x, y)
    return if @actors.nil?
    @actors.each_with_index { |actor, i| draw_character_info(actor, x + (i * 96), y) }
  end

  # Disegna il nome del giocatore
  def draw_player_name(x, y)
    change_color system_color
    draw_text(x, y, contents_width - x, line_height, Vocab.player_name)
    change_color normal_color
    xx = contents.text_size(Vocab.player_name).width
    draw_text(x + xx, y, contents_width - xx - x, line_height, @player)
  end

  # Disegna la data di salvataggio
  def draw_save_date(x, y)
    save_date = DataManager.savefile_time_stamp(@save_number)
    change_color system_color
    draw_text(x, y, contents_width - x, line_height, Vocab.save_date)
    xx = contents.text_size(Vocab.save_date).width
    change_color normal_color
    draw_text(x + xx, y, contents_width - (x + xx), line_height, get_date(save_date))
  end

  # Ottiene il testo della data del salvataggio
  def get_date(save_date)
    day = save_date.mday
    month = save_date.mon
    year = save_date.year
    hour = save_date.hour
    min = save_date.min
    pre_text = "%d/%d/%d - %d:%d"
    sprintf(pre_text, day, month, year, hour, min)
  end

  # Mostra il tempo di gioco
  def draw_play_time(x, y)
    change_color system_color
    draw_text(x, y, contents_width - x, line_height, Vocab.play_time)
    change_color normal_color
    xx = x + contents.text_size(Vocab.play_time).width
    draw_text(xx, y, contents_width - xx, line_height, @play_time)
  end

  # Disegna l'oro del giocatore
  def draw_gold(x, y)
    change_color system_color
    draw_text(x, y, contents_width - x, line_height, Vocab.gold)
    change_color normal_color
    xx = contents.text_size(Vocab.gold).width
    draw_text(xx, y, contents_width - x - xx, line_height, @gold)
  end

  # Mostra la posizione del giocatore
  def draw_location(x, y)
    draw_text(x, y, contents_width, line_height, @map_name)
  end

  # Mostra la percentuale della storia
  def draw_story(x, y)
    st = (@story.to_f / CPanel::MAX_STORY * 100).to_i
    draw_text(x, y, contents_width, line_height, sprintf(Vocab.story, st), 2)
  end

  # Disegna le informazioni dell'eroe
  def draw_character_info(actor, x, y)
    draw_face(actor[0], actor[1], x, y, 96)
    draw_hp_bar(actor, x, y + 90)
    draw_level(actor, x + 2, y + 2)
  end

  # Disegna la barra degli HP
  def draw_hp_bar(actor, x, y)
    contents.fill_rect(x, y, 94, 6, Color.new(0, 0, 0))
    contents.fill_rect(x + 1, y + 1, 92, 4, gauge_back_color)
    w = [actor[3].to_f / actor[4] * 92.0, 92].min
    contents.gradient_fill_rect(x + 1, y + 1, w, 4, hp_gauge_color1, hp_gauge_color2)
  end

  # Disengna il livello
  def draw_level(actor, x, y)
    change_color system_color
    back_g = back_level
    contents.blt(x, y + 5, back_g, back_g.rect)
    draw_text(x, y, 90, line_height, Vocab.level_a)
    change_color normal_color
    xx = x + contents.text_size(Vocab.level_a).width
    draw_text(xx, y, 90, line_height, actor[2])
  end

  def back_level
    bitmap = Bitmap.new(70, line_height - 10)
    color1 = gauge_back_color
    color2 = gauge_back_color.deopacize(0)
    bitmap.gradient_fill_rect(0, 5, 70, line_height - 10, color1, color2)
    bitmap
  end

  # Disegna il testo delle missioni completate
  def draw_missions(x, y)
    change_color normal_color
    draw_text(x, y, contents_width - 4, line_height, header[:missions], 2)
    xx = contents.text_size(header[:missions]).width + 1
    change_color system_color
    draw_text(x, y, contents_width - xx - 4, line_height, Vocab.missions, 2)
  end
end