require File.expand_path('rm_vx_data')

class RPG::UsableItem < RPG::BaseItem
  def has_bomb?
    self.note.split(/[\r\n]+/).each { |riga|
      return true if riga =~
end

class Skill_Bomb
  attr_reader :actor
  attr_reader :skill
  attr_reader :turns
  
  def initialize(actor, skill, turns = 2)
    @actor = actor
    @skill = skill
    @turns = turns  
  end
  
  def icon_index
    @skill.icon_index
  end
  
  def scale_turn
    @turns -= 1
  end
end

class Game_Battler
  def bombs
    @bombs = [] unless @bombs
    @bombs
  end
  
  def add_bomb(actor, bomb)
    bombs.add(Skill_Bomb.new(actor.safe_clone, bomb, skill.bomb_turns))
  end 
end

class Scene_Battle < Scene_Base
  def init_bombs
    
  end
end