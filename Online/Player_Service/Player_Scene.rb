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
    create_gift_code_window
    create_gift_code_input_window
    create_avatar_window
    create_notifications_window
    reset_help
    @dialog_window.back_opacity = 255
  end

  def create_help_window
    super
    @help_window.y = @player_window.bottom_corner
  end

  def get_player_data
    Online.login unless Online.logged_in?
    @player = Online_Player.get($game_system.player_id)
  end

  # @return [Online_Player]
  def current_player
    @player
  end

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

  def create_avatar_window
    y = Graphics.width
    width = Graphics.width
    @avatar_window = Window_AvatarList.new(0, y, width, 3)
    @avatar_window.visible = false
    @avatar_window.set_handler(:ok, method(:avatar_confirmation))
    @avatar_window.set_handler(:cancel, method(:reset_main_windows))
    @avatar_window.deactivate
  end

  def create_command_window
    @command_window = Window_PlayerCommand.new(0, @help_window.bottom_corner)
    @command_window.set_handler(:title, method(:command_title))
    @command_window.set_handler(:avatar, method(:command_avatar))
    @command_window.set_handler(:gift_code, method(:command_giftcode))
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:messages, method(:command_messages))
    @command_window.set_handler(:support, method(:command_support))
    @command_window.activate
    @command_window.index = 0
  end

  def create_player_window
    @player_window = Window_PlayerInfo.new(0, 0, Graphics.width)
    @player_window.player = @player
  end

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

  def create_gift_code_window
    @gift_code_window = Window_GiftCode.new
    @gift_code_window.openness = 0
    @gift_code_window.set_handler(:ok, method(:accept_code))
    @gift_code_window.set_handler(:cancel, method(:reset_main_windows))
    @gift_code_window.set_handler(:claimed, method(:rewards_claimed))
    @gift_code_window.deactivate
  end

  def create_dashboard_window
    x = @command_window.right_corner
    y = @help_window.bottom_corner
    width = Graphics.width - x
    height = Graphics.height - y
    @dashboard_window = Window_OnlineDashboard.new(x, y, width, height)
    @dashboard_window.set_player @player
  end

  def create_notifications_window
    @notifications_downloaded = false
    @notifications_window = Window_NotificationMessages.new(0, Graphics.height, Graphics.width, Graphics.height - @help_window.height)
    @notifications_window.visible = false
    @notifications_window.set_handler(:cancel, method(:reset_main_windows))
    @notifications_window.deactivate
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
    @gift_input_window.close
    @gift_code_window.close
    @command_window.activate
    reset_help
  end

  def reset_help
    @help_window.set_text(Vocab.online_info_help)
  end

  def hide_main_windows
    #@player_window.smooth_move(0, 0 - @player_window.height)
    #@help_window.smooth_move(0, 0)
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

  def command_giftcode
    hide_main_windows
    @gift_input_window.clear_text
    @gift_input_window.open
    @gift_input_window.activate
  end

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

  def cancel_code
    @gift_input_window.close
    reset_main_windows
  end

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

  def rewards_claimed
    @gift_code_window.close
    show_dialog(Vocab::Gift_Code_All_Claimed, method(:reset_main_windows))
  end

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
    add_command(Vocab.command_gift_code, :gift_code, can?)
    add_command(Vocab.support, :support)
    add_command(Vocab.cancel, :cancel)
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
