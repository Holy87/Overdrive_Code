module Follow_Settings
  # pulsante per cambiare ordine dell'elenco amici
  SORT_MODE_KEY = :X
  # pulsante per aggiungere un nuovo follow
  ADD_FOLLOW_KEY = :A
  # Metodi di ordinamento
  ORDER_BY = [:name, :online, :level]
end

module Vocab
  Follow_Info = "Dettagli"
  Follow_Sort = "Ordina per"
  Follow_Search = "Cerca..."
  Follow_Sort_Per = {
    :name => 'nome',
    :level => 'livello',
    :online => 'ultimo accesso'
  }
  Add_Follow_Player = "Nome giocatore da aggiungere..."
  Player_Not_Found = "Nessun giocatore trovato con questo nome."
  Player_Already_Followed = "Segui già %s."
  Player_Same = "Non puoi seguire te stesso!"
  Follow_Player = "Segui"
  Unfollow_Player = "Smetti di seguire"
  View_Party = "Party attuale"
  View_Achievements = "Obiettivi sbloccati"
  Follow_Success = "Ora segui %s!"
  Unfollow_Success = "Non segui più %s."
  Empty_Friends = "La lista è vuota."
end

module Follow_Service
  # segue un giocatore
  # @param [Integer] player_id
  # @return [Online::Operation_Result]
  def self.follow_player(player_id)
    return unless $game_system.can_upload?
    params = {:player_id => player_id}
    Online.upload :player, :follow, params
  end

  # smetti di seguire un giocatore
  # @param [Integer] player_id
  # @return [Online::Operation_Result]
  def self.unfollow_player(player_id)
    return unless $game_system.can_upload?
    params = {:player_id => player_id}
    Online.upload :player, :unfollow, params
  end

  # scarica i giocatori seguiti dall'ID giocatore
  # @return [Array<Online_Player>]
  def self.get_follows(player_id)
    begin
      response = Online.get :player, :following, {:player_id => player_id}
    rescue => error
      Logger.error(error.message)
      return []
    end
    response.decode_json.map{|data| Online_Player.new(data)}
  end

  # scarica l'elenco dei giocatori che seguono il player_id
  # @return [Array<Online_Player>]
  def self.get_followers(player_id)
    begin
      response = Online.get :player, :followers, {:player_id => player_id}
    rescue => error
      Logger.error(error.message)
      return []
    end
    response.decode_json.map{|data| Online_Player.new(data)}
  end
end

class Window_Follows < Window_Selectable
  include Follow_Settings
  attr_accessor :info_window
  attr_reader :following

  def initialize(x, y, width, height)
    super
    @order_by = 0
    @info_window = nil
    #make_item_list
    #refresh
  end

  def col_max
    1
  end

  def deep_refresh
    apply_sort
    create_contents
    refresh
  end

  def set_data(data, following = false)
    return if data == @data
    @data = data
    @following = following
    deep_refresh
  end

  # disabilitato - carica la prima volta che accede ai follow
  def make_item_list
    @data = Follow_Service.get_follows($game_system.player_id)
    apply_sort
  end

  def item_max
    @data ? @data.size : 0
  end

  # @return [Online_Player]
  def item(index = @index)
    @data[index]
  end

  def current_item_enabled?
    item != nil
  end

  def empty_text
    Vocab::Empty_Friends
  end

  def draw_item(index)
    rect = item_rect_for_text(index)
    player = item(index)
    draw_icon(last_online_icon(player),  rect.x, rect.y)
    draw_inline_avatar(player.avatar, rect.x + ICON_WIDTH, rect.y)
    rect.width -= (ICON_WIDTH + LFACE_WIDTH)
    rect.x += ICON_WIDTH + LFACE_WIDTH
    change_color normal_color
    text = player.title.empty? ? player.name : player.name + ' - '
    draw_text(rect, text)
    unless player.title.empty?
      change_color title_color(player.title.type)
      rect.x += text_width(text)
      rect.width -= text_width(text)
      draw_text(rect, player.title.name)
    end
    change_color system_color
    draw_text(rect, sprintf('%s %d', Vocab::level_a, player.level), 2)
  end

  def process_handling
    super
    return unless open? && active
    process_change_order if Input.trigger?(SORT_MODE_KEY)
  end

  def process_change_order
    Sound.play_load
    change_order_mode
  end

  def change_order_mode
    @order_by += 1
    @order_by = 0 if @order_by >= ORDER_BY.size
    apply_sort
    update_info_window
    refresh
  end

  def update_info_window
    @info_window.set_sort(next_sort_mode) if @info_window
  end

  # @return [Symbol]
  def sort_mode
    ORDER_BY[@order_by]
  end

  # restituisce il prossimo tipo di ordinamento
  # @return [Symbol]
  def next_sort_mode
    ORDER_BY[@order_by + 1] || ORDER_BY[0]
  end

  def apply_sort
    case sort_mode
    when :name
      @data = @data.sort_by{|player| player.name}
    when :online
      @data = @data.sort_by{|player| player.days_from_last_online}
    when :level
      @data = @data.sort_by{|player| player.level}.reverse
    else
      @data
    end
  end

  # restituisce l'icona dello stato online a seconda dei giorni dell'ultima partita
  # @param [Online_Player] player
  def last_online_icon(player)
    return 1307 if player.hours_from_last_online <= 24
    return 1308 if player.days_from_last_online <= 7
    return 1309 if player.days_from_last_online <= 30
    1310
  end

end

class Window_FollowHelp < Window_KeyHelp
  def initialize(y)
    super(2, y)
    #set_command(0, Key_Command_Container.new([:C], Vocab::Follow_Info))
    set_command(0, Key_Command_Container.new([Follow_Settings::ADD_FOLLOW_KEY], Vocab::Follow_Search))
    set_sort(Follow_Settings::ORDER_BY[1])
  end

  def set_sort(sort)
    text = sprintf('%s %s', Vocab::Follow_Sort, Vocab::Follow_Sort_Per[sort])
    set_command(1, Key_Command_Container.new([Follow_Settings::SORT_MODE_KEY], text))
  end
end

class Window_FriendCommand < Window_Command
  def initialize(y)
    super(0, y)
    deactivate
    @following = false
    @openness = 0
  end

  def set_follow(following)
    return if @following == following
    @following = following
    refresh
  end

  def window_width
    200
  end

  def make_command_list
    add_command(Vocab::View_Party, :party, false)
    add_command(Vocab::View_Achievements, :achievements, false)
    if @following
      add_command(Vocab::Unfollow_Player, :unfollow)
    else
      add_command(Vocab::Follow_Player, :follow)
    end
  end
end