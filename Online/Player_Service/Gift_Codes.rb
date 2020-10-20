module Vocab
  Gift_Code_Help = 'Inserisci qui il codice'
  Gift_Code_Rewards = 'Contenuto del pacchetto:'
  Gift_Code_Expired = "Questo codice è scaduto."
  Gift_Code_Used = "Questo codice è già stato usato."
  Gift_Code_Not_Found = "Questo codice non è disponibile."
  Gift_Code_Valid = "Questo codice è valido."
  Gift_Code_Error = 'Errore nella verifica del codice'
  Gift_Code_Use = 'Usa il codice'
  Gift_Code_Cancel = 'Annulla'
  Gift_Code_Warning = "Otterrai le ricompense solo su questo salvataggio.\nSei sicuro di voler continuare?"
  Gift_Code_Reclamed = "RISCATTATO"
  Gift_Code_All_Claimed = "Hai ottenuto tutte le ricompense!"

  def self.gift_code_error(error_code)
    {
        Gift_Code::NOT_EXIST => Gift_Code_Not_Found,
        Gift_Code::ERROR => Gift_Code_Error,
        Gift_Code::USED => Gift_Code_Used,
        Gift_Code::EXPIRED => Gift_Code_Expired
    }[error_code]
  end
end

module Gift_Code_Service
  # @param [String] code
  def self.gift_code_state(code)
    begin
      response = Online.get :giftcode, :state, {:code => code}
      response.body.to_i
    rescue
      Logger.error($!.message)
      -1
    end
  end

  # @param [String] code
  def self.gift_code_rewards(code)
    params = {:code => code}
    begin
      response = Online.get :giftcode, :rewards, params
      Gift_Code.get_rewards(JSON.decode(response.body)['rewards'])
    rescue
      Logger.error($!.message)
      []
    end
  end

  # @param [String] code
  # @return [Online::Operation_Result]
  def self.use_code(code)
    params = {:code => code}
    Online.upload :giftcode, :apply, params
  end

  # @param [Array] rewards
  def self.distribute_rewards(rewards)
    rewards.each do |reward|
      n = reward[1].to_i
      item = reward[0]
      case item
      when :gold
        $game_party.gain_gold(n)
      when :ap
        $game_party.all_members.each { |member| member.earn_jp(n) }
      when :title
        $game_system.unlock_title(n)
      when RPG::Weapon, RPG::Armor, RPG::Item
        $game_party.gain_item(item, n)
      end
    end
  end
end

class Gift_Code
  AVAILABLE = 0
  NOT_EXIST = 100
  USED = 102
  EXPIRED = 103
  ERROR = -1

  # @param [String] rewards_data
  def self.get_rewards(rewards_data)
    rewards_data.split(',').collect{|data| reward(data)}
  end

  private

  # @param [String] data
  # @return [Array<Symbol or Fixnum>, nil]
  def self.reward(data)
    datas = {
        'i' => $data_items,
        'w' => $data_weapons,
        'a' => $data_armors
    }
    case data
    when /([iwa])(\d+)/i
      [datas[$1][$2.to_i], 1]
    when /([iwa])(\d+)x(\d+)/i
      [datas[$1][$2.to_i], $3.to_i]
    when /(\d+)g/i
      [:gold, $1.to_i]
    when /t(\d+)/i
      [:title, $1.to_i]
    when /(\d+)ap/i
      [:ap, $1.to_i]
    else
      nil
    end
  end
end

class Window_GiftCode < Window_Selectable
  def initialize
    @claim = false
    super(0, 0, 500, fitting_height(9))
    center_window
  end

  def set_rewards(rewards)
    @rewards = rewards
    @index = -1
    @claim = false
    @claim_index = 0
    @claim_timing = 0
    refresh
  end

  # @return [Array<Array>]
  def rewards
    @rewards
  end

  def item_max
    0
  end

  def update
    super
    update_claim
  end

  def update_claim
    return unless @claim
    @claim_timing -= 1
    return if @claim_timing > 0
    if @claim_index < @rewards.size
      Sound.play_gift_code
      change_color knockout_color
      draw_text(reward_rect(@claim_index), Vocab::Gift_Code_Reclamed, 1)
      @claim_index += 1
      @claim_timing = 15
    else
      finish_claim
    end
  end

  def start_claim
    @claim_index = 0
    @claim_timing = 0
    @claim = true
  end

  def finish_claim
    @claim = false
    call_handler(:claimed)
  end

  def refresh
    contents.clear
    change_color power_up_color
    draw_text(0, 0, contents_width, line_height, Vocab::Gift_Code_Valid, 1)
    change_color normal_color
    draw_text(0, line_height, contents_width, line_height, Vocab::Gift_Code_Rewards, 1)
    draw_underline(0)
    draw_rewards
    draw_help_commands
  end

  def draw_rewards
    rewards.each_with_index do |reward, index|
      draw_reward(reward, reward_rect(index))
    end
  end

  def reward_rect(index)
    x = (index % 2) * (contents_width / 2)
    y = index / 2 * line_height + line_height * 2
    Rect.new(x, y, contents_width / 2, line_height)
  end

  # @param [Array] reward
  # @param [Rect] rect
  def draw_reward(reward, rect)
    return if reward.nil?
    rect.width -= 4
    draw_bg_srect(rect.x, rect.y, rect.width, rect.height)
    change_color normal_color
    case reward[0]
    when :gold
      draw_text(rect, sprintf('%d %s', reward[1], Vocab.currency_unit))
    when :ap
      draw_text(rect, sprintf('%d %s', reward[1], Vocab.jp))
    when :title
      draw_text(rect, sprintf('%s: %s', Vocab.player_title, Player_Titles.get_title(reward[1]).name))
    else
      draw_item_name(reward[0], rect.x, rect.y, true, rect.width)
      draw_text(rect, sprintf('x%d', reward[1]), 2)
    end
  end

  def draw_help_commands
    draw_text_ex(0, contents_height - line_height * 3, sprintf("\\C[2]%s",Vocab::Gift_Code_Warning))
    change_color normal_color
    y = contents_height - line_height
    draw_key_icon(:C, 0, y)
    draw_text(24, y, contents_width, line_height, Vocab::Gift_Code_Use)
    x = contents_width / 2
    draw_key_icon(:B, x, y)
    draw_text(24 + x, y, contents_width, line_height, Vocab::Gift_Code_Cancel)
  end

end

class Game_System
  def used_codes
    @used_gift_codes ||= []
  end
end