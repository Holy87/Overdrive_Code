require 'rm_vx_data'

class Game_Actor < Game_Battler

  def description
    return @custom_desc if @custom_desc
    actor.description
  end

  def set_description(new_descr)
    @custom_desc = new_descr
  end

  def reset_description
    @custom_desc = nil
  end
end