require 'rm_vx_data'

class Window_BestiaryCategory < Window_Command
  def make_command_list
    @categories.each{|key, info| add_command(get_command_name(info), key)}
  end

  def get_command_name(info)
    if info[:sw] and !$game_switches[info[:sw]]
      '????'
    else
      info[:name]
    end
  end
end