module Vocab
  def self.change_avatar
    'Cambia Avatar'
  end

  def self.change_title
    'Cambia Titolo'
  end

  def self.gift_code
    'Inserisci codice regalo'
  end

  def self.command_gift_code
    'Codici regalo'
  end

  def self.messages
    'Messaggi'
  end

  def self.follows
    'Giocatori seguiti'
  end

  def self.followers
    'I tuoi fan'
  end

  def self.command_online_dashboard
    'Online'
  end

  def self.command_register
    'Registrati'
  end

  def self.online_info_help
    "In questa schermata puoi gestire il tuo profilo online.|I progressi di gioco vengono inviati ed aggiornati quando salvi."
  end

  def self.online_notifications_help
    "Ci sono messaggi per te."
  end

  def self.support
    'Supporto'
  end

  def self.support_help
    "Puoi ottenere supporto andando su %s\noppure scrivendo a %s.\nPuoi anche mandarmi un messaggio sulla pagina di Facebook!"
  end
end

module Sound
  def self.play_gift_code
    RPG::SE.new('Chime2').play
  end
end


#noinspection RubyYardReturnMatch
class Scene_OnlinePlayer < Scene_MenuBase
  def start
    super
    get_player_data
    create_player_window
    create_help_window
    create_command_window
    create_dashboard_window
    create_titles_window
    create_gifts_windows
    create_avatar_window
    create_notifications_window
    create_friends_windows
    reset_help
    @dialog_window.back_opacity = 255
  end

  # crea le finestre necessarie al sistema dei regali
  def create_gifts_windows
    create_gift_code_window
    create_gift_code_input_window
  end

  # crea le finestre necessarie al sistema degli amici
  def create_friends_windows
    create_follow_command_window
    create_follows_window
    create_player_search_window
    create_friend_player_window
    create_friend_command_window
  end

  # crea la finestra d'aiuto
  def create_help_window
    super
    @help_window.y = @player_window.bottom_corner
  end

  # scarica le informazioni sul giocatore attuale
  def get_player_data
    Online.login unless Online.logged_in?
    @player = Online_Player.get($game_system.player_id)
  end

  # restituisce il giocatore attuale
  # @return [Online_Player]
  def current_player
    @player
  end

  # crea il contenitore dei titoli sbloccati dal giocatore
  def create_titles_window
    y = Graphics.width
    width = Graphics.width
    height = Graphics.height - @help_window.bottom_corner
    @titles_window = Window_PlayerTitles.new(0, y, width, height)
    @titles_window.visible = false
    @titles_window.help_window = @help_window
    @titles_window.set_handler(:ok, method(:title_confirmation))
    @titles_window.set_handler(:cancel, method(:reset_main_windows))
    @titles_window.deactivate
  end

  # crea il contenitore degli avatar sbloccati dal giocatore
  def create_avatar_window
    y = Graphics.width
    width = Graphics.width
    @avatar_window = Window_AvatarList.new(0, y, width, 3)
    @avatar_window.visible = false
    @avatar_window.set_handler(:ok, method(:avatar_confirmation))
    @avatar_window.set_handler(:cancel, method(:reset_main_windows))
    @avatar_window.deactivate
  end

  # crea il menu principale
  def create_command_window
    @command_window = Window_PlayerCommand.new(0, @help_window.bottom_corner)
    @command_window.set_handler(:title, method(:command_title))
    @command_window.set_handler(:avatar, method(:command_avatar))
    @command_window.set_handler(:gift_code, method(:command_giftcode))
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:messages, method(:command_messages))
    @command_window.set_handler(:support, method(:command_support))
    @command_window.set_handler(:follows, method(:command_follows))
    @command_window.set_handler(:followers, method(:command_followers))
    @command_window.activate
    @command_window.index = 0
  end

  # crea la finestra del giocatore
  def create_player_window
    @player_window = Window_PlayerInfo.new(0, 0, Graphics.width)
    @player_window.player = @player
  end

  # crea la finestra di input del codice regalo
  def create_gift_code_input_window
    params = {:upcase => true, :permitted => Text_Inputable::ALPHA_WITH_SPACING,
              :max_characters => 20, :placeholder => 'XXXX-XXXX-XXXX',
              :title => Vocab.gift_code}
    @gift_input_window = Window_SingleLineInput.new(0, 0, params)
    @gift_input_window.center_window
    @gift_input_window.openness = 0
    @gift_input_window.set_done_handler(method(:send_code))
    @gift_input_window.set_cancel_handler(method(:cancel_code))
    @gift_input_window.deactivate
  end

  # crea la finestra che mostra le ricompense del codice regalo
  def create_gift_code_window
    @gift_code_window = Window_GiftCode.new
    @gift_code_window.openness = 0
    @gift_code_window.set_handler(:ok, method(:accept_code))
    @gift_code_window.set_handler(:cancel, method(:reset_main_windows))
    @gift_code_window.set_handler(:claimed, method(:rewards_claimed))
    @gift_code_window.deactivate
  end

  # crea la finestra che mostra le informazioni sull'online (stato, eventi ecc...)
  def create_dashboard_window
    x = @command_window.right_corner
    y = @help_window.bottom_corner
    width = Graphics.width - x
    height = Graphics.height - y
    @dashboard_window = Window_OnlineDashboard.new(x, y, width, height)
    @dashboard_window.set_player @player
  end

  # crea la finestra che mostra i pulsanti da premere sulla finestra degli amici
  def create_follow_command_window
    @follows_help_window = Window_FollowHelp.new(Graphics.height)
    @follows_help_window.visible = false
  end

  # crea la finestra degli amici
  def create_follows_window
    y = @player_window.height
    height = Graphics.height - y - @follows_help_window.height
    @follows_window = Window_Follows.new(Graphics.width, y, Graphics.width, height)
    @follows_window.visible = false
    @follows_window.x = Graphics.width
    @follows_window.set_handler(:cancel, method(:reset_main_windows))
    @follows_window.set_handler(:ok, method(:command_open_player))
    @follows_window.info_window = @follows_help_window
    @follows_window.deactivate
    @follows_data = nil
    @followers_data = nil
  end

  # crea la finestra di input nome giocatore per cercarlo
  def create_player_search_window
    params = {:max_characters => Settings::MAX_NICKNAME_LEN, :title => Vocab::Add_Follow_Player}
    @player_search_window = Window_SingleLineInput.new(0, 0, params)
    @player_search_window.center_window
    @player_search_window.y -= 100
    @player_search_window.openness = 0
    @player_search_window.set_done_handler(method(:search_player))
    @player_search_window.set_cancel_handler(method(:cancel_search))
    @player_search_window.deactivate
  end

  # crea la finestra del giocatore (diverso da quello attuale) per mostrare il giocatore cercato o selezionato dalla lista
  def create_friend_player_window
    @friend_window = Window_PlayerInfo.new(0, @player_window.height, Graphics.width)
    @friend_window.openness = 0
  end

  # crea la finestra del menu del giocatore amico
  def create_friend_command_window
    @friend_command_window = Window_FriendCommand.new(@friend_window.bottom_corner)
    @friend_command_window.openness = 0
    @friend_command_window.deactivate
    @friend_command_window.set_handler(:cancel, method(:command_close_friend))
    @friend_command_window.set_handler(:follow, method(:command_follow))
    @friend_command_window.set_handler(:unfollow, method(:command_unfollow))
    @friend_command_window.set_handler(:party, method(:command_party))
    @friend_command_window.set_handler(:achievements, method(:command_achievements))
  end

  # crea la finestra dei messaggi
  def create_notifications_window
    @notifications_downloaded = false
    @notifications_window = Window_NotificationMessages.new(0, Graphics.height, Graphics.width, Graphics.height - @help_window.height)
    @notifications_window.visible = false
    @notifications_window.set_handler(:cancel, method(:reset_main_windows))
    @notifications_window.deactivate
  end

  def create_message_window
    @message_window = Window_NotificationMessage.new(Graphics.width, 0, Graphics.width, Graphics.height)
    @message_window.visible = false
  end

  def reset_main_windows
    @player_window.smooth_move(0, 0)
    @help_window.smooth_move(0, @player_window.height)
    @help_window.open
    @command_window.smooth_move(0, @command_window.y)
    @dashboard_window.smooth_move(@command_window.width, @dashboard_window.y)
    @avatar_window.smooth_move(@avatar_window.x, Graphics.height)
    @titles_window.smooth_move(@titles_window.x, Graphics.height)
    @notifications_window.smooth_move(0, Graphics.height)
    @follows_window.smooth_move(Graphics.width, @follows_window.y)
    @follows_help_window.smooth_move(0, Graphics.height)
    @follows_window.index = -1
    @gift_input_window.close
    @gift_code_window.close
    @command_window.activate
    reset_help
  end

  def reset_help
    @help_window.set_text(Vocab.online_info_help)
  end
  
  def hide_player_window
    @player_window.smooth_move(0, 0 - @player_window.height)
  end
  
  def show_player_window
    @player_window.smooth_move(0, 0)
  end

  def hide_main_windows(including_player = false)
    hide_player_window if including_player
    hide_help_window
    stash_command_window
    stash_dashboard_window
  end

  def hide_help_window
    @help_window.close
  end

  def stash_dashboard_window
    @dashboard_window.smooth_move(Graphics.width, @dashboard_window.y)
  end

  def stash_command_window
    @command_window.smooth_move(0 - @command_window.width, @command_window.y)
  end

  def command_avatar
    hide_main_windows
    @avatar_window.y = Graphics.height unless @avatar_window.visible
    @avatar_window.visible = true
    @avatar_window.index = current_player.avatar
    @avatar_window.smooth_move(@avatar_window.x, @player_window.height)
    @avatar_window.activate
  end

  def command_title
    stash_dashboard_window
    stash_command_window
    @titles_window.y = Graphics.height unless @titles_window.visible
    @titles_window.visible = true
    @titles_window.smooth_move(@titles_window.x, @help_window.bottom_corner)
    @titles_window.activate
    @titles_window.set_index(current_player.title_id)
  end

  def command_support
    hide_main_windows
    #noinspection RubyResolve
    text = sprintf(Vocab.support_help, 'www.overdriverpg.it', CPanel::SUPPORT_MAIL)
    show_dialog(text, method(:reset_main_windows), :info)
  end

  # apre la finestra dei giocatori seguiti
  def command_follows
    hide_main_windows
    @follows_help_window.visible = true
    @follows_window.visible = true
    @follows_help_window.change_enable(0, true)
    @follows_window.set_handler(:shift, method(:command_search_player))
    if follows_loaded?
      @follows_window.set_data @follows_data
      @follows_window.activate
      @follows_window.index = 0
    else
      await_server do
        @follows_data = Follow_Service.get_follows($game_system.player_id)
        @follows_window.set_data @follows_data
        @follows_window.index = 0
        @follows_window.activate
      end
    end
    @follows_window.smooth_move(0, @follows_window.y)
    @follows_help_window.smooth_move(0, Graphics.height - @follows_help_window.height)
  end

  # apre la finestra dei giocatori che ti seguono
  def command_followers
    hide_main_windows
    @follows_help_window.visible = true
    @follows_window.visible = true
    @follows_help_window.change_enable(0, false)
    @follows_window.delete_handler(:shift)
    if followers_loaded?
      @follows_window.set_data @followers_data, true
      @follows_window.activate
      @follows_window.index = 0
    else
      await_server do
        @followers_data = Follow_Service.get_followers($game_system.player_id)
        @follows_window.set_data @followers_data, true
        @follows_window.index = 0
        @follows_window.activate
      end
    end
    @follows_window.smooth_move(0, @follows_window.y)
    @follows_help_window.smooth_move(0, Graphics.height - @follows_help_window.height)
  end

  def command_follow
    friend_player = @friend_window.player
    response = Follow_Service.follow_player(friend_player.player_id)
    if response.success?
      @friend_command_window.set_follow(true)
      show_dialog(sprintf(Vocab::Follow_Success, friend_player.name), @friend_command_window, :success)
      @follows_data.push(friend_player)
      trigger_follow_update
    else
      Logger.error(response)
      show_dialog(response.failed_message, @friend_command_window, :error)
    end
  end

  def command_unfollow
    friend_player = @friend_window.player
    response = Follow_Service.unfollow_player(friend_player.player_id)
    if response.success?
      @friend_command_window.set_follow(false)
      show_dialog(sprintf(Vocab::Unfollow_Success, friend_player.name), @friend_command_window, :success)
      @follows_data.delete_if { |p| p.player_id == friend_player.player_id}
      trigger_follow_update
    else
      show_dialog(response.failed_message, @friend_command_window, :error)
    end
  end

  def command_party
    fail NotImplementedError
  end

  def command_achievements
    fail NotImplementedError
  end

  def command_close_friend
    @friend_command_window.close
    @friend_window.close
    @follows_window.open
    @follows_help_window.open
    @follows_window.activate
  end

  def cancel_search
    @player_search_window.close
    show_player_window
    @follows_window.open
    @follows_help_window.open
    @follows_window.activate
  end

  def command_giftcode
    hide_main_windows
    @gift_input_window.clear_text
    @gift_input_window.open
    @gift_input_window.activate
  end

  # apre un messaggio dall'elenco
  def command_open_message
    @notifications_window.smooth_move(0 - @notifications_window.width, @notifications_window.y)
    @help_window.smooth_move(0, 0 - @help_window.height)
    @message_window.set_notification(@notifications_window.item)
    @message_window.smooth_move(0, 0)
    @message_window.visible = true
  end

  # chiude il messaggio e torna all'elenco
  def command_close_message
    @notifications_window.smooth_move(0, @notifications_window.y)
    @help_window.smooth_move(0, 0)
    @message_window.smooth_move(Graphics.width, 0)
    @notifications_window.activate
  end

  # invia il codice regalo al server, controlla la validità e le ricompense
  def send_code
    @gift_input_window.close
    Online.login unless Online.logged_in?
    state = Gift_Code_Service.gift_code_state(@gift_input_window.text)
    if state == Gift_Code::AVAILABLE
      rewards = Gift_Code_Service.gift_code_rewards(@gift_input_window.text)
      @gift_code_window.set_rewards(rewards)
      @gift_code_window.open
      @gift_code_window.activate
    else
      Sound.play_buzzer
      show_dialog(Vocab.gift_code_error(state), method(:reset_main_windows), :warning)
    end
  end

  # annulla l'utilizzo del codice regalo
  def cancel_code
    @gift_input_window.close
    reset_main_windows
  end

  # utilizza il codice regalo
  def accept_code
    begin
      result = Gift_Code_Service.use_code(@gift_input_window.text)
      if result.success?
        $game_system.used_codes.push(@gift_input_window.text)
        Gift_Code_Service.distribute_rewards(@gift_code_window.rewards)
        @gift_code_window.start_claim
      else
        show_dialog(result.failed_message, method(:reset_main_windows), :error)
      end
    rescue => error
      Logger.error(error.message)
      show_dialog(Vocab.data_error, method(:reset_main_windows), :error)
    end
  end

  # mostra il messaggio che le ricompense sono state reclamate.
  def rewards_claimed
    @gift_code_window.close
    show_dialog(Vocab::Gift_Code_All_Claimed, method(:reset_main_windows))
  end

  # apre la finestra dei messaggi ricevuti.
  def command_messages
    @help_window.smooth_move(0, 0)
    @help_window.set_text(Vocab.online_notifications_help)
    @player_window.smooth_move(0, 0 - @player_window.height)
    stash_command_window
    stash_dashboard_window
    @command_window.delete_read_count
    unless @notifications_downloaded
      $game_system.download_online_notifications
      @notifications_downloaded = true
      @notifications_window.set_messages($game_system.saved_notifications)
      $game_system.set_all_read_notifications
    end
    @notifications_window.y = Graphics.height unless @notifications_window.visible
    @notifications_window.visible = true
    @notifications_window.smooth_move(0, @help_window.height)
    @notifications_window.activate
    @notifications_window.index = 0
  end

  # comando di selezione dell'avatar da modificare. Aggiorna l'avatar e torna al menu principale.
  def avatar_confirmation
    reset_main_windows
    if @avatar_window.index != current_player.avatar
      begin
        operation = Online.change_avatar(@avatar_window.index)
        if operation.success?
          current_player.avatar = @avatar_window.index
          $game_system.player_face = @avatar_window.index
          @player_window.refresh
        else
          @command_window.deactivate
          show_dialog(operation.failed_message, @command_window)
        end
      rescue => error
        Logger.error error.message
        @command_window.deactivate
        show_dialog(Vocab.data_error, @command_window)
      end
    end
  end

  # comando di selezione del titolo da modificare. Aggiorna il titolo e torna al menu principale
  def title_confirmation
    reset_main_windows
    if @titles_window.title != current_player.title
      begin
        title_id = @titles_window.title.nil? ? nil : @titles_window.title.id
        operation = Online.change_title title_id
        if operation.success?
          current_player.title_id = @titles_window.title.id
          @player_window.refresh
        else
          @command_window.deactivate
          show_dialog(operation.failed_message, @command_window)
        end
      rescue => error
        Logger.error error.message
        @command_window.deactivate
        show_dialog(Vocab.data_error, @command_window)
      end
    end
  end

  # comando di selezione del giocatore dall'elenco
  def command_open_player
    open_player @follows_window.item
  end

  # apre la finestra di ricerca del giocatore
  def command_search_player
    hide_player_window
    @follows_window.close
    @follows_help_window.close
    @player_search_window.open
    @player_search_window.activate
  end

  # avvia la ricerca del giocatore ed apre la finestra, se trovato
  def search_player
      player_found = Online_Player.find_by_name(@player_search_window.text)
      if player_found.nil?
        show_dialog(Vocab::Player_Not_Found, @player_search_window, :error)
      elsif player_found.player_id == $game_system.player_id
        show_dialog(Vocab::Player_Same, @player_search_window, :error)
      elsif @follows_data.map { |player| player.player_id }.include?(player_found.player_id)
        show_dialog(sprintf(Vocab::Player_Already_Followed, player_found.name), @player_search_window, :warning)
      else
        @player_search_window.close
        show_player_window
        open_player(player_found)
      end
  end

  # @param [Online_Player] player
  def open_player(player)
    @follows_window.close
    @follows_help_window.close
    @friend_window.player = player
    @friend_window.open
    @friend_command_window.set_follow following_player_id?(player.player_id)
    @friend_command_window.open
    @friend_command_window.activate
  end

  # determina se i giocatori seguiti sono stati scaricati dal server
  def follows_loaded?
    @follows_data != nil
  end

  # determina se l'elenco dei giocatori che ti seguono è stato caricato
  def followers_loaded?
    @followers_data != nil
  end

  # determina se stai seguendo un determinato giocatore
  def following_player_id?(player_id)
    return false unless follows_loaded?
    @follows_data.map { |follows| follows.player_id == player_id }.any?
  end

  def trigger_follow_update
    @follows_window.set_data(@follows_data) unless @follows_window.following
  end
end

class Window_PlayerCommand < Window_Command

  def initialize(x, y)
    get_unread_count
    super
  end

  def window_width
    200
  end

  def get_unread_count
    @unread = $game_system.unread_count
  end

  def make_command_list
    add_command(Vocab.messages, :messages, has_messages?, :message_n)
    add_command(Vocab.change_avatar, :avatar, can?)
    add_command(Vocab.change_title, :title, can?)
    add_command(Vocab.follows, :follows, can?)
    add_command(Vocab.followers, :followers, can?)
    add_command(Vocab.command_gift_code, :gift_code, can?)
    add_command(Vocab.support, :support)
    #add_command(Vocab.cancel, :cancel)
  end

  def can?
    !$game_system.user_banned?
  end

  def has_messages?
    $game_system.saved_notifications.size > 0 or Notification_Service.has_unread_notifications?
  end

  def draw_item(index)
    super
    rect = item_rect_for_text(index)
    draw_new_messages(rect) if @list[index][:ext] == :message_n
  end

  # @param [Rect] rect
  def draw_new_messages(rect)
    return if @unread == 0
    change_color(crisis_color)
    draw_text(rect, sprintf('(%d)', @unread), 2)
  end

  def delete_read_count
    @unread = 0
    refresh
  end
end

class Window_MenuCommand < Window_Command
  alias h87_online_original_cmds add_original_commands unless $@
  def add_original_commands
    h87_online_original_cmds
    if Online.enabled?
      if $game_system.user_registered?
        new_messages = $game_system.unread_notifications?
        enabled = (Online.logged_in? or $game_system.user_banned?)
        add_command(Vocab.command_online_dashboard, :online, enabled, new_messages ? :new : nil)
      else
        add_command(Vocab.command_register, :register)
      end
    end
  end
end
